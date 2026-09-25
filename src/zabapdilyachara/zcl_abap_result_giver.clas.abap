CLASS zcl_abap_result_giver DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_ABAP_RESULT_GIVER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF lty_data,
             matnr TYPE matnr,
             werks TYPE werks_d,
           END OF lty_data.

    DATA: lt_table TYPE lty_data,
          lr_data  TYPE REF TO data.


    lt_table-matnr = '10203'.
    lt_table-werks = '2094'.

    lr_data = REF #( lt_table ).

    DATA obj TYPE REF TO zcl_abap_pointer.
    CREATE OBJECT obj.

    obj->resulter(
    EXPORTING
     in1 = lr_data
    IMPORTING
     in2 = FINAL(newInchara)
    ).

    out->write( | newInchara->* | ).
  ENDMETHOD.
ENDCLASS.
