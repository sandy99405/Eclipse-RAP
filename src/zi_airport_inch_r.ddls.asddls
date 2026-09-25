@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vaue help CDS View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_AIRPORT_INCH_R as select from /dmo/airport
{
  
    key airport_id as AirportId,
    name as Name,
    city as City,
    country as Country
}
