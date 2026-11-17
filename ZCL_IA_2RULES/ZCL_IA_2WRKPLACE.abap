class ZCL_IA_2WRKPLACE definition
  public
  final
  create public .

public section.

  types:
    tt_aufnr TYPE STANDARD TABLE OF aufnr WITH DEFAULT KEY .
  types:
    BEGIN OF ts_einzelkapas_ref,
        object TYPE REF TO zcl_ia_2indiv_capcity,
      END OF ts_einzelkapas_ref .
  types:
    tt_einzelkapas_ref TYPE STANDARD TABLE OF ts_einzelkapas_ref  WITH DEFAULT KEY .
  types:
    BEGIN OF ts_adjust_tab,
        sperrabschnitt TYPE zia_2sf_bs,
        increment      TYPE i,
      END OF ts_adjust_tab .
  types:
    tt_v_map_as TYPE STANDARD TABLE OF zia_d_2_map_as WITH DEFAULT KEY .
  types:
    BEGIN OF ts_anzahl_qual,
        aufnr       TYPE aufnr,
        er_ir       TYPE ziA_2_er_ir,
        anzahl_qual TYPE zIA_2_anzahl_qual,
      END OF ts_anzahl_qual .
  types:
    tt_anzahl_qual TYPE STANDARD TABLE OF ts_anzahl_qual WITH DEFAULT KEY .
  types:
    BEGIN OF ts_pneu_kennzeichen,
        zarbstbez TYPE zia_2_arbstbez_kennzeichen,
        index     TYPE zia_2_index,
      END OF ts_pneu_kennzeichen .
  types:
    tt_pneu_kennzeichen TYPE STANDARD TABLE OF ts_pneu_kennzeichen WITH DEFAULT KEY .
  types:
*  types:
*    tts_v_map_as TYPE STANDARD TABLE OF zia_2_v_map_as WITH DEFAULT KEY .
    BEGIN OF ts_sp_ktext,
        position   TYPE int1,
        prefix     TYPE char1,
        index      TYPE n LENGTH 2,
        zugangsart TYPE zia_2_zugangsart,
        name       TYPE zia_2_id_btg,
        btg        TYPE char40,
      END OF ts_sp_ktext .
  types:
    tt_sp_ktext TYPE STANDARD TABLE OF ts_sp_ktext WITH DEFAULT KEY .
  types:
*  types:
*    tt_sp_ktext TYPE STANDARD TABLE OF ts_sp_ktext WITH DEFAULT KEY .
    BEGIN OF ts_as_km_sort,
        zarbstl TYPE zia_2_id_arbstl,
        km_max  TYPE zia_2_km_bis,
      END OF ts_as_km_sort .
  types:
    tt_as_km_sort TYPE STANDARD TABLE OF ts_as_km_sort WITH DEFAULT KEY .
  types:
    BEGIN OF ts_km,
        km_von TYPE zia_2_km_von,
        km_bis TYPE zia_2_km_bis,
      END OF ts_km .
  types:
    tt_km TYPE STANDARD TABLE OF ts_km WITH DEFAULT KEY .

  constants:
    BEGIN OF mc_sperrabs,
        e  TYPE zia_2_roehre VALUE 'E',
        e1 TYPE zia_2_roehre VALUE 'E1',
        e2 TYPE zia_2_roehre VALUE 'E2',
        e3 TYPE zia_2_roehre VALUE 'E3',
        w  TYPE zia_2_roehre VALUE 'W',
        w1 TYPE zia_2_roehre VALUE 'W1',
        w2 TYPE zia_2_roehre VALUE 'W2',
        w3 TYPE zia_2_roehre VALUE 'W3',
      END OF mc_sperrabs .
  constants:
    BEGIN OF mc_perimeters,
        gbt TYPE zia_2_perimeters VALUE 'GBT',
        cbt TYPE zia_2_perimeters VALUE 'GBT',
      END OF mc_perimeters .
  data GS_ARBEITSSTELLE type ZIA_2SF_WA .
  constants MC_INTERVALLART_LI type ZIA_2_INTERVALLART value 'LI' ##NO_TEXT.

  methods GET_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT .
  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !IV_ID type ZIA_2ID optional
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT optional .
  methods GET_DATA
    returning
      value(RS_DATA) type ZIA_2SF_WA .
  methods GET_KURZTEXT
    importing
      !IV_ZGART_TXT type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_TEXT) type STRING .
  methods CHECK_AS_IS_IN_TUNNEL
    returning
      value(RV_IS_TUNNEL) type BOOLEAN .
  methods GET_AUFTRAG
    importing
      !IS_FILTER type ZIA_2ORDER optional
      !IV_INDEX type INTEGER optional
      !IV_KEY type AUFNR optional
    returning
      value(RO_OBJECT) type ref to ZCL_IA_2ORDER .
  methods GET_FAHRZEUGE
    importing
      !IV_FILTER_FZTYP type ZIA_2_ID_FZTYP optional
    returning
      value(RO_FAHRZEUGE) type ref to CL_OBJECT_MAP .
  methods GET_ID
    returning
      value(RV_ID) type ZIA_2_ID_AS .
  methods GET_AUFTRAEGE
    importing
      !IS_FILTER type ZIA_2ORDER optional
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods HAS_MET
    exporting
      !ES_MET type ZIA_2MET
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods HAS_TS_REFERENCE
    returning
      value(RV_YES) type XSDBOOLEAN .
  methods IS_PNEU
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_SCHIENE
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_ABHAENGIG
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods SET_DATA
    importing
      !IS_DATA type ZIA_2SF_WA .
  methods GET_ZUGANGSARTEN
    returning
      value(RS_ZUGANGSARTEN) type ZIA_2_ACCESS_TYP .
  methods IS_BTG
    exporting
      !EV_ID_BTG type ZIA_2_ID_BTG
    returning
      value(RV_BOOLEAN) type WDY_BOOLEAN .
  methods GET_MAP_SP_AS
    importing
      !IV_REFRESH type ABAP_BOOL optional
    returning
      value(RT_DATA) type TT_V_MAP_AS .
  methods GET_PNEU_KENNZEICHEN
    returning
      value(RT_DATA) type TT_PNEU_KENNZEICHEN .
  methods GET_BTG
    exporting
      !EV_LAGE type ZIA_2_LAGE
      !EV_DIDOK type ZIA_2_DIDOK
      !EV_ID_BTG type ZIA_2_ID_BTG
      !EV_INDEX type ZIA_2_INDEX .
  methods RELOAD_AUFTRAG_O
    importing
      !IO_ORDER type ref to ZCL_IA_2ORDER
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods ADD_FAHRZEUG
    importing
      !IO_FAHRZEUG type ref to ZCL_IA_2VEHICLE .
  methods ADD_SP_ZEIT
    importing
      !IO_SP_ZEIT type ref to ZCL_IA_2RESTR_ASSO_TIMS .
  methods ADD_SP_KM
    importing
      !IO_SP_KM type ref to ZCL_IA_2_SP_KILOMETER .
  methods DETERMINE_ZID_EIZ_VALUE
    importing
      !IV_DEFAULT type ZIA_2_ID_EIZ
      !IV_PREFIX type ZIA_2_MET_AS_NAME_PREFIX optional
      !IV_USE_CONDITON type ABAP_BOOL default ' '
    returning
      value(RV_ZID_EIZ) type ZIA_2_ID_EIZ .
  methods GET_SP_KILOMETER
    returning
      value(RO_SP_KILOMETER) type ref to CL_OBJECT_MAP .
  methods GET_TEXT_ID
    importing
      !IV_ZUGANGSART type ZIA_2_ZUGANGSART
      !IV_INC_TS type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_VALUE) type ZIA_2_ARBST .
  methods HAS_TS
    returning
      value(RV_HAS_TS) type BOOLEAN .
  methods IS_IN_TUNNEL
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods GET_PERIMETER
    returning
      value(RV_VALUE) type ZIA_2_PERIMETERS .
  methods GET_SITZPLAETZE
    returning
      value(RO_SITZPLAETZE) type ref to CL_OBJECT_MAP .
  methods GET_SPERRABSCHNITTE_AS_TEXT
    returning
      value(RV_VALUE) type ZIA_2_SPERRABSCHNITT_TEXT .
  methods GET_SUPPLY_TYPE_AS_TEXT
    returning
      value(RV_DATA) type BOOLEAN .
  methods GET_LINUMBER_AS_TEXT
    returning
      value(RV_VALUE) type ZIA_2_LINUMBER_TEXT .
  methods RELOAD .
  methods EXISTS
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods GET_WD_HEADER_TEXT
    returning
      value(RV_TEXT) type ZIA_2_AS_HEADER_TEXT .
  methods GET_INTERVALLARTEN
    returning
      value(RS_INTERVALLARTEN) type ZIA_2_INTERVAL_TYPE_S .
  class-methods GET_INSTANCE
    importing
      !IV_SCHICHT_ID type ZIA_2_SCHICHT
      !IV_ARBSTLE_ID type ZIA_2_ID_ARBSTL
    returning
      value(RO_INSTANCE) type ref to ZCL_IA_2WRKPLACE .
  methods SET_SCHICHT
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT .
  methods IS_IN_QS
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods GET_AKO
    returning
      value(RS_SITZPLATZ) type ZIA_2SF_VEH_SEAT .
  methods SET_ETAPPENAUFTRAG
    importing
      !IV_AUFNR type AUFNR .
  methods SET_FAHRZEUGE
    importing
      !IO_FAHRZEUGE type ref to CL_OBJECT_MAP .
  methods REMOVE_AUFTRAEGE
    importing
      !IV_CHANGE_ERP type BOOLEAN default ABAP_TRUE
    raising  " exceptions
      ZCX_IA_2FAILURE .
  methods REMOVE_AUFTRAG_O
    importing
      !IO_OBJECT type ref to ZCL_IA_2ORDER optional
      !IV_CHANGE_ERP type BOOLEAN default ABAP_TRUE
    raising
      ZCX_IA_2FAILURE .
  methods REMOVE_FAHRZEUG
    importing
      !IO_FAHRZEUG type ref to ZCL_IA_2VEHICLE
    raising
      ZCX_IA_2FAILURE .
  methods REFRESH_EIZ_EST
    importing
      !IS_AUFTRAG type ZIA_2ORDER optional .
  methods REMOVE_FAHRZEUGE .
  methods LOCK_SUB_OBJECTS
    importing
      !IV_CHECK type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  methods REFRESH_MANUAL_SIGNALS .
  methods REFRESH_AUSDEHUNG .
  methods SAVE
    importing
      !IV_SAVE_DIRECTLY type BOOLEAN optional .
  methods GET_SP_ZEITEN
    returning
      value(RO_SP_ZEITEN) type ref to CL_OBJECT_MAP .
  methods GET_SPERRABSCHNITTE
    importing
      !IV_ZUGANGSART type ZIA_2_ZUGANGSART optional
    returning
      value(RT_MAP_AS_SZG) type ZIA_2MAP_AS_SZG_T .
  methods LOCK
    importing
      !IV_CHECK type BOOLEAN optional
    raising
      ZCX_IA_2FAILURE .
  methods REMOVE_VORSCHAU .
  methods UNLOCK_SUB_OBJECTS
    raising
      ZCX_IA_2FAILURE .
  methods UNLOCK .
  methods IS_EMPTY
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_FZG_KM_SA_TRENNUNG_VALID
    returning
      value(RV_VALUE) type BOOLEAN .
  methods GET_SIGABS_BY_SP
    importing
      !IV_INCLUDE_MANUAL type BOOLEAN default ABAP_FALSE
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
    returning
      value(RT_SIGABS_EHB) type ZIA_2_SGNL_SEC_T .
  methods GET_ARBEITSZEIT
    returning
      value(RS_DATA) type ZIA_2_WORKPLACE_ZEIT .
  methods ADD_SP
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
      !IV_ZUGANGSART type ZIA_2_ZUGANGSART .
  methods GET_SP_DETAILS_WD
    exporting
      !ET_SP_EHB type ZIA_2SP_EHB_WD_T
    changing
      !CT_SP_DETAILS type ZIA_2SP_DETIALS_WD_T optional .
  methods GET_SIGABS_BY_SP_AS_TEXT
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
    returning
      value(RV_SIGABS_EHB) type STRINGVAL .
  methods SET_MET
    importing
      !IV_ID_MET type ZIA_2_ID_MET
      !IV_IGNORE_ERRORS type ABAP_BOOL optional .
  methods REMOVE_MET .
  methods ADD_FAHRZEUGE
    importing
      !IO_OBJECTS type ref to CL_OBJECT_MAP
      !IV_VORSCHAU type BOOLEAN optional .
  methods SET_MET_AS_NAME_PREFIX
    importing
      !IV_PREFIX type ZIA_2_MET_AS_NAME_PREFIX .
  methods GET_COLOR
    returning
      value(RV_COLOR) type STRINGVAL .
  methods GET_SITZPLATZ_BY_ID
    importing
      !IV_SITZPLATZ_ID type ZIA_2ID
    returning
      value(RO_SITZPLATZ) type ref to ZCL_IA_2SEAT .
  methods GET_NETTOARBEITSZEIT
    returning
      value(RV_ARBEITSZEIT) type ZIA_2_ARBEITSZEIT .
  methods HAS_OSX
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods ADD_AUFTRAG_O
    importing
      !IO_ORDER type ref to ZCL_IA_2ORDER optional
      !IS_AUFTRAG type ZIA_2ORDER optional
      !IV_AUFNR type AUFNR optional
      !IV_TESTRUN type BOOLEAN optional
      !IV_IGNORE_ERRORS type BOOLEAN optional
      !IV_AUTO_PLANNING type BOOLEAN optional
      !IV_SKIP_VALIDATIONS type BOOLEAN optional
      !IV_FIRST_ORDER type BOOLEAN optional
      !IV_VORSCHAU type BOOLEAN optional
      !IV_PLANNED_ORD_CAPACITY type BOOLEAN optional
    returning
      value(RV_SUCCESS) type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  methods HAS_AUFTRAG
    importing
      !IV_AUFNR type AUFNR
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_IN_OS_NORD
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_IN_OS_SUED
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods GET_AUFTRAEGE_WD
    returning
      value(RT_LIST) type ZIA_2JOBPOOL_WD_T .
  methods ARE_VEHICLES_REFERENCED
    returning
      value(RV_VALUE) type BOOLEAN .
  methods GET_SIGNALABSCHNITT_NEXT
    importing
      !IS_SA type ZIA_2SC
      !IT_SA_RNG type ZIA_2SPABSCH_RANGE_T optional
    returning
      value(RS_SA) type ZIA_2SC .
  methods GET_SIGNALABSCHNITT_PREV
    importing
      !IS_SA type ZIA_2SC
    returning
      value(RS_SA) type ZIA_2SC .
  methods GET_EZ_FORM
    importing
      !IV_RICHTUNG type ZIA_2_RICHTUNG optional
      !IV_ACTIVE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_VALUE) type ZIA_2EZ_FORM_T .
  methods GET_EIZ_DESCRIPTION
    returning
      value(RV_VALUE) type ZIA_2_EIZ_DESCRIPTION .
  methods CONTAINS_MANUAL_SIGNALS
    returning
      value(RV_RESULT) type BOOLEAN .
  methods SET_ZKMIN
    importing
      !IV_ZKMIN type ZIA_2SF_WA-ZKMIN .
  methods SET_ZKMAX
    importing
      !IV_ZKMAX type ZIA_2SF_WA-ZKMAX .
  methods GET_SPERRABSCHNITTE_WITH_ID
    importing
      !IV_ZUGANGSART type ZIA_2_ZUGANGSART optional
    returning
      value(RT_VALUE) type ZIA_2_SPID_SPABS_INTART_T .
  methods GET_AL
    returning
      value(RT_SITZPLAETZE) type ZIA_2FZG_PL_T .
  methods GET_THF
    returning
      value(RT_SITZPLAETZE) type ZIA_2FZG_PL_T .
  methods GET_SC
    returning
      value(RT_SITZPLAETZE) type ZIA_2FZG_PL_T .
  methods GET_RJ_EST
    returning
      value(RV_EST) type ZIA_2_ROEHRE .
  methods SET_INITAL_AUSDEHNUNG_SP
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER .
  methods GET_SA_EXT_FOR_NEW_AUFTRAG
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
    returning
      value(RT_SA) type ZIA_2_SGNL_SEC_T .
  methods GET_SA_FOR_NEW_AUFTRAG
    importing
      !IV_RJ_EST type ZIA_2_BLOCKING_SECTION
      !IV_TS_EST type ZIA_2_BLOCKING_SECTION
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
    returning
      value(RT_SA) type ZIA_2_SGNL_SEC_T .
  methods GET_MAX_AUSLASTUNG
    returning
      value(RV_VALUE) type ZIA_2_AUSLASTUNG_TIME .
  methods GET_MET
    returning
      value(RS_VALUE) type ZIA_2MET .
  methods GET_SA
    importing
      !IV_PERIMETER type ZIA_2_PERIMETERS
      !IV_KM_VON type ZIA_2_KM_VON
      !IV_KM_BIS type ZIA_2_KM_BIS
      !IT_ZEST type ANY TABLE
    returning
      value(RT_SA) type ZIA_2_SGNL_SEC_T .
  methods GET_KM_VIS_FROM
    importing
      !IV_PERIMETER type ZIA_2_PERIMETERS
      !IV_KM_VON type ZIA_2_KM_VON
      !IV_KM_BIS type ZIA_2_KM_BIS
      !IT_ZEST type ANY TABLE
    returning
      value(RS_KM) type TS_KM .
  methods SET_TREMOLA_CALC
    importing
      !IV_DATA type ABAP_BOOL .
  methods GET_KM_MIN_MAX
    importing
      !IV_MFS type ZIA_2_DIDOK
      !IV_KM type ZIA_2_KM_BIS
      !IV_RJ_EST type ZIA_2_BLOCKING_SECTION
    exporting
      !EV_KMIN type ZIA_2_KM_MET
      !EV_KMAX type ZIA_2_KM_MET .
  methods FUELLE_ARBEITSSTELLE
    importing
      !IV_MAX_AUSLASTUNG type ZIA_2_AUSLASTUNG .
  methods GET_AUFTRAEGE_PLANUNG
    importing
      !IV_KM_MIN type ZIA_2_KM optional
      !IV_KM_MAX type ZIA_2_KM optional
    returning
      value(RT_AUFTRAEGE) type ZIA_2ORDER_T .
  methods VERIFY_AND_ADD_SP_FOR_ORDER
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER .
  methods INITIALIZE_AUFTRAG
    importing
      !IV_AUFNR type AUFNR
      !IS_AUFTRAG type ZIA_2ORDER
      !IO_ORDER type ref to ZCL_IA_2ORDER
    exporting
      !EO_ORDER type ref to ZCL_IA_2ORDER
      !ES_ORDER type ZIA_2ORDER .
  methods VALIDATE_ORDER
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
      !IS_AUFTRAG type ZIA_2ORDER
      !IV_AUTO_PLANNING type BOOLEAN
      !IV_IGNORE_ERRORS type BOOLEAN
      !IV_VORSCHAU type BOOLEAN
    exporting
      !ET_EINZELKAPAS type ZIA_2EINZELKAPAS_T
      !EV_IS_VALID type BOOLEAN
      !EV_HAS_ERRORS type BOOLEAN
      !EV_CRITICAL type BOOLEAN .
  methods DETERMINE_ORDER_VEHICLES
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_AUFTRAG type ZIA_2ORDER
      !IV_IGNORE_ERRORS type BOOLEAN
      !IV_VORSCHAU type ZIA_2_VORSCHAU
      !IV_ZZZUGANGSART type ZIA_2_ACCESSTYP
      !IV_PLANUNG_OS type BOOLEAN
      !IV_AUTO_PLANNING type BOOLEAN
    exporting
      !EO_FAHRZEUGE type ref to CL_OBJECT_MAP
      !EV_HAS_ERRORS type BOOLEAN .
  methods ENSURE_MATCHING_VEHICLE_EXISTS
    importing
      !IS_AUFTRAG type ZIA_2ORDER
    exporting
      !EO_FAHRZEUGE_I type ref to CL_OBJECT_COLLECTION_ITERATOR
      !EO_FAHRZEUG type ref to ZCL_IA_2VEHICLE
      !EV_FZG_VORHANDEN type BOOLEAN .
  methods ADD_BASIS_FAHRZEUGE
    importing
      !IV_FZG_VORHANDEN type BOOLEAN
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IV_IGNORE_ERRORS type BOOLEAN
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
      !IV_VORSCHAU type BOOLEAN
    exporting
      !EO_FAHRZEUGE type ref to CL_OBJECT_MAP .
  methods CHECK_EINZELKAPAS_VALIDITY
    importing
      !IS_AUFTRAG type ZIA_2ORDER
      !IV_IGNORE_ERRORS type BOOLEAN
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IV_AUTO_PLANNING type BOOLEAN
      !IV_PLANNED_ORD_CAPACITY type BOOLEAN optional
    exporting
      !EV_CRITICAL_ERROR type BOOLEAN
      !ET_EINZELKAPAS type ZIA_2_ORDER_CAP_T
      !EV_SUCCESS type BOOLEAN
      !EV_HAS_ERRORS type BOOLEAN
    returning
      value(RV_IS_VALID) type BOOLEAN .
  methods LOCK_SINGLE_CAPACITIES
    importing
      !IT_EINZELKAPAS type ZIA_2EINZELKAPAS_T
    exporting
      !EO_FAHRZEUGE_I type ref to CL_OBJECT_COLLECTION_ITERATOR
      !EO_FAHRZEUG type ref to ZCL_IA_2VEHICLE
      !EO_SITZPLATZ type ref to ZCL_IA_2SEAT .
  methods ADD_FAHRZEUGE_AND_ORDER
    importing
      !IO_FAHRZEUGE type ref to CL_OBJECT_MAP
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
      !IV_VORSCHAU type BOOLEAN
      !IT_EINZELKAPAS type ZIA_2EINZELKAPAS_T
      !IV_IGNORE_ERRORS type BOOLEAN
    exporting
      !EO_FAHRZEUGE_I type ref to CL_OBJECT_COLLECTION_ITERATOR
      !EO_FAHRZEUG type ref to ZCL_IA_2VEHICLE
      !EO_SITZPLATZ type ref to ZCL_IA_2SEAT
    returning
      value(RX_FEHLER) type ref to ZCX_IA_2FAILURE .
  methods SAVE_EZ_FORM
    importing
      !IT_EZ_FORM type ZIA_2_EZ_FRM_T
      !IS_INNER_SP_ZEITEN type ZIA_2SF_BS_TIME optional
      !IV_CALLED_FROM type ZIA_2_TREMOLA_CALLED_FROM optional .
  methods CLEAR_ZUGNUMMER
    importing
      !IV_CALLED_FROM type ZIA_2_TREMOLA_CALLED_FROM .
  methods GET_EZ_FORM_DB
    importing
      !IV_NEW type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_DATA) type ZIA_2_EZ_FRM_T .
  methods SET_ZUGNUMMER
    importing
      !IV_ZUGNUMMER type ZIA_2_ZUG_ID .
  methods GET_SP_ZEITEN_DATA
    importing
      !IV_SPERRABSCHNITT type ZIA_2_SPABS
    returning
      value(RS_VALUE) type ZIA_2SF_BS_TIME .
  methods GET_SPERRABSCHNITTE_KM
    importing
      !IV_ZUGANGSART type ZIA_2_ZUGANGSART optional
    returning
      value(RT_VALUE) type ZIA_2ARBSTL_SPABSCHT_KM_T .
  methods CHECK_LOCK_ORDERS
    importing
      !IO_OBJECT type ref to ZCL_IA_2ORDER optional
      !IV_AUFNR type AUFNR optional
    exporting
      !ET_BAPIRET type BAPIRET2_T .
protected section.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ts_min_km ,
      perimeter      TYPE zia_2_perimeters,
      sperrabschnitt TYPE zia_2_spabs,
      min_km         TYPE zia_2_km,
    END   OF ts_min_km .
  TYPES:
    tt_min_km TYPE STANDARD TABLE OF ts_min_km WITH EMPTY KEY .
  TYPES:
##NEEDED    tt_adjust_tab TYPE STANDARD TABLE OF ts_adjust_tab WITH DEFAULT KEY .
  TYPES:
    BEGIN OF ts_sp_zeiten_tab,
      sperras_id     TYPE zia_2_sperras_id,
      sperrabschnitt TYPE zia_2_roehre,
      zintervallart  TYPE zia_2_intervallart,
      start_datum    TYPE pm_ordgstrp,
      start_zeit     TYPE co_gsuzp,
      end_datum      TYPE co_gltrp,
      end_zeit       TYPE co_gluzp,
    END OF ts_sp_zeiten_tab .
  TYPES:
    tt_sp_zeiten_tab TYPE STANDARD TABLE OF ts_sp_zeiten_tab WITH DEFAULT KEY .

  DATA go_schicht TYPE REF TO zcl_ia_2workshift .
  DATA go_orders TYPE REF TO cl_object_map .
  DATA go_fahrzeuge TYPE REF TO cl_object_map .
*  data GO_ARBEITSSTELLE_GRUPPE type ref to ZCL_IA_2ARBEITSSTELLE_GRUPPE .
  DATA go_sp_kilometer TYPE REF TO cl_object_map .
  DATA go_sp_zeiten TYPE REF TO cl_object_map .
  CLASS-DATA mt_min_km TYPE tt_min_km .
  DATA gt_map_sp_as TYPE tt_v_map_as .
  DATA gt_map_as_szg TYPE zia_2map_as_szg_t .
 ##NEEDED  DATA gs_schicht TYPE zia_2_wrkshifts .
  DATA gt_auftraege_planung TYPE zia_2order_t .
  DATA gt_ez_form_db TYPE zia_2_ez_frm_t .

  CLASS-METHODS init_min_km .
  CLASS-METHODS add_min_km
    IMPORTING
      !iv_perimeter      TYPE zia_2_perimeters
      !iv_sperrabschnitt TYPE zia_2_spabs .
  CLASS-METHODS select_sa_km_min
    IMPORTING
      !iv_perimeter      TYPE zia_2_perimeters
      !iv_sperrabschnitt TYPE zia_2_spabs
    RETURNING
      VALUE(rt_value)    TYPE tt_min_km .
  METHODS get_sp_ktext_tab
    EXPORTING
      VALUE(et_data) TYPE tt_sp_ktext .
  METHODS get_ref_ts_aufnr  ##RELAX
    RETURNING
##NEEDED      VALUE(rs_auftrag) TYPE zia_2order .
  METHODS refresh_fahrleitungsschaltung .
  METHODS refresh_ausdehnung_met .
  METHODS refresh_sa_sp .
  METHODS get_sperrabschnitte_range
    RETURNING
      VALUE(rt_range) TYPE zia_2spabsch_range_t .
  METHODS remove_sp
    IMPORTING
      !iv_sperras_id TYPE zia_2_sperras_id .
  METHODS get_sp_zeiten_tab
    RETURNING
      VALUE(rt_data) TYPE tt_sp_zeiten_tab .
  METHODS fuelle_arbeitsort_new
    IMPORTING
      !is_auftrag TYPE zia_2order .
  METHODS set_zugnummer_from_ez_form
    IMPORTING
      !it_ez_form     TYPE zia_2_ez_frm_t
      !iv_called_from TYPE zia_2_tremola_called_from OPTIONAL .
  METHODS update_zugnummer .
  METHODS update_zeiten_from_spabsid .
  METHODS select_sp_schicht
    IMPORTING
      !iv_sperras_id  TYPE zia_2_sperras_id
    RETURNING
      VALUE(rs_value) TYPE zia_2sf_bs .
  METHODS calculate_as_times
    IMPORTING
      !it_ez_form         TYPE zia_2_ez_frm_t
      !is_inner_sp_zeiten TYPE zia_2sf_bs_time .
  METHODS get_trasse_data_for_ez_form
    IMPORTING
      !it_ez_form       TYPE zia_2_ez_frm_t
      !iv_richtung      TYPE zia_2_richtung
##NEEDED      !iv_intervallart  TYPE zia_2_intervallart OPTIONAL
    EXPORTING
      !ev_betriebspunkt TYPE zia_2_betriebspunkt
      !ev_date          TYPE dats
      !ev_time          TYPE tims .
  METHODS calculate_as_time
    IMPORTING
      !iv_betriebspunkt  TYPE zia_2_betriebspunkt
      !iv_sperrabschnitt TYPE zia_2_spabs
##NEEDED      !iv_intervallart   TYPE zia_2_intervallart OPTIONAL
      !iv_richtung       TYPE zia_2_richtung
    CHANGING
      !cv_date           TYPE dats
      !cv_time           TYPE tims .
  METHODS delete_ez_form
    IMPORTING
      !it_ez_form TYPE zia_2_ez_frm_t .
  METHODS get_km_von_for_calc
    IMPORTING
      !iv_betriebspunkt  TYPE zia_2_betriebspunkt
      !iv_sperrabschnitt TYPE zia_2_spabs
      !iv_richtung       TYPE zia_2_richtung
    RETURNING
      VALUE(rv_value)    TYPE zia_2_km .
  METHODS insert_ez_form
    IMPORTING
      !it_ez_form TYPE zia_2_ez_frm_t .
  METHODS adjust_km_for_sperrabschnitt
    IMPORTING
      !iv_sperrabschnitt TYPE zia_2_spabs
    CHANGING
      !cv_km             TYPE zia_2_km .
  METHODS get_km_bis_for_calc
    IMPORTING
      !iv_richtung    TYPE zia_2_richtung
    RETURNING
      VALUE(rv_value) TYPE zia_2_km .
  METHODS get_min_km_for_calc
    IMPORTING
      !iv_richtung    TYPE zia_2_richtung
    RETURNING
      VALUE(rv_value) TYPE zia_2_zeitabzug_pro_km_fs .
