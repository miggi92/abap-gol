*&---------------------------------------------------------------------*
*& Report zgol_runner
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgol_runner.

PARAMETERS p_cols TYPE i DEFAULT 30.
PARAMETERS p_rows TYPE i DEFAULT 15.


DATA go_controller TYPE REF TO zcl_gol_controller.

START-OF-SELECTION.
  go_controller = NEW zcl_gol_controller( iv_cols = p_cols
                                          iv_rows = p_rows ).

  go_controller->start_game( ).
