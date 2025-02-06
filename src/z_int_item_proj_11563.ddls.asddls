@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_INT_ITEM_PROJ_11563 as projection on Z_INT_ITEM_11563
{
  key Docno,
    key ItemNo,
    Status,
    @Semantics.amount.currencyCode: 'Currency'
    ItemAmt,
     @Semantics.amount.currencyCode: 'Currency'
    TaxAmt,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    Quantity,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_CurrencyText', element: 'Currency' } }]
    Currency,
    UOM,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    /* Associations */
    _header : redirected to parent Z_INT_HEADER_PROJ_11563
}
