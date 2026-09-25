@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver for Booking'
@UI.headerInfo:{
      typeName: 'Booking',
      typeNamePlural: 'Bookings',
      title: { type: #STANDARD, label:'Booking ID' }
}
@Search.searchable:true
define view entity ZC_BOOKING_APPROVER_INCH as projection on ZI_BOOING_INCH_M
{
    @UI.facet :[{
         id: 'Booking',
         position: 10,
         purpose: #STANDARD,
         type: #IDENTIFICATION_REFERENCE,
         label: 'Booking'
    }]
    @UI : {
        lineItem: [ {position: 10, importance: #HIGH}],
        identification: [{position:10}]
    }
    @Search.defaultSearchElement: true
    key TravelId,
    @UI : {
        lineItem: [ {position: 20, importance: #HIGH}],
        identification: [{position:20}]
    }
    key BookingId,
    @UI : {
        lineItem: [ {position: 30, importance: #HIGH}],
        identification: [{position:30}]
    }
    BookingDate,
    @UI : {
        lineItem: [ {position: 40, importance: #HIGH}],
        identification: [{position:40}]
    }
    CustomerId,
    @UI : {
        lineItem: [ {position: 50, importance: #HIGH}],
        identification: [{position:50}]
    }
    CarrierId,
    @UI : {
        lineItem: [ {position: 60, importance: #HIGH}],
        identification: [{position:70}]
    }
    ConnectionId,
    FlightDate,
  //  FlightPrice,
 //   CurrencyCode,
    BookingStatus,
 //   LastChangedAt,
    /* Associations */
    _BookSt,
    _Carrier,
    _Connection,
    _Customer,
    _Suppl,
    _Travel: redirected to parent ZC_TRAVEL_APPROVER_INCH
}
