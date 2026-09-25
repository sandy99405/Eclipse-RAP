CLASS lsc_zi_travel_root_inch DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_travel_root_inch IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_travel_log TYPE STANDARD TABLE OF ztab_travel_log.
    DATA: lt_travel_logc TYPE STANDARD TABLE OF ztab_travel_log.
    IF create-_travel IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( create-_travel ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<lfs_travel_log>).

        <lfs_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <lfs_travel_log>-chaged_at.

        READ TABLE create-_travel ASSIGNING FIELD-SYMBOL(<ls_travel>)
                                             WITH TABLE KEY entity
                                             COMPONENTS TravelId = <lfs_travel_log>-TravelId.
        IF sy-subrc = 0.
          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.

            <lfs_travel_log>-changed_field_name = 'Booking Fee'.
            <lfs_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <lfs_travel_log>-change_id     = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
            ENDTRY.
            APPEND <lfs_travel_log> TO lt_travel_logc.
          ENDIF.
          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.

            <lfs_travel_log>-changed_field_name = 'Overallstatus'.
            <lfs_travel_log>-changed_value      = <ls_travel>-OverallStatus.
            TRY.
                <lfs_travel_log>-change_id          = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.

            ENDTRY.

            APPEND <lfs_travel_log> TO lt_travel_logc.

          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDIF.

    IF update-_travel IS NOT INITIAL.
      lt_travel_log = CORRESPONDING #( update-_travel ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<lfs_travel_u_log>).
        <lfs_travel_u_log>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <lfs_travel_u_log>-chaged_at.

        READ TABLE update-_travel ASSIGNING FIELD-SYMBOL(<lfs_update_travel>)
                                                     WITH TABLE KEY entity
                                                     COMPONENTS TravelId = <lfs_travel_u_log>-travelid.

        IF <lfs_update_travel>-%control-CustomerId = cl_abap_behv=>flag_changed.

          <lfs_travel_u_log>-changed_field_name = 'customer_id'.
          <lfs_travel_u_log>-changed_value      = <lfs_update_travel>-CustomerId.
          TRY.
              <lfs_travel_u_log>-change_id          = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.

          ENDTRY.
          APPEND <lfs_travel_u_log> TO lt_travel_logc.
        ENDIF.
        IF <lfs_update_travel>-%control-Description = cl_abap_behv=>flag_changed.

          <lfs_travel_u_log>-changed_field_name = 'Description'.
          <lfs_travel_u_log>-changed_value      = <lfs_update_travel>-Description.
          TRY.
              <lfs_travel_u_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.

          ENDTRY.

          APPEND <lfs_travel_u_log> TO lt_travel_logc.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF delete-_travel IS NOT INITIAL.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR _Travel RESULT result.

*    METHODS newTotal FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR _Travel~newTotal.

    METHODS AcceptTravel FOR MODIFY
       keys FOR ACTION _Travel~AcceptTravel RESULT result.


    METHODS CopyTravel FOR MODIFY
       keys FOR ACTION _Travel~CopyTravel.

    METHODS RejectTravel FOR MODIFY
       keys FOR ACTION _Travel~RejectTravel RESULT result.


    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR _Travel RESULT result.


    METHODS validdate FOR VALIDATE ON SAVE
       keys FOR _travel~validdate.
    METHODS validoverallstatus FOR VALIDATE ON SAVE
       keys FOR _travel~validoverallstatus.

    METHODS validcust FOR VALIDATE ON SAVE
       keys FOR _travel~validcust.
    METHODS calctotprice FOR MODIFY
       keys FOR ACTION _travel~calctotprice.

    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
       keys FOR _travel~calculatetotalprice.



    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE _Travel\_Booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE _Travel.


ENDCLASS.

