class ZCL_IA_2LOFPM_CLH_WD_ASSIST definition
  public
  inheriting from CL_WD_COMPONENT_ASSISTANCE
  create public .

public section.

  types:
    TT_ZIA_2SF_VEH_SEATS TYPE STANDARD TABLE OF zia_2sf_veh_seat .
  types:
    BEGIN OF ts_qual_tff,
        wa_id TYPE char12,
        qual  TYPE zia_2sf_veh_seat,
      END OF ts_qual_tff .
  types:
    tt_qual_tff TYPE STANDARD TABLE OF ts_qual_tff WITH DEFAULT KEY .
  types:
    BEGIN OF ts_order_comp,
        aufnr       TYPE aufnr,
        start_datum TYPE zia_2_pm_ordgstrp,
        start_zeit  TYPE zia_2_co_gsuzp,
        reserv_no   TYPE rsnum,
        res_item    TYPE rspos,
        fzg_belad   TYPE char6,
      END OF ts_order_comp .
  types:
    tt_order_comp TYPE STANDARD TABLE OF ts_order_comp WITH DEFAULT KEY .
  types:
    BEGIN OF ts_zia_2sf_veh_seat,
        zid_fzg_platz TYPE zia_2_id_vehicle_slot,
        uname         TYPE uname,
      END OF ts_zia_2sf_veh_seat .
  types:
    tt_zia_2sf_veh_seat TYPE STANDARD TABLE OF ts_zia_2sf_veh_seat WITH DEFAULT KEY .
  types:
    tt_zia_2order_cap TYPE STANDARD TABLE OF zia_2order_cap WITH DEFAULT KEY .
  types:
    tt_orders TYPE STANDARD TABLE OF zia_2order WITH DEFAULT KEY .
  types:
    tt_zia_2veh_typ_sp TYPE STANDARD TABLE OF zia_2veh_typ_sp WITH DEFAULT KEY .
  types:
    tt_zia_2cost_blck TYPE STANDARD TABLE OF zia_2cost_blck WITH DEFAULT KEY .
  types:
    tt_zia_2veh_typ_rat TYPE STANDARD TABLE OF zia_2veh_typ_rat  WITH DEFAULT KEY .
  types:
    tt_zia_2sf_veh_cost TYPE STANDARD TABLE OF zia_2sf_veh_cost WITH DEFAULT KEY .
  types:
    tt_zia_2sf_orderstr TYPE STANDARD TABLE OF zia_2sf_orderstr WITH DEFAULT KEY .
  types:
    BEGIN OF ts_auftrag,
        zzperi TYPE zia_2_perimeters,
        matnr  TYPE zia_2mo_actprod,
      END OF ts_auftrag .
  types:
    BEGIN OF ts_map_sp_fztyp,
        zid_fztyp TYPE zia_2_vec_typ_id,
      END OF ts_map_sp_fztyp .
  types:
    tt_map_sp_fztyp TYPE STANDARD TABLE OF ts_map_sp_fztyp WITH DEFAULT KEY .
  types:
    BEGIN OF ts_org_unit,
        zorg_einheit TYPE zia_2_fzg_orgeinheit,
      END OF ts_org_unit .
  types:
    tt_org_unit TYPE STANDARD TABLE OF ts_org_unit WITH DEFAULT KEY .
  types:
    tt_zest_eq TYPE RANGE OF zia_2sc-zest .
  types:
    tt_singal_data TYPE STANDARD TABLE OF zia_2_sp_ehb_wd_s WITH DEFAULT KEY .
  types:
    BEGIN OF ts_aufk_ext_sp,
        z_section TYPE eaml_d_lfe_data-z_section,
      END OF ts_aufk_ext_sp .
  types:
    tt_aufk_ext_sp TYPE STANDARD TABLE OF ts_aufk_ext_sp WITH DEFAULT KEY .
  types:
    tt_rsnum TYPE RANGE OF rsnum .
  types:
    tt_rspos TYPE RANGE OF rspos .
  types:
    tt_rsart TYPE RANGE OF rsart .
  types:
    tt_aufnr TYPE RANGE OF aufnr .
  types:
    tt_jobpool TYPE STANDARD TABLE OF zia_2_jobpool_wd_s WITH DEFAULT KEY .
  types:
    BEGIN OF ts_aufnr_key,
        aufnr TYPE eaml_d_lfe_data-tabkey, " MUST MATCH TABKEY EXACTLY
      END OF ts_aufnr_key .
  types:
    tt_aufnr_key TYPE STANDARD TABLE OF ts_aufnr_key WITH EMPTY KEY .
  types:
    tt_order TYPE STANDARD TABLE OF zia_2_auftr_wd_s WITH DEFAULT KEY .
  types:
    BEGIN OF ts_aufnr_status,
        aufnr     TYPE aufnr,
        tplnr_int TYPE char30,
      END OF ts_aufnr_status .
  types:
    tt_aufnr_status TYPE STANDARD TABLE OF ts_aufnr_status WITH DEFAULT KEY .
  types:
    tt_po_data TYPE STANDARD TABLE OF zia_2_po_data_wd_s WITH DEFAULT KEY .
  types:
    BEGIN OF ts_qmel_data,
        qmnum TYPE qmnum,
        priok TYPE priok,
      END OF ts_qmel_data .
  types:
    tt_qmel_data TYPE STANDARD TABLE OF ts_qmel_data WITH DEFAULT KEY .
  types:
    BEGIN OF ts_objek,
        objek TYPE cuobn,
        aufnr TYPE aufnr,
      END OF  ts_objek .
  types:
    tt_objek  TYPE STANDARD TABLE OF ts_objek  WITH DEFAULT KEY .
  types:
    BEGIN OF ts_inob,
        cuobj TYPE cuobj,
        objek TYPE cuobn,
      END OF  ts_inob .
  types:
    tt_inob  TYPE STANDARD TABLE OF ts_inob  WITH DEFAULT KEY .
  types:
    BEGIN OF ts_objnum,
        objnum TYPE cuobn,
        objek  TYPE cuobn,
      END OF ts_objnum .
  types:
    tt_objnum  TYPE STANDARD TABLE OF ts_objnum  WITH DEFAULT KEY .
  types:
    BEGIN OF ts_ausp,
        objek TYPE cuobn,
        atwrt TYPE atwrt,
      END OF ts_ausp .
  types:
    tt_ausp  TYPE STANDARD TABLE OF ts_ausp  WITH DEFAULT KEY .
  types:
    BEGIN OF ts_qmnum,
        qmnum TYPE qmnum,
      END OF ts_qmnum .
  types:
    tt_qmnum TYPE STANDARD TABLE OF ts_qmnum WITH DEFAULT KEY .
  types:
    BEGIN OF ts_notif_data,
        qmnum TYPE qmnum,
        qmcod TYPE qmcod,
        strmn TYPE strmn,
        strur TYPE strur,
        ltrur TYPE ltrur,
        ltrmn TYPE ltrmn,
        priok TYPE priok,
      END OF ts_notif_data .
  types:
    tt_notif_data TYPE STANDARD TABLE OF ts_notif_data WITH DEFAULT KEY .
  types:
    BEGIN OF ts_data,
        zid_btg TYPE zia_2_id_btg,
        zindex  TYPE zia_2_index,
        zzperi  TYPE zia_2_perimeters,
        zktext  TYPE zia_2_ktext40,
      END OF ts_data .
  types:
    tt_buildings TYPE STANDARD TABLE OF  ts_data WITH DEFAULT KEY .
  types:
    tt_id_arbstl TYPE STANDARD TABLE OF zia_2_id_arbstl WITH DEFAULT KEY .
  types:
    BEGIN OF ts_ventilation,
        zzperi         TYPE zia_2_perimeters,
        lueftung_code  TYPE zia_2_lueftung_code,
        spras          TYPE spras,
        lueftung_bschr TYPE zia_2_lueftung_bschr,
