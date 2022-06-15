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
    mo_instance = NEW #( i_cols = 5
                         i_rows = 5 ).
  	ENDMETHOD.

  METHOD teardown.
    CLEAR: mo_instance.
  	ENDMETHOD.



  METHOD create_grid.
    DATA:
            lo_table TYPE REF TO data.
    FIELD-SYMBOLS:
    <lt_table> TYPE table.

    lo_table = mo_instance->get_grid_table( ).
    cl_aunit_assert=>assert_bound(
        act     = lo_table                 " Reference Variable to Be Checked
    ).

  ENDMETHOD.

  METHOD row_number.
    DATA:
                lo_table TYPE REF TO data.

    FIELD-SYMBOLS:
    <lt_table> TYPE table.

    lo_table = mo_instance->get_grid_table( ).
    cl_aunit_assert=>assert_bound(
        act     = lo_table                 " Reference Variable to Be Checked
        quit    = cl_aunit_assert=>no           " Flow Control in Case of Error
    ).

    ASSIGN lo_table->* TO <lt_table>.

    " checking row number
    cl_aunit_assert=>assert_equals(
        exp     = 5                 " Data Object with Expected Type
        act     = lines( <lt_table> )                 " Data Object with Current Value
    ).
  ENDMETHOD.

  METHOD col_number.
    DATA:
      lo_table      TYPE REF TO data,
      lo_rtti_table TYPE REF TO cl_abap_tabledescr,
      lo_structure  TYPE REF TO cl_abap_structdescr.

    FIELD-SYMBOLS:
    <lt_table> TYPE table.

    lo_table = mo_instance->get_grid_table( ).
    cl_aunit_assert=>assert_bound(
        act     = lo_table                 " Reference Variable to Be Checked
        quit    = cl_aunit_assert=>no           " Flow Control in Case of Error
    ).

    lo_rtti_table ?= cl_abap_tabledescr=>describe_by_data_ref( lo_table ).
    lo_structure ?= lo_rtti_table->get_table_line_type( ).
    DATA(lt_components) = lo_structure->get_components( ).


    " checking col number
    cl_aunit_assert=>assert_equals(
        exp     = 5                 " Data Object with Expected Type
        act     = lines( lt_components )                 " Data Object with Current Value
    ).
  ENDMETHOD.

ENDCLASS.
