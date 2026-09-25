@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver for Travel'
@UI.headerInfo:{
         typeName:'Travel',
         typeNamePlural : 'Travels',
         title : {type: #STANDARD, label: 'Travel' }
}
@Search.searchable: true
define root view entity ZC_TRAVEL_APPROVER_INCH 
provider contract transactional_query
as projection on ZI_TRAVEL_ROOT_INCH
{
@UI.facet: [
       {
          id: 'Travel',
          position: 10,
          purpose: #STANDARD,
          label: 'Travel',
          type: #IDENTIFICATION_REFERENCE
       },
       {
           id: 'Booking',
           label: 'Booking',
           position: 20,
           purpose: #STANDARD,
           type: #LINEITEM_REFERENCE,
           targetElement: '_Booking'
       }
]
   @UI: {
       lineItem: [{position: 10, importance: #HIGH}],
       identification: [{position:10}],
       selectionField: [{position: 10}]
   }
   @Search.defaultSearchElement: true
    key TravelId,
    @UI: {
       lineItem : [{position: 20, importance: #HIGH}],
       identification: [{position:20}],
       selectionField: [{position:20}]
    }
    @ObjectModel.text.element: ['AgencyName']
    AgencyId,
    _Agency.Name as AgencyName,
    @UI: {
        lineItem: [{position: 30}],
        identification: [{position: 30}],
        selectionField: [{position:30}]
    }
    @ObjectModel.text.element: ['CustomerName']
    CustomerId,
    _Customer.FirstName as CustomerName,
     @UI: {
        lineItem: [{position: 40}],
        identification: [{position: 40}]
    }
    BeginDate,
     @UI: {
        lineItem: [{position: 50}],
        identification: [{position: 50}]
    }
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    @UI: {
        lineItem: [{position: 60}],
        identification: [{position: 60}]
    }
    Description,
    @UI: {
        lineItem: [{position: 70, importance:#HIGH},
                   {type: #FOR_ACTION, dataAction: 'AcceptTravel', label:'Accept Travel'},
                   {type: #FOR_ACTION, dataAction: 'RejectTravel', label:'Reject Travel'}
                  ],
        identification: [{position: 70},
                         {type: #FOR_ACTION, dataAction: 'AcceptTravel', label:'Accept Travel'},
                         {type: #FOR_ACTION, dataAction: 'RejectTravel', label:'Reject Travel'}
                        ],
        selectionField: [{position: 70}]
    }
    @Consumption.valueHelpDefinition: [ { entity: {
            name: '/DMO/I_Overall_Status_VH_Text',
            element: 'OverallStatus'
         } 
    } ]    
    OverallStatus,
    @UI.hidden: true
    CreatedBy,
    @UI.hidden: true
    CreatedAt,
    @UI.hidden: true
    LastChangedBy,
    @UI.hidden: true
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZC_BOOKING_APPROVER_INCH,
    _Currency,
    _Customer,
    _Status
}