*        lueftung_bschr_ts TYPE zia_2_lueftung_bschr,
        aedat          TYPE aedat,
        aetim          TYPE uzeit,
        aenam          TYPE aenam,
      END OF ts_ventilation .
  types:
    tt_ra_msgty TYPE STANDARD TABLE OF zia_2_lofpm_ra_string_s WITH DEFAULT KEY .
  types:
    tt_planning_log TYPE STANDARD TABLE OF zia_2_planungslog_ext_s WITH DEFAULT KEY .

  methods WEBGUI_SIMPLE_CALL_TRANSACTION
    importing
      !IV_TCODE type TCODE
      !IV_OKCODE type SYUCOMM
      !IV_PARNAM type MEMORYID
      !IV_PARVAL type STRING
      !II_COMP_API type ref to IF_WD_COMPONENT .
  methods SALV_FORMAT_COLUMN
    importing
      !IV_NAME type STRING
      !IV_IMAGE_FIELD type ABAP_BOOL optional
      !IV_IMAGE_SOURCE type STRING optional
      !IV_IMAGE_SOURCE_FIELDNAME type STRING optional
      !IV_LINK_TO_ACTION_FIELD type ABAP_BOOL optional
      !IV_TEXT_SOURCE_FIELDNAME type STRING optional
      !IV_DROPDOWN_BY_KEY_FIELD type ABAP_BOOL optional
      !IV_DROPDOWN_BY_IDX_FIELD type ABAP_BOOL optional
      !IV_GROUPING_ALLOWED type ABAP_BOOL default ABAP_TRUE
      !IV_H_ALIGN type WDUI_TABLE_COLUMN_HALIGN default CL_WD_TABLE_COLUMN=>E_H_ALIGN-AUTO
      !IV_FIXED_POSITION type WDUI_TABLE_COLUMN_FIXED_POS default CL_WD_ABSTR_TABLE_COLUMN=>E_FIXED_POSITION-NOT_FIXED
      !IV_TITLE type STRING optional
      !IV_HIDE type WDY_BOOLEAN optional
      !IV_WIDTH type STRING optional
      !IV_HIERARCHY_COL type ABAP_BOOL optional
      !IO_ALVMODEL type ref to CL_SALV_WD_CONFIG_TABLE
      !IV_TOOLTIP_FIELDNAME type STRING optional
      !IV_LINK_TYPE type WDUI_LINK_TYPE default '00'
      !IV_CAPTION_FIELD type WDY_BOOLEAN optional .
  methods GET_VEHICLE_TYPE_DATA
    returning
      value(RT_FAHRZEUG_TYPE) type ZIA_2_VH_TYPES_WD_T .
  methods GET_VEHICLE_TYPE_TEXT
    importing
      !IV_ZID_FZTYP type ZIA_2VEH_TYP-ZID_FZTYP
    returning
      value(RV_FAHRZEUG_TEXT) type ZIA_2_FZTYP_TXT .
  methods GET_QUALIFIKATION
    importing
      !IV_ZOBJID type CR_OBJID
      !IV_ZOBJTY type CR_OBJTY
    returning
      value(RV_QUALIFIKATION) type ZIA_2_QUALI .
  methods GET_AUFTRAG
    importing
      !IV_AUFNR type AUFNR
    returning
      value(RS_AUFTRAG) type TS_AUFTRAG .
  methods GET_FZ_TYP_LIST
    importing
      !IV_PERI type ZIA_2_PERIMETERS
      !IV_MATNR type ZIA_2VEH_TYP_SP-MATSV
    returning
      value(RT_ID_FZTYP) type TT_MAP_SP_FZTYP .
  methods GET_VEH_TYPE
    importing
      !IV_ID_FZTYP type ZIA_2_VEC_TYP_ID
    returning
      value(RS_FZTYP) type ZIA_2VEH_TYP_S .
  methods GET_RT_DATA
    importing
      !IV_AUFNR type AUFNR
      !IT_AUFNR type AUFNR_T
    returning
      value(RT_DATA) type RESB_T .
  methods GET_RESERV
    returning
      value(RV_KZEAR) type KZEAR .
  methods GET_ORG_UNIT
    returning
      value(RT_DATA) type TT_ORG_UNIT .
  methods GET_SHIFT
    importing
      !IV_QMNUM type ZIA_2_WORKSHIFT
    returning
      value(RS_SHIFT) type ZIA_2WRKSHIFTS .
  methods GET_WORKCENTER
    importing
      !IV_ZOBJID type CR_OBJID optional
      !IV_ZOBJTY type CR_OBJTY optional
      !IV_SHIFT type ZIA_2_WORKSHIFT optional
    returning
      value(RV_WORKCENTER) type ARBPL .
  methods GET_SIGNAL_SECTIONS
    importing
      !IV_KM_BIS type ZIA_2_KM_BIS
      !IV_KM_VON type ZIA_2_KM_VON
      !IV_PERIMTER type ZIA_2_PERIMETERS
      !IT_ZEST_EQ type TT_ZEST_EQ
      !IV_NEED_E type ABAP_BOOL optional
      !IV_NEED_W type ABAP_BOOL optional
    returning
      value(RT_SIGNALSECTIONS) type ZIA_2SC_T .
  methods SELECT_BLOCK_SECTION
    importing
      !IV_AUFNR type AUFNR
    returning
      value(RT_AUFK_EXT_SP) type TT_AUFK_EXT_SP .
  methods GET_RESB_DATA
    importing
      !IT_RSNUM type TT_RSNUM
      !IT_RSPOS type TT_RSPOS
      !IT_RSART type TT_RSART
      !IT_AUFNR type TT_AUFNR
    returning
      value(RS_DATA) type RESB .
  methods GET_JOBPOOL
    importing
      !IV_ID_BTG type ZIA_2_ID_BTG optional
      !IV_PERIM type QMCOD optional
      !IV_SCHICHT_START_DATUM type STRMN optional
      !IV_SCHICHT_START_ZEIT type STRUR optional
      !IV_SCHICHT_END_DATUM type LTRMN optional
      !IV_SCHICHT_END_ZEIT type LTRUR optional
      !IV_MARK type ABAP_BOOL optional
      !IV_ID_EIZ type ZIA_2_ID_EIZ optional
      !IV_SHIFT type QMNUM optional
    returning
      value(RT_JOBPOOL) type TT_JOBPOOL .
  methods GET_BLOCKING_SECTION
    importing
      !IT_AUFNR_KEY type TT_AUFNR_KEY
    returning
      value(RT_AUFK_EXT_SP) type EAML_T_LFE_DATA .
  methods GET_ORDER_DATA
    importing
      !IT_WHERE_CONDITION type STRINGTAB
      !IV_ORDER_BY type STRING
    returning
      value(RT_ORDER) type ZIA_2ORDER_T .
  methods GET_WORKPLACES
    importing
      !IV_ARBSTL type ZIA_2_ID_ARBSTL
    returning
      value(RS_WORKPLACE) type ZIA_2SF_WA .
  methods GET_SIG_SECTIONS
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
      !IV_SHIFT type ZIA_2_WORKSHIFT
    returning
      value(RT_SECTIONS) type ZIA_2_SIGNALUSR_T .
  methods GET_PM_ORDER_STATUS
    importing
      !IT_AUFTRAGE type TT_ORDER
    returning
      value(RT_DATA) type TT_AUFNR_STATUS .
  methods GET_PO_DATA
    importing
      !IV_SHIFT type QMNUM
      !IV_PERI type QMCOD
    returning
      value(RT_LOG_PO_DATA) type TT_PO_DATA .
  methods GET_QMEL_DATA
    importing
      !IV_PERIMETER type ZIA_2_PERIMETERS
      !IV_DATE type STRMN
    returning
      value(RT_QMEL_DATA) type TT_QMEL_DATA .
  methods GET_SIGNSECTIONS
    importing
      !IV_PERI type QMCOD
      !IV_ZEST type ZIA_2_EST_TXT
      !IV_ZSA type ZIA_2_SIGNAL_SECTION optional
    returning
      value(RT_SC) type ZIA_2SC_T .
  methods RUN_COMMIT
    importing
      !IV_COMMIT type BOOLEAN optional .
  methods GET_INOB_DATA
    importing
      !IT_OBJEK type TT_OBJEK
    returning
      value(RT_INOB) type TT_INOB .
  methods GET_AUSP_DATA
    importing
      !IT_OBJNUM type TT_OBJNUM
      !IV_ATINN type ATINN
    returning
      value(RT_AUSP) type TT_AUSP .
  methods GET_WORKSHIFT
    importing
      !IV_END_DATE type DATUM
      !IV_START_DATE type DATUM
      !IV_PERIM type STRING
    returning
      value(RT_SHIFT) type TT_QMNUM .
  methods GET_NOTIF_DATA
    importing
      !IV_PERI type STRING
      !IV_START_SELECTED_DATE type STRMN
      !IV_LAST_SELECTED_DATE type STRMN
    returning
      value(RT_NOTIF_DATA) type TT_NOTIF_DATA .
  methods GET_SIGNALSECTIONS
    importing
      !IV_ZEST type ZIA_2_BLOCKING_SECTION
      !IV_ZSA type ZIA_2_SIGNAL_SECTION
    returning
      value(RS_SECTIONS) type ZIA_2SC_SEQ .
  methods GET_BUILDINGS
    importing
      !IV_PERI type QMCOD optional
    returning
      value(RT_BUILDINGS) type TT_BUILDINGS .
  methods GET_SIGNALS
    importing
      !IV_ZSA type ZIA_2_SIGNAL_SECTION_S
      !IV_ZEST type ZIA_2_BLOCKING_SECTION_S
    returning
      value(RS_SC) type ZIA_2SC_S .
  methods GET_SIGNALSECTIONS1
    importing
      !IV_PERI type QMCOD
    returning
      value(RT_SECTIONS) type ZIA_2_SGNL_SEC_T .
  methods GET_BUILDINGS_GBT
    returning
      value(RT_BUILDINGS) type TT_BUILDINGS .
  methods GET_BUILDINGS_TUNNEL
    importing
      !IV_PERI type QMCOD
    returning
      value(RT_BUILDINGS) type TT_BUILDINGS .
  methods GET_VEHICLE_MATERIAL
    importing
      !IT_ID_ARBSTL type TT_ID_ARBSTL
    returning
      value(RT_VEH_MAT) type ZIA_2MAP_MATFZG_T .
  methods READ_SIGNALABSCHNITTE
    returning
      value(RT_DATA) type ZIA_2_SGNL_SEC_T .
  methods GET_SF_QUALI
    importing
      !IV_SHIFT type ZIA_2_WORKSHIFT
      !IV_ARBPL type ZIA_2_QUALIFICATION
    returning
      value(RS_DATA) type ZIA_2_QUALIFICATION_POPUP_WD_S .
  methods GET_STD_PARA
    importing
      !IS_QUALIFICATION type ZIA_2_QUALIFICATION_POPUP_WD_S
    returning
      value(RS_DATA) type ZIA_2_QUALIFICATION_POPUP_WD_S .
  methods GET_SF_SB_COMM
    importing
      !IV_SHIFT type ZIA_2_WORKSHIFT
    returning
      value(RT_COMMENT_OLD) type ZIA_2DB_COMMENT_T .
  methods GET_VENTILATION_CBT
    importing
      !IV_LUEFTUNG_CODE type ZIA_2_LUEFTUNG_CODE
    returning
      value(RS_VENTILATION) type TS_VENTILATION .
  methods GET_PLANNING_LOG
    importing
      !IT_RA_MSGTY type TT_RA_MSGTY
      !IV_MAX_TREFFER type INTEGER
    returning
      value(RT_PLANLOG) type TT_PLANNING_LOG .
  methods GET_COUNT
    importing
      !IV_PERI type QMCOD
      !IV_SA type ZIA_2_SIGNAL_SECTION
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods DELETE_SIGNAL_SECTIONS
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
      !IV_SHIFT type ZIA_2_WORKSHIFT
      !IT_USER_ADD_SIGNALS type ZIA_2_SIGNALUSR_T .
  methods GET_VENTILATION_GBT
    importing
      !IV_LUEFTUNG_CODE type ZIA_2_LUEFTUNG_CODE
    returning
      value(RS_VENTILATION) type TS_VENTILATION .
  methods COMMIT_PB .
  methods ROLLBACK_ENTITIES .
  methods COMMIT_ENTITIES .
  methods POPULATE_SHIFT_ORDER_DETAILS
    importing
      !IV_SCHICHT type ZIA_2_WORKSHIFT
    exporting
      !EV_SHIFT_AUFNR type QMEL-AUFNR
      !ES_AUFK type AUFK .
  methods GET_SUBPHASE
    importing
      !IV_AUFNR type AUFNR
    returning
      value(RV_SUBPHASE) type STRING .
  class-methods GET_RESULTS
    importing
      !IV_MAINTORDOVRLPROCSUBPHASE type EAM_OSTAT_SPHASE
    returning
      value(RV_STRING) type STRING .
  methods GET_FUNC_LOC_DESCR
    importing
      !IV_TPLNR type TPLNR
    returning
      value(RV_FUNC_TEXT) type PLTXT .
  methods MODIFY_SETTLEMENT_TABLES
    importing
      !IT_ZIA_2SF_ORDERSTR type TT_ZIA_2SF_ORDERSTR
      !IT_ZIA_2SF_VEH_COST type TT_ZIA_2SF_VEH_COST .
  methods POPULATE_VEH_TYP_AND_COST_BLCK
    exporting
      !ET_ZIA_2VEH_TYP_RAT type TT_ZIA_2VEH_TYP_RAT
      !ET_ZIA_2COST_BLCK type TT_ZIA_2COST_BLCK
      !ET_ZIA_2VEH_TYP_SP type TT_ZIA_2VEH_TYP_SP
      !EV_STEUS type ZIA_2MO_FLD_VALUE
      !EV_USE04 type ZIA_2MO_FLD_VALUE
      !EV_USR04 type ZIA_2MO_FLD_VALUE .
  methods POPULATE_WORKCENTERINTERNALID
    importing
      !IV_WORKCENTER type I_WORKCENTER-WORKCENTER
      !IV_PLANT type I_WORKCENTER-PLANT
    exporting
      !EV_WORKCENTERINTERNALID type I_WORKCENTER-WORKCENTERINTERNALID .
  methods POPULATE_ZIA_2ORDER_CAP
    importing
      !IT_ORDERS type TT_ORDERS
    exporting
      !ET_ZIA_2ORDER_CAP type TT_ZIA_2ORDER_CAP
      !ET_ZIA_2SF_VEH_SEAT type TT_ZIA_2SF_VEH_SEAT .
  methods UPDATE_REVISION_NUMBER
    importing
      !IS_ORDER type ZIA_2ORDER
      !IV_REVISION type REVNI .
  methods POPULATE_REVISION_NUMBER
    importing
      !IS_ORDER type ZIA_2ORDER
      !IV_REVISION type REVNI .
  methods CALL_PROGRAM_ZIA_20001_M1
    importing
      !IV_REVISION type REVNI .
  methods UPDATE_COMPONENTS
    importing
      !IT_ORDERS type TT_ORDER_COMP
      !IV_LI type CHAR2 .
  methods UPDATE_ORDER_PHASE_SUBPHASE
    importing
      !IV_ORDER type AUFNR
      !IV_PHASE type EAM_OSTAT_PHASE
      !IV_SUBPHASE type EAM_OSTAT_SPHASE .
  methods UPDATE_OPR_IN_ADMIN_ORDERS
    importing
      !IV_ADMIN_AUFNR type AUFNR
      !IT_QUAL type TT_ZIA_2SF_VEH_SEATS
      !IV_STEUS type ZIA_2MO_FLD_VALUE
      !IV_USE04 type ZIA_2MO_FLD_VALUE
      !IV_USR04 type ZIA_2MO_FLD_VALUE
      !IV_MAINTENANCEPLANNINGPLANT type WERKS_D
      !IV_SHORTTEXT type AUFTEXT
      !IS_SCHICHTDETAILS type ZIA_2_SHIFTPLAN_WD_S .
  methods UPDATE_TFF_IN_SHIFT_ORDER
    importing
      !IV_SHIFT_AUFNR type AUFNR
      !IT_QUAL_TFF type TT_QUAL_TFF
      !IV_STEUS type ZIA_2MO_FLD_VALUE
      !IV_USE04 type ZIA_2MO_FLD_VALUE
      !IV_USR04 type ZIA_2MO_FLD_VALUE
      !IV_MAINTENANCEPLANNINGPLANT type WERKS_D
      !IV_SHORTTEXT type AUFTEXT
      !IS_SCHICHTDETAILS type ZIA_2_SHIFTPLAN_WD_S .
  methods CHANGE_DATES_PLANNING_BUCKET
    importing
      !IV_BUCKET_UUID type SYSUUID_X16
      !IV_ADMIN_AUFNR type AUFNR
      !IV_START_DATE_TIME type TZNTSTMPS
      !IV_END_DATE_TIME type TZNTSTMPS .
  PROTECTED SECTION.
private section.


  data GV_REQUIRED_FIELD_CHECK_ACTIVE type ABAP_BOOL  ##NEEDED.

  methods WEBGUI_GET_URL
    importing
      !IV_TCODE type TCODE
      !IV_OKCODE type SYUCOMM optional
      !IV_PARNAM type MEMORYID optional
      !IV_PARVAL type STRING optional
      !IT_PARAMETERS type TIHTTPNVP optional
    returning
      value(RV_URL) type STRING .
ENDCLASS.



CLASS ZCL_IA_2LOFPM_CLH_WD_ASSIST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->WEBGUI_GET_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TCODE                       TYPE        TCODE
* | [--->] IV_OKCODE                      TYPE        SYUCOMM(optional)
* | [--->] IV_PARNAM                      TYPE        MEMORYID(optional)
* | [--->] IV_PARVAL                      TYPE        STRING(optional)
* | [--->] IT_PARAMETERS                  TYPE        TIHTTPNVP(optional)
* | [<-()] RV_URL                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD webgui_get_url.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : WEBGUI_GET_URL
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       13.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lv_url       TYPE string,
              lv_host      TYPE string,
              lv_port      TYPE string,
              lv_protocol  TYPE string,
*              lv_parameter TYPE string,
              lv_abs_url   TYPE string.

*Call below method to get host and port
    cl_http_server=>if_http_server~get_location(

* Standard als HTTPS definiert 20130219 WFMI2
*     EXPORTING protocol = 'http'   ">001<  (-)

       IMPORTING host = lv_host
              port = lv_port
              out_protocol = lv_protocol ).

* create URL
    CONCATENATE lv_protocol
    '://' lv_host ':' lv_port
    '/sap/bc/gui/sap/its/webgui/?sap-client=' sy-mandt '&sap-theme=sap_corbu' '&~transaction=' iv_tcode
     INTO lv_abs_url.

    IF iv_parnam IS NOT INITIAL.
      CONCATENATE lv_abs_url '&' iv_parnam '=' iv_parval '&~OKCODE=' iv_okcode INTO lv_abs_url.
    ELSEIF it_parameters IS NOT INITIAL.
      FIELD-SYMBOLS: <ls_parameter> LIKE LINE OF it_parameters.
      LOOP AT it_parameters ASSIGNING <ls_parameter>.
        CALL METHOD cl_http_server=>append_field_url
          EXPORTING
            name  = <ls_parameter>-name
            value = <ls_parameter>-value
          CHANGING
            url   = lv_abs_url.
      ENDLOOP.

      IF iv_okcode IS NOT INITIAL.
        CONCATENATE lv_abs_url '&~OKCODE=' iv_okcode INTO lv_abs_url.
      ENDIF.
    ENDIF.

    rv_url = lv_abs_url.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->WEBGUI_SIMPLE_CALL_TRANSACTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TCODE                       TYPE        TCODE
