class ZCL_IA_2ORDER_UTILS definition
  public
  final
  create public .

public section.

  types:
    tt_2_c_eiz TYPE STANDARD TABLE OF zia_2c_eiz WITH DEFAULT KEY .
  types:
    BEGIN OF ts_notif_head,
        qmtxt TYPE qmtxt,
        qmart TYPE qmart,
        aufnr TYPE aufnr,
        iwerk TYPE iwerk,
        strmn TYPE strmn,
        ltrmn TYPE ltrmn,
        auart TYPE auart,
        ilart TYPE ila,
        qmnum TYPE qmnum,
      END OF ts_notif_head .

  class-data MV_REAL_MEMORY_FLAG type CHAR20 value 'ZIO_3_REAL_NO_EXIT' ##NO_TEXT.
  constants MC_WORKCENTER_CH type GEWRK value 'CH' ##NO_TEXT.

  class-methods CHANGE_USER_STATUS
    importing
      !IO_AUFTRAEGE type ref to CL_OBJECT_MAP
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT
      !IV_STATUS type J_TXT04 optional
      !IV_ARBZEIT_UPD type ABAP_BOOL default ABAP_TRUE
      !IV_TEST_RUN type ABAP_BOOL default ABAP_FALSE
    raising
      ZCX_IA_2FAILURE .
  class-methods CREATE_BACKUP
    importing
      !IO_AUFTRAEGE type ref to CL_OBJECT_MAP optional
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT optional
      !IT_AUFK type TT_AUFK optional .
  class-methods CREATE_SRULE .
  class-methods GET_AUFK
    importing
      !IO_AUFTRAEGE type ref to CL_OBJECT_MAP
    returning
      value(RT_DATA) type TT_AUFK .
  class-methods GET_CUST_EIZ
    importing
      !IV_ARBPL type ARBPL optional
      !IV_WERKS type WERKS_D optional
    returning
      value(RT_DATA) type TT_2_C_EIZ .
  class-methods CREATE_SHIFT_ORDER
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT .
  class-methods GET_NOTIFICATION_DATA
    importing
      !IV_SHIFT type QMNUM
    returning
      value(RS_NOTIF_DATA) type TS_NOTIF_HEAD .
  class-methods GET_ACTIVITY_TYPE
    importing
      !IV_AUART type AUART
    returning
      value(RV_ILART) type ILA .
  class-methods SET_ORSC_STATUS
    importing
      !IO_AUFTRAEGE type ref to CL_OBJECT_MAP
    raising
      ZCX_IA_2FAILURE .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA mt_cust_eiz TYPE tt_2_c_eiz .
ENDCLASS.



