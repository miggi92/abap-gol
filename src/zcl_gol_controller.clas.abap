"! <p class="shorttext synchronized">Game of life controller</p>
CLASS zcl_gol_controller DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor.

    "! <p class="shorttext synchronized">Start game</p>
    "!
    METHODS start_game.

    METHODS next_gen.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_grid TYPE REF TO zcl_gol_grid.
    DATA mo_alv  TYPE REF TO zcl_gol_alv.
ENDCLASS.


CLASS zcl_gol_controller IMPLEMENTATION.
  METHOD constructor.
    mo_grid = NEW zcl_gol_grid( iv_cols = 10
                                iv_rows = 10 ).
    mo_alv = NEW zcl_gol_alv( mo_grid->get_grid_table( ) ).
  ENDMETHOD.

  METHOD start_game.
    mo_alv->display( ).
  ENDMETHOD.

  METHOD next_gen.
    mo_alv->display( ).
  ENDMETHOD.
ENDCLASS.