* | [--->] IV_OKCODE                      TYPE        SYUCOMM
* | [--->] IV_PARNAM                      TYPE        MEMORYID
* | [--->] IV_PARVAL                      TYPE        STRING
* | [--->] II_COMP_API                    TYPE REF TO IF_WD_COMPONENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD webgui_simple_call_transaction.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : WEBGUI_SIMPLE_CALL_TRANSACTION
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       13.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA:   lv_url TYPE string.


    lv_url = webgui_get_url(
        iv_tcode  = iv_tcode    " Transaktionscode
        iv_okcode = iv_okcode    " Funktionscode, der PAI ausgelöst hat
        iv_parnam = iv_parnam    " Set-/Get-Paramter-Id
        iv_parval = iv_parval    " Auftragsnummer
    ).

*get the window manager as we are opening t code in external window.

    DATA li_window_manager TYPE REF TO if_wd_window_manager.
*  DATA lr_api_component TYPE REF TO if_wd_component.
    DATA li_window TYPE REF TO if_wd_window.

**  lr_api_component = ir_comp_controller->wd_get_api( ).
    IF ii_comp_api IS NOT INITIAL.
      li_window_manager = ii_comp_api->get_window_manager( ).


*  call the url which we created above
      li_window =  li_window_manager->create_external_window( url = lv_url ).

      li_window->open( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->SALV_FORMAT_COLUMN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [--->] IV_IMAGE_FIELD                 TYPE        ABAP_BOOL(optional)
* | [--->] IV_IMAGE_SOURCE                TYPE        STRING(optional)
* | [--->] IV_IMAGE_SOURCE_FIELDNAME      TYPE        STRING(optional)
* | [--->] IV_LINK_TO_ACTION_FIELD        TYPE        ABAP_BOOL(optional)
* | [--->] IV_TEXT_SOURCE_FIELDNAME       TYPE        STRING(optional)
* | [--->] IV_DROPDOWN_BY_KEY_FIELD       TYPE        ABAP_BOOL(optional)
* | [--->] IV_DROPDOWN_BY_IDX_FIELD       TYPE        ABAP_BOOL(optional)
* | [--->] IV_GROUPING_ALLOWED            TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] IV_H_ALIGN                     TYPE        WDUI_TABLE_COLUMN_HALIGN (default =CL_WD_TABLE_COLUMN=>E_H_ALIGN-AUTO)
* | [--->] IV_FIXED_POSITION              TYPE        WDUI_TABLE_COLUMN_FIXED_POS (default =CL_WD_ABSTR_TABLE_COLUMN=>E_FIXED_POSITION-NOT_FIXED)
* | [--->] IV_TITLE                       TYPE        STRING(optional)
* | [--->] IV_HIDE                        TYPE        WDY_BOOLEAN(optional)
* | [--->] IV_WIDTH                       TYPE        STRING(optional)
* | [--->] IV_HIERARCHY_COL               TYPE        ABAP_BOOL(optional)
* | [--->] IO_ALVMODEL                    TYPE REF TO CL_SALV_WD_CONFIG_TABLE
* | [--->] IV_TOOLTIP_FIELDNAME           TYPE        STRING(optional)
* | [--->] IV_LINK_TYPE                   TYPE        WDUI_LINK_TYPE (default ='00')
* | [--->] IV_CAPTION_FIELD               TYPE        WDY_BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD salv_format_column.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SALV_FORMAT_COLUMN
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: li_column_settings TYPE REF TO if_salv_wd_column_settings,
          lo_column          TYPE REF TO cl_salv_wd_column,
          lo_column_header   TYPE REF TO cl_salv_wd_column_header,
          lo_image_field     TYPE REF TO cl_salv_wd_uie_image,
          lo_lta_field       TYPE REF TO cl_salv_wd_uie_link_to_action,
          lo_ddnkey_field    TYPE REF TO cl_salv_wd_uie_dropdown_by_key,
          lo_ddnidx_field    TYPE REF TO cl_salv_wd_uie_dropdown_by_idx,
          lo_cap_field       TYPE REF TO cl_salv_wd_uie_caption,
          lo_alv_field       TYPE REF TO cl_salv_wd_field.

    li_column_settings ?= io_alvmodel.
    lo_column = li_column_settings->get_column( iv_name ).

    CHECK lo_column IS NOT INITIAL.

* horizontal alignment of cell value
    lo_column->set_h_align( iv_h_align ).

* column title
    IF iv_title IS NOT INITIAL.
      lo_column_header = lo_column->get_header( ).
      lo_column_header->set_text( iv_title ).
    ENDIF.

    IF  iv_hide IS NOT INITIAL.
      lo_column->set_visible( cl_wd_uielement=>e_visible-none ).
    ENDIF.

* field property: link to action
    IF iv_link_to_action_field EQ abap_true.
      lo_lta_field = NEW #( ).
* set image on column cells
      IF  iv_image_source IS NOT INITIAL.
        lo_lta_field->set_image_source( iv_image_source ).
*      lo_lta_field->set_enabled_fieldname( iv_name ).
*      lo_lta_field->set_visible_fieldname( iv_name ).
      ENDIF.
      IF  iv_image_source_fieldname IS NOT INITIAL.
        lo_lta_field->set_image_source_fieldname( iv_image_source_fieldname ).
*      else.
      ENDIF.
      IF iv_text_source_fieldname IS INITIAL.
        lo_lta_field->set_text_fieldname( iv_name ).
      ELSE.
        lo_lta_field->set_text_fieldname( iv_text_source_fieldname ).
      ENDIF.
*    ENDIF.
      IF iv_tooltip_fieldname IS NOT INITIAL.
        lo_lta_field->set_tooltip_fieldname( iv_tooltip_fieldname ).
      ENDIF.
      lo_lta_field->set_type( cl_wd_link_to_action=>e_type-result ).
      lo_column->set_cell_editor( lo_lta_field ).
    ENDIF.

* field property: link to action
    IF iv_caption_field EQ abap_true.
      lo_cap_field = NEW #( ).
* set image on column cells
      IF  iv_image_source IS NOT  INITIAL.
        lo_cap_field->set_image_source( iv_image_source ).
      ENDIF.
      IF iv_image_source_fieldname IS NOT INITIAL.
        lo_cap_field->set_image_source_fieldname( iv_image_source_fieldname ).
*      else.
      ENDIF.
      IF iv_text_source_fieldname IS INITIAL.
        lo_cap_field->set_text_fieldname( iv_name ).
      ELSE.
        lo_cap_field->set_text_fieldname( iv_text_source_fieldname ).
      ENDIF.
*    ENDIF.
      IF iv_tooltip_fieldname IS NOT INITIAL.
        lo_cap_field->set_tooltip_fieldname( iv_tooltip_fieldname ).
      ENDIF.
      lo_column->set_cell_editor( lo_cap_field ).
    ENDIF.

* field property: image field
    IF iv_image_field EQ abap_true.
      lo_image_field = NEW #( ).
* set image on column cells
      IF  iv_image_source IS NOT INITIAL.
        lo_image_field->set_source( iv_image_source ).
        lo_image_field->set_enabled_fieldname( iv_name ).
*      lo_image_field->set_visible_fieldname( iv_name ).
      ENDIF.
      IF  iv_image_source_fieldname IS NOT INITIAL.
        lo_image_field->set_source_fieldname( iv_image_source_fieldname ).
      ENDIF.
      IF iv_tooltip_fieldname IS NOT INITIAL.
        lo_image_field->set_tooltip_fieldname( iv_tooltip_fieldname ).
      ENDIF.
      lo_column->set_cell_editor( lo_image_field ).
    ENDIF.

* field property: drop down by key
    IF iv_dropdown_by_key_field EQ abap_true.
      lo_ddnkey_field = NEW #( selected_key_fieldname = iv_image_source_fieldname ).

*    lo_ddnkey_field->set_image_source_fieldname( iv_image_source_fieldname ).
      lo_column->set_cell_editor( lo_ddnkey_field ).
    ENDIF.

* field property: drop down by index
    IF iv_dropdown_by_idx_field EQ abap_true.
      lo_ddnidx_field = NEW #( selected_key_fieldname = iv_image_source_fieldname ).

*    lo_ddnkey_field->set_image_source_fieldname( iv_image_source_fieldname ).
      lo_column->set_cell_editor( lo_ddnidx_field ).
    ENDIF.

* field fixed position
    IF iv_fixed_position IS NOT INITIAL.
      lo_column->set_fixed_position( iv_fixed_position ).
    ENDIF.

* field grouping
*    io_alvmodel->if_salv_wd_field_settings~get_field( EXPORTING fieldname = iv_name RECEIVING value = lo_alv_field ).
    lo_alv_field = io_alvmodel->if_salv_wd_field_settings~get_field( fieldname = iv_name ).

    IF lo_alv_field IS NOT INITIAL.
      lo_alv_field->if_salv_wd_sort~set_grouping_allowed( iv_grouping_allowed ) .
    ENDIF.

* field column width
    IF iv_width IS NOT  INITIAL.
      lo_column->set_width( iv_width ).
    ENDIF.

* column should be hierarchy column?
    IF iv_hierarchy_col EQ abap_true.
      lo_column->if_salv_wd_column_hierarchy~set_hierarchy_column( abap_true ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-()] RS_AUFTRAG                     TYPE        TS_AUFTRAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET Order Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Perform SELECT query
    SELECT SINGLE zzperi, matnr
      INTO @rs_auftrag
      FROM zia_2order
      WHERE aufnr = @iv_aufnr.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_FZ_TYP_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        ZIA_2_PERIMETERS
* | [--->] IV_MATNR                       TYPE        ZIA_2VEH_TYP_SP-MATSV
* | [<-()] RT_ID_FZTYP                    TYPE        TT_MAP_SP_FZTYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fz_typ_list.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET Vehicle Type List
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Get Vehicle Type List
    SELECT zid_fztyp
      FROM zia_2veh_typ_sp
      INTO TABLE @rt_id_fztyp
      WHERE zzperi = @iv_peri
      AND matsv = @iv_matnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_QUALIFIKATION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZOBJID                      TYPE        CR_OBJID
* | [--->] IV_ZOBJTY                      TYPE        CR_OBJTY
* | [<-()] RV_QUALIFIKATION               TYPE        ZIA_2_QUALI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_qualifikation.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET Qualification
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

*    SELECT SINGLE workcenter
*     FROM i_workcenter
*     INTO @rv_qualifikation
*     WHERE workcenterinternalid = @iv_zobjid AND workcentertypecode = @iv_zobjty.
**    CALL FUNCTION 'CR_WORKSTATION_READ'
**      EXPORTING
**        id    = iv_zobjid
**      IMPORTING
**        arbpl = rv_qualifikation.

    ##WARN_OK    SELECT SINGLE arbpl
          INTO rv_qualifikation
          FROM crhd_v1
         WHERE objty = iv_zobjty
           AND objid = iv_zobjid.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VEHICLE_TYPE_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_FAHRZEUG_TYPE               TYPE        ZIA_2_VH_TYPES_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vehicle_type_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Get Vehicle type data
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    SELECT zid_fztyp,
             zfzztyp_mime_pfad
        FROM zia_2veh_typ
##TOO_MANY_ITAB_FIELDS INTO CORRESPONDING FIELDS OF TABLE @rt_fahrzeug_type
        WHERE zbasisfzg_os   = @abap_false
          AND zbasisfzg_pneu = @abap_false.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VEHICLE_TYPE_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZID_FZTYP                   TYPE        ZIA_2VEH_TYP-ZID_FZTYP
* | [<-()] RV_FAHRZEUG_TEXT               TYPE        ZIA_2_FZTYP_TXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vehicle_type_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET VEHICLE TYPE TEXT
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_fahrzeug_text TYPE string.

    " Perform the SELECT SINGLE query
    SELECT SINGLE zfztyp_txt
      INTO lv_fahrzeug_text
      FROM zia_2veh_typ_t
      WHERE zid_fztyp = iv_zid_fztyp
        AND spras = sy-langu.

    " Return the fetched text
    rv_fahrzeug_text = lv_fahrzeug_text.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_RT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [--->] IT_AUFNR                       TYPE        AUFNR_T
* | [<-()] RT_DATA                        TYPE        RESB_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_rt_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET RT DATA
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
*    SELECT AUFNR,BDTER,BDZTP                    "#EC CI_FAE_NO_LINES_OK
*     FROM RESB
*     INTO CORRESPONDING FIELDS OF TABLE @RT_DATA
*     FOR ALL ENTRIES IN @IT_AUFNR
*     WHERE AUFNR = @IT_AUFNR-AUFNR.
*    IF SY-SUBRC <> 0.
*      RETURN.
*    ENDIF.
    SELECT referenceorder AS aufnr,
 matlcomprequirementdate AS bdter,
 reservationquantityrqmttime AS btztp           "#EC CI_FAE_NO_LINES_OK
FROM i_reservationitem
##TOO_MANY_ITAB_FIELDS INTO CORRESPONDING FIELDS OF TABLE @rt_data
FOR ALL ENTRIES IN @it_aufnr
WHERE referenceorder = @it_aufnr-aufnr.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VEH_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_FZTYP                    TYPE        ZIA_2_VEC_TYP_ID
* | [<-()] RS_FZTYP                       TYPE        ZIA_2VEH_TYP_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_veh_type.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET Vehicle Type data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Vehicle Type data
    ##WARN_OK    SELECT SINGLE *                            "#EC WARNOK
          FROM zia_2veh_typ_t
          INTO @DATA(ls_fztyp)
          WHERE zid_fztyp = @iv_id_fztyp.
    " Moving data
    rs_fztyp = ls_fztyp.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_ORG_UNIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TT_ORG_UNIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_org_unit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Pratima
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lt_data TYPE STANDARD TABLE OF zia_2std_par_qua.
    SELECT zorg_einheit                              ##TOO_MANY_ITAB_FIELDS "#EC CI_NOWHERE
      FROM zia_2std_par_qua
      INTO TABLE lt_data.
    rt_data = lt_data.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_RESERV
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KZEAR                       TYPE        KZEAR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_reserv.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lt_ret TYPE bapi_alm_order_component_et,
              ls_ret TYPE bapi_alm_order_component_e.

    SELECT SINGLE reservationitemisfinallyissued FROM i_reservationdocumentitem
            INTO @rv_kzear WHERE reservation = @ls_ret-reserv_no
            AND reservationitem = @ls_ret-res_item
            AND recordtype = @ls_ret-res_type.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_QMNUM                       TYPE        ZIA_2_WORKSHIFT