CLASS ZCL_IA_2ORDER_UTILS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>CHANGE_USER_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAEGE                   TYPE REF TO CL_OBJECT_MAP
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* | [--->] IV_STATUS                      TYPE        J_TXT04(optional)
* | [--->] IV_ARBZEIT_UPD                 TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] IV_TEST_RUN                    TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_user_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : CHANGE_USER_STATUS
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*


    CONSTANTS:
      lc_change_event_change TYPE char2 VALUE '02',     " USER STATUS CHANGE
      lc_method_save         TYPE char10 VALUE 'SAVE', " FINALIZE
      lc_msgtype_error       TYPE symsgty VALUE 'E',
      lc_msgtype_abort       TYPE symsgty VALUE 'A',
      lc_msgtype_system      TYPE symsgty VALUE 'X'.


    " DECLARE INTERNAL TABLES AND VARIABLES USED IN THE PROCESS
    DATA(lt_status)       = VALUE bapi_alm_order_usrstat_t( ).  " STORES USER STATUS INFORMATION
    DATA(lt_user_status)       = VALUE bapi_alm_order_usrstat_t( ).  " STORES USER STATUS INFORMATION
    DATA(lt_methods)    = VALUE bapi_alm_order_method_t( ).    " STORES METHOD DETAILS FOR BAPI
    DATA(lt_return)     = VALUE bapiret2_t( ).                 " RETURN TABLE TO CAPTURE BAPI RESPONSE
    DATA(lv_index)      = VALUE syindex( ).                    " INDEX FOR THE METHOD REFERENCE

    " DEFINE FIXED PHASES FOR MAINTENANCE
    DATA lv_maintordovrlprocphase TYPE eam_ostat_phase VALUE '06'.
    DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase VALUE '0060'.
    ##NEEDED  DATA: lv_prio          TYPE priok,
    ##NEEDED        lv_objnr         TYPE jsto-objnr,
  ##NEEDED          lv_target_txt04  TYPE tj02t-txt04,   " TARGET TXT04 (PL1/PL2)
    ##NEEDED        lv_status_number TYPE jest-stat,
    ##NEEDED        lv_user_line     TYPE bsvx-sttxt.
    " UPDATE FAFIH TABLE
    ##NEEDED  DATA: ls_order_update TYPE ko99_pm_order_update,
    ##NEEDED        lt_order_update TYPE TABLE OF ko99_pm_order_update.

    " DECLARE ORDER DATA AND RELATED TABLES FOR UPDATES
    DATA(lt_aufk)  = get_aufk( io_auftraege ).  " GET ORDER DATA (AUFTRAG)
    DATA(lt_eiz)   = get_cust_eiz( ).            " GET CUSTOMER-SPECIFIC DATA
    DATA(lo_arbeitsstellen) = CAST cl_object_map( io_schicht->get_arbeitsstellen( ) ).  " ARBEITSSTELLEN DATA
    DATA(lo_auftraege_i)    = CAST cl_object_collection_iterator( io_auftraege->get_values_iterator( ) ).  " ITERATE OVER ORDERS

    " LOOP THROUGH EACH ORDER IN THE COLLECTION AND PROCESS USER STATUS
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      DATA(lo_auftrag) = CAST zcl_ia_2order( lo_auftraege_i->get_next( ) ).  " GET CURRENT ORDER
*    lv_index = lv_index + 1.  " INCREMENT THE METHOD REFERENCE INDEX

      TRY.
          " FETCH ASSOCIATED ORDER DATA AND CALCULATE RELEVANT VALUES
          DATA(ls_aufk) = lt_aufk[ aufnr = CONV aufnr( lo_auftrag->get_id( ) ) ].  " GET SPECIFIC ORDER DATA
          DATA(lv_eiz) = zcl_ia_2utilities2=>get_eiz_by_wctr( iv_arbpl = ls_aufk-vaplz iv_werks = ls_aufk-werks ).  " GET EIZ BY WORK AREA
          ##NEEDED        DATA(lv_team_arbpl) = lt_eiz[ arbpl = ls_aufk-vaplz eiz = lv_eiz ]-team_arbpl.  " GET TEAM WORK AREA
        CATCH cx_sy_itab_line_not_found.
          CLEAR lv_team_arbpl.  " IN CASE OF ERROR, CLEAR THE TEAM WORK AREA
      ENDTRY.

      " GET THE WORKING HOURS FOR THE ASSIGNED WORKPLACE
      DATA(lo_arbstl) = CAST zcl_ia_2wrkplace( lo_arbeitsstellen->get( key = lo_auftrag->get_data( )-zarbstl ) ).  " GET WORK AREA DETAILS
      ##NEEDED    DATA(ls_arbszeit) = lo_arbstl->get_arbeitszeit( ).  " GET WORKING HOURS



      " SET THE STATUS FOR THE ORDER WITH DYNAMIC SYSTEM LANGUAGE
      lt_status = VALUE #( BASE lt_status
                           ( langu        = 'D'
                             langu_iso    = 'DE'
                             user_st_text = 'PL1'      " STATUS DESCRIPTION
                             change_event = lc_change_event_change
                             inactive     = 'X' ) ).        " CHANGE EVENT FOR USER STATUS

      lt_status = VALUE #( BASE lt_status
                           ( langu        = 'D'
                             langu_iso    = 'DE'
                             user_st_text = iv_status  " STATUS DESCRIPTION
                             change_event = lc_change_event_change ) ).    " CHANGE EVENT FOR USER STATUS

