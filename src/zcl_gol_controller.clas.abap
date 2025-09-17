"! <p class="shorttext synchronized">Game of life controller</p>
CLASS zcl_gol_controller DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor.

    METHODS start_game.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_grid TYPE REF TO zcl_gol_grid.
ENDCLASS.


CLASS zcl_gol_controller IMPLEMENTATION.
  METHOD constructor.
  ENDMETHOD.

  METHOD start_game.
  ENDMETHOD.
ENDCLASS.