* | [<-()] RS_SHIFT                       TYPE        ZIA_2WRKSHIFTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_shift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF @rs_shift
      FROM viqmel
      WHERE qmnum = @iv_qmnum.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_WORKCENTER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZOBJID                      TYPE        CR_OBJID(optional)
* | [--->] IV_ZOBJTY                      TYPE        CR_OBJTY(optional)
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT(optional)
* | [<-()] RV_WORKCENTER                  TYPE        ARBPL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workcenter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_zobjid IS NOT INITIAL AND iv_zobjty IS NOT INITIAL.
      SELECT SINGLE workcenter
        FROM i_workcenter
        INTO @rv_workcenter
        WHERE workcenterinternalid = @iv_zobjid
        AND workcentertypecode = @iv_zobjty.
    ENDIF.

    IF iv_shift IS  NOT INITIAL.
      ##WARN_OK      SELECT SINGLE zarbstl                  "#EC WARNOK
         FROM zia_2sf_wa
         INTO @rv_workcenter
         WHERE zschicht = @iv_shift.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIGNAL_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KM_BIS                      TYPE        ZIA_2_KM_BIS
* | [--->] IV_KM_VON                      TYPE        ZIA_2_KM_VON
* | [--->] IV_PERIMTER                    TYPE        ZIA_2_PERIMETERS
* | [--->] IT_ZEST_EQ                     TYPE        TT_ZEST_EQ
* | [--->] IV_NEED_E                      TYPE        ABAP_BOOL(optional)
* | [--->] IV_NEED_W                      TYPE        ABAP_BOOL(optional)
* | [<-()] RT_SIGNALSECTIONS              TYPE        ZIA_2SC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signal_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET RT DATA
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    LOOP AT it_zest_eq ASSIGNING FIELD-SYMBOL(<ls_sp>).
      CASE <ls_sp>-low(1).
        WHEN 'E'.
          SELECT *
          FROM zia_2sc
          WHERE km_von <= @iv_km_bis
            AND km_bis >= @iv_km_von
            AND zzperi = @iv_perimter
            AND zest = @<ls_sp>-low
          INTO CORRESPONDING FIELDS OF TABLE @rt_signalsections.

        WHEN 'W'.
          SELECT *
             FROM zia_2sc
             WHERE km_von <= @iv_km_bis
               AND km_bis >= @iv_km_von
               AND zzperi = @iv_perimter
               AND zest = @<ls_sp>-low
             INTO CORRESPONDING FIELDS OF TABLE @rt_signalsections.

        WHEN OTHERS.
          DATA(lv_zest) =  <ls_sp>-low(2).
          SELECT *
              FROM zia_2sc
                    WHERE km_von <= @iv_km_bis
                      AND km_bis >= @iv_km_von
                      AND zzperi = @iv_perimter
*                AND zest = @<ls_sp>-low
                AND zest = @lv_zest
*            AND zest LIKE 'N%'
             APPENDING CORRESPONDING FIELDS OF TABLE @rt_signalsections.

      ENDCASE.

      IF iv_need_e = abap_true.
        SELECT *
        FROM zia_2sc
        WHERE km_von <= @iv_km_bis
          AND km_bis >= @iv_km_von
          AND zzperi = @iv_perimter
          AND zest LIKE 'E%'
        APPENDING CORRESPONDING FIELDS OF TABLE @rt_signalsections.

        SELECT *
               FROM zia_2sc
               WHERE km_von_2 <= @iv_km_bis
                 AND km_bis_2 >= @iv_km_von
                 AND zzperi = @iv_perimter
                 AND zest LIKE 'W%'
               APPENDING CORRESPONDING FIELDS OF TABLE @rt_signalsections.
      ENDIF.
    ENDLOOP.

**    IF it_zest_eq IS NOT INITIAL.
**      SELECT *
**          FROM zia_2sc
**          WHERE km_von <= @iv_km_bis
**            AND km_bis >= @iv_km_von
**            AND zzperi = @iv_perimter
**            AND zest IN @it_zest_eq
**          INTO CORRESPONDING FIELDS OF TABLE @rt_signalsections.
**    ENDIF.
**
**    IF iv_need_e = abap_true.
**      SELECT *
**        FROM zia_2sc
**        WHERE km_von <= @iv_km_bis
**          AND km_bis >= @iv_km_von
**          AND zzperi = @iv_perimter
**          AND zest LIKE 'E%'
**        APPENDING CORRESPONDING FIELDS OF TABLE @rt_signalsections.
**    ENDIF.
**
**    IF iv_need_w = abap_true.
**      SELECT *
**        FROM zia_2sc
**        WHERE km_von_2 <= @iv_km_bis
**          AND km_bis_2 >= @iv_km_von
**          AND zzperi = @iv_perimter
**          AND zest LIKE 'W%'
**        APPENDING CORRESPONDING FIELDS OF TABLE @rt_signalsections.
**    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_RESB_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RSNUM                       TYPE        TT_RSNUM
* | [--->] IT_RSPOS                       TYPE        TT_RSPOS
* | [--->] IT_RSART                       TYPE        TT_RSART
* | [--->] IT_AUFNR                       TYPE        TT_AUFNR
* | [<-()] RS_DATA                        TYPE        RESB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_resb_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##WARN_OK
    SELECT SINGLE reservation AS rsnum,
     reservationitem AS rspos,
     reservationitemisfinallyissued AS kzear,
     unloadingpointname AS ablad,
     reservationitmismarkedfordeltn AS xloek
FROM  i_reservationitem INTO CORRESPONDING FIELDS OF @rs_data
WHERE reservation IN @it_rsnum
 AND reservationitem IN @it_rspos
 AND recordtype IN @it_rsart
 AND referenceorder IN @it_aufnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->SELECT_BLOCK_SECTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-()] RT_AUFK_EXT_SP                 TYPE        TT_AUFK_EXT_SP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_block_section.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Get z_section data into lt_aufk_ext_sp
    SELECT z_section
      FROM eaml_d_lfe_data
      INTO TABLE @rt_aufk_ext_sp
      WHERE tabkey EQ @iv_aufnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_JOBPOOL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_BTG                      TYPE        ZIA_2_ID_BTG(optional)
* | [--->] IV_PERIM                       TYPE        QMCOD(optional)
* | [--->] IV_SCHICHT_START_DATUM         TYPE        STRMN(optional)
* | [--->] IV_SCHICHT_START_ZEIT          TYPE        STRUR(optional)
* | [--->] IV_SCHICHT_END_DATUM           TYPE        LTRMN(optional)
* | [--->] IV_SCHICHT_END_ZEIT            TYPE        LTRUR(optional)
* | [--->] IV_MARK                        TYPE        ABAP_BOOL(optional)
* | [--->] IV_ID_EIZ                      TYPE        ZIA_2_ID_EIZ(optional)
* | [--->] IV_SHIFT                       TYPE        QMNUM(optional)
* | [<-()] RT_JOBPOOL                     TYPE        TT_JOBPOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_jobpool.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2order AS auftr
       INNER JOIN zia_2building AS gebaeude ON gebaeude~zid_btg = iv_id_btg
##TOO_MANY_ITAB_FIELDS INTO CORRESPONDING FIELDS OF TABLE rt_jobpool
       WHERE auftr~zzperi = iv_perim
         AND auftr~zschicht = '0'
         AND auftr~zstatus <> 'E'
         AND auftr~zstdkz = 'G'
         AND auftr~zlage = gebaeude~zlage
         AND auftr~zdidok = gebaeude~zdidok
         AND auftr~zzzugangsart = '2'
        AND (     ( ( gstrp LE iv_schicht_start_datum AND gsuzp LE iv_schicht_start_zeit ) AND ( gltrp GE iv_schicht_start_datum AND gluzp GE iv_schicht_end_zeit  ) ) "Fall 1 / 4 / 6 / 7
               OR ( "( gstrp GE lv_schicht_start_datum AND gsuzp GE lv_schicht_start_zeit ) AND ( gstrp LE lv_schicht_end_datum AND gsuzp LE lv_schicht_end_zeit )
                     ( gstrp GE iv_schicht_start_datum AND gsuzp GE iv_schicht_start_zeit ) AND ( gstrp LE iv_schicht_end_datum  )
                  OR ( gstrp GE iv_schicht_start_datum AND gltrp LE iv_schicht_end_datum )
                  OR ( gstrp GE iv_schicht_start_datum AND gstrp LE iv_schicht_end_datum AND gltrp GE iv_schicht_end_datum )
                  )    "Fall 2 / 3
               OR ( ( gstrp EQ iv_schicht_end_datum AND gsuzp EQ iv_schicht_end_zeit ) AND ( gltrp EQ iv_schicht_end_datum AND gluzp EQ iv_schicht_end_zeit ) )      "Fall 5
             )
     ORDER BY auftr~zpprio ASCENDING.

    IF iv_mark = abap_true.
      SELECT auftr~* FROM zia_cds_c_2_shift AS s
            INNER JOIN zia_cds_c_2_order AS a ON s~qmcod = a~zzperi
                                         AND (   s~eckstart BETWEEN a~eckstart AND a~eckende
                                              OR s~eckende BETWEEN a~eckstart AND a~eckende
                                              OR a~eckstart BETWEEN s~eckstart AND s~eckende
                                              OR a~eckende BETWEEN s~eckstart AND s~eckende )
            INNER JOIN zia_2order AS auftr ON auftr~aufnr = a~aufnr
     WHERE s~qmnum = @iv_shift
       AND auftr~zstdkz <> 'G'
       AND auftr~zschicht = ''
       AND auftr~zarbstl = ''
       AND auftr~zid_eiz = @iv_id_eiz
##TOO_MANY_ITAB_FIELDS     INTO CORRESPONDING FIELDS OF TABLE @rt_jobpool.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_BLOCKING_SECTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_AUFNR_KEY                   TYPE        TT_AUFNR_KEY
* | [<-()] RT_AUFK_EXT_SP                 TYPE        EAML_T_LFE_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_blocking_section.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET blocking section
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK it_aufnr_key IS NOT INITIAL.
    SELECT tabkey, z_section
       FROM eaml_d_lfe_data
##TOO_MANY_ITAB_FIELDS INTO CORRESPONDING FIELDS OF TABLE @rt_aufk_ext_sp
      FOR ALL ENTRIES IN @it_aufnr_key  WHERE tabkey =   @it_aufnr_key-aufnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->RUN_COMMIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COMMIT                      TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD run_commit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_commit EQ 'X'.
      COMMIT WORK .
    ELSE.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_ORDER_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_WHERE_CONDITION             TYPE        STRINGTAB
* | [--->] IV_ORDER_BY                    TYPE        STRING
* | [<-()] RT_ORDER                       TYPE        ZIA_2ORDER_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_order_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET Order Data
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2order
        WHERE (it_where_condition)
        ORDER BY (iv_order_by)
            INTO CORRESPONDING FIELDS OF TABLE @rt_order.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_PM_ORDER_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_AUFTRAGE                    TYPE        TT_ORDER
* | [<-()] RT_DATA                        TYPE        TT_AUFNR_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_pm_order_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK it_auftrage IS NOT INITIAL.
    SELECT aufnr, tplnr_int
      FROM viaufkst_iflos
      INTO TABLE @rt_data
      FOR ALL ENTRIES IN @it_auftrage
      WHERE aufnr = @it_auftrage-aufnr.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_PO_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        QMNUM
* | [--->] IV_PERI                        TYPE        QMCOD
* | [<-()] RT_LOG_PO_DATA                 TYPE        TT_PO_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_po_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2po_data
      INTO CORRESPONDING FIELDS OF TABLE @rt_log_po_data UP TO 100 ROWS
        WHERE schicht = @iv_shift
          AND zzperi  = @iv_peri.

    SORT rt_log_po_data BY request_date DESCENDING
                       request_time DESCENDING.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_QMEL_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_DATE                        TYPE        STRMN
* | [<-()] RT_QMEL_DATA                   TYPE        TT_QMEL_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_qmel_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT qmnum, priok
         FROM qmel
         INTO TABLE @rt_qmel_data
         WHERE qmcod      = @iv_perimeter
           AND strmn = @iv_date AND phase <> '5'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIGNSECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        QMCOD
* | [--->] IV_ZEST                        TYPE        ZIA_2_EST_TXT
* | [--->] IV_ZSA                         TYPE        ZIA_2_SIGNAL_SECTION(optional)
* | [<-()] RT_SC                          TYPE        ZIA_2SC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signsections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_peri IS NOT INITIAL AND iv_zest IS NOT INITIAL.
      SELECT *
        FROM zia_2sc
        INTO TABLE @rt_sc
        WHERE zzperi = @iv_peri
        AND zest = @iv_zest.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIG_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [<-()] RT_SECTIONS                    TYPE        ZIA_2_SIGNALUSR_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sig_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2sf_sc_usr
       INTO TABLE @rt_sections
       WHERE sperras_id = @iv_sperras_id
         AND zschicht = @iv_shift.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_WORKPLACES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ARBSTL                      TYPE        ZIA_2_ID_ARBSTL
* | [<-()] RS_WORKPLACE                   TYPE        ZIA_2SF_WA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workplaces.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* GET RT Data
*----------------------------------------------------------------------*
* >000<   7.50       10.02.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT SINGLE *
      FROM zia_2sf_wa
      INTO @rs_workplace
     WHERE zarbstl = @iv_arbstl.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_AUSP_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJNUM                      TYPE        TT_OBJNUM
