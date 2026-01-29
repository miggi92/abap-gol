"! <p class="shorttext synchronized">Game of life grid</p>
CLASS zcl_gol_grid DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_rows | <p class="shorttext synchronized">Number of rows for the grid</p>
    "! @parameter iv_cols | <p class="shorttext synchronized">Number of columns for the grid</p>
    METHODS constructor
      IMPORTING iv_rows TYPE i
                iv_cols TYPE i.

    "! <p class="shorttext synchronized">Get generated grid</p>
    "!
    "! @parameter ro_grid_table | <p class="shorttext synchronized">Grid table</p>
    METHODS get_grid_table
      RETURNING VALUE(ro_grid_table) TYPE REF TO data.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mv_rows       TYPE i.
    DATA mv_cols       TYPE i.
    DATA mo_grid_table TYPE REF TO data.

    "! <p class="shorttext synchronized">Build grid</p>
    "!
    METHODS build_grid.
ENDCLASS.


CLASS zcl_gol_grid IMPLEMENTATION.
  METHOD constructor.
    mv_rows = iv_rows.
    mv_cols = iv_cols.
  ENDMETHOD.

  METHOD build_grid.
    DATA lt_structure_components TYPE abap_component_tab.
    DATA lo_structure            TYPE REF TO cl_abap_structdescr.
    DATA lo_table                TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS <lt_grid>        TYPE table.
    FIELD-SYMBOLS <ls_struct_comp> LIKE LINE OF lt_structure_components.

    DO mv_cols TIMES.
      APPEND INITIAL LINE TO lt_structure_components ASSIGNING <ls_struct_comp>.
      <ls_struct_comp>-name  = |COL_{ sy-index }|.
      <ls_struct_comp>-type ?= cl_abap_typedescr=>describe_by_data( abap_true ).
    ENDDO.

    APPEND INITIAL LINE TO lt_structure_components ASSIGNING <ls_struct_comp>.
    <ls_struct_comp>-name  = zif_gol_constants=>gc_color_col.
    <ls_struct_comp>-type ?= cl_abap_typedescr=>describe_by_name( 'LVC_T_SCOL' ).

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
