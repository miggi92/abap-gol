"! <p class="shorttext synchronized">Cell</p>
CLASS zcl_gol_cell DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_x_coord TYPE i
                iv_y_coord TYPE i.

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
