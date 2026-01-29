"! <p class="shorttext synchronized">Types</p>
INTERFACE zif_gol_types
  PUBLIC.

  TYPES:
    BEGIN OF gty_cell,
      x        TYPE i,
      y        TYPE i,
      instance TYPE REF TO zcl_gol_cell,
    END OF gty_cell.
  TYPES gty_cells TYPE STANDARD TABLE OF gty_cell WITH KEY x y.

ENDINTERFACE.
