@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Interface View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_INT_HEADER_11563 as select from ztm_header_11563
composition[1..*] of Z_INT_ITEM_11563 as _item 
{    
@Search.defaultSearchElement: true
key docno as Docno,      //Document Number
comp_cd as CompCd,       //Company Code
purch_org as PurchOrg,   // Purchasing Organization
currency as Currency,    //Currency
supplier_no as SupplierNo, //Supplier Number
@Consumption.valueHelpDefinition: [{ entity : { name : 'Z_I_STATUS_DOM_11563' , element: 'Value'  } }]
status as Status,          // Status
changed_at as ChangedAt,   //Changed At
created_at as CreatedAt,   //Created At
created_by as CreatedBy,   //Created By
locallastchangedat as LocalLastChangedAt,

// Make Associations Public
_item
    
}