ENDCLASS.



CLASS ZCL_IA_2WRKPLACE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2WRKPLACE=>ADD_MIN_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_min_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: ADD MIN KM
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - ADD_MIN_KM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    READ TABLE mt_min_km ASSIGNING FIELD-SYMBOL(<ls_min_km>)
       WITH KEY perimeter      = iv_perimeter
                sperrabschnitt = iv_sperrabschnitt
                BINARY SEARCH.
    IF <ls_min_km> IS NOT ASSIGNED.
      INSERT VALUE #( perimeter      = iv_perimeter
                      sperrabschnitt = iv_sperrabschnitt
                    ) INTO mt_min_km INDEX sy-tabix ASSIGNING <ls_min_km>.
    ENDIF.
    CHECK <ls_min_km> IS ASSIGNED.

    DATA(lt_km) = select_sa_km_min( iv_perimeter = iv_perimeter iv_sperrabschnitt = iv_sperrabschnitt ).

    SORT lt_km BY min_km.

    READ TABLE lt_km INTO DATA(ls_km_prev) INDEX 1.

    DATA: lv_dist TYPE zia_2_km.
    LOOP AT lt_km ASSIGNING FIELD-SYMBOL(<ls_km>).
      lv_dist = <ls_km>-min_km - ls_km_prev-min_km.
      IF lv_dist > 2.
        <ls_min_km>-min_km = <ls_km>-min_km.
        RETURN.
      ENDIF.
      ls_km_prev = <ls_km>.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CHECK_AS_IS_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_IS_TUNNEL                   TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_as_is_in_tunnel.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: SETTING RETURN VARIABLE AS ABAP TRUE
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - CHECK_AS_IS_IN_TUNNEL
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    " SETTING RETURN VARIABLE AS ABAP TRUE
    rv_is_tunnel = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2WRKPLACE=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Calling init_min_km
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - CLASS_CONSTRUCTOR
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    init_min_km( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIA_2ID(optional)
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - CONSTRUCTOR
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    me->go_orders = NEW cl_object_map( ).
    me->go_fahrzeuge = NEW cl_object_map( ).
    me->go_sp_zeiten = NEW cl_object_map( ).
    me->go_sp_kilometer = NEW cl_object_map( ).

    me->go_schicht = io_schicht.

    IF iv_id IS INITIAL. " NEUE AS, HOLE ARBEITSSTELLEN-ID
      ##UNHANDLED_FUNC_EXCEPTION_OK
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr = '1'
          object      = 'ZIA_2GBT'
        IMPORTING
          number      = me->gs_arbeitsstelle-zarbstl.
    ELSE. " VORHANDENE AS, LESE AS-DATEN EIN
      me->gs_arbeitsstelle-zarbstl = iv_id.
      me->reload( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AUFTRAEGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_FILTER                      TYPE        ZIA_2ORDER(optional)
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftraege.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: RETURNS THE ORDERS TO THE WORKSTATION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_AUFTRAEGE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag   TYPE REF TO zcl_ia_2order.


    IF is_filter IS NOT INITIAL.
      lo_aufttag_i ?= go_orders->get_values_iterator( ).
*      CREATE OBJECT ro_objects.
      ro_objects = NEW cl_object_map( ).

      WHILE lo_aufttag_i->has_next( ) = abap_true.
        lo_auftrag ?= lo_aufttag_i->get_next( ).

        ro_objects->put( EXPORTING key = lo_auftrag->get_data( )-aufnr value = lo_auftrag ).

      ENDWHILE.
    ELSE.
      ro_objects = me->go_orders.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_FILTER                      TYPE        ZIA_2ORDER(optional)
* | [--->] IV_INDEX                       TYPE        INTEGER(optional)
* | [--->] IV_KEY                         TYPE        AUFNR(optional)
* | [<-()] RO_OBJECT                      TYPE REF TO ZCL_IA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: GET ORDERS
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_AUFTRAG
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    IF iv_index IS NOT INITIAL.
      ro_object ?= go_orders->get_by_position( position = iv_index ).
      RETURN.
    ELSEIF iv_key IS NOT INITIAL.
      ro_object ?= go_orders->get( key = iv_key ).
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_BTG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_LAGE                        TYPE        ZIA_2_LAGE
* | [<---] EV_DIDOK                       TYPE        ZIA_2_DIDOK
* | [<---] EV_ID_BTG                      TYPE        ZIA_2_ID_BTG
* | [<---] EV_INDEX                       TYPE        ZIA_2_INDEX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_btg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: PROVIDES THE RAILWAY ENGINEERING BUILDING
* (ID, LOCATION, DIDOK)
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_BTG
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
*    CHECK  me->go_orders->map IS NOT INITIAL.
    TRY.
        me->get_auftrag( iv_index = 1 )->get_btg(
        IMPORTING
          ev_lage   = ev_lage
          ev_didok  = ev_didok
          ev_id_btg = ev_id_btg
          ev_index  = ev_index
         ).
      ##NO_HANDLER      CATCH cx_sy_ref_is_initial.
      ##NO_HANDLER      CATCH cx_no_check.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2SF_WA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_DATA
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    rs_data = me->gs_arbeitsstelle.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FILTER_FZTYP                TYPE        ZIA_2_ID_FZTYP(optional)
* | [<-()] RO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: DELIVERS THE VEHICLES
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_FAHRZEUGE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

    IF iv_filter_fztyp IS INITIAL.
      ro_fahrzeuge = go_fahrzeuge.
    ELSE.
      ro_fahrzeuge = NEW cl_object_map( ).
      lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        " FILTER ANWENDEN
        CHECK lo_fahrzeug->get_data( )-zid_fztyp = iv_filter_fztyp.
        " FAHTZEUG ZURÜCKGEBEN
        ro_fahrzeuge->put( EXPORTING key = lo_fahrzeug->get_id( )   value = lo_fahrzeug ).
      ENDWHILE.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZIA_2_ID_AS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: GetID
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - zcl_io_5_arbeitsstelle, METHOD - GET_ID
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rv_id = me->gs_arbeitsstelle-zarbstl.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_KURZTEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZGART_TXT                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RV_TEXT                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_kurztext.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: GET TEXT
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*


   " Flag to determine if TS (time segment) exists
   DATA(lv_is_ts) = VALUE abap_bool( ).

   " Call another method to get the SPERRABSCHNITTE table (short text)
   me->get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).  "GET/CREATE THE 'SPERRABSCHINTT' TABLE FOR KTEXT

   " If the table is empty, exit the method
   IF lt_sp_ktext IS INITIAL.
     RETURN.
   ENDIF.

   " Check if there is a TS (time segment) in the map of work areas
   IF line_exists( gt_map_sp_as[ zintervallart = 'TS' ] ).         "CHECK TS EXISTS
     lv_is_ts = abap_true.  " Set the flag to true if TS exists
   ENDIF.

   " Get the number of lines in the lt_sp_ktext table
   DATA(lv_lines) = lines( lt_sp_ktext ).

   " Loop through the lt_sp_ktext table and process each record
   LOOP AT lt_sp_ktext ASSIGNING FIELD-SYMBOL(<ls_sp_ktext>).

     " Get the current line index (tabix) of the loop
     DATA(lv_tabix) = sy-tabix.

     " Build the short text (rv_text) by concatenating different fields and values
     rv_text  = |{ rv_text }| & | | & |{ <ls_sp_ktext>-prefix }| &  |{ <ls_sp_ktext>-index ALPHA = IN }|.

     " If TS exists, append 'TS' to the text
     IF lv_is_ts = abap_true.
       rv_text = |{ rv_text }| & |TS|.
     ENDIF.

     " If iv_zgart_txt is true, get additional text based on zugangsart (access type)
     IF iv_zgart_txt = abap_true.
       DATA(lv_zgart_txt) = COND #( WHEN <ls_sp_ktext>-zugangsart = '1'
                                    THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/RAIL' )  " Get text for rail access type
                                    WHEN <ls_sp_ktext>-zugangsart = '2'
                                    THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/STREET' ) ).  " Get text for street access type
       rv_text =  |{ rv_text }| & | | & |(| & |{ lv_zgart_txt }| & |)|.  " Append the access type text to the short text
     ENDIF.

     " If this is the first line in the table and there are more lines, append a dash to the text
     IF lv_tabix <= 1 AND lv_tabix < lv_lines.
       rv_text = |{ rv_text }| & | | & |-|.  " Add dash between entries
     ENDIF.

   ENDLOOP.

   " Remove leading and trailing spaces from rv_text (condense the text)
   CONDENSE rv_text.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_MAP_SP_AS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REFRESH                     TYPE        ABAP_BOOL(optional)
* | [<-()] RT_DATA                        TYPE        TT_V_MAP_AS
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_map_sp_as.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Returns the mapping of ZIA_D_2_MAP_AS View
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  CLEAR rt_data.
  DATA: lv_sperras_id TYPE string,
        lv_shift      TYPE string,
##NEEDED        lv_order      TYPE eaml_tabkey.

  ##NEEDED  DATA: lt_sperrabschnitt TYPE STANDARD TABLE OF string,
  ##NEEDED        lv_sperrabschnitt TYPE string.

  IF iv_refresh = abap_false.
    rt_data = gt_map_sp_as.
    RETURN.
  ENDIF.

  " Read ALL matching entries for the Arbeitsstelle
  SELECT sperras_id, zugangsart
    FROM zia_2map_as_szg
    WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl
    INTO TABLE @DATA(lt_map_data).

  IF lt_map_data IS INITIAL.
    RETURN. " no entries → nothing to map
  ENDIF.

*  ##WARN_OK  SELECT SINGLE aufnr FROM zia_2order
*      INTO @lv_order
*       WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.
*  "*******************************
*  SELECT * FROM eaml_d_lfe_data INTO TABLE @DATA(lt_aufk_ext_sp) WHERE tabkey EQ @lv_order. "#EC CI_ALL_FIELDS_NEEDED


  "*******************************
  LOOP AT lt_map_data INTO DATA(ls_map_data).

    " Split sperras_id + shift
    lv_shift      = ls_map_data-sperras_id(12).   " First 12 chars
    lv_sperras_id = ls_map_data-sperras_id+16(4). " Next 4 chars


    " Get QMMA + QMFE entries
    SELECT a~qmnum, a~mncod, b~oteil
      FROM qmma AS a
      INNER JOIN qmfe AS b
      ON a~qmnum = b~qmnum AND a~fenum = b~fenum
      WHERE a~qmnum = @lv_shift
*        AND a~fenum = @lv_sperras_id
        AND a~manum = @lv_sperras_id
      INTO TABLE @DATA(lt_data).

    "   LOOP AT lt_aufk_ext_sp ASSIGNING FIELD-SYMBOL(<ls_auftrag_sp_intvart>). "#EC CI_NESTED
***
***      SPLIT <ls_auftrag_sp_intvart>-z_section
***        AT ','
***       INTO TABLE lt_sperrabschnitt.
***
    "     LOOP AT lt_sperrabschnitt INTO lv_sperrabschnitt.
***
***
***        ##NEEDED      READ TABLE lt_data WITH KEY mncod =   lv_sperrabschnitt         ##WARN_OK "#EC CI_STDSEQ
***                                          oteil  = <ls_auftrag_sp_intvart>-z_interval INTO DATA(ls_sp_schicht).
***        IF sy-subrc = 0.
***          APPEND VALUE #(
***              zarbstl        = me->gs_arbeitsstelle-zarbstl
***              sperras_id     = ls_map_data-sperras_id
***              zugangsart     = ls_map_data-zugangsart
***              sperrabschnitt = lv_sperrabschnitt
***              zintervallart  = <ls_auftrag_sp_intvart>-z_interval
***            ) TO rt_data.
***        ENDIF.
***      ENDLOOP.
***    ENDLOOP.
    LOOP AT lt_data INTO DATA(ls_data).                  "#EC CI_NESTED
      APPEND VALUE #(
        zarbstl       = me->gs_arbeitsstelle-zarbstl
        zugangsart    = ls_map_data-zugangsart
        sperrabschnitt = ls_data-mncod
        zintervallart = ls_data-oteil
      ) TO rt_data.
    ENDLOOP.

  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_PNEU_KENNZEICHEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TT_PNEU_KENNZEICHEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_pneu_kennzeichen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: PROVIDES THE TIRE LICENSE PLATE
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_PNEU_KENNZEICHEN
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA(lo_aufttag_i) = CAST cl_object_collection_iterator( me->get_auftraege( )->get_values_iterator( ) ).
    DATA lv_kennzeichen TYPE zia_2_arbstbez_kennzeichen.
    WHILE lo_aufttag_i->has_next( ) = abap_true.
      DATA(lo_auftrag) = CAST zcl_ia_2order( lo_aufttag_i->get_next( ) ).
      CHECK lo_auftrag->get_data( )-zzzugangsart = '2'.

      lv_kennzeichen = zcl_ia_2utilities2=>get_pneu_bez_kennzeichen( iv_stdkz = lo_auftrag->get_data( )-zstdkz
                                                                          iv_didok = lo_auftrag->get_data( )-zdidok
                                                                          iv_lage = lo_auftrag->get_data( )-zlage   ).

      rt_data = VALUE #( BASE rt_data ( zarbstbez = lv_kennzeichen ) ).

      IF me->is_btg( ).
        EXIT.
      ENDIF.
    ENDWHILE.

    DELETE ADJACENT DUPLICATES FROM rt_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_SP_KTEXT_TAB
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_DATA                        TYPE        TT_SP_KTEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_sp_ktext_tab.
***----------------------------------------------------------------------*
*** SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
***----------------------------------------------------------------------*
***
***-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
*** VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*** BESCHREIBUNG / DESCRIPTION:RETURNS THE BLOCKING SECTION TABLE FOR
*** THE SHORT TEXT
***----------------------------------------------------------------------*
*** >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
***PROGRAMMERSTELLUNG / CREATION OF PROGRAM
**
***----------------------------------------------------------------------*
*** >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
***         ...
***----------------------------------------------------------------------*
  CONSTANTS: lc_sort_asc    TYPE string VALUE 'ASCENDING',
             lc_sort_desc   TYPE string VALUE 'DESCENDING',
             lc_zid_eiz_sed TYPE zia_2_id_eiz VALUE 10,
             lc_zid_eiz_fad TYPE zia_2_id_eiz VALUE 20,
             lc_as_prefix_n TYPE zia_2_met_as_name_prefix VALUE 'N',
##NEEDED             lc_as_prefix_s TYPE zia_2_met_as_name_prefix VALUE 'S'.

  DATA: lt_as_sort    TYPE tt_as_km_sort,
        lv_perim      TYPE string,
        lv_zid_eiz    TYPE zia_2_id_eiz,
        lv_zid_eiz_as TYPE zia_2_id_eiz.

  DATA(lt_kenzchn_btg) = VALUE tt_pneu_kennzeichen( ).

  CHECK go_schicht IS BOUND.
  DATA(lo_auftrag) = me->get_auftrag( iv_index = 1 ).
  lv_perim = COND #( WHEN lo_auftrag IS BOUND THEN lo_auftrag->get_data( )-zzperi ELSE go_schicht->get_data( )-zzperi ).

  DATA(ls_zugangsarten) = me->get_zugangsarten( ).
  DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( go_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).
    CHECK NOT lo_arbstelle->is_btg( ).
    lv_zid_eiz_as = me->determine_zid_eiz_value(
      iv_default = lo_arbstelle->get_data( )-zid_eiz
      iv_prefix = lo_arbstelle->get_data( )-prefix_met_as
      iv_use_conditon = lo_arbstelle->has_met( ) ).

    lv_zid_eiz = gs_arbeitsstelle-zid_eiz.
    IF gs_arbeitsstelle-prefix_met_as IS NOT INITIAL.
      lv_zid_eiz = COND #( WHEN me->get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_zid_eiz_sed ELSE lc_zid_eiz_fad ).
    ENDIF.

    DATA(ls_data1) = lo_arbstelle->get_data( ).
    IF lv_zid_eiz = lv_zid_eiz_as.
      lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = ls_data1-zarbstl km_max = COND #( WHEN lv_zid_eiz = lc_zid_eiz_sed THEN ls_data1-zkmin ELSE ls_data1-zkmax ) ) ).
    ENDIF.
  ENDWHILE.

  " Process and adjust data
  DATA(lt_map_sp_as) = me->get_map_sp_as( abap_true ).
**  DATA(lv_sort_order) = COND #( WHEN lv_perim = zif_ia_2_constant=>mc_perim-cbt THEN lc_sort_desc
**                          WHEN has_met( ) THEN COND #( WHEN get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_sort_desc ELSE lc_sort_asc )
**                          ELSE lc_sort_asc ).
  DATA(lv_sort_order) = COND #( WHEN lv_perim =  zif_ia_2_constant=>mc_perim-cbt THEN lc_sort_desc
                           WHEN has_met( )
                           THEN COND #( WHEN get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_sort_desc ELSE lc_sort_asc )
                           ELSE COND #( WHEN get_data( )-zid_eiz = lc_zid_eiz_sed       THEN lc_sort_desc ELSE lc_sort_asc ) ).
*
*  SORT lt_as_sort BY km_max % CASE lv_sort_order WHEN lc_sort_desc THEN DESCENDING ELSE ASCENDING ENDCASE.
  IF lv_sort_order = lc_sort_desc.
    SORT lt_as_sort BY km_max DESCENDING.
  ELSE.
    SORT lt_as_sort BY km_max.
  ENDIF.

  IF ( line_exists( lt_map_sp_as[ zugangsart = '1' ] ) OR ls_zugangsarten-schiene = abap_true ) AND me->is_schiene( ).
    et_data = VALUE #( BASE et_data (
      position = lines( et_data ) + 1
      index = line_index( lt_as_sort[ zarbstl = me->gs_arbeitsstelle-zarbstl ] )
      zugangsart = '1'
      prefix = COND #( WHEN lv_perim = 'GBT' AND me->gs_arbeitsstelle-zid_eiz = 10 THEN 'N' WHEN lv_perim = 'GBT' AND me->gs_arbeitsstelle-zid_eiz = 20 THEN 'S' WHEN lv_perim = 'CBT' THEN 'C' ) ) ).
  ENDIF.

  IF ( line_exists( lt_map_sp_as[ zugangsart = '2' ] ) OR ls_zugangsarten-pneu = abap_true ).
    IF NOT me->is_btg( ).
      LOOP AT me->get_pneu_kennzeichen( ) ASSIGNING FIELD-SYMBOL(<ls_data>).
        CHECK NOT line_exists( et_data[ prefix = <ls_data>-zarbstbez index = line_index( lt_as_sort[ zarbstl = me->gs_arbeitsstelle-zarbstl ] ) zugangsart = '2' ] ).
        et_data = VALUE #( BASE et_data (
                           position   = lines( et_data ) + 1
                           prefix     = <ls_data>-zarbstbez
                           index      = line_index( lt_as_sort[ zarbstl = me->gs_arbeitsstelle-zarbstl ] )
                           zugangsart = '2' ) ).
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF me->is_btg( ).   "Compare with other AS-BTG in Schicht (for the same Kenneichen ) to get INDEX
    lo_arbstelle_i = CAST cl_object_collection_iterator( go_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).
    DATA(lt_kennzeichen_cur) = me->get_pneu_kennzeichen( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).
      CHECK lo_arbstelle->is_btg( ).
      DATA(lt_kennzeichen_tmp) = lo_arbstelle->get_pneu_kennzeichen( ).
      TRY.
          DATA(lv_kennzeichen_btg) = lt_kennzeichen_cur[ 1 ]-zarbstbez.
          CHECK lv_kennzeichen_btg = lt_kennzeichen_tmp[ 1 ]-zarbstbez.
          lo_arbstelle->get_btg( IMPORTING ev_index = DATA(lv_index) ).
          lt_kenzchn_btg = VALUE #( BASE lt_kenzchn_btg ( zarbstbez = lt_kennzeichen_tmp[ 1 ]-zarbstbez index = lv_index ) ).
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.
    ENDWHILE.

    SORT lt_kenzchn_btg ASCENDING BY index.
    DELETE ADJACENT DUPLICATES FROM lt_kenzchn_btg COMPARING ALL FIELDS.
    me->get_btg( IMPORTING ev_index = lv_index ).
    IF lv_index IS NOT INITIAL.
      et_data = VALUE #( BASE et_data ( position   = lines( et_data ) + 1
                                        prefix     = lv_kennzeichen_btg
                                        index      = line_index( lt_kenzchn_btg[ index = lv_index ] )
                                        zugangsart = '2' ) ).
    ENDIF.
  ENDIF.


  SORT et_data BY position.
ENDMETHOD.                                               "#EC CI_VALPAR


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_ZUGANGSARTEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_ZUGANGSARTEN                TYPE        ZIA_2_ACCESS_TYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_zugangsarten.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: TYPES OF ACCESS TO THE WORKPLACE
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_ZUGANGSARTEN
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    rs_zugangsarten-schiene = abap_false.
    rs_zugangsarten-pneu = abap_false.

    DATA: lo_auftgrag TYPE REF TO zcl_ia_2order.

    DATA(li_auftraege_iterator) = me->go_orders->get_values_iterator( ).

    WHILE li_auftraege_iterator->has_next( ).
      lo_auftgrag ?= li_auftraege_iterator->get_next( ).

      CASE lo_auftgrag->get_data( )-zzzugangsart.
          WHEN '1':.  "1  SCHIENE
          rs_zugangsarten-schiene = abap_true.
          WHEN '2':.  "2  STRASSE
          rs_zugangsarten-pneu = abap_true.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->HAS_MET
* +-------------------------------------------------------------------------------------------------+
* | [<---] ES_MET                         TYPE        ZIA_2MET
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Checks if the AS contains a MET
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - HAS_MET
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    IF me->gs_arbeitsstelle-zmet IS NOT INITIAL.
      rv_boolean = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->HAS_TS_REFERENCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_YES                         TYPE        XSDBOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_ts_reference.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CHECKS WHETHER THE JOB HAS A TS REFERENCE
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - HAS_TS_REFERENCE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lx_err TYPE REF TO cx_root,
    ##NEEDED          lo_arb TYPE REF TO zcl_ia_2wrkplace.
*zia_2sf_worka is replaced by zia_2sf_wa, thats why deleting this below code.
*deleted on 03.12.2025 by E564128
    SELECT COUNT(*)
      FROM zia_2sf_wa
      WHERE zarbstl = gs_arbeitsstelle-zarbstl.

    IF sy-subrc = 0.
      rv_yes = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2WRKPLACE=>INIT_MIN_KM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_min_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Kilometers
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_MD_20013_A1, METHOD - INIT_MIN_KM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    add_min_km( iv_perimeter = 'GBT' iv_sperrabschnitt = 'E' ).
    add_min_km( iv_perimeter = 'GBT' iv_sperrabschnitt = 'W' ).
    add_min_km( iv_perimeter = 'CBT' iv_sperrabschnitt = 'E' ).
    add_min_km( iv_perimeter = 'CBT' iv_sperrabschnitt = 'W' ).

*--> BEGIN INSERT >001<
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-e1 ).
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-e2 ).
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-e3 ).
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-w1 ).
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-w2 ).
    add_min_km( iv_perimeter = mc_perimeters-gbt iv_sperrabschnitt = mc_sperrabs-w3 ).

    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-e1 ).
    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-e2 ).
    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-e3 ).
    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-w1 ).
    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-w2 ).
    add_min_km( iv_perimeter = mc_perimeters-cbt iv_sperrabschnitt = mc_sperrabs-w3 ).
