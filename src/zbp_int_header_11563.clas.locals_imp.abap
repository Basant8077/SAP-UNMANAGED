CLASS lhc_Z_INT_HEADER_11563 DEFINITION INHERITING FROM cl_abap_behavior_handler.
PUBLIC SECTION.
*  CLASS-DATA:
*      mt_root_to_create TYPE STANDARD TABLE OF ztm_header_11563 WITH NON-UNIQUE DEFAULT KEY,
*      ms_root_to_create TYPE ztm_header_11563,
*      mt_item           TYPE STANDARD TABLE OF ztd_item_11563 WITH NON-UNIQUE DEFAULT KEY,
*      mT_root_to_DELETE TYPE STANDARD TABLE OF ztm_header_11563 WITH NON-UNIQUE DEFAULT KEY,
*      ms_DEL            TYPE ztm_header_11563.

* TYPES : tt_create_header  TYPE TABLE FOR CREATE z_int_header_11563\\_header,
*            tt_mapped_early   TYPE RESPONSE FOR MAPPED EARLY z_int_header_11563,
*            tt_response_early TYPE RESPONSE FOR FAILED EARLY z_int_header_11563,
*            tt_reported_early TYPE RESPONSE FOR REPORTED EARLY z_int_header_11563,
*            tt_reported_late  TYPE RESPONSE FOR REPORTED LATE z_int_header_11563.
*TYPES : TT_HEADER_KEYS TYPE table for read import z_int_header_11563\\_header,
*        TT_HEADER_RESULT TYPE table for read result z_int_header_11563\\_header,
*        TT_FAILED_EARLY TYPE  response for failed early z_int_header_11563.
*
*TYPES : TT_UPDATE_ITEM TYPE TABLE FOR UPDATE z_int_item_11563.
*
*TYPES : TT_UPDATE_HEADER TYPE table for update z_int_header_11563\\_header.
*    CLASS-METHODS : get_next_docno_id RETURNING VALUE(r_docno_val) TYPE ztdocno_dt.

  PRIVATE SECTION.

* CLASS-DATA : mo_instance TYPE REF TO zcl_crud_header_um,
*                 gt_HEADER   TYPE STANDARD TABLE OF ztm_header_11563,
*                 gs_mapped   TYPE tt_mapped_early,
*                 gt_result   TYPE STANDARD TABLE OF ztd_item_11563.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE _header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE _header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE _header.

    METHODS read FOR READ
      IMPORTING keys FOR READ _header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _header..

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ _header\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE _header\_Item.

ENDCLASS.

CLASS lhc_Z_INT_HEADER_11563 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

  "--Call the create_header Method of the class
  "--Question-->Why Use the get_instance( )
  zcl_crud_header_um=>get_instance( )->create_header(
    EXPORTING
      entities = entities
    CHANGING
      mapped   = mapped
      failed   = failed
      reported = reported
  ).

* gt_header = CORRESPONDING #( entities MAPPING FROM ENTITY )."--Mapping data from UIFrontend to Backend Database
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).
*
*      IF NOT gt_header[] IS INITIAL.
*
*        gt_header[ 1 ]-docno = get_next_docno_id(  ).
*
*        mapped-_header = VALUE #( (
*                               %cid = <lfs_entities>-%cid
*                               %key = <lfs_entities>-%key
*        ) ).

*
*      ENDIF.
*
*
*
*    ENDLOOP.


*  LOOP AT entities INTO DATA(entity).
*      MOVE-CORRESPONDING entity TO ms_root_to_create.
*
*      ms_root_to_create-comp_cd = entity-CompCd.
*      ms_root_to_create-purch_org = entity-PurchOrg.
*      ms_root_to_create-supplier_no = entity-SupplierNo.
**      if entity-SuppliNo is NOT INITIAL.
*      ms_root_to_create-docno = entity-SupplierNo.
**      endif.
*      ms_root_to_create-changed_at = entity-ChangedAt.
*      ms_root_to_create-created_at = entity-CreatedAt.
*      ms_root_to_create-created_by = entity-CreatedBy.
*      INSERT CORRESPONDING #( entity ) INTO TABLE mapped-_header.
*      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_root_to_create.
*
*
*    ENDLOOP.
*
*    DATA(lv_sup) = entities[ 1 ]-SupplierNo.
*    IF lv_sup IS INITIAL.
*      DATA(lv_error_text) = 'Supplier is not filed it'.
*
*      APPEND VALUE #( %cid        = entity-%cid
*                     %key        = entity-%key
*                     %create     = if_abap_behv=>mk-on
*                     %fail-cause = if_abap_behv=>cause-unspecific
*                 ) TO failed-_header.
*
*      APPEND VALUE #( %cid      = entity-%cid
*                      %key      = entity-%key
*                      %create   = if_abap_behv=>mk-on
*                      %msg      = new_message_with_text(
*                      severity  = if_abap_behv_message=>severity-error
*                      text      = lv_error_text )
*                  ) TO reported-_header.
*
*    ELSE.
*      SELECT SINGLE @abap_true
*         FROM ztm_header_11563
*         WHERE docno = @lv_sup
*         INTO @DATA(exists).
*      IF exists = abap_true.
*        lv_error_text = 'Document number already created'.
*
*        APPEND VALUE #( %cid        = entity-%cid
*                       %key        = entity-%key
*                       %create     = if_abap_behv=>mk-on
*                       %fail-cause = if_abap_behv=>cause-unspecific
*                   ) TO failed-_header.
*
*        APPEND VALUE #( %cid      = entity-%cid
*                        %key      = entity-%key
*                        %create   = if_abap_behv=>mk-on
*                        %msg      = new_message_with_text(
*                        severity  = if_abap_behv_message=>severity-error
*                        text      = lv_error_text )
*                    ) TO reported-_header.
*
*      ENDIF.
*    ENDIF.
  ENDMETHOD.

  METHOD update.

