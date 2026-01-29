"! <p class="shorttext synchronized">Game of life ALV</p>
CLASS zcl_gol_alv DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    EVENTS next_generation_requested.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter io_table | <p class="shorttext synchronized">Table</p>
    METHODS constructor
      IMPORTING io_table TYPE REF TO data.

    "! <p class="shorttext synchronized">Display</p>
    "!
    METHODS display.

    "! <p class="shorttext synchronized">Get alv object</p>
    "!
    "! @parameter ro_salv | <p class="shorttext synchronized">ALV Object</p>
    METHODS get_alv_object
      RETURNING VALUE(ro_salv) TYPE REF TO cl_salv_table.

    "! <p class="shorttext synchronized">Handle user command</p>
    "!
    "! @parameter e_salv_function | <p class="shorttext synchronized">Usercommand</p>
    METHODS handle_user_command FOR EVENT added_function OF cl_salv_events_table
      IMPORTING e_salv_function.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_salv  TYPE REF TO cl_salv_table.
    DATA mo_table TYPE REF TO data.

    "! <p class="shorttext synchronized">Set row colors</p>
    "!
    METHODS set_row_colors.

ENDCLASS.


CLASS zcl_gol_alv IMPLEMENTATION.
  METHOD constructor.
    mo_table = io_table.
  ENDMETHOD.

  METHOD display.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.

    TRY.
        ASSIGN mo_table->* TO <lt_data>.

        set_row_colors( ).

        IF mo_salv IS INITIAL.
          cl_salv_table=>factory( IMPORTING r_salv_table = mo_salv
                                  CHANGING  t_table      = <lt_data> ).

          mo_salv->get_columns( )->set_color_column( value = zif_gol_constants=>gc_color_col ).
          mo_salv->get_functions( )->set_all( abap_false ).
          mo_salv->set_screen_status( report        = 'ZGOL_RUNNER'
                                      pfstatus      = 'ZPFSTATUS'
                                      set_functions = cl_salv_table=>c_functions_all ).

          SET HANDLER handle_user_command FOR mo_salv->get_event( ).
          mo_salv->display( ).
        ELSE.
          mo_salv->refresh( ).
        ENDIF.
      CATCH cx_salv_msg
            cx_salv_data_error
            cx_salv_existing
            cx_salv_wrong_call.
        " handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD set_row_colors.
    FIELD-SYMBOLS <lt_data>  TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_color> TYPE lvc_t_scol.
    DATA lo_table     TYPE REF TO cl_abap_tabledescr.
    DATA lo_structure TYPE REF TO cl_abap_structdescr.

    ASSIGN mo_table->* TO <lt_data>.

    lo_table ?= cl_abap_tabledescr=>describe_by_data( <lt_data> ).
    lo_structure ?= lo_table->get_table_line_type( ).
    DATA(lt_components) = lo_structure->get_components( ).
    DELETE lt_components WHERE name = zif_gol_constants=>gc_color_col.

    LOOP AT <lt_data> ASSIGNING FIELD-SYMBOL(<ls_row>).
      ASSIGN COMPONENT zif_gol_constants=>gc_color_col OF STRUCTURE <ls_row> TO FIELD-SYMBOL(<lo_color>).
      ASSIGN <lo_color> TO <lt_color>.

      CLEAR <lt_color>.

      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<ls_col>).
        ASSIGN COMPONENT <ls_col>-name OF STRUCTURE <ls_row> TO FIELD-SYMBOL(<lv_value>).
        IF <lv_value> = abap_true.
          APPEND VALUE #( fname     = <ls_col>-name
                          color-col = col_positive
                          color-int = 0
                          color-inv = 0 ) TO <lt_color>.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_alv_object.
    ro_salv = mo_salv.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_salv_function.
      WHEN 'NEXT_GEN'.
        RAISE EVENT next_generation_requested.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
