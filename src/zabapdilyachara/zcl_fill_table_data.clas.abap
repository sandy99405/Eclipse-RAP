CLASS ZCL_FILL_TABLE_DATA DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.

      PUBLIC SECTION.
           INTERFACES if_oo_adt_classrun.
      PROTECTED SECTION.

      PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_FILL_TABLE_DATA IMPLEMENTATION.


       METHOD if_oo_adt_classrun~main.

              data: lt_filler type table of ZBOOKING_INCH_M,
                    lt_new_filler type table of ZBOOKSUPL_INCH_M.


            DELETE FROM ZBOOKING_INCH_M.
            DELETE FROM ZBOOKSUPL_INCH_M.

           lt_filler = value #(
                ( travel_id = '102' booking_id = '1001' booking_date  = '19991011' customer_id = '2001' carrier_id = '200'
                   connection_id = '2000' flight_date = '20261020' flight_price = '200' booking_status = 'S' )
                (  travel_id = '103' booking_id = '1002' booking_date  = '19991012' customer_id = '2002' carrier_id = '300'
                   connection_id = '3000' flight_date = '20261021' flight_price = '300' booking_status = 'F' )
                   ).

           lt_new_filler = value #(
           ( travel_id = '102' booking_id = '1001' booking_supplement_id = '10' supplement_id =  '100' price = '100'
            currency_code  = '100' )
           ( travel_id = '103' booking_id = '1002' booking_supplement_id = '20' supplement_id =  '200' price = '200'
            currency_code  = '300' )
           ).

           insert zbooking_inch_m from table @lt_filler.
           insert zbooksupl_inch_m from table @lt_new_filler.

           if sy-subrc = 0.
                  out->write( 'Hi Inchara loves Sandilya !! and marries Sandilya' ).
           endif.

       ENDMETHOD.
ENDCLASS.