*--> END INSERT >001<

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_ABHAENGIG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_abhaengig.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Set as abap falase
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - IS_ABHAENGIG
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rv_value = abap_false.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_BTG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_ID_BTG                      TYPE        ZIA_2_ID_BTG
* | [<-()] RV_BOOLEAN                     TYPE        WDY_BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_btg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: INDICATOR WHETHER A JOB IS IN A BTG
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - IS_BTG
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ev_id_btg = me->gs_arbeitsstelle-zid_btg.
    rv_boolean = COND #( WHEN me->gs_arbeitsstelle-zid_btg IS INITIAL THEN abap_false ELSE abap_true ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_PNEU
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD is_pneu.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CHECKS WHETHER IT IS A TIRE WORK SITE
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - IS_PNEU
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  rv_boolean = COND #( WHEN lines( gt_map_as_szg ) > 0
                        " NO ZUGANGSART SCHINE => STRASSE ONLY => IS_PNEU RETURNS TRUE
                        THEN boolc( NOT line_exists( gt_map_as_szg[ zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ] ) )
                        " NO ZUGANGSART AT ALL
                        ELSE abap_false
                      ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_SCHIENE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD is_schiene.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Checks whether it is a railway job
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - zcl_io_5_arbeitsstelle, METHOD - IS_SCHIENE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  rv_boolean = boolc( line_exists( gt_map_as_szg[ zugangsart = zcl_ia_2utilities2=>mc_zugangsart_schiene ] ) ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload.
**----------------------------------------------------------------------*
** SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
**----------------------------------------------------------------------*
**
**-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
** VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
** BESCHREIBUNG / DESCRIPTION: RELOAD
**----------------------------------------------------------------------*
** >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
** PROGRAMMERSTELLUNG / CREATION OF PROGRAM
** CODE MIGRATED FROM - M02(201)
** M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - RELOAD
**----------------------------------------------------------------------*
** >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
**         ...
**----------------------------------------------------------------------*
    ##NEEDED    DATA: lo_arbstelle TYPE REF TO zcl_ia_2wrkplace,
              lo_fahrzeug  TYPE REF TO zcl_ia_2vehicle,
              lo_auftrag   TYPE REF TO zcl_ia_2order,
              lo_sp_zeit   TYPE REF TO zcl_ia_2restr_asso_tims,
              lo_sp_km     TYPE REF TO zcl_ia_2_sp_kilometer,
##NEEDED              lx_fehler    TYPE REF TO zcx_ia_2failure.


    me->go_fahrzeuge->clear( ).
    me->go_orders->clear( ).
    me->go_sp_zeiten->clear( ).
    me->go_sp_kilometer->clear( ).

    SELECT SINGLE * FROM zia_2sf_wa INTO @DATA(ls_arbstelle) WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.   "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zia_2sf_wa_veh INTO TABLE @DATA(lt_fahrzeuge) WHERE zid_arbstl = @me->gs_arbeitsstelle-zarbstl. "#EC CI_ALL_FIELDS_NEEDED
    SELECT * FROM zia_2order INTO TABLE @DATA(lt_auftraege) WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl. "#EC CI_ALL_FIELDS_NEEDED
    SELECT * FROM zia_2sf_bs_time INTO TABLE @DATA(lt_sp_zeiten) WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.     "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zia_2bs_km INTO TABLE @DATA(lt_sp_km) WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.             "CI_ALL_FIELDS_NEEDED
*    SELECT * FROM zia_2map_as_szg INTO TABLE @gt_map_as_szg WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.         "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zia_2map_as_szg INTO TABLE @gt_map_as_szg WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.         "CI_ALL_FIELDS_NEEDED

    me->gt_map_sp_as = me->get_map_sp_as( abap_true ).
    me->gs_arbeitsstelle = ls_arbstelle.

    ##NEEDED    DATA: lt_sa_auftraege  TYPE zia_2_sgnl_sec_t.

    " AUFTRÄGE EINLESEN
    LOOP AT lt_auftraege ASSIGNING FIELD-SYMBOL(<ls_auftrag>).
      lo_auftrag = NEW zcl_ia_2order( iv_aufnr = <ls_auftrag>-aufnr ).
      TRY.
          me->reload_auftrag_o( io_order = lo_auftrag ).
        ##NO_HANDLER        CATCH zcx_ia_2failure INTO lx_fehler.
      ENDTRY.
    ENDLOOP.

    " FAHRZEUGE EINLESEN
    LOOP AT lt_fahrzeuge ASSIGNING FIELD-SYMBOL(<ls_fzg>).
*      lo_fahrzeug = NEW zcl_ia_2vehicle( iv_id = <ls_fzg>-zid_fzg io_arbeitsstelle = me ).
      lo_fahrzeug = NEW zcl_ia_2vehicle(  iv_id = <ls_fzg>-zid_fzg io_arbeitsstelle = me  ).
      me->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
    ENDLOOP.

    "SPERRABSCHNITTE-ZEITEN
    LOOP AT lt_sp_zeiten ASSIGNING FIELD-SYMBOL(<ls_sp_zeiten>).
      lo_sp_zeit = zcl_ia_2restr_asso_tims=>get_instance( iv_id = <ls_sp_zeiten>-sp_zeiten_id ).
      add_sp_zeit( io_sp_zeit = lo_sp_zeit ).
    ENDLOOP.

    "SPERRABSCHNITTE-KILOMETER
    LOOP AT lt_sp_km ASSIGNING FIELD-SYMBOL(<ls_sp_km>).
      lo_sp_km = NEW zcl_ia_2_sp_kilometer( iv_id = <ls_sp_km>-sp_km_id ).
      me->add_sp_km( io_sp_km = lo_sp_km ).
      lo_sp_km->set_schicht( me->go_schicht ).
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2WRKPLACE=>SELECT_SA_KM_MIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* | [<-()] RT_VALUE                       TYPE        TT_MIN_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_sa_km_min.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: PARAMETER METHOD
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - SELECT_SA_KM_MIN
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    SELECT zzperi AS perimeter,
        zest   AS sperrabschnitt,
        km_von AS min_km
   INTO CORRESPONDING FIELDS OF TABLE @rt_value
   FROM zia_2sc
   WHERE zzperi = @iv_perimeter
     AND zest   = @iv_sperrabschnitt.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZIA_2SF_WA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: SET DATA
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - SET_DATA
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    " DECLARATION
    DATA(lv_id_as) = me->gs_arbeitsstelle-zarbstl.
    " PASING VALUES
    me->gs_arbeitsstelle = is_data.
    me->gs_arbeitsstelle-zarbstl = lv_id_as.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->RELOAD_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IA_2ORDER
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload_auftrag_o.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - RELOAD_AUFTRAG_O
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    zcl_ia_2message_mnger=>get_instance( )->add_message(  EXPORTING iv_msgid = 'ZIA_2_REAL'
                                                                      iv_msgno = 296
                                                                      iv_msgty = 'I'
                                                                      iv_msgv3 =
                                                                      io_order->get_data( )-aufnr ).

    me->go_orders->put( EXPORTING key = io_order->get_data( )-aufnr   value = io_order ).
    io_order->set_schicht( iv_schicht = me->gs_arbeitsstelle-zschicht ).
    io_order->set_arbeitsstelle_id( iv_arbstl = me->gs_arbeitsstelle-zarbstl ).
    io_order->set_vorschau_flag( iv_vorschau = abap_false ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: RETURNS THE CORRESPONDING LAYER
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_SCHICHT
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ro_schicht = me->go_schicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeug.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Adds a vehicle to the job site
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - ADD_FAHRZEUG
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    me->go_fahrzeuge->put( EXPORTING key = io_fahrzeug->get_data( )-zid_fzg   value = io_fahrzeug ).
    io_fahrzeug->set_arbeitsstelle( io_arbstelle = me ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_SP_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SP_KM                       TYPE REF TO ZCL_IA_2_SP_KILOMETER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Adds closure section kilometer OBJ to the
* work site
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - ADD_SP_KM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    me->go_sp_kilometer->put( EXPORTING key = io_sp_km->get_data( )-sperras_id   value = io_sp_km ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_SP_ZEIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SP_ZEIT                     TYPE REF TO ZCL_IA_2RESTR_ASSO_TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp_zeit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Adds blocking section time OBJ to the workstation
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - ADD_SP_ZEIT
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    CHECK io_sp_zeit IS NOT INITIAL.
    me->go_sp_zeiten->put( EXPORTING key = io_sp_zeit->get_data( )-sperras_id   value = io_sp_zeit ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->DETERMINE_ZID_EIZ_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DEFAULT                     TYPE        ZIA_2_ID_EIZ
* | [--->] IV_PREFIX                      TYPE        ZIA_2_MET_AS_NAME_PREFIX(optional)
* | [--->] IV_USE_CONDITON                TYPE        ABAP_BOOL (default =' ')
* | [<-()] RV_ZID_EIZ                     TYPE        ZIA_2_ID_EIZ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD determine_zid_eiz_value.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: determine the EIZ value
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* CODE MIGRATED FROM - M02(201)
* M02 - CLASS - ZCL_IO_5_ARBEITSSTELLE, METHOD - GET_SP_KTEXT_TAB
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    CONSTANTS: lc_zid_eiz_sed TYPE zia_2_id_eiz               VALUE 10,
               lc_zid_eiz_fad TYPE zia_2_id_eiz               VALUE 20,
               lc_as_prefix_n TYPE zia_2_met_as_name_prefix   VALUE 'N'.

    IF iv_use_conditon = abap_true AND iv_prefix IS NOT INITIAL.
      rv_zid_eiz = COND #(
        WHEN iv_prefix = lc_as_prefix_n THEN lc_zid_eiz_sed
        ELSE lc_zid_eiz_fad
      ).
    ELSE.
      rv_zid_eiz = iv_default.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [--->] IV_AUFNR                       TYPE        AUFNR(optional)
* | [--->] IV_TESTRUN                     TYPE        BOOLEAN(optional)
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN(optional)
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN(optional)
* | [--->] IV_SKIP_VALIDATIONS            TYPE        BOOLEAN(optional)
* | [--->] IV_FIRST_ORDER                 TYPE        BOOLEAN(optional)
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN(optional)
* | [--->] IV_PLANNED_ORD_CAPACITY        TYPE        BOOLEAN(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD add_auftrag_o.                                    "#EC CI_CYCLO
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : ADD_AUFTRAG_O
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       16.10.2026        TCS / Venkateswarlu Batta
*         Added Parameter
*----------------------------------------------------------------------*
   DATA: lo_auftrag        TYPE REF TO zcl_ia_2order,
         lt_einzelkapas    TYPE zia_2einzelkapas_t,
         ls_einzelkapa     TYPE zia_2order_cap,
         lo_fahrzeuge      TYPE REF TO cl_object_map,
         lo_fahrzeuge_i    TYPE REF TO cl_object_collection_iterator,
         lo_fahrzeug       TYPE REF TO zcl_ia_2vehicle,
         lo_sitzplatz      TYPE REF TO zcl_ia_2seat,
         lv_is_valid       TYPE boolean,
         lv_has_errors     TYPE boolean,
         lv_critical_error TYPE boolean,
         lx_fehler         TYPE REF TO zcx_ia_2failure.

******   IF is_auftrag IS NOT INITIAL.
******     DATA(ls_auftrag) = is_auftrag.
******     lo_auftrag = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).
******   ELSEIF io_order IS NOT INITIAL.
******     ls_auftrag = io_order->get_data( ).
******     lo_auftrag ?= io_order.
******   ELSEIF iv_aufnr IS NOT INITIAL.
******     SELECT SINGLE * FROM zia_2order INTO @ls_auftrag WHERE aufnr = @iv_aufnr. "#EC CI_ALL_FIELDS_NEEDED
******     lo_auftrag = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).
******   ELSE.
******     EXIT.
******   ENDIF.

   initialize_auftrag( EXPORTING iv_aufnr = iv_aufnr is_auftrag = is_auftrag io_order = io_order
                       IMPORTING eo_order = lo_auftrag es_order = DATA(ls_auftrag) ).

   " Auftrag can be added only if it is not already assigned to this Arbeitsstelle
   CHECK NOT has_auftrag( lo_auftrag->get_data( )-aufnr ).
*   CHECK has_auftrag( lo_auftrag->get_data( )-aufnr ).

   zcl_ia_2message_mnger=>get_instance( )->add_message(  EXPORTING iv_msgid = 'ZIA_2_REAL'  iv_msgno = 296  iv_msgty = 'I' iv_msgv3 = ls_auftrag-aufnr ).
   "=============== Prüfe Auftrag &1 ===============

   "Indikator setzen, ob es sich um eine Planung OS handelt oder Tunnel.
   "Falls dieses Flag gesetzt ist, werden verschiedenste Prüfungen, die für die OS nicht benötigt werden, ignoriert.
   DATA(lv_planung_os) = COND #( WHEN me->is_in_tunnel( ) EQ abap_false THEN abap_true ELSE abap_false ).
   ##NEEDED   DATA(lv_planung_btg) = COND #( WHEN lo_auftrag->get_data( )-zstdkz EQ 'G' THEN abap_true ELSE abap_false ).

   "*******************
   "* Begin
   "***************
   IF iv_skip_validations = abap_false.

     validate_order(
         EXPORTING
           io_auftrag       = lo_auftrag
           is_auftrag       = ls_auftrag
           iv_auto_planning = iv_auto_planning
           iv_ignore_errors = iv_ignore_errors
           iv_vorschau      = iv_vorschau
         IMPORTING
           et_einzelkapas   = lt_einzelkapas
           ev_is_valid      = lv_is_valid
           ev_has_errors    = lv_has_errors
           ev_critical      = lv_critical_error ).

     IF lv_critical_error = abap_true.
       rv_success = abap_false.
       RETURN.
     ENDIF.
   ENDIF.

********   " Hole Fahrzeuge zum Auftrag
   IF ls_auftrag-zzzugangsart = 1."*    IF me->is_schiene( ) EQ abap_true.
     IF zcl_ia_2rules=>get_fahrzeuge( EXPORTING io_arbeitsstelle = me
                                                  iv_vorschau = iv_vorschau
                                                  io_auftrag = lo_auftrag
                                                  iv_ignore_errors = iv_ignore_errors
                                        IMPORTING eo_fahrzeuge = lo_fahrzeuge ) = abap_false
                                                           AND iv_ignore_errors = abap_false
                                                           AND lv_planung_os    = abap_false.
       IF iv_auto_planning = abap_true.
         refresh_sa_sp( ).
         RETURN.
       ELSE.
         lv_has_errors = abap_true.
       ENDIF.
     ENDIF.
   ENDIF.
   "*******************
   "* Begin neues zeugs
   "***************
   ensure_matching_vehicle_exists( EXPORTING is_auftrag = ls_auftrag
                                   IMPORTING eo_fahrzeug = lo_fahrzeug
                                             eo_fahrzeuge_i = lo_fahrzeuge_i
                                             ev_fzg_vorhanden = DATA(lv_fzg_vorhanden) ).

   ##NEEDED   add_basis_fahrzeuge( EXPORTING iv_fzg_vorhanden = lv_fzg_vorhanden
                                     io_arbeitsstelle = me
                                     io_auftrag       = lo_auftrag
                                     iv_ignore_errors = abap_true
                                     iv_vorschau      = iv_vorschau
                           IMPORTING eo_fahrzeuge     = DATA(lo_basis_fzg) ).
   "***************
   "* Ende neues zeugs
   "*******************
   " Prüfe die Einzelkapazitäten "Nur im Tunnel
   lv_is_valid =  check_einzelkapas_validity( EXPORTING is_auftrag        = ls_auftrag
                                                        io_arbeitsstelle  = me
                                           iv_auto_planning  = iv_auto_planning
                                           iv_ignore_errors  = iv_ignore_errors
                                           iv_planned_ord_capacity = iv_planned_ord_capacity       ">001<
                                 IMPORTING ev_critical_error = lv_critical_error
                                           et_einzelkapas    = lt_einzelkapas
                                           ev_has_errors     = lv_has_errors
                                           ev_success        = rv_success ).
   "***************
   "* Ende
   "*******************
   " Einzelkapas sperren
   lock_single_capacities( EXPORTING it_einzelkapas = lt_einzelkapas
                           IMPORTING eo_fahrzeug    = lo_fahrzeug
                                     eo_fahrzeuge_i = lo_fahrzeuge_i
                                     eo_sitzplatz   = lo_sitzplatz ).

   IF  iv_testrun = abap_false AND ( lv_has_errors = abap_false OR iv_ignore_errors = abap_true ). "iv_testrun = abap_false AND  lv_has_errors = abap_false
     "Fahrzeuge hinzzufügen
     lx_fehler = add_fahrzeuge_and_order( EXPORTING io_auftrag = lo_auftrag
                                           io_fahrzeuge = lo_fahrzeuge
                                           it_einzelkapas = lt_einzelkapas
                                           iv_ignore_errors = iv_ignore_errors
                                           iv_vorschau = iv_vorschau
                                 IMPORTING eo_fahrzeug = lo_fahrzeug
                                           eo_fahrzeuge_i = lo_fahrzeuge_i
                                           eo_sitzplatz  = lo_sitzplatz ).
   ENDIF.

   " Einzelkapas entsperren
   LOOP AT lt_einzelkapas INTO ls_einzelkapa.
     lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
     WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
       lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
       lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
       CHECK lo_sitzplatz IS NOT INITIAL.
       TRY.
           lo_sitzplatz->unlock( ).
         CATCH zcx_ia_2failure INTO lx_fehler.
           RAISE EXCEPTION lx_fehler.
       ENDTRY.
     ENDWHILE.
   ENDLOOP.

   " Rückgabe
   IF lv_is_valid = abap_false AND iv_ignore_errors = abap_false.
     rv_success = abap_false.
   ELSE.
     rv_success = abap_true.
   ENDIF.

   lo_auftrag->set_arbeitsstelle_object( io_arbst = me ).

   IF iv_skip_validations = abap_false.
     me->refresh_fahrleitungsschaltung( ).
   ENDIF.



   IF rv_success = abap_true.
     "*******************
     "* Sperrabschnitte
     "***************

     DATA(lt_sa_auftrag) =  me->get_sa_ext_for_new_auftrag( io_auftrag = lo_auftrag ).

     "Sperrabschnitt Kilomter speichern
     DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.
     DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
     WHILE li_sp_km_i->has_next( ) = abap_true.
       lo_sp_km ?= li_sp_km_i->get_next( ).

       ##NEEDED       DATA(lv_sperras_id) = lo_sp_km->get_data( )-sperras_id.
       DATA(lv_sperrabschnitt) = lo_sp_km->get_sp( ).

       LOOP AT lt_sa_auftrag ASSIGNING FIELD-SYMBOL(<ls_sa_auftrag>).
         CHECK <ls_sa_auftrag>-zest = lv_sperrabschnitt.
         lo_sp_km->add_sa( is_sa = <ls_sa_auftrag> ).
       ENDLOOP.

     ENDWHILE.
   ELSE.
     refresh_sa_sp( ).
   ENDIF.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : ADD_FAHRZEUGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

    lo_fahrzeuge_i ?= io_objects->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_fahrzeug->set_vorschau_flag( iv_vorschau = iv_vorschau ).

      me->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [--->] IV_ZUGANGSART                  TYPE        ZIA_2_ZUGANGSART
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : ADD_SP
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA: lv_sperras_id    TYPE string,
          lv_shift         TYPE string,
##NEEDED          lv_iv_sperras_id TYPE string,
##NEEDED          lv_unique_id     TYPE string.

    " SPLIT IV_SPERRAS_ID INTO SPERRAS_ID AND SHIFT
    lv_shift  = iv_sperras_id(12).  " FIRST 10 CHARACTERS FOR SPERRAS_ID
    lv_sperras_id      = iv_sperras_id+16(4).  " NEXT 4 CHARACTERS FOR SHIFT

    SELECT SINGLE * FROM viqmma INTO @DATA(ls_sp_schicht) WHERE qmnum = @lv_shift AND manum = @lv_sperras_id  AND kzloesch EQ ''.
    DATA(ls_schicht) = go_schicht->get_data( ). ">001< (+)
    "*******************
    "* ZEITEN
    "***************
    DATA(ls_sp_zeiten) = VALUE zia_2sf_bs_time( ).

    MOVE-CORRESPONDING ls_sp_schicht TO ls_sp_zeiten.
    ls_sp_zeiten-zarbstl = gs_arbeitsstelle-zarbstl.
    ls_sp_zeiten-sperras_id = ls_sp_schicht-qmnum && ls_sp_schicht-fenum && ls_sp_schicht-manum.
    ls_sp_zeiten-start_datum = ls_sp_schicht-pster.
    ls_sp_zeiten-start_zeit = ls_sp_schicht-pstur.

    ">001< (+) BEGIN
    ##NEEDED    DATA(lo_abap_tstmp) = NEW cl_abap_tstmp( ).
    ##NEEDED    DATA lv_timestamp TYPE timestamp.
    DATA lv_abzug TYPE zia_2_abzug.
    ##NEEDED    DATA lv_abzug_i TYPE i.

    " Declare timestamp variables to store the final result
    DATA lv_start_tstamp  TYPE timestamp.
    DATA lv_end_tstamp TYPE timestamp.

    " Calculate the start and end times by converting date/time into timestamp without intermediate TZNTSTMPL
    CONVERT DATE ls_schicht-start_datum TIME ls_schicht-start_zeit INTO TIME STAMP lv_start_tstamp TIME ZONE sy-zonlo.
    CONVERT DATE ls_schicht-end_datum TIME ls_schicht-end_zeit INTO TIME STAMP lv_end_tstamp TIME ZONE sy-zonlo.

    " Perform the time adjustment (e.g., subtracting seconds from the start time, adding to the end time)
*    DATA lv_abzug TYPE i.
    lv_abzug = go_schicht->get_parameter( )->get_data( )-abzug / 2 * 60.

    " Adjust start timestamp (subtract seconds) and end timestamp (add seconds)
    lv_start_tstamp = lv_start_tstamp - lv_abzug.
    lv_end_tstamp = lv_end_tstamp + lv_abzug.

    " Convert the final result back to DATE and TIME to populate ls_sp_zeit
    CONVERT TIME STAMP lv_start_tstamp TIME ZONE sy-zonlo INTO DATE ls_sp_zeiten-start_datum TIME ls_sp_zeiten-start_zeit.
    CONVERT TIME STAMP lv_end_tstamp TIME ZONE sy-zonlo INTO DATE ls_sp_zeiten-end_datum TIME ls_sp_zeiten-end_zeit.

    DATA(lo_sp_zeit) = zcl_ia_2restr_asso_tims=>get_instance( ).
    lo_sp_zeit->set_data( is_data = ls_sp_zeiten ).

    add_sp_zeit( io_sp_zeit = lo_sp_zeit ).

    "*******************
    "* KILOMTER
    "***************
    DATA(ls_sp_kilomter) = VALUE zia_2bs_km( ).

    MOVE-CORRESPONDING ls_sp_schicht TO ls_sp_kilomter.
    ls_sp_kilomter-sperras_id = ls_sp_schicht-qmnum && ls_sp_schicht-fenum && ls_sp_schicht-manum.

    ##UNHANDLED_FUNC_EXCEPTION_OK
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '1'
        object      = 'ZIA_2GBT'
      IMPORTING
        number      = ls_sp_kilomter-sp_km_id.

    ls_sp_kilomter-zarbstl = me->gs_arbeitsstelle-zarbstl.
    DATA(lo_sp_km) = NEW zcl_ia_2_sp_kilometer( ).
    lo_sp_km->set_data( is_data = ls_sp_kilomter ).
    lo_sp_km->set_schicht( me->go_schicht ).

    me->add_sp_km( io_sp_km = lo_sp_km ).

    "*******************
    "* MAPPING AS SP SPEICHERN
    "***************

    APPEND INITIAL LINE TO me->gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
    <ls_map_as_szg>-zarbstl = me->gs_arbeitsstelle-zarbstl.
    <ls_map_as_szg>-sperras_id = ls_sp_schicht-qmnum && ls_sp_schicht-fenum && ls_sp_schicht-manum.
    <ls_map_as_szg>-zugangsart = iv_zugangsart.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ARE_VEHICLES_REFERENCED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD are_vehicles_referenced.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : ARE_VEHICLES_REFERENCED
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_schicht_id) = me->go_schicht->get_id( ).

    ##NEEDED    SELECT ref_fzg
           INTO @DATA(lv_v_ref_fzg)
           FROM zia_2sf_wa_veh
           UP TO 1 ROWS
           WHERE ref_schicht = @lv_schicht_id
             AND ref_arbstl  = @me->gs_arbeitsstelle-zarbstl
             AND ref_fzg     NE @space.
    ENDSELECT.
    IF sy-subrc = 0.
      rv_value = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CONTAINS_MANUAL_SIGNALS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RESULT                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD contains_manual_signals.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : CONTAINS_MANUAL_SIGNALS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.

    DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE li_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= li_sp_km_i->get_next( ).
      DATA(lt_user_signals) = lo_sp_km->get_user_signals( ).
      IF lt_user_signals[] IS NOT INITIAL.
        rv_result = abap_true.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD exists.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: ADD MIN KM
*----------------------------------------------------------------------*
* >000<   7.50       13.08.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Check if a work center (Arbeitsstelle) exists in custom table ZIA_2SF_WA
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
   " Check if the work center (Arbeitsstelle) ID is provided
   CHECK gs_arbeitsstelle-zarbstl IS NOT INITIAL.

   " Attempt to select the work center ID from the custom table ZIA_2SF_WA
   SELECT SINGLE zarbstl
     INTO @DATA(lv_id)
     FROM zia_2sf_wa
     WHERE zarbstl = @gs_arbeitsstelle-zarbstl.  " Match based on the work center ID from the structure

   " Return true if a matching entry is found, otherwise false
   rv_value = boolc( lv_id = gs_arbeitsstelle-zarbstl ).  " Convert logical expression to boolean value (X or space)

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AKO
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_SITZPLATZ                   TYPE        ZIA_2SF_VEH_SEAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ako.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AKO
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeuge     TYPE REF TO cl_object_map,
##NEEDED          lo_fahrzeug      TYPE REF TO zcl_ia_2vehicle,
          lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator,
          lo_sitzplaetze   TYPE REF TO cl_object_map,
##NEEDED          lo_sitzplatz     TYPE REF TO zcl_ia_2seat,
##NEEDED          ls_sitzplatz     TYPE zia_2sf_veh_seat.


    lo_fahrzeuge = get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_sitzplaetze_i ?= lo_sitzplaetze->get_values_iterator( ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).

*       COMMENTING THE BELOW CODE AS TABLE ZIA_2VEH_SEAT_1 HAS BEEN REPLCED BY ZIA_2SF_VEH_SEAT
*       BY E564128 ON 05.12.2025

        "FOUND AN INTERNSHIP
*        IF LS_SITZPLATZ-IS_AKO EQ ABAP_TRUE.
*
*          RS_SITZPLATZ = LS_SITZPLATZ.
*          RETURN.
*        ENDIF.
      ENDWHILE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIA_2FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_al.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AL
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( lo_sitzplaetze_i->get_next( ) ).

        "Sitzplatz gefunden.
        DATA(ls_sitzplatz) = lo_sitzplatz->get_data( ).

        "SC der Arbeitstelle gefunden
        IF ls_sitzplatz-is_al EQ abap_true.
          DATA(lv_personalmodul_as) = lo_sitzplatz->get_fahrzeug( )->get_arbeitsstelle( )->get_kurztext( ).
          DATA(lv_personalmodul_reihung) = lo_sitzplatz->get_fahrzeug( )->get_reihung( ).
          CONCATENATE lv_personalmodul_as '.' lv_personalmodul_reihung INTO ls_sitzplatz-personalmodul.
          APPEND ls_sitzplatz TO rt_sitzplaetze.
        ENDIF.

      ENDWHILE.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_ARBEITSZEIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2_WORKPLACE_ZEIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_arbeitszeit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_ARBEITSZEIT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

  DATA lo_sp_zeit       TYPE REF TO zcl_ia_2restr_asso_tims.
  DATA(lv_time_sec_new)  = VALUE   i( ).
  DATA(lv_time_sec_curr) = VALUE   i( ).


  DATA(lt_sp_zeiten) = me->get_sp_zeiten_tab( ).
  IF lt_sp_zeiten IS INITIAL.
    RETURN.
  ENDIF.
*--> Begin Change >001<
  ##WARN_OK  IF line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'E' ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'W' ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = 'RI' sperrabschnitt(1) = 'W' ] ) OR    "Prio 1 - Find Intervallart =  RI/RJ (Tunnel)
      line_exists( lt_sp_zeiten[ zintervallart = 'RI' sperrabschnitt(1) = 'E' ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = 'JI' sperrabschnitt(1) = 'W' ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = 'JI' sperrabschnitt(1) = 'E' ] ) OR
*--> Begin Change >001<
*--> Begin Insert >001<
      line_exists( lt_sp_zeiten[ zintervallart = mc_intervallart_li sperrabschnitt(1) = mc_sperrabs-w ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = mc_intervallart_li sperrabschnitt(1) = mc_sperrabs-e ] ).
*--> End Insert >001<.

    READ TABLE lt_sp_zeiten ASSIGNING FIELD-SYMBOL(<ls_sp_zeiten>) WITH KEY zintervallart = 'RI'.    "Check RI
    IF sy-subrc <> 0.
      READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = 'JI'.  "If not RI, then must be RJ  => HP RJ is wrong I thin it should be JI
      IF syst-subrc <> 0.
        READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = 'TS'.  "If not RI, then must be RJ  => HP RJ is wrong I thin it should be JI
*--> Begin Insert >001<
        IF syst-subrc <> 0.
          READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = mc_intervallart_li.
        ENDIF.
*--> End Insert >001<.
      ENDIF.
    ENDIF.

    IF sy-subrc = 0.
      lo_sp_zeit ?=  me->go_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
      CHECK lo_sp_zeit IS BOUND.
      rs_data = CORRESPONDING #( lo_sp_zeit->get_data_conv_24( ) ).
    ENDIF.

  ELSE.                                                                 "Prio 2 (not dermined in Prio 1) - find SP in OS with the longest time range

    LOOP AT lt_sp_zeiten ASSIGNING <ls_sp_zeiten>.

      IF ( <ls_sp_zeiten>-sperrabschnitt(1) NE 'N' AND
           <ls_sp_zeiten>-sperrabschnitt(1) NE 'S' AND
           <ls_sp_zeiten>-sperrabschnitt(1) NE 'C' ).
        CONTINUE.
      ENDIF.

      lo_sp_zeit ?= me->go_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
      CHECK lo_sp_zeit IS BOUND.
      DATA(ls_sp_zeit) = lo_sp_zeit->get_data_conv_24( ).

      TRY.
          cl_abap_tstmp=>td_subtract(
           EXPORTING
             date1 = ls_sp_zeit-end_datum
             time1 = ls_sp_zeit-end_zeit
             date2 = ls_sp_zeit-start_datum
             time2 = ls_sp_zeit-start_zeit
           IMPORTING
             res_secs = lv_time_sec_new  ).

          CHECK lv_time_sec_new > lv_time_sec_curr.
          lv_time_sec_curr = lv_time_sec_new.
          rs_data = CORRESPONDING #( ls_sp_zeit ).
        CATCH cx_parameter_invalid_range.
          CONTINUE.
      ENDTRY.

    ENDLOOP.
  ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AUFTRAEGE_WD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_LIST                        TYPE        ZIA_2JOBPOOL_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_auftraege_wd.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AUFTRAEGE_WD
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

   DATA: ls_auftrag   LIKE LINE OF rt_list,
         lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
         lo_auftrag   TYPE REF TO zcl_ia_2order.

   lo_aufttag_i ?= go_orders->get_values_iterator( ).

   WHILE lo_aufttag_i->has_next( ) = abap_true.
     lo_auftrag ?= lo_aufttag_i->get_next( ).

     MOVE-CORRESPONDING lo_auftrag->get_data( ) TO ls_auftrag.
     ls_auftrag-object = lo_auftrag.

     "RGBT-1052: Befindet sich die Schicht im Status ANTL oder höher, soll das Datum (Ausführen bis) aus ZIO_BACKUP ermittelt werden.
     IF go_schicht->get_status( ) NE zif_ia_2_wrkshft_status=>mc_interval_provided.
       SELECT SINGLE gltrp FROM zia_2order_bup INTO ls_auftrag-gltrp WHERE aufnr EQ ls_auftrag-aufnr.
     ENDIF.

     "HP: Auftrag ist erstmal immer visible:
     ls_auftrag-is_visible = abap_true.

     APPEND ls_auftrag TO rt_list. CLEAR ls_auftrag.
   ENDWHILE.

   SORT rt_list ASCENDING BY zpprio.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_COLOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_COLOR                       TYPE        STRINGVAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_color.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_COLOR
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_color = ''.


    "BTG's werden GRÜN dargestellt
    IF me->is_btg( ).
      rv_color = 'green.png'.
    ELSE.

      "Zugangsarten
      DATA(ls_zugangsarten) = me->get_zugangsarten( ).
      IF ls_zugangsarten-schiene EQ abap_true AND ls_zugangsarten-pneu EQ abap_true.
        "Strasse/ Schiene = Rot   => RED
        rv_color = 'red.png'.
      ELSEIF ls_zugangsarten-schiene EQ abap_false AND ls_zugangsarten-pneu EQ abap_true.
        "Nur Strasse = Gelb       => dirty_yellow
        rv_color = 'dirty_yellow.png'.
      ELSEIF ls_zugangsarten-schiene EQ abap_true AND ls_zugangsarten-pneu EQ abap_false.
        "Nur Schiene = Grau       => GREY
        rv_color = 'grey.png'.
      ENDIF.


      "Intervallart
      "Totalsperrung = Lila
      IF rv_color = ''.
        ##NEEDED        SELECT zintervallart
                  FROM zia_d_2v_map_as
                  WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl
                    AND zintervallart = 'TS'
                  APPENDING TABLE @DATA(lt_sps).

        IF syst-subrc EQ 0.
          rv_color = 'purple.png'.
          RETURN."          EXIT.
        ENDIF.

      ENDIF.
    ENDIF.

    "Fallback => bisher wurde die AS nicht klassifiziert.
    IF rv_color = ''.
      rv_color = 'grey.png'.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_EIZ_DESCRIPTION
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIA_2_EIZ_DESCRIPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_eiz_description.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_EIZ_DESCRIPTION
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    rv_value = SWITCH #( gs_arbeitsstelle-zid_eiz
                      WHEN zif_ia_2_constant=>mc_eizid_gbtn THEN 'Erstfeld'  ##NO_TEXT
                      WHEN zif_ia_2_constant=>mc_eizid_gbts THEN 'Biasca'   ##NO_TEXT
                      ELSE '' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG(optional)
* | [--->] IV_ACTIVE                      TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RT_VALUE                       TYPE        ZIA_2EZ_FORM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    TRY .
        rt_value[] = go_schicht->get_ez_form( iv_zarbstl  = gs_arbeitsstelle-zarbstl
                                              iv_richtung = iv_richtung
                                              iv_active   = iv_active ).
      ##NO_HANDLER      CATCH cx_sy_ref_is_initial.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2WRKPLACE=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT_ID                  TYPE        ZIA_2_SCHICHT
* | [--->] IV_ARBSTLE_ID                  TYPE        ZIA_2_ID_ARBSTL
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IA_2WRKPLACE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Get Instance
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    CHECK iv_schicht_id IS NOT INITIAL
       AND iv_arbstle_id IS NOT INITIAL.

    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = iv_schicht_id ).

    ro_instance = NEW #( io_schicht = lo_schicht
                         iv_id      = iv_arbstle_id ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_INTERVALLARTEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_INTERVALLARTEN              TYPE        ZIA_2_INTERVAL_TYPE_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_intervallarten.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       19.08.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* This method determines which interval types are present for a set of