* | [--->] IV_ATINN                       TYPE        ATINN
* | [<-()] RT_AUSP                        TYPE        TT_AUSP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ausp_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       17.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CONSTANTS: lc_classtype_zia TYPE klassenart VALUE 'ZIA'.
    " Select characteristic values (atwrt) for objects from AUSP table
    SELECT objek, atwrt                         "#EC CI_FAE_NO_LINES_OK
      FROM ausp
      INTO TABLE @rt_ausp
      FOR ALL ENTRIES IN @it_objnum
      WHERE objek = @it_objnum-objnum
        AND atinn = @iv_atinn
        AND klart = @lc_classtype_zia.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_INOB_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJEK                       TYPE        TT_OBJEK
* | [<-()] RT_INOB                        TYPE        TT_INOB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_inob_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.02.20256    tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CONSTANTS: lc_objecttable   TYPE tabelle    VALUE 'IFLOT',
               lc_classtype_zia TYPE klassenart VALUE 'ZIA'.
*##NEEDED               lc_char_aks_atg_ort TYPE string      VALUE 'ZIA_5_AKS_ATG_ORT'.

    SELECT cuobj, objek                         "#EC CI_FAE_NO_LINES_OK
     FROM inob
     INTO TABLE @rt_inob
     FOR ALL ENTRIES IN @it_objek
     WHERE objek = @it_objek-objek
       AND klart = @lc_classtype_zia
       AND obtab = @lc_objecttable.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_NOTIF_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        STRING
* | [--->] IV_START_SELECTED_DATE         TYPE        STRMN
* | [--->] IV_LAST_SELECTED_DATE          TYPE        STRMN
* | [<-()] RT_NOTIF_DATA                  TYPE        TT_NOTIF_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_notif_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       18.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " GetNotification Qualification data
    SELECT qmnum, qmcod, strmn,strur ,ltrur, ltrmn, priok
    INTO TABLE @rt_notif_data
    FROM qmel
    WHERE qmcod = @iv_peri
      AND strmn BETWEEN @iv_start_selected_date
                     AND @iv_last_selected_date
     AND phase <> '5'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIGNALSECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZEST                        TYPE        ZIA_2_BLOCKING_SECTION
* | [--->] IV_ZSA                         TYPE        ZIA_2_SIGNAL_SECTION
* | [<-()] RS_SECTIONS                    TYPE        ZIA_2SC_SEQ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalsections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       18.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    ##WARN_OK    SELECT SINGLE *
       FROM zia_2sc_seq
       INTO @DATA(ls_data)
       WHERE sperrabschnitt  = @iv_zest
         AND signalabschnitt = @iv_zsa.
    rs_sections = ls_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_WORKSHIFT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_END_DATE                    TYPE        DATUM
* | [--->] IV_START_DATE                  TYPE        DATUM
* | [--->] IV_PERIM                       TYPE        STRING
* | [<-()] RT_SHIFT                       TYPE        TT_QMNUM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workshift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       18.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT qmnum
      FROM qmel
      INTO TABLE @rt_shift
      WHERE qmcod = @iv_perim
        AND strmn BETWEEN @iv_start_date AND @iv_end_date.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_BUILDINGS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        QMCOD(optional)
* | [<-()] RT_BUILDINGS                   TYPE        TT_BUILDINGS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_buildings.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       18.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    IF iv_peri IS INITIAL.
      SELECT DISTINCT a~zid_btg, zindex,                "#EC CI_NOWHERE
        a~zzperi,zktext
        FROM zia_2building AS a
        INNER JOIN zia_2building_t AS b
        ON a~zid_btg = b~zid_btg
        INTO TABLE @rt_buildings.
    ELSE.
      SELECT DISTINCT zid_btg, zindex
      FROM zia_2building
##TOO_MANY_ITAB_FIELDS      INTO TABLE @rt_buildings
      WHERE zzperi = @iv_peri
        AND ort = 'OSN'.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_BUILDINGS_GBT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_BUILDINGS                   TYPE        TT_BUILDINGS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_buildings_gbt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT DISTINCT a~zid_btg, zindex, a~zzperi, b~zktext
    FROM zia_2building AS a
      INNER JOIN zia_2building_t AS b
        ON a~zid_btg = b~zid_btg
##TOO_MANY_ITAB_FIELDS    INTO TABLE @rt_buildings
    WHERE a~zzperi = 'GBT'
      AND a~ort = 'OSS'.

*    SELECT DISTINCT a~zid_btg, zindex,                  "#EC CI_NOWHERE
*      zktext
*      FROM zia_2building AS a
*      INNER JOIN zia_2building_t AS b
*      ON a~zid_btg = b~zid_btg
*      INTO TABLE @rt_buildings.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_BUILDINGS_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        QMCOD
* | [<-()] RT_BUILDINGS                   TYPE        TT_BUILDINGS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_buildings_tunnel.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT DISTINCT zid_btg, zindex
      FROM zia_2building
  ##TOO_MANY_ITAB_FIELDS    INTO TABLE @rt_buildings
      WHERE zzperi = @iv_peri
        AND ort = 'TUNNEL'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIGNALS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZSA                         TYPE        ZIA_2_SIGNAL_SECTION_S
* | [--->] IV_ZEST                        TYPE        ZIA_2_BLOCKING_SECTION_S
* | [<-()] RS_SC                          TYPE        ZIA_2SC_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signals.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.02.2026     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##WARN_OK    SELECT SINGLE *                            "#EC WARNOK
          FROM zia_2sc
          INTO CORRESPONDING FIELDS OF @rs_sc
          WHERE zsa = @iv_zsa
          AND  zest = @iv_zest.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SIGNALSECTIONS1
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        QMCOD
* | [<-()] RT_SECTIONS                    TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalsections1.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET RT DATA
*----------------------------------------------------------------------*
* >000<   7.50       12.02.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2sc
       INTO TABLE @rt_sections
         WHERE zzperi = @iv_peri AND
               ( zest = @zif_ia_2_constant=>mc_sperrabs-w  OR
                 zest = @zif_ia_2_constant=>mc_sperrabs-w1 OR
                 zest = @zif_ia_2_constant=>mc_sperrabs-w2 OR
                 zest = @zif_ia_2_constant=>mc_sperrabs-w3 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VEHICLE_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ID_ARBSTL                   TYPE        TT_ID_ARBSTL
* | [<-()] RT_VEH_MAT                     TYPE        ZIA_2MAP_MATFZG_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vehicle_material.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* Get Vehicle Material Data
*----------------------------------------------------------------------*
* >000<   7.50       23.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT *                                  "#EC CI_FAE_LINES_ENSURED
      FROM zia_2map_matfzg
      INTO CORRESPONDING FIELDS OF TABLE @rt_veh_mat
      FOR ALL ENTRIES IN @it_id_arbstl
      WHERE zarbstl = @it_id_arbstl-table_line.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->READ_SIGNALABSCHNITTE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_signalabschnitte.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Signal Data
*----------------------------------------------------------------------*
* >000<   7.50       23.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT zzperi, zsa, lfdnr,                          "#EC CI_NOWHERE
        km_von, km_bis,
        km_von_2, km_bis_2,
        zehb, zest, zspw,
        zid_joker_1, zid_joker_2,
        zio_gleis, zio_spa_abf, einfahrtrichtung
##TOO_MANY_ITAB_FIELDS   INTO CORRESPONDING FIELDS OF TABLE @rt_data
   FROM zia_2sc
   ORDER BY PRIMARY KEY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SF_QUALI
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IV_ARBPL                       TYPE        ZIA_2_QUALIFICATION
* | [<-()] RS_DATA                        TYPE        ZIA_2_QUALIFICATION_POPUP_WD_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sf_quali.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Personal Resources per Shift according to EIZ
*----------------------------------------------------------------------*
* >000<   7.50       23.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ##WARN_OK SELECT SINGLE objty AS zobjty, objid AS zobjid
              INTO CORRESPONDING FIELDS OF @rs_data
              FROM zia_2sf_quali
              WHERE zschicht = @iv_shift
                AND arbpl    = @iv_arbpl.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_STD_PARA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_QUALIFICATION               TYPE        ZIA_2_QUALIFICATION_POPUP_WD_S
* | [<-()] RS_DATA                        TYPE        ZIA_2_QUALIFICATION_POPUP_WD_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_std_para.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Personal Resources per Shift according to EIZ
*----------------------------------------------------------------------*
* >000<   7.50       23.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ##WARN_OK    SELECT SINGLE objty AS zobjty, objid AS zobjid
            INTO CORRESPONDING FIELDS OF @rs_data
            FROM zia_cds_c_2_stdqpara
            WHERE zzperi = @is_qualification-zzperi
              AND arbpl  = @is_qualification-arbpl.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SF_SB_COMM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [<-()] RT_COMMENT_OLD                 TYPE        ZIA_2DB_COMMENT_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sf_sb_comm.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* Get OLD comments
*----------------------------------------------------------------------*
* >000<   7.50       23.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2sf_sb_comm
      WHERE zschicht = @iv_shift
      INTO TABLE @rt_comment_old.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VENTILATION_CBT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LUEFTUNG_CODE               TYPE        ZIA_2_LUEFTUNG_CODE
* | [<-()] RS_VENTILATION                 TYPE        TS_VENTILATION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ventilation_cbt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET OLD COMMENTS
*----------------------------------------------------------------------*
* >000<   7.50       24.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT SINGLE * FROM zia_2ventilation
    INTO CORRESPONDING FIELDS OF @rs_ventilation
        WHERE lueftung_code = @iv_lueftung_code
          AND zzperi = 'CBT'
          AND spras = @syst-langu .

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_PLANNING_LOG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RA_MSGTY                    TYPE        TT_RA_MSGTY
* | [--->] IV_MAX_TREFFER                 TYPE        INTEGER
* | [<-()] RT_PLANLOG                     TYPE        TT_PLANNING_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_planning_log.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET planning logs
*----------------------------------------------------------------------*
* >000<   7.50       24.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2planungslog
##TOO_MANY_ITAB_FIELDS INTO CORRESPONDING FIELDS OF TABLE @rt_planlog
        UP TO @iv_max_treffer ROWS
         WHERE msgty IN @it_ra_msgty.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_COUNT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERI                        TYPE        QMCOD
* | [--->] IV_SA                          TYPE        ZIA_2_SIGNAL_SECTION
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_count.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Count
*----------------------------------------------------------------------*
* >000<   7.50       24.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    "Check if SA exists
    SELECT COUNT( * ) UP TO 1 ROWS
      FROM zia_2sc
      WHERE zzperi = @iv_peri
        AND zsa    = @iv_sa.

    IF sy-subrc EQ 0.
      rv_boolean = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->DELETE_SIGNAL_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IT_USER_ADD_SIGNALS            TYPE        ZIA_2_SIGNALUSR_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_signal_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Count
*----------------------------------------------------------------------*
* >000<   7.50       24.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DELETE FROM zia_2sf_sc_usr WHERE sperras_id = iv_sperras_id
                                     AND zschicht = iv_shift.

    MODIFY zia_2sf_sc_usr FROM TABLE it_user_add_signals.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_VENTILATION_GBT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LUEFTUNG_CODE               TYPE        ZIA_2_LUEFTUNG_CODE
* | [<-()] RS_VENTILATION                 TYPE        TS_VENTILATION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ventilation_gbt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
* GET Count
*----------------------------------------------------------------------*
* >000<   7.50       24.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    SELECT SINGLE * FROM zia_2ventilation
       INTO CORRESPONDING FIELDS OF @rs_ventilation
        WHERE lueftung_code = @iv_lueftung_code
          AND zzperi = 'GBT'
          AND spras = @syst-langu .
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->COMMIT_PB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD commit_pb.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    ##NEEDED    DATA : ls_commit_failed   TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
    ##NEEDED           ls_commit_reported TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
      ls_bucket_commit_failed        TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
          ls_bucket_commit_reported      TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
    ls_admin_order_commit_failed   TYPE RESPONSE FOR FAILED LATE r_maintenanceordertp,
          ls_admin_order_commit_reported TYPE RESPONSE FOR REPORTED LATE r_maintenanceordertp.


*    COMMIT ENTITIES
*   RESPONSE OF r_maintplanningbuckettp_2
*     FAILED   ls_commit_failed
*     REPORTED ls_commit_reported.

*    es_commit_failed = ls_commit_failed.
*    es_commit_reported = ls_commit_reported.

    COMMIT ENTITIES
            RESPONSE OF r_maintplanningbuckettp_2
              FAILED   ls_bucket_commit_failed
              REPORTED ls_bucket_commit_reported
            RESPONSE OF r_maintenanceordertp
              FAILED   ls_admin_order_commit_failed
              REPORTED ls_admin_order_commit_reported.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->COMMIT_ENTITIES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD commit_entities.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    COMMIT ENTITIES.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->POPULATE_SHIFT_ORDER_DETAILS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT                     TYPE        ZIA_2_WORKSHIFT
* | [<---] EV_SHIFT_AUFNR                 TYPE        QMEL-AUFNR
* | [<---] ES_AUFK                        TYPE        AUFK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_shift_order_details.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    SELECT SINGLE aufnr
      FROM qmel
      INTO ev_shift_aufnr
      WHERE qmnum =  iv_schicht.

    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
      INTO es_aufk
      FROM aufkv
     WHERE aufnr = ev_shift_aufnr.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->ROLLBACK_ENTITIES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD rollback_entities.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ROLLBACK ENTITIES.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST=>GET_RESULTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MAINTORDOVRLPROCSUBPHASE    TYPE        EAM_OSTAT_SPHASE
* | [<-()] RV_STRING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_results.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_RESULTS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Select subphase and description for given maint order process subphase filtered by system language
    SELECT SINGLE  eamovrlprocsubphasedesc
      INTO @rv_string
      FROM eam_ostat_sph_t
      WHERE eamovrlprocsubphase = @iv_maintordovrlprocsubphase
        AND language = @sy-langu.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_SUBPHASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-()] RV_SUBPHASE                    TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_subphase.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SUBPHASE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.03.2026     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT SINGLE maintordovrlprocsubphase
     FROM afih
     INTO  @rv_subphase
     WHERE aufnr = @iv_aufnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->GET_FUNC_LOC_DESCR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TPLNR                       TYPE        TPLNR