*    CLEAR lv_index.
      ##NEEDED    LOOP AT lt_status INTO DATA(ls_data).

        lv_index = lv_index + 1.
        " PREPARE METHOD CALL FOR BAPI_ALM_ORDER_MAINTAIN
        lt_methods = VALUE #( BASE lt_methods
                              ( objectkey  = lo_auftrag->get_id( )  " ORDER ID
                                refnumber  = lv_index          " REFERENCE NUMBER
                                objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-userstatus  " OBJECT TYPE FOR USER STATUS
                                method     = if_eams_bo_const=>gc_bapi_ord_method-change ) ).     " METHOD TO CHANGE USER STATUS
        APPEND ls_data TO lt_user_status.
      ENDLOOP.
      CLEAR lt_status.

      " FINALIZE METHOD CALL WITH SAVE METHOD FOR THIS ORDER
      lt_methods = VALUE #( BASE lt_methods ( refnumber = 1 method = lc_method_save ) ).  " FINAL SAVE METHOD FOR BAPI

      " CALL BAPI TO MAINTAIN THE ORDER WITH THE UPDATED STATUS AND METHODS
      CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
        TABLES
          it_methods    = lt_methods   " PASS METHODS FOR THE OPERATION
          it_userstatus = lt_user_status    " PASS USER STATUS UPDATES
          return        = lt_return.   " CAPTURE THE BAPI RETURN MESSAGE

      " HANDLE BAPI TRANSACTION BASED ON RETURN MESSAGES
      IF NOT line_exists( lt_return[ type = lc_msgtype_error  ] ) AND
         NOT line_exists( lt_return[ type = lc_msgtype_abort ] ) AND
         NOT line_exists( lt_return[ type = lc_msgtype_system ] ) AND
         iv_test_run = abap_false.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'  " COMMIT THE TRANSACTION FOR THIS ORDER
          EXPORTING
            wait = abap_true.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.  " ROLLBACK THE TRANSACTION IN CASE OF ERROR
        IF lt_return IS NOT INITIAL.
          RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.  " RAISE AN EXCEPTION IF RETURN CONTAINS ERRORS
        ENDIF.
      ENDIF.

      " CLEAR FOR NEXT ORDER
      CLEAR: lt_methods, lt_user_status, lt_return, lv_index.
    ENDWHILE.