* orders and the associated shift
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    " Initialize all interval flags to false
    rs_intervallarten-regelintervall = abap_false.
    rs_intervallarten-totalsperrung  = abap_false.
    rs_intervallarten-jokerintervall = abap_false.

    " Declare reference to a single order
    DATA: lo_auftrag TYPE REF TO zcl_ia_2order.

    " Get an iterator over the list of orders
    DATA(li_auftraege_iterator) = me->go_orders->get_values_iterator( ).

    " Loop through all orders
    WHILE li_auftraege_iterator->has_next( ).
      " Get the next order object from the iterator
      lo_auftrag ?= li_auftraege_iterator->get_next( ).

      " Evaluate the interval type (zintervall) of the order
      CASE lo_auftrag->get_data( )-zintervall.
        WHEN 'RI'.  " Rule/Joker interval
          rs_intervallarten-regelintervall = abap_true.
        WHEN 'TS'.  " Total lock interval
          rs_intervallarten-totalsperrung = abap_true.
        WHEN 'LI'.  " Long interval (custom case, comment indicates enhancement >001<)
          rs_intervallarten-langintervall = abap_true.
        WHEN 'JI'.  " Long interval (custom case, comment indicates enhancement >001<)
          rs_intervallarten-jokerintervall = abap_true.
      ENDCASE.

    ENDWHILE.

    " Joker interval can only be determined based on the shift data
    " Check if regular interval is active (potential condition to evaluate Joker)
    IF rs_intervallarten-regelintervall = abap_true.

      " Get all blocking sections (Sperrabschnitte) from the shift
      DATA(lt_sp_schicht) = go_schicht->get_sp_schicht( ).

      " Look for a blocking section with a Joker interval ('JI')
      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WITH KEY zintervallart = 'JI'.

      IF sy-subrc = 0.
        " If a Joker interval is found, deactivate the regular interval
        rs_intervallarten-regelintervall = abap_false.
        " And activate the Joker interval flag
        rs_intervallarten-jokerintervall = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_LINUMBER_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIA_2_LINUMBER_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
   METHOD get_linumber_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_LINUMBER_AS_TEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
     DATA(lv_linumber) = VALUE string( ).


     "Sperrabschnitt-Daten abrufen.
     SELECT linumber
       INTO TABLE @DATA(lt_sp_data)
       FROM zia_d_2_map_as
       WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.
     IF  lt_sp_data IS INITIAL.
       RETURN.
     ENDIF.

     SORT lt_sp_data BY linumber.
     DELETE ADJACENT DUPLICATES FROM lt_sp_data COMPARING linumber.
     SORT lt_sp_data BY linumber.

     LOOP AT lt_sp_data ASSIGNING FIELD-SYMBOL(<ls_sp_data>) WHERE linumber IS NOT INITIAL.

       lv_linumber = |{ <ls_sp_data>-linumber ALPHA = OUT }|.
       IF rv_value IS INITIAL.
         rv_value = lv_linumber.
       ELSE.
         rv_value = |{ rv_value }; { lv_linumber }|.
       ENDIF.
     ENDLOOP.
   ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_NETTOARBEITSZEIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ARBEITSZEIT                 TYPE        ZIA_2_ARBEITSZEIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_nettoarbeitszeit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_NETTOARBEITSZEIT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_sp_zeit       TYPE REF TO zcl_ia_2restr_asso_tims.
    DATA ls_sp_zeit       TYPE zia_2sf_bs_time.
    DATA lv_time_rng_sec  TYPE i.
    DATA lt_sp_zeiten     TYPE tt_sp_zeiten_tab.

    FIELD-SYMBOLS <ls_sp_zeiten> LIKE LINE OF lt_sp_zeiten.


    lt_sp_zeiten = me->get_sp_zeiten_tab( ).
    IF lt_sp_zeiten IS INITIAL.
      RETURN.
    ENDIF.
*--> Begin Change >001<
    IF line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'E' ] ) OR      ##WARN_OK
       line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'W' ] ) OR
       line_exists( lt_sp_zeiten[ zintervallart = 'RI' sperrabschnitt(1) = 'W' ] ) OR    "Prio 1 - Find Intervallart =  RI/RJ (Tunnel)
       line_exists( lt_sp_zeiten[ zintervallart = 'RI' sperrabschnitt(1) = 'E' ] ) OR
       line_exists( lt_sp_zeiten[ zintervallart = 'JI' sperrabschnitt(1) = 'W' ] ) OR
       line_exists( lt_sp_zeiten[ zintervallart = 'JI' sperrabschnitt(1) = 'E' ] ) OR
*--> End Change >001<
*--> Begin Insert >001<
      line_exists( lt_sp_zeiten[ zintervallart = mc_intervallart_li sperrabschnitt(1) = mc_sperrabs-w ] ) OR
      line_exists( lt_sp_zeiten[ zintervallart = mc_intervallart_li sperrabschnitt(1) = mc_sperrabs-e ] ).
*--> End Insert >001<.

      READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = 'RI'.    "Check RI
      IF sy-subrc <> 0.
        READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = 'JI'.  "If not RI, then must be RJ  => HP RJ is wrong I thin it should be JI
        IF syst-subrc <> 0.
          READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = 'TS'.  "If not RI, then must be RJ  => HP RJ is wrong I thin it should be JI
*--> Begin Insert >001<
          IF syst-subrc <> 0.
            READ TABLE lt_sp_zeiten ASSIGNING <ls_sp_zeiten> WITH KEY zintervallart = mc_intervallart_li.
          ENDIF.
*--> End Insert >001<.
        ENDIF.
      ENDIF.


      IF sy-subrc = 0.
        lo_sp_zeit ?= me->go_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
        CHECK lo_sp_zeit IS BOUND.
        ls_sp_zeit  = lo_sp_zeit->get_data_conv_24( ).

        TRY.
            cl_abap_tstmp=>td_subtract(
              EXPORTING
                date1 = ls_sp_zeit-end_datum
                time1 = ls_sp_zeit-end_zeit
                date2 = ls_sp_zeit-start_datum
                time2 = ls_sp_zeit-start_zeit
              IMPORTING
                res_secs = lv_time_rng_sec  ).

            rv_arbeitszeit = lv_time_rng_sec.

          CATCH cx_parameter_invalid_range.
            RETURN.
        ENDTRY.

      ENDIF.

    ELSE.                                                                 "Prio 2 (not dermined in Prio 1) - find SP in OS with the longest time range

      LOOP AT lt_sp_zeiten ASSIGNING <ls_sp_zeiten>.

        IF ( <ls_sp_zeiten>-sperrabschnitt(1) NE 'N'
         AND <ls_sp_zeiten>-sperrabschnitt(1) NE 'S'
         AND <ls_sp_zeiten>-sperrabschnitt(1) NE 'C' ).
          CONTINUE.
        ENDIF.

        lo_sp_zeit ?= me->go_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
        CHECK lo_sp_zeit IS BOUND.
        ls_sp_zeit = lo_sp_zeit->get_data_conv_24( ).

        TRY.
            cl_abap_tstmp=>td_subtract(
             EXPORTING
               date1 = ls_sp_zeit-end_datum
               time1 = ls_sp_zeit-end_zeit
               date2 = ls_sp_zeit-start_datum
               time2 = ls_sp_zeit-start_zeit
             IMPORTING
               res_secs = lv_time_rng_sec  ).

            IF lv_time_rng_sec > rv_arbeitszeit.
              rv_arbeitszeit = lv_time_rng_sec.
            ENDIF.
          CATCH cx_parameter_invalid_range.
            CONTINUE.
        ENDTRY.

      ENDLOOP.

    ENDIF.

    IF rv_arbeitszeit > 0.
      rv_arbeitszeit = rv_arbeitszeit / 60.
    ENDIF.

    IF me->has_met( ) = abap_true.
      rv_arbeitszeit = rv_arbeitszeit - me->get_schicht( )->get_parameter( )->get_data( )-abzug_met.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_PERIMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIA_2_PERIMETERS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_perimeter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Returns the perimeter (ZZPERI) value from the current Schicht object.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rv_value = go_schicht->get_data( )-zzperi.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_REF_TS_AUFNR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_AUFTRAG                     TYPE        ZIA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED  METHOD get_ref_ts_aufnr.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_REF_TS_AUFNR
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

*commenting the below code lines as table ZIA_2SF_WORKA is replaced by table ZIA_2SF_WA
*    this is done by E564128 on 03.12.2025
*    SELECT SINGLE * INTO CORRESPONDING FIELDS OF rs_auftrag
*      FROM zia_2order AS auf
*        JOIN zia_2sf_wa AS arb
*          ON auf~zarbstl = arb~zarbstl
*      WHERE arb~zarbstl = gs_arbeitsstelle-zarbstl.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SC
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIA_2FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SC
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( lo_sitzplaetze_i->get_next( ) ).

        "Sitzplatz gefunden.
        DATA(ls_sitzplatz) = lo_sitzplatz->get_data( ).

        "SC der Arbeitstelle gefunden
        IF ls_sitzplatz-is_sc EQ abap_true.
          DATA(lv_personalmodul_as) = lo_sitzplatz->get_fahrzeug( )->get_arbeitsstelle( )->get_kurztext( ).
          DATA(lv_personalmodul_reihung) = lo_sitzplatz->get_fahrzeug( )->get_reihung( ).
          CONCATENATE lv_personalmodul_as '.' lv_personalmodul_reihung INTO ls_sitzplatz-personalmodul.
          APPEND ls_sitzplatz TO rt_sitzplaetze.
        ENDIF.

      ENDWHILE.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SIGABS_BY_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INCLUDE_MANUAL              TYPE        BOOLEAN (default =ABAP_FALSE)
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [<-()] RT_SIGABS_EHB                  TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sigabs_by_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SIGABS_BY_SP
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lt_sigabs_ehb_manual TYPE zia_2_sgnl_sec_t. ">001<

    DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.
    lo_sp_km ?= go_sp_kilometer->get( key = iv_sperras_id ).
    IF lo_sp_km IS BOUND.
      DATA(lv_min) = lo_sp_km->get_zkmin( ).
      DATA(lv_max) = lo_sp_km->get_zkmax( ).
      DATA(lv_est) = lo_sp_km->get_text( ).
      DATA(lv_zzperi) = me->go_schicht->get_data( )-zzperi.


      SELECT * FROM zia_2sc INTO TABLE @rt_sigabs_ehb
            WHERE  km_von >= @lv_min AND km_bis <= @lv_max
                   AND zest EQ @lv_est
                   AND zzperi = @lv_zzperi.

*    ENDIF.
*--> Begin Insert >001<
      IF iv_include_manual EQ abap_true AND
        zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.

        DATA(lt_manual_signals) = lo_sp_km->get_user_signals( ).
        lt_sigabs_ehb_manual = CORRESPONDING #( lt_manual_signals ).

        IF lt_sigabs_ehb_manual[] IS NOT INITIAL.
          APPEND LINES OF lt_sigabs_ehb_manual TO rt_sigabs_ehb.
          SORT rt_sigabs_ehb BY km_von.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SIGABS_BY_SP_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [<-()] RV_SIGABS_EHB                  TYPE        STRINGVAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sigabs_by_sp_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SIGABS_BY_SP_AS_TEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.
    lo_sp_km ?= go_sp_kilometer->get( key = iv_sperras_id ).
    IF lo_sp_km IS BOUND.
      DATA(lv_min) = lo_sp_km->get_zkmin( ).
      DATA(lv_max) = lo_sp_km->get_zkmax( ).
      DATA(lv_est) = lo_sp_km->get_text( ).
      DATA(lv_zzperi) = me->go_schicht->get_data( )-zzperi.

      SELECT MIN( zsa )  AS von_sa,
             MIN( zehb ) AS von_ehb,
             MAX( zsa )  AS bis_sa,
             MAX( zehb ) AS bis_ehb
        FROM zia_2sc INTO @DATA(ls_sa_ehb)
        WHERE  (    ( km_von <= @lv_min AND km_bis >= @lv_min ) " An Skizze aufzeichnen
                 OR ( km_von >= @lv_min AND km_bis <= @lv_max )
                 OR ( km_von < @lv_max AND km_bis >= @lv_max ) )
               AND zest EQ @lv_est
               AND zzperi = @lv_zzperi.
    ENDIF.
*--> Begin Insert >001<
    IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
      DATA(lv_schicht) = me->go_schicht->get_id( ).

      SELECT MIN( zsa )  AS von_sa,
             MIN( zehb ) AS von_ehb,
             MAX( zsa )  AS bis_sa,
             MAX( zehb ) AS bis_ehb
       FROM zia_2sf_sc_usr
        INTO @DATA(ls_sa_user_ehb)
            WHERE zarbstl    = @me->gs_arbeitsstelle-zarbstl
              AND sperras_id = @iv_sperras_id
              AND zschicht   = @lv_schicht.

      IF ls_sa_user_ehb IS NOT INITIAL.

        ls_sa_ehb-von_sa  = COND #( WHEN ls_sa_user_ehb-von_sa < ls_sa_ehb-von_sa THEN ls_sa_user_ehb-von_sa
                                   ELSE ls_sa_ehb-von_sa ).

        ls_sa_ehb-von_ehb = COND #( WHEN ls_sa_user_ehb-von_ehb < ls_sa_ehb-von_ehb THEN ls_sa_user_ehb-von_ehb
                                    ELSE ls_sa_ehb-von_ehb ).

        ls_sa_ehb-bis_sa  = COND #( WHEN ls_sa_user_ehb-bis_sa > ls_sa_ehb-bis_sa THEN ls_sa_user_ehb-bis_sa
                                    ELSE ls_sa_ehb-bis_sa ).

        ls_sa_ehb-bis_ehb = COND #( WHEN ls_sa_user_ehb-bis_ehb > ls_sa_ehb-bis_ehb THEN ls_sa_user_ehb-bis_ehb
                                    ELSE ls_sa_ehb-bis_ehb ).

      ENDIF.
    ENDIF.
*--> End Insert >001<

    SHIFT ls_sa_ehb-von_sa LEFT DELETING LEADING '0'.
    SHIFT ls_sa_ehb-von_ehb LEFT DELETING LEADING '0'.
    SHIFT ls_sa_ehb-bis_sa LEFT DELETING LEADING '0'.
    SHIFT ls_sa_ehb-bis_ehb LEFT DELETING LEADING '0'.

    rv_sigabs_ehb = | { ls_sa_ehb-von_sa }/{ ls_sa_ehb-von_ehb } - { ls_sa_ehb-bis_sa }/{ ls_sa_ehb-bis_ehb }|.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SIGNALABSCHNITT_NEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SA                          TYPE        ZIA_2SC
* | [--->] IT_SA_RNG                      TYPE        ZIA_2SPABSCH_RANGE_T(optional)
* | [<-()] RS_SA                          TYPE        ZIA_2SC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalabschnitt_next.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SIGNALABSCHNITT_NEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF it_sa_rng IS INITIAL.   ">001< (+)
      DATA(lt_spabsch_range) = get_sperrabschnitte_range( ).
    ELSE.
      lt_spabsch_range = it_sa_rng.
    ENDIF.                     ">001< (+)

    rs_sa = zcl_ia_2utilities2=>get_signalabschnitt_next( EXPORTING is_sa            = is_sa
                                                                    it_spabsch_range = lt_spabsch_range ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SIGNALABSCHNITT_PREV
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SA                          TYPE        ZIA_2SC
* | [<-()] RS_SA                          TYPE        ZIA_2SC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalabschnitt_prev.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SIGNALABSCHNITT_PREV
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_spabsch_range) = get_sperrabschnitte_range( ).

    rs_sa = zcl_ia_2utilities2=>get_signalabschnitt_prev( EXPORTING is_sa            = is_sa
                                                                    it_spabsch_range = lt_spabsch_range ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SITZPLAETZE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SITZPLAETZE                 TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sitzplaetze.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SITZPLAETZE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug      TYPE REF TO zcl_ia_2vehicle,
          lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator,
          lo_sitzplatz     TYPE REF TO zcl_ia_2seat.

    ro_sitzplaetze = NEW #( ).
    lo_fahrzeuge_i ?= go_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_sitzplaetze_i ?= lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).

        ro_sitzplaetze->put( EXPORTING key = lo_sitzplatz->get_id( )   value = lo_sitzplatz ).
      ENDWHILE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SITZPLATZ_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SITZPLATZ_ID                TYPE        ZIA_2ID
* | [<-()] RO_SITZPLATZ                   TYPE REF TO ZCL_IA_2SEAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sitzplatz_by_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SITZPLATZ_BY_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(li_fahrzeuge_i) = go_fahrzeuge->get_values_iterator( ).

    WHILE li_fahrzeuge_i->has_next( ).
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).

      DATA(li_sitzplatz_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).

      WHILE li_sitzplatz_i->has_next( ).
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplatz_i->get_next( ) ).
        CHECK lo_sitzplatz->get_id( ) = iv_sitzplatz_id.

        ro_sitzplatz = lo_sitzplatz.
        RETURN.

      ENDWHILE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SPERRABSCHNITTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIA_2_ZUGANGSART(optional)
* | [<-()] RT_MAP_AS_SZG                  TYPE        ZIA_2MAP_AS_SZG_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SPERRABSCHNITTE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rt_map_as_szg = gt_map_as_szg.

    IF iv_zugangsart IS NOT INITIAL.
      DELETE rt_map_as_szg WHERE zugangsart <> iv_zugangsart.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SPERRABSCHNITTE_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIA_2_SPERRABSCHNITT_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
   METHOD get_sperrabschnitte_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SPERRABSCHNITTE_AS_TEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

     "SPERRABSCHNITT-DATEN ABRUFEN.
*     SELECT sperrabschnitt, zintervallart, sperras_id
*       INTO TABLE @DATA(lt_sp_data)
*       FROM zia_d_2_map_as
*       WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.
     DATA: lv_sperras_id TYPE string,
           lv_shift      TYPE string.

     ##WARN_OK     SELECT SINGLE sperras_id
            FROM zia_2map_as_szg
            INTO @lv_sperras_id
            WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.

     " Split iv_sperras_id into sperras_id and shift
     lv_shift  = lv_sperras_id(12).  " First 10 characters for sperras_id
     lv_sperras_id      = lv_sperras_id+12(4).  " Next 4 characters for shift

     SELECT DISTINCT a~sperras_id, b~mncod, c~oteil
       FROM zia_2map_as_szg AS a
       INNER JOIN qmma AS b ON b~qmnum = @lv_shift AND b~manum = @lv_sperras_id
       INNER JOIN qmfe AS c ON c~qmnum = @lv_shift AND c~fenum = @lv_sperras_id
       INTO TABLE @DATA(lt_sp_data).
*       WHERE a~zarbstl = @me->gs_arbeitsstelle-zarbstl.


     CHECK lt_sp_data[] IS NOT INITIAL.

     SORT lt_sp_data BY mncod oteil sperras_id.
     DELETE ADJACENT DUPLICATES FROM lt_sp_data COMPARING mncod oteil.
     SORT lt_sp_data BY sperras_id.

     LOOP AT lt_sp_data ASSIGNING FIELD-SYMBOL(<ls_sp_data>).

       DATA(lv_spabs) = |{ <ls_sp_data>-mncod }({ <ls_sp_data>-oteil })|.

       IF rv_value IS INITIAL.
         rv_value = lv_spabs.
       ELSE.
         rv_value = |{ rv_value }; { lv_spabs }|.
       ENDIF.

     ENDLOOP.

   ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_SPERRABSCHNITTE_RANGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_RANGE                       TYPE        ZIA_2SPABSCH_RANGE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte_range.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SPERRABSCHNITTE_RANGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rt_range = VALUE #( ( sign = 'I' option = 'EQ' low = go_schicht->get_rj_est( ) ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SPERRABSCHNITTE_WITH_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIA_2_ZUGANGSART(optional)
* | [<-()] RT_VALUE                       TYPE        ZIA_2_SPID_SPABS_INTART_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_sperrabschnitte_with_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SPERRABSCHNITTE_WITH_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
   DATA lt_zugangsart_r TYPE RANGE OF zia_2map_as_szg-zugangsart.

   IF iv_zugangsart IS NOT INITIAL.
     lt_zugangsart_r = VALUE #( ( sign = 'I' option = 'EQ' low = iv_zugangsart ) ).
   ENDIF.
   DATA: lv_sperras_id TYPE string,
         lv_shift      TYPE string.

   SELECT SINGLE sperras_id                     ##WARN_OK
     FROM zia_2map_as_szg
     INTO @lv_sperras_id
     WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.

   " SPLIT IV_SPERRAS_ID INTO SPERRAS_ID AND SHIFT
   lv_shift  = lv_sperras_id(12).  " FIRST 10 CHARACTERS FOR SPERRAS_ID
   lv_sperras_id      = lv_sperras_id+16(4).  " NEXT 4 CHARACTERS FOR SHIFT

   SELECT DISTINCT a~sperras_id,
      a~zugangsart,
      b~oteil AS zintervallart, c~mncod AS sperrabschnitt
     FROM zia_2map_as_szg AS a
     INNER JOIN viqmfe AS b ON b~qmnum = @lv_shift
*     AND b~manum = @lv_sperras_id
     INNER JOIN viqmma AS c ON c~qmnum = @lv_shift AND c~manum = @lv_sperras_id
     WHERE a~zarbstl    =  @gs_arbeitsstelle-zarbstl
     AND a~zugangsart IN @lt_zugangsart_r[]
     AND b~kzloesch = ''
     INTO CORRESPONDING FIELDS OF TABLE @rt_value.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SP_DETAILS_WD
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_SP_EHB                      TYPE        ZIA_2SP_EHB_WD_T
* | [<-->] CT_SP_DETAILS                  TYPE        ZIA_2SP_DETIALS_WD_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_details_wd.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SP_DETAILS_WD
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_sp_zeit       TYPE REF TO zcl_ia_2restr_asso_tims,
          lo_sp_km         TYPE REF TO zcl_ia_2_sp_kilometer,
##NEEDED          lt_sp_details_wd TYPE STANDARD TABLE OF zia_2_sp_detials_wd_s.

    "Sperrabschnitt pro Schicht
    DATA(lt_sp_schicht) = go_schicht->get_sp_schicht( ).

    "Alle zugeordnete Sperrabschnitte zur Arbeitsstelle
    DATA(lt_distinct_sp) = me->gt_map_as_szg.
    SORT lt_distinct_sp BY sperras_id.
    DELETE ADJACENT DUPLICATES FROM lt_distinct_sp COMPARING sperras_id.

    LOOP AT lt_distinct_sp ASSIGNING FIELD-SYMBOL(<ls_distinct_sp>) .
      READ TABLE me->gt_map_as_szg WITH KEY sperras_id = <ls_distinct_sp>-sperras_id ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>). "#EC CI_STDSEQ

      lo_sp_zeit ?= me->go_sp_zeiten->get( key = <ls_map_as_szg>-sperras_id ).
      IF lo_sp_zeit IS BOUND.
        DATA(ls_sp_zeit) = lo_sp_zeit->get_data( ).
      ENDIF.

      READ TABLE ct_sp_details ASSIGNING FIELD-SYMBOL(<ls_sp_details_wd>) WITH KEY start_datum = ls_sp_zeit-start_datum "#EC CI_STDSEQ
                                                                                   start_zeit = ls_sp_zeit-start_zeit
                                                                                   end_datum = ls_sp_zeit-end_datum
                                                                                   end_zeit = ls_sp_zeit-end_zeit.

*
      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WITH KEY sperras_id = <ls_map_as_szg>-sperras_id. "#EC CI_STDSEQ

      "Gruppierung nach Datum/Zeit
      IF <ls_sp_details_wd> IS NOT ASSIGNED OR
         <ls_sp_schicht>-zintervallart = 'TS'.
        "Komination nicht vorhanden => neu

        lo_sp_km ?= me->go_sp_kilometer->get( key = <ls_map_as_szg>-sperras_id ).

        APPEND INITIAL LINE TO ct_sp_details ASSIGNING <ls_sp_details_wd>.

*--> Begin Insert >001<
        IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
          <ls_sp_details_wd>-sperras_id  = ls_sp_zeit-sperras_id.
        ENDIF.
*--> End Insert >001<
        <ls_sp_details_wd>-start_datum = ls_sp_zeit-start_datum.
        <ls_sp_details_wd>-start_zeit  = ls_sp_zeit-start_zeit.
        <ls_sp_details_wd>-end_datum   = ls_sp_zeit-end_datum.
        <ls_sp_details_wd>-end_zeit    = ls_sp_zeit-end_zeit.
        <ls_sp_details_wd>-datum       = ls_sp_zeit-start_datum.
        IF <ls_sp_schicht> IS ASSIGNED.
          <ls_sp_details_wd>-sp_zeiten = |{ ls_sp_zeit-start_zeit(2) }:{ ls_sp_zeit-start_zeit+2(2) }:{ ls_sp_zeit-start_zeit+4(2) } - {
                                            ls_sp_zeit-end_zeit(2) }:{ ls_sp_zeit-end_zeit+2(2) }:{ ls_sp_zeit-end_zeit+4(2) } {
                                            <ls_sp_schicht>-sperrabschnitt }|.

          IF lo_sp_km IS BOUND.
            <ls_sp_details_wd>-sp_kilometer = |KM: { lo_sp_km->get_ausdehnung_as_text( ) }|.
          ENDIF.
          <ls_sp_details_wd>-sp_sigabs_ehb = |Signalabschn./EHB: { me->get_sigabs_by_sp_as_text( <ls_map_as_szg>-sperras_id ) }|.
          <ls_sp_details_wd>-sp_filter = <ls_sp_schicht>-sperrabschnitt.
        ENDIF.
      ELSE.
        "Kombination vorhanden
        READ TABLE lt_sp_schicht ASSIGNING <ls_sp_schicht> WITH KEY sperras_id = <ls_map_as_szg>-sperras_id. "#EC CI_STDSEQ
        <ls_sp_details_wd>-sp_zeiten = |{ <ls_sp_details_wd>-sp_zeiten };{ <ls_sp_schicht>-sperrabschnitt }|.
        <ls_sp_details_wd>-sp_filter = |{ <ls_sp_details_wd>-sp_filter }{ <ls_sp_schicht>-sperrabschnitt }|.
        CLEAR: <ls_sp_details_wd>-sp_kilometer, <ls_sp_details_wd>-sp_sigabs_ehb.
        "Zusammenfassung von Kilometer und Signalabschnitten/Erhaltungsbezirken
      ENDIF.
      IF <ls_map_as_szg> IS ASSIGNED.
        DATA(lt_tmp) = get_sigabs_by_sp( iv_sperras_id = <ls_map_as_szg>-sperras_id ).
        LOOP AT lt_tmp ASSIGNING FIELD-SYMBOL(<ls_tmp>). "#EC CI_NESTED
          APPEND INITIAL LINE TO et_sp_ehb ASSIGNING FIELD-SYMBOL(<ls_sp_ehb>).
          MOVE-CORRESPONDING <ls_tmp> TO <ls_sp_ehb>.
          <ls_sp_ehb>-sp_filter = <ls_sp_schicht>-sperrabschnitt.
        ENDLOOP.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SP_KILOMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SP_KILOMETER                TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_kilometer.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Getter method to return the reference to the SP_KILOMETER object.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ro_sp_kilometer = me->go_sp_kilometer.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SP_ZEITEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SP_ZEITEN                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SP_ZEITEN
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ro_sp_zeiten = go_sp_zeiten.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SUPPLY_TYPE_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
   METHOD get_supply_type_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SUPPLY_TYPE_AS_TEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
     DATA lt_sp_data TYPE STANDARD TABLE OF zia_d_2_map_as WITH DEFAULT KEY.

*     SELECT supply_type
*       INTO CORRESPONDING FIELDS OF TABLE @lt_sp_data
*       FROM zia_d_2_map_as
*       WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl.

     SELECT fecod AS supply_type
##TOO_MANY_ITAB_FIELDS       INTO CORRESPONDING FIELDS OF TABLE @lt_sp_data
         FROM qmfe
         WHERE qmnum = @me->gs_arbeitsstelle-zschicht.

     IF sy-subrc <> 0.
       RETURN.
     ENDIF.

     SORT lt_sp_data BY supply_type.
     DELETE ADJACENT DUPLICATES FROM lt_sp_data.

     LOOP AT lt_sp_data ASSIGNING FIELD-SYMBOL(<ls_sp_data>).
       rv_data = COND #( WHEN rv_data IS INITIAL THEN <ls_sp_data>-supply_type
                          ELSE |{ rv_data }; { <ls_sp_data>-supply_type }| ).
     ENDLOOP.

   ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_TEXT_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIA_2_ZUGANGSART
