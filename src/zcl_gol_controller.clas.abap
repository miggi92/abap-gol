"! <p class="shorttext synchronized">Game of life controller</p>
CLASS zcl_gol_controller DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_cols TYPE i DEFAULT 10
                iv_rows TYPE i DEFAULT 10.

    "! <p class="shorttext synchronized">Start game</p>
    "!
    METHODS start_game.

    "! <p class="shorttext synchronized">Display next generation</p>
    "!
    METHODS next_gen.

    METHODS on_next_generation FOR EVENT next_generation_requested OF zcl_gol_alv.

    METHODS set_cell_value
      IMPORTING iv_row   TYPE i
                iv_col   TYPE i
                iv_value TYPE abap_bool.

    METHODS get_cell_state
      IMPORTING iv_row          TYPE i
                iv_col          TYPE i
      RETURNING VALUE(rv_value) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_grid  TYPE REF TO zcl_gol_grid.
    DATA mo_alv   TYPE REF TO zcl_gol_alv.
    DATA mo_table TYPE REF TO data.
    DATA mt_cells TYPE zif_gol_types=>gty_cells.

    METHODS init_table.
ENDCLASS.


CLASS zcl_gol_controller IMPLEMENTATION.
  METHOD constructor.
    mo_grid = NEW zcl_gol_grid( iv_cols = iv_cols
                                iv_rows = iv_rows ).
    mo_table = mo_grid->get_grid_table( ).

    mo_alv = NEW zcl_gol_alv( mo_table ).
    SET HANDLER on_next_generation FOR mo_alv.
  ENDMETHOD.

  METHOD start_game.
    init_table( ).
    mo_alv->display( ).
  ENDMETHOD.

  METHOD next_gen.
    FIELD-SYMBOLS <lt_old_gen> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_new_gen> TYPE STANDARD TABLE.
    DATA lo_table     TYPE REF TO cl_abap_tabledescr.
    DATA lo_structure TYPE REF TO cl_abap_structdescr.
    DATA lo_new_gen   TYPE REF TO data.

    ASSIGN mo_table->* TO <lt_old_gen>.

    CREATE DATA lo_new_gen LIKE <lt_old_gen>.
    ASSIGN lo_new_gen->* TO <lt_new_gen>.
    <lt_new_gen> = <lt_old_gen>.

    lo_table ?= cl_abap_tabledescr=>describe_by_data( <lt_old_gen> ).
    lo_structure ?= lo_table->get_table_line_type( ).
    DATA(lt_components) = lo_structure->get_components( ).
    DELETE lt_components WHERE name = zif_gol_constants=>gc_color_col.

    DATA(lv_max_rows) = lines( <lt_old_gen> ).
    DATA(lv_max_cols) = lines( lt_components ).

    LOOP AT <lt_new_gen> ASSIGNING FIELD-SYMBOL(<ls_row_new>).
      DATA(lv_row_idx) = sy-tabix.

      " Performance: Zeilen-Pointer für Old Gen VORHER setzen
      " Das spart uns tausende Lesezugriffe in der inneren Schleife.