* | [<-()] RV_FUNC_TEXT                   TYPE        PLTXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_func_loc_descr.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Get functional location description based on function location
*----------------------------------------------------------------------*
* >000<   7.50       27.03.2026     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " IF no functional location was provided, EXIT immediately
    CHECK iv_tplnr IS NOT INITIAL.
    " Read the functional location description (PLTXT) from IFLO
    ##WARN_OK    SELECT SINGLE pltxt
          FROM iflo
          INTO @rv_func_text
          WHERE tplnr = @iv_tplnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->MODIFY_SETTLEMENT_TABLES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ZIA_2SF_ORDERSTR            TYPE        TT_ZIA_2SF_ORDERSTR
* | [--->] IT_ZIA_2SF_VEH_COST            TYPE        TT_ZIA_2SF_VEH_COST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD modify_settlement_tables.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Modify Settlement Z tables
*----------------------------------------------------------------------*
* >000<   7.50       07.04.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*


    MODIFY zia_2sf_veh_cost FROM TABLE it_zia_2sf_veh_cost.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
    MODIFY zia_2sf_orderstr FROM TABLE it_zia_2sf_orderstr.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->POPULATE_VEH_TYP_AND_COST_BLCK
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_ZIA_2VEH_TYP_RAT            TYPE        TT_ZIA_2VEH_TYP_RAT
* | [<---] ET_ZIA_2COST_BLCK              TYPE        TT_ZIA_2COST_BLCK
* | [<---] ET_ZIA_2VEH_TYP_SP             TYPE        TT_ZIA_2VEH_TYP_SP
* | [<---] EV_STEUS                       TYPE        ZIA_2MO_FLD_VALUE
* | [<---] EV_USE04                       TYPE        ZIA_2MO_FLD_VALUE
* | [<---] EV_USR04                       TYPE        ZIA_2MO_FLD_VALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_veh_typ_and_cost_blck.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       23.04.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA: lt_zia_2mo_derivatn TYPE STANDARD TABLE OF zia_2mo_derivatn,
          ls_zia_2mo_derivatn TYPE zia_2mo_derivatn.

* GET VEHICLE RATE FOR VEHICLE TYPE
    SELECT *                                            "#EC CI_NOWHERE
      FROM zia_2veh_typ_rat
      INTO TABLE et_zia_2veh_typ_rat.

*    GET COST BLOCKS
    SELECT *                                            "#EC CI_NOWHERE
      FROM zia_2cost_blck
      INTO TABLE et_zia_2cost_blck.
*      WHERE kategorie LIKE '%V%'.

    SELECT *                                            "#EC CI_NOWHERE
      FROM zia_2veh_typ_sp
      INTO TABLE et_zia_2veh_typ_sp.

    ##WARN_OK    SELECT SINGLE value
          INTO ev_steus
          FROM zia_2mo_derivatn
         WHERE field_key = 'N_DIENS'
           AND data_table = 'AFVC'
           AND data_field = 'STEUS'.

    SELECT *
      INTO TABLE lt_zia_2mo_derivatn
      FROM zia_2mo_derivatn
     WHERE field_key = 'N_DIENS'.
    IF sy-subrc = 0.
      READ TABLE lt_zia_2mo_derivatn INTO ls_zia_2mo_derivatn
                  WITH KEY field_key = 'N_DIENS'
                           data_field = 'STEUS'.
      IF sy-subrc = 0.
        ev_steus = ls_zia_2mo_derivatn-value.
      ENDIF.
      READ TABLE lt_zia_2mo_derivatn INTO ls_zia_2mo_derivatn
                WITH KEY field_key = 'N_DIENS'
                         data_field = 'USE04'.
      IF sy-subrc = 0.
        ev_use04 = ls_zia_2mo_derivatn-value.
      ENDIF.
      READ TABLE lt_zia_2mo_derivatn INTO ls_zia_2mo_derivatn
                  WITH KEY field_key = 'N_DIENS'
                           data_field = 'USR04'.
      IF sy-subrc = 0.
        ev_usr04 = ls_zia_2mo_derivatn-value.
      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->POPULATE_WORKCENTERINTERNALID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WORKCENTER                  TYPE        I_WORKCENTER-WORKCENTER
* | [--->] IV_PLANT                       TYPE        I_WORKCENTER-PLANT
* | [<---] EV_WORKCENTERINTERNALID        TYPE        I_WORKCENTER-WORKCENTERINTERNALID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_workcenterinternalid.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       23.04.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*


    ##WARN_OK   SELECT SINGLE workcenterinternalid
         FROM i_workcenter
           INTO @ev_workcenterinternalid
             WHERE workcenter EQ @iv_workcenter
             AND   plant      EQ @iv_plant.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->POPULATE_ZIA_2ORDER_CAP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORDERS                      TYPE        TT_ORDERS
* | [<---] ET_ZIA_2ORDER_CAP              TYPE        TT_ZIA_2ORDER_CAP
* | [<---] ET_ZIA_2SF_VEH_SEAT            TYPE        TT_ZIA_2SF_VEH_SEAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_zia_2order_cap.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >000<   7.50       18.09.2026     TCS / ROSHAN WADHWANI
*         added zdauer field in the query.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
                     "#EC CI_FAE_LINES_ENSURED  "#EC CI_FAE_NO_LINES_OK
    IF it_orders[] IS NOT INITIAL.

      SELECT *                                "#EC CI_FAE_LINES_ENSURED
        FROM zia_2order_cap
        FOR ALL ENTRIES IN @it_orders
       WHERE aufnr = @it_orders-aufnr
         AND zdauer IS NOT INITIAL
        INTO TABLE @et_zia_2order_cap.


      SELECT zid_fzg_platz,
             uname
        FROM zia_2sf_veh_seat
      FOR ALL ENTRIES IN @it_orders
       WHERE zschicht = @it_orders-zschicht
        INTO TABLE @et_zia_2sf_veh_seat.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->POPULATE_REVISION_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORDER                       TYPE        ZIA_2ORDER
* | [--->] IV_REVISION                    TYPE        REVNI
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD populate_revision_number.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       12.05.2026        TCS / Roshan
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*


*Get Order details

  DATA: lt_order_data    TYPE eams_t_bo_ord_header,
        ls_order_data	   TYPE eams_s_bo_ord_header,
        ls_order         TYPE zia_2order,
        lv_objnr         TYPE jsto-objnr,
        lv_txt04         TYPE tj02t-txt04,
        lv_status_number TYPE jest-stat,
        lt_methods       TYPE bapi_alm_order_method_t,
        lt_header        TYPE bapi_alm_order_headers_i_t,
        lt_header_up     TYPE TABLE OF bapi_alm_order_headers_up,
        lt_return        TYPE bapiret2_t,
        lv_objectkey     TYPE bapi_alm_order_method-objectkey.


  ls_order = is_order.

  "fetch Maintenance Order Details
  ##NEEDED
  cl_eams_bo_order=>s_get_instance( )->get_order_header(
    EXPORTING
      it_node_id     =  VALUE #( ( eams_aufnr = ls_order-aufnr ) )                 "Business Object Order - Identification
    IMPORTING
      et_node_data   =  lt_order_data                                         "Business Object Order - Header Data
      et_node_id_rel =  DATA(lt_node_id_rel1)                                 "Relationship between index of source and target node ID
      et_messages    =  DATA(lt_message) ).                                   "Message

  CHECK lt_order_data IS NOT INITIAL.
  ls_order_data = VALUE #( lt_order_data[ eams_aufnr = ls_order-aufnr ] ).

*            deactivate PL2 if it exists.
  IF ls_order_data-userstatus CA 'PL2'.

    lv_objnr = ls_order-objnr.
    lv_txt04 = 'PL2'.

    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
      EXPORTING
        language           = sy-langu
        mode               = 'E'
        objnr              = lv_objnr
        txt04              = lv_txt04
      IMPORTING
        status_number      = lv_status_number
      EXCEPTIONS
        insufficient_input = 1
        not_found          = 2
        object_not_found   = 3
        wrong_mode         = 4
        OTHERS             = 5.

    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
      EXPORTING
        objnr       = lv_objnr
        user_status = lv_status_number
        set_inact   = 'X'.


  ENDIF.

*            set PL3 status.


*to set the status as PL3.
  CLEAR : lv_status_number.
  lv_txt04 = 'PL3'.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
    EXPORTING
      language           = sy-langu
      mode               = 'E'
      objnr              = lv_objnr
      txt04              = lv_txt04
    IMPORTING
      status_number      = lv_status_number
    EXCEPTIONS
      insufficient_input = 1
      not_found          = 2
      object_not_found   = 3
      wrong_mode         = 4
      OTHERS             = 5.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
    EXPORTING
      objnr       = lv_objnr
      user_status = lv_status_number
      set_inact   = ' '.

  " Updating Phase
  zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = ls_order-aufnr
                                             iv_maintordovrlprocphase = '06'"lv_maintordovrlprocphase
                                             iv_maintordovrlprocsubphase = '0065' ).


*CHANGE MAINTENANCE ORDER.

  CLEAR: lt_methods,
         lt_header,
         lt_header_up,
         lt_return,
         lv_objectkey.


  lv_objectkey = ls_order-aufnr.
  FREE lt_methods.

*   METHODS - ANLEGEN
  APPEND VALUE #(
    refnumber  = 1
    objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
    method     = if_eams_bo_const=>gc_bapi_ord_method-change
    objectkey  = lv_objectkey
  ) TO lt_methods.

*   POPULATE THE HEADER TABLE
  APPEND VALUE #(
    orderid     = lv_objectkey
    order_type  = ls_order-auart
    revision    = iv_revision "ls_result-maintenanceevent  "SEE PLANNING BUCKET
  ) TO lt_header.


  APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up1>).
  IF <ls_orderheader_up1> IS ASSIGNED.
    <ls_orderheader_up1>-orderid    = lv_objectkey.
    <ls_orderheader_up1>-revision = abap_true.
  ENDIF.
  UNASSIGN <ls_orderheader_up1>.


*  _METHODS - SAVE
  APPEND VALUE #(
    refnumber  = 1
    objecttype = space
    method     = if_eams_bo_const=>gc_bapi_ord_method-save
    objectkey  = lv_objectkey
  ) TO lt_methods.

*   CALL THE BAPI
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_header    = lt_header
      it_header_up = lt_header_up
      return       = lt_return.
  IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->CALL_PROGRAM_ZIA_20001_M1
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REVISION                    TYPE        REVNI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD call_program_zia_20001_m1.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       19.05.2026        TCS / Roshan
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    DATA : lt_selection TYPE TABLE OF rsparams.

    APPEND VALUE #( selname = 'S_REVNR' kind = 'S' sign = 'I' option = 'EQ' low = iv_revision ) TO lt_selection.
    APPEND VALUE #( selname = 'P_RULE'  kind = 'P' sign = 'I' option = 'EQ' low = 'X' ) TO lt_selection.
    APPEND VALUE #( selname = 'P_EXEC'  kind = 'P' sign = 'I' option = 'EQ' low = '1' ) TO lt_selection.
    SUBMIT zia_20001_m1 WITH SELECTION-TABLE lt_selection AND RETURN EXPORTING LIST TO MEMORY. "#EC CI_SUBMIT

*    TYPES :   BEGIN OF ts_order,
*        maintenanceorder            TYPE i_maintenanceorder-maintenanceorder,
*        maintenanceprocessingphase  TYPE i_maintenanceorder-maintenanceprocessingphase,
*        maintenancerevision         TYPE i_maintenanceorder-maintenancerevision,
*        maintenanceplan             TYPE i_maintenanceorder-maintenanceplan,
*        maintenanceitem             TYPE i_maintenanceorder-maintenanceitem,
*        maintenanceordertype        TYPE i_maintenanceorder-maintenanceordertype,
*        maintenanceorderinternalid  TYPE i_maintenanceorder-maintenanceorderinternalid,
*        tasklistgroup               TYPE i_maintenanceorder-tasklistgroup,
*        tasklisttype                TYPE i_maintenanceorder-tasklisttype,
*        tasklistgroupcounter        TYPE i_maintenanceorder-tasklistgroupcounter,
*        maintordprocessphasecode    TYPE i_maintenanceorder-maintordprocessphasecode,
*        maintordprocesssubphasecode TYPE i_maintenanceorder-maintordprocesssubphasecode,
*        adm_order                   TYPE i_maintenanceorder-maintenanceorder,
*      END OF ts_order .
*  types:
*    tt_order TYPE STANDARD TABLE OF ts_order .
*
*  DATA : GT_ADM_ORD TYPE tt_order.
*
*     SELECT  maintenanceorder,
*             maintenanceprocessingphase,
*             maintenancerevision,
*             maintenanceplan,
*             maintenanceitem,
*             maintenanceordertype,
*             maintenanceorderinternalid,
*             maintordprocessphasecode,
*             maintordprocesssubphasecode,
*             tasklistgroup,
*             tasklisttype,
*             tasklistgroupcounter
*      FROM i_maintenanceorder
*      INTO CORRESPONDING FIELDS OF TABLE @gt_adm_ord
*      WHERE maintenancerevision   = @iv_revision.
*


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->UPDATE_COMPONENTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORDERS                      TYPE        TT_ORDER_COMP
* | [--->] IV_LI                          TYPE        CHAR2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_components.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       12.10.2026        TCS / ROSHAN WADHWANI
*         adding L in the recepient location for Long intervals only
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA : lt_components TYPE STANDARD TABLE OF bapi_alm_order_component_e,
           ls_component  TYPE bapi_alm_order_component,
           lt_component  TYPE STANDARD TABLE OF bapi_alm_order_component,
           lt_return0    TYPE STANDARD TABLE OF bapiret2,
           lv_val1       TYPE char6,
           lv_val2       TYPE char6,
           lv_val3       TYPE char15.

    CONSTANTS lc_obj_typ_comp TYPE obj_typ    VALUE 'COMPONENT'.
    CONSTANTS lc_method_chng  TYPE swo_method VALUE 'CHANGE'.
    CONSTANTS lc_method_save  TYPE swo_method VALUE 'SAVE'.

    DATA(lt_methods)  = VALUE bapi_alm_order_method_t( ).
    DATA(lt_return)   = VALUE bapiret2_t( ).
    DATA(lt_comp_upd) = VALUE bapi_alm_order_component_ut( ).
    DATA(lv_index)    = VALUE int4( ).


