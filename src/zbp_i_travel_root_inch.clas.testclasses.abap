"! @testing [BDEF:BDEF_ZI_TRAVEL_ROOT_INCH] | [CDS:CDS_ZI_TRAVEL_ROOT_INCH] | [SRVB:SRVB_ZUI_TECH_INCH_V2]
CLASS ltcl_managed DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc__travel,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      setup,
      teardown,
      method_name FOR TESTING.

ENDCLASS.


CLASS ltcl_managed IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.

    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZI_TRAVEL_ROOT_INCH' ).

  ENDMETHOD.

  METHOD class_teardown.

    cds_test_environment->destroy(  ).

  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles(  ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.


  METHOD method_name.

    DATA: lt_travel_int TYPE TABLE OF ztravel_incha_m,
          lt_failed     TYPE RESPONSE FOR FAILED LATE zi_travel_root_inch,
          lt_reported   TYPE RESPONSE FOR REPORTED LATE zi_travel_root_inch.

    lt_travel_int = VALUE #( ( travel_id = '103' overall_status = 'G' ) ).

    cds_test_environment->insert_test_data( lt_travel_int ).

    data: lt_travel type table of zi_travel_root_inch.

    lt_travel = corresponding #( lt_travel_int MAPPING TravelId = travel_id OverallStatus = overall_status ).

    class_under_test->validoverallstatus(
        EXPORTING
           keys = CORRESPONDING #( lt_travel )
        CHANGING
           failed = lt_failed
           reported = lt_reported
     ).

    cl_abap_unit_assert=>assert_initial( msg = 'Failed due to error' act = lt_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'Reported' act = lt_reported ).

  ENDMETHOD.


ENDCLASS.