*      UNASSIGN: <ls_row_top>, <ls_row_mid>, <ls_row_bot>.

      " Pointer auf die alte Version dieser Zeile
      ASSIGN <lt_old_gen>[ lv_row_idx ] TO FIELD-SYMBOL(<ls_row_mid>).

      " Pointer auf obere Zeile (falls nicht erste Zeile)
      IF lv_row_idx > 1.
        ASSIGN <lt_old_gen>[ lv_row_idx - 1 ] TO FIELD-SYMBOL(<ls_row_top>).
      ENDIF.

      " Pointer auf untere Zeile (falls nicht letzte Zeile)
      IF lv_row_idx < lv_max_rows.
        ASSIGN <lt_old_gen>[ lv_row_idx + 1 ] TO FIELD-SYMBOL(<ls_row_bot>).
      ENDIF.

      " -------------------------------------------------------
      " Innere Schleife: Spalten (X-Achse)
      " -------------------------------------------------------
      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<ls_comp>).
        DATA(lv_col_idx) = sy-tabix.
        DATA(lv_neighbors) = 0.

        " Namen der Nachbar-Komponenten ermitteln (Links / Rechts)
        " Wir nehmen an, dass lt_comps sortiert ist (COL_1, COL_2...)
        DATA(lv_col_name_left)  = VALUE string( ).
        DATA(lv_col_name_right) = VALUE string( ).

        IF lv_col_idx > 1.
          lv_col_name_left = lt_components[ lv_col_idx - 1 ]-name.
        ENDIF.
        IF lv_col_idx < lv_max_cols.
          lv_col_name_right = lt_components[ lv_col_idx + 1 ]-name.
        ENDIF.

        " === Nachbarn zählen ===

        " 1. Obere Zeile prüfen
        IF <ls_row_top> IS ASSIGNED.
          " Oben Mitte
          ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_row_top> TO FIELD-SYMBOL(<lv_n>).
          IF <lv_n> = abap_true.
            lv_neighbors = lv_neighbors + 1.
          ENDIF.

          " Oben Links
          IF lv_col_name_left IS NOT INITIAL.
            ASSIGN COMPONENT lv_col_name_left OF STRUCTURE <ls_row_top> TO <lv_n>.
            IF <lv_n> = abap_true.
              lv_neighbors = lv_neighbors + 1.
            ENDIF.
          ENDIF.

          " Oben Rechts
          IF lv_col_name_right IS NOT INITIAL.
            ASSIGN COMPONENT lv_col_name_right OF STRUCTURE <ls_row_top> TO <lv_n>.
            IF <lv_n> = abap_true.
              lv_neighbors = lv_neighbors + 1.
            ENDIF.
          ENDIF.
        ENDIF.

        " 2. Untere Zeile prüfen
        IF <ls_row_bot> IS ASSIGNED.
          " Unten Mitte
          ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_row_bot> TO <lv_n>.
          IF <lv_n> = abap_true.
            lv_neighbors = lv_neighbors + 1.
          ENDIF.

          " Unten Links
          IF lv_col_name_left IS NOT INITIAL.
            ASSIGN COMPONENT lv_col_name_left OF STRUCTURE <ls_row_bot> TO <lv_n>.
            IF <lv_n> = abap_true.
              lv_neighbors = lv_neighbors + 1.
            ENDIF.
          ENDIF.

          " Unten Rechts
          IF lv_col_name_right IS NOT INITIAL.
            ASSIGN COMPONENT lv_col_name_right OF STRUCTURE <ls_row_bot> TO <lv_n>.
            IF <lv_n> = abap_true.
              lv_neighbors = lv_neighbors + 1.
            ENDIF.
          ENDIF.
        ENDIF.

        " 3. Gleiche Zeile (Links / Rechts)
        " Links
        IF lv_col_name_left IS NOT INITIAL.
          ASSIGN COMPONENT lv_col_name_left OF STRUCTURE <ls_row_mid> TO <lv_n>.
          IF <lv_n> = abap_true.
            lv_neighbors = lv_neighbors + 1.
          ENDIF.
        ENDIF.
        " Rechts
        IF lv_col_name_right IS NOT INITIAL.
          ASSIGN COMPONENT lv_col_name_right OF STRUCTURE <ls_row_mid> TO <lv_n>.
          IF <lv_n> = abap_true.
            lv_neighbors = lv_neighbors + 1.
          ENDIF.
        ENDIF.

        " === Regeln anwenden ===
        ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_row_mid> TO FIELD-SYMBOL(<lv_cell_old>).
        ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_row_new> TO FIELD-SYMBOL(<lv_cell_new>).

        IF <lv_cell_old> = abap_true.
          " Zelle lebt: Bleibt am Leben bei 2 oder 3 Nachbarn
          IF lv_neighbors = 2 OR lv_neighbors = 3.
            <lv_cell_new> = abap_true.
          ELSE.
            <lv_cell_new> = abap_false. " Unterbevölkerung oder Überbevölkerung
          ENDIF.
        ELSE.
          " Zelle tot: Wird geboren bei genau 3 Nachbarn
          IF lv_neighbors = 3.
            <lv_cell_new> = abap_true.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDLOOP.
    <lt_old_gen> = <lt_new_gen>.
  ENDMETHOD.

  METHOD init_table.
    set_cell_value( iv_row   = 2
                    iv_col   = 1
                    iv_value = abap_true ).
    set_cell_value( iv_row   = 2
                    iv_col   = 2
                    iv_value = abap_true ).
    set_cell_value( iv_row   = 2
                    iv_col   = 3
                    iv_value = abap_true ).
  ENDMETHOD.

  METHOD on_next_generation.
    next_gen( ).
    mo_alv->display( ).
  ENDMETHOD.

  METHOD set_cell_value.
    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.

    ASSIGN mo_table->* TO <lt_table>.
    ASSIGN <lt_table>[ iv_row ] TO FIELD-SYMBOL(<ls_row>).

    ASSIGN COMPONENT |COL_{ iv_col }| OF STRUCTURE <ls_row> TO FIELD-SYMBOL(<lv_cell>).
    <lv_cell> = iv_value.
  ENDMETHOD.

  METHOD get_cell_state.
    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.

    ASSIGN mo_table->* TO <lt_table>.
    ASSIGN <lt_table>[ iv_row ] TO FIELD-SYMBOL(<ls_row>).
    ASSIGN COMPONENT |COL_{ iv_col }| OF STRUCTURE <ls_row> TO FIELD-SYMBOL(<lv_cell>).
    rv_value = <lv_cell>.
  ENDMETHOD.
ENDCLASS.