****  FINALIZE METHOD CALL WITH SAVE METHOD FOR ALL ORDERS
***  lt_methods = VALUE #( BASE lt_methods ( refnumber = 1 method = lc_method_save ) ).  " FINAL SAVE METHOD FOR BAPI
***
***  " CALL BAPI TO MAINTAIN THE ORDER WITH THE UPDATED STATUS AND METHODS
***  CALL-FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
***    TABLES
***      it_methods    = lt_methods   " PASS METHODS FOR THE OPERATION
***      it_userstatus = lt_user_status    " PASS USER STATUS UPDATES
***      return        = lt_return.   " CAPTURE THE BAPI RETURN MESSAGE
***
***  " HANDLE BAPI TRANSACTION BASED ON RETURN MESSAGES
***  IF NOT line_exists( lt_return[ type = lc_msgtype_error  ] ) AND
***     NOT line_exists( lt_return[ type = lc_msgtype_abort ] ) AND
***     NOT line_exists( lt_return[ type = lc_msgtype_system ] ) AND
***     iv_test_run = abap_false.
***
***    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'  " COMMIT THE TRANSACTION IF NO ERRORS
***      EXPORTING
***        wait = abap_true.
    zcl_ia_2order_utils=>create_backup( io_auftraege = io_auftraege io_schicht = io_schicht it_aufk = lt_aufk ).  " CREATE BACKUP AFTER COMMIT
    " UPDATING PHASE
    zcl_ia_2utilities=>update_maint_ord_phase( it_order                    = lt_aufk
                                               iv_maintordovrlprocphase    = lv_maintordovrlprocphase
                                               iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
***  ELSE.
***    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.  " ROLLBACK THE TRANSACTION IN CASE OF ERROR
***    IF lt_return IS NOT INITIAL.
***      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.  " RAISE AN EXCEPTION IF RETURN CONTAINS ERRORS
***    ENDIF.
***  ENDIF.

    " UPDATE WORKING TIMES FOR THE ORDER IF REQUIRED
    IF iv_arbzeit_upd = abap_true AND iv_test_run = abap_false.
      lo_auftraege_i = CAST cl_object_collection_iterator( io_auftraege->get_values_iterator( ) ).
      WHILE lo_auftraege_i->has_next( ) = abap_true.
        lo_auftrag = CAST zcl_ia_2order( lo_auftraege_i->get_next( ) ).
        lo_arbstl  = CAST zcl_ia_2wrkplace( lo_arbeitsstellen->get( key = lo_auftrag->get_data( )-zarbstl ) ).
*      lo_auftrag->set_arbstl_arbeitszeit( io_arbstl = lo_arbstl ).
      ENDWHILE.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>CREATE_BACKUP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAEGE                   TYPE REF TO CL_OBJECT_MAP(optional)
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT(optional)
* | [--->] IT_AUFK                        TYPE        TT_AUFK(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_backup.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       17.09.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_auftraege   TYPE REF TO cl_object_map.
    DATA(lt_backup)   = VALUE zia_2_order_bup_t( ).
    DATA(lt_aufk)     = VALUE tt_aufk( ).

    IF io_auftraege IS SUPPLIED.
      lo_auftraege = io_auftraege.
    ELSEIF io_auftrag IS SUPPLIED.
      lo_auftraege = NEW cl_object_map( ).
      lo_auftraege->put( EXPORTING key = io_auftrag->get_id( ) value = io_auftrag ).
    ELSE.
      RETURN.
    ENDIF.

    IF it_aufk IS SUPPLIED.
      lt_aufk = it_aufk.
    ELSE.
      lt_aufk = get_aufk( lo_auftraege ).
    ENDIF.

    DATA(lo_auftraege_i)  = CAST cl_object_collection_iterator( io_auftraege->get_values_iterator( ) ).
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      DATA(lo_auftrag) = CAST zcl_ia_2order( lo_auftraege_i->get_next( ) ).

      TRY.
          DATA(ls_aufk) = lt_aufk[ aufnr  = CONV aufnr( lo_auftrag->get_id( ) ) ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR ls_aufk.
      ENDTRY.

      DATA(lv_zschicht) = COND #( WHEN lo_auftrag->get_data( )-zschicht IS NOT INITIAL THEN lo_auftrag->get_data( )-zschicht
                                  WHEN io_schicht IS BOUND THEN io_schicht->get_id( ) ).
      lt_backup = VALUE #( BASE lt_backup
                                ( aufnr    = CONV aufnr( lo_auftrag->get_id( ) )
                                  zschicht = lv_zschicht
                                  gltrp    = lo_auftrag->get_data( )-gltrp
                                  gluzp    = lo_auftrag->get_data( )-gluzp
                                  gstrp    = lo_auftrag->get_data( )-gstrp
                                  gsuzp    = lo_auftrag->get_data( )-gsuzp
                                  arbpl    = ls_aufk-vaplz )
                          ).
    ENDWHILE.

    MODIFY zia_2order_bup FROM TABLE lt_backup.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>CREATE_SRULE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
 ##NEEDED  METHOD create_srule.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>GET_AUFK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAEGE                   TYPE REF TO CL_OBJECT_MAP
* | [<-()] RT_DATA                        TYPE        TT_AUFK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_aufk.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AUFK
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_aufnr) = VALUE aufnr_t( ).

    lt_aufnr = io_auftraege->get_keys( ).
    IF lt_aufnr IS NOT INITIAL.
      SELECT aufnr, werks, vaplz