CLASS lhc__Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD earlynumbering_create.
*    DATA(lt_entities) = entities.
*
*    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
*
*
*    TRY.
*        cl_numberrange_runtime=>number_get(
*          EXPORTING
*          ignore_buffer     =
*            nr_range_nr       =   '01'
*            object            =   '/DMO/TRV_M'
*            quantity          =   CONV #( lines( lt_entities ) )
*          subobject         =
*          toyear            =
*          IMPORTING
*            number            =  DATA(lv_latest_num)
*            returncode        =  DATA(lv_code)
*            returned_quantity =  DATA(lv_qty)
*        ).
*      CATCH cx_nr_object_not_found.
*      CATCH cx_number_ranges INTO DATA(err).
*        LOOP AT lt_entities INTO DATA(ls_entities).
*
*          APPEND VALUE #( %cid = ls_entities-%cid
*                          %key = ls_entities-%key
*         ) TO failed-_travel.
*
*          APPEND VALUE #( %cid = ls_entities-%cid
*                          %key = ls_entities-%key
*                          %msg = err
*           ) TO reported-_travel.
*        ENDLOOP.
*        EXIT.
*    ENDTRY.
*
*    ASSERT lv_qty = lines( lt_entities ).
*
*    DATA: lt_entity_table TYPE TABLE FOR MAPPED EARLY zi_travel_root_inch,
*          ls_entity_table LIKE LINE OF lt_entity_table.
*
*    DATA(lv_curr_num) = lv_latest_num - lv_qty.
*
*    LOOP AT lt_entities INTO ls_entities.
*
*      lv_curr_num = lv_curr_num + 1.
*
*      ls_entity_table = VALUE #( %cid = ls_entities-%cid
*                                 travelid = lv_curr_num
*      ).
*
*      APPEND ls_entity_table TO mapped-_travel.
*    ENDLOOP.

    DATA: lv_max_travel TYPE /dmo/travel_id.

    SELECT travel_id FROM ztravel_incha_m INTO TABLE @DATA(lt_database_travel_ids).


    lv_max_travel = REDUCE /dmo/travel_id( INIT lv_max = CONV /dmo/travel_id( '0' )
                                           FOR ls_result IN lt_database_travel_ids
                                           NEXT lv_max = COND /dmo/travel_id( WHEN lv_max < ls_result-travel_id
                                                                              THEN ls_result-travel_id
                                                                              ELSE lv_max
                                                                             )
                                        ).

    lv_max_travel = REDUCE /dmo/travel_id( INIT lv_max = lv_max_travel
                                           FOR ls_entities IN entities
                                           NEXT lv_max = COND /dmo/travel_id( WHEN lv_max < ls_entities-TravelId
                                                                              THEN ls_entities-TravelId
                                                                              ELSE lv_max
                                                                             )
                                         ).


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_field>).

      lv_max_travel = lv_max_travel + 1.
      APPEND CORRESPONDING #( <lfs_field> ) TO mapped-_travel ASSIGNING FIELD-SYMBOL(<lfs_keys>).
      <lfs_keys>-TravelId = lv_max_travel.
      <lfs_keys>-%cid = <lfs_field>-%cid.

    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_num TYPE /dmo/booking_Id.

    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
       ENTITY _Travel
       BY \_booking
       FROM CORRESPONDING #( entities )
       LINK DATA(lt_linked_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_field>)
                                     GROUP BY <lfs_field>-TravelId.

      lv_max_num = REDUCE #( INIT lv_max = CONV  /dmo/booking_id( '0' )
                             FOR ls_link IN lt_linked_data USING KEY entity
                                            WHERE ( source-TravelId = <lfs_field>-TravelId )
                              NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                  THEN ls_link-target-BookingId
                                                                  ELSE lv_max )
                            ).

      lv_max_num = REDUCE #( INIT lv_max = lv_max_num
                             FOR ls_entity IN entities USING KEY entity
                                   WHERE ( TravelId = <lfs_field>-TravelId )
                                FOR ls_booking IN ls_entity-%target
                                NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-bookingId
                                                                    THEN ls_booking-bookingId
                                                                    ELSE lv_max
                                                                   )
                           ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                       WHERE travelId = <lfs_field>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          lv_max_num += 10.
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-_booking ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).

          <ls_new_map_book>-BookingId = lv_max_num.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.




