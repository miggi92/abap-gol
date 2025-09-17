"! <p class="shorttext synchronized" lang="en">Game of life ALV</p>
CLASS zcl_gol_alv DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_salv  TYPE REF TO cl_salv_table,
          mo_table TYPE REF TO data.
ENDCLASS.



CLASS zcl_gol_alv IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

ENDCLASS.
