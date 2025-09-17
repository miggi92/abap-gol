*&---------------------------------------------------------------------*
*& Report zgol_runner
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgol_runner.


DATA go_controller TYPE REF TO zcl_gol_controller.

START-OF-SELECTION.
  go_controller = NEW zcl_gol_controller( ).
