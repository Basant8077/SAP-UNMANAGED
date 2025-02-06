CLASS zcl_crud_header_um DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : tt_create_header  TYPE TABLE FOR CREATE z_int_header_11563\\_header,
            tt_mapped_early   TYPE RESPONSE FOR MAPPED EARLY z_int_header_11563,
            tt_response_early TYPE RESPONSE FOR FAILED EARLY z_int_header_11563,
            tt_reported_early TYPE RESPONSE FOR REPORTED EARLY z_int_header_11563,
            tt_reported_late  TYPE RESPONSE FOR REPORTED LATE z_int_header_11563.


TYPES : TT_HEADER_KEYS TYPE table for read import z_int_header_11563\\_header,
        TT_HEADER_RESULT TYPE table for read result z_int_header_11563\\_header,
        TT_FAILED_EARLY TYPE  response for failed early z_int_header_11563.

TYPES : TT_HEADER_DELETE type table for delete z_int_header_11563\\_header .
TYPES : TT_UPDATE_ITEM TYPE TABLE FOR UPDATE z_int_item_11563.

TYPES : TT_UPDATE_HEADER TYPE table for update z_int_header_11563\\_header.

DATA :   mt_item type standard table of ztd_item_11563 with non-unique default key.
TYPES : TT_CREATE_ITEM TYPE table for create z_int_header_11563\\_header\_item.

    CLASS-METHODS : get_next_docno_id RETURNING VALUE(r_docno_val) TYPE ztdocno_dt.

    CLASS-METHODS : savedata CHANGING reported TYPE tt_reported_late.

    CLASS-METHODS : get_instance RETURNING VALUE(ro_instance)
                                             TYPE REF TO zcl_crud_header_um.

CLASS-METHODS : UPDATE importing entities  type  TT_UPDATE_HEADER"table for update z_int_header_11563\\_header  [ derived type... ]
 changing mapped  type TT_MAPPED_EARLY "response for mapped early z_int_header_11563  [ derived type... ]
  failed  type  TT_FAILED_EARLY"response for failed early z_int_header_11563  [ derived type... ]
  reported  type TT_REPORTED_EARLY."response for reported early z_int_header_11563  [ derived type... ]

    METHODS  create_header
      IMPORTING entities TYPE tt_create_header
      CHANGING  mapped   TYPE tt_mapped_early
                failed   TYPE tt_response_early
                reported TYPE tt_reported_early.

METHODS DELETE importing keys  type TT_HEADER_DELETE
 changing mapped  TYPE TT_MAPPED_eARLY
  failed  type tt_response_early
  reported  type tt_reported_early  .

    METHODS READ_DATA
     importing keys  type  TT_HEADER_KEYS
 changing result  type  TT_HEADER_RESULT
  failed    TYPE TT_FAILED_EARLY
  reported  type   TT_REPORTED_EARLY.

METHODS CBA_ITEM importing entities_cba  type tt_create_item  "[ derived type... ]
 changing mapped  type TT_MAPPED_EARLY " [ derived type... ]
  failed  type TT_RESPONSE_EARLY "  [ derived type... ]
  reported  type TT_REPORTED_EARLY.  "[ derived type... ]


  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA : mo_instance TYPE REF TO zcl_crud_header_um,
                 gt_HEADER   TYPE STANDARD TABLE OF ztm_header_11563,
                 gs_mapped   TYPE tt_mapped_early,
                 gt_result   TYPE STANDARD TABLE OF ztd_item_11563,
                 gr_header_r TYPE range of  ZTM_HEADER_11563,
                 GT_RESULT_ITEM TYPE STANDARD TABLE OF ztd_item_11563.


ENDCLASS.



CLASS zcl_crud_header_um IMPLEMENTATION.
  METHOD create_header.
    "---Implement the Create Header Functionality in this Method
    "--MAPPING FROM ENTITY--->F
    gt_header = CORRESPONDING #( entities MAPPING FROM ENTITY )."--Mapping data from UIFrontend to Backend Database

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).

      IF NOT gt_header[] IS INITIAL.

        gt_header[ 1 ]-docno = get_next_docno_id(  ).

        mapped-_header = VALUE #( (
                               %cid = <lfs_entities>-%cid
                               %key = <lfs_entities>-%key
        ) ).


      ENDIF.



    ENDLOOP.



  ENDMETHOD.

  METHOD get_next_docno_id.
    "--Get DOCNO From TABLE and Update the MAX Value
    SELECT MAX( docno ) FROM ztm_header_11563 INTO @DATA(lv_max_docnoid).
    r_docno_val = lv_max_docnoid + 1.
    r_docno_val = |{ r_docno_val ALPHA = IN }|.
  ENDMETHOD.

  METHOD savedata.
    "--Save The DATA
       IF NOT gr_header_r IS INITIAL.

LOOP AT gr_header_r INTO DATA(range_entry).
  data(lv_docno) = range_entry-low-docno .
  lv_docno = |{ lv_docno ALPHA = IN }|.
  DELETE FROM  ztm_header_11563 WHERE DOCNO EQ  @lv_docno.
ENDLOOP.


    ENDIF.

    IF NOT gt_header[] IS INITIAL.

      MODIFY ztm_header_11563 FROM TABLE @gt_header.

    ENDIF.



  ENDMETHOD.

  METHOD get_instance.

    mo_instance = ro_instance = COND #(
    WHEN mo_instance IS BOUND
    THEN mo_instance
    ELSE NEW #(  )
    ).

  ENDMETHOD.

  METHOD read_data.
