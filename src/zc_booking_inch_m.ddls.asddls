@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Booking'
@Metadata.allowExtensions: true
define view entity ZC_BOOKING_INCH_M as projection on ZI_BOOING_INCH_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    @ObjectModel.text.element: [ 'CustomerLastName' ]
    CustomerId,
    _Customer.LastName as CustomerLastName,
    @ObjectModel.text.element: [ 'CarrierName' ]
    CarrierId,
    _Carrier.Name as CarrierName,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    @ObjectModel.text.element: [ 'BookingStatusText' ]
    BookingStatus, 
    _BookSt._Text.Text as BookingStatusText : localized,
    LastChangedAt,
    /* Associations */
    _BookSt,
    _Carrier,
    _Connection,
    _Customer,
    _Suppl:     redirected to composition child ZC_BOOKING_SUPPL_M,
    _Travel:    redirected to parent ZC_TRAVEL_ROOT_INCH
}
