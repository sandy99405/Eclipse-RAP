CLASS zabap_practise DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zabap_practise IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITY zi_travel_root_inch
    CREATE FIELDS ( AgencyId BookingFee CurrencyCode CustomerId OverallStatus )
    WITH VALUE #( ( %cid = 'INCHARASANDILYA'
                  AgencyId = '102'
                  CustomerId = '302'
                  OverallStatus = 'A'
                  BookingFee = '1029'
                  CurrencyCode = 'AB'
                  %control = VALUE #(
                     AgencyId = if_abap_behv=>mk-on
                     CustomerId = if_abap_behv=>mk-on
                     OverallStatus = if_abap_behv=>mk-on
                     BookingFee = if_abap_behv=>mk-on
                     CurrencyCode = if_abap_behv=>mk-on
                   ) ) )
     CREATE BY \_Booking
     FIELDS ( BookingDate BookingStatus CarrierId ConnectionId CustomerId FlightPrice CurrencyCode )
     WITH VALUE #( (
          %cid_ref = 'INCHARASANDILYA'
          %target = VALUE #( (
           %cid = 'INCHARASANDILYACHILD'
           %data = VALUE #(
              BookingId = '0318'
              BookingStatus = 'A'
              CarrierId = '69'
              ConnectionId = '2837'
              CustomerId = '7364'
              FlightPrice = '3646'
              CurrencyCode = 'AB'
           )
          %control = VALUE #(
             BookingId = if_abap_behv=>mk-on
              BookingStatus = if_abap_behv=>mk-on
              CarrierId = if_abap_behv=>mk-on
              ConnectionId = if_abap_behv=>mk-on
              CustomerId = if_abap_behv=>mk-on
              FlightPrice = if_abap_behv=>mk-on
              CurrencyCode = if_abap_behv=>mk-on
           )
          ) )
         ) )
     MAPPED DATA(lt_mapped)
     REPORTED DATA(lt_reported)
     FAILED DATA(lt_failed).


*     if lt_failed is not initial.
    COMMIT ENTITIES.
*     endif.


  ENDMETHOD.
ENDCLASS.