*        FROM aufk
        FROM aufkv
        INTO CORRESPONDING FIELDS OF TABLE @rt_data ##TOO_MANY_ITAB_FIELDS
        FOR ALL ENTRIES IN @lt_aufnr
        WHERE aufnr =  @lt_aufnr-aufnr.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>GET_CUST_EIZ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ARBPL                       TYPE        ARBPL(optional)
* | [--->] IV_WERKS                       TYPE        WERKS_D(optional)
* | [<-()] RT_DATA                        TYPE        TT_2_C_EIZ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cust_eiz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_CUST_EIZ
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lt_arbpl_rng  TYPE RANGE OF arbpl.
    DATA lt_werks_rng  TYPE RANGE OF werks_d.

    IF iv_arbpl IS SUPPLIED.
      lt_arbpl_rng = VALUE #( ( sign = 'I' option = 'EQ' low = iv_arbpl ) ).
    ENDIF.

    IF iv_werks IS SUPPLIED.
      lt_werks_rng = VALUE #( ( sign = 'I' option = 'EQ' low = iv_werks ) ).
    ENDIF.

    IF mt_cust_eiz IS INITIAL.
      SELECT arbpl, werks, eiz, team_arbpl, werks_log
        FROM zia_2c_eiz
        INTO CORRESPONDING FIELDS OF TABLE @mt_cust_eiz  ##TOO_MANY_ITAB_FIELDS
        WHERE arbpl IN @lt_arbpl_rng AND
              werks IN @lt_werks_rng.
    ENDIF.
    rt_data =  mt_cust_eiz.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>CREATE_SHIFT_ORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_shift_order.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Get Shift order
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_header)     = VALUE bapi_alm_order_headers_i_t( ).
    DATA(lt_header_up)  = VALUE bapi_alm_order_headers_i_ut( ).
*    DATA(lt_status)     = VALUE bapi_alm_order_usrstat_t( ).
    DATA(lt_methods)    = VALUE bapi_alm_order_method_t( ).
    DATA(lt_return)     = VALUE bapiret2_t( ).
    ##NEEDED    DATA(lv_index)      = VALUE syindex( ).
    ##NEEDED    DATA lv_mem_clear     TYPE  char1 VALUE 0.
    DATA(lt_operations) = VALUE bapi_alm_order_operation_t( ).

    " select shift data
    DATA(ls_shift_data) = io_schicht->get_data( ).

    " Select Notification Data and Order Type (JOIN)
    DATA(ls_notif_head) =  get_notification_data( iv_shift = ls_shift_data-zschicht ).

    " If the order exists, stop
    CHECK ls_notif_head-aufnr IS INITIAL.

    " Select Activity Type (ILART) based on Order Type (AUART)
    " Fill Maintenance activity type
    ls_notif_head-ilart =  get_activity_type( iv_auart = ls_notif_head-auart  ).

    " Prepare header data for the BAPI
    APPEND VALUE #(
*      orderid    = '%00000000001' && ls_shift_data-zschicht
      orderid    = |{ '%00000000001' && ls_shift_data-zschicht }|
      order_type = ls_notif_head-auart
      pmacttype  = ls_notif_head-ilart
      short_text = ls_notif_head-qmtxt
*      Notif_no   = ls_shift_data-zschicht
      planplant  = ls_notif_head-iwerk
      mn_wk_ctr  = mc_workcenter_ch
      plant      = ls_notif_head-iwerk
      maintplant = ls_notif_head-iwerk
      start_date = ls_notif_head-strmn
      finish_date = ls_notif_head-ltrmn
    ) TO lt_header.

    " Append methods to lt_methods (create notification, change user status, save)
    APPEND VALUE #(
      refnumber  = 1
      objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
      method     = if_eams_bo_const=>gc_bapi_ord_method-create_notif
      objectkey  = |{ '%00000000001' && ls_shift_data-zschicht }|
    ) TO lt_methods.