zcl_crud_header_um=>get_instance(  )->update(
  EXPORTING
    entities = entities
  CHANGING
    mapped   = mapped
    failed   = failed
    reported = reported
).
**  DATA(lv_docno) = entities[ 1 ].
**select * from ztm_header_11563  where docno = @lv_docno-Docno
**into table @data(lt_header) .
**.
**
**  loop at entities assigning field-SYMBOL(<ls_entity>).
**
**  if <ls_entity>-%control-Status is NOT INITIAL.
**    lv_docno-Status =   <ls_entity>-Status.
**  endif.
**
**  if <ls_entity>-%control-SupplierNo is not INITIAL.
**  lv_docno-SupplierNo =   <ls_entity>-SupplierNo.
**  endif.
**
**   if <ls_entity>-%control-ChangedAt is not INITIAL.
**  lv_docno-ChangedAt =   <ls_entity>-ChangedAt.
**  endif.
**
**   if <ls_entity>-%control-CompCd is not INITIAL.
**  lv_docno-CompCd =   <ls_entity>-CompCd.
**  endif.
**
**   if <ls_entity>-%control-CreatedAt is not INITIAL.
**  lv_docno-CreatedAt =   <ls_entity>-CreatedAt.
**  endif.
**
**   if <ls_entity>-%control-CreatedBy is not INITIAL.
**  lv_docno-CreatedBy =   <ls_entity>-CreatedBy.
**  endif.
**
**   if <ls_entity>-%control-SupplierNo is not INITIAL.
**  lv_docno-SupplierNo =   <ls_entity>-SupplierNo.
**  endif.
**
**MODIFY  ztm_header_11563 FROM TABLE   @lhc_z_int_header_11563=>mt_root_to_create .
**
**  endloop.

  ENDMETHOD.

  METHOD delete.

*     LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
*      ms_del-docno = <ls_del>-DocNo.
*      INSERT CORRESPONDING #( ms_DEL ) INTO TABLE mt_root_to_DELETE.
*    ENDLOOP.
zcl_crud_header_um=>get_instance(  )->delete(
  EXPORTING
    keys     =  keys
  CHANGING
    mapped   = mapped
    failed   = failed
    reported = reported
).
  ENDMETHOD.

  METHOD read.
  "---Read Data

  zcl_crud_header_um=>get_instance(  )->read_data(
    EXPORTING
      keys     =  keys
    CHANGING
      result   = result
      failed   = failed
      reported = reported
  ).

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Item.
  ENDMETHOD.

  METHOD cba_Item.

*  DATA: ls_item TYPE ztd_item_11563.
*    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<lfs_item>) .
*      LOOP AT <lfs_item>-%target ASSIGNING FIELD-SYMBOL(<fs_item>).
*        MOVE-CORRESPONDING <fs_item> TO ls_item.
*
*        ls_item-docno = <lfs_item>-DocNo.
*        ls_item-item_no = <fs_item>-ItemNo.
*        ls_item-tax_amt = <fs_item>-TaxAmt.
*
*        ls_item-changed_at = <fs_item>-ChangedAt.
*        ls_item-created_at = <fs_item>-CreatedAt.
*        ls_item-created_by = <fs_item>-CreatedBy.
*        APPEND ls_item TO mt_item.
*      ENDLOOP.
*    ENDLOOP.

  ENDMETHOD.



ENDCLASS.

CLASS lhc_Z_INT_ITEM_11563 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE z_int_item_11563.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE z_int_item_11563.

    METHODS read FOR READ
      IMPORTING keys FOR READ z_int_item_11563 RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ z_int_item_11563\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Z_INT_ITEM_11563 IMPLEMENTATION.

  METHOD update.


  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_INT_HEADER_11563 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_INT_HEADER_11563 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
*    IF lhc_z_int_header_11563=>mt_root_to_create IS NOT INITIAL.
*      MODIFY ztm_header_11563 FROM TABLE @lhc_z_int_header_11563=>mt_root_to_create.
*    ENDIF.
*
*    IF lhc_z_int_header_11563=>mt_item IS NOT INITIAL.
*      MODIFY ztd_item_11563 FROM TABLE @lhc_z_int_header_11563=>mt_item.
*
*    ENDIF.
*
*    IF lhc_z_int_header_11563=>mt_root_to_delete IS NOT INITIAL.
*      DELETE ztm_header_11563 FROM TABLE @lhc_z_int_header_11563=>mt_root_to_delete.
*      DELETE ztd_item_11563 FROM TABLE @lhc_z_int_header_11563=>mt_root_to_delete.
*
*    ENDIF.

zcl_crud_header_um=>get_instance(  )->savedata(
  CHANGING
    reported = reported
).



  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
