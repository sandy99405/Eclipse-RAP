@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Suppliments booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
      serviceQuality: #X,
      sizeCategory: #S,
      dataClass:#MIXED
}
define view entity ZI_BOOKING_SUPPL_M
  as select from zbooksupl_inch_m
  association        to parent ZI_BOOING_INCH_M as _booking    on  $projection.BookingId = _booking.BookingId
                                                               and $projection.TravelId  = _booking.TravelId
  association [1..1] to ZI_TRAVEL_ROOT_INCH     as _Travel     on  $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Supplement       as _Supplement on  $projection.SupplementId = _Supplement.SupplementID
  association [1..*] to /DMO/I_SupplementText   as _supptext   on  $projection.SupplementId = _supptext.SupplementID
{
      @ObjectModel.foreignKey.association: '_Travel'
  key travel_id             as TravelId,
      @ObjectModel.foreignKey.association: '_booking'
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      last_changed_at       as LastChangedAt,
      _booking,
      _Supplement,
      _supptext,
      _Travel
}