*    APPEND VALUE #(
*     refnumber = 1
*     objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-userstatus
*     method = if_eams_bo_const=>gc_bapi_ord_method-change
*     objectkey = |{ '%00000000001' }|
*   ) TO lt_methods.

    APPEND VALUE #(
     refnumber  = 1
     objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
     method     = if_eams_bo_const=>gc_bapi_ord_method-create
     objectkey  = |{ '%00000000001' && ls_shift_data-zschicht }|
   ) TO lt_methods.

    APPEND VALUE #(
      refnumber = 1
      objecttype = space
      method = if_eams_bo_const=>gc_bapi_ord_method-save
      objectkey = |{ '%00000000001' && ls_shift_data-zschicht }|
    ) TO lt_methods.

*    " Prepare User Status Data
*    APPEND VALUE #(
*      user_st_text = 'PL1'
*      langu        = sy-langu
*      inactive     = 'X'
*    ) TO lt_status.
*
*    APPEND VALUE #(
*      user_st_text = 'PL2'
*      langu        = sy-langu
*    ) TO lt_status.

    " Prepare Operations Data (linking activity type, work center, etc.)

    APPEND VALUE #(
      activity    = '0010'
      control_key = 'PM01'
      work_cntr   = mc_workcenter_ch
      plant       = ls_notif_head-iwerk
      description = ls_notif_head-qmtxt
    ) TO lt_operations.

    APPEND VALUE #(
       notif_no = abap_true
      ) TO lt_header_up.


    " Call the BAPI to create the order
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods   = lt_methods
        it_header    = lt_header
        it_header_up = lt_header_up