* | [--->] IV_INC_TS                      TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RV_VALUE                       TYPE        ZIA_2_ARBST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_text_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Generates a text ID based on Zugangsart from SP_KTEXT table.
* Optionally appends 'TS' if TS data is active and flag is set.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).

    LOOP AT lt_sp_ktext ASSIGNING FIELD-SYMBOL(<ls_sp_ktext>)
         WHERE zugangsart = iv_zugangsart.
      rv_value = |{ <ls_sp_ktext>-prefix }{ <ls_sp_ktext>-index }|.
      EXIT.
    ENDLOOP.

    CHECK rv_value IS NOT INITIAL.

    IF iv_inc_ts = abap_true.
      rv_value = |{ rv_value }{ COND #( WHEN has_ts( ) THEN `TS` ELSE `` ) }|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_THF
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIA_2FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_thf.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_THF
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( lo_sitzplaetze_i->get_next( ) ).

        "Sitzplatz gefunden.
        DATA(ls_sitzplatz) = lo_sitzplatz->get_data( ).

        "SC der Arbeitstelle gefunden
        IF ls_sitzplatz-is_thf EQ abap_true.
          DATA(lv_personalmodul_as) = lo_sitzplatz->get_fahrzeug( )->get_arbeitsstelle( )->get_kurztext( ).
          DATA(lv_personalmodul_reihung) = lo_sitzplatz->get_fahrzeug( )->get_reihung( ).
          CONCATENATE lv_personalmodul_as '.' lv_personalmodul_reihung INTO ls_sitzplatz-personalmodul.
          APPEND ls_sitzplatz TO rt_sitzplaetze.
        ENDIF.

      ENDWHILE.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_WD_HEADER_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_TEXT                        TYPE        ZIA_2_AS_HEADER_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_wd_header_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       19.08.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* This method builds a formatted header text (rv_text) for display in
* the Web Dynpro UI
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    CONSTANTS lc_separator_ver TYPE char1 VALUE '|'.
    DATA(lv_versorgung_txt) = VALUE string( ).

    DATA(ls_intervallarten) = me->get_intervallarten( ).      "Get intervall types

    rv_text = COND #(
        WHEN ls_intervallarten-jokerintervall = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_JOKERINTERVALL' )
        WHEN ls_intervallarten-totalsperrung  = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_REGERINTERVALL_MIT_TS' )
        WHEN ls_intervallarten-langintervall  = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_LANGINTERVALL' ) ).
    ">001< +

    " if no Intervallart exists for any Auftrag then get LI from Schicht (of course if exists)
    IF rv_text IS INITIAL.
      DATA(lt_sp_schicht) = go_schicht->get_sperrabschnitte( ).
      rv_text = COND #( WHEN line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-li ] )
                        THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_LANGINTERVALL' )
                        ELSE cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_REGERINTERVALL' ) ). "old logic
    ENDIF.



    DATA(lv_supply_type) = go_schicht->get_parameter( )->get_data( )-supply_type.
    IF lv_supply_type IS NOT INITIAL.
      lv_versorgung_txt = COND #( WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung
                                  THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_VERSORGUNGSSCHICHT' )
                                  WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung
                                  THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_ENTSORGUNG' )
                                  WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt
                                  THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/NO_RIDE' ) ).
*                                  ELSE cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_KEINE_LOGISTIKSCHICHT' ) ).
      IF lv_versorgung_txt IS NOT INITIAL.
        rv_text = |{ rv_text } | & |{ lc_separator_ver } | & |{ lv_versorgung_txt }|.
      ENDIF.
    ENDIF.

    rv_text = | { rv_text } | & | { lc_separator_ver } | & | { me->get_kurztext( ) } |.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->HAS_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_auftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_value = boolc( go_orders->get( key = iv_aufnr ) IS BOUND ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->HAS_OSX
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_osx.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : HAS_OSX
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lv_sperras_id TYPE string,
          lv_shift      TYPE string.
*    ##NEEDED    DATA:  lv_order      TYPE eaml_tabkey.
    rv_boolean = abap_false.
    LOOP AT gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

**      SELECT substring( sperrabschnitt, 1, 1 ) AS sperrabschnitt
**        FROM zia_2sf_bs
**        WHERE sperras_id EQ @<ls_map_as_szg>-sperras_id
**        APPENDING TABLE @DATA(lt_sps).
      lv_shift  = <ls_map_as_szg>-sperras_id(12).  " First 10 characters for sperras_id
      lv_sperras_id      = <ls_map_as_szg>-sperras_id+16(4).  " Next 4 characters for shift


      SELECT substring( mncod, 1, 1 ) AS sperrabschnitt
             FROM viqmma
             WHERE qmnum EQ @lv_shift AND manum EQ @lv_sperras_id
*        WHERE qmnum EQ @lv_sperras_id
             APPENDING TABLE @DATA(lt_sps).

    ENDLOOP.
    "OSS
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'S' TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
    IF syst-subrc = 0.
      rv_boolean = abap_true.
    ENDIF.

    "OSN
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'N' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->HAS_TS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_HAS_TS                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_ts.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Checks if a TS (Technische Sperre) interval exists in the SP_KTEXT data.
* Returns ABAP_TRUE if a 'TS' zintervallart entry is found in mapping table.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rv_has_ts = abap_false.

    me->get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).

    IF lt_sp_ktext IS INITIAL.
      RETURN.
    ENDIF.

    IF line_exists( gt_map_sp_as[ zintervallart = 'TS' ] ).
      rv_has_ts = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_EMPTY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_empty.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_EMPTY
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    TRY .
        rv_value = go_orders->is_empty( ).

      CATCH cx_sy_ref_is_initial.
        rv_value = abap_true.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_FZG_KM_SA_TRENNUNG_VALID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_fzg_km_sa_trennung_valid.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_FZG_KM_SA_TRENNUNG_VALID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

    rv_value = abap_true. "Default

    lo_fahrzeuge_i ?= go_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      IF lo_fahrzeug->is_km_trennung_valid( ) EQ abap_false.
        lo_fahrzeug->set_km_trennung( 0 ).
        rv_value = abap_false.
      ENDIF.

      IF lo_fahrzeug->is_signal_trennung_valid( ) EQ abap_false.
        lo_fahrzeug->set_km_signal( '0' ).
        rv_value = abap_false.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_IN_OS_NORD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_os_nord.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_IN_OS_NORD
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_sperras_id TYPE string,
          lv_shift      TYPE string.
    rv_boolean = abap_false.
    ">001< (+) begin
    IF gs_arbeitsstelle-zid_btg IS NOT INITIAL.
      RETURN.
    ENDIF.
    ">001< (+) begin

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

*      DATA(lv_sperras_id) = CONV qmnum( <ls_map_as_szg>-sperras_id ).

      lv_shift  = <ls_map_as_szg>-sperras_id(12).  " First 10 characters for sperras_id
      lv_sperras_id      = <ls_map_as_szg>-sperras_id+16(4).  " Next 4 characters for shift


      SELECT substring( mncod, 1, 1 ) AS sperrabschnitt
        FROM viqmma
        WHERE qmnum EQ @lv_shift AND manum EQ @lv_sperras_id
*        WHERE qmnum EQ @lv_sperras_id
        APPENDING TABLE @DATA(lt_sps).

**      ##WARN_OK  SELECT SINGLE aufnr
**             FROM zia_2order
**             INTO @lv_order
**      WHERE zarbstl = @<ls_map_as_szg>-zarbstl.
**
**
**      SELECT substring( z_section, 1, 1 ) AS sperrabschnitt  FROM eaml_d_lfe_data WHERE tabkey EQ @lv_order APPENDING TABLE @DATA(lt_sps).. "#EC CI_ALL_FIELDS_NEEDED
    ENDLOOP.

    "Tunnel
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'E' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
      RETURN.
    ENDIF.

    READ TABLE lt_sps WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
      RETURN.
    ENDIF.

    "OSS
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'S' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
    ENDIF.

    "OSN GBT
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'N' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

    "OSN CBT
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'C' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_IN_OS_SUED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_os_sued.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_IN_OS_SUED
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_sperras_id TYPE string,
          lv_shift      TYPE string.
    rv_boolean = abap_false.
    ">001< (+) begin
    IF gs_arbeitsstelle-zid_btg IS NOT INITIAL.
      RETURN.
    ENDIF.
    ">001< (+) begin

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

      lv_shift  = <ls_map_as_szg>-sperras_id(12).  " First 10 characters for sperras_id
      lv_sperras_id      = <ls_map_as_szg>-sperras_id+16(4).  " Next 4 characters for shift


      SELECT substring( mncod, 1, 1 ) AS sperrabschnitt
        FROM viqmma
        WHERE qmnum EQ @lv_shift AND manum EQ @lv_sperras_id
*        WHERE qmnum EQ @lv_sperras_id
        APPENDING TABLE @DATA(lt_sps).

**      DATA(lv_sperras_id) = CONV qmnum( <ls_map_as_szg>-sperras_id ).
**
**      SELECT substring( mncod, 1, 1 ) AS sperrabschnitt
**        FROM viqmma
**        WHERE qmnum EQ @lv_sperras_id
**        APPENDING TABLE @DATA(lt_sps).
    ENDLOOP.
    "Tunnel
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'E' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
      RETURN.
    ENDIF.

    READ TABLE lt_sps WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
      RETURN.
    ENDIF.

    "OSS
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'N' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_false.
    ENDIF.

    "OSN
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'S' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_IN_QS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_qs.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_IN_QS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA: lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag     TYPE REF TO zcl_ia_2order.


    lo_auftraege_i ?= go_orders->get_values_iterator( ).
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).

      IF lo_auftrag->get_data( )-zstdkz EQ 'Q'.
        rv_boolean = abap_true.
        RETURN.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->IS_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_tunnel.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Method to check if any of the assigned Sperrabschnitte (blocking
* sections) belong to tunnel sections (identified by prefix 'E' or 'W').
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA: lv_sperras_id TYPE string,
          lv_shift      TYPE string.
    ##NEEDED    DATA:  lv_order      TYPE eaml_tabkey.
    rv_boolean = abap_false.

    " Loop through assigned Sperrabschnitt IDs of the Arbeitsstelle
    LOOP AT gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

      lv_shift  = <ls_map_as_szg>-sperras_id(12).  " First 10 characters for sperras_id
      lv_sperras_id      = <ls_map_as_szg>-sperras_id+16(4).  " Next 4 characters for shift

      SELECT substring( mncod, 1, 1 ) AS sperrabschnitt
        FROM viqmma
        WHERE   qmnum = @lv_shift AND manum = @lv_sperras_id
        APPENDING TABLE @DATA(lt_sps).
**      SELECT SINGLE aufnr
**                   FROM zia_2order
**                   INTO @lv_order
**            WHERE zarbstl = @<ls_map_as_szg>-zarbstl.
**
**
**      SELECT substring( z_section, 1, 1 ) AS sperrabschnitt  FROM eaml_d_lfe_data WHERE tabkey EQ @lv_order APPENDING TABLE @DATA(lt_sps).. "#EC CI_ALL_FIELDS_NEEDED
    ENDLOOP.


    " Check for tunnel identifiers: 'E' or 'W' as first character
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'E' TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

    READ TABLE lt_sps WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->LOCK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHECK                       TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : LOCK
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

*-----------------------------------------------------------------
* Bei AS immer prüfen, ob Schicht gesperrt werden kann
*-----------------------------------------------------------------
    TRY.
        CALL METHOD go_schicht->lock( iv_check = abap_true ).
      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        RAISE EXCEPTION lx_fehler.
    ENDTRY.

*-----------------------------------------------------------------
* AS Sperren
*-----------------------------------------------------------------

*    CALL FUNCTION 'ENQUEUE_EZ_5_ARBSTELLEN' ##EXISTS
*      EXPORTING
*        mode_zio_5_arbstellen = lv_mode
*        mandt                 = sy-mandt
*        zarbstl               = gs_arbeitsstelle-zarbstl
*        _scope                = '1'
*      EXCEPTIONS
*        foreign_lock          = 1
*        system_failure        = 2
**       OTHERS                = 3
*      .

    CALL FUNCTION 'ENQUEUE_EZIA_2SF_WA'
      EXPORTING
        mode_zia_2sf_wa = lv_mode
        mandt           = sy-mandt
        zarbstl         = gs_arbeitsstelle-zarbstl
        _scope          = '2'
      EXCEPTIONS
        foreign_lock    = 1
        system_failure  = 2
        OTHERS          = 3.
*-----------------------------------------------------------------
* Rückgabe vorbereiten
*-----------------------------------------------------------------
    IF sy-subrc <> 0.
      IF sy-msgv1 IS NOT INITIAL.
        TRY.
            zcl_ia_2utilities=>get_user_details( EXPORTING iv_uname       = CONV uname( sy-msgv1 )
                                                  IMPORTING ev_voller_name = DATA(lv_name) ).
          ##NO_HANDLER          CATCH zcx_ia_2failure.
        ENDTRY.
      ENDIF.

      DATA(lv_kurztext) = get_kurztext( ).
      IF lx_fehler IS INITIAL.
        lx_fehler = NEW zcx_ia_2failure( ).
      ENDIF.
      lx_fehler->add_error_msg( EXPORTING iv_msgid = 'ZIA_2_MMT'  iv_msgno =  155 iv_msgv1 = lv_kurztext iv_msgv2 = lv_name ).
      RAISE EXCEPTION lx_fehler.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->LOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHECK                       TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock_sub_objects.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : LOCK_SUB_OBJECTS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge   TYPE REF TO cl_object_map,
          lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

    ##NEEDED    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

    lo_fahrzeuge = get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      TRY.
          CALL METHOD lo_fahrzeug->lock EXPORTING iv_check = iv_check.
          CALL METHOD lo_fahrzeug->lock_subobjects EXPORTING iv_check = iv_check.
        CATCH zcx_ia_2failure INTO DATA(lx_fehler).
          RAISE EXCEPTION lx_fehler.
      ENDTRY.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->REFRESH_AUSDEHNUNG_MET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_ausdehnung_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_AUSDEHNUNG_MET
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF me->gs_arbeitsstelle-zmet IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_met)        = zcl_ia_2met=>zif_ia_2_met~get_met_by_id( me->gs_arbeitsstelle-zmet ).
    DATA(ls_sa)         = zcl_ia_2utilities2=>get_sa_by_km(
                            iv_peri    = go_schicht->get_data( )-zzperi
                            iv_km      = ls_met-zkm
                            iv_zest    = ls_met-zzest
                            io_schicht = go_schicht  ).

*
    DATA(lt_sp_schicht) = go_schicht->get_sp_schicht( ).

    TRY.
        DATA(ls_sp_schicht) =  lt_sp_schicht[ sperrabschnitt = ls_met-zzest ].
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    " Extend the ausdehung of Sperrabschnitt
    DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( go_sp_kilometer->get( key = ls_sp_schicht-sperras_id ) ).
    IF lo_sp_km IS NOT BOUND.
      RETURN.
    ENDIF.

    DATA(ls_sp_km) = lo_sp_km->get_data( ).
    ls_sp_km-zkmin = COND #( WHEN ls_sa-km_von < ls_sp_km-zkmin THEN ls_sa-km_von ELSE ls_sp_km-zkmin ).
    ls_sp_km-zkmax = COND #( WHEN ls_sa-km_bis > ls_sp_km-zkmax THEN ls_sa-km_bis ELSE ls_sp_km-zkmax ).

    lo_sp_km->set_data( ls_sp_km ).
    go_sp_kilometer->put( EXPORTING key = ls_sp_schicht-sperras_id value = lo_sp_km ).

    " Set the mon/max ausdehung of AS
    gs_arbeitsstelle-zkmin = COND #( WHEN ls_sa-km_von < gs_arbeitsstelle-zkmin THEN ls_sa-km_von ELSE gs_arbeitsstelle-zkmin ).
    gs_arbeitsstelle-zkmax = COND #( WHEN ls_sa-km_bis > gs_arbeitsstelle-zkmax THEN ls_sa-km_bis ELSE gs_arbeitsstelle-zkmax ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REFRESH_AUSDEHUNG
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_ausdehung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_AUSDEHUNG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_abs_min TYPE zia_2_km_von VALUE 1000,
          lv_abs_max TYPE zia_2_km_bis VALUE 0,
          lo_sp_km   TYPE REF TO zcl_ia_2_sp_kilometer.

    "Sperrabschnitt Kilomter speichern
    DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE li_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= li_sp_km_i->get_next( ).

      CHECK lo_sp_km->get_intervallart( ) NE 'TS'.
*--> Begin Change >001<
      lv_abs_min = COND #( WHEN lv_abs_min < lo_sp_km->get_zkmin( abap_true ) THEN lv_abs_min ELSE lo_sp_km->get_zkmin( abap_true ) ).
      lv_abs_max = COND #( WHEN lv_abs_max > lo_sp_km->get_zkmax( abap_true )  THEN lv_abs_max ELSE lo_sp_km->get_zkmax( abap_true )  ).
*--> End Change >001<
    ENDWHILE.

    me->gs_arbeitsstelle-zkmin = lv_abs_min.
    me->gs_arbeitsstelle-zkmax = lv_abs_max.

    me->refresh_ausdehnung_met( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REFRESH_EIZ_EST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_EIZ_EST
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
METHOD refresh_eiz_est.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->REFRESH_FAHRLEITUNGSSCHALTUNG
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD refresh_fahrleitungsschaltung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_FAHRLEITUNGSSCHALTUNG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

   " Retrieve the service product Fahrleitungsschaltung data
   DATA(lt_servprod_fls) = zcl_ia_2brfplus_interface=>get_fahrleitungsschaltung( ).

   " By default, the Fahrleitung (power supply) is turned ON (set to true)
   me->gs_arbeitsstelle-zfls = abap_true.

   " Iterate over the list of orders (aufträge) in the current work area (me->go_orders)
   DATA(lo_auftrag_i) = CAST cl_object_collection_iterator( me->go_orders->get_values_iterator( ) ).
   WHILE lo_auftrag_i->has_next( ) = abap_true.
     " Get the next order from the iterator
     DATA(lo_auftrag) = CAST zcl_ia_2order( lo_auftrag_i->get_next( ) ).

     " Retrieve the material number (matnr) from the order data
     DATA(lv_matsv) = lo_auftrag->get_data( )-matnr.

     " Search for the corresponding entry in the Fahrleitungsschaltung data based on material number
     READ TABLE lt_servprod_fls INTO DATA(ls_servprod_fls) WITH KEY matsv = lv_matsv.

     " If an entry is found and the Fahrleitungsschaltung (power supply) is OFF (false),
     " set the Arbeitsstelle's Fahrleitungsschaltung to OFF (false) and exit the loop
     IF sy-subrc = 0 AND ls_servprod_fls-zfls = abap_false.
       me->gs_arbeitsstelle-zfls = abap_false.
       EXIT.  " Exit the loop once the condition is met
     ENDIF.

   ENDWHILE.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REFRESH_MANUAL_SIGNALS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_manual_signals.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_MANUAL_SIGNALS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.

    DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE li_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= li_sp_km_i->get_next( ).
      lo_sp_km->refresh_user_signals( ).
      lo_sp_km->save_user_signals( ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->REFRESH_SA_SP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
   METHOD refresh_sa_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REFRESH_SA_SP
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
     "Aufträge lesen
     DATA: lo_aufttag_i    TYPE REF TO cl_object_collection_iterator,
           lo_auftrag      TYPE REF TO zcl_ia_2order,
           lt_sa_auftraege TYPE zia_2_sgnl_sec_t.



     lo_aufttag_i ?= go_orders->get_values_iterator( ).

     WHILE lo_aufttag_i->has_next( ) = abap_true.

       lo_auftrag ?= lo_aufttag_i->get_next( ).

       APPEND LINES OF me->get_sa_for_new_auftrag( iv_rj_est = me->get_schicht( )->get_rj_est( )
                                                   iv_ts_est = me->get_schicht( )->get_ts_est( )
                                                   io_auftrag = lo_auftrag ) TO lt_sa_auftraege.

     ENDWHILE.

     CHECK lines( lt_sa_auftraege ) > 0.

     SORT lt_sa_auftraege BY zsa.
     DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.

     DATA(lv_peri) = go_schicht->get_data( )-zzperi.
     "Welche Sperrabschnitte haben wir denn so.
     LOOP AT lt_sa_auftraege ASSIGNING FIELD-SYMBOL(<ls_sa>).

       AT NEW zest.
         DATA(lt_tmp_sa) = lt_sa_auftraege.
         DELETE lt_tmp_sa WHERE zest <> <ls_sa>-zest.    "#EC CI_STDSEQ

         DATA(lv_sa_min) = lt_tmp_sa[ 1 ]-zsa.
         DATA(lv_sa_max) = lt_tmp_sa[ lines( lt_tmp_sa ) ]-zsa.

         SELECT * FROM zia_2sc
           APPENDING TABLE @DATA(lt_reloaded_sa)
           WHERE zzperi = @lv_peri
             AND zsa >= @lv_sa_min
             AND zsa <= @lv_sa_max
             AND zest = @<ls_sa>-zest.

       ENDAT.

     ENDLOOP.

     APPEND LINES OF lt_reloaded_sa TO lt_sa_auftraege.
     SORT lt_sa_auftraege BY zsa.
     DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.

     "************
     "*     Hier sind dann die Lücken auf dem Einzelnen Intervallen geschlossen
     "**************
     DATA(lv_rj_sa_min) = 99999.
     DATA(lv_rj_sa_max) = 00000.
     "MIN MAX auf dem Regelintervall
     LOOP AT lt_sa_auftraege ASSIGNING <ls_sa> WHERE zest = me->get_schicht( )->get_rj_est( ).
       lv_rj_sa_min = COND #( WHEN <ls_sa>-zsa < lv_rj_sa_min THEN <ls_sa>-zsa ELSE lv_rj_sa_min ).
       lv_rj_sa_max = COND #( WHEN <ls_sa>-zsa > lv_rj_sa_max THEN <ls_sa>-zsa ELSE lv_rj_sa_max ).
     ENDLOOP.


     "Für jeden anderen RJ Sperrabschnitt müssen wir nun die Lücken Schliessen
     LOOP AT lt_sa_auftraege ASSIGNING <ls_sa> WHERE zest <> me->get_schicht( )->get_rj_est( )
                                                 AND zest <> me->get_schicht( )->get_ts_est( ).
       AT NEW zest.
         DATA(lv_osx_zest) = <ls_sa>-zest.

*         DATA(lv_osx_sa_min) = 99999.
*         DATA(lv_osx_sa_max) = 00000.
         ##STR_NUM         DATA :lv_osx_sa_min TYPE i VALUE '99999',
        ##STR_NUM               lv_osx_sa_max TYPE i VALUE '00000'.
         "MIN MAX auf dem Regelintervall
         LOOP AT lt_sa_auftraege ASSIGNING FIELD-SYMBOL(<ls_sa_osx>) WHERE zest = lv_osx_zest. "#EC CI_NESTED "#EC CI_STDSEQ
           lv_osx_sa_min = COND #( WHEN <ls_sa>-zsa < lv_osx_sa_min THEN <ls_sa>-zsa ELSE lv_osx_sa_min ).
           lv_osx_sa_max = COND #( WHEN <ls_sa>-zsa > lv_osx_sa_max THEN <ls_sa>-zsa ELSE lv_osx_sa_max ).
         ENDLOOP.


         DATA(lv_rj_est) = me->get_schicht( )->get_rj_est( ).

         IF ( gs_arbeitsstelle-zid_eiz  = '10' AND lv_peri = 'GBT' ) OR
             ( gs_arbeitsstelle-zid_eiz = '20' AND lv_peri = 'CBT' ).
           "wir schauen richtung norden
           SELECT * FROM zia_2sc_seq
            APPENDING TABLE @DATA(lt_gaps_sa)
            WHERE (      zzperi = @lv_peri
                     AND sperrabschnitt = @lv_rj_est
                     AND signalabschnitt < @lv_rj_sa_min
                     AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) )
                   OR
                 (       zzperi = @lv_peri
                     AND sperrabschnitt = @lv_osx_zest
                     AND signalabschnitt > @lv_osx_sa_max
                     AND ( s_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
         ELSE.
           "wir schauen richtung süden
           SELECT * FROM zia_2sc_seq
            APPENDING TABLE @lt_gaps_sa
            WHERE (      zzperi = @lv_peri
                     AND sperrabschnitt = @lv_rj_est
                     AND signalabschnitt < @lv_rj_sa_max
                     AND ( s_sperrabschnitt = @lv_rj_est OR s_sperrabschnitt = @lv_osx_zest ) )
                   OR
                 (       zzperi = @lv_peri
                     AND sperrabschnitt = @lv_osx_zest
                     AND signalabschnitt > @lv_osx_sa_min
                     AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
         ENDIF.
       ENDAT.

     ENDLOOP.

     DATA: lt_sa TYPE RANGE OF zia_2_signal_section.
     IF lines( lt_gaps_sa ) > 0.
       LOOP AT lt_gaps_sa ASSIGNING FIELD-SYMBOL(<ls_gap_sa>).
         APPEND INITIAL LINE TO lt_sa ASSIGNING FIELD-SYMBOL(<ls_ra_sa>).
         <ls_ra_sa> = VALUE #( sign = 'I'
                               option = 'EQ'
                               low = <ls_gap_sa>-signalabschnitt ).
*         APPEND VALUE #( sign = 'I' option = 'EQ' low = <ls_gap_sa>-signalabschnitt ) TO lt_sa.
       ENDLOOP.

       SELECT * FROM zia_2sc APPENDING CORRESPONDING FIELDS OF TABLE @lt_sa_auftraege
         WHERE zzperi = @lv_peri
           AND zsa IN @lt_sa.

     ENDIF.

     SORT lt_sa_auftraege BY zsa.
     DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.
     "*******************
     "* Ab hier sind dann die Signalabschnitte wieder korrekt.
     "***************


     "Aufträge lesen
     DATA: lo_sp_km_i TYPE REF TO cl_object_collection_iterator,
           lo_sp_km   TYPE REF TO zcl_ia_2_sp_kilometer.

     lo_sp_km_i ?= go_sp_kilometer->get_values_iterator( ).

     WHILE lo_sp_km_i->has_next( ) = abap_true.

       lo_sp_km ?= lo_sp_km_i->get_next( ).
       DATA(lv_sperrabschnitt) = lo_sp_km->get_sp( ).

       READ TABLE lt_sa_auftraege WITH KEY zest = lv_sperrabschnitt TRANSPORTING NO FIELDS.
       IF syst-subrc <> 0.
         remove_sp( iv_sperras_id = lo_sp_km->get_data( )-sperras_id ).
       ENDIF.

       lo_sp_km->reset_extension( ).
       LOOP AT lt_sa_auftraege ASSIGNING <ls_sa> WHERE zest = lv_sperrabschnitt.
         lo_sp_km->add_sa( is_sa = <ls_sa> ).
       ENDLOOP.


     ENDWHILE.
   ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_AUFTRAEGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHANGE_ERP                  TYPE        BOOLEAN (default =ABAP_TRUE)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_auftraege.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_AUFTRAEGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag   TYPE REF TO zcl_ia_2order,
##NEEDED          lx_fehler    TYPE REF TO zcx_ia_2failure.

    lo_aufttag_i ?= go_orders->get_values_iterator( ).

    WHILE lo_aufttag_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_aufttag_i->get_next( ).

      CHECK lo_auftrag->get_data( )-zarbstl = me->gs_arbeitsstelle-zarbstl. "Story 222: Nur wirklich zugehörige Aufträge löschen

      TRY.
          me->remove_auftrag_o( io_object = lo_auftrag iv_change_erp = iv_change_erp ).
        ##NO_HANDLER        CATCH zcx_ia_2failure INTO lx_fehler.
*          RAISE EXCEPTION lx_fehler.
      ENDTRY.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECT                      TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IV_CHANGE_ERP                  TYPE        BOOLEAN (default =ABAP_TRUE)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_auftrag_o.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_AUFTRAG_O
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.
    DATA: lv_aufnr TYPE aufnr,
          lv_count TYPE i VALUE 0. "lt_auftraege TYPE zio_auftraege_t. "OPTREAL-91

    ##NEEDED    DATA: ls_auftrag   TYPE zia_2order.

    DATA: lx_fehler TYPE REF TO zcx_ia_2failure.
    DATA:lv_ustat_tabg    TYPE boolean.

*    FIELD-SYMBOLS <ls_auftrag> TYPE zia_2order.

*-----------------------------------------------------------------------------------------------------------
* Info in Appl. Log schreiben
*-----------------------------------------------------------------------------------------------------------

    DATA(lo_log) = zcl_ia_2log=>get_instance( ).
    IF io_object IS BOUND AND go_schicht IS BOUND.
      lo_log->add_info( EXPORTING iv_text       = |{ 'Auftrag entfernen' } { io_object->get_data( )-aufnr } { 'entfernen für Schicht:  ' } { go_schicht->get_data( )-start_datum }|
                                  iv_sub_object = zcl_ia_2log=>mc_sub_object_planung ).
    ENDIF.
*-----------------------------------------------------------------------------------------------------------

    ls_auftrag = io_object->get_data( ).


    zcl_ia_2lofpm_clh_app=>get_instance( iv_applid = 'GBT' ).
    IF zcl_ia_2lofpm_cla_agency=>get_status_agent( )->get_ustat_as_string( iv_objnr = io_object->get_data( )-objnr ) CS 'tabg'.
      lv_ustat_tabg = abap_true.
    ENDIF.

    "In Abhängigkeit des Schichtstatus wird beim Einplanen der Status des Auftrags in SAP geändert
    IF    go_schicht->get_status( ) GE zif_ia_2_wrkshft_status=>mc_interval_provided
      AND iv_change_erp = abap_true
      AND lv_ustat_tabg = abap_false. "Aufträge mit Anwenderstatus "Technsich abgeschlossen" können nicht mehr geändert werden

      " Aufträge im ERP zurücksetzen (Originaldaten laden)
      DATA(lv_zstatus) = go_schicht->get_status( ).
      IF    lv_zstatus GT zif_ia_2_wrkshft_status=>mc_plannig_started
        AND lv_zstatus LT zif_ia_2_wrkshft_status=>mc_shift_released .
        TRY.
            zcl_ia_2utilities=>restore_auftraege_erp( io_auftrag = io_object ).
          CATCH zcx_ia_2failure INTO lx_fehler.
            RAISE EXCEPTION lx_fehler.
        ENDTRY.
      ENDIF.
    ENDIF.

* Entferne alle Einzelkapas des Auftrags aus den Fahrzeugen/Sitzplaetzen
    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      lo_fahrzeug->remove_auftrag( io_auftrag = io_object ).

      "leeres Pneu Fahzeug kann automatisch entfernt werden.
      IF lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true AND
         lo_fahrzeug->get_auftraege( )->is_empty( ).
        lo_fahrzeug->unlock( ).
        lo_fahrzeug->unlock_subobjects( ).
        me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
      ENDIF.

    ENDWHILE.

* Entferne Auftrag aus der Arbeitsstelle
    me->go_orders->remove( key = io_object->get_data( )-aufnr ).

* Aktualisiere das Auftragsobjekt
    io_object->set_schicht( iv_schicht = 0 ).
    io_object->set_arbeitsstelle_id( iv_arbstl = 0 ).

* Aktuelisiere die Fahrleitungsschaltung
    me->refresh_fahrleitungsschaltung( ).

* AKtualisiere Ausdehnung
    me->refresh_ausdehung( ).

*   EIZ + EST in Arbstelle updaten
    me->refresh_eiz_est( ).

* Datenbank aktualisieren
    lv_aufnr = io_object->get_data( )-aufnr.
    " OPTREAL-91 START
    DATA(lv_arbsort) = io_object->get_data( )-zarbsort.
    UPDATE zia_2order SET zschicht = '0' zarbstl = '0' zarbsort = '0' zarbstl_ri = '0' WHERE aufnr = lv_aufnr.
    SELECT COUNT(*) INTO lv_count FROM zia_2order WHERE zarbsort = lv_arbsort. "#EC CI_NOFIELD
    "     Falls ja: nichts tun, da noch abhängige Aufträge mit Arbeitsort
    "     Falls nein: Aufruf von REMOVE_ARBSORT, Arbeitsort wird entfernt
    IF lv_count = 0.
      TRY.
          CALL METHOD zcl_ia_2utilities=>remove_arbsort
            EXPORTING
              iv_arbsort = lv_arbsort.
        CATCH zcx_ia_2failure INTO lx_fehler.
          RAISE EXCEPTION lx_fehler.
      ENDTRY.
    ENDIF. " OPTREAL-91 END

    IF lv_ustat_tabg = abap_true.
      UPDATE zia_2order SET zstatus = 'E' WHERE aufnr = lv_aufnr.
    ENDIF.
    COMMIT WORK.
    refresh_sa_sp( ).


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_fahrzeug.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_FAHRZEUG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lv_id_zfg TYPE zia_2_id_fzg,
          lv_id_as  TYPE zia_2_id_arbstl.
    DATA: lx_fehler   TYPE REF TO zcx_ia_2failure.

    lv_id_zfg = io_fahrzeug->get_data( )-zid_fzg.
    lv_id_as = me->gs_arbeitsstelle-zarbstl.
* mit Klassensave wird Fahrzeug gelöscht commit work?---------------------------------
* Delete sollte entfernt werden
    DELETE FROM  zia_2sf_wa_veh WHERE zid_arbstl = lv_id_as AND zid_fzg = lv_id_zfg.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
    " Aufträge entfernen
    DATA: lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag     TYPE REF TO zcl_ia_2order.

    lo_auftraege_i ?= io_fahrzeug->get_auftraege( )->get_values_iterator( ).

    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).

      CHECK lo_auftrag->get_data( )-zarbstl = me->gs_arbeitsstelle-zarbstl AND lo_auftrag->get_data( )-zarbstl IS NOT INITIAL. "Story 222: Nur wirklich zugehörige Aufträge löschen

      TRY.
          me->remove_auftrag_o( io_object = lo_auftrag ).
        CATCH zcx_ia_2failure INTO lx_fehler.
          RAISE EXCEPTION lx_fehler.
      ENDTRY.
    ENDWHILE.

    " Sitzplaetze entfernen
    io_fahrzeug->remove_sitzplaetze( ).

    " Delete from ObjectMap
    me->go_fahrzeuge->remove( key = io_fahrzeug->get_data( )-zid_fzg ).

    "Remove referenced Fahrzeuge               ">001< + begin
    IF go_schicht->is_versorgung_schicht( ).
      DATA(lt_fzg_ref) = io_fahrzeug->get_refernced_fahrzeuge( ).
      LOOP AT lt_fzg_ref ASSIGNING FIELD-SYMBOL(<ls_fzg_ref>).
        CHECK <ls_fzg_ref>-o_arbstl IS BOUND.
        CHECK <ls_fzg_ref>-o_fzg    IS BOUND.
        TRY.
            <ls_fzg_ref>-o_arbstl->remove_fahrzeug( <ls_fzg_ref>-o_fzg ).
          CATCH zcx_ia_2failure.
            CONTINUE.
        ENDTRY.
      ENDLOOP.
    ENDIF.                                     ">001< + end

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_FAHRZEUGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.
    DATA: lx_fehler     TYPE REF TO zcx_ia_2failure.

    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      TRY.
          me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
        CATCH zcx_ia_2failure INTO lx_fehler.
          RAISE EXCEPTION lx_fehler.
      ENDTRY.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_MET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_MET
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       29.12.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_log) = zcl_ia_2log=>get_instance( ).
    MESSAGE s024(zia_2_real) WITH gs_arbeitsstelle-zschicht gs_arbeitsstelle-zarbstl gs_arbeitsstelle-zkmin gs_arbeitsstelle-zkmax INTO DATA(lv_msg).
    lo_log->add_info( iv_text = CONV #( lv_msg )  iv_sub_object = zcl_ia_2log=>mc_sub_object_planung ).

    "Remove MET-Fahrzeuge
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( me->go_fahrzeuge->get_values_iterator( ) ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
      CHECK lo_fahrzeug->get_fahrzeugtyp( )-zmet = abap_true.
      TRY.
          me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
          DATA(lv_missing_reihung) = lo_fahrzeug->get_reihung( ).
        CATCH zcx_ia_2failure.
          EXIT.
      ENDTRY.
    ENDWHILE.

    "Remove empty AS
    IF me->go_orders->size( ) = 0.
      TRY.
          go_schicht->remove_arbeitsstelle( EXPORTING io_object = me ).
          go_schicht->save( ).
        CATCH zcx_ia_2failure.
          RETURN.
      ENDTRY.
      RETURN.
    ENDIF.

    me->gs_arbeitsstelle-zmet = 0.
    me->refresh_sa_sp( ).
    me->refresh_ausdehung( ).
    me->set_tremola_calc( abap_true ).

    IF me->go_fahrzeuge->size( ) OR
       lv_missing_reihung IS INITIAL.
      RETURN.
    ENDIF.

    "Update Reihung - MET removed
    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      IF lo_fahrzeug->get_reihung( ) < lv_missing_reihung.
        CONTINUE.
      ENDIF.

      DATA(lv_new_reihung) = lo_fahrzeug->get_reihung( ).
      lv_new_reihung = lv_new_reihung - 1.
      lo_fahrzeug->set_reihung( lv_new_reihung ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->REMOVE_VORSCHAU
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_vorschau.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_VORSCHAU
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_fahrzeuge_i    TYPE REF TO cl_object_collection_iterator.
    DATA lo_sitzplaetze_i  TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftraege_i    TYPE REF TO cl_object_collection_iterator.
    DATA lo_fahrzeug       TYPE REF TO zcl_ia_2vehicle.
    DATA lo_sitzplatz      TYPE REF TO zcl_ia_2seat.
    DATA lo_auftrag        TYPE REF TO zcl_ia_2order.


    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).                     "Remove Vorschau-Flag from Fahrzeuge
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      IF lo_fahrzeug->get_vorschau_flag( ) = abap_true.
        me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
      ENDIF.
    ENDWHILE.

    lo_auftraege_i  ?= go_orders->get_values_iterator( ).                           "Remove Vorschau-Flag from Auftraege
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).
      IF lo_auftrag->get_vorschau_flag( ) = abap_true.
        me->remove_auftrag_o( io_object = lo_auftrag ).
      ENDIF.
    ENDWHILE.

    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).                     "Remove Vorschau-Flag from Qualifikationen
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      lo_sitzplaetze_i ?= lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).
        IF lo_sitzplatz->get_vorschau_flag( ) = abap_true.
          lo_sitzplatz->remove_qualifikation( ).
          lo_sitzplatz->set_vorschau_flag( iv_vorschau = abap_false ).
        ENDIF.
      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SAVE_DIRECTLY               TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SAVE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA:
      ls_arbstelle TYPE zia_2sf_wa,
      ls_order_bup TYPE zia_2order_bup,