*    SELECT *
*      FROM zia_2map_matfzg
*      INTO TABLE @DATA(lt_zia_2map_matfzg)
*      FOR ALL ENTRIES IN @it_orders
*     WHERE aufnr = @it_orders-aufnr.            "#EC CI_FAE_NO_LINES_OK

    LOOP AT it_orders INTO DATA(ls_order).

      AT NEW aufnr.
*      lv_index = lv_index + 1.
        CLEAR : lv_index, lt_components, ls_component, lt_component, lt_methods, lt_comp_upd  .

        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
          EXPORTING
            number        = ls_order-aufnr
          TABLES
            et_components = lt_components
            return        = lt_return0.

        LOOP AT lt_components INTO DATA(ls_components).  "#EC CI_NESTED


*        aufnr       TYPE aufnr,
*        start_datum TYPE zia_2_pm_ordgstrp,
*        start_zeit  TYPE zia_2_co_gsuzp,
*        reserv_no   TYPE rsnum,
*        res_item    TYPE rspos,
*        fzg_belad   TYPE char6,

          READ TABLE it_orders INTO DATA(ls_order_comp)
                                        WITH KEY aufnr = ls_order-aufnr
                                                 reserv_no = ls_components-reserv_no
                                                 res_item = ls_components-res_item.
          IF sy-subrc = 0.
            lv_index = lv_index + 1.

            IF iv_li = 'LI'.
              CLEAR : lv_val1, lv_val2, lv_val3.
              SPLIT ls_order_comp-fzg_belad AT '.' INTO lv_val1 lv_val2.
              CONCATENATE lv_val1  'L' INTO lv_val1.
              IF lv_val2 IS NOT INITIAL.
                CONCATENATE lv_val1 lv_val2 INTO lv_val3 SEPARATED BY '.'.
              ELSE.
                lv_val3 = lv_val1.
              ENDIF.
              ls_components-recipient_location_code = lv_val3.
            ELSE.
              ls_components-recipient_location_code = ls_order_comp-fzg_belad.
            ENDIF.


            ls_components-req_date = ls_order_comp-start_datum.
            ls_components-req_time = ls_order_comp-start_zeit.
            ##ENH_OK
            MOVE-CORRESPONDING ls_components TO ls_component.
            APPEND ls_component TO lt_component.
            CLEAR ls_component.

            CLEAR : ls_components, ls_order_comp.


            APPEND VALUE #( recipient_location_code = abap_true
                            req_date = abap_true
                            req_time = abap_true ) TO lt_comp_upd.

            APPEND VALUE #( ) TO lt_methods ASSIGNING FIELD-SYMBOL(<ls_methods>).
            <ls_methods>-refnumber     = lv_index.
            <ls_methods>-objecttype    = lc_obj_typ_comp.
            <ls_methods>-method        = lc_method_chng.
            <ls_methods>-objectkey(12) = ls_order-aufnr.

            APPEND VALUE #( refnumber = lv_index method = lc_method_save ) TO lt_methods.
          ENDIF.

        ENDLOOP.





        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
          TABLES
            it_methods      = lt_methods
            it_component    = lt_component
            it_component_up = lt_comp_upd
            return          = lt_return.
        IF NOT line_exists( lt_return[ type = 'E' ] ) AND
           NOT line_exists( lt_return[ type = 'A' ] ) AND
           NOT line_exists( lt_return[ type = 'X' ] ).
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ##ENH_OK
        ENDIF.

      ENDAT.
    ENDLOOP.






  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->UPDATE_ORDER_PHASE_SUBPHASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORDER                       TYPE        AUFNR
* | [--->] IV_PHASE                       TYPE        EAM_OSTAT_PHASE
* | [--->] IV_SUBPHASE                    TYPE        EAM_OSTAT_SPHASE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_order_phase_subphase.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*
*----------------------------------------------------------------------*
* >000<   7.50       05.06.2026     TCS / ROSHAN WADHWANI
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       09.10.2026     TCS / ROSHAN WADHWANI
*         uncommenting of FM code CO_VB_KO99_ORDER_UPDATE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

*adding new code to update phase.

    DATA lv_objnr       TYPE j_objnr.
    DATA lv_loghandle  TYPE balloghndl.
    DATA lv_context     TYPE maintenanceprocessingcontext.
    DATA lv_order TYPE aufnr.
    lv_order = iv_order.


    lv_context = 001.
*  objnr = <<order no>>
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_order
      IMPORTING
        output = lv_order.

*    iv_order = lv_order.

    CONCATENATE 'OR' lv_order INTO lv_objnr.
    DATA(li_loghandler) = CAST if_eam_business_transact_log( cl_eam_business_transact_log=>get_instance( ) ).
    li_loghandler->set_loghandle( lv_loghandle ).


    cl_eam_order_btransactions=>get_instance(  )->release_order( objectnumber = lv_objnr
                                                                 processing_context = lv_context
                                                                 log_handle_id = lv_loghandle ).


    cl_eam_order_btransactions=>get_instance(  )->dispatch_operations(
      objectnumber       = lv_objnr
      processing_context = lv_context
      log_handle_id      = lv_loghandle
    ).




*commenting the below code Temporarily on 25.08.2026

    DATA: lt_order_update TYPE TABLE OF ko99_pm_order_update.

* Fill global internal Table PM_ORDER_DATA_TAB
    lt_order_update = VALUE #( ( aufnr = iv_order
                                 iphas = '2'
                                 maintordovrlprocphase    = iv_phase
                                 maintordovrlprocsubphase = iv_subphase ) ).
*    UPDATE afih table
    CALL FUNCTION 'CO_VB_KO99_ORDER_UPDATE' " IN UPDATE TASK
      TABLES
        ko99_pm_order_tab = lt_order_update.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->UPDATE_REVISION_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORDER                       TYPE        ZIA_2ORDER
* | [--->] IV_REVISION                    TYPE        REVNI
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD update_revision_number.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       20.07.2026        TCS / Roshan
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*


*Get Order details

  ##NEEDED  DATA: lt_order_data    TYPE eams_t_bo_ord_header,
  ##NEEDED        ls_order_data	   TYPE eams_s_bo_ord_header,
          ls_order         TYPE zia_2order,
  ##NEEDED        lv_objnr         TYPE jsto-objnr,
  ##NEEDED        lv_txt04         TYPE tj02t-txt04,
  ##NEEDED        lv_status_number TYPE jest-stat,
          lt_methods       TYPE bapi_alm_order_method_t,
          lt_header        TYPE bapi_alm_order_headers_i_t,
          lt_header_up     TYPE TABLE OF bapi_alm_order_headers_up,
          lt_return        TYPE bapiret2_t,
          lv_objectkey     TYPE bapi_alm_order_method-objectkey.


  ls_order = is_order.


*CHANGE MAINTENANCE ORDER.

  CLEAR: lt_methods,
         lt_header,
         lt_header_up,
         lt_return,
         lv_objectkey.


  lv_objectkey = ls_order-aufnr.
  FREE lt_methods.

*   METHODS - ANLEGEN
  APPEND VALUE #(
    refnumber  = 1
    objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
    method     = if_eams_bo_const=>gc_bapi_ord_method-change
    objectkey  = lv_objectkey
  ) TO lt_methods.

*   POPULATE THE HEADER TABLE
  APPEND VALUE #(
    orderid     = lv_objectkey
    order_type  = ls_order-auart
    revision    = iv_revision "ls_result-maintenanceevent  "SEE PLANNING BUCKET
  ) TO lt_header.


  APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up1>).
  IF <ls_orderheader_up1> IS ASSIGNED.
    <ls_orderheader_up1>-orderid    = lv_objectkey.
    <ls_orderheader_up1>-revision = abap_true.
  ENDIF.
  UNASSIGN <ls_orderheader_up1>.


*  _METHODS - SAVE
  APPEND VALUE #(
    refnumber  = 1
    objecttype = space
    method     = if_eams_bo_const=>gc_bapi_ord_method-save
    objectkey  = lv_objectkey
  ) TO lt_methods.

*   CALL THE BAPI
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_header    = lt_header
      it_header_up = lt_header_up
      return       = lt_return.
  IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->UPDATE_TFF_IN_SHIFT_ORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT_AUFNR                 TYPE        AUFNR
* | [--->] IT_QUAL_TFF                    TYPE        TT_QUAL_TFF
* | [--->] IV_STEUS                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_USE04                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_USR04                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_MAINTENANCEPLANNINGPLANT    TYPE        WERKS_D
* | [--->] IV_SHORTTEXT                   TYPE        AUFTEXT
* | [--->] IS_SCHICHTDETAILS              TYPE        ZIA_2_SHIFTPLAN_WD_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_tff_in_shift_order.
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       26.08.2026     tcs / Roshan Wadhwani
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------


    DATA : lt_methods      TYPE bapi_alm_order_method_t,
 ##NEEDED           lt_header       TYPE bapi_alm_order_headers_i_t,
           ls_operation    TYPE bapi_alm_order_operation_e,
           lt_operation    TYPE TABLE OF bapi_alm_order_operation,
           lt_oper         TYPE bapi_alm_order_operation_et,
           lt_operation_up TYPE bapi_alm_order_operation_ut,
 ##NEEDED           ls_header_up    TYPE bapi_alm_order_headers_up,
 ##NEEDED           lt_header_up    TYPE TABLE OF bapi_alm_order_headers_up,
           lt_return       TYPE bapiret2_t,
           lv_objectkey    TYPE bapi_alm_order_method-objectkey,
           lv_len          TYPE i,
           lv_uname        TYPE co_pernr,
           lv_activity     TYPE vornr,
           lv_refnum       TYPE i,
           lv_objectkeyo   TYPE bapi_alm_order_method-objectkey,
           ls_qual_tff     TYPE ts_qual_tff,
           lv_aufnr        TYPE bapi_alm_order_header_e-orderid.


    CLEAR: lt_methods,
           lt_header,
           lt_operation,
           ls_header_up,
           lt_header_up,
           lt_return,
           lv_objectkey.


*      lv_objectkey = ls_order-aufnr.
    lv_objectkey = iv_shift_aufnr.
    FREE lt_methods.
    lv_aufnr = iv_shift_aufnr.
*get the latest operation number.
    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number        = lv_aufnr
      TABLES
        et_operations = lt_oper
        return        = lt_return.

    SORT lt_oper DESCENDING.
    READ TABLE lt_oper INTO ls_operation INDEX 1.
    IF sy-subrc = 0.
      lv_activity = ls_operation-activity.
    ENDIF.



*     LOOP AT it_qual_tff INTO ls_qual_tff WHERE wa_id = ls_order-zarbstl. "#EC CI_NESTED
    CLEAR : lt_operation, lt_return.

    LOOP AT it_qual_tff INTO ls_qual_tff." WHERE wa_id = iv_shift_aufnr. "#EC CI_NESTED
      IF ls_qual_tff-qual-uname IS NOT INITIAL.

        lv_len = strlen( ls_qual_tff-qual-uname ).
        lv_len = lv_len - 1.
        lv_uname = ls_qual_tff-qual-uname+1(lv_len).

      ENDIF.
      lv_refnum = lv_refnum + 1.
      lv_activity = lv_activity + 10.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_activity
        IMPORTING
          output = lv_activity.

      CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
      APPEND VALUE #(
        refnumber  = lv_refnum
        objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
        method     = if_eams_bo_const=>gc_bapi_ord_method-create
        objectkey  = lv_objectkeyo
      ) TO lt_methods.

      APPEND VALUE #(
        activity    = lv_activity   "'0010'
        control_key = iv_steus "'PM01'
        work_cntr   = ls_qual_tff-qual-personalmodul    "'CH'
        plant       = iv_maintenanceplanningplant
        description = iv_shorttext"ls_result-maintplngbucketlabel
        field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
        duration_normal = '0'"lv_zdlz
        pers_no = lv_uname
        usr04 = iv_usr04
        use04 = iv_use04
        start_cons = is_schichtdetails-start_datum
        strttimcon = is_schichtdetails-start_zeit
        fin_constr = is_schichtdetails-end_datum
        fintimcons = is_schichtdetails-end_zeit
      ) TO lt_operation.

    ENDLOOP.


*    adding new line in operations.
    lv_refnum = lv_refnum + 1.
    lv_activity = lv_activity + 10.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_activity
      IMPORTING
        output = lv_activity.

    CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
    APPEND VALUE #(
      refnumber  = lv_refnum
      objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
      method     = if_eams_bo_const=>gc_bapi_ord_method-create
      objectkey  = lv_objectkeyo
    ) TO lt_methods.

    APPEND VALUE #(
      activity    = lv_activity   "'0010'
      control_key = iv_steus "'PM01'
      work_cntr   = ls_qual_tff-qual-personalmodul    "'CH'
      plant       = iv_maintenanceplanningplant
      description = 'TFF Logistic'
      field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
      duration_normal = '0'"lv_zdlz
      pers_no = ' '
      usr04 = iv_usr04
      use04 = iv_use04
      start_cons = is_schichtdetails-start_datum
      strttimcon = is_schichtdetails-start_zeit
      fin_constr = is_schichtdetails-end_datum
      fintimcons = is_schichtdetails-end_zeit
    ) TO lt_operation.



    lt_operation_up = VALUE #( ( activity = abap_true
                                     control_key = abap_true
                                     work_cntr = abap_true
                                     plant = abap_true
