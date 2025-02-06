@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_INT_HEADER_PROJ_11563 
as projection on Z_INT_HEADER_11563
{
@Search.defaultSearchElement: true
    key Docno,
    CompCd,
    PurchOrg,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_CurrencyText', element: 'Currency' } }]
    Currency,
    SupplierNo,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'Z_I_STATUS_DOM_11563', element: 'Value' } }]
    Status,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    LocalLastChangedAt,
    /* Associations */
    _item : redirected to composition child Z_INT_ITEM_PROJ_11563
    
}
