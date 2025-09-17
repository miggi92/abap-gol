*"* use this source file for your ABAP unit test classes
CLASS ltcl_gol_grid DEFINITION DEFERRED.

CLASS ltcl_gol_grid DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: mo_instance TYPE REF TO zcl_gol_grid.

    METHODS:
      setup,
      teardown,
      create_grid FOR TESTING,
      row_number FOR TESTING,
      col_number FOR TESTING.
ENDCLASS.


CLASS ltcl_gol_grid IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT mo_instance
      EXPORTING
        iv_cols = 5
        iv_rows = 5.
  ENDMETHOD.

  METHOD teardown.
    CLEAR: mo_instance.
  ENDMETHOD.



  METHOD create_grid.
    DATA:
      lo_table TYPE REF TO data.
    lo_table = mo_instance->get_grid_table( ).
    cl_abap_unit_assert=>assert_bound( act = lo_table ).

  ENDMETHOD.

  METHOD row_number.
    DATA:
      lo_table TYPE REF TO data.

    FIELD-SYMBOLS:
    <lt_table> TYPE table.

    lo_table = mo_instance->get_grid_table( ).
    cl_abap_unit_assert=>assert_bound(
        act     = lo_table                 " Reference Variable to Be Checked
        quit    = if_aunit_constants=>no ).

    ASSIGN lo_table->* TO <lt_table>.

    " checking row number
    cl_abap_unit_assert=>assert_equals(
        exp     = 5                 " Data Object with Expected Type
        act     = lines( <lt_table> ) ).
  ENDMETHOD.

  METHOD col_number.
    DATA:
      lo_table      TYPE REF TO data,
      lo_rtti_table TYPE REF TO cl_abap_tabledescr,
      lo_structure  TYPE REF TO cl_abap_structdescr,
      lt_components TYPE abap_component_tab.

    lo_table = mo_instance->get_grid_table( ).
    cl_abap_unit_assert=>assert_bound(
        act     = lo_table                 " Reference Variable to Be Checked
        quit    = if_aunit_constants=>no ).

    lo_rtti_table ?= cl_abap_tabledescr=>describe_by_data_ref( lo_table ).
    lo_structure  ?= lo_rtti_table->get_table_line_type( ).
    lt_components = lo_structure->get_components( ).


    " checking col number
    cl_abap_unit_assert=>assert_equals(
        exp     = 5                 " Data Object with Expected Type
        act     = lines( lt_components ) ).
  ENDMETHOD.

ENDCLASS.
