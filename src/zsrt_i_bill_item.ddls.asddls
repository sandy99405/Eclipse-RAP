@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill Item Interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSRT_I_BILL_ITEM as select from zsrt_bill_item
{  
   key billid as Billid,
   key materialid as Materialid,
    itemno as Itemno,
    description as Description
}
