"! <p class="shorttext synchronized" lang="en">Game of life grid</p>
CLASS zcl_gol_grid DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Constructor</p>
      "!
      "! @parameter iv_rows | <p class="shorttext synchronized" lang="en">Number of rows for the grid</p>
      "! @parameter iv_cols | <p class="shorttext synchronized" lang="en">Number of columns for the grid</p>
      constructor
        IMPORTING
          iv_rows TYPE i
          iv_cols TYPE i,
      "! <p class="shorttext synchronized" lang="en">Get generated grid</p>
      "!
      "! @parameter ro_grid_table | <p class="shorttext synchronized" lang="en">Grid table</p>
      get_grid_table
        RETURNING
          VALUE(ro_grid_table) TYPE REF TO data.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_rows       TYPE i,
          mv_cols       TYPE i,
          mo_grid_table TYPE REF TO data.

    METHODS:
      "! <p class="shorttext synchronized" lang="en">Build grid</p>
      "!
      build_grid.
ENDCLASS.



CLASS zcl_gol_grid IMPLEMENTATION.

  METHOD constructor.
    mv_rows = iv_rows.
    mv_cols = iv_cols.
  ENDMETHOD.

  METHOD build_grid.
    DATA: lt_structure_components TYPE abap_component_tab,
          lo_structure            TYPE REF TO cl_abap_structdescr,
          lo_table                TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS:
    <lt_grid> TYPE table,
    <ls_struct_comp> LIKE LINE OF lt_structure_components.

    DO mv_cols TIMES.
      APPEND INITIAL LINE TO lt_structure_components ASSIGNING <ls_struct_comp>.
      <ls_struct_comp>-name = |COL_{ sy-index }|.
      <ls_struct_comp>-type ?= cl_abap_typedescr=>describe_by_data( abap_true ).
    ENDDO.

    lo_structure ?= cl_abap_structdescr=>create( lt_structure_components ).
    lo_table     ?= cl_abap_tabledescr=>create( lo_structure ).

    CREATE DATA mo_grid_table TYPE HANDLE lo_table.
    ASSIGN mo_grid_table->* TO <lt_grid>.

    DO mv_rows TIMES.
      APPEND INITIAL LINE TO <lt_grid>.
    ENDDO.
  ENDMETHOD.

  METHOD get_grid_table.
    IF mo_grid_table IS NOT BOUND.
      build_grid( ).
    ENDIF.
    ro_grid_table = mo_grid_table.
  ENDMETHOD.

ENDCLASS.