##NEEDED      lo_orders    TYPE REF TO cl_object_map,
      lo_order     TYPE REF TO zcl_ia_2order,
      lo_fahrzeuge TYPE REF TO cl_object_map,
      lo_fahrzeug  TYPE REF TO zcl_ia_2vehicle,
      lo_sp_zeit   TYPE REF TO zcl_ia_2restr_asso_tims,
      lo_sp_km     TYPE REF TO zcl_ia_2_sp_kilometer.


    "*******************
    "* Fahrzeuge in Z-tabelle speichern
    "***************
    lo_fahrzeuge = me->get_fahrzeuge( ).
    DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

    WHILE li_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= li_fahrzeuge_i->get_next( ).
      lo_fahrzeug->set_vorschau_flag( iv_vorschau = abap_false ).
      lo_fahrzeug->save( ).
    ENDWHILE.

    "*******************
    "* Aufträge in Z-tabelle speichern
    "***************
    DATA(li_order_i) = me->get_auftraege( )->get_values_iterator( ).
    WHILE li_order_i->has_next( ) = abap_true.
      lo_order ?= li_order_i->get_next( ).
      lo_order->set_vorschau_flag( iv_vorschau = abap_false ).
      DATA(ls_order) = lo_order->get_data( ).
      zcl_ia_2utilities2=>set_update_data_any_structure( CHANGING cv_update_data_structure = ls_order ).
      ls_order-maintordovrlprocsubphase = '0060'.
      UPDATE zia_2order FROM ls_order.
      COMMIT WORK.
    ENDWHILE.

    "Sperrabschnitt Zeiten speichern
    DATA(li_sp_zeit_i) = me->get_sp_zeiten( )->get_values_iterator( ).
    WHILE li_sp_zeit_i->has_next( ) = abap_true.
      lo_sp_zeit ?= li_sp_zeit_i->get_next( ).
      DATA(ls_sp_zeit) = lo_sp_zeit->get_data( ).
      zcl_ia_2utilities2=>set_update_data_any_structure( CHANGING cv_update_data_structure = ls_sp_zeit ).
      MODIFY zia_2sf_bs_time FROM ls_sp_zeit.
    ENDWHILE.

    "Sperrabschnitt Kilomter speichern
    DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE li_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= li_sp_km_i->get_next( ).
      DATA(ls_sp_km) = lo_sp_km->get_data( ).
      zcl_ia_2utilities=>set_update_data_any_structure( CHANGING cv_update_data_structure = ls_sp_km ).
      MODIFY zia_2bs_km FROM ls_sp_km.
      lo_sp_km->save_user_signals( ).
    ENDWHILE.

    IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true.
      me->refresh_ausdehung( ).
    ENDIF.


    "Mapping Sperrabschnitt Arbeitsstelle speichern
    DATA(lt_map_as_szg) = me->get_sperrabschnitte( ).
    LOOP AT lt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      zcl_ia_2utilities2=>set_update_data_any_structure( CHANGING cv_update_data_structure = <ls_map_as_szg> ).
    ENDLOOP.
    MODIFY zia_2map_as_szg FROM TABLE lt_map_as_szg.

*--> Begin Insert >001<
    ls_arbstelle = me->get_data( ).
*    zcl_ia_2utilities2=>set_update_data_any_structure( CHANGING cv_update_data_structure = ls_arbstelle ).

    ls_arbstelle-aenam = cl_abap_context_info=>get_user_technical_name( )."syst-uname.   " Change time / Änderungszeit
    ls_arbstelle-aedat = syst-datum.   " Modifier user / Benutzer der Änderung
    ls_arbstelle-aetim = syst-timlo.   " Modifier user / Benutzer der Änderung

    MODIFY zia_2sf_wa FROM ls_arbstelle.

    IF lo_order IS BOUND.
      DATA(ls_workorder) = lo_order->get_data( ).
      DATA: lv_arbpl TYPE arbpl,
            lv_gewrk TYPE lgwid.
      " get Object ID of the Work Center
      SELECT  SINGLE gewrk
        FROM afih
        INTO @lv_gewrk
        WHERE aufnr = @ls_workorder-aufnr.
      " get Name of work center
      IF sy-subrc = 0.
        SELECT SINGLE workcenter INTO @lv_arbpl      ##WARN_OK
                                 FROM  i_workcenter
                                  WHERE   workcenterinternalid = @lv_gewrk.
        "        CALL FUNCTION 'CR_WORKSTATION_READ'  "#EC CI_SUBRC
        "          EXPORTING
*                   id        = lv_gewrk
        "          IMPORTING
*                    arbpl     = lv_arbpl
        "          EXCEPTIONS
*            not_found = 1
*           OTHERS    = 2.
      ENDIF.

      ls_order_bup = VALUE #( aufnr = ls_workorder-aufnr
                              zschicht = ls_arbstelle-zschicht
                              gltrp = ls_workorder-gltrp
                              gluzp = ls_workorder-gluzp
                              gstrp = ls_workorder-gstrp
                              gsuzp = ls_workorder-gsuzp
                              arbpl = lv_arbpl
                              ).

      MODIFY zia_2order_bup FROM ls_order_bup.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_ETAPPENAUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_etappenauftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ETAPPENAUFTRAG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    me->gs_arbeitsstelle-etappenauftrag = iv_aufnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_FAHRZEUGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    me->go_fahrzeuge = io_fahrzeuge.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_MET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_MET                      TYPE        ZIA_2_ID_MET
* | [--->] IV_IGNORE_ERRORS               TYPE        ABAP_BOOL(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_MET
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_arbeitsstelle_i TYPE REF TO cl_object_collection_iterator.

    lo_arbeitsstelle_i ?= me->get_schicht( )->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE lo_arbeitsstelle_i->has_next( ) = abap_true.
      DATA(lo_arbeitsstelle) = CAST zcl_ia_2wrkplace( lo_arbeitsstelle_i->get_next( ) ).
      CHECK lo_arbeitsstelle->has_met( ) = abap_true.
      lo_arbeitsstelle->remove_met( ).
    ENDWHILE.

    DATA(lo_fahrzeuge) = zcl_ia_2rules=>get_met_fahrzeuge( iv_ignore_errors = iv_ignore_errors io_arbeitsstelle = me ).
    IF lo_fahrzeuge->size( ) > 0.
      me->add_fahrzeuge( io_objects = lo_fahrzeuge ).
    ENDIF.

    me->gs_arbeitsstelle-zmet = iv_id_met.
    me->refresh_sa_sp( ).
    me->refresh_ausdehung( ).

    DATA(lo_log) = zcl_ia_2log=>get_instance( ).
    MESSAGE s025(zia_2_real) WITH gs_arbeitsstelle-zschicht gs_arbeitsstelle-zarbstl gs_arbeitsstelle-zkmin gs_arbeitsstelle-zkmax INTO DATA(lv_msg).
    lo_log->add_info( iv_text = CONV #( lv_msg ) iv_sub_object = zcl_ia_2log=>mc_sub_object_planung ).


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_MET_AS_NAME_PREFIX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PREFIX                      TYPE        ZIA_2_MET_AS_NAME_PREFIX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_met_as_name_prefix.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_MET_AS_NAME_PREFIX
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_arbeitsstelle-prefix_met_as = iv_prefix.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_SCHICHT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    me->go_schicht = io_schicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_ZKMAX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZKMAX                       TYPE        ZIA_2SF_WA-ZKMAX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zkmax.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ZKMAX
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_arbeitsstelle-zkmax <> iv_zkmax.

    gs_arbeitsstelle-zkmax = iv_zkmax.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_ZKMIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZKMIN                       TYPE        ZIA_2SF_WA-ZKMIN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zkmin.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ZKMIN
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_arbeitsstelle-zkmin <> iv_zkmin.

    gs_arbeitsstelle-zkmin = iv_zkmin.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->UNLOCK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unlock.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : UNLOCK
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CALL FUNCTION 'DEQUEUE_EZIA_2SF_WA'
      EXPORTING
        mode_zia_2sf_wa = 'E'
        mandt           = sy-mandt
        zarbstl         = gs_arbeitsstelle-zarbstl
        x_zarbstl       = ' '
        _scope          = '3'
        _synchron       = 'X'
        _collect        = ' '.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->UNLOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unlock_sub_objects.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : UNLOCK_SUB_OBJECTS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA lo_fahrzeuge_i     TYPE REF TO cl_object_collection_iterator.
    DATA lo_fahrzeuge       TYPE REF TO cl_object_map.
    DATA lo_fahrzeug        TYPE REF TO zcl_ia_2vehicle.
    ##NEEDED    DATA lx_fehler          TYPE REF TO zcx_ia_2failure.


    lo_fahrzeuge = get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_fahrzeug->unlock( ).
      lo_fahrzeug->unlock_subobjects( ).

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_KM_VIS_FROM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_KM_VON                      TYPE        ZIA_2_KM_VON
* | [--->] IV_KM_BIS                      TYPE        ZIA_2_KM_BIS
* | [--->] IT_ZEST                        TYPE        ANY TABLE
* | [<-()] RS_KM                          TYPE        TS_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_km_vis_from.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_KM_VIS_FROM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       29.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zia_2sc AS sa INTO @rs_km
             WHERE sa~zzperi = @iv_perimeter
               AND km_von <= @iv_km_von
               AND km_bis >= @iv_km_bis
               AND sa~zest IN @it_zest.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_MAX_AUSLASTUNG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIA_2_AUSLASTUNG_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_max_auslastung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_MAX_AUSLASTUNG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_value = get_nettoarbeitszeit( ) * ( get_schicht( )->get_parameter( )->get_data( )-auslastung_1 / 100 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_MET
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_VALUE                       TYPE        ZIA_2MET
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_MET
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_arbeitsstelle-zmet IS NOT INITIAL.

    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF @rs_value
      FROM zia_2met
      WHERE zid_met = @gs_arbeitsstelle-zmet.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_RJ_EST
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EST                         TYPE        ZIA_2_ROEHRE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_rj_est.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_RJ_EST
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lt_sp_schicht) =  go_schicht->get_sp_schicht( ).
    DATA(lt_as_sp)      =  get_sperrabschnitte( ).
    DATA(ls_as_sp)      = VALUE #( lt_as_sp[ 1 ] OPTIONAL ).

    IF ls_as_sp IS NOT INITIAL.
      DATA(ls_sp_schicht) = VALUE #( lt_sp_schicht[ sperras_id = ls_as_sp-sperras_id ] OPTIONAL ).
      rv_est = ls_sp_schicht-sperrabschnitt.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_KM_VON                      TYPE        ZIA_2_KM_VON
* | [--->] IV_KM_BIS                      TYPE        ZIA_2_KM_BIS
* | [--->] IT_ZEST                        TYPE        ANY TABLE
* | [<-()] RT_SA                          TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sa.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SA
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       29.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    SELECT * FROM zia_2sc AS sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
         WHERE sa~zzperi = @iv_perimeter
           AND km_von <= @iv_km_von
           AND km_bis >= @iv_km_bis
           AND sa~zest IN @it_zest.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SA_EXT_FOR_NEW_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [<-()] RT_SA                          TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sa_ext_for_new_auftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SA_EXT_FOR_NEW_AUFTRAG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lv_sa_km_von TYPE zia_2_km_von,
    ##NEEDED          lv_sa_km_bis TYPE zia_2_km_bis.

    ##NEEDED    DATA(ls_auftrag) = io_auftrag->get_data( ).


    "für den Auftrag sollen die Signalabschnitte ermittelt werden.
    "Der Auftrag kann mehrere Sperrabschnitte enthalten
    "Also muss für jeden Sperrabschnitt extra geschaut werden.

    APPEND LINES OF me->get_sa_for_new_auftrag( iv_rj_est = me->get_schicht( )->get_rj_est( )
                                                iv_ts_est = me->get_schicht( )->get_ts_est( )
                                                io_auftrag = io_auftrag ) TO rt_sa.

    DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).

    WHILE li_sp_km_i->has_next( ).
      DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( li_sp_km_i->get_next( ) ).
      APPEND LINES OF lo_sp_km->get_sa( ) TO rt_sa.
    ENDWHILE.


    SORT rt_sa BY zsa.
    DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.

    DATA(lv_peri) = io_auftrag->get_data( )-zzperi.
    "Welche Sperrabschnitte haben wir denn so.
    LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa>).

      AT NEW zest.
        DATA(lt_tmp_sa) = rt_sa.
        DELETE lt_tmp_sa WHERE zest <> <ls_sa>-zest.     "#EC CI_STDSEQ

        DATA(lv_sa_min) = lt_tmp_sa[ 1 ]-zsa.
        DATA(lv_sa_max) = lt_tmp_sa[ lines( lt_tmp_sa ) ]-zsa.

        SELECT * FROM zia_2sc
          APPENDING TABLE @DATA(lt_reloaded_sa)
          WHERE zzperi = @lv_peri
            AND zsa >= @lv_sa_min
            AND zsa <= @lv_sa_max
            AND zest = @<ls_sa>-zest.

      ENDAT.

    ENDLOOP.

    APPEND LINES OF lt_reloaded_sa TO rt_sa.
    SORT rt_sa BY zsa.
    DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
************
*     Hier sind dann die Lücken auf dem Einzelnen Intervallen geschlossen
**************


    DATA(lv_rj_sa_min) = 99999.
    DATA(lv_rj_sa_max) = 00000.
    "MIN MAX auf dem Regelintervall
    LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest = me->get_schicht( )->get_rj_est( ).
      lv_rj_sa_min = COND #( WHEN <ls_sa>-zsa < lv_rj_sa_min THEN <ls_sa>-zsa ELSE lv_rj_sa_min ).
      lv_rj_sa_max = COND #( WHEN <ls_sa>-zsa > lv_rj_sa_max THEN <ls_sa>-zsa ELSE lv_rj_sa_max ).
    ENDLOOP.


    CHECK me->is_in_tunnel( ) EQ abap_true.
    "Für jeden anderen RJ Sperrabschnitt müssen wir nun die Lücken Schliessen
    LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest <> me->get_schicht( )->get_rj_est( )
                                      AND zest <> me->get_schicht( )->get_ts_est( ).
      AT NEW zest.
        DATA(lv_osx_zest) = <ls_sa>-zest.

        DATA(lv_osx_sa_min) = 99999.
        DATA(lv_osx_sa_max) = 00000.
        LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa_osx>) WHERE zest = lv_osx_zest. "#EC CI_NESTED "#EC CI_STDSEQ
          lv_osx_sa_min = COND #( WHEN <ls_sa>-zsa < lv_osx_sa_min THEN <ls_sa>-zsa ELSE lv_osx_sa_min ).
          lv_osx_sa_max = COND #( WHEN <ls_sa>-zsa > lv_osx_sa_max THEN <ls_sa>-zsa ELSE lv_osx_sa_max ).
        ENDLOOP.

        DATA(lv_rj_est) = me->get_schicht( )->get_rj_est( ).

        IF ( gs_arbeitsstelle-zid_eiz = '10' AND lv_peri = 'GBT' ) OR
           ( gs_arbeitsstelle-zid_eiz = '20' AND lv_peri = 'CBT' ).
          "wir schauen richtung norden
          SELECT * FROM zia_2sc_seq
           APPENDING TABLE @DATA(lt_gaps_sa)
           WHERE (      zzperi = @lv_peri
                    AND sperrabschnitt = @lv_rj_est
                    AND signalabschnitt < @lv_rj_sa_min
                    AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) )
                  OR
                (       zzperi = @lv_peri
                    AND sperrabschnitt = @lv_osx_zest
                    AND signalabschnitt > @lv_osx_sa_max
                    AND ( s_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
        ELSE.
          "wir schauen richtung süden
          SELECT * FROM zia_2sc_seq
           APPENDING TABLE @lt_gaps_sa
           WHERE        zzperi = @lv_peri
                    AND (     sperrabschnitt = @lv_rj_est
                          AND signalabschnitt > @lv_rj_sa_min
                          AND ( s_sperrabschnitt = @lv_rj_est OR s_sperrabschnitt = @lv_osx_zest ) )
                    OR
                        (     sperrabschnitt = @lv_osx_zest
                          AND signalabschnitt < @lv_osx_sa_max
                          AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
        ENDIF.
      ENDAT.

    ENDLOOP.

    DATA: lt_sa TYPE RANGE OF zia_2_signal_section.
    IF lines( lt_gaps_sa ) > 0.
      LOOP AT lt_gaps_sa ASSIGNING FIELD-SYMBOL(<ls_gap_sa>).
        APPEND INITIAL LINE TO lt_sa ASSIGNING FIELD-SYMBOL(<ls_ra_sa>).
        <ls_ra_sa>-sign = 'I'.
        <ls_ra_sa>-option = 'EQ'.
        <ls_ra_sa>-low = <ls_gap_sa>-signalabschnitt.
      ENDLOOP.

      SELECT * FROM zia_2sc APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
        WHERE zzperi = @lv_peri
          AND zsa IN @lt_sa.

    ENDIF.

    SORT rt_sa BY zsa.
    DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SA_FOR_NEW_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RJ_EST                      TYPE        ZIA_2_BLOCKING_SECTION
* | [--->] IV_TS_EST                      TYPE        ZIA_2_BLOCKING_SECTION
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [<-()] RT_SA                          TYPE        ZIA_2_SGNL_SEC_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sa_for_new_auftrag.                          "#EC CI_CYCLO
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SA_FOR_NEW_AUFTRAG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lt_est TYPE RANGE OF zia_2_blocking_section.

    "*******************
    "* Ermittlung Signalabschnitte anhand vom Standortkennzeichen
    "***************
    DATA(lv_peri) = io_auftrag->get_data( )-zzperi.

    CASE io_auftrag->get_data( )-zstdkz.
      WHEN 'Q'.
        "*******************
        "* Aufträge mit Standortkennzeichen Q müssen anders behandelt werden.
        "*
        "* Wenn Intervallart TS am Auftrag ist, kann davon ausgegangen werden, dass es kein 'X' sondern genau E oder W
        "* Wenn Intervallart RJ am Auftrag ist, so wird der Auftrag nur in der RJ Röhe eingeplant. Es muss also das IV_RJ_EST übergeben werden,
        "* denn zum Planungszeitpunkt hat das Auftragsobjekt noch keine Arbeitsstelle und somit auch keine Schicht und daher auch kein RJ_EST
        "***************

*        CASE io_auftrag->get_data( )-zintervall.

        DATA(lt_tmp) = SWITCH #( io_auftrag->get_data( )-zintervall   WHEN 'TS' THEN io_auftrag->get_sp( )
                                WHEN 'JI' THEN  io_auftrag->get_sp( iv_rj_est )
                                WHEN 'LI' THEN io_auftrag->get_sp( iv_rj_est )                               ">001< INS
                                WHEN 'RI' THEN io_auftrag->get_sp( iv_rj_est )
                                ).                               ">001< INS
        ">001< INS
*         when others.
*        ENDCASE.

        LOOP AT lt_tmp ASSIGNING FIELD-SYMBOL(<ls_tmp>).
          APPEND INITIAL LINE TO lt_est ASSIGNING FIELD-SYMBOL(<ls_est>).
          <ls_est> = VALUE #( sign = 'I'
                              option = 'EQ'
                              low = <ls_tmp>-sperrabschnitt ).
        ENDLOOP.

        "Bei Sperrabschnitt W müssen die Auftragskilometer gemapt werden.
        READ TABLE lt_tmp WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
        DATA(lv_sperrabschnitt_w) = COND #( WHEN syst-subrc = 0 THEN abap_true ELSE abap_false ).

*        IF lv_sperrabschnitt_w EQ abap_true.
*          DATA(lv_zzkmvpl) = io_auftrag->get_km_west( )-zkmin.
*          DATA(lv_zzkmbpl) = io_auftrag->get_km_west( )-zkmax.
*        ELSE.
*          lv_zzkmvpl = io_auftrag->get_data( )-zzkmvpl.
*          lv_zzkmbpl = io_auftrag->get_data( )-zzkmbpl.
*        ENDIF.
        DATA(lv_zzkmvpl) = COND #( WHEN lv_sperrabschnitt_w EQ abap_true THEN io_auftrag->get_km_west( )-zkmin ELSE io_auftrag->get_data( )-zzkmvpl ).
        DATA(lv_zzkmbpl) = COND #( WHEN lv_sperrabschnitt_w EQ abap_true THEN io_auftrag->get_km_west( )-zkmax ELSE  io_auftrag->get_data( )-zzkmbpl ).
        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************

        SELECT * FROM zia_2sc AS sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lt_est.
        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zia_2sc AS sa INTO @DATA(ls_ausdehnung_q)
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lt_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung_q IS NOT INITIAL.

          DATA(ls_next_q) = COND #( WHEN ( ls_ausdehnung_q-max - io_auftrag->gv_signal_km_abweich ) <= lv_zzkmbpl
 ##OPERATOR[RT_SA]
                       THEN  zcl_ia_2utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung_q-max ]  ) ).

          DATA(ls_prev_q) = COND #( WHEN  ( ls_ausdehnung_q-min + io_auftrag->gv_signal_km_abweich ) >= lv_zzkmvpl
 ##OPERATOR[RT_SA]
           THEN zcl_ia_2utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung_q-min ] ) ).

        ENDIF.
      WHEN 'M'.
        lt_tmp = SWITCH #( io_auftrag->get_data( )-zintervall
                               WHEN 'TS' THEN io_auftrag->get_sp( )
                               WHEN 'JI' THEN io_auftrag->get_sp( iv_rj_est )
                               WHEN 'LI' THEN io_auftrag->get_sp( iv_rj_est )
                               WHEN 'RI' THEN io_auftrag->get_sp( iv_rj_est ) ).       ">001< INS