*                                   standard_text_key = abap_true
                                     description = abap_true
                                     field_key = abap_true
                                     duration_normal = abap_true
                                     pers_no = abap_true
                                     usr04 = abap_true
                                     use04 = abap_true
                                     start_cons = abap_true
                                     strttimcon = abap_true
                                     fin_constr = abap_true
                                     fintimcons = abap_true
*                                   calc_key = abap_true
*                                   currency = abap_true
                                      ) ).

*  _METHODS - SAVE
    APPEND VALUE #(
      refnumber  = 1
      objecttype = space
      method     = if_eams_bo_const=>gc_bapi_ord_method-save
      objectkey  = lv_objectkey
    ) TO lt_methods.


*   CALL THE BAPI
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods      = lt_methods
*       it_header       = lt_header
*       it_header_up    = lt_header_up
        it_operation    = lt_operation
        it_operation_up = lt_operation_up
        return          = lt_return.

*   RÜCKGABEVERARBEITUNG
    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->UPDATE_OPR_IN_ADMIN_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ADMIN_AUFNR                 TYPE        AUFNR
* | [--->] IT_QUAL                        TYPE        TT_ZIA_2SF_VEH_SEATS
* | [--->] IV_STEUS                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_USE04                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_USR04                       TYPE        ZIA_2MO_FLD_VALUE
* | [--->] IV_MAINTENANCEPLANNINGPLANT    TYPE        WERKS_D
* | [--->] IV_SHORTTEXT                   TYPE        AUFTEXT
* | [--->] IS_SCHICHTDETAILS              TYPE        ZIA_2_SHIFTPLAN_WD_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_opr_in_admin_orders.
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       06.10.2026     tcs / Roshan Wadhwani
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.50       19.10.2026     tcs / Roshan Wadhwani
*      adding user id repetition check restriction in operation
*-----------------------------------------------------------------------
*  >001<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------


    DATA : lt_methods      TYPE bapi_alm_order_method_t,
 ##NEEDED           lt_header       TYPE bapi_alm_order_headers_i_t,
           ls_operation    TYPE bapi_alm_order_operation_e,
           lt_operation    TYPE TABLE OF bapi_alm_order_operation,
##NEEDED   ls_oper         TYPE bapi_alm_order_operation_e,
           lt_oper         TYPE bapi_alm_order_operation_et,
           lt_operation_up TYPE bapi_alm_order_operation_ut,
 ##NEEDED           ls_header_up    TYPE bapi_alm_order_headers_up,
 ##NEEDED           lt_header_up    TYPE TABLE OF bapi_alm_order_headers_up,
           lt_return       TYPE bapiret2_t,
           lv_objectkey    TYPE bapi_alm_order_method-objectkey,
           lv_len          TYPE i,
           lv_uname        TYPE co_pernr,
           lv_activity     TYPE vornr,
           lv_refnum       TYPE i,
           lv_objectkeyo   TYPE bapi_alm_order_method-objectkey,
           ls_qual     TYPE zia_2sf_veh_seat,
           lv_aufnr        TYPE bapi_alm_order_header_e-orderid.


    CLEAR: lt_methods,
           lt_header,
           lt_operation,
           ls_header_up,
           lt_header_up,
           lt_return,
           lv_objectkey.



    lv_aufnr = iv_admin_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_aufnr
      IMPORTING
        output = lv_aufnr.


*      lv_objectkey = ls_order-aufnr.
*    lv_objectkey = iv_admin_aufnr.
    lv_objectkey = lv_aufnr.
    FREE lt_methods.

*get the latest operation number.
    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number        = lv_aufnr
      TABLES
        et_operations = lt_oper
        return        = lt_return.

    SORT lt_oper DESCENDING.
    READ TABLE lt_oper INTO ls_operation INDEX 1.
    IF sy-subrc = 0.
      lv_activity = ls_operation-activity.
    ENDIF.



*     LOOP AT it_qual_tff INTO ls_qual_tff WHERE wa_id = ls_order-zarbstl. "#EC CI_NESTED
    CLEAR : lt_operation, lt_return.

    LOOP AT it_qual INTO ls_qual." WHERE wa_id = iv_admin_aufnr. "#EC CI_NESTED
      IF ls_qual-uname IS NOT INITIAL.

        lv_len = strlen( ls_qual-uname ).
        lv_len = lv_len - 1.
        lv_uname = ls_qual-uname+1(lv_len).

      ENDIF.
*      adding the below check to stop repetition of the same user.
      READ TABLE lt_oper INTO ls_oper WITH KEY pers_no = lv_uname.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.
      lv_refnum = lv_refnum + 1.
      lv_activity = lv_activity + 10.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_activity
        IMPORTING
          output = lv_activity.

      CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
      APPEND VALUE #(
        refnumber  = lv_refnum
        objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
        method     = if_eams_bo_const=>gc_bapi_ord_method-create
        objectkey  = lv_objectkeyo
      ) TO lt_methods.

      APPEND VALUE #(
        activity    = lv_activity   "'0010'
        control_key = iv_steus "'PM01'
        work_cntr   = ls_qual-personalmodul    "'CH'
        plant       = iv_maintenanceplanningplant
        description = iv_shorttext"ls_result-maintplngbucketlabel
        field_key = 'N_DIENS'
          duration_normal = ls_qual-zdlz
*        duration_normal = '0'"lv_zdlz
        pers_no = lv_uname
        usr04 = iv_usr04
        use04 = iv_use04
        start_cons = is_schichtdetails-start_datum
        strttimcon = is_schichtdetails-start_zeit
        fin_constr = is_schichtdetails-end_datum
        fintimcons = is_schichtdetails-end_zeit
      ) TO lt_operation.

    ENDLOOP.


    IF lt_operation IS NOT INITIAL.

      lt_operation_up = VALUE #( ( activity = abap_true
                                       control_key = abap_true
                                       work_cntr = abap_true
                                       plant = abap_true
*                                   standard_text_key = abap_true
                                       description = abap_true
                                       field_key = abap_true
                                       duration_normal = abap_true
                                       pers_no = abap_true
                                       usr04 = abap_true
                                       use04 = abap_true
                                       start_cons = abap_true
                                       strttimcon = abap_true
                                       fin_constr = abap_true
                                       fintimcons = abap_true
*                                   calc_key = abap_true
*                                   currency = abap_true
                                        ) ).

*  _METHODS - SAVE
      APPEND VALUE #(
        refnumber  = 1
        objecttype = space
        method     = if_eams_bo_const=>gc_bapi_ord_method-save
        objectkey  = lv_objectkey
      ) TO lt_methods.


*   CALL THE BAPI
      CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
        TABLES
          it_methods      = lt_methods
*         it_header       = lt_header
*         it_header_up    = lt_header_up
          it_operation    = lt_operation
          it_operation_up = lt_operation_up
          return          = lt_return.

*   RÜCKGABEVERARBEITUNG
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LOFPM_CLH_WD_ASSIST->CHANGE_DATES_PLANNING_BUCKET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BUCKET_UUID                 TYPE        SYSUUID_X16
* | [--->] IV_ADMIN_AUFNR                 TYPE        AUFNR
* | [--->] IV_START_DATE_TIME             TYPE        TZNTSTMPS
* | [--->] IV_END_DATE_TIME               TYPE        TZNTSTMPS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_dates_planning_bucket.
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       26.10.2026     tcs / Roshan Wadhwani
*          Programmerstellung / Creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
    TYPES: BEGIN OF ts_add_action_response_early,
             mapped   TYPE RESPONSE FOR MAPPED   EARLY zir_cds_c_1planningbucket,
             failed   TYPE RESPONSE FOR FAILED   EARLY zir_cds_c_1planningbucket,
             reported TYPE RESPONSE FOR REPORTED EARLY zir_cds_c_1planningbucket,
           END OF ts_add_action_response_early.

*    "! <p class="shorttext synchronized" lang="en">Type for Additional Action late Response</p>
*           BEGIN OF ts_add_action_response_late,
*             mapped   TYPE RESPONSE FOR MAPPED   LATE zir_cds_c_1planningbucket,
*             failed   TYPE RESPONSE FOR FAILED   LATE zir_cds_c_1planningbucket,
*             reported TYPE RESPONSE FOR REPORTED LATE zir_cds_c_1planningbucket,
*           END OF ts_add_action_response_late,
*
*           "! <p class="shorttext synchronized" lang="en">Type for Bucket early Response</p>
*           BEGIN OF ts_bucket_response_early,
*             mapped   TYPE RESPONSE FOR MAPPED   EARLY r_maintplanningbuckettp_2,
*             failed   TYPE RESPONSE FOR FAILED   EARLY r_maintplanningbuckettp_2,
*             reported TYPE RESPONSE FOR REPORTED EARLY r_maintplanningbuckettp_2,
*           END OF ts_bucket_response_early,
*
*           "! <p class="shorttext synchronized" lang="en">Type for Bucket late Response</p>
*           BEGIN OF ts_bucket_response_late,
*             mapped   TYPE RESPONSE FOR MAPPED   LATE r_maintplanningbuckettp_2,
*             failed   TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
*             reported TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
*           END OF ts_bucket_response_late.

    "Write Admin Order to Bucket Header
    "Adjust Start and End Date

    DATA lt_bucket_update TYPE TABLE FOR UPDATE r_maintplanningbuckettp_2\\maintplanningbuckettp.

    DATA(lo_rap_msg)            = zcl_ir_1pb_rap_msg=>get_instance( ).
*    DATA(ls_action_information) = me->get_action_information( ).
    DATA ls_action_information  TYPE STRUCTURE FOR ACTION IMPORT zir_cds_c_1planningbucket\\zzplngbktadditionalactions~createbucket.

*    DATA(ls_action_response)    = me->get_add_action_response( ).
    DATA ls_action_response TYPE ts_add_action_response_early."    = me->get_add_action_response( ).
*    DATA(ls_result_parameter)   = me->get_result_parameter( ).
    DATA ls_result_parameter TYPE zir_cds_d_1pbactcreatepres.
    DATA(lv_admin_order)        = CONV aufnr( |{ ls_result_parameter-maintorderforadministration ALPHA = IN }| ).

*    IF me->is_bucket_locked( ) EQ abap_true.
*      RETURN abap_false.
*    ENDIF.
*********************

    DATA(lt_locked_bucket) = zcl_ir_1pb_mpb=>determine_locked_buckets( VALUE #( ( bucket_uuid = iv_bucket_uuid ) ) ).

    IF lt_locked_bucket IS INITIAL.
      CLEAR sy-subrc.
    ELSE.
*      RETURN abap_false.
      RETURN.
    ENDIF.


*********************
    DATA(lv_duration) = cl_abap_tstmp=>subtract( tstmp1 = iv_end_date_time
                                                 tstmp2 = iv_start_date_time ).

*    APPEND VALUE #( %key-maintplanningbucketuuid          = ls_result_parameter-maintplanningbucketuuid
*                    %data-maintorderforadministration     = lv_admin_order
*                    %data-maintplngbucketstartdatetime    = ls_action_information-%param-startdateandtime
*                    %data-maintplngbucketenddatetime      = ls_action_information-%param-enddateandtime

    APPEND VALUE #( %key-maintplanningbucketuuid          = iv_bucket_uuid
                    %data-maintorderforadministration     = iv_admin_aufnr
                    %data-maintplngbucketstartdatetime    = iv_start_date_time
                    %data-maintplngbucketenddatetime      = iv_end_date_time

                    %data-maintplngbucketduration         = COND #( WHEN lv_duration LT 3600  THEN lv_duration / 60
                                                                    WHEN lv_duration LT 86400 THEN lv_duration / 3600
                                                                    ELSE                           lv_duration / 86400 )

                    %data-maintplngbucketdurationunit     = COND #( WHEN lv_duration LT 3600  THEN zif_ir_1pb_c=>mc_bucket_duration_unit-minutes
                                                                    WHEN lv_duration LT 86400 THEN zif_ir_1pb_c=>mc_bucket_duration_unit-hours
                                                                    ELSE                           zif_ir_1pb_c=>mc_bucket_duration_unit-days )

                    %control-maintorderforadministration  = COND #( WHEN lv_admin_order IS NOT INITIAL
                                                                    THEN if_abap_behv=>mk-on
                                                                    ELSE if_abap_behv=>mk-off )

                    %control-maintplngbucketstartdatetime = if_abap_behv=>mk-on
                    %control-maintplngbucketenddatetime   = if_abap_behv=>mk-on
                    %control-maintplngbucketduration      = if_abap_behv=>mk-on
                    %control-maintplngbucketdurationunit  = if_abap_behv=>mk-on ) TO lt_bucket_update.

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
        UPDATE FROM lt_bucket_update
    FAILED   DATA(ls_bucket_update_failed)
    REPORTED DATA(ls_bucket_update_reported).

    IF ls_bucket_update_failed IS NOT INITIAL.
      lo_rap_msg->msg_add_failed( EXPORTING iv_content_id    = ls_action_information-%cid
                                            iv_action_name   = zcl_ir_1pb_add_action_bp=>mc_action-create_bucket
                                            iv_fail_cause    = if_abap_behv=>cause-conflict
                                  CHANGING  cs_action_failed = ls_action_response-failed ).

      ls_action_response-reported-zzplngbktadditionalactions = VALUE #( BASE ls_action_response-reported-zzplngbktadditionalactions
                                                                        FOR <ls_bucket_reported> IN ls_bucket_update_reported-maintplanningbuckettp
                                                                        WHERE ( %msg->if_t100_dyn_msg~msgty EQ zif_ir_1pb_c=>mc_message_type-error )
                                                                        ( %cid                 = ls_action_information-%cid
                                                                          %msg                 = <ls_bucket_reported>-%msg
                                                                          %action-createbucket = if_abap_behv=>mk-on  ) ).
*      me->set_add_action_response( ls_action_response ).

    ELSE.

      me->commit_pb( ).

    ENDIF.

*    RETURN COND #( WHEN ls_bucket_update_failed IS INITIAL
*                   THEN abap_true
*                   ELSE abap_false ).

  ENDMETHOD.
ENDCLASS.