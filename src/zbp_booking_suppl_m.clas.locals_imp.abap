CLASS lhc__Suppl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR _Suppl~calculateTotalPrice.

ENDCLASS.

CLASS lhc__Suppl IMPLEMENTATION.

  METHOD calculateTotalPrice.

    DATA: lt_travel TYPE STANDARD TABLE OF zi_travel_root_inch WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    lt_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId  ).

    MODIFY ENTITY IN LOCAL MODE zi_travel_root_inch
    EXECUTE CalcTotPrice
    FROM CORRESPONDING #( lt_travel ).


  ENDMETHOD.

ENDCLASS.