*          WHEN OTHERS.
*        ENDCASE.

        LOOP AT lt_tmp ASSIGNING <ls_tmp>.
          APPEND INITIAL LINE TO lt_est ASSIGNING <ls_est>.
          <ls_est> = VALUE #( sign = 'I'
                              option = 'EQ'
                              low = <ls_tmp>-sperrabschnitt ).
        ENDLOOP.

        DATA(lv_mfs) = io_auftrag->get_data( )-zdidok.
        DATA(lv_km) = io_auftrag->get_data( )-zzkmvpl.

        SELECT SINGLE * FROM zia_2mfs INTO @DATA(ls_mfs)    ##WARN_OK
          WHERE zmfs EQ @lv_mfs
            AND zkm_mfs_von <= @lv_km AND zkm_mfs_bis >= @lv_km.

        lv_zzkmvpl = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).
        lv_zzkmbpl = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).

        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************
        SELECT * FROM zia_2sc AS sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lt_est.
        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zia_2sc AS sa INTO @ls_ausdehnung_q
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lt_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung_q IS NOT INITIAL.
          ls_next_q = COND #( WHEN ( ls_ausdehnung_q-max - io_auftrag->gv_signal_km_abweich ) <= lv_zzkmbpl
 ##OPERATOR[RT_SA]
                 THEN  zcl_ia_2utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung_q-max ] ) ).

          ls_prev_q = COND #( WHEN ( ls_ausdehnung_q-min + io_auftrag->gv_signal_km_abweich ) >= lv_zzkmvpl THEN
           ##OPERATOR[RT_SA]
          zcl_ia_2utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung_q-min ] ) ).
        ENDIF.

      WHEN OTHERS.
        "*******************
        "* Ermittlung Sperrabschnitte vom Auftrag
        "***************
        lt_tmp = io_auftrag->get_sp( ).
        LOOP AT lt_tmp ASSIGNING <ls_tmp>.
          APPEND INITIAL LINE TO lt_est ASSIGNING <ls_est>.
          <ls_est> = VALUE #( sign = 'I'
                              option = 'EQ'
                              low = <ls_tmp>-sperrabschnitt ).
        ENDLOOP.

        lv_zzkmvpl = io_auftrag->get_data( )-zzkmvpl.
        lv_zzkmbpl = io_auftrag->get_data( )-zzkmbpl.

        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************
        SELECT * FROM zia_2sc AS sa INTO CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lt_est.

        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zia_2sc AS sa INTO @DATA(ls_ausdehnung)
                 WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
                   AND sa~zest IN @lt_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung IS NOT INITIAL.
          DATA(ls_next) = COND #( WHEN ( ls_ausdehnung-max - io_auftrag->gv_signal_km_abweich ) <= lv_zzkmvpl THEN
 ##OPERATOR[RT_SA]
          zcl_ia_2utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung-max ]  ) ).

          DATA(ls_prev) = COND #( WHEN ( ls_ausdehnung-min + io_auftrag->gv_signal_km_abweich ) >= lv_zzkmvpl THEN
 ##OPERATOR[RT_SA]
          zcl_ia_2utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung-min ]  ) ).

        ENDIF.
    ENDCASE.


    IF ls_next IS NOT INITIAL. APPEND ls_next TO rt_sa. ENDIF.
    IF ls_prev IS NOT INITIAL. APPEND ls_prev TO rt_sa. ENDIF.
    IF ls_next_q IS NOT INITIAL. APPEND ls_next_q TO rt_sa. ENDIF.
    IF ls_prev_q IS NOT INITIAL. APPEND ls_prev_q TO rt_sa. ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_SP_ZEITEN_TAB
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TT_SP_ZEITEN_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten_tab.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SP_ZEITEN_TAB
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_sp_zeit       TYPE REF TO zcl_ia_2restr_asso_tims.


    DATA(lt_sp_schicht) = me->go_schicht->get_sp_schicht( ).

    LOOP AT me->gt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

      lo_sp_zeit ?= me->go_sp_zeiten->get( key = <ls_map_as_szg>-sperras_id ).
      CHECK lo_sp_zeit IS BOUND.

      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) "#EC CI_STDSEQ
                                 WITH KEY sperras_id = <ls_map_as_szg>-sperras_id.

      IF sy-subrc = 0.
        APPEND INITIAL LINE TO rt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
        <ls_data>-sperras_id     = <ls_sp_schicht>-sperras_id.
        <ls_data>-sperrabschnitt = <ls_sp_schicht>-sperrabschnitt.
        <ls_data>-zintervallart  = <ls_sp_schicht>-zintervallart.
        <ls_data>-start_datum    = lo_sp_zeit->get_data( )-start_datum.
        <ls_data>-start_zeit     = lo_sp_zeit->get_data( )-start_zeit.
        <ls_data>-end_datum      = lo_sp_zeit->get_data( )-end_datum.
        <ls_data>-end_zeit       = lo_sp_zeit->get_data( )-end_zeit.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->REMOVE_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD remove_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_SP
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
   me->go_sp_kilometer->remove( key = iv_sperras_id ).
   DELETE me->gt_map_as_szg WHERE sperras_id =  iv_sperras_id.
   DELETE FROM zia_2bs_km WHERE zarbstl = me->gs_arbeitsstelle-zarbstl AND sperras_id = iv_sperras_id.
   DELETE FROM zia_2map_as_szg WHERE zarbstl = me->gs_arbeitsstelle-zarbstl AND sperras_id = iv_sperras_id.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_INITAL_AUSDEHNUNG_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD set_inital_ausdehnung_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_INITAL_AUSDEHNUNG_SP
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       24.12.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
   DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.
   ##NEEDED   DATA(li_sp_km_i) = go_sp_kilometer->get_values_iterator( ).

   lo_sp_km ?= go_sp_kilometer->get( key = iv_sperras_id ).
   IF lo_sp_km IS NOT INITIAL.
     IF lo_sp_km->get_data( )-sperras_id EQ iv_sperras_id.

       DATA(lv_sp) = lo_sp_km->get_sp( ).

       lo_sp_km->set_zkmin( io_auftrag->get_km_by_est( lv_sp )-zkmin ).
       lo_sp_km->set_zkmax( io_auftrag->get_km_by_est( lv_sp )-zkmax ).

     ENDIF.
   ENDIF.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_TREMOLA_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_tremola_calc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_TREMOLA_CALC
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       29.12.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_arbeitsstelle-tremola_calc = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_KM_MIN_MAX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MFS                         TYPE        ZIA_2_DIDOK
* | [--->] IV_KM                          TYPE        ZIA_2_KM_BIS
* | [--->] IV_RJ_EST                      TYPE        ZIA_2_BLOCKING_SECTION
* | [<---] EV_KMIN                        TYPE        ZIA_2_KM_MET
* | [<---] EV_KMAX                        TYPE        ZIA_2_KM_MET
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_km_min_max.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_KM_MIN_MAX
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       01.01.2026    tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  SELECT SINGLE * FROM zia_2mfs INTO @DATA(ls_mfs)   ##WARN_OK
           WHERE zmfs EQ @iv_mfs
             AND zkm_mfs_von <= @iv_km AND zkm_mfs_bis >= @iv_km.

  ev_kmin = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).
  ev_kmax = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->FUELLE_ARBEITSORT_NEW
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fuelle_arbeitsort_new.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       11.09.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       16.10.2026        TCS / Venkateswarlu Batta
*         Added parameter
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lt_auftraege   TYPE zia_2order_t,
              lt_auftraege_p TYPE zia_2_order_planning_t.

    DATA(lo_auftrag_arbeitsort) = NEW zcl_ia_2order( iv_aufnr = is_auftrag-aufnr ).
    DATA(ls_ausdehnung_arbeitsort) = lo_auftrag_arbeitsort->get_km_by_est( iv_est = me->get_schicht( )->get_rj_est( ) ).

    LOOP AT me->gt_auftraege_planung INTO DATA(ls_auftrag).

      "um diese Kilometerierung herum werden die Aufträge gesucht.

      ##NEEDED      DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).
      DATA(ls_ausdehnung_auftrag) = lo_auftrag_arbeitsort->get_km_by_est( iv_est = me->get_schicht( )->get_rj_est( ) ).

      CHECK ls_ausdehnung_auftrag-zkmin >= ls_ausdehnung_arbeitsort-zkmin AND ls_ausdehnung_auftrag-zkmax <= ls_ausdehnung_arbeitsort-zkmax.
      APPEND INITIAL LINE TO lt_auftraege_p ASSIGNING FIELD-SYMBOL(<ls_auftrag_p>).
      MOVE-CORRESPONDING ls_auftrag TO <ls_auftrag_p>.

      IF ls_ausdehnung_auftrag-zkmin < ls_ausdehnung_arbeitsort-zkmin.
        <ls_auftrag_p>-zdistanz = ls_ausdehnung_arbeitsort-zkmin - ls_ausdehnung_auftrag-zkmin.
      ELSE.
        <ls_auftrag_p>-zdistanz = ls_ausdehnung_auftrag-zkmin - ls_ausdehnung_arbeitsort-zkmin.
      ENDIF.


    ENDLOOP.

    " Aufträge nach distanz sortieren
    SORT lt_auftraege_p BY zdistanz.

    " Aufträge zum Arbeitsort hinzufügen
    LOOP AT lt_auftraege_p ASSIGNING <ls_auftrag_p>.
      MOVE-CORRESPONDING <ls_auftrag_p> TO ls_auftrag.
      TRY .
          me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true iv_planned_ord_capacity = abap_true ).  ">001<
          DELETE me->gt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr. "#EC CI_STDSEQ
        ##NO_HANDLER        CATCH zcx_ia_2failure.
      ENDTRY.

      CLEAR: ls_auftrag.
    ENDLOOP.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->FUELLE_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MAX_AUSLASTUNG              TYPE        ZIA_2_AUSLASTUNG
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD fuelle_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       11.09.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       16.10.2026        TCS / Venkateswarlu Batta
*         Added parameter
*----------------------------------------------------------------------*
  me->gt_auftraege_planung =  me->get_auftraege_planung( ).

**********************************************************************************************************
* Fülle Arbeitsstellen mit Aufträgen
**********************************************************************************************************
  IF me->get_auftrag( iv_index = 1 ) IS NOT INITIAL. ">001< INS LINE
    IF me->get_auftrag( iv_index = 1 )->get_data( )-zstdkz = 'Q' OR me->get_auftrag( iv_index = 1 )->get_data( )-zstdkz = 'M'.
      "Arbeitsort von erstem Auftrag auffüllen
      me->fuelle_arbeitsort_new( is_auftrag = me->get_auftrag( EXPORTING iv_index = 1 )->get_data( ) ).
    ENDIF.
  ENDIF.                                             ">001< INS LINE

  " Arbeitsstelle vollends befüllen
  LOOP AT me->gt_auftraege_planung INTO DATA(ls_auftrag).
    TRY .
        me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true  iv_planned_ord_capacity = abap_true ). ">001<
        IF ls_auftrag-zstdkz = 'Q' OR ls_auftrag-zstdkz = 'M'.

          "Arbeitsort auffüllen
          me->fuelle_arbeitsort_new( is_auftrag = ls_auftrag ).
        ENDIF.
        DELETE me->gt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr. "#EC CI_STDSEQ
      ##NO_HANDLER      CATCH zcx_ia_2failure.
    ENDTRY.
  ENDLOOP.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_AUFTRAEGE_PLANUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KM_MIN                      TYPE        ZIA_2_KM(optional)
* | [--->] IV_KM_MAX                      TYPE        ZIA_2_KM(optional)
* | [<-()] RT_AUFTRAEGE                   TYPE        ZIA_2ORDER_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_auftraege_planung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       11.09.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
***********************************************************************************************************
   DATA: lt_auftraege TYPE zia_2order_t,
         ls_auftrag   TYPE zia_2order,
##NEEDED         lt_ra_est    TYPE zia_2range_string_t,
##NEEDED         lt_ra_eiz    TYPE zia_2range_string_t.


   ##NEEDED   DATA(lo_schichtparameter) = NEW zcl_ia_2parameter( iv_schicht   = me->gs_arbeitsstelle-zschicht ).

   ##NEEDED   DATA(ls_intervall) = me->get_schicht( )->get_planungsintervall( ).
   ##NEEDED   DATA(lv_schicht) = me->go_schicht->get_data( )-zschicht.
   DATA(lv_id_eiz) = me->gs_arbeitsstelle-zid_eiz.
   DATA(lv_perimeter) = me->go_schicht->get_data( )-zzperi.

   SELECT auftr~*
   FROM viqmel AS s
            INNER JOIN zia_2order AS auftr ON s~qmcod = auftr~zzperi
*                                            AND s~aufnr = auftr~aufnr
                                         AND (   s~strmn BETWEEN auftr~gstrp AND auftr~gltrp
                                              OR s~ltrmn BETWEEN auftr~gstrp AND auftr~gltrp )
          INNER JOIN eaml_d_lfe_data AS sp ON sp~tabkey = auftr~aufnr
                                            "AND ( sp~sperrabschnitt = 'E' OR sp~sperrabschnitt = 'X' )
*   WHERE s~qmnum = @me->gs_schicht-zschicht
   WHERE s~qmnum = @lv_schicht
     AND ( auftr~zstdkz <> 'G' AND auftr~zstdkz <> 'O' )
     AND auftr~zzzugangsart = '1'
     AND ( auftr~zid_eiz = @lv_id_eiz OR auftr~zid_eiz = 0 )
     AND auftr~zzperi = @lv_perimeter
     AND auftr~zschicht = 0
     AND auftr~zarbstl = 0
     AND auftr~zintervall <> 'TS'
     AND auftr~zintervall <> 'LI'  ">001< (+)
   ORDER BY zpprio ASCENDING
   INTO TABLE @lt_auftraege.

   DATA(lt_sp_schicht) =  me->go_schicht->get_sp_schicht( ).
   DELETE lt_sp_schicht WHERE zintervallart = 'TS'.
   LOOP AT lt_auftraege INTO ls_auftrag.
     ##NEEDED     DATA(lv_sp_not_found) = abap_false.
     DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).

     LOOP AT lo_auftrag->get_sp( iv_rj_est = me->go_schicht->get_rj_est( ) ) ASSIGNING FIELD-SYMBOL(<ls_sp>). "#EC CI_NESTED
       READ TABLE lt_sp_schicht WITH KEY sperrabschnitt = <ls_sp>-sperrabschnitt TRANSPORTING NO FIELDS. "#EC CI_STDSEQ
       IF syst-subrc NE 0. DELETE lt_auftraege WHERE aufnr = ls_auftrag-aufnr. EXIT. ENDIF. "#EC CI_STDSEQ
     ENDLOOP.
   ENDLOOP.
   DATA: lv_max_sa TYPE i,
         lt_sa     TYPE STANDARD TABLE OF zia_2sc,
         ls_sa     TYPE zia_2sc,
         lv_km     TYPE zia_2_km,
         lv_km_von TYPE zia_2_km,
         lv_km_bis TYPE zia_2_km,
         lv_index  TYPE i,
         lv_lines  TYPE i.
   IF iv_km_min IS NOT INITIAL OR iv_km_max IS NOT INITIAL.
     lv_km_von = iv_km_min.
     lv_km_bis = iv_km_max.
   ELSE.
     lv_max_sa = me->get_schicht( )->get_parameter( )->get_data( )-max_ausdehnung.
     DATA(lv_est) = me->go_schicht->get_rj_est( ).

     SELECT *
       FROM zia_2sc
       INTO TABLE @lt_sa
       WHERE zest = @lv_est.

     SORT lt_sa BY km_von.
     lv_lines = lines( lt_sa ).

     LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmin
                                AND km_bis >= me->get_data( )-zkmin.
       lv_index = sy-tabix + lv_max_sa.
       IF lv_index > lv_lines.
         lv_index = lv_lines.
       ENDIF.
       READ TABLE lt_sa INDEX lv_index INTO ls_sa.
       lv_km_bis = ls_sa-km_bis.
     ENDLOOP.

     LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmax
                                AND km_bis >= me->get_data( )-zkmax.
       lv_index = sy-tabix - lv_max_sa.
       IF lv_index < 0.
         lv_index = 0.
       ENDIF.
       READ TABLE lt_sa INDEX lv_index INTO ls_sa.
       lv_km_von = ls_sa-km_von.
     ENDLOOP.
   ENDIF.
   LOOP AT lt_auftraege ASSIGNING FIELD-SYMBOL(<ls_auftrag>).
     CASE <ls_auftrag>-zstdkz.
       WHEN 'S'.
         DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
       WHEN 'Q'.
         IF me->go_schicht->get_rj_est( ) = mc_sperrabs-w
         OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w1
         OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w2
         OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w3.
           SELECT SINGLE zkm_w   ##WARN_OK
             FROM zia_2lateral_tb
             INTO @lv_km
             WHERE zkm_e = @<ls_auftrag>-zzkmvpl
               AND zzperi = @<ls_auftrag>-zzperi.
         ELSE.
           lv_km = <ls_auftrag>-zzkmvpl.
         ENDIF.

         IF lv_km NOT BETWEEN lv_km_von AND lv_km_bis.
           DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
         ENDIF.
       WHEN 'T'.
         IF <ls_auftrag>-zzkmvpl NOT BETWEEN lv_km_von AND lv_km_bis
         OR <ls_auftrag>-zzkmbpl NOT BETWEEN lv_km_von AND lv_km_bis.
           DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
         ENDIF.
     ENDCASE.
   ENDLOOP.
   rt_auftraege = lt_auftraege.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_BASIS_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FZG_VORHANDEN               TYPE        BOOLEAN
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN
* | [<---] EO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_basis_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_fzg_vorhanden = abap_false.
      zcl_ia_2rules=>get_basis_fahrzeug(
        EXPORTING
          io_arbeitsstelle = io_arbeitsstelle
          iv_ignore_errors = abap_true
          io_auftrag = io_auftrag
        IMPORTING
          eo_fahrzeuge = DATA(lo_basis_fzg)
      ).
      me->add_fahrzeuge(
        EXPORTING
          io_objects = lo_basis_fzg
          iv_vorschau = iv_vorschau
      ).

      eo_fahrzeuge = lo_basis_fzg.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ADD_FAHRZEUGE_AND_ORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN
* | [--->] IT_EINZELKAPAS                 TYPE        ZIA_2EINZELKAPAS_T
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [<---] EO_FAHRZEUGE_I                 TYPE REF TO CL_OBJECT_COLLECTION_ITERATOR
* | [<---] EO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* | [<---] EO_SITZPLATZ                   TYPE REF TO ZCL_IA_2SEAT
* | [<-()] RX_FEHLER                      TYPE REF TO ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeuge_and_order.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA : ls_einzelkapa  TYPE zia_2order_cap,
           ls_auftrag     TYPE zia_2order,
           lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
           lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle,
           lo_sitzplatz   TYPE REF TO zcl_ia_2seat.


    IF io_fahrzeuge IS NOT INITIAL.
      me->add_fahrzeuge( io_objects = io_fahrzeuge ).
    ENDIF.

    " Auftrag hinzufügen
    me->go_orders->put( EXPORTING key = io_auftrag->get_data( )-aufnr   value = io_auftrag ).
    io_auftrag->set_schicht( iv_schicht = me->gs_arbeitsstelle-zschicht ).
    io_auftrag->set_arbeitsstelle_id( iv_arbstl = me->gs_arbeitsstelle-zarbstl ).
*      lo_auftrag->set_arbstl_ri( iv_arbstl = me->ms_arbeitsstelle-zarbstl_ref ). ">001< INS LINE
    io_auftrag->set_vorschau_flag( iv_vorschau = iv_vorschau ).

    " Arbstellen-Ausdehnung updaten
    IF iv_vorschau = abap_false.
      me->refresh_ausdehung( ).
    ENDIF.

    " EIZ + EST in Arbstelle updaten
    me->refresh_eiz_est( is_auftrag = ls_auftrag ).

    " Einzelkapas hinzufügen
    LOOP AT it_einzelkapas INTO ls_einzelkapa.
      " Durchlaufe alle Fahrzeuge
      lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        "Pneu Auftrag und das aktuelle Fahrzeug ist kein Pneufahrzeug => CONTINUE
        IF ls_auftrag-zzzugangsart = zcl_ia_2order=>mc_zgart_pneu AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_false.
          CONTINUE.
        ENDIF.
        "Schienenauftrag und das aktuelle Fahrzeug ist ein Pneufahrzeug => CONTINUE
        IF ls_auftrag-zzzugangsart = zcl_ia_2order=>mc_zgart_schiene AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true.
          CONTINUE.
        ENDIF.

        lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
        CHECK lo_sitzplatz IS NOT INITIAL.

        TRY.
            IF lo_sitzplatz->has_quali( ) = abap_false AND io_auftrag->get_vorschau_flag( ) = abap_true.
              lo_sitzplatz->set_vorschau_flag( iv_vorschau = abap_true ).
            ENDIF.

            lo_sitzplatz->add_einzelkapazitaet_o( EXPORTING iv_ignore_errors = iv_ignore_errors   io_einzelkapa = io_auftrag->get_einzelkapazitaet_o( iv_id_ek = ls_einzelkapa-zid_ek )  ).
          ##NO_HANDLER          CATCH zcx_ia_2failure INTO rx_fehler.
        ENDTRY.
        io_auftrag->get_einzelkapazitaet_o( iv_id_ek = ls_einzelkapa-zid_ek )->set_error_flag( iv_flag = ls_einzelkapa-error_flag ).
      ENDWHILE.
    ENDLOOP.

    eo_fahrzeuge_i = lo_fahrzeuge_i.
    eo_fahrzeug    = lo_fahrzeug.
    eo_sitzplatz   = lo_sitzplatz.
*****************************************************************************************************************************************
    DATA(lt_messages) = zcl_ia_2message_manager=>get_instance( )->get_messages( ).

    ##WARN_OK    READ TABLE lt_messages WITH KEY number = 100 type = 'W' TRANSPORTING NO FIELDS.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->ADJUST_KM_FOR_SPERRABSCHNITT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* | [<-->] CV_KM                          TYPE        ZIA_2_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD adjust_km_for_sperrabschnitt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : ADJUST_KM_FOR_SPERRABSCHNITT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2026     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_perimeter) = go_schicht->get_data( )-zzperi.

    TRY .
        DATA(lv_min_km) = mt_min_km[ perimeter      = lv_perimeter
                                     sperrabschnitt = iv_sperrabschnitt ]-min_km.
      ##NO_HANDLER      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    IF cv_km < lv_min_km.
      cv_km = lv_min_km.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->CALCULATE_AS_TIME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BETRIEBSPUNKT               TYPE        ZIA_2_BETRIEBSPUNKT
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* | [--->] IV_INTERVALLART                TYPE        ZIA_2_INTERVALLART(optional)
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [<-->] CV_DATE                        TYPE        DATS
* | [<-->] CV_TIME                        TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_as_time.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : CALCULATE_AS_TIME
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2026     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lv_km_von) = get_km_von_for_calc( iv_betriebspunkt  = iv_betriebspunkt
                                           iv_sperrabschnitt = iv_sperrabschnitt
                                           iv_richtung       = iv_richtung ).
    adjust_km_for_sperrabschnitt( EXPORTING iv_sperrabschnitt = iv_sperrabschnitt
                                  CHANGING  cv_km             = lv_km_von ).

    DATA(lv_km_bis) = get_km_bis_for_calc( iv_richtung = iv_richtung ).
    adjust_km_for_sperrabschnitt( EXPORTING iv_sperrabschnitt = iv_sperrabschnitt
                                  CHANGING  cv_km             = lv_km_bis ).

    DATA(lv_min_km) = get_min_km_for_calc( iv_richtung = iv_richtung ).

    DATA(lv_sec_km) = CONV i( lv_min_km * 60 ).

    DATA(lv_km_diff) = CONV zia_2_km( lv_km_bis - lv_km_von ).

    DATA(lv_sec) = CONV i( lv_km_diff * lv_sec_km ).

    lv_sec = COND #( WHEN iv_richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt THEN - lv_sec ELSE lv_sec ).

    TRY.
        cl_abap_tstmp=>td_add( EXPORTING date     = cv_date
                                         time     = cv_time
                                         secs     = lv_sec
                               IMPORTING res_date = cv_date
                                         res_time = cv_time ).
        zcl_ia_2utilities2=>round_date_time_to_minute( CHANGING cv_date = cv_date
                                                                cv_time = cv_time ).

      ##NO_HANDLER      CATCH cx_parameter_invalid_type cx_parameter_invalid_range.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->CALCULATE_AS_TIMES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* | [--->] IS_INNER_SP_ZEITEN             TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_as_times.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : CALCULATE_AS_TIMES
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lv_sperrabschnitt) = CONV zia_2_spabs( go_schicht->get_rj_est( ) ).
    ##NEEDED    DATA(lv_date)           = go_schicht->get_data( )-start_datum.
    DATA(lt_map_spabs)      = get_sperrabschnitte( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ).
    DATA(lt_sp_schicht)    = go_schicht->get_sp_schicht( ).

    DATA(li_sp_zeiten_i) = go_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_ia_2restr_asso_tims( li_sp_zeiten_i->get_next( ) ).
      DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).

      ASSIGN lt_map_spabs[ sperras_id = ls_sp_zeiten-sperras_id ] TO FIELD-SYMBOL(<ls_map_spabs>).
      CHECK sy-subrc = 0.

      ASSIGN lt_sp_schicht[ sperras_id = <ls_map_spabs>-sperras_id ] TO FIELD-SYMBOL(<ls_sp_schicht>).
      CHECK sy-subrc = 0.

      "<-------- TS -------
      IF <ls_sp_schicht>-zintervallart = zcl_ia_2utilities=>mc_intervart_sp_ts.  "Set initial date (sp_schicht table)
        ls_sp_zeiten-start_datum = <ls_sp_schicht>-start_datum.
        ls_sp_zeiten-start_zeit  = <ls_sp_schicht>-start_zeit.
        ls_sp_zeiten-end_datum   = <ls_sp_schicht>-end_datum.
        ls_sp_zeiten-end_zeit    = <ls_sp_schicht>-end_zeit.
        lo_sp_zeiten->update_data( is_data = ls_sp_zeiten ).
        CONTINUE.
      ENDIF.

      DATA(lv_betriebspunkt) = CONV zia_2_betriebspunkt( '' ).

      "<-------- EINFAHRT -------
      IF line_exists( it_ez_form[ zarbstl = gs_arbeitsstelle-zarbstl richtung = 'E' ez_aktiv = abap_true ] ).
        get_trasse_data_for_ez_form( EXPORTING it_ez_form       = it_ez_form
                                               iv_richtung      = zif_ia_2_trasse=>mc_richtung_einfahrt
                                     IMPORTING ev_betriebspunkt = lv_betriebspunkt
                                               ev_date          = ls_sp_zeiten-start_datum
                                               ev_time          = ls_sp_zeiten-start_zeit ).

        calculate_as_time( EXPORTING iv_betriebspunkt  = lv_betriebspunkt
                                     iv_sperrabschnitt = lv_sperrabschnitt
                                     iv_richtung       = zif_ia_2_trasse=>mc_richtung_einfahrt
                           CHANGING  cv_date           = ls_sp_zeiten-start_datum
                                     cv_time           = ls_sp_zeiten-start_zeit ).
      ELSE.
        ls_sp_zeiten-start_datum = <ls_sp_schicht>-start_datum.
        ls_sp_zeiten-start_zeit  = <ls_sp_schicht>-start_zeit.
      ENDIF.

      "<-------- AUSFAHRT -------
      IF line_exists( it_ez_form[ zarbstl = gs_arbeitsstelle-zarbstl richtung = 'A' ez_aktiv = abap_true ] ).
        get_trasse_data_for_ez_form( EXPORTING it_ez_form       = it_ez_form
                                               iv_richtung      = zif_ia_2_trasse=>mc_richtung_ausfahrt
                                     IMPORTING ev_betriebspunkt = lv_betriebspunkt
                                               ev_date          = ls_sp_zeiten-end_datum
                                               ev_time          = ls_sp_zeiten-end_zeit ).

        IF is_inner_sp_zeiten-zarbstl IS NOT INITIAL.
          ls_sp_zeiten-end_datum = is_inner_sp_zeiten-end_datum.
          ls_sp_zeiten-end_zeit  = is_inner_sp_zeiten-end_zeit.
        ENDIF.

        calculate_as_time( EXPORTING iv_betriebspunkt  = lv_betriebspunkt
                                     iv_sperrabschnitt = lv_sperrabschnitt
                                     iv_richtung       = zif_ia_2_trasse=>mc_richtung_ausfahrt
                           CHANGING  cv_date           = ls_sp_zeiten-end_datum
                                     cv_time           = ls_sp_zeiten-end_zeit ).
      ELSE.
        ls_sp_zeiten-end_datum   = <ls_sp_schicht>-end_datum.
        ls_sp_zeiten-end_zeit    = <ls_sp_schicht>-end_zeit.
      ENDIF.

      lo_sp_zeiten->update_data( is_data = ls_sp_zeiten ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CHECK_EINZELKAPAS_VALIDITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN
* | [--->] IV_PLANNED_ORD_CAPACITY        TYPE        BOOLEAN(optional)
* | [<---] EV_CRITICAL_ERROR              TYPE        BOOLEAN
* | [<---] ET_EINZELKAPAS                 TYPE        ZIA_2_ORDER_CAP_T
* | [<---] EV_SUCCESS                     TYPE        BOOLEAN
* | [<---] EV_HAS_ERRORS                  TYPE        BOOLEAN
* | [<-()] RV_IS_VALID                    TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_einzelkapas_validity.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       16.10.2026        TCS / Venkateswarlu Batta
*         Added parameter
*----------------------------------------------------------------------*

    rv_is_valid = zcl_ia_2rules=>check_auf_einzelkapas(
      EXPORTING
        is_auftrag = is_auftrag
        io_arbeitsstelle = io_arbeitsstelle
        iv_ignore_errors = iv_ignore_errors
        iv_planned_ord_capacity = iv_planned_ord_capacity ">001<
      IMPORTING
        et_einzelkapas = et_einzelkapas
        ev_critical_error = ev_critical_error
    ).

    IF ev_critical_error = abap_true.
      ev_success = abap_false.
      refresh_sa_sp( ).
      RETURN.
    ENDIF.

    IF rv_is_valid = abap_false AND iv_auto_planning = abap_true.
      IF iv_auto_planning = abap_true.
        refresh_sa_sp( ).
        RETURN.
      ELSE.
        ev_has_errors = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CLEAR_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CALLED_FROM                 TYPE        ZIA_2_TREMOLA_CALLED_FROM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD clear_zugnummer.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : CLEAR_ZUGNUMMER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CLEAR gs_arbeitsstelle-zid_zug.

    update_zugnummer( ).
    IF iv_called_from = 'POPUP_INIT'.   ">001< +
      update_zeiten_from_spabsid( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->DELETE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : DELETE_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_ez_form_db) = me->get_ez_form_db( ).
    LOOP AT lt_ez_form_db ASSIGNING FIELD-SYMBOL(<ls_ez_form_db>).
      "WHERE data_origin NE zif_io_5_constant=>mc_data_origin-tremola. "Change >001<  "Non-Tremola Entries = REAL/Manually Added ">003< -

      CHECK line_exists( it_ez_form[ zid_eiz     = <ls_ez_form_db>-zid_eiz
                                     richtung    = <ls_ez_form_db>-richtung
                                     data_origin = <ls_ez_form_db>-data_origin
                                     has_changed = abap_true
                                     ez_aktiv    = abap_false ] ) .  "check if the manual change was withdrawn

      DELETE FROM zia_2sf_ez_form
        WHERE zschicht    = @gs_arbeitsstelle-zschicht
          AND zarbstl     = @gs_arbeitsstelle-zarbstl
          AND zid_eiz     = @gs_arbeitsstelle-zid_eiz
          AND richtung    = @<ls_ez_form_db>-richtung
          AND data_origin = @<ls_ez_form_db>-data_origin.  "do not remove tremola   "#EC CI_IMUD_NESTED

    ENDLOOP.
    ">002< + begin
    DATA(lv_richtung) = COND #( WHEN go_schicht->is_versorgung_schicht( ) THEN zif_ia_2_constant=>mc_richtung-ausfahrt
                                WHEN go_schicht->is_entsorgung_schicht( ) THEN zif_ia_2_constant=>mc_richtung-einfahrt ).
    IF lv_richtung IS NOT INITIAL.
      DELETE FROM zia_2sf_ez_form
       WHERE zschicht    = @gs_arbeitsstelle-zschicht
         AND zarbstl     = @gs_arbeitsstelle-zarbstl
         AND zid_eiz     = @gs_arbeitsstelle-zid_eiz
         AND richtung    = @lv_richtung.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->DETERMINE_ORDER_VEHICLES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IV_VORSCHAU                    TYPE        ZIA_2_VORSCHAU
