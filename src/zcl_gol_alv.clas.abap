"! <p class="shorttext synchronized">Game of life ALV</p>
CLASS zcl_gol_alv DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING io_table TYPE REF TO data.

    METHODS display.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_salv  TYPE REF TO cl_salv_table.
    DATA mo_table TYPE REF TO data.

ENDCLASS.


CLASS zcl_gol_alv IMPLEMENTATION.
  METHOD constructor.
    mo_table = io_table.
  ENDMETHOD.

  METHOD display.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.

    TRY.
        ASSIGN mo_table->* TO <lt_data>.

        IF mo_salv IS INITIAL.
          cl_salv_table=>factory( IMPORTING r_salv_table = mo_salv
                                  CHANGING  t_table      = <lt_data> ).
          mo_salv->display( ).
        ELSE.
          mo_salv->refresh( ).
        ENDIF.
      CATCH cx_salv_msg.
        " handle exception
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
