CLASS zcl_abap_pointer DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: resulter IMPORTING in1 TYPE REF TO data
                     EXPORTING in2 type ref to data.
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_ABAP_POINTER IMPLEMENTATION.


  METHOD resulter.

    FIELD-SYMBOLS: <p_field> TYPE any.

    ASSIGN in1->* TO <p_field>.
    IF sy-subrc = 0.
      in2 = <p_field>.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