"--Implement READ Data
SELECT * FROM ZTM_HEADER_11563 FOR ALL ENTRIES IN @keys
WHERE docno = @keys-Docno
INTO TABLE @DATA(LT_HEADER_DATA).

RESULT = CORRESPONDING #( LT_HEADER_DATA MAPPING TO ENTITY ).



  ENDMETHOD.

  METHOD update.
"--Update the Header Records
DATA : LT_HEADER_UPDATE TYPE STANDARD TABLE OF ztm_header_11563,
       LT_HEADER_UPDATE_X TYPE STANDARD TABLE OF ZTM_HEADER_STR,
       LS_HEADER_UPDATE TYPE ztm_header_11563.

LT_HEADER_UPDATE = CORRESPONDING #( ENTITIES MAPPING FROM ENTITY ).


SELECT * FROM ztm_header_11563
FOR ALL ENTRIES IN @lt_header_update
WHERE docno = @lt_header_update-docno
INTO TABLE @DATA(LT_HEADER_UPDATE_OLD). "--Reference Record to be checked with

"--Insert the MODIFIED DATA BACK TO TABLE
GT_HEADER = VALUE #(
*    "--Loop running once only
FOR X = 1 WHILE X <= LINES( lt_header_update )
    LET
    ls_control_flag = VALUE #( entities[ x ]-%control OPTIONAL )
    ls_header_OLD = VALUE #( LT_HEADER_UPDATE_OLD[ x ]  OPTIONAL )"--Whatever User has Update it will come here
    ls_header_NEW = VALUE #( LT_HEADER_UPDATE[ DOCNO = ls_header_old-docno ] OPTIONAL )
in
(
*"--Use CONTROL STRUCUTRE to IDENTIFY WHICH VALUES ARE UPDATED
*"--Still we will send those fields that are not UPDATED,Else we will get DUMP or
docno = ls_header_old-docno
purch_org = COND #( WHEN ls_control_flag-PurchOrg IS NOT INITIAL
                    THEN LS_HEADER_new-purch_org ELSE ls_header_old-purch_org )
*
comp_cd = COND #( WHEN ls_control_flag-CompCd IS NOT INITIAL
                    THEN LS_HEADER_new-comp_cd ELSE ls_header_old-comp_cd )
*
  currency =    COND #( WHEN ls_control_flag-Currency IS NOT INITIAL
                    THEN LS_HEADER_new-currency ELSE ls_header_old-currency )
*
created_at =  COND #( WHEN ls_control_flag-CreatedAt IS NOT INITIAL
                    THEN LS_HEADER_new-created_at ELSE ls_header_old-created_at )

 created_by =  COND #( WHEN ls_control_flag-CreatedBy IS NOT INITIAL
                    THEN LS_HEADER_new-created_by ELSE ls_header_old-created_by )

 status =  COND #( WHEN ls_control_flag-status IS NOT INITIAL
                    THEN LS_HEADER_new-status ELSE ls_header_old-status )

 supplier_no =  COND #( WHEN ls_control_flag-SupplierNo IS NOT INITIAL
                    THEN LS_HEADER_new-supplier_no ELSE ls_header_old-supplier_no )

 locallastchangedat = COND #( WHEN ls_control_flag-locallastchangedat IS NOT INITIAL
                    THEN LS_HEADER_new-locallastchangedat ELSE ls_header_old-locallastchangedat )

 changed_at =  COND #( WHEN ls_control_flag-ChangedAt IS NOT INITIAL
                    THEN LS_HEADER_new-changed_at ELSE ls_header_old-changed_at )

 ) ).

  ENDMETHOD.

  METHOD delete.

data : lt_header type standard table of ztm_header_11563.
lt_header = CORRESPONDING #( keys MAPPING FROM ENTITY ).

gr_header_R = value #(
            for ls_header IN lT_HEADER
            sign = 'I'
            option = 'EQ'
         (   low = ls_header-docno )
).


  ENDMETHOD.

  METHOD cba_item.

data : lwa_item type ztd_item_11563.
LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<LFS_ENTITY_CBA>).

LOOP AT <lfs_entity_cba>-%target ASSIGNING FIELD-SYMBOL(<LFS_ITEM>).

*GT_RESULT_ITEM = CORRESPONDING #( <lfs_ENTITY_CBA>-%target MAPPING FROM ENTITY  ).


        MOVE-CORRESPONDING <Lfs_item> TO lwa_item.

        lwa_item-docno  = <Lfs_item>-Docno.
        lwa_item-item_no     = <Lfs_item>-ItemNo.
        lwa_item-status          = <Lfs_item>-Status.
        lwa_item-quantity        = <LFs_item>-Quantity.
        lwa_item-currency        = <Lfs_item>-Currency.
        lwa_item-item_amt          = <Lfs_item>-ItemAmt.
        lwa_item-tax_amt      = <Lfs_item>-TaxAmt.
        lwa_item-changed_at      = <Lfs_item>-ChangedAt.
        lwa_item-created_at      = <Lfs_item>-CreatedAt.
        lwa_item-created_by      = <Lfs_item>-CreatedBy.

        APPEND lwa_item TO mt_item.
      ENDLOOP.

"--Now we will Put this LT_ITEM in MAPPED
*mapped-z_int_item_11563 = lt_item.
ENDLOOP.



  ENDMETHOD.

ENDCLASS.
