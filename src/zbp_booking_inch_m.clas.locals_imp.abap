CLASS lhc__booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Suppl FOR NUMBERING
      IMPORTING entities FOR CREATE _Booking\_Suppl.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR _Booking RESULT result.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
       keys FOR _booking~calculatetotalprice.

ENDCLASS.

CLASS lhc__booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Suppl.

    DATA: lv_max_number TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
    ENTITY _Booking
    BY \_Suppl
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_linked_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>)
                               GROUP BY <lfs_entities>-BookingId.


      lv_max_number = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                 FOR ls_linked IN lt_linked_data
                                            WHERE ( source-BookingId = <lfs_entities>-BookingId  )
                                 NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_linked-target-BookingSupplementId
                                                                                THEN ls_linked-target-BookingSupplementId
                                                                                ELSE lv_max
                                                                              ) ).

      lv_max_number = REDUCE #( INIT lv_max = lv_max_number
                                FOR ls_entities IN entities
                                         FOR ls_target IN ls_entities-%target
                                                      WHERE ( BookingId = <lfs_entities>-BookingId )
                                         NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_target-BookingSupplementId
                                                                                        THEN ls_target-BookingSupplementId
                                                                                        ELSE lv_max
                                                                                      ) ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_assign_suppl>)
                                 GROUP BY <lfs_assign_suppl>-BookingId.

        LOOP AT <lfs_assign_suppl>-%target ASSIGNING FIELD-SYMBOL(<lfs_target>).

          lv_max_number += 10.
          APPEND CORRESPONDING #( <lfs_target> ) TO mapped-_suppl ASSIGNING FIELD-SYMBOL(<lfs_mapped>).
          <lfs_mapped>-BookingSupplementId = lv_max_number.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    BY \_Booking
    FIELDS ( BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                        (
                          %tky = ls_result-%tky
                          %features-%assoc-_Suppl = COND #( WHEN ls_result-%data-BookingStatus = 'X'
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled
                                                          )
                         )
                     ).

  ENDMETHOD.

  METHOD calculateTotalPrice.

*     data: lt_travel type standard table of zi_travel_root_inch with unique hashed key key components travelId.
*
*     lt_travel = corresponding #( keys discarding duplicates mapping TravelId = travelid ).

     read entities of zi_travel_root_inch in local mode
     entity _Booking by \_Travel
     from corresponding #( keys )
     result data(lt_travel).

     modify entity in LOCAL mode zi_travel_root_inch
     execute CalcTotPrice
     from value #( for travel in lt_travel ( %tky = travel-%tky ) ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

