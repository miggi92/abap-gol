*"* use this source file for your ABAP unit tests
CLASS lcl_test_gol DEFINITION DEFERRED.
CLASS zcl_gol_controller DEFINITION LOCAL FRIENDS lcl_test_gol.

CLASS lcl_test_gol DEFINITION
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    TYPES: BEGIN OF mty_coord,
             row TYPE i,
             col TYPE i,
           END OF mty_coord.
    TYPES mtt_coords TYPE STANDARD TABLE OF mty_coord WITH EMPTY KEY.

    DATA mo_cut TYPE REF TO zcl_gol_controller. " Class Under Test

    METHODS setup.

    METHODS init_pattern
      IMPORTING it_coords TYPE mtt_coords.

    METHODS assert_row_pattern
      IMPORTING iv_row     TYPE i
                iv_pattern TYPE string.

    METHODS test_blinker_step   FOR TESTING.
    METHODS test_loneliness     FOR TESTING.
    METHODS test_overpopulation FOR TESTING. " Mehr als 3 Nachbarn -> Tod
    METHODS test_birth          FOR TESTING. " Exakt 3 Nachbarn -> Leben
ENDCLASS.


CLASS lcl_test_gol IMPLEMENTATION.
  METHOD setup.
    " Initialisierung vor jedem Testlauf
    mo_cut = NEW #( iv_cols = 3
                    iv_rows = 3 ).
  ENDMETHOD.

  METHOD init_pattern.
    LOOP AT it_coords ASSIGNING FIELD-SYMBOL(<ls_coord>).
      mo_cut->set_cell_value( iv_row   = <ls_coord>-row
                              iv_col   = <ls_coord>-col
                              iv_value = abap_true ).
    ENDLOOP.
  ENDMETHOD.

  METHOD assert_row_pattern.
    DATA(lv_len) = strlen( iv_pattern ).
    DO lv_len TIMES.
      DATA(lv_offset) = sy-index - 1.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(lv_char) = substring( val = iv_pattern
                                 off = lv_offset
                                 len = 1 ).

      DATA(lv_is_alive) = mo_cut->get_cell_state( iv_row = iv_row
                                                  iv_col = sy-index ).

      IF lv_is_alive = abap_true.
        cl_abap_unit_assert=>assert_true( act = lv_is_alive
                                          msg = |Zeile { iv_row }, Spalte { sy-index } sollte LEBEN| ).
      ELSE.
        cl_abap_unit_assert=>assert_false( act = lv_is_alive
                                           msg = |Zeile { iv_row }, Spalte { sy-index } sollte TOT sein| ).
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD test_loneliness.
    " Szenario: Eine einzelne Zelle stirbt an Einsamkeit
    " 1. Setup: Ein Grid mit nur einer lebenden Zelle (X)
    " . . .
    " . X .
    " . . .
    init_pattern( VALUE #( ( row = 2 col = 2 ) ) ).

    " 2. Aktion: Nächste Generation berechnen
    mo_cut->next_gen( ).

    " 3. Assert: Die Zelle muss nun tot sein
    cl_abap_unit_assert=>assert_false( mo_cut->get_cell_state( iv_row = 2
                                                               iv_col = 2 ) ).
  ENDMETHOD.

  METHOD test_blinker_step.
    " Szenario: Ein 'Blinker' (3 Zellen in einer Reihe)
    " Wird in der nächsten Gen zu einer vertikalen Reihe
    " [ ] [X] [ ]      [ ] [ ] [ ]
    " [ ] [X] [ ]  ->  [X] [X] [X]
    " [ ] [X] [ ]      [ ] [ ] [ ]

    " 1. Grid vorbereiten
    init_pattern( VALUE #( col = 2
                           ( row = 1 )
                           ( row = 2 )
                           ( row = 3 ) ) ).

    " 2. next gen
    mo_cut->next_gen( ).
    " 3. Prüfen ob die neuen Koordinaten stimmen
    assert_row_pattern( iv_row     = 1
                        iv_pattern = '...' ).
    assert_row_pattern( iv_row     = 2
                        iv_pattern = 'XXX' ).
    assert_row_pattern( iv_row     = 3
                        iv_pattern = '...' ).
  ENDMETHOD.

  METHOD test_overpopulation.
    " Szenario: Eine Zelle mit 4 Nachbarn stirbt
    " X X X     . . .
    " X X .  -> . . .
    " . . .     . . .

    " 1. Grid vorbereiten
    init_pattern( VALUE #( ( col = 1 row = 1 )
                           ( col = 2 row = 1 )
                           ( col = 3 row = 1 )
                           ( col = 1 row = 2 )
                           ( col = 2 row = 2 ) ) ).

    mo_cut->next_gen( ).

    " 3. Prüfen ob die neuen Koordinaten stimmen
    assert_row_pattern( iv_row     = 1
                        iv_pattern = '...' ).
    assert_row_pattern( iv_row     = 2
                        iv_pattern = '...' ).
    assert_row_pattern( iv_row     = 3
                        iv_pattern = '...' ).
  ENDMETHOD.

  METHOD test_birth.
    " Szenario: Eine tote Zelle mit exakt 3 Nachbarn wird lebendig
    " X X .     . . .
    " X . .  -> . X . (Die Mitte wird geboren)
    " . . .     . . .

    " 1. Grid vorbereiten
    init_pattern( VALUE #( ( col = 1 row = 1 )
                           ( col = 2 row = 1 )
                           ( col = 1 row = 2 ) ) ).

    mo_cut->next_gen( ).

    " 3. Prüfen ob die neuen Koordinaten stimmen
    assert_row_pattern( iv_row     = 1
                        iv_pattern = '...' ).
    assert_row_pattern( iv_row     = 2
                        iv_pattern = '.X.' ).
    assert_row_pattern( iv_row     = 3
                        iv_pattern = '...' ).
  ENDMETHOD.
ENDCLASS.
