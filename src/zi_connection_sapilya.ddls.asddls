@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection View CDS Data Model'
@Metadata.ignorePropagatedAnnotations: true

@UI.headerInfo:{
     typeName:'Connection',
     typeNamePlural:'Connections'
     }
@Search.searchable: true     
define view entity ZI_Connection_SAPilya
  as select from /dmo/connection as Connection
  association [1..*] to ZI_FLIGHT_INCH_R as _Inch_R
  on $projection.CarrierId = _Inch_R.CarrierId
  and $projection.ConnectionId = _Inch_R.ConnectionId
  association [1] to ZI_FLIGHT_INCH_NAME_R as _Name
  on $projection.CarrierId = _Name.CarrierId 
{
  @UI.facet: [{ id:'Connection',
               purpose: #STANDARD,
               type:#IDENTIFICATION_REFERENCE,
               position: 10,
               label: 'Check with eclipse you idiot'},
               { id:'Flight',
               purpose: #STANDARD,
               type:#LINEITEM_REFERENCE,
               position: 20,
               label: 'Fligh Detail',
               targetElement:'_Inch_R'}]

  @UI.lineItem:[{position:10, label:'Carrier ID'}]
  @UI.identification: [{ position: 10 }]
  @ObjectModel.text.association: '_Name'
  @Search.defaultSearchElement: true
  key carrier_id      as CarrierId,
  @UI.lineItem:[{position:20, label:'Connection ID'}]
  @UI.identification: [{ position: 20}]
  @Search.defaultSearchElement:true
  key connection_id   as ConnectionId,
  @UI.selectionField:[{position:30}]
  @UI.lineItem:[{position:30, label:'From Airport'}]
  @UI.identification: [{ position: 30 , label: 'Departure Airport Id'}]
      airport_from_id as AirportFromId,
  @UI.lineItem:[{position:40, label:'To Airport'}]    
  @UI.identification: [{ position: 40 }]
  @EndUserText.label: 'Destination Airport ID'    // ABAP level 
      airport_to_id   as AirportToId,
  @UI.selectionField:[{position:60}]
  @UI.lineItem:[{position:50, label:'Departure Time'}]
  @UI.identification: [{ position: 50 }]    
      departure_time  as DepartureTime,
  @UI.lineItem:[{position:10, label:'Time of Arriva'}]
  @UI.identification: [{ position: 60 }]    
      arrival_time    as ArrivalTime,  
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
  @UI.identification: [{ position: 70 }]    
      distance        as Distance,
      distance_unit   as DistanceUnit,
      
//    Association -->
      _Inch_R,
      _Name
}
