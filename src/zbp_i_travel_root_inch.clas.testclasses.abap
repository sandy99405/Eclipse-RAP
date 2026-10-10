"!@testing [BDEF:BDEF_ZI_TRAVEL_ROOT_INCH]
CLASS ltcl_managed definition FOR testing
     RISK LEVEL HARMLESS
     DURATION MEDIUM.

   PUBLIC SECTION.

   PROTECTED SECTION.

   PRIVATE SECTION.

      CLASS-DATA:
           class_under_test type REF to lhc__travel,
           cds_test_environment type ref to if_cds_test_environment,
           sql_test_environment type ref to if_osql_test_environment.

      CLASS-METHODS:
           class_setup,
           class_teardown.

      methods:
          setup,
          teardown,
          method_name for testing,
          get_instance_feature_t for testing,
          get_instance_feature_n for testing.


ENDCLASS.

CLASS ltcl_managed implementation.


    method class_setup.
         create object class_under_test for testing.

         cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZI_TRAVEL_ROOT_INCH' ).
    endmethod.

    method class_teardown.
         cds_test_environment->destroy(  ).
    ENDMETHOD.

    method setup.
         cds_test_environment->clear_doubles(  ).
    ENDMETHOD.

    METHOD teardown.
        ROLLBACK entities.
    endmethod.

    method method_name.

        data: lt_failed type RESPONSE for failed late zi_travel_root_inch,
              lt_reported type response for reported late zi_travel_root_inch,
              lt_travel_in type TABLE of ztravel_incha_m,
              lt_travel type table of zi_travel_root_inch.

        lt_travel_in = value #( ( travel_id = '104' overall_status = 'G' ) ).

        cds_test_environment->insert_test_data( lt_travel_in ).

        lt_travel = corresponding #( lt_travel_in mapping TravelId = travel_id OverallStatus = overall_status ).

        class_under_test->validoverallstatus(
          EXPORTING
            keys     = corresponding #( lt_travel )
          CHANGING
            failed   = lt_failed
            reported = lt_reported
        ).

       cl_abap_unit_assert=>assert_initial( msg = 'Failed due to wrong Status' act = lt_failed ).
       cl_abap_unit_assert=>assert_initial( msg = 'Reported due to wrong Status' act = lt_reported ).

    endmethod.

    method get_instance_feature_t.

         DATA: lt_travel type table of ztravel_incha_m,
               lt_travel_t type table of zi_travel_root_inch,
               lt_result TYPE TABLE for features result zi_travel_root_inch\\_Travel,
               lt_failed type response for failed early zi_travel_root_inch,
               lt_reported type RESPONSE for reported early zi_travel_root_inch.

         lt_travel = value #( ( travel_id = '69' overall_status = 'A' ) ).

         cds_test_environment->insert_test_data( lt_travel ).

         lt_travel_t = corresponding #( lt_travel mapping TravelId = travel_id OverallStatus = overall_status ).

         class_under_test->get_instance_features(
           EXPORTING
             keys               = corresponding #( lt_travel_t )
             requested_features = value #( %action-AcceptTravel = if_abap_behv=>fc-o-disabled
                                           %action-RejectTravel = if_abap_behv=>fc-o-enabled
                                           %assoc-_Booking      = if_abap_behv=>mk-on
                                          )
           CHANGING
             result             = lt_result
             failed             = lt_failed
             reported           = lt_reported
         ).

         DATA exp like lt_result.
         DATA: api_key TYPE if_abap_api_state=>ty_s_api_key.
         exp = value #( ( TravelId = '69'
                          %action-AcceptTravel = if_abap_behv=>fc-o-disabled
                          %action-RejectTravel = if_abap_behv=>fc-o-enabled
                          %assoc-_Booking      = if_abap_behv=>fc-o-enabled
                               ) ).

         cl_abap_unit_assert=>assert_equals( msg = 'Success Result' act = lt_result exp = exp ).

*        try.
*
*         api_key-object_type = 'DDLS'.
*         api_key-object_name = 'I_Currency'.
*         api_key-sub_object_type = 'CDS_STOB'.
*         api_key-sub_object_name = 'I_Currency'.
*
*         cl_abap_api_state=>create_instance(
*           EXPORTING
*             api_key = api_key
*           RECEIVING
*             result  = data(result)
*         ).
*
*         CATCH cx_abap_api_state.
*
*        endtry.

    endmethod.


    method get_instance_feature_n.

         data: lt_result TYPE table for features result zi_travel_root_inch\\_travel,
               failed type response for failed early zi_travel_root_inch,
               reported type response for reported early zi_travel_root_inch.


         class_under_test->get_instance_features(
           EXPORTING
             keys               = value #( ( travelid = '43' ) )
             requested_features = value #( %action-AcceptTravel = if_abap_behv=>mk-off
                                           %action-RejectTravel = if_abap_behv=>fc-o-enabled
                                           %assoc-_Booking      = if_abap_behv=>fc-o-enabled
                                           )
           CHANGING
             result             = lt_result
             failed             = failed
             reported           = reported
         ).

         cl_abap_unit_assert=>assert_equals( msg = 'Failed' act = lines( failed-_travel ) exp = 1 ).
         cl_abap_unit_assert=>assert_equals( msg = 'failed due to no record' act = failed-_travel[ 1 ] exp = '43' ).
         cl_abap_unit_assert=>assert_equals( msg = 'fail-cause in failed-_travel' act = failed-_travel[ 1 ]-%fail-cause exp = if_abap_behv=>cause-not_found ).

    endmethod.

ENDCLASS.
