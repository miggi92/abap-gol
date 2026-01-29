"! <p class="shorttext synchronized">Cell</p>
CLASS zcl_gol_cell DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_x_coord | <p class="shorttext synchronized">X coordinate</p>
    "! @parameter iv_y_coord | <p class="shorttext synchronized">Y coordinate</p>
    METHODS constructor
      IMPORTING iv_x_coord TYPE i
                iv_y_coord TYPE i.

    "! <p class="shorttext synchronized">Check if cell is alive</p>
    "!
    "! @parameter rv_is_alive | <p class="shorttext synchronized">Is alive?</p>
    METHODS is_alive
      RETURNING VALUE(rv_is_alive) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mv_x_coord  TYPE i.
    DATA mv_y_coord  TYPE i.
    DATA mv_is_alive TYPE abap_bool.
ENDCLASS.


CLASS zcl_gol_cell IMPLEMENTATION.
  METHOD is_alive.
    rv_is_alive = mv_is_alive.
  ENDMETHOD.

  METHOD constructor.
    mv_x_coord  = iv_x_coord.
    mv_y_coord  = iv_y_coord.
    mv_is_alive = abap_false.
  ENDMETHOD.
ENDCLASS.
