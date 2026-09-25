@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
      serviceQuality: #X,
      sizeCategory: #S,
      dataClass:#MIXED
}
define view entity ZI_BOOING_INCH_M
  as select from zbooking_inch_m
  association     to parent ZI_TRAVEL_ROOT_INCH as _Travel     on  $projection.TravelId = _Travel.TravelId
  composition [0..*] of ZI_BOOKING_SUPPL_M         as _Suppl
  association [1..1] to /DMO/I_Carrier             as _Carrier    on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Customer            as _Customer   on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Connection          as _Connection on  $projection.CarrierId    = _Connection.AirlineID
                                                                  and $projection.ConnectionId = _Connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH   as _BookSt     on  $projection.BookingStatus = _BookSt.BookingStatus

{
      @ObjectModel.foreignKey.association: '_Travel'
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      last_changed_at as LastChangedAt,
      _Travel,
      _Suppl,
      _Carrier,
      _Customer,
      _Connection,
      _BookSt
}