*  METHOD newTotal.
*    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
*      ENTITY _TraveL
*      FIELDS ( bookingFee ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_result_tab).
*
*    LOOP AT lt_result_tab ASSIGNING FIELD-SYMBOL(<ls_result_tab>).
*      <ls_result_tab>-TotalPrice  = <ls_result_tab>-BookingFee + <ls_result_tab>-TotalPrice.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zi_travel_root_inch IN LOCAL MODE
*       ENTITY _Travel
*       UPDATE FIELDS ( TotalPrice )
*       WITH CORRESPONDING #( lt_result_tab ).
*  ENDMETHOD.


  METHOD AcceptTravel.

    MODIFY ENTITY zi_travel_root_inch
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'A'
                                       ) )
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).


    READ ENTITY zi_travel_root_inch
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    IF sy-subrc = 0.

      result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                     %param = ls_result
                                                    ) ).

    ENDIF.
  ENDMETHOD.

*  METHOD CalcTotPrice.
*
*    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
*    ENTITY _Travel
*    FIELDS ( BookingFee CurrencyCode )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_travel)
*    ENTITY _Booking
*    FIELDS ( FlightPrice CurrencyCode )
*    WITH CORRESPONDING #( lt_travel )
*    RESULT DATA(lt_booking)
*    ENTITY _Suppl
*    FIELDS ( Price CurrencyCode )
*    WITH CORRESPONDING #( lt_booking )
*    RESULT DATA(lt_suppl).
*
*    DATA lv_total_price TYPE /dmo/total_price.
*
*    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).
*
*      LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<lfs_booking>)
*                                                 WHERE TravelId = <lfs_travel>-TravelId.
*
*        LOOP AT lt_suppl ASSIGNING FIELD-SYMBOL(<lfs_suppl>)
*                                                WHERE BookingId = <lfs_booking>-BookingId.
*
*          lv_total_price = <lfs_travel>-BookingFee + <lfs_booking>-FlightPrice + <lfs_suppl>-Price.
*          APPEND VALUE #(  ) TO mapped-_travel.
*
*        ENDLOOP.
*
*      ENDLOOP.
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD CopyTravel.

    DATA: lt_create_travel  TYPE TABLE FOR CREATE zi_travel_root_inch,
          lt_create_booking TYPE TABLE FOR CREATE zi_travel_root_inch\_Booking,
          lt_create_suppl   TYPE TABLE FOR CREATE zi_booing_inch_m\_Suppl.


    READ TABLE keys ASSIGNING FIELD-SYMBOL(<lfs_keys>) WITH KEY %cid = ' '.
    ASSERT <lfs_keys> IS NOT ASSIGNED.


    READ ENTITY zi_travel_root_inch
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
    ENTITY _Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel )
    RESULT FINAL(lt_booking_r).

    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
    ENTITY _Booking
    BY \_Suppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT FINAL(lt_suppl_r).


    IF lt_travel IS NOT INITIAL.


      LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).

        APPEND INITIAL LINE TO lt_create_travel ASSIGNING FIELD-SYMBOL(<lfs_create_travel>).
        <lfs_create_travel>-%cid = keys[ KEY entity TravelId = <lfs_travel>-TravelId ]-%cid.
        <lfs_create_travel>-%data = CORRESPONDING #( <lfs_travel> EXCEPT TravelId ).

        APPEND VALUE #( %cid_ref = <lfs_create_travel>-%cid
                       ) TO lt_create_booking ASSIGNING FIELD-SYMBOL(<lfs_create_booking>).

        LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<lfs_booking_r>)
                                       WHERE TravelId = <lfs_travel>-TravelId.

          APPEND VALUE #( %cid = <lfs_create_travel>-%cid && <lfs_travel>-TravelId
                          %data = CORRESPONDING #( <lfs_booking_r> EXCEPT travelid )
                        ) TO <lfs_create_booking>-%target.

          APPEND VALUE #( %cid_ref = <lfs_create_travel>-%cid && <lfs_travel>-TravelId
                        ) TO lt_create_suppl ASSIGNING FIELD-SYMBOL(<lfs_create_suppl>).

          LOOP AT lt_suppl_r ASSIGNING FIELD-SYMBOL(<lfs_suppl_r>)
                                       WHERE TravelId = <lfs_travel>-TravelId
                                       AND  BookingId = <lfs_booking_r>-BookingId.

            APPEND VALUE #( %cid = <lfs_create_travel>-%cid && <lfs_travel>-TravelId && <lfs_booking_r>-TravelId
                            %data = CORRESPONDING #( <lfs_suppl_r> EXCEPT travelid )
                          ) TO <lfs_create_suppl>-%target.

          ENDLOOP.

        ENDLOOP.

      ENDLOOP.


      MODIFY ENTITIES OF zi_travel_root_inch IN LOCAL MODE
      ENTITY _Travel
      CREATE FROM CORRESPONDING #( lt_create_travel )
      ENTITY _Travel
      CREATE BY \_Booking
      FROM CORRESPONDING #( lt_create_booking )
      ENTITY _Booking
      CREATE BY \_Suppl
      FROM CORRESPONDING #( lt_create_suppl )
      REPORTED DATA(lt_reported_booking).



    ENDIF.

  ENDMETHOD.

  METHOD RejectTravel.

    MODIFY ENTITY zi_travel_root_inch
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky-TravelId = ls_keys-TravelId
                                          OverallStatus = 'X'
                                       ) )
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

    READ ENTITY zi_travel_root_inch
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    IF lt_failed IS NOT INITIAL.

    ELSE.
      result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                     %param = CORRESPONDING #( ls_result )
                                                     ) ).
    ENDIF.

  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                       (  %tky  = ls_result-%tky
                           %features-%action-AcceptTravel = COND #( WHEN ls_result-%data-OverallStatus = 'A'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled
                                                                   )
                           %features-%action-RejectTravel = COND #( WHEN ls_result-%data-OverallStatus = 'X'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled
                                                                    )
                           %features-%assoc-_Booking     = COND #( WHEN ls_result-%data-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled
                                                                  )
                       )
                    ).

  ENDMETHOD.




  METHOD validDate.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_result>).

      IF <lfs_result>-BeginDate > <lfs_result>-EndDate.

        APPEND VALUE #( %tky = <lfs_result>-%tky )
        TO failed-_travel.

        APPEND VALUE #( %tky = <lfs_result>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                  textid = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                  begin_date = <lfs_result>-BeginDate
                                  severity = if_abap_behv_message=>severity-error
                               )
                       %element-begindate = if_abap_behv=>mk-on )
        TO reported-_travel.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD ValidOverallStatus.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_result>).

      APPEND VALUE #( %tky = <lfs_result>-%tky ) TO failed-_travel.

      APPEND VALUE #(  %tky = <lfs_result>-%tky
                       %msg = NEW zcl_message_class(
                                 textid = zcl_message_class=>standard_message
                                 severity = if_abap_behv_message=>severity-error
                                 status = <lfs_result>-OverallStatus
                              )
                       %element-OverallStatus = if_abap_behv=>mk-on
                    ) TO reported-_travel.

    ENDLOOP.
  ENDMETHOD.


  METHOD validCust.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    FIELDS ( customerId )
    WITH CORRESPONDING  #( keys )
    RESULT DATA(lt_result).

    DATA: lt_temp TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_temp = CORRESPONDING #( lt_result DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_temp WHERE customer_id IS INITIAL.

    SELECT
      FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_temp
      WHERE customer_id = @lt_temp-Customer_Id
      INTO TABLE @DATA(lt_cust_db).

    IF sy-subrc = 0.

      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_result>).

        IF <lfs_result>-CustomerId IS INITIAL
         OR line_exists( lt_cust_db[ customer_id = <lfs_result>-CustomerId ] ).

          APPEND VALUE #( %tky = <lfs_result>-%tky )
           TO failed-_travel.

          APPEND VALUE #( %tky = <lfs_result>-%tky
                          %msg = NEW zcl_message_class(
                               textid = zcl_message_class=>customer_unkown
                               severity = if_abap_behv_message=>severity-error
                               customer_id = <lfs_result>-CustomerId
                            )
                          %element-customerid = <lfs_result>-CustomerId
                       )
           TO reported-_travel.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD CalcTotPrice.

    TYPES: BEGIN OF lty_tp,
             price TYPE /dmo/total_price,
             curr  TYPE /dmo/currency_code,
           END OF lty_tp.

    DATA: lt_tot_price  TYPE TABLE OF lty_tp,
          lv_conv_price TYPE /dmo/total_price,
          lv_calc_price TYPE /dmo/total_price,
          lv_old_price  TYPE /dmo/total_price,
          lt_travel_upd TYPE TABLE FOR UPDATE zi_travel_root_inch.


    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    FIELDS ( BookingFee CurrencyCode TotalPrice )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_res).

    IF lt_travel_res IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITY IN LOCAL MODE zi_travel_root_inch
    BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel_res )
    RESULT DATA(lt_book_res).

    READ ENTITIES OF zi_travel_root_inch IN LOCAL MODE
    ENTITY _Suppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_book_res )
    RESULT DATA(lt_suppl_res).

    LOOP AT lt_travel_res ASSIGNING FIELD-SYMBOL(<lfs_travel_res>).

      lt_tot_price = VALUE #( ( price = <lfs_travel_res>-BookingFee
                                  curr  = <lfs_travel_res>-CurrencyCode
                               ) ).

      LOOP AT lt_book_res ASSIGNING FIELD-SYMBOL(<lfs_book_res>)
                                                WHERE TravelId = <lfs_travel_res>-TravelId
                                                AND currencycode IS NOT INITIAL.

        APPEND VALUE #( price = <lfs_book_res>-FlightPrice
                                  curr = <lfs_book_res>-CurrencyCode
                                  ) TO lt_tot_price.

        LOOP AT lt_suppl_res ASSIGNING FIELD-SYMBOL(<lfs_suppl_res>)
                                                  WHERE TravelId = <lfs_travel_res>-TravelId
                                                  AND BookingId = <lfs_book_res>-BookingId
                                                  AND CurrencyCode IS NOT INITIAL.

          APPEND VALUE #( price = <lfs_suppl_res>-Price
                                   curr  = <lfs_suppl_res>-CurrencyCode
                                ) TO lt_tot_price.
        ENDLOOP.

      ENDLOOP.

      LOOP AT lt_tot_price ASSIGNING FIELD-SYMBOL(<lfs_tot_price>).
        IF <lfs_travel_res>-CurrencyCode IS NOT INITIAL
             AND <lfs_travel_res>-CurrencyCode = <lfs_tot_price>-curr.

          lv_conv_price  = <lfs_tot_price>-price.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
              EXPORTING
                 iv_amount = <lfs_tot_price>-price
                 iv_currency_code_source = <lfs_tot_price>-curr
                 iv_currency_code_target = <lfs_travel_res>-CurrencyCode
                 iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
              IMPORTING
                 ev_amount               = lv_conv_price
           ).
        ENDIF.

        lv_calc_price = lv_calc_price + lv_conv_price.
      ENDLOOP.

      APPEND VALUE #(
                  %tky = <lfs_travel_res>-%tky
                  totalprice = lv_calc_price
                  %control-totalprice = if_abap_behv=>mk-on
                 )
     TO lt_travel_upd.

    ENDLOOP.

    IF <lfs_travel_res>-TotalPrice NE lv_calc_price.
      IF lt_travel_upd IS NOT INITIAL.
        MODIFY ENTITIES OF zi_travel_root_inch IN LOCAL MODE
        ENTITY _Travel
        UPDATE FIELDS ( TotalPrice )
        WITH lt_travel_upd.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD calculateTotalPrice.

    MODIFY ENTITY IN LOCAL MODE zi_travel_root_inch
    EXECUTE CalcTotPrice
    FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
