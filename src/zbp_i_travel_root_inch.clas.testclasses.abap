"! @testing [BDEF:BDEF_ZI_TRAVEL_ROOT_INCH] | [CDS_ZI_TRAVEL_ROOT_INCH] | [SRVB:SRVB_ZUI_TECH_INCH_V2]
class ltcl_managed definition final for testing
  duration SHORT
  risk level harmless.

  private section.
    methods:
      first_test for testing raising cx_static_check.
endclass.


class ltcl_managed implementation.

  method first_test.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.

endclass.