* | [--->] IV_ZZZUGANGSART                TYPE        ZIA_2_ACCESSTYP
* | [--->] IV_PLANUNG_OS                  TYPE        BOOLEAN
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN
* | [<---] EO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* | [<---] EV_HAS_ERRORS                  TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD determine_order_vehicles.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_zzzugangsart = 1."*    IF me->is_schiene( ) EQ abap_true.
      IF zcl_ia_2rules=>get_fahrzeuge( EXPORTING   io_arbeitsstelle = io_arbeitsstelle
                                                   iv_vorschau = iv_vorschau
                                                   io_auftrag = io_auftrag
                                                   iv_ignore_errors = iv_ignore_errors
                                         IMPORTING eo_fahrzeuge = eo_fahrzeuge ) = abap_false
                                                            AND iv_ignore_errors = abap_false
                                                            AND iv_planung_os    = abap_false.
        IF iv_auto_planning = abap_true.
          refresh_sa_sp( ).
          RETURN.
        ELSE.
          ev_has_errors = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->ENSURE_MATCHING_VEHICLE_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [<---] EO_FAHRZEUGE_I                 TYPE REF TO CL_OBJECT_COLLECTION_ITERATOR
* | [<---] EO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* | [<---] EV_FZG_VORHANDEN               TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ensure_matching_vehicle_exists.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.
    DATA(lv_fzg_vorhanden) = abap_false.

    lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      CASE is_auftrag-zzzugangsart.
        WHEN zcl_ia_2order=>mc_zgart_schiene.
          IF lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_false.
            lv_fzg_vorhanden = abap_true.
          ELSE.
            CONTINUE.
          ENDIF.
        WHEN zcl_ia_2order=>mc_zgart_pneu.
          IF lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true.
            lv_fzg_vorhanden = abap_true.
          ELSE.
            CONTINUE.
          ENDIF.
      ENDCASE.

    ENDWHILE.

    eo_fahrzeug = lo_fahrzeug.
    eo_fahrzeuge_i = lo_fahrzeuge_i.
    ev_fzg_vorhanden = lv_fzg_vorhanden.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_EZ_FORM_DB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NEW                         TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RT_DATA                        TYPE        ZIA_2_EZ_FRM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form_db.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :GET_EZ_FORM_DB
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_new = abap_false.
      rt_data = gt_ez_form_db.
      RETURN.
    ENDIF.

    DATA(lv_zschicht) = go_schicht->get_id( ).
    SELECT zschicht, zugnummer, zarbstl, zid_eiz, richtung, data_origin, ez_aktiv
      INTO CORRESPONDING FIELDS OF TABLE @gt_ez_form_db      ##TOO_MANY_ITAB_FIELDS
      FROM zia_2sf_ez_form
      WHERE zschicht = @lv_zschicht
        AND zarbstl  = @gs_arbeitsstelle-zarbstl.
    IF sy-subrc = 0.
      SORT gt_ez_form_db BY zschicht zugnummer zarbstl zid_eiz richtung data_origin.
      DELETE ADJACENT DUPLICATES FROM gt_ez_form_db COMPARING zschicht zugnummer zarbstl zid_eiz richtung.
      rt_data = gt_ez_form_db.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_KM_BIS_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIA_2_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_km_bis_for_calc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_KM_BIS_FOR_CALC
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2026     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Default value of 'KM bis' for calculation is 'KM bis' of this Arbeitsstelle.
    " If the calculation is for Ausfahrt:
    " - first get maximal KM (KM bis) of the most inner Arbeitsstelle in the Tunnel
    " - if this most inner KM is the same as 'KM bis' of this Arbeitsstelle
    "   - than this is the most inner Arbeitsstelle, so use 'KM bis' of this Arbeitsstelle
    "   - otherwise use the most inner KM

    rv_value = gs_arbeitsstelle-zkmax.

    IF iv_richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt.
      go_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN gs_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE lv_km_max ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_KM_VON_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BETRIEBSPUNKT               TYPE        ZIA_2_BETRIEBSPUNKT
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIA_2_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_km_von_for_calc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_KM_VON_FOR_CALC
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2026     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_value = zcl_ia_2betriebspunk=>get_kilometer( iv_betriebspunkt  = iv_betriebspunkt
                                                    iv_sperrabschnitt = iv_sperrabschnitt ).

    IF iv_richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt.
      go_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN gs_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE gs_arbeitsstelle-zkmin ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_MIN_KM_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIA_2_ZEITABZUG_PRO_KM_FS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_min_km_for_calc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_MIN_KM_FOR_CALC
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2026     tcs / Shital Kshirsagar
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    " Default value of MIN Per KM for calculation is 'Zeitabzug km FS'
    " If the calculation is for Ausfahrt:
    " - first get maximal KM (KM bis) of the most inner Arbeitsstelle in the Tunnel
    " - if this most inner KM is the same as 'KM bis' of this Arbeitsstelle
    "   - than this is the most inner Arbeitsstelle, so use 'Zeitabzug km FS'
    "   - otherwise use 'Zeitabzug km SH'

    DATA(ls_param) = go_schicht->get_parameter( )->get_data( ).

    rv_value = ls_param-zeitabzug_pro_km_fs.

    IF iv_richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt.
      go_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN gs_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE ls_param-zeitabzug_pro_km_sh ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SP_ZEITEN_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_SPABS
* | [<-()] RS_VALUE                       TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SP_ZEITEN_DATA
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_spabs) = get_sperrabschnitte_with_id( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ).
    READ TABLE lt_spabs ASSIGNING FIELD-SYMBOL(<ls_spabs>) WITH KEY sperrabschnitt = iv_sperrabschnitt.
    CHECK sy-subrc = 0.

    DATA(li_sp_zeiten_i) = go_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_ia_2restr_asso_tims( li_sp_zeiten_i->get_next( ) ).
      DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).
      CHECK ls_sp_zeiten-sperras_id = <ls_spabs>-sperras_id.

      rs_value = CORRESPONDING #( ls_sp_zeiten ).

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->GET_TRASSE_DATA_FOR_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [--->] IV_INTERVALLART                TYPE        ZIA_2_INTERVALLART(optional)
* | [<---] EV_BETRIEBSPUNKT               TYPE        ZIA_2_BETRIEBSPUNKT
* | [<---] EV_DATE                        TYPE        DATS
* | [<---] EV_TIME                        TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_trasse_data_for_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_TRASSE_DATA_FOR_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ASSIGN it_ez_form[ zarbstl  = gs_arbeitsstelle-zarbstl
                      richtung = iv_richtung
                      ez_aktiv = abap_true ] TO FIELD-SYMBOL(<ls_ez_form>).

    CHECK sy-subrc = 0.
    CHECK <ls_ez_form>-zugnummer IS NOT INITIAL.
    go_schicht->get_sp_schicht( ).
    ev_date = go_schicht->get_data( )-start_datum.

    DATA(lv_time_field) = CONV fieldname( '' ).
    DATA(lt_trassen) = go_schicht->get_trassen( iv_zugnummer       = <ls_ez_form>-zugnummer
                                                iv_arbstelle_level = abap_true ).
    CASE iv_richtung.
      WHEN zif_ia_2_trasse=>mc_richtung_einfahrt.
        lv_time_field = 'ZAN'.
        SORT lt_trassen BY reihenfolge DESCENDING.
      WHEN zif_ia_2_trasse=>mc_richtung_ausfahrt.
        lv_time_field = 'ZAB'.
        SORT lt_trassen BY reihenfolge ASCENDING.
    ENDCASE.

    ASSIGN lt_trassen[ 1 ] TO FIELD-SYMBOL(<ls_trasse>).
    CHECK <ls_trasse> IS ASSIGNED.

    ev_betriebspunkt = <ls_trasse>-betriebspunkt.

    IF <ls_trasse>-zeit_am_start_tag IS INITIAL.
      ev_date = ev_date + 1.
    ENDIF.

    ASSIGN COMPONENT lv_time_field OF STRUCTURE <ls_trasse> TO FIELD-SYMBOL(<lv_time>).
    ev_time = <lv_time>.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->INITIALIZE_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IA_2ORDER
* | [<---] EO_ORDER                       TYPE REF TO ZCL_IA_2ORDER
* | [<---] ES_ORDER                       TYPE        ZIA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD initialize_auftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
* Intialize the order class object
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF is_auftrag IS NOT INITIAL.
      DATA(ls_auftrag) = is_auftrag.
      eo_order = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).
    ELSEIF io_order IS NOT INITIAL.
      ls_auftrag = io_order->get_data( ).
*      eo_order ?= io_order.
      eo_order = io_order.
    ELSEIF iv_aufnr IS NOT INITIAL.
      SELECT SINGLE * FROM zia_2order INTO @ls_auftrag WHERE aufnr = @iv_aufnr.
      eo_order = NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr ).
    ELSE.
      RETURN."      EXIT.
    ENDIF.
    es_order = ls_auftrag.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->INSERT_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD insert_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : INSERT_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lt_has_changed TYPE RANGE OF abap_bool.
    DATA lt_db TYPE STANDARD TABLE OF zia_2sf_ez_form WITH EMPTY KEY.

    IF get_perimeter( ) = 'GBT'.
      " for GBT save only changed records
      lt_has_changed = VALUE #( ( sign = 'I' option = 'EQ' low = abap_true ) ).
    ENDIF.

    lt_db = VALUE #( FOR <ls_ez_form> IN it_ez_form WHERE ( zarbstl     =  gs_arbeitsstelle-zarbstl
                                                      AND   ez_aktiv    =  abap_true
                                                      AND   has_changed IN lt_has_changed[] )
                         ( zschicht    = gs_arbeitsstelle-zschicht
                           zugnummer   = <ls_ez_form>-zugnummer
                           zarbstl     = gs_arbeitsstelle-zarbstl
                           zid_eiz     = gs_arbeitsstelle-zid_eiz
                           richtung    = <ls_ez_form>-richtung
                           data_origin = <ls_ez_form>-data_origin
                           ez_aktiv    = <ls_ez_form>-ez_aktiv
                           ernam       = cl_abap_context_info=>get_user_technical_name( )"syst-uname
                           erdat       = sy-datum
                           erzeit      = sy-uzeit ) ).

    CHECK lt_db[] IS NOT INITIAL.

    INSERT zia_2sf_ez_form FROM TABLE lt_db ACCEPTING DUPLICATE KEYS.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->LOCK_SINGLE_CAPACITIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EINZELKAPAS                 TYPE        ZIA_2EINZELKAPAS_T
* | [<---] EO_FAHRZEUGE_I                 TYPE REF TO CL_OBJECT_COLLECTION_ITERATOR
* | [<---] EO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* | [<---] EO_SITZPLATZ                   TYPE REF TO ZCL_IA_2SEAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock_single_capacities.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA : ls_einzelkapa  TYPE zia_2order_cap,
           lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
           lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle,
           lo_sitzplatz   TYPE REF TO zcl_ia_2seat.

    LOOP AT it_einzelkapas INTO ls_einzelkapa.
      lo_fahrzeuge_i ?= me->go_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
        lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
        CHECK lo_sitzplatz IS NOT INITIAL.

        TRY.
            lo_sitzplatz->lock( ).
          CATCH zcx_ia_2failure INTO DATA(lx_fehler).
            RAISE EXCEPTION lx_fehler.
        ENDTRY.
      ENDWHILE.
    ENDLOOP.

    eo_fahrzeuge_i = lo_fahrzeuge_i.
    eo_fahrzeug    = lo_fahrzeug.
    eo_sitzplatz   = lo_sitzplatz.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SAVE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* | [--->] IS_INNER_SP_ZEITEN             TYPE        ZIA_2SF_BS_TIME(optional)
* | [--->] IV_CALLED_FROM                 TYPE        ZIA_2_TREMOLA_CALLED_FROM(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SAVE_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_ez_form) = it_ez_form.
    DELETE lt_ez_form WHERE zarbstl <> gs_arbeitsstelle-zarbstl.

    set_zugnummer_from_ez_form( it_ez_form = lt_ez_form
                                 iv_called_from  = iv_called_from ).   ">001< +

    IF NOT go_schicht->is_tremola_active( ).
      calculate_as_times( it_ez_form         = lt_ez_form
                          is_inner_sp_zeiten = is_inner_sp_zeiten ).
    ENDIF.

    delete_ez_form( it_ez_form = lt_ez_form ).

    insert_ez_form( it_ez_form = lt_ez_form ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->SELECT_SP_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIA_2_SPERRAS_ID
* | [<-()] RS_VALUE                       TYPE        ZIA_2SF_BS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_sp_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SELECT_SP_SCHICHT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
*    SELECT SINGLE * FROM zia_2sf_bs   ##WARN_OK
    SELECT SINGLE * FROM zia_2sf_bs_time   ##WARN_OK
      INTO @rs_value
      WHERE zarbstl = @me->gs_arbeitsstelle-zarbstl
        AND sperras_id = @iv_sperras_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->SET_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGNUMMER                   TYPE        ZIA_2_ZUG_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zugnummer.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :SET_ZUGNUMMER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_arbeitsstelle-zid_zug <> iv_zugnummer.

    gs_arbeitsstelle-zid_zug = iv_zugnummer.

    update_zugnummer( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->SET_ZUGNUMMER_FROM_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T
* | [--->] IV_CALLED_FROM                 TYPE        ZIA_2_TREMOLA_CALLED_FROM(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zugnummer_from_ez_form.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :SET_ZUGNUMMER_FROM_EZ_FORM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    clear_zugnummer( iv_called_from = iv_called_from  ).   ">002< MOD

    TRY .
        DATA(lv_zugnummer) = it_ez_form[ zarbstl  = gs_arbeitsstelle-zarbstl
                                         richtung = zif_ia_2_trasse=>mc_richtung_einfahrt
                                         ez_aktiv = abap_true ]-zugnummer.
        set_zugnummer( lv_zugnummer ).

      CATCH cx_sy_itab_line_not_found.

        DATA(lt_ez_form_db) = me->get_ez_form_db( ).   "Check manual change
        ASSIGN lt_ez_form_db[ zarbstl     = gs_arbeitsstelle-zarbstl
                              richtung    = zif_ia_2_trasse=>mc_richtung_einfahrt
                              data_origin = abap_false
                              ez_aktiv    = abap_true ]-zugnummer TO FIELD-SYMBOL(<lv_zugnummer>).

*--> Begin Insert >001<
        IF sy-subrc NE 0.
          ASSIGN lt_ez_form_db[ zarbstl     = gs_arbeitsstelle-zarbstl
                                richtung    = zif_ia_2_trasse=>mc_richtung_einfahrt
                                data_origin = zif_ia_2_constant=>mc_data_origin-manual
                                ez_aktiv    = abap_true ]-zugnummer TO <lv_zugnummer>.

        ENDIF.

        IF <lv_zugnummer> IS ASSIGNED.
*--> End Insert >001<
          set_zugnummer( <lv_zugnummer> ).
        ENDIF.

    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->UPDATE_ZEITEN_FROM_SPABSID
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_zeiten_from_spabsid.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : UPDATE_ZEITEN_FROM_SPABSID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lt_map_spabs) = get_sperrabschnitte( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ).

    DATA(li_sp_zeiten_i) = go_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_ia_2restr_asso_tims( li_sp_zeiten_i->get_next( ) ).

      DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).
      ASSIGN lt_map_spabs[ sperras_id = ls_sp_zeiten-sperras_id ] TO FIELD-SYMBOL(<ls_map_spabs>).
      CHECK sy-subrc = 0.

      DATA(ls_sp_schicht) = select_sp_schicht( <ls_map_spabs>-sperras_id ).

      ls_sp_zeiten-start_datum = ls_sp_schicht-start_datum.
      ls_sp_zeiten-start_zeit  = ls_sp_schicht-start_zeit.
      ls_sp_zeiten-end_datum   = ls_sp_schicht-end_datum.
      ls_sp_zeiten-end_zeit    = ls_sp_schicht-end_zeit.

      lo_sp_zeiten->update_data( is_data = ls_sp_zeiten ).

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WRKPLACE->UPDATE_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_zugnummer.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :UPDATE_ZUGNUMMER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    UPDATE zia_2sf_wa SET
     zid_zug = @gs_arbeitsstelle-zid_zug
     WHERE zarbstl = @gs_arbeitsstelle-zarbstl.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->VALIDATE_ORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN
* | [<---] ET_EINZELKAPAS                 TYPE        ZIA_2EINZELKAPAS_T
* | [<---] EV_IS_VALID                    TYPE        BOOLEAN
* | [<---] EV_HAS_ERRORS                  TYPE        BOOLEAN
* | [<---] EV_CRITICAL                    TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD validate_order.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  DATA(lv_planung_os) = COND #( WHEN me->is_in_tunnel( ) EQ abap_false THEN abap_true ELSE abap_false ).
  DATA(lv_planung_btg) = COND #( WHEN io_auftrag->get_data( )-zstdkz EQ 'G' THEN abap_true ELSE abap_false ).

  verify_and_add_sp_for_order( io_auftrag = io_auftrag ).

  " ---- RULE CHECKS ----
  IF zcl_ia_2rules=>check_quer_km(
       EXPORTING is_auftrag = is_auftrag
                 io_arbeitsstelle = me ) = abap_false.
    ev_has_errors = abap_true.
    ev_critical = abap_true.
  ENDIF.


  IF zcl_ia_2rules=>check_datum(
       io_arbeitsstelle = me
       is_auftrag       = is_auftrag ) = abap_false.
    ev_has_errors = abap_true.
    ev_critical = abap_true.
  ENDIF.

  IF lv_planung_btg = abap_false AND
     lv_planung_os  = abap_false AND
     zcl_ia_2rules=>check_as_ausdehnung(
       io_arbeitsstelle = me
       io_auftrag       = io_auftrag ) = abap_false.
    ev_has_errors = abap_true.
    ev_critical = abap_true.
  ENDIF.

  IF lv_planung_btg = abap_false AND
     zcl_ia_2rules=>check_sa_gap(
       io_arbeitsstelle = me
       io_auftrag       = io_auftrag ) = abap_false.
    ev_has_errors = abap_true.
    ev_critical = abap_true.
  ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->VERIFY_AND_ADD_SP_FOR_ORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD verify_and_add_sp_for_order.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       27.02.2026     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA lt_sperrabschnitt TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lv_sperrabschnitt TYPE zia_2sp_block_shift_s-sperrabschnitt.

    DATA(lt_auftrag_sp_intvart) = io_auftrag->get_sp_intvart( iv_ts_est = me->go_schicht->get_ts_est( )
                                                                iv_rj_est = me->go_schicht->get_rj_est( ) ).
    LOOP AT lt_auftrag_sp_intvart ASSIGNING FIELD-SYMBOL(<ls_auftrag_sp_intvart>).

      CLEAR lt_sperrabschnitt.
      IF <ls_auftrag_sp_intvart>-zintervallart = 'TS'.
        " TS is matched by interval type only.
        APPEND CONV string( <ls_auftrag_sp_intvart>-sperrabschnitt ) TO lt_sperrabschnitt.
      ELSE.
        SPLIT <ls_auftrag_sp_intvart>-sperrabschnitt AT ',' INTO TABLE lt_sperrabschnitt.
      ENDIF.

      LOOP AT lt_sperrabschnitt INTO lv_sperrabschnitt.  "#EC CI_NESTED
        "Lesen der Kombinationen Sperrabschnitte/Intervallart an der Schicht
        IF <ls_auftrag_sp_intvart>-zintervallart = 'TS'.
          READ TABLE  me->get_schicht( )->get_sp_schicht( ) WITH KEY zintervallart  = <ls_auftrag_sp_intvart>-zintervallart INTO DATA(ls_sp_schicht). "#EC CI_STDSEQ
        ELSE.
          READ TABLE  me->get_schicht( )->get_sp_schicht( ) WITH KEY sperrabschnitt = lv_sperrabschnitt
                                                                   zintervallart  = <ls_auftrag_sp_intvart>-zintervallart INTO ls_sp_schicht.
        ENDIF.

        IF syst-subrc EQ 0.
          "Ist denn der Sperrabschnitt schon auf der Arbeitsstelle vorhande?
          READ TABLE me->gt_map_as_szg WITH KEY sperras_id  = ls_sp_schicht-sperras_id "TRANSPORTING NO FIELDS.  "#EC CI_STDSEQ
                                                zugangsart  = io_auftrag->get_data( )-zzzugangsart TRANSPORTING NO FIELDS.

          IF syst-subrc NE 0.
            "Neuen Sperrabschnitt der Arbeitsstelle hinzufügen
            me->add_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                        iv_zugangsart =  io_auftrag->get_data( )-zzzugangsart ).

            me->set_inital_ausdehnung_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                                          io_auftrag    = io_auftrag ).
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->GET_SPERRABSCHNITTE_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIA_2_ZUGANGSART(optional)
* | [<-()] RT_VALUE                       TYPE        ZIA_2ARBSTL_SPABSCHT_KM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_SPERRABSCHNITTE_KM
*----------------------------------------------------------------------*
* >000<   7.50       27.06.2026     tcs / pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: lv_dummy TYPE i .
    lv_dummy = '123'.
*    DATA lt_zugangsart_r TYPE RANGE OF zia_2map_as_szg-zugangsart.
*
*    IF iv_zugangsart IS NOT INITIAL.
*      lt_zugangsart_r = VALUE #( ( sign = 'I' option = 'EQ' low = iv_zugangsart ) ).
*    ENDIF.
*
*    SELECT spabs~zschicht,
*           spkm~zarbstl,
*           spkm~sperras_id,
*           map~zugangsart,
*           spabs~sperrabschnitt,
*           spabs~zintervallart,
*           spkm~zkmin,
*           spkm~zkmax
*      INTO CORRESPONDING FIELDS OF TABLE @rt_value
*      FROM       zia_2bs_km      AS spkm
*      INNER JOIN zia_2map_as_szg AS map ON map~zarbstl    = spkm~zarbstl
*                                        AND map~sperras_id = spkm~sperras_id
*      INNER JOIN zio_5_sp_schicht AS spabs ON spabs~sperras_id = spkm~sperras_id
*      WHERE spkm~zarbstl   =  @ms_arbeitsstelle-zarbstl
*        AND map~zugangsart IN @lt_zugangsart_r[].
*
**--> Begin Insert >001<
*    SELECT spabs~zschicht,
*           spkm~zarbstl,
*           signalusr~sperras_id,
*           spabs~sperrabschnitt,
*           spabs~zintervallart,
*           signalusr~km_von AS zkmin,
*           signalusr~km_bis AS zkmax
*    FROM       zia_2bs_km     AS spkm
*    INNER JOIN zio_5_sp_schicht AS spabs
*       ON spabs~sperras_id = spkm~sperras_id
*    INNER JOIN zia_2sf_sc_usr  AS signalusr
*       ON spabs~sperras_id =  signalusr~sperras_id
*       AND spkm~zarbstl =  signalusr~zarbstl               ">003< INS
*      WHERE spkm~zarbstl   =  @ms_arbeitsstelle-zarbstl
*     APPENDING CORRESPONDING FIELDS OF TABLE @rt_value.
**--> End Insert >001<
*
*    IF iv_zugangsart IS INITIAL.
*      MODIFY rt_value FROM VALUE #( zugangsart = iv_zugangsart ) TRANSPORTING zugangsart WHERE zugangsart IS NOT INITIAL.
*    ENDIF.
*
*    SORT rt_value.
*    DELETE ADJACENT DUPLICATES FROM rt_value COMPARING ALL FIELDS.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WRKPLACE->CHECK_LOCK_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECT                      TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IV_AUFNR                       TYPE        AUFNR(optional)
* | [<---] ET_BAPIRET                     TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_lock_orders.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : check the lock
*
*----------------------------------------------------------------------*
* >000<   7.50       28.09.2026     tcs / Venkateswarlu Batta
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    TYPES: BEGIN OF ts_enq_aufnr,
             aufnr TYPE aufnr,
             uname TYPE uname,
           END OF ts_enq_aufnr.
    TYPES: tt_enq_aufnr TYPE STANDARD TABLE OF ts_enq_aufnr WITH DEFAULT KEY.
*    DATA(lt_aufnr)       = VALUE aufnr_t( ).
    DATA(lt_enq)         = VALUE wlf_seqg3_tab( ).
    DATA(lt_enq_aufnr)   = VALUE tt_enq_aufnr( ).
    DATA(lt_bapiret)     = VALUE bapiret2_t( ).

    CALL FUNCTION 'ENQUEUE_READ'
      EXPORTING
        gname                 = 'AUFK' "mc_tabname_auftr
      TABLES
        enq                   = lt_enq
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 3.
    IF sy-subrc <> 0 OR lt_enq IS INITIAL.
      RETURN.
    ENDIF.


*    lt_aufnr = CAST cl_object_map( go_schicht->get_auftraege( ) )->get_keys( ).
    IF io_object IS NOT INITIAL.
      DATA(lv_ord) = io_object->get_data( )-aufnr.
    ELSE.
      lv_ord = iv_aufnr.
    ENDIF.

*    LOOP AT lt_aufnr ASSIGNING FIELD-SYMBOL(<ls_aufnr>).
    TRY.
        DATA(ls_enq) = lt_enq[ garg+3 = lv_ord ].
        lt_enq_aufnr = VALUE #( BASE lt_enq_aufnr ( uname = ls_enq-guname aufnr = |{ lv_ord ALPHA = OUT }| )  ).
        ##NO_HANDLER
      CATCH cx_sy_itab_line_not_found.
*          CONTINUE.
    ENDTRY.
*    ENDLOOP.

    IF lt_enq_aufnr IS NOT INITIAL.
      LOOP AT lt_enq_aufnr ASSIGNING FIELD-SYMBOL(<ls_enq_aufnr>).
        TRY.
            zcl_ia_2utilities=>get_user_details( EXPORTING iv_uname = <ls_enq_aufnr>-uname IMPORTING ev_voller_name = DATA(lv_name) ).
          CATCH zcx_ia_2failure.
            lv_name = <ls_enq_aufnr>-uname. "syst-uname
        ENDTRY.
        MESSAGE e551(zia_2_real) WITH <ls_enq_aufnr>-aufnr lv_name INTO DATA(lv_msg).
        et_bapiret = VALUE #( BASE lt_bapiret ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message    = lv_msg ) ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.