*       it_userstatus = lt_status
        it_operation = lt_operations
        return       = lt_return.

    IF NOT line_exists( lt_return[ type = 'E' ] ) AND
       NOT line_exists( lt_return[ type = 'A' ] ) AND
       NOT line_exists( lt_return[ type = 'X' ] ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      IF lt_return IS NOT INITIAL.
        RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>GET_ACTIVITY_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUART                       TYPE        AUART
* | [<-()] RV_ILART                       TYPE        ILA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_activity_type.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Get activity type
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Select Activity Type (ILART) based on Order Type (AUART)
    SELECT SINGLE ilart ##WARN_OK
        INTO @rv_ilart
        FROM t350i
        WHERE auart = @iv_auart.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>GET_NOTIFICATION_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        QMNUM
* | [<-()] RS_NOTIF_DATA                  TYPE        TS_NOTIF_HEAD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_notification_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Get Notification data based on shift
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Select Notification Data and Order Type in one query (JOIN)
    SELECT SINGLE v~qmtxt, v~qmart, v~aufnr, v~iwerk, v~strmn, v~ltrmn, t~auart, v~qmnum ##WARN_OK
         INTO @rs_notif_data
         FROM viqmel AS v
         INNER JOIN tq80 AS t ON t~qmart = v~qmart     "#EC CI_BUFFJOIN
        WHERE v~qmnum = @iv_shift.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2ORDER_UTILS=>SET_ORSC_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAEGE                   TYPE REF TO CL_OBJECT_MAP
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_orsc_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : SET_ORSC_STATUS
*----------------------------------------------------------------------*
* >000<   7.50       15.07.2026     TCS / mod-orsc-001
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*         When shift is released for Disposition (subphase 0060 = OK):
*           - Activate system status ORSC (IEAM5) on order header and
*             every operation.
*           - Deactivate system status IEAMP (PWF) on every operation.
*         Uses standard EAM status manager CL_EAML_SM_OBJECT_MANAGER
*         directly (not ZCL_IA_2MO_PM_STATUS_CHANGE->UPDATE_ORSC_DSPT,
*         which has an unrelated side effect on ZSE_1IMP_EXP).
*         Header + operation OBJNRs come from CDS views
*         I_MAINTENANCEORDER + I_MAINTORDEROPERANDSUBOPER in a single
*         SELECT (same pattern as ZCL_IA_20005_AI=>GET_DATA).
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  DATA: lt_return TYPE bapirettab,
        lv_error  TYPE abap_bool.

  DATA(lo_auftraege_i) = CAST cl_object_collection_iterator( io_auftraege->get_values_iterator( ) ).

  WHILE lo_auftraege_i->has_next( ) = abap_true.

    DATA(lo_auftrag)     = CAST zcl_ia_2order( lo_auftraege_i->get_next( ) ).
    DATA(lv_aufnr)       = CONV aufnr( lo_auftrag->get_id( ) ).
    DATA(lv_order_error) = abap_false.

    " 1. Prepare EML Action Request for single order
    DATA: lt_keys TYPE TABLE FOR ACTION IMPORT r_maintenanceordertp\\order~setreadyforscheduling.
    lt_keys = VALUE #( ( %tky-maintenanceorder = lv_aufnr ) ).

    " 2. Execute Action via RAP EML inside the loop
    MODIFY ENTITIES OF r_maintenanceordertp ##EML_IN_LOOP_OK
      ENTITY order
      EXECUTE setreadyforscheduling FROM lt_keys
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    " 3. Map EML %msg instances to BAPIRET2 using <LS_REPORTED_ORDER>
    LOOP AT ls_reported-order ASSIGNING FIELD-SYMBOL(<ls_reported_order>).
      IF <ls_reported_order>-%msg IS BOUND.
        DATA(ls_return) = VALUE bapiret2(
          id         = <ls_reported_order>-%msg->if_t100_message~t100key-msgid
          number     = <ls_reported_order>-%msg->if_t100_message~t100key-msgno
          type       = COND #( WHEN <ls_reported_order>-%msg->m_severity IS INITIAL THEN 'E'
                               ELSE CONV #( <ls_reported_order>-%msg->m_severity ) ) ##TYPE
          message_v1 = <ls_reported_order>-%msg->if_t100_dyn_msg~msgv1
          message_v2 = <ls_reported_order>-%msg->if_t100_dyn_msg~msgv2
          message_v3 = <ls_reported_order>-%msg->if_t100_dyn_msg~msgv3
          message_v4 = <ls_reported_order>-%msg->if_t100_dyn_msg~msgv4
        ).

        ls_return-message = <ls_reported_order>-%msg->if_message~get_text( ).
        APPEND ls_return TO lt_return.

        IF ls_return-type CA 'EA'.
          lv_order_error = abap_true.
          lv_error       = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF ls_failed IS NOT INITIAL.
      lv_order_error = abap_true.
      lv_error       = abap_true.
      " Fallback: Construct explicit message if FAILED has entries but REPORTED was empty
      IF ls_reported-order IS INITIAL.
        LOOP AT ls_failed-order ASSIGNING FIELD-SYMBOL(<ls_failed_order>).
          DATA(lv_cause_text) = SWITCH string( <ls_failed_order>-%fail-cause
            WHEN if_abap_behv=>cause-disabled     THEN 'Action is disabled for this order (check MANC/Status)'
            WHEN if_abap_behv=>cause-not_found    THEN 'Order key not found'
            WHEN if_abap_behv=>cause-unauthorized THEN 'No authorization for order action'
            ELSE 'Action failed due to BO state constraint' ).
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = 'IWD'
            number     = '000'
            message_v1 = CONV #( lv_aufnr )
            message    = |Order { lv_aufnr }: { lv_cause_text }|
          ) TO lt_return.
        ENDLOOP.
      ENDIF.
    ENDIF.

    " 4. Commit or Rollback PER ORDER to isolate the transactional buffer
    IF lv_order_error = abap_false.
      COMMIT ENTITIES.
      COMMIT WORK.
    ELSE.
      ROLLBACK ENTITIES.
      ROLLBACK WORK.
    ENDIF.

  ENDWHILE.

  " 5. Raise Exception at end if any order encountered errors
  IF lv_error = abap_true OR line_exists( lt_return[ type = 'E' ] )
                          OR line_exists( lt_return[ type = 'A' ] ).
    RAISE EXCEPTION TYPE zcx_ia_2failure
      EXPORTING
        gt_bapiret = lt_return.
  ENDIF.

ENDMETHOD.
ENDCLASS.