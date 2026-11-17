class ZCL_IO_5_ARBEITSSTELLE definition
  public
  final
  create public .

public section.

  types:
    tty_aufnr TYPE STANDARD TABLE OF aufnr WITH DEFAULT KEY .
  types:
    BEGIN OF ty_einzelkapas_ref,
        object TYPE REF TO zcl_io_5_einzelkapazitaet,
      END OF ty_einzelkapas_ref .
  types:
    tty_einzelkapas_ref TYPE STANDARD TABLE OF ty_einzelkapas_ref  WITH DEFAULT KEY .
  types:
    BEGIN OF ty_anzahl_qual,
        aufnr       TYPE aufnr,
        er_ir       TYPE zio_5_er_ir,
        anzahl_qual TYPE zio_5_anzahl_qual,
      END OF ty_anzahl_qual .
  types:
    tty_anzahl_qual TYPE STANDARD TABLE OF ty_anzahl_qual WITH DEFAULT KEY .
  types:
    BEGIN OF ty_pneu_kennzeichen,
        zarbstbez TYPE zio_arbstbez_kennzeichen,
        index     TYPE zio_index,
      END OF ty_pneu_kennzeichen .
  types:
    tty_pneu_kennzeichen TYPE STANDARD TABLE OF ty_pneu_kennzeichen WITH DEFAULT KEY .
  types:
    BEGIN OF ty_sp_zeiten_tab,
        sperras_id     TYPE zio_5_sperras_id,
        sperrabschnitt TYPE zio_roehre,
        zintervallart  TYPE zio_intervallart,
        start_datum    TYPE pm_ordgstrp,
        start_zeit     TYPE co_gsuzp,
        end_datum      TYPE co_gltrp,
        end_zeit       TYPE co_gluzp,
      END OF ty_sp_zeiten_tab .
  types:
    tty_sp_zeiten_tab TYPE STANDARD TABLE OF ty_sp_zeiten_tab WITH DEFAULT KEY .
  types:
    tty_v_map_as TYPE STANDARD TABLE OF zio_5_v_map_as WITH DEFAULT KEY .
  types:
    BEGIN OF ty_sp_ktext,
        position   TYPE int1,
        prefix     TYPE char1,
        index      TYPE n LENGTH 2,
        zugangsart TYPE zio_zugangsart,
        name       TYPE zio_id_btg,
        btg        TYPE zio_ktext40_de,
      END OF ty_sp_ktext .
  types:
    tty_sp_ktext TYPE STANDARD TABLE OF ty_sp_ktext WITH DEFAULT KEY .
  types:
    BEGIN OF ty_as_km_sort,
        zarbstl TYPE zio_id_arbstl,
        km_max  TYPE zio_km_bis,
      END OF ty_as_km_sort .
  types:
    tty_as_km_sort TYPE STANDARD TABLE OF ty_as_km_sort WITH DEFAULT KEY .

  constants MC_APPLID type ZLOFPM_APPLID value 'GBT' ##NO_TEXT.
  constants MC_PNAME type ZLOFPM_PNAME value 'REAL_SIGNAL_KM_ABWEICH' ##NO_TEXT.
  constants MC_INTERVALLART_LI type ZIO_INTERVALLART value 'LI' ##NO_TEXT.
  constants:
    BEGIN OF mc_sperrabs,
                 e  TYPE zio_roehre VALUE 'E',
                 e1 TYPE zio_roehre VALUE 'E1',
                 e2 TYPE zio_roehre VALUE 'E2',
                 e3 TYPE zio_roehre VALUE 'E3',
                 w  TYPE zio_roehre VALUE 'W',
                 w1 TYPE zio_roehre VALUE 'W1',
                 w2 TYPE zio_roehre VALUE 'W2',
                 w3 TYPE zio_roehre VALUE 'W3',
               END OF mc_sperrabs .
  constants:
    BEGIN OF mc_perimeters,
                 gbt TYPE zio_prmtr VALUE 'GBT',
                 cbt TYPE zio_prmtr VALUE 'GBT',
               END OF mc_perimeters .
  data MS_ARBEITSSTELLE type ZIO_5_ARBSTELLEN .

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_INSTANCE
    importing
      !IV_SCHICHT_ID type ZIO_5_SCHICHT
      !IV_ARBSTLE_ID type ZIO_ID_ARBSTL
    returning
      value(RO_INSTANCE) type ref to ZCL_IO_5_ARBEITSSTELLE .
  methods ADD_AUFTRAG_O
    importing
      !IO_ORDER type ref to ZCL_IO_5_AUFTRAG optional
      !IS_AUFTRAG type ZIO_5_AUFTR optional
      !IV_AUFNR type AUFNR optional
      !IV_TESTRUN type BOOLEAN optional
      !IV_IGNORE_ERRORS type BOOLEAN optional
      !IV_AUTO_PLANNING type BOOLEAN optional
      !IV_SKIP_VALIDATIONS type BOOLEAN optional
      !IV_FIRST_ORDER type BOOLEAN optional
      !IV_VORSCHAU type BOOLEAN optional
    returning
      value(RV_SUCCESS) type BOOLEAN
    raising
      ZCX_IO_5_FEHLER .
  methods ADD_FAHRZEUG
    importing
      !IO_FAHRZEUG type ref to ZCL_IO_5_FAHRZEUG .
  methods ADD_FAHRZEUGE
    importing
      !IO_OBJECTS type ref to CL_OBJECT_MAP
      !IV_VORSCHAU type BOOLEAN optional .
  methods ADD_FAHRZEUGE_TYPES .
  methods ADD_SP
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
      !IV_ZUGANGSART type ZIO_ZUGANGSART .
  methods ADD_SP_KM
    importing
      !IO_SP_KM type ref to ZCL_IO_5_SP_KILOMETER .
  methods ADD_SP_ZEIT
    importing
      !IO_SP_ZEIT type ref to ZCL_IO_5_SP_ZEITEN .
  methods CHECK_AS_IS_IN_TUNNEL
    returning
      value(RV_IS_TUNNEL) type BOOLEAN .
  methods CLEAR_ZUGNUMMER
    importing
      !IV_CALLED_FROM type ZIO_5_TREMOLA_CALLED_FROM optional .
  methods CONSTRUCTOR
    importing
      !IV_ID type ZIO_ID optional
      !IO_SCHICHT type ref to ZCL_IO_5_SCHICHT optional .
  methods EXISTS
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods FUELLE_ARBEITSSTELLE
    importing
      !IV_MAX_AUSLASTUNG type ZIO_AUSLASTUNG .
  methods GET_AL
    returning
      value(RT_SITZPLAETZE) type ZIO_5_FZG_PL_T .
  methods GET_ANZAHL_QUAL
    returning
      value(RT_DATA) type TTY_ANZAHL_QUAL .
  methods GET_ARBEITSZEIT
    returning
      value(RS_DATA) type ZIO_5_ARBSTELLE_ZEIT .
  methods GET_SA_FOR_NEW_AUFTRAG
    importing
      !IV_RJ_EST type ZIO_ROEHRE
      !IV_TS_EST type ZIO_ROEHRE
      !IO_AUFTRAG type ref to ZCL_IO_5_AUFTRAG
    returning
      value(RT_SA) type ZIO_5_SA_T .
  methods GET_AUFTRAEGE
    importing
      !IS_FILTER type ZIO_5_AUFTR optional
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods GET_AUFTRAEGE_PLANUNG
    importing
      !IV_KM_MIN type ZIO_KM optional
      !IV_KM_MAX type ZIO_KM optional
    returning
      value(RT_AUFTRAEGE) type ZIO_5_AUFTRAEGE_T .
  methods GET_AUFTRAEGE_WD
    returning
      value(RT_LIST) type ZIO_5_JOBPOOL_WD_T .
  methods GET_AUFTRAG
    importing
      !IV_INDEX type INTEGER optional
      !IV_KEY type AUFNR optional
    returning
      value(RO_OBJECT) type ref to ZCL_IO_5_AUFTRAG .
  methods GET_BTG
    exporting
      !EV_LAGE type ZIO_LAGE
      !EV_DIDOK type ZIO_DIDOK
      !EV_ID_BTG type ZIO_ID_BTG
      !EV_INDEX type ZIO_INDEX .
  methods GET_COLOR
    returning
      value(RS_COLOR) type STRINGVAL .
  methods GET_DATA
    returning
      value(RS_DATA) type ZIO_5_ARBSTELLEN .
  methods GET_EINZELKAPAS_REF
    returning
      value(RT_DATA) type TTY_EINZELKAPAS_REF .
  methods GET_SA_EXT_FOR_NEW_AUFTRAG
    importing
      !IO_AUFTRAG type ref to ZCL_IO_5_AUFTRAG optional
    returning
      value(RT_SA) type ZIO_5_SA_T .
  methods GET_EIZ_DESCRIPTION
    returning
      value(RV_VALUE) type ZIO_5_EIZ_BESCHR .
  methods GET_EZ_FORM
    importing
      !IV_RICHTUNG type ZIO_5_RICHTUNG optional
      !IV_ACTIVE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_VALUE) type ZIO_5_EZ_FORM_T .
  methods GET_EZ_FORM_DB
    importing
      !IV_NEW type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_DATA) type ZIO_5_EZ_FORM_T .
  methods GET_FAHRZEUGE
    importing
      !IV_FILTER_FZTYP type ZIO_ID_FZTYP optional
    returning
      value(RO_FAHRZEUGE) type ref to CL_OBJECT_MAP .
  methods GET_ID
    returning
      value(RV_ID) type ZIO_ID_AS .
  methods GET_INTERVALLARTEN
    returning
      value(RS_INTERVALLARTEN) type ZIO_5_INTERVALLARTEN .
  methods GET_KURZTEXT
    importing
      !IV_ZGART_TXT type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_TEXT) type STRING .
  methods GET_MAP_SP_AS
    importing
      !IV_REFRESH type ABAP_BOOL optional
    returning
      value(RT_DATA) type TTY_V_MAP_AS .
  methods GET_MAX_AUSLASTUNG
    returning
      value(RV_VALUE) type ZIO_5_AUSLASTUNG_TIME .
  methods GET_MET
    returning
      value(RS_VALUE) type ZIO_5_MET .
  methods GET_NETTOARBEITSZEIT
    returning
      value(RV_ARBEITSZEIT) type ZIO_ARBEITSZEIT .
  methods GET_PERIMETER
    returning
      value(RV_VALUE) type ZIO_PRMTR .
  methods GET_PNEU_KENNZEICHEN
    returning
      value(RT_DATA) type TTY_PNEU_KENNZEICHEN .
  methods GET_RJ_EST
    returning
      value(RV_EST) type ZIO_ROEHRE .
  methods GET_SC
    returning
      value(RT_SITZPLAETZE) type ZIO_5_FZG_PL_T .
  methods GET_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IO_5_SCHICHT .
  methods GET_SIGABS_BY_SP
    importing
      !IV_INCLUDE_MANUAL type BOOLEAN default ABAP_FALSE
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
    returning
      value(RT_SIGABS_EHB) type ZIO_5_SA_T .
  methods GET_SIGABS_BY_SP_AS_TEXT
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
    returning
      value(RV_SIGABS_EHB) type STRINGVAL .
  methods GET_SIGNALABSCHNITT_NEXT
    importing
      !IS_SA type ZIO_5_SA
      !IT_SA_RNG type ZIO_5_SPABSCH_RANGE_T optional
    returning
      value(RS_SA) type ZIO_5_SA .
  methods GET_SIGNALABSCHNITT_PREV
    importing
      !IS_SA type ZIO_5_SA
    returning
      value(RS_SA) type ZIO_5_SA .
  methods GET_SITZPLAETZE
    returning
      value(RO_SITZPLAETZE) type ref to CL_OBJECT_MAP .
  methods GET_SITZPLATZ_BY_ID
    importing
      !IV_SITZPLATZ_ID type ZIO_ID
    returning
      value(RO_SITZPLATZ) type ref to ZCL_IO_5_SITZPLATZ .
  methods GET_SPERRABSCHNITTE
    importing
      !IV_ZUGANGSART type ZIO_5_ZUGANGSART optional
    returning
      value(RT_MAP_AS_SZG) type ZIO_5_MAP_AS_SZG_T .
  methods GET_SPERRABSCHNITTE_AS_TEXT
    returning
      value(RV_VALUE) type ZIO_5_SPERRABSCHNITT_TEXT .
  methods GET_SPERRABSCHNITTE_KM
    importing
      !IV_ZUGANGSART type ZIO_5_ZUGANGSART optional
    returning
      value(RT_VALUE) type ZIO_5_ARBSTL_SPABSCHT_KM_T .
  methods GET_SPERRABSCHNITTE_WITH_ID
    importing
      !IV_ZUGANGSART type ZIO_5_ZUGANGSART optional
    returning
      value(RT_VALUE) type ZIO_5_SPID_SPABS_INTART_T .
  methods GET_SP_DETAILS_WD
    exporting
      !ET_SP_EHB type ZIO_5_SP_EHB_WD_T
      !ET_SP_DETAILS type ZIO_5_SP_DETIALS_WD_T .
  methods GET_SP_KILOMETER
    returning
      value(RO_SP_KILOMETER) type ref to CL_OBJECT_MAP .
  methods GET_SP_ZEITEN
    returning
      value(RO_SP_ZEITEN) type ref to CL_OBJECT_MAP .
  methods GET_SP_ZEITEN_DATA
    importing
      !IV_SPERRABSCHNITT type ZIO_5_SPABS
    returning
      value(RS_VALUE) type ZIO_5_SP_ZEITEN .
  methods GET_SUPPLY_TYPE_AS_TEXT
    returning
      value(RV_DATA) type STRING .
  methods GET_TEXT_ID
    importing
      !IV_ZUGANGSART type ZIO_5_ZUGANGSART
      !IV_INC_TS type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_VALUE) type ZIO_ARBST .
  methods GET_THF
    returning
      value(RT_SITZPLAETZE) type ZIO_5_FZG_PL_T .
  methods GET_WD_HEADER_TEXT
    returning
      value(RV_TEXT) type ZIO_5_AS_HEADER_TEXT .
  methods GET_ZUGANGSARTEN
    returning
      value(RS_ZUGANGSARTEN) type ZIO_5_ZUGANGSARTEN .
  methods HAS_AUFTRAG
    importing
      !IV_AUFNR type AUFNR
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods HAS_MET
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods HAS_OSX
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods HAS_TS
    returning
      value(RV_HAS_TS) type BOOLEAN .
  methods IS_ABHAENGIG
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_BTG
    exporting
      !EV_ID_BTG type ZIO_ID_BTG
    returning
      value(RV_BOOLEAN) type WDY_BOOLEAN .
  methods IS_EMPTY
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_IN_OS_NORD
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_IN_OS_SUED
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_IN_TUNNEL
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_PNEU
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_SCHIENE
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods LOCK
    importing
      !IV_CHECK type BOOLEAN optional
    raising
      ZCX_IO_5_FEHLER .
  methods LOCK_SUB_OBJECTS
    importing
      !IV_CHECK type BOOLEAN
    raising
      ZCX_IO_5_FEHLER .
  methods REFRESH_AUSDEHUNG .
  methods REFRESH_EIZ_EST
    importing
      !IS_AUFTRAG type ZIO_5_AUFTR optional .
  methods RELOAD .
  methods RELOAD_AUFTRAG_O
    importing
      !IO_ORDER type ref to ZCL_IO_5_AUFTRAG optional
    returning
      value(RV_SUCCESS) type BOOLEAN
    raising
      ZCX_IO_5_FEHLER .
  methods REMOVE_AUFTRAEGE
    importing
      !IV_CHANGE_ERP type BOOLEAN default ABAP_TRUE
    raising
      ZCX_IO_5_FEHLER .
  methods REMOVE_AUFTRAG_O
    importing
      !IO_OBJECT type ref to ZCL_IO_5_AUFTRAG
      !IV_CHANGE_ERP type BOOLEAN default ABAP_TRUE
    raising
      ZCX_IO_5_FEHLER .
  methods REMOVE_FAHRZEUG
    importing
      !IO_FAHRZEUG type ref to ZCL_IO_5_FAHRZEUG
    raising
      ZCX_IO_5_FEHLER .
  methods REMOVE_FAHRZEUGE
    raising
      ZCX_IO_5_FEHLER .
  methods REMOVE_MET .
  methods REMOVE_VORSCHAU
    raising
      ZCX_IO_5_FEHLER .
  methods SAVE
    importing
      !IV_SAVE_DIRECTLY type BOOLEAN optional .
  methods SAVE_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T
      !IS_INNER_SP_ZEITEN type ZIO_5_SP_ZEITEN optional
      !IV_CALLED_FROM type ZIO_5_TREMOLA_CALLED_FROM optional .
  methods SET_BTG
    importing
      !IV_ID_BTG type ZIO_ID_BTG .
  methods SET_DATA
    importing
      !IS_DATA type ZIO_5_ARBSTELLEN .
  methods SET_ETAPPENAUFTRAG
    importing
      !IV_AUFNR type AUFNR .
  methods SET_INITAL_AUSDEHNUNG_SP
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
      !IO_AUFTRAG type ref to ZCL_IO_5_AUFTRAG .
  methods SET_MET
    importing
      !IV_ID_MET type ZIO_ID_MET
      !IV_IGNORE_ERRORS type ABAP_BOOL optional .
  methods SET_MET_AS_NAME_PREFIX
    importing
      !IV_PREFIX type ZIO_5_MET_AS_NAME_PREFIX .
  methods SET_SCHICHT
    importing
      !IO_SCHICHT type ref to ZCL_IO_5_SCHICHT .
  methods SET_TREMOLA_CALC
    importing
      !IV_DATA type ABAP_BOOL .
  methods SET_ZKMIN
    importing
      !IV_ZKMIN type ZIO_5_ARBSTELLEN-ZKMIN .
  methods SET_ZKMAX
    importing
      !IV_ZKMAX type ZIO_5_ARBSTELLEN-ZKMAX .
  methods SET_ZUGNUMMER
    importing
      !IV_ZUGNUMMER type ZIO_5_ARBSTELLEN-ZID_ZUG .
  methods UNLOCK .
  methods UNLOCK_SUB_OBJECTS
    raising
      ZCX_IO_5_FEHLER .
  methods GET_LINUMBER_AS_TEXT
    returning
      value(RV_VALUE) type ZIO_5_LINUMBER_TEXT .
  methods ARE_VEHICLES_REFERENCED
    returning
      value(RV_VALUE) type BOOLEAN .
  methods CONTAINS_MANUAL_SIGNALS
    returning
      value(RV_RESULT) type BOOLEAN .
  methods REFRESH_MANUAL_SIGNALS .
  methods IS_FZG_KM_SA_TRENNUNG_VALID
    returning
      value(RV_VALUE) type BOOLEAN .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_min_km ,
      perimeter      TYPE zio_prmtr,
      sperrabschnitt TYPE zio_5_spabs,
      min_km         TYPE zio_km,
    END   OF ts_min_km .
  types:
    tt_min_km TYPE STANDARD TABLE OF ts_min_km WITH EMPTY KEY .
  types:
    tty_fplatz TYPE STANDARD TABLE OF zio_id_fzg_platz WITH DEFAULT KEY .

  class-data MT_MIN_KM type TT_MIN_KM .
  data MO_FAHRZEUGE type ref to CL_OBJECT_MAP .
  data MO_ORDERS type ref to CL_OBJECT_MAP .
  data MO_SCHICHT type ref to ZCL_IO_5_SCHICHT .
  data MO_SP_KILOMETER type ref to CL_OBJECT_MAP .
  data MO_SP_ZEITEN type ref to CL_OBJECT_MAP .
  data MT_AUFTRAEGE_PLANUNG type ZIO_5_AUFTRAEGE_T .
  data MT_MAP_AS_SZG type ZIO_5_MAP_AS_SZG_T .
  data MT_MAP_SP_AS type TTY_V_MAP_AS .
  data MT_EZ_FORM_DB type ZIO_5_EZ_FORM_T .

  methods REFRESH_SA_SP .
  class-methods ADD_MIN_KM
    importing
      !IV_PERIMETER type ZIO_PRMTR
      !IV_SPERRABSCHNITT type ZIO_5_SPABS .
  class-methods INIT_MIN_KM .
  class-methods SELECT_SA_KM_MIN
    importing
      !IV_PERIMETER type ZIO_PRMTR
      !IV_SPERRABSCHNITT type ZIO_5_SPABS
    returning
      value(RT_VALUE) type TT_MIN_KM .
  methods ADJUST_KM_FOR_SPERRABSCHNITT
    importing
      !IV_SPERRABSCHNITT type ZIO_5_SPABS
    changing
      !CV_KM type ZIO_KM .
  methods CALCULATE_AS_TIME
    importing
      !IV_BETRIEBSPUNKT type ZIO_5_BETRIEBSPUNKT
      !IV_SPERRABSCHNITT type ZIO_5_SPABS
      !IV_INTERVALLART type ZIO_5_INTERVALLART optional
      !IV_RICHTUNG type ZIO_5_RICHTUNG
    changing
      !CV_DATE type DATS
      !CV_TIME type TIMS .
  methods CALCULATE_AS_TIMES
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T
      !IS_INNER_SP_ZEITEN type ZIO_5_SP_ZEITEN optional .
  methods DELETE_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T optional .
  methods FUELLE_ARBEITSORT
    importing
      !IV_ID_ARBSORT type ZIO_ID_ARBSORT .
  methods FUELLE_ARBEITSORT_NEW
    importing
      !IS_AUFTRAG type ZIO_5_AUFTR .
  methods GET_DATETIME_FOR_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T
      !IV_RICHTUNG type ZIO_5_RICHTUNG
    exporting
      !EV_ZUGNUMMER type ZIO_ZUG_ID
      !EV_DATE type DATS
      !EV_TIME type TIMS .
  methods GET_KM_BIS_FOR_CALC
    importing
      !IV_RICHTUNG type ZIO_5_RICHTUNG
    returning
      value(RV_VALUE) type ZIO_KM .
  methods GET_KM_VON_FOR_CALC
    importing
      !IV_BETRIEBSPUNKT type ZIO_5_BETRIEBSPUNKT
      !IV_SPERRABSCHNITT type ZIO_5_SPABS
      !IV_RICHTUNG type ZIO_5_RICHTUNG
    returning
      value(RV_VALUE) type ZIO_KM .
  methods GET_MIN_KM_FOR_CALC
    importing
      !IV_RICHTUNG type ZIO_5_RICHTUNG
    returning
      value(RV_VALUE) type ZIO_5_ZEITABZUG_PRO_KM_FS .
  methods GET_SPERRABSCHNITTE_RANGE
    returning
      value(RT_RANGE) type ZIO_5_SPABSCH_RANGE_T .
  methods GET_SP_KTEXT_TAB
    exporting
      value(ET_DATA) type TTY_SP_KTEXT .
  methods GET_SP_ZEITEN_TAB
    returning
      value(RT_DATA) type TTY_SP_ZEITEN_TAB .
  methods GET_TRASSE_DATA_FOR_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T
      !IV_RICHTUNG type ZIO_5_RICHTUNG
      !IV_INTERVALLART type ZIO_5_INTERVALLART optional
    exporting
      !EV_BETRIEBSPUNKT type ZIO_5_BETRIEBSPUNKT
      !EV_DATE type DATS
      !EV_TIME type TIMS .
  methods INSERT_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T .
  methods REFRESH_AUSDEHNUNG_MET .
  methods REFRESH_FAHRLEITUNGSSCHALTUNG .
  methods REFRESH_SPERRAS_AUSDEHNUNG
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
      !IO_AUFTRAG type ref to ZCL_IO_5_AUFTRAG .
  methods REMOVE_SP
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID .
  methods SELECT_SP_SCHICHT
    importing
      !IV_SPERRAS_ID type ZIO_5_SPERRAS_ID
    returning
      value(RS_VALUE) type ZIO_5_SP_SCHICHT .
  methods SET_ZUGNUMMER_FROM_EZ_FORM
    importing
      !IT_EZ_FORM type ZIO_5_EZ_FORM_T
      !IV_CALLED_FROM type ZIO_5_TREMOLA_CALLED_FROM optional .
  methods UPDATE_ZEITEN_FROM_SPABSID .
  methods UPDATE_ZUGNUMMER .
ENDCLASS.



CLASS ZCL_IO_5_ARBEITSSTELLE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IO_5_AUFTRAG(optional)
* | [--->] IS_AUFTRAG                     TYPE        ZIO_5_AUFTR(optional)
* | [--->] IV_AUFNR                       TYPE        AUFNR(optional)
* | [--->] IV_TESTRUN                     TYPE        BOOLEAN(optional)
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN(optional)
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN(optional)
* | [--->] IV_SKIP_VALIDATIONS            TYPE        BOOLEAN(optional)
* | [--->] IV_FIRST_ORDER                 TYPE        BOOLEAN(optional)
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_auftrag_o.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung:
*
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Thomas Frick
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        16.09.2019  SBB/Holger Pluschke
*         Erstellung
*----------------------------------------------------------------------*



    DATA: lo_auftrag        TYPE REF TO zcl_io_5_auftrag,
          lt_einzelkapas    TYPE zio_5_einzelkapas_t,
          ls_einzelkapa     TYPE zio_5_ez_kapas,
          lo_fahrzeuge      TYPE REF TO cl_object_map,
          lo_fahrzeuge_i    TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug       TYPE REF TO zcl_io_5_fahrzeug,
          lo_sitzplatz      TYPE REF TO zcl_io_5_sitzplatz,
          lv_is_valid       TYPE boolean,
          lv_has_errors     TYPE boolean,
          lv_critical_error TYPE boolean,
          lo_fehler         TYPE REF TO zcx_io_5_fehler.

    IF is_auftrag IS NOT INITIAL.
      DATA(ls_auftrag) = is_auftrag.
      lo_auftrag = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).
    ELSEIF io_order IS NOT INITIAL.
      ls_auftrag = io_order->get_data( ).
      lo_auftrag ?= io_order.
    ELSEIF iv_aufnr IS NOT INITIAL.
      SELECT SINGLE * FROM zio_5_auftr INTO @ls_auftrag WHERE aufnr = @iv_aufnr.
      lo_auftrag = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).
    ELSE.
      EXIT.
    ENDIF.

    " Auftrag can be added only if it is not already assigned to this Arbeitsstelle
    CHECK NOT has_auftrag( lo_auftrag->get_data( )-aufnr ).

    zcl_io_message_manager=>get_instance( )->add_message(  EXPORTING iv_msgid = 'ZIO_3_MMT'  iv_msgno = 96  iv_msgty = 'I' iv_msgv3 = ls_auftrag-aufnr ).
    "=============== Prüfe Auftrag &1 ===============

    "Indikator setzen, ob es sich um eine Planung OS handelt oder Tunnel.
    "Falls dieses Flag gesetzt ist, werden verschiedenste Prüfungen, die für die OS nicht benötigt werden, ignoriert.
    DATA(lv_planung_os) = COND #( WHEN me->is_in_tunnel( ) EQ abap_false THEN abap_true ELSE abap_false ).
    DATA(lv_planung_btg) = COND #( WHEN lo_auftrag->get_data( )-zstdkz EQ 'G' THEN abap_true ELSE abap_false ).


    "*******************
    "* Begin
    "***************
    IF iv_skip_validations = abap_false.
      "Die Prüfung, ob die Sperrabschnitte vom Auftrag zum Schichtcustomizing passen,
      "sollte ausserhalbt dieser Methode gemacht werden.

      "Lesen der Kombinationen Sperrabschnitte/Intervallart am Auftrag
      DATA(lt_auftrag_sp_intvart) = lo_auftrag->get_sp_intvart( iv_ts_est = me->mo_schicht->get_ts_est( )
                                                                iv_rj_est = me->mo_schicht->get_rj_est( ) ).
      LOOP AT lt_auftrag_sp_intvart ASSIGNING FIELD-SYMBOL(<ls_auftrag_sp_intvart>).

        "Lesen der Kombinationen Sperrabschnitte/Intervallart an der Schicht
        IF <ls_auftrag_sp_intvart>-zintervallart = 'TS'.
          READ TABLE  me->get_schicht( )->get_sp_schicht( ) WITH KEY zintervallart  = <ls_auftrag_sp_intvart>-zintervallart INTO DATA(ls_sp_schicht).
        ELSE.
          READ TABLE  me->get_schicht( )->get_sp_schicht( ) WITH KEY sperrabschnitt = <ls_auftrag_sp_intvart>-sperrabschnitt
                                                                     zintervallart  = <ls_auftrag_sp_intvart>-zintervallart INTO ls_sp_schicht.
        ENDIF.
        IF syst-subrc EQ 0.

          "Ist denn der Sperrabschnitt schon auf der Arbeitsstelle vorhande?
          READ TABLE me->mt_map_as_szg WITH KEY sperras_id  = ls_sp_schicht-sperras_id "TRANSPORTING NO FIELDS.
                                                zugangsart  = lo_auftrag->get_data( )-zzzugangsart TRANSPORTING NO FIELDS.

          IF syst-subrc NE 0.
            "Neuen Sperrabschnitt der Arbeitsstelle hinzufügen
            me->add_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                        iv_zugangsart =  lo_auftrag->get_data( )-zzzugangsart ).

            me->set_inital_ausdehnung_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                                          io_auftrag    = lo_auftrag ).

          ENDIF.
        ENDIF.
      ENDLOOP.



      "Prüfe, ob Querschläge die richtige Kilometrierung haben wie in Tabelle ZIO_QUERSCHLAEGE
      IF zcl_io_5_regeln=>check_quer_km( EXPORTING is_auftrag = ls_auftrag io_arbeitsstelle = me ) = abap_false.
        IF iv_auto_planning = abap_true. refresh_sa_sp( ). RETURN. ELSE. lv_has_errors = abap_true. ENDIF.
      ENDIF.


*****      " Prüfe, ob Eckstart und -ende des Auftrages zur Schicht passen
      IF zcl_io_5_regeln=>check_datum( io_arbeitsstelle = me  is_auftrag = ls_auftrag ) = abap_false.
        IF iv_auto_planning = abap_true. RETURN. ELSE. lv_has_errors = abap_true.  lv_is_valid = abap_true. ENDIF.
      ENDIF.

*      " Prüfe auf die max. zulässigen Signalabschnitte
*      IF zcl_io_5_regeln=>is_regel_aktiv( iv_regel = 104 iv_auto_planning = iv_auto_planning iv_offene_strecke = lv_planung_os ) = abap_true
*         AND iv_first_order = abap_false AND lv_planung_os EQ abap_false.
**        AND NOT ( zcl_io_regeln=>is_regel_pflicht( iv_regel = 104 ) = abap_false AND iv_ignore_errors = abap_true ).
      "*******************
      "* Prüfe auf die max. zulässigen Signalabschnitte einer Arbeitsstelle
      "***************
      IF lv_planung_btg EQ abap_false AND
         lv_planung_os  EQ abap_false AND
         zcl_io_5_regeln=>check_as_ausdehnung( io_arbeitsstelle = me  io_auftrag = lo_auftrag ) = abap_false.
        IF iv_auto_planning = abap_true. refresh_sa_sp( ). RETURN. ELSE. IF iv_first_order = abap_true. RETURN. ENDIF. lv_has_errors = abap_true. ENDIF.
      ENDIF.


      "*******************
      "* Leere Signalabschnitte zwischen Arbeitsstellen
      "* Für BTG's wird diese Regel nicht angewendet
      "***************
      IF lv_planung_btg EQ abap_false AND
         "lv_planung_os  EQ abap_false AND
         zcl_io_5_regeln=>check_sa_gap( io_arbeitsstelle = me io_auftrag = lo_auftrag ) = abap_false.
        IF iv_auto_planning = abap_true. RETURN. ELSE. lv_has_errors = abap_true. ENDIF.

        lv_has_errors = abap_true.
        RETURN.
      ENDIF.

      " Hole Fahrzeuge zum Auftrag
      IF ls_auftrag-zzzugangsart = 1."*    IF me->is_schiene( ) EQ abap_true.
        IF zcl_io_5_regeln=>get_fahrzeuge( EXPORTING io_arbeitsstelle = me
                                                     iv_vorschau = iv_vorschau
                                                     io_auftrag = lo_auftrag
                                                     iv_ignore_errors = iv_ignore_errors
                                           IMPORTING eo_fahrzeuge = lo_fahrzeuge ) = abap_false
                                                              AND iv_ignore_errors = abap_false
                                                              AND lv_planung_os    = abap_false.
          IF iv_auto_planning = abap_true. refresh_sa_sp( ). RETURN. ELSE. lv_has_errors = abap_true. ENDIF.
        ENDIF.
      ENDIF.


      "*******************
      "* Begin neues zeugs
      "***************


      DATA(lv_fzg_vorhanden) = abap_false.
      lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        CASE ls_auftrag-zzzugangsart.
          WHEN zcl_io_5_auftrag=>mc_zgart_schiene.
            IF lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_false.
              lv_fzg_vorhanden = abap_true.
            ELSE.
              CONTINUE.
            ENDIF.
          WHEN zcl_io_5_auftrag=>mc_zgart_pneu.
            IF lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true.
              lv_fzg_vorhanden = abap_true.
            ELSE.
              CONTINUE.
            ENDIF.
        ENDCASE.

      ENDWHILE.


      IF lv_fzg_vorhanden = abap_false.
        zcl_io_5_regeln=>get_basis_fahrzeug( EXPORTING io_arbeitsstelle = me
                                                       iv_ignore_errors = abap_true
                                                       io_auftrag       = lo_auftrag
                                             IMPORTING eo_fahrzeuge     = DATA(lo_basis_fzg) ).

        me->add_fahrzeuge( EXPORTING io_objects = lo_basis_fzg
                                     iv_vorschau = iv_vorschau ).
      ENDIF.


      "***************
      "* Ende neues zeugs
      "*******************





      " Prüfe die Einzelkapazitäten "Nur im Tunnel
      lv_is_valid = zcl_io_5_regeln=>check_auf_einzelkapas( EXPORTING is_auftrag        = ls_auftrag
                                                                      io_arbeitsstelle  = me
                                                                      iv_ignore_errors  = iv_ignore_errors
                                                            IMPORTING et_einzelkapas    = lt_einzelkapas
                                                                      ev_critical_error = lv_critical_error ).
      IF lv_critical_error = abap_true.
        rv_success = abap_false.
        refresh_sa_sp( ).
        RETURN.
      ENDIF.

      IF lv_is_valid = abap_false AND iv_auto_planning = abap_true.
        IF iv_auto_planning = abap_true. refresh_sa_sp( ). RETURN. ELSE. lv_has_errors = abap_true. ENDIF.
      ENDIF.

    ENDIF.



    "***************
    "* Ende
    "*******************




    " Einzelkapas sperren
    LOOP AT lt_einzelkapas INTO ls_einzelkapa.
      " Durchlaufe alle Fahrzeuge
      lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
        lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
        CHECK lo_sitzplatz IS NOT INITIAL.
        TRY.
            lo_sitzplatz->lock( ).
          CATCH zcx_io_5_fehler INTO lo_fehler.
            RAISE EXCEPTION lo_fehler.
        ENDTRY.
      ENDWHILE.
    ENDLOOP.

    IF  iv_testrun = abap_false AND ( lv_has_errors = abap_false OR iv_ignore_errors = abap_true ). "iv_testrun = abap_false AND  lv_has_errors = abap_false



      "Fahrzeuge hinzzufügen
      IF lo_fahrzeuge IS NOT INITIAL.
        me->add_fahrzeuge( io_objects = lo_fahrzeuge ).
      ENDIF.

      " Auftrag hinzufügen
      me->mo_orders->put( EXPORTING key = lo_auftrag->get_data( )-aufnr   value = lo_auftrag ).
      lo_auftrag->set_schicht( iv_schicht = me->ms_arbeitsstelle-zschicht ).
      lo_auftrag->set_arbeitsstelle_id( iv_arbstl = me->ms_arbeitsstelle-zarbstl ).
*      lo_auftrag->set_arbstl_ri( iv_arbstl = me->ms_arbeitsstelle-zarbstl_ref ). ">001< INS LINE
      lo_auftrag->set_vorschau_flag( iv_vorschau = iv_vorschau ).

      " Arbstellen-Ausdehnung updaten
      IF iv_vorschau = abap_false.
        me->refresh_ausdehung( ).
      ENDIF.

      " EIZ + EST in Arbstelle updaten
      me->refresh_eiz_est( is_auftrag = ls_auftrag ).

      " Einzelkapas hinzufügen
      LOOP AT lt_einzelkapas INTO ls_einzelkapa.
        " Durchlaufe alle Fahrzeuge
        lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
        WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
          lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

          "Pneu Auftrag und das aktuelle Fahrzeug ist kein Pneufahrzeug => CONTINUE
          IF ls_auftrag-zzzugangsart = zcl_io_5_auftrag=>mc_zgart_pneu AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_false.
            CONTINUE.
          ENDIF.
          "Schienenauftrag und das aktuelle Fahrzeug ist ein Pneufahrzeug => CONTINUE
          IF ls_auftrag-zzzugangsart = zcl_io_5_auftrag=>mc_zgart_schiene AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true.
            CONTINUE.
          ENDIF.

          lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
          CHECK lo_sitzplatz IS NOT INITIAL.

          TRY.
              IF lo_sitzplatz->has_quali( ) = abap_false AND lo_auftrag->get_vorschau_flag( ) = abap_true.
                lo_sitzplatz->set_vorschau_flag( iv_vorschau = abap_true ).
              ENDIF.

              lo_sitzplatz->add_einzelkapazitaet_o( EXPORTING iv_ignore_errors = iv_ignore_errors   io_einzelkapa = lo_auftrag->get_einzelkapazitaet_o( iv_id_ek = ls_einzelkapa-zid_ek )  ).
            CATCH zcx_io_5_fehler INTO lo_fehler.
          ENDTRY.
          lo_auftrag->get_einzelkapazitaet_o( iv_id_ek = ls_einzelkapa-zid_ek )->set_error_flag( iv_flag = ls_einzelkapa-error_flag ).
        ENDWHILE.
      ENDLOOP.

******************      " Abhängige As hinzufügen
******************      me->get_schicht( )->add_arbeitsstellen( io_objects = lo_arbstellen_abh ).


********************************************************************************************************************************************
* OPTREAL-43: Manuelles planen von mehreren RJ-Arbeitsstellen an einem Ort
********************************************************************************************************************************************
      DATA(lt_messages) = zcl_io_message_manager=>get_instance( )->get_messages( ).

      READ TABLE lt_messages WITH KEY number = 100 type = 'W' TRANSPORTING NO FIELDS.
    ENDIF.

    " Einzelkapas entsperren
    LOOP AT lt_einzelkapas INTO ls_einzelkapa.
      lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
        lo_sitzplatz ?= lo_fahrzeug->get_sitzplaetze( )->get( key = ls_einzelkapa-zid_fzg_platz ).
        CHECK lo_sitzplatz IS NOT INITIAL.
        TRY.
            lo_sitzplatz->unlock( ).
          CATCH zcx_io_5_fehler INTO lo_fehler.
            RAISE EXCEPTION lo_fehler.
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
      DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.
      DATA(lo_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
      WHILE lo_sp_km_i->has_next( ) = abap_true.
        lo_sp_km ?= lo_sp_km_i->get_next( ).

        DATA(lv_sperras_id) = lo_sp_km->get_data( )-sperras_id.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUG                    TYPE REF TO ZCL_IO_5_FAHRZEUG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeug.

    me->mo_fahrzeuge->put( EXPORTING key = io_fahrzeug->get_data( )-zid_fzg   value = io_fahrzeug ).
    io_fahrzeug->set_arbeitsstelle( io_arbstelle = me ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* | [--->] IV_VORSCHAU                    TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeuge.

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.

    lo_fahrzeuge_i ?= io_objects->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_fahrzeug->set_vorschau_flag( iv_vorschau = iv_vorschau ).

      me->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_FAHRZEUGE_TYPES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fahrzeuge_types.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IO_5_ARBEITSSTELLE=>ADD_MIN_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIO_PRMTR
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_min_km.

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

    LOOP AT lt_km ASSIGNING FIELD-SYMBOL(<ls_km>).
      DATA(lv_dist) = <ls_km>-min_km - ls_km_prev-min_km.
      IF lv_dist > 2.
        <ls_min_km>-min_km = <ls_km>-min_km.
        RETURN.
      ENDIF.
      ls_km_prev = <ls_km>.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [--->] IV_ZUGANGSART                  TYPE        ZIO_ZUGANGSART
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Add SP
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >001<   7.5x        26.01.2024   SBB  / Piotr Stelmach (DXC)
*         6800034985, NES:JADE-871 Fehler Abzug der Ein-/Ausfa
*----------------------------------------------------------------------*

    SELECT SINGLE * FROM zio_5_sp_schicht INTO @DATA(ls_sp_schicht) WHERE sperras_id = @iv_sperras_id.
    DATA(ls_schicht) = mo_schicht->get_data( ). ">001< (+)
    "*******************
    "* Zeiten
    "***************
    DATA(ls_sp_zeiten) = VALUE zio_5_sp_zeiten( ).

    MOVE-CORRESPONDING ls_sp_schicht TO ls_sp_zeiten.
    ls_sp_zeiten-zarbstl = ms_arbeitsstelle-zarbstl.
    ls_sp_zeiten-sperras_id = ls_sp_schicht-sperras_id.

    ">001< (+) begin
    DATA(lo_abap_tstmp) = NEW cl_abap_tstmp( ).
    CONVERT DATE ls_schicht-start_datum TIME ls_schicht-start_zeit INTO TIME STAMP DATA(lv_tstamp) TIME ZONE sy-zonlo.
    DATA(lv_abzug) =  mo_schicht->get_parameter( )->get_data( )-abzug / 2 * 60.
    lv_tstamp = lo_abap_tstmp->add( EXPORTING tstmp = lv_tstamp    secs =  lv_abzug ).
    CONVERT TIME STAMP lv_tstamp TIME ZONE sy-zonlo INTO DATE ls_sp_zeiten-start_datum TIME ls_sp_zeiten-start_zeit.

    CONVERT DATE ls_schicht-end_datum TIME ls_schicht-end_zeit INTO TIME STAMP lv_tstamp TIME ZONE sy-zonlo.
    lv_abzug = mo_schicht->get_parameter( )->get_data( )-abzug / 2 * 60.
    lv_tstamp = lo_abap_tstmp->subtractsecs( EXPORTING tstmp = lv_tstamp    secs =  lv_abzug ).
    CONVERT TIME STAMP lv_tstamp TIME ZONE sy-zonlo INTO DATE ls_sp_zeiten-end_datum TIME ls_sp_zeiten-end_zeit.
    ">001< (+) end

    DATA(lo_sp_zeit) = zcl_io_5_sp_zeiten=>get_instance( ).
    lo_sp_zeit->set_data( is_data = ls_sp_zeiten ).

    add_sp_zeit( io_sp_zeit = lo_sp_zeit ).


    "*******************
    "* Kilomter
    "***************
    DATA(ls_sp_kilomter) = VALUE zio_5_sp_km( ).

    MOVE-CORRESPONDING ls_sp_schicht TO ls_sp_kilomter.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '1'
        object      = 'ZIO_GBT'
      IMPORTING
        number      = ls_sp_kilomter-sp_km_id.

    ls_sp_kilomter-zarbstl = me->ms_arbeitsstelle-zarbstl.
    DATA(lo_sp_km) = NEW zcl_io_5_sp_kilometer( ).
    lo_sp_km->set_data( is_data = ls_sp_kilomter ).
    lo_sp_km->set_schicht( me->mo_schicht ).

    me->add_sp_km( io_sp_km = lo_sp_km ).

    "*******************
    "* Mapping AS SP speichern
    "***************

    APPEND INITIAL LINE TO me->mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
    <ls_map_as_szg>-zarbstl = me->ms_arbeitsstelle-zarbstl.
    <ls_map_as_szg>-sperras_id = ls_sp_schicht-sperras_id.
    <ls_map_as_szg>-zugangsart = iv_zugangsart.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_SP_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SP_KM                       TYPE REF TO ZCL_IO_5_SP_KILOMETER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp_km.

    me->mo_sp_kilometer->put( EXPORTING key = io_sp_km->get_data( )-sperras_id   value = io_sp_km ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ADD_SP_ZEIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SP_ZEIT                     TYPE REF TO ZCL_IO_5_SP_ZEITEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sp_zeit.

    me->mo_sp_zeiten->put( EXPORTING key = io_sp_zeit->get_data( )-sperras_id   value = io_sp_zeit ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->ADJUST_KM_FOR_SPERRABSCHNITT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* | [<-->] CV_KM                          TYPE        ZIO_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD adjust_km_for_sperrabschnitt.

    DATA(lv_perimeter) = mo_schicht->get_data( )-zzperi.

    TRY .
        DATA(lv_min_km) = mt_min_km[ perimeter      = lv_perimeter
                                     sperrabschnitt = iv_sperrabschnitt ]-min_km.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    IF cv_km < lv_min_km.
      cv_km = lv_min_km.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->ARE_VEHICLES_REFERENCED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD are_vehicles_referenced.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Check if Versorgung Arbeitstelle is referenced
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL 2.0/ LI
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52       12.12.2023   DXC / Fatima De Villa
*         S 6800029711: NESJADE-720,785,714 Versorgungsschicht
*         - Methode Erstellung / Method Creation
*----------------------------------------------------------------------*

    DATA(lv_schicht_id) = me->mo_schicht->get_id( ).

    SELECT ref_fzg
       INTO @DATA(lv_v_ref_fzg)
       FROM zio_5_map_as_fz
       UP TO 1 ROWS
       WHERE ref_schicht = @lv_schicht_id
         AND ref_arbstl  = @me->ms_arbeitsstelle-zarbstl
         AND ref_fzg     NE @space.
    ENDSELECT.
    IF sy-subrc = 0.
      rv_value = abap_true.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->CALCULATE_AS_TIME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BETRIEBSPUNKT               TYPE        ZIO_5_BETRIEBSPUNKT
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* | [--->] IV_INTERVALLART                TYPE        ZIO_5_INTERVALLART(optional)
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [<-->] CV_DATE                        TYPE        DATS
* | [<-->] CV_TIME                        TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_as_time.

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

    DATA(lv_km_diff) = CONV zio_km( lv_km_bis - lv_km_von ).

    DATA(lv_sec) = CONV i( lv_km_diff * lv_sec_km ).

    lv_sec = COND #( WHEN iv_richtung = zif_io_5_trasse=>mc_richtung_ausfahrt THEN - lv_sec ELSE lv_sec ).

    TRY.
        cl_abap_tstmp=>td_add( EXPORTING date     = cv_date
                                         time     = cv_time
                                         secs     = lv_sec
                               IMPORTING res_date = cv_date
                                         res_time = cv_time ).
        zcl_io_5_utilities=>round_date_time_to_minute( CHANGING cv_date = cv_date
                                                                cv_time = cv_time ).

      CATCH cx_parameter_invalid_type cx_parameter_invalid_range.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->CALCULATE_AS_TIMES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* | [--->] IS_INNER_SP_ZEITEN             TYPE        ZIO_5_SP_ZEITEN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_as_times.
    FIELD-SYMBOLS <lv_time> TYPE zio_5_trassen-zab.

    DATA(lv_sperrabschnitt) = CONV zio_5_spabs( mo_schicht->get_rj_est( ) ).
    DATA(lv_date)           = mo_schicht->get_data( )-start_datum.
    DATA(lt_map_spabs)      = get_sperrabschnitte( iv_zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ).
    DATA(lt_sp_schicht)    = mo_schicht->get_sp_schicht( ).

    DATA(li_sp_zeiten_i) = mo_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_io_5_sp_zeiten( li_sp_zeiten_i->get_next( ) ).
      DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).

      ASSIGN lt_map_spabs[ sperras_id = ls_sp_zeiten-sperras_id ] TO FIELD-SYMBOL(<ls_map_spabs>).
      CHECK sy-subrc = 0.

      ASSIGN lt_sp_schicht[ sperras_id = <ls_map_spabs>-sperras_id ] TO FIELD-SYMBOL(<ls_sp_schicht>).
      CHECK sy-subrc = 0.

      "<-------- TS -------
      IF <ls_sp_schicht>-zintervallart = zcl_io_5_utilities=>mc_intervart_sp_ts.  "Set initial date (sp_schicht table)
        ls_sp_zeiten-start_datum = <ls_sp_schicht>-start_datum.
        ls_sp_zeiten-start_zeit  = <ls_sp_schicht>-start_zeit.
        ls_sp_zeiten-end_datum   = <ls_sp_schicht>-end_datum.
        ls_sp_zeiten-end_zeit    = <ls_sp_schicht>-end_zeit.
        lo_sp_zeiten->update_data( is_data = ls_sp_zeiten ).
        CONTINUE.
      ENDIF.

      DATA(lv_betriebspunkt) = CONV zio_5_betriebspunkt( '' ).

      "<-------- EINFAHRT -------
      IF line_exists( it_ez_form[ zarbstl = ms_arbeitsstelle-zarbstl richtung = 'E' ez_aktiv = abap_true ] ).
        get_trasse_data_for_ez_form( EXPORTING it_ez_form       = it_ez_form
                                               iv_richtung      = zif_io_5_trasse=>mc_richtung_einfahrt
                                     IMPORTING ev_betriebspunkt = lv_betriebspunkt
                                               ev_date          = ls_sp_zeiten-start_datum
                                               ev_time          = ls_sp_zeiten-start_zeit ).

        calculate_as_time( EXPORTING iv_betriebspunkt  = lv_betriebspunkt
                                     iv_sperrabschnitt = lv_sperrabschnitt
                                     iv_richtung       = zif_io_5_trasse=>mc_richtung_einfahrt
                           CHANGING  cv_date           = ls_sp_zeiten-start_datum
                                     cv_time           = ls_sp_zeiten-start_zeit ).
      ELSE.
        ls_sp_zeiten-start_datum = <ls_sp_schicht>-start_datum.
        ls_sp_zeiten-start_zeit  = <ls_sp_schicht>-start_zeit.
      ENDIF.

      "<-------- AUSFAHRT -------
      IF line_exists( it_ez_form[ zarbstl = ms_arbeitsstelle-zarbstl richtung = 'A' ez_aktiv = abap_true ] ).
        get_trasse_data_for_ez_form( EXPORTING it_ez_form       = it_ez_form
                                               iv_richtung      = zif_io_5_trasse=>mc_richtung_ausfahrt
                                     IMPORTING ev_betriebspunkt = lv_betriebspunkt
                                               ev_date          = ls_sp_zeiten-end_datum
                                               ev_time          = ls_sp_zeiten-end_zeit ).

        IF is_inner_sp_zeiten-zarbstl IS NOT INITIAL.
          ls_sp_zeiten-end_datum = is_inner_sp_zeiten-end_datum.
          ls_sp_zeiten-end_zeit  = is_inner_sp_zeiten-end_zeit.
        ENDIF.

        calculate_as_time( EXPORTING iv_betriebspunkt  = lv_betriebspunkt
                                     iv_sperrabschnitt = lv_sperrabschnitt
                                     iv_richtung       = zif_io_5_trasse=>mc_richtung_ausfahrt
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->CHECK_AS_IS_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_IS_TUNNEL                   TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_as_is_in_tunnel.
*--------------änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        10.08.2018  SBB AG / Fredy Villiger
*         QM900088053: ZSTDKZ = 'IS_IN_BTG' nicht beachten.
*----------------------------------------------------------------------*
* >002<   7.52        01.10.2018  SBB AG / Arlene Bucher
*         QM900088053: ZSTDKZ = 'IS_IN_BTG' beachten.
*                      BTG 'G' sind immer im Tunnel
*----------------------------------------------------------------------*

    "*******************
    "*
    "* wird ersetzt durch die Methode is_in_tunnel
    "*
    "***************


    rv_is_tunnel = abap_true.

*    IF ( ms_arbeitsstelle-zest EQ 'E' OR
*      ms_arbeitsstelle-zest EQ 'W' OR
*      ms_arbeitsstelle-zest EQ 'X' OR
*      ms_arbeitsstelle-zest EQ '2' ) OR " AND  " DEL >001<
*  "   ( is_in_btg( ) EQ abap_false ).        " DEL >001<
*      ( is_in_btg( ) EQ abap_true ).         " INS >002<
*      rv_is_tunnel = abap_true.
*    ELSE.
*      rv_is_tunnel = abap_false.
*    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IO_5_ARBEITSSTELLE=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.

    init_min_km( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->CLEAR_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CALLED_FROM                 TYPE        ZIO_5_TREMOLA_CALLED_FROM(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD clear_zugnummer.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Supply AS
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* >001<   7.52      27.01.2025   DXC / Piotr Stelmach
*         6800038063: NES:JADE-1027
*----------------------------------------------------------------------*
    CLEAR ms_arbeitsstelle-zid_zug.

    update_zugnummer( ).
    IF iv_called_from = 'POPUP_INIT'.   ">001< +
      update_zeiten_from_spabsid( ).
    ENDIF.                               ">001< +


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIO_ID(optional)
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    me->mo_orders = NEW cl_object_map( ).
    me->mo_fahrzeuge = NEW cl_object_map( ).
    me->mo_sp_zeiten = NEW cl_object_map( ).
    me->mo_sp_kilometer = NEW cl_object_map( ).

    me->mo_schicht = io_schicht.

    IF iv_id IS INITIAL. " Neue AS, hole Arbeitsstellen-ID
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr = '1'
          object      = 'ZIO_GBT'
        IMPORTING
          number      = me->ms_arbeitsstelle-zarbstl.
    ELSE. " Vorhandene AS, lese AS-Daten ein
      me->ms_arbeitsstelle-zarbstl = iv_id.
      me->reload( ).
    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->CONTAINS_MANUAL_SIGNALS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RESULT                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD CONTAINS_MANUAL_SIGNALS.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob die Arbeitsstelle manuelle Signale enthält
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      03.01.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*

    DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.

    DATA(lo_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE lo_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= lo_sp_km_i->get_next( ).
      DATA(lt_user_signals) = lo_sp_km->get_user_signals( ).
      IF lt_user_signals[] IS NOT INITIAL.
        rv_result = abap_true.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->DELETE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD delete_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Delete EZ Form
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      09.10.2020   DXC  / Thomas Frick
*         S 6800007557: 6800007439, 5787: IT-GC C
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      19.05.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-140
*         - Alte Logik zum falschen Löschen von Einträgen in der DB entfernen
*         - Manuell hinzugefügtes ez_form löschen, wenn es auch in Trassen gelöscht wird
*----------------------------------------------------------------------*
* >002<   7.51       02.09.2022   DXC Technology / Piotr Stelmach
*         S 6800032167  JADE-825: Delete Tremola with Richtung = Ausfhart
*         for Versorgung Schicht und Einfhart for Entsorgung Schicht
*----------------------------------------------------------------------*
* >003<   7.50      06.08.2023   DXC  / Piotr Stelmach
*        S 6800035273: NES:JADE-756 Manuelle Trass. MIT Tremola
*        After adding a manual entry, the previous entry was still active
*----------------------------------------------------------------------*

   DATA(lt_ez_form_db) = me->get_ez_form_db( ).
   LOOP AT lt_ez_form_db ASSIGNING FIELD-SYMBOL(<ls_ez_form_db>).
     "WHERE data_origin NE zif_io_5_constant=>mc_data_origin-tremola. "Change >001<  "Non-Tremola Entries = REAL/Manually Added ">003< -

     CHECK line_exists( it_ez_form[ zid_eiz     = <ls_ez_form_db>-zid_eiz
                                    richtung    = <ls_ez_form_db>-richtung
                                    data_origin = <ls_ez_form_db>-data_origin
                                    has_changed = abap_true
                                    ez_aktiv    = abap_false ] ) .  "check if the manual change was withdrawn

     DELETE FROM zio_5_ez_form
       WHERE zschicht    = @ms_arbeitsstelle-zschicht
         AND zarbstl     = @ms_arbeitsstelle-zarbstl
         AND zid_eiz     = @ms_arbeitsstelle-zid_eiz
         AND richtung    = @<ls_ez_form_db>-richtung
         AND data_origin = @<ls_ez_form_db>-data_origin.  "do not remove tremola

   ENDLOOP.
   ">002< + begin
   DATA(lv_richtung) = COND #( WHEN mo_schicht->is_versorgung_schicht( ) THEN zif_io_5_constant=>mc_richtung-ausfahrt
                               WHEN mo_schicht->is_entsorgung_schicht( ) THEN zif_io_5_constant=>mc_richtung-einfahrt ).
   IF lv_richtung IS NOT INITIAL.
     DELETE FROM zio_5_ez_form
      WHERE zschicht    = @ms_arbeitsstelle-zschicht
        AND zarbstl     = @ms_arbeitsstelle-zarbstl
        AND zid_eiz     = @ms_arbeitsstelle-zid_eiz
        AND richtung    = @lv_richtung.
   ENDIF.
   ">002< + end

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD exists.
    CHECK ms_arbeitsstelle-zarbstl IS NOT INITIAL.

    SELECT SINGLE zarbstl INTO @DATA(lv_id) FROM zio_5_arbstellen WHERE zarbstl = @ms_arbeitsstelle-zarbstl.

    rv_value = boolc( lv_id = ms_arbeitsstelle-zarbstl ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->FUELLE_ARBEITSORT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_ARBSORT                  TYPE        ZIO_ID_ARBSORT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fuelle_arbeitsort.
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        09.08.2018  SBB AG / Fredy Villiger
*         QM900088053: Feld ZSTDKZ beachten.
*----------------------------------------------------------------------*
* >002<   7.52      11.07.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-671
*         - Sperrabschnitt W, W1, W2 und W3 zulassen
*         - Sperrabschnitt E, E1, E2 und E3 zulassen
*----------------------------------------------------------------------*

    DATA: lt_auftraege   TYPE zio_5_auftr_t,
          lt_auftraege_p TYPE zio_auftraege_planung_t,
          ls_auftrag_p   LIKE LINE OF lt_auftraege_p,
          ls_arbsort     TYPE zio_arbsort.

    DATA: lv_km_min         TYPE zio_km,
          lv_km_max         TYPE zio_km,
          lv_km_first_order TYPE zio_km.

    lv_km_first_order =  me->get_auftrag( iv_index = 1 )->get_data( )-zzkmvpl.



    SELECT SINGLE * FROM zio_arbsort INTO ls_arbsort WHERE zarbsort = iv_id_arbsort.

    LOOP AT me->mt_auftraege_planung INTO DATA(ls_auftrag).
      DATA(lv_sp_not_found) = abap_false.
      DATA(lo_auftrag) = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).
      lo_auftrag->get_km_by_est( iv_est = me->mo_schicht->get_rj_est( ) ).



      "Sind die Sperrabschnitte vom Auftrag für die Schicht geplant?
*          TRY.
*              lo_auftrag->check_avaiable_sp_schicht( io_schicht = me ).
*            CATCH zcx_io_5_fehler INTO DATA(lo_exception).
**              wd_this->mo_message_manager->add_bapiret_t( it_table = lo_exception->get_bapiret( ) ).
**              wd_this->mo_message_manager->display_messages( ).
**              wd_this->mo_message_manager->reset( ).
*              CONTINUE.
*          ENDTRY.

      DATA(lt_sp_schicht) =  me->mo_schicht->get_sp_schicht( ).
      DELETE lt_sp_schicht WHERE zintervallart = 'TS'.
      LOOP AT lo_auftrag->get_sp( iv_rj_est = me->mo_schicht->get_rj_est( ) ) ASSIGNING FIELD-SYMBOL(<ls_sp>).
        READ TABLE lt_sp_schicht WITH KEY sperrabschnitt = <ls_sp>-sperrabschnitt TRANSPORTING NO FIELDS.
        IF syst-subrc NE 0. lv_sp_not_found = abap_true. EXIT. ENDIF.
      ENDLOOP.

      CHECK lv_sp_not_found EQ abap_false .
*      IF lv_sp_not_found = abap_true. CONTINUE. ENDIF.


      " Kilometrierung des Auftrages holen
      "IF ls_auftrag-zest = 'X'. "Röhrenunabhängige Aufträge, Kilometer muss evtl. gemappt werden                              " DEL >001<
      IF ls_auftrag-zzest = 'X' AND ls_auftrag-zstdkz NE 'G'. "Röhrenunabhängige Aufträge, Kilometer muss evtl. gemappt werden  " INS >001<
        SELECT SINGLE * FROM zio_5_mfs INTO @DATA(ls_mfs) WHERE zkm_mfs_von <= @ls_auftrag-zzkmvpl AND zkm_mfs_bis >= @ls_auftrag-zzkmvpl.

        "IF me->ms_arbeitsstelle-zest = 'E'.
*--> Begin Change >002<
        IF me->mo_schicht->get_rj_est( ) = mc_sperrabs-e  OR
           me->mo_schicht->get_rj_est( ) = mc_sperrabs-e1 OR
           me->mo_schicht->get_rj_est( ) = mc_sperrabs-e2 OR
           me->mo_schicht->get_rj_est( ) = mc_sperrabs-e3.
*--> End Change >002<
          IF ls_auftrag-zstdkz = 'Q'.
            lv_km_min = ls_auftrag-zzkmvpl.
            lv_km_max = ls_auftrag-zzkmbpl.
          ELSEIF ls_auftrag-zstdkz = 'M'.
            lv_km_min = ls_mfs-zkm_e.
            lv_km_max = ls_mfs-zkm_e.
          ENDIF.
*--> Begin Change >002<
        ELSEIF me->mo_schicht->get_rj_est( ) = mc_sperrabs-w  OR
               me->mo_schicht->get_rj_est( ) = mc_sperrabs-w1 OR
               me->mo_schicht->get_rj_est( ) = mc_sperrabs-w2 OR
               me->mo_schicht->get_rj_est( ) = mc_sperrabs-w3.
*--> End Change >002<
          IF ls_auftrag-zstdkz = 'Q'.
            SELECT SINGLE zkm_w FROM zio_5_querschl INTO lv_km_min WHERE zkm_e = ls_auftrag-zzkmbpl.
            lv_km_max = lv_km_min.
          ELSEIF ls_auftrag-zstdkz = 'M'.
            lv_km_min = ls_mfs-zkm_w.
            lv_km_max = ls_mfs-zkm_w.
          ENDIF.
        ENDIF.
      ELSE.
        lv_km_min =  ls_auftrag-zzkmvpl.
        lv_km_max = ls_auftrag-zzkmbpl.
      ENDIF.

      " Kilometrierung prüfen
      CHECK lv_km_min >= ls_arbsort-zkmin_erw AND lv_km_max <= ls_arbsort-zkmax_erw.

      "Distanz berechnen und zu Liste hinzufügen
      MOVE-CORRESPONDING ls_auftrag TO ls_auftrag_p.

      IF lv_km_min < lv_km_first_order.
        ls_auftrag_p-zdistanz = lv_km_first_order - lv_km_min.
      ELSE.
        ls_auftrag_p-zdistanz = lv_km_min - lv_km_first_order.
      ENDIF.

      APPEND ls_auftrag_p TO lt_auftraege_p. CLEAR ls_auftrag_p.

    ENDLOOP.

    " Aufträge nach distanz sortieren
    SORT lt_auftraege_p BY zdistanz.

    " Aufträge zum Arbeitsort hinzufügen
    LOOP AT lt_auftraege_p INTO ls_auftrag_p.
      MOVE-CORRESPONDING ls_auftrag_p TO ls_auftrag.
      TRY .
          me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true ).
          DELETE me->mt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr.
        CATCH zcx_io_fehler.
      ENDTRY.

      CLEAR: ls_auftrag.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->FUELLE_ARBEITSORT_NEW
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIO_5_AUFTR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fuelle_arbeitsort_new.
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        09.08.2018  SBB AG / Fredy Villiger
*         QM900088053: Feld ZSTDKZ beachten.
*----------------------------------------------------------------------*

    DATA: lt_auftraege   TYPE zio_5_auftr_t,
          lt_auftraege_p TYPE zio_5_auftrag_planung_t.
*          ls_auftrag_p   LIKE LINE OF lt_auftraege_p.
    "*******************
    "* Wir wollen den Arbeitsort füllen
    "***************

    "Der Übergebene Auftrag gibt den Arbeitsort vor
    DATA(lo_auftrag_arbeitsort) = NEW zcl_io_5_auftrag( iv_aufnr = is_auftrag-aufnr ).
    DATA(ls_ausdehnung_arbeitsort) = lo_auftrag_arbeitsort->get_km_by_est( iv_est = me->get_schicht( )->get_rj_est( ) ).

    LOOP AT me->mt_auftraege_planung INTO DATA(ls_auftrag).

      "um diese Kilometerierung herum werden die Aufträge gesucht.

      DATA(lo_auftrag) = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).
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
          me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true ).
          DELETE me->mt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr.
        CATCH zcx_io_fehler.
      ENDTRY.

      CLEAR: ls_auftrag.
    ENDLOOP.





*    DATA: lt_auftraege   TYPE zio_5_auftr_t,
*          lt_auftraege_p TYPE zio_auftraege_planung_t,
*          ls_auftrag_p   LIKE LINE OF lt_auftraege_p,
*          ls_arbsort     TYPE zio_arbsort.
*
*    DATA: lv_km_min         TYPE zio_km,
*          lv_km_max         TYPE zio_km,
*          lv_km_first_order TYPE zio_km.
*
*    lv_km_first_order =  me->get_auftrag( iv_index = 1 )->get_data( )-zzkmvpl.
*
*
*
*    SELECT SINGLE * FROM zio_arbsort INTO ls_arbsort WHERE zarbsort = iv_id_arbsort.
*
*    LOOP AT me->mt_auftraege_planung INTO DATA(ls_auftrag).
*      DATA(lv_sp_not_found) = abap_false.
*      DATA(lo_auftrag) = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).
*      lo_auftrag->get_km_by_est( iv_est = me->mo_schicht->get_rj_est( ) ).
*
*
*
*      "Sind die Sperrabschnitte vom Auftrag für die Schicht geplant?
**          TRY.
**              lo_auftrag->check_avaiable_sp_schicht( io_schicht = me ).
**            CATCH zcx_io_5_fehler INTO DATA(lo_exception).
***              wd_this->mo_message_manager->add_bapiret_t( it_table = lo_exception->get_bapiret( ) ).
***              wd_this->mo_message_manager->display_messages( ).
***              wd_this->mo_message_manager->reset( ).
**              CONTINUE.
**          ENDTRY.
*
*      DATA(lt_sp_schicht) =  me->mo_schicht->get_sp_schicht( ).
*      DELETE lt_sp_schicht WHERE zintervallart = 'TS'.
*      LOOP AT lo_auftrag->get_sp( iv_rj_est = me->mo_schicht->get_rj_est( ) ) ASSIGNING FIELD-SYMBOL(<ls_sp>).
*        READ TABLE lt_sp_schicht WITH KEY sperrabschnitt = <ls_sp>-sperrabschnitt TRANSPORTING NO FIELDS.
*        IF syst-subrc NE 0. lv_sp_not_found = abap_true. EXIT. ENDIF.
*      ENDLOOP.
*
*      CHECK lv_sp_not_found EQ abap_false .
**      IF lv_sp_not_found = abap_true. CONTINUE. ENDIF.
*
*
*      " Kilometrierung des Auftrages holen
*      "IF ls_auftrag-zest = 'X'. "Röhrenunabhängige Aufträge, Kilometer muss evtl. gemappt werden                              " DEL >001<
*      IF ls_auftrag-zzest = 'X' AND ls_auftrag-zstdkz NE 'G'. "Röhrenunabhängige Aufträge, Kilometer muss evtl. gemappt werden  " INS >001<
*        SELECT SINGLE * FROM zio_5_mfs INTO @DATA(ls_mfs) WHERE zkm_mfs_von <= @ls_auftrag-zzkmvpl AND zkm_mfs_bis >= @ls_auftrag-zzkmvpl.
*
*        "IF me->ms_arbeitsstelle-zest = 'E'.
*        IF me->mo_schicht->get_rj_est( ) = 'E'.
*          IF ls_auftrag-zstdkz = 'Q'.
*            lv_km_min = ls_auftrag-zzkmvpl.
*            lv_km_max = ls_auftrag-zzkmbpl.
*          ELSEIF ls_auftrag-zstdkz = 'M'.
*            lv_km_min = ls_mfs-zkm_e.
*            lv_km_max = ls_mfs-zkm_e.
*          ENDIF.
*        ELSEIF me->mo_schicht->get_rj_est( ) = 'W'.
*          IF ls_auftrag-zstdkz = 'Q'.
*            SELECT SINGLE zkm_w FROM zio_5_querschl INTO lv_km_min WHERE zkm_e = ls_auftrag-zzkmbpl.
*            lv_km_max = lv_km_min.
*          ELSEIF ls_auftrag-zstdkz = 'M'.
*            lv_km_min = ls_mfs-zkm_w.
*            lv_km_max = ls_mfs-zkm_w.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        lv_km_min =  ls_auftrag-zzkmvpl.
*        lv_km_max = ls_auftrag-zzkmbpl.
*      ENDIF.
*
*      " Kilometrierung prüfen
*      CHECK lv_km_min >= ls_arbsort-zkmin_erw AND lv_km_max <= ls_arbsort-zkmax_erw.
*
*      "Distanz berechnen und zu Liste hinzufügen
*      MOVE-CORRESPONDING ls_auftrag TO ls_auftrag_p.
*
*      IF lv_km_min < lv_km_first_order.
*        ls_auftrag_p-zdistanz = lv_km_first_order - lv_km_min.
*      ELSE.
*        ls_auftrag_p-zdistanz = lv_km_min - lv_km_first_order.
*      ENDIF.
*
*      APPEND ls_auftrag_p TO lt_auftraege_p. CLEAR ls_auftrag_p.
*
*    ENDLOOP.
*
*    " Aufträge nach distanz sortieren
*    SORT lt_auftraege_p BY zdistanz.
*
*    " Aufträge zum Arbeitsort hinzufügen
*    LOOP AT lt_auftraege_p INTO ls_auftrag_p.
*      MOVE-CORRESPONDING ls_auftrag_p TO ls_auftrag.
*      TRY .
*          me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true ).
*          DELETE me->mt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr.
*        CATCH zcx_io_fehler.
*      ENDTRY.
*
*      CLEAR: ls_auftrag.
*    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->FUELLE_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MAX_AUSLASTUNG              TYPE        ZIO_AUSLASTUNG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fuelle_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: Testprogramm für die Klasse ZCL_IO_JOBPOOL_MMT.
*               Nach der Abnahme im I02 muss es gelöscht werden.
*
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Rolf Wahle
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        05.02.2018  Q-Perior / Ismail Demiralp
*         "Auftag wird manchmal nicht gefunden und erzeugt einen DUMP
*----------------------------------------------------------------------*



    me->mt_auftraege_planung =  me->get_auftraege_planung( ).

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
    LOOP AT me->mt_auftraege_planung INTO DATA(ls_auftrag).
      TRY .
          me->add_auftrag_o( is_auftrag = ls_auftrag     iv_auto_planning = abap_true ).
          IF ls_auftrag-zstdkz = 'Q' OR ls_auftrag-zstdkz = 'M'.

            "Arbeitsort auffüllen
            me->fuelle_arbeitsort_new( is_auftrag = ls_auftrag ).
          ENDIF.
          DELETE me->mt_auftraege_planung WHERE aufnr = ls_auftrag-aufnr.
        CATCH zcx_io_fehler.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_AL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIO_5_FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_al.

    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_io_5_sitzplatz( lo_sitzplaetze_i->get_next( ) ).

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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_ANZAHL_QUAL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TTY_ANZAHL_QUAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_anzahl_qual.
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Anzahl Qualifikation
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : BAUN-259
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by:
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       22.11.2021   DXC / Piotr Stelmach
*         Programmerstellung/creation of program
*         6800015680 JADE-101
*----------------------------------------------------------------------*
    DATA(lt_ekapas)  = VALUE zio_5_einzelkapas_t( ).

    DATA(lt_ekapas_ref) = me->get_einzelkapas_ref( ).
    lt_ekapas       = VALUE #( BASE lt_ekapas FOR lS_ekapa_ref IN lt_ekapas_ref ( ls_ekapa_ref-object->get_data( ) ) ).
    DATA(lt_aufk)   = zcl_io_5_auftraege_utils=>get_aufk( me->get_auftraege( ) ).
    DATA(lt_fplatz) = VALUE tty_fplatz( FOR GROUPS val_fp OF line IN lt_ekapas GROUP BY line-zid_fzg_platz WITHOUT MEMBERS ( val_fp ) ).

    SORT lt_ekapas BY zid_fzg_platz.
    LOOP AT lt_fplatz ASSIGNING FIELD-SYMBOL(<ls_fplatz>).

      DATA(lv_counter) = VALUE i( ).
      DATA(lv_total)   = VALUE zio_5_anzahl_qual( ).
      LOOP AT lt_ekapas ASSIGNING FIELD-SYMBOL(<ls_ekapas>) WHERE zid_fzg_platz = <ls_fplatz>.

        lv_counter = lv_counter + 1.
        DATA(lv_fp_lines) = lines( VALUE tty_fplatz( FOR line IN lt_ekapas WHERE ( zid_fzg_platz = <ls_ekapas>-zid_fzg_platz ) ( line-zid_fzg_platz ) ) ).
        DATA(ls_aufk)     = VALUE #( lt_aufk[ aufnr = <ls_ekapas>-aufnr ] OPTIONAL ).

        ASSIGN rt_data[ aufnr = <ls_ekapas>-aufnr ] TO FIELD-SYMBOL(<ls_data>).
        IF sy-subrc <> 0.
          APPEND VALUE #( aufnr = <ls_ekapas>-aufnr
                          er_ir = COND #( WHEN ls_aufk-zzilart <> 'IC'
                                          THEN 'ER'
                                          ELSE 'IR'  ) ) TO rt_data ASSIGNING <ls_data>.
        ENDIF.

        <ls_data>-anzahl_qual = <ls_data>-anzahl_qual + ( 1 / lv_fp_lines ).  "Auftrag Anzahl
        lv_total = lv_total + ( 1 / lv_fp_lines ).                            "Quali Anzahl - max. 1

        IF lv_counter = lv_fp_lines AND lv_total <> 1.
*         "Round Anzahl of the last Auftrag in Quali group - Quali Anzahl must be = 1
          <ls_data>-anzahl_qual = <ls_data>-anzahl_qual + ( 1 - lv_total ).
        ENDIF.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_ARBEITSZEIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIO_5_ARBSTELLE_ZEIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_arbeitszeit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Arbeitszeit
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50      07.07.2020   SBB   / Holger Pluschke
*         S 6800003177: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.50      12.04.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-671
*         - Hinzufügen Langintervall und nur erste Buchstabe der
*           Sperrabschnitt verwenden
*----------------------------------------------------------------------*
    DATA lo_sp_zeit       TYPE REF TO zcl_io_5_sp_zeiten.
    DATA(lv_time_sec_new)  = VALUE   i( ).
    DATA(lv_time_sec_curr) = VALUE   i( ).


    DATA(lt_sp_zeiten) = me->get_sp_zeiten_tab( ).
    IF lt_sp_zeiten IS INITIAL.
      RETURN.
    ENDIF.
*--> Begin Change >001<
    IF line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'E' ] ) OR
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
        lo_sp_zeit ?=  me->mo_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
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

        lo_sp_zeit ?= me->mo_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_AUFTRAEGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_FILTER                      TYPE        ZIO_5_AUFTR(optional)
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftraege.

    DATA: lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag   TYPE REF TO zcl_io_5_auftrag.


    IF is_filter IS NOT INITIAL.
      lo_aufttag_i ?= mo_orders->get_values_iterator( ).
      CREATE OBJECT ro_objects.

      WHILE lo_aufttag_i->has_next( ) = abap_true.
        lo_auftrag ?= lo_aufttag_i->get_next( ).

*        IF is_filter-zplatznr IS NOT INITIAL. CHECK lo_auftrag->get_data( )-zplatznr = is_filter-zplatznr. ENDIF.

        ro_objects->put( EXPORTING key = lo_auftrag->get_data( )-aufnr value = lo_auftrag ).

      ENDWHILE.
    ELSE.
      ro_objects = me->mo_orders.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_AUFTRAEGE_PLANUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KM_MIN                      TYPE        ZIO_KM(optional)
* | [--->] IV_KM_MAX                      TYPE        ZIO_KM(optional)
* | [<-()] RT_AUFTRAEGE                   TYPE        ZIO_5_AUFTRAEGE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_auftraege_planung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Auftraege Planung
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50      27.11.2020   SBB   / Thomas Frick
*         S 6800007835: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      11.07.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-671
*         - Sperrabschnitt W, W1, W2 und W3 zulassen
*----------------------------------------------------------------------*
* >002<   7.52       07.07.2025   DXC / Piotr Stelmach
*         6800040745: NES:JADE-1234 Automatische SchichtplaN
*----------------------------------------------------------------------*

**************************************************************************************************************
* Slektiere passende Aufträge aus der DB
**************************************************************************************************************
    DATA: lt_auftraege TYPE zio_5_auftr_t,
          ls_auftrag   TYPE zio_5_auftr,
*          lo_auftrag   TYPE REF TO zcl_io_5_auftrag.
          lt_ra_est    TYPE zio_range_string_t,
          lt_ra_eiz    TYPE zio_range_string_t.
    FIELD-SYMBOLS: <ls_auftrag>     LIKE LINE OF lt_auftraege.

*    lt_ra_est = me->get_ra_est( ).
*    lt_ra_eiz = me->get_ra_eiz( ).

    DATA(lo_schichtparameter) = NEW zcl_io_5_parameter( iv_schicht   = me->ms_arbeitsstelle-zschicht ).

    DATA(ls_intervall) = me->get_schicht( )->get_planungsintervall( ).

*******    SELECT * FROM zio_5_auftr INTO TABLE lt_auftraege
*******      WHERE zschicht = '0'
*******      AND ( ( zfix = '' AND NOT ( gstrp > ms_arbeitsstelle-end_datum OR gltrp < ms_arbeitsstelle-start_datum ) ) "reguläre Aufträge
*******            OR ( ( zfix = 'X' AND gstrp = ls_intervall-gstrp AND gsuzp >= ls_intervall-gsuzp ) OR (  zfix = 'X' AND gstrp = ls_intervall-gltrp AND gsuzp < ls_intervall-gluzp ) ) ) "Fixterminauftrag
*******      AND zstatus <> 'E'
*******        AND zzzugangsart = '1'
*******        AND zstdkz <> 'G'
*******      AND zintervall <> 'TS'
********      AND zest IN lt_ra_est "( zid_est = ms_arbeitsstelle-zid_est OR zid_est = '0')
********      AND zid_eiz IN lt_ra_eiz "( zid_eiz = ms_arbeitsstelle-zid_eiz OR zid_eiz = '0')
*******      ORDER BY zpprio ASCENDING.

    DATA(lv_schicht) = me->mo_schicht->get_data( )-zschicht.
    DATA(lv_id_eiz) = me->ms_arbeitsstelle-zid_eiz.
    DATA(lv_perimeter) = me->mo_schicht->get_data( )-zzperi.
    "Hole passende Aufträge
    SELECT auftr~* FROM zio_5_v_schicht AS s
             INNER JOIN zio_5_v_auftr AS a ON s~zzperi = a~zzperi
                                          AND (   s~eckstart BETWEEN a~eckstart AND a~eckende
                                               OR s~eckende BETWEEN a~eckstart AND a~eckende )
             INNER JOIN zio_5_auftr AS auftr ON auftr~aufnr = a~aufnr
             INNER JOIN zix_aufk_ext_sp AS sp ON sp~aufnr = a~aufnr
                                             "AND ( sp~sperrabschnitt = 'E' OR sp~sperrabschnitt = 'X' )
    WHERE s~zschicht = @lv_schicht
      AND ( auftr~zstdkz <> 'G' AND auftr~zstdkz <> 'O' )
      AND auftr~zzzugangsart = '1'
      AND ( auftr~zid_eiz = @lv_id_eiz OR auftr~zid_eiz = 0 )
      AND auftr~zzperi = @lv_perimeter
      AND auftr~zschicht = 0
      AND auftr~zarbstl = 0
      AND auftr~zintervall <> 'TS'
      AND auftr~zintervall <> 'LI'  ">002< (+)
    ORDER BY zpprio ASCENDING
    INTO TABLE @lt_auftraege.


    DATA(lt_sp_schicht) =  me->mo_schicht->get_sp_schicht( ).
    DELETE lt_sp_schicht WHERE zintervallart = 'TS'.
    LOOP AT lt_auftraege INTO ls_auftrag.
      DATA(lv_sp_not_found) = abap_false.
      DATA(lo_auftrag) = NEW zcl_io_5_auftrag( iv_aufnr = ls_auftrag-aufnr ).



      LOOP AT lo_auftrag->get_sp( iv_rj_est = me->mo_schicht->get_rj_est( ) ) ASSIGNING FIELD-SYMBOL(<ls_sp>).
        READ TABLE lt_sp_schicht WITH KEY sperrabschnitt = <ls_sp>-sperrabschnitt TRANSPORTING NO FIELDS.
        IF syst-subrc NE 0. DELETE lt_auftraege WHERE aufnr = ls_auftrag-aufnr. EXIT. ENDIF.
      ENDLOOP.



    ENDLOOP.

**************************************************************************************************************
* Wenn keine Ausdehnung übergeben wird, dann berechne die maximal mögliche Ausdehnung der AS (von KM, bis KM)
**************************************************************************************************************
    DATA: lv_max_sa TYPE i,
          lt_sa     TYPE TABLE OF zio_5_sa,
          ls_sa     TYPE zio_5_sa,
          lv_km     TYPE zio_km,
          lv_km_von TYPE zio_km,
          lv_km_bis TYPE zio_km,
          lv_index  TYPE i,
          lv_lines  TYPE i.


    IF iv_km_min IS NOT INITIAL OR iv_km_max IS NOT INITIAL.
      lv_km_von = iv_km_min.
      lv_km_bis = iv_km_max.
    ELSE.

      lv_max_sa = me->get_schicht( )->get_parameter( )->get_data( )-max_ausdehnung.
      DATA(lv_est) = me->mo_schicht->get_rj_est( ).
      SELECT * FROM zio_5_sa INTO TABLE @lt_sa WHERE zest = @lv_est.

      SORT lt_sa BY km_von.
      DESCRIBE TABLE lt_sa LINES lv_lines.

      " Hole den End-Kilometer der AS
      LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmin AND km_bis >= me->get_data( )-zkmin.
        lv_index = sy-tabix + lv_max_sa.
        IF lv_index > lv_lines.
          lv_index = lv_lines.
        ENDIF.
        READ TABLE lt_sa INDEX lv_index INTO ls_sa.
        lv_km_bis = ls_sa-km_bis.
        CLEAR ls_sa.
      ENDLOOP.

      " Hole den Start-Kilometer der AS
      LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmax AND km_bis >= me->get_data( )-zkmax.
        lv_index = sy-tabix - lv_max_sa.
        IF lv_index < 0.
          lv_index = 0.
        ENDIF.
        READ TABLE lt_sa INDEX lv_index INTO ls_sa.
        lv_km_von = ls_sa-km_von.
        CLEAR ls_sa.
      ENDLOOP.
    ENDIF.


**************************************************************************************************************
* Lösche Aufträge, die nicht in der möglichen Ausdehnung der AS liegen
**************************************************************************************************************
    LOOP AT lt_auftraege ASSIGNING <ls_auftrag>.
      CASE <ls_auftrag>-zstdkz.
        WHEN 'S'.
          DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
          CONTINUE.
        WHEN 'Q'.
          "IF me->ms_arbeitsstelle-zest = 'W'.
*--> Begin Change >001<
           IF me->mo_schicht->get_rj_est( ) = mc_sperrabs-w  OR
              me->mo_schicht->get_rj_est( ) = mc_sperrabs-w1 OR
              me->mo_schicht->get_rj_est( ) = mc_sperrabs-w2 OR
              me->mo_schicht->get_rj_est( ) = mc_sperrabs-w3.
*--> End Change >001<
            SELECT SINGLE zkm_w FROM zio_5_querschl INTO lv_km WHERE zkm_e = <ls_auftrag>-zzkmvpl.
*            lv_km = io_auftrag->get_km_by_eiz( iv_eiz = io_arbeitsstelle->get_data( )-zid_est )-zkmin.


*          ELSEIF me->ms_arbeitsstelle-zest = 'E'.
          ELSE.
            lv_km = <ls_auftrag>-zzkmvpl.
          ENDIF.

          IF lv_km NOT BETWEEN lv_km_von AND lv_km_bis.
            DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
          ENDIF.
        WHEN 'M'.




*        WHEN ''.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_AUFTRAEGE_WD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_LIST                        TYPE        ZIO_5_JOBPOOL_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftraege_wd.

    DATA: ls_auftrag   LIKE LINE OF rt_list,
          lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag   TYPE REF TO zcl_io_5_auftrag.

    lo_aufttag_i ?= mo_orders->get_values_iterator( ).

    WHILE lo_aufttag_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_aufttag_i->get_next( ).

      MOVE-CORRESPONDING lo_auftrag->get_data( ) TO ls_auftrag.
      ls_auftrag-object = lo_auftrag.

      "RGBT-1052: Befindet sich die Schicht im Status ANTL oder höher, soll das Datum (Ausführen bis) aus ZIO_BACKUP ermittelt werden.
      IF mo_schicht->get_status( ) NE zif_io_5_schicht_status=>mc_interval_provided.
        SELECT SINGLE gltrp FROM zio_5_backup INTO ls_auftrag-gltrp WHERE aufnr EQ ls_auftrag-aufnr.
      ENDIF.

      "HP: Auftrag ist erstmal immer visible:
      ls_auftrag-is_visible = abap_true.

      APPEND ls_auftrag TO rt_list. CLEAR ls_auftrag.
    ENDWHILE.

    SORT rt_list ASCENDING BY zpprio.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INDEX                       TYPE        INTEGER(optional)
* | [--->] IV_KEY                         TYPE        AUFNR(optional)
* | [<-()] RO_OBJECT                      TYPE REF TO ZCL_IO_5_AUFTRAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftrag.

    IF iv_index IS NOT INITIAL.
      ro_object ?= mo_orders->get_by_position( position = iv_index ).
      RETURN.
    ELSEIF iv_key IS NOT INITIAL.
      ro_object ?= mo_orders->get( key = iv_key ).
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_BTG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_LAGE                        TYPE        ZIO_LAGE
* | [<---] EV_DIDOK                       TYPE        ZIO_DIDOK
* | [<---] EV_ID_BTG                      TYPE        ZIO_ID_BTG
* | [<---] EV_INDEX                       TYPE        ZIO_INDEX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_btg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Liefert die BTG Daten
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    TRY.
        me->get_auftrag( iv_index = 1 )->get_btg(
        IMPORTING
          ev_lage   = ev_lage
          ev_didok  = ev_didok
          ev_id_btg = ev_id_btg
          ev_index  = ev_index
         ).

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_COLOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_COLOR                       TYPE        STRINGVAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_color.

    rs_color = ''.


    "BTG's werden GRÜN dargestellt
    IF me->is_btg( ).
      rs_color = 'green.png'.
    ELSE.

      "Zugangsarten
      DATA(ls_zugangsarten) = me->get_zugangsarten( ).
      IF ls_zugangsarten-schiene EQ abap_true AND ls_zugangsarten-pneu EQ abap_true.
        "Strasse/ Schiene = Rot   => RED
        rs_color = 'RED.PNG'.
      ELSEIF ls_zugangsarten-schiene EQ abap_false AND ls_zugangsarten-pneu EQ abap_true.
        "Nur Strasse = Gelb       => dirty_yellow
        rs_color = 'dirty_yellow.png'.
      ELSEIF ls_zugangsarten-schiene EQ abap_true AND ls_zugangsarten-pneu EQ abap_false.
        "Nur Schiene = Grau       => GREY
        rs_color = 'grey.png'.
      ENDIF.


      "Intervallart
      "Totalsperrung = Lila
      IF rs_color = ''.
        SELECT zintervallart
          FROM zio_5_v_map_as
          WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl
            AND zintervallart = 'TS'
          APPENDING TABLE @DATA(lt_sps).

        IF syst-subrc EQ 0.
          rs_color = 'purple.png'.
          EXIT.
        ENDIF.

      ENDIF.
    ENDIF.

    "Fallback => bisher wurde die AS nicht klassifiziert.
    IF rs_color = ''.
      rs_color = 'grey.png'.
    ENDIF.





  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIO_5_ARBSTELLEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.

    rs_data = me->ms_arbeitsstelle.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_DATETIME_FOR_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [<---] EV_ZUGNUMMER                   TYPE        ZIO_ZUG_ID
* | [<---] EV_DATE                        TYPE        DATS
* | [<---] EV_TIME                        TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_datetime_for_ez_form.

    ASSIGN it_ez_form[ zarbstl  = ms_arbeitsstelle-zarbstl
                       richtung = iv_richtung
                       ez_aktiv = abap_true ]
        TO FIELD-SYMBOL(<ls_ez_form>).
    CHECK <ls_ez_form> IS ASSIGNED.
    CHECK <ls_ez_form>-zugnummer IS NOT INITIAL.

    ev_zugnummer = <ls_ez_form>-zugnummer.

    ev_date = mo_schicht->get_data( )-start_datum.

    DATA(lv_time_field) = CONV fieldname( '' ).

    DATA(lt_trassen) = mo_schicht->get_trassen( iv_zugnummer       = ev_zugnummer
                                                iv_arbstelle_level = abap_true ).
    CASE iv_richtung.
      WHEN zif_io_5_trasse=>mc_richtung_einfahrt.
        lv_time_field = 'ZAN'.
        SORT lt_trassen BY reihenfolge DESCENDING.
      WHEN zif_io_5_trasse=>mc_richtung_ausfahrt.
        lv_time_field = 'ZAB'.
        SORT lt_trassen BY reihenfolge ASCENDING.
    ENDCASE.

    ASSIGN lt_trassen[ 1 ] TO FIELD-SYMBOL(<ls_trasse>).
    IF <ls_trasse> IS ASSIGNED.

      IF <ls_trasse>-zeit_am_start_tag IS INITIAL.
        ev_date = ev_date + 1.
      ENDIF.

      ASSIGN COMPONENT lv_time_field OF STRUCTURE <ls_trasse> TO FIELD-SYMBOL(<lv_time>).
      ev_time = <lv_time>.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_EINZELKAPAS_REF
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TTY_EINZELKAPAS_REF
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_einzelkapas_ref.
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Einzelkapas References
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : BAUN-259
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by:
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       19.11.2021   DXC / Piotr Stelmach
*         Programmerstellung/creation of program
*         6800015680 JADE-101
*----------------------------------------------------------------------*

    DATA(lo_auftraege)   = me->get_auftraege( ).
    DATA(lo_auftraege_i) = CAST cl_object_collection_iterator( lo_auftraege->get_values_iterator( ) ).
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      DATA(lo_auftrag)       = CAST zcl_io_5_auftrag( lo_auftraege_i->get_next( ) ).
      DATA(lo_einzelkapas)   = CAST cl_object_map( lo_auftrag->get_einzelkapas_o( ) ).
      DATA(lo_einzelkapas_i) = CAST cl_object_collection_iterator( lo_einzelkapas->get_values_iterator( ) ).
      WHILE lo_einzelkapas_i->has_next( ) = abap_true.
        DATA(lo_einzelkapa) = CAST zcl_io_5_einzelkapazitaet( lo_einzelkapas_i->get_next( ) ).
        rt_data = VALUE #( BASE rt_data ( object = lo_einzelkapa ) ).
      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_EIZ_DESCRIPTION
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIO_5_EIZ_BESCHR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_eiz_description.

    rv_value = SWITCH #( ms_arbeitsstelle-zid_eiz
                         WHEN zif_io_5_constant=>mc_eizid_gbtn THEN 'Ersfeld'  ##NO_TEXT
                         WHEN zif_io_5_constant=>mc_eizid_gbts THEN 'Biasca'   ##NO_TEXT
                         ELSE '' ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG(optional)
* | [--->] IV_ACTIVE                      TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RT_VALUE                       TYPE        ZIO_5_EZ_FORM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form.

    TRY .
        rt_value[] = mo_schicht->get_ez_form( iv_zarbstl  = ms_arbeitsstelle-zarbstl
                                              iv_richtung = iv_richtung
                                              iv_active   = iv_active ).
      CATCH cx_sy_ref_is_initial.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_EZ_FORM_DB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NEW                         TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RT_DATA                        TYPE        ZIO_5_EZ_FORM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form_db.

    IF iv_new = abap_false.
      rt_data = mt_ez_form_db.
      RETURN.
    ENDIF.

    DATA(lv_zschicht) = mo_schicht->get_id( ).
    SELECT zschicht, zugnummer, zarbstl, zid_eiz, richtung, data_origin, ez_aktiv
      INTO CORRESPONDING FIELDS OF TABLE @mt_ez_form_db
      FROM zio_5_ez_form
      WHERE zschicht = @lv_zschicht
        AND zarbstl  = @ms_arbeitsstelle-zarbstl.
    IF sy-subrc = 0.
      SORT mt_ez_form_db BY zschicht zugnummer zarbstl zid_eiz richtung data_origin.
      DELETE ADJACENT DUPLICATES FROM mt_ez_form_db COMPARING zschicht zugnummer zarbstl zid_eiz richtung.
      rt_data = mt_ez_form_db.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FILTER_FZTYP                TYPE        ZIO_ID_FZTYP(optional)
* | [<-()] RO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: Die Fahrzeuge für eine Arbeitsstelle werden gelesen
*
* SAP-Prozess : ...
* Grund:        (X) QM-Meldung  : 900088705
*               ( ) Projekt     : ...
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Thomas Frick
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.52        26.06.2018  SBB AG / Arlene Bucher
*         Nur bei einer Arbeitsstelle, die in der Totalsperrungsröhre
*         liegt, werden die Fahrzeuge der Referenzarbeitsstelle gelesen
*         keine Änderung
*----------------------------------------------------------------------*
* >002<   7.50        00.00.0000   /
*
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.

    IF iv_filter_fztyp IS INITIAL.
      ro_fahrzeuge = me->mo_fahrzeuge.
    ELSE.
      ro_fahrzeuge = NEW cl_object_map( ).
      lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        " Filter anwenden
        CHECK lo_fahrzeug->get_data( )-zid_fztyp = iv_filter_fztyp.
        " Fahtzeug zurückgeben
        ro_fahrzeuge->put( EXPORTING key = lo_fahrzeug->get_id( )   value = lo_fahrzeug ).
      ENDWHILE.
    ENDIF.

****    "Fahrzeuge aus der Primären Referenzarbeitstelle ermitteln ">001< nur wenn es sich um eine TS-TS-Arbeitsstelle handelt
****    IF me->get_data( )-zarbstl_ref IS NOT INITIAL.
****      TRY.
****          DATA(lo_arbstl) = me->get_arbeitsstelle_gruppe( )->get_arbeitsstelle_ref( me ).
****          IF lo_arbstl IS NOT INITIAL.
****            ro_fahrzeuge = lo_arbstl->get_fahrzeuge( ).
****          ENDIF.
****        CATCH cx_root.
****      ENDTRY.
****    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZIO_ID_AS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_id.

    rv_id = me->ms_arbeitsstelle-zarbstl.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IO_5_ARBEITSSTELLE=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT_ID                  TYPE        ZIO_5_SCHICHT
* | [--->] IV_ARBSTLE_ID                  TYPE        ZIO_ID_ARBSTL
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IO_5_ARBEITSSTELLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
    CHECK iv_schicht_id IS NOT INITIAL
      AND iv_arbstle_id IS NOT INITIAL.

    DATA(lo_schicht) = NEW zcl_io_5_schicht( iv_zschicht = iv_schicht_id ).

    ro_instance = NEW #( io_schicht = lo_schicht
                         iv_id      = iv_arbstle_id ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_INTERVALLARTEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_INTERVALLARTEN              TYPE        ZIO_5_INTERVALLARTEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_intervallarten.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Interval types
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >001<   7.52       05.06.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*

    rs_intervallarten-regelintervall = abap_false.
    rs_intervallarten-totalsperrung  = abap_false.
    rs_intervallarten-jokerintervall = abap_false.

    DATA: lo_auftrag TYPE REF TO zcl_io_5_auftrag.

    DATA(lo_auftraege_iterator) = me->mo_orders->get_values_iterator( ).

    WHILE lo_auftraege_iterator->has_next( ).
      lo_auftrag ?= lo_auftraege_iterator->get_next( ).

      CASE lo_auftrag->get_data( )-zintervall.
          WHEN 'RJ':.  "Regel/Jokerintervall
          rs_intervallarten-regelintervall = abap_true.
          WHEN 'TS':.  "Totalsperrung
          rs_intervallarten-totalsperrung = abap_true.
        WHEN 'LI'.                                            ">001< +
          rs_intervallarten-langintervall = abap_true.        ">001< +
      ENDCASE.

    ENDWHILE.

    "Jokerintervall kann nur von der Schicht ermittelt werden die Aufträge
    "to do eigentlich müsste Tabelle ZIO_5_MAP_AS_IZG mit Intervallart und Zugangsart befüllt sein, zur Zeit fehlend
    IF rs_intervallarten-regelintervall = abap_true. "stimmt das wirklich?

      "Sperrabschnitt pro Schicht
      DATA(lt_sp_schicht) = mo_schicht->get_sp_schicht( ).
      "gibt es einen Sperrabschnitt mit Jokerintervall?
      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WITH KEY zintervallart = 'JI'.
      IF sy-subrc = 0.
        rs_intervallarten-regelintervall = abap_false.
        rs_intervallarten-jokerintervall = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_KM_BIS_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIO_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_km_bis_for_calc.
    " Default value of 'KM bis' for calculation is 'KM bis' of this Arbeitsstelle.
    " If the calculation is for Ausfahrt:
    " - first get maximal KM (KM bis) of the most inner Arbeitsstelle in the Tunnel
    " - if this most inner KM is the same as 'KM bis' of this Arbeitsstelle
    "   - than this is the most inner Arbeitsstelle, so use 'KM bis' of this Arbeitsstelle
    "   - otherwise use the most inner KM

    rv_value = ms_arbeitsstelle-zkmax.

    IF iv_richtung = zif_io_5_trasse=>mc_richtung_ausfahrt.
      mo_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN ms_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE lv_km_max ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_KM_VON_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BETRIEBSPUNKT               TYPE        ZIO_5_BETRIEBSPUNKT
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIO_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_km_von_for_calc.
    " Default value of 'KM von' for calculation is KM of the Betriebspunkt.
    " If the calculation is for Ausfahrt:
    " - first get maximal KM (KM bis) of the most inner Arbeitsstelle in the Tunnel
    " - if this most inner KM is the same as 'KM bis' of this Arbeitsstelle
    "   - than this is the most inner Arbeitsstelle, so use the KM value of Betriebspunkt
    "   - otherwise use 'KM von' of this Arbeitsstelle

    rv_value = zcl_io_5_betriebspunkt=>get_kilometer( iv_betriebspunkt  = iv_betriebspunkt
                                                      iv_sperrabschnitt = iv_sperrabschnitt ).

    IF iv_richtung = zif_io_5_trasse=>mc_richtung_ausfahrt.
      mo_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN ms_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE ms_arbeitsstelle-zkmin ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_KURZTEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZGART_TXT                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RV_TEXT                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_kurztext.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Liefert den AS Kurztext
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_is_ts) = VALUE abap_bool( ).


    me->get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).  "Get/create the 'Sperrabschintt' table for Ktext

    IF lt_sp_ktext IS INITIAL.
      RETURN.
    ENDIF.

    IF line_exists( mt_map_sp_as[ zintervallart = 'TS' ] ).         "Check TS exists
      lv_is_ts = abap_true.
    ENDIF.

    DESCRIBE TABLE lt_sp_ktext LINES DATA(lv_lines).

    LOOP AT lt_sp_ktext ASSIGNING FIELD-SYMBOL(<ls_sp_ktext>).
      DATA(lv_tabix) = sy-tabix.
      rv_text  = |{ rv_text }| & | | & |{ <ls_sp_ktext>-prefix }| &  |{ <ls_sp_ktext>-index ALPHA = IN }|.

      IF lv_is_ts = abap_true.
        rv_text = |{ rv_text }| & |TS|.
      ENDIF.

      IF iv_zgart_txt = abap_true.
        DATA(lv_zgart_txt) = COND #( WHEN <ls_sp_ktext>-zugangsart = '1'
                                     THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIO_5/SCHIENE' )
                                     WHEN <ls_sp_ktext>-zugangsart = '2'
                                     THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIO_5/STRASSE' ) ).
        rv_text =  |{ rv_text }| & | | & |(| & |{ lv_zgart_txt }| & |)|.
      ENDIF.

      IF lv_tabix <= 1 AND lv_tabix < lv_lines.
        rv_text = |{ rv_text }| & | | & |-|.
      ENDIF.

    ENDLOOP.

    CONDENSE rv_text.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_LINUMBER_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIO_5_LINUMBER_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_linumber_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get int. number as text
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52       05.06.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-618
*----------------------------------------------------------------------*
    DATA(lv_linumber) = VALUE string( ).


    "Sperrabschnitt-Daten abrufen.
    SELECT linumber
      INTO TABLE @DATA(lt_sp_data)
      FROM zio_5_v_map_as
      WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_MAP_SP_AS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REFRESH                     TYPE        ABAP_BOOL(optional)
* | [<-()] RT_DATA                        TYPE        TTY_V_MAP_AS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_map_sp_as.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Liefert das Maping von ZIO_5_V_MAP_AS View
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CLEAR rt_data.

    IF iv_refresh = abap_false.               "Without data refresh
      rt_data = mt_map_sp_as.
    ELSE.                                      "With data refreshing
      SELECT zarbstl, sperras_id, zugangsart, sperrabschnitt, zintervallart, etappenautrag
        FROM zio_5_v_map_as
        INTO CORRESPONDING FIELDS OF TABLE @rt_data
        WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_MAX_AUSLASTUNG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIO_5_AUSLASTUNG_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_max_auslastung.

    rv_value = get_nettoarbeitszeit( ) * ( get_schicht( )->get_parameter( )->get_data( )-auslastung_1 / 100 ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_MET
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_VALUE                       TYPE        ZIO_5_MET
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_met.
    CHECK ms_arbeitsstelle-zmet IS NOT INITIAL.

    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF @rs_value
      FROM zio_5_met
      WHERE zid_met = @ms_arbeitsstelle-zmet.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_MIN_KM_FOR_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [<-()] RV_VALUE                       TYPE        ZIO_5_ZEITABZUG_PRO_KM_FS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_min_km_for_calc.
    " Default value of MIN Per KM for calculation is 'Zeitabzug km FS'
    " If the calculation is for Ausfahrt:
    " - first get maximal KM (KM bis) of the most inner Arbeitsstelle in the Tunnel
    " - if this most inner KM is the same as 'KM bis' of this Arbeitsstelle
    "   - than this is the most inner Arbeitsstelle, so use 'Zeitabzug km FS'
    "   - otherwise use 'Zeitabzug km SH'

    DATA(ls_param) = mo_schicht->get_parameter( )->get_data( ).

    rv_value = ls_param-zeitabzug_pro_km_fs.

    IF iv_richtung = zif_io_5_trasse=>mc_richtung_ausfahrt.
      mo_schicht->get_most_inner_arbeitsstelle( IMPORTING ev_km_max = DATA(lv_km_max) ).
      rv_value = COND #( WHEN ms_arbeitsstelle-zkmax = lv_km_max THEN rv_value ELSE ls_param-zeitabzug_pro_km_sh ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_NETTOARBEITSZEIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ARBEITSZEIT                 TYPE        ZIO_ARBEITSZEIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_nettoarbeitszeit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get NettoArbeitszeit
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50      12.04.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-671
*         - Hinzufügen Langintervall und nur erste Buchstabe der
*           Sperrabschnitt verwenden
*----------------------------------------------------------------------*
    DATA lo_sp_zeit       TYPE REF TO zcl_io_5_sp_zeiten.
    DATA ls_sp_zeit       TYPE zio_5_sp_zeiten.
    DATA lv_time_rng_sec  TYPE i.
    DATA lt_sp_zeiten     TYPE tty_sp_zeiten_tab.

    FIELD-SYMBOLS <ls_sp_zeiten> LIKE LINE OF lt_sp_zeiten.


    lt_sp_zeiten = me->get_sp_zeiten_tab( ).
    IF lt_sp_zeiten IS INITIAL.
      RETURN.
    ENDIF.
*--> Begin Change >001<
    IF line_exists( lt_sp_zeiten[ zintervallart = 'TS' sperrabschnitt(1) = 'E' ] ) OR
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
        lo_sp_zeit ?= me->mo_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
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

        lo_sp_zeit ?= me->mo_sp_zeiten->get( key = <ls_sp_zeiten>-sperras_id ).
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_PERIMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIO_PRMTR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_perimeter.

    rv_value = mo_schicht->get_data( )-zzperi.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_PNEU_KENNZEICHEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TTY_PNEU_KENNZEICHEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_pneu_kennzeichen.

    DATA(lo_aufttag_i) = CAST cl_object_collection_iterator( me->get_auftraege( )->get_values_iterator( ) ).
    WHILE lo_aufttag_i->has_next( ) = abap_true.
      DATA(lo_auftrag) = CAST zcl_io_5_auftrag( lo_aufttag_i->get_next( ) ).
      CHECK lo_auftrag->get_data( )-zzzugangsart = '2'.

      zcl_io_5_utilities=>get_pneu_bez_kennzeichen(                                          "Get prefix
       EXPORTING
         iv_stdkz = lo_auftrag->get_data( )-zstdkz
         iv_didok = lo_auftrag->get_data( )-zdidok
         iv_lage  = lo_auftrag->get_data( )-zlage
       RECEIVING  rv_mark = DATA(lv_kennzeichen) ).

      rt_data = VALUE #( BASE rt_data ( zarbstbez = lv_kennzeichen ) ).

      IF me->is_btg( ).
        EXIT.
      ENDIF.
    ENDWHILE.

    DELETE ADJACENT DUPLICATES FROM rt_data.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_RJ_EST
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EST                         TYPE        ZIO_ROEHRE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_rj_est.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get RJ EST
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50      25.07.2025   DXC   / Piotr Stelmach
*         6800039067: NES-JADE: REAL LI (JADE-1114)
*----------------------------------------------------------------------*

    DATA(lt_sp_schicht) =  mo_schicht->get_sp_schicht( ).
    DATA(lt_as_sp)      =  get_sperrabschnitte( ).
    DATA(ls_as_sp)      = VALUE #( lt_as_sp[ 1 ] OPTIONAL ).

    IF ls_as_sp IS NOT INITIAL.
      DATA(ls_sp_schicht) = VALUE #( lt_sp_schicht[ sperras_id = ls_as_sp-sperras_id ] OPTIONAL ).
      rv_est = ls_sp_schicht-sperrabschnitt.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SA_EXT_FOR_NEW_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IO_5_AUFTRAG(optional)
* | [<-()] RT_SA                          TYPE        ZIO_5_SA_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
        METHOD get_sa_ext_for_new_auftrag.
****    METHOD get_sa_ext_for_new_auftrag.
****
****      DATA: lv_sa_km_von TYPE zio_km_von,
****            lv_sa_km_bis TYPE zio_km_bis.
****
****      DATA(ls_auftrag) = io_auftrag->get_data( ).
****
****
****      "für den Auftrag sollen die Signalabschnitte ermittelt werden.
****      "Der Auftrag kann mehrere Sperrabschnitte enthalten
****      "Also muss für jeden Sperrabschnitt extra geschaut werden.
****
****      APPEND LINES OF me->get_sa_for_new_auftrag( iv_rj_est = me->get_schicht( )->get_rj_est( )
****                                                  iv_ts_est = me->get_schicht( )->get_ts_est( )
****                                                  io_auftrag = io_auftrag ) TO rt_sa.
****
****      DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
****
****      WHILE li_sp_km_i->has_next( ).
****        DATA(lo_sp_km) = CAST zcl_io_5_sp_kilometer( li_sp_km_i->get_next( ) ).
****        APPEND LINES OF lo_sp_km->get_sa( ) TO rt_sa.
****      ENDWHILE.
****
****      SORT rt_sa BY zsa.
****      DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
****
****      DATA(lv_peri) = io_auftrag->get_data( )-zzperi.
****
****      "Welche Sperrabschnitte haben wir denn so.
****      DATA lt_distinct_sp TYPE STANDARD TABLE OF zio_roehre.
****      LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa>).
****        APPEND INITIAL LINE TO lt_distinct_sp ASSIGNING FIELD-SYMBOL(<ls_distinct_sp>).
****        <ls_distinct_sp> = <ls_sa>-zest.
****      ENDLOOP.
****      SORT lt_distinct_sp.
****      DELETE ADJACENT DUPLICATES FROM lt_distinct_sp .
****
****      LOOP AT lt_distinct_sp ASSIGNING <ls_distinct_sp>.
****
****        DATA(lt_tmp_sa) = rt_sa.
****        DELETE lt_tmp_sa WHERE zest <> <ls_distinct_sp>.
****
****        DATA(ls_sa_min) = lt_tmp_sa[ 1 ]-zsa.
****        DATA(ls_sa_max) = lt_tmp_sa[ lines( lt_tmp_sa ) ]-zsa.
****
****        SELECT * FROM zio_5_sa
****          APPENDING TABLE @DATA(lt_reloaded_sa)
****          WHERE zzperi = @lv_peri
****            AND zsa >= @ls_sa_min
****            AND zsa <= @ls_sa_max
****            AND zest = @<ls_distinct_sp>.
****      ENDLOOP.
****
****      APPEND LINES OF lt_reloaded_sa TO rt_sa.
****      SORT rt_sa BY zsa.
****      DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
****************
*****     Hier sind dann die Lücken auf dem Einzelnen Intervallen geschlossen
******************
****
****
****      DATA(ls_rj_sa_min) = 99999. DATA(ls_rj_sa_max) = 00000.
****      "MIN MAX auf dem Regelintervall
****      LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest = me->get_schicht( )->get_rj_est( ).
****        ls_rj_sa_min = COND #( WHEN <ls_sa>-zsa < ls_rj_sa_min THEN <ls_sa>-zsa ELSE ls_rj_sa_min ).
****        ls_rj_sa_max = COND #( WHEN <ls_sa>-zsa > ls_rj_sa_max THEN <ls_sa>-zsa ELSE ls_rj_sa_max ).
****      ENDLOOP.
****
****
****      CHECK me->is_in_tunnel( ) EQ abap_true.
****      "Für jeden anderen RJ Sperrabschnitt müssen wir nun die Lücken Schliessen
****      LOOP AT lt_distinct_sp ASSIGNING <ls_distinct_sp> WHERE table_line <> me->get_schicht( )->get_rj_est( )
****                                                          AND table_line <> me->get_schicht( )->get_ts_est( ).
****
****      ENDLOOP.
****
**********      LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest <> me->get_schicht( )->get_rj_est( )
**********                                        AND zest <> me->get_schicht( )->get_ts_est( ).
**********        AT NEW zest.
**********          DATA(lv_osx_zest) = <ls_sa>-zest.
**********
**********          DATA(ls_osx_sa_min) = 99999. DATA(ls_osx_sa_max) = 00000.
**********          LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa_osx>) WHERE zest = lv_osx_zest.
**********            ls_osx_sa_min = COND #( WHEN <ls_sa>-zsa < ls_osx_sa_min THEN <ls_sa>-zsa ELSE ls_osx_sa_min ).
**********            ls_osx_sa_max = COND #( WHEN <ls_sa>-zsa > ls_osx_sa_max THEN <ls_sa>-zsa ELSE ls_osx_sa_max ).
**********          ENDLOOP.
**********
**********          DATA(lv_rj_est) = me->get_schicht( )->get_rj_est( ).
**********
**********          IF ( ms_arbeitsstelle-zid_eiz = '10' AND lv_peri = 'GBT' ) OR
**********             ( ms_arbeitsstelle-zid_eiz = '20' AND lv_peri = 'CBT' ).
**********            "wir schauen richtung norden
**********            SELECT * FROM zio_5_sa_abfolge
**********             APPENDING TABLE @DATA(lt_gaps_sa)
**********             WHERE (      zzperi = @lv_peri
**********                      AND sperrabschnitt = @lv_rj_est
**********                      AND signalabschnitt < @ls_rj_sa_min
**********                      AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) )
**********                    OR
**********                  (       zzperi = @lv_peri
**********                      AND sperrabschnitt = @lv_osx_zest
**********                      AND signalabschnitt > @ls_osx_sa_max
**********                      AND ( s_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
**********          ELSE.
**********            "wir schauen richtung süden
**********            SELECT * FROM zio_5_sa_abfolge
**********             APPENDING TABLE @lt_gaps_sa
**********             WHERE (      zzperi = @lv_peri
**********                      AND sperrabschnitt = @lv_rj_est
**********                      AND signalabschnitt < @ls_rj_sa_max
**********                      AND ( s_sperrabschnitt = @lv_rj_est OR s_sperrabschnitt = @lv_osx_zest ) )
**********                    OR
**********                  (       zzperi = @lv_peri
**********                      AND sperrabschnitt = @lv_osx_zest
**********                      AND signalabschnitt > @ls_osx_sa_min
**********                      AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
**********          ENDIF.
**********        ENDAT.
**********
**********      ENDLOOP.
****
*****      DATA: lr_sa TYPE RANGE OF zio_signalabschnitt.
*****      IF lines( lt_gaps_sa ) > 0.
*****        LOOP AT lt_gaps_sa ASSIGNING FIELD-SYMBOL(<ls_gap_sa>).
*****          APPEND INITIAL LINE TO lr_sa ASSIGNING FIELD-SYMBOL(<ls_ra_sa>).
*****          <ls_ra_sa>-sign = 'I'.
*****          <ls_ra_sa>-option = 'EQ'.
*****          <ls_ra_sa>-low = <ls_gap_sa>-signalabschnitt.
*****        ENDLOOP.
*****
*****        SELECT * FROM zio_5_sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
*****          WHERE zzperi = @lv_peri
*****            AND zsa IN @lr_sa.
*****
*****      ENDIF.
*****
*****      SORT rt_sa BY zsa.
*****      DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
****
****    ENDMETHOD.


        "*******************
        "* BACLUP
        "***************

          DATA: lv_sa_km_von TYPE zio_km_von,
                lv_sa_km_bis TYPE zio_km_bis.

          DATA(ls_auftrag) = io_auftrag->get_data( ).


          "für den Auftrag sollen die Signalabschnitte ermittelt werden.
          "Der Auftrag kann mehrere Sperrabschnitte enthalten
          "Also muss für jeden Sperrabschnitt extra geschaut werden.

          APPEND LINES OF me->get_sa_for_new_auftrag( iv_rj_est = me->get_schicht( )->get_rj_est( )
                                                                    iv_ts_est = me->get_schicht( )->get_ts_est( )
                                                                    io_auftrag = io_auftrag ) TO rt_sa.

          DATA(li_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).

          WHILE li_sp_km_i->has_next( ).
            DATA(lo_sp_km) = CAST zcl_io_5_sp_kilometer( li_sp_km_i->get_next( ) ).
            APPEND LINES OF lo_sp_km->get_sa( ) TO rt_sa.
          ENDWHILE.


          SORT rt_sa BY zsa.
          DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.

          DATA(lv_peri) = io_auftrag->get_data( )-zzperi.
          "Welche Sperrabschnitte haben wir denn so.
          LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa>).

            AT NEW zest.
              DATA(lt_tmp_sa) = rt_sa.
              DELETE lt_tmp_sa WHERE zest <> <ls_sa>-zest.

              DATA(ls_sa_min) = lt_tmp_sa[ 1 ]-zsa.
              DATA(ls_sa_max) = lt_tmp_sa[ lines( lt_tmp_sa ) ]-zsa.

              SELECT * FROM zio_5_sa
                APPENDING TABLE @DATA(lt_reloaded_sa)
                WHERE zzperi = @lv_peri
                  AND zsa >= @ls_sa_min
                  AND zsa <= @ls_sa_max
                  AND zest = @<ls_sa>-zest.

            ENDAT.

          ENDLOOP.

          APPEND LINES OF lt_reloaded_sa TO rt_sa.
          SORT rt_sa BY zsa.
          DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.
************
*     Hier sind dann die Lücken auf dem Einzelnen Intervallen geschlossen
**************


          DATA(ls_rj_sa_min) = 99999. DATA(ls_rj_sa_max) = 00000.
          "MIN MAX auf dem Regelintervall
          LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest = me->get_schicht( )->get_rj_est( ).
            ls_rj_sa_min = COND #( WHEN <ls_sa>-zsa < ls_rj_sa_min THEN <ls_sa>-zsa ELSE ls_rj_sa_min ).
            ls_rj_sa_max = COND #( WHEN <ls_sa>-zsa > ls_rj_sa_max THEN <ls_sa>-zsa ELSE ls_rj_sa_max ).
          ENDLOOP.


          CHECK me->is_in_tunnel( ) EQ abap_true.
          "Für jeden anderen RJ Sperrabschnitt müssen wir nun die Lücken Schliessen
          LOOP AT rt_sa ASSIGNING <ls_sa> WHERE zest <> me->get_schicht( )->get_rj_est( )
                                            AND zest <> me->get_schicht( )->get_ts_est( ).
            AT NEW zest.
              DATA(lv_osx_zest) = <ls_sa>-zest.

              DATA(ls_osx_sa_min) = 99999. DATA(ls_osx_sa_max) = 00000.
              LOOP AT rt_sa ASSIGNING FIELD-SYMBOL(<ls_sa_osx>) WHERE zest = lv_osx_zest.
                ls_osx_sa_min = COND #( WHEN <ls_sa>-zsa < ls_osx_sa_min THEN <ls_sa>-zsa ELSE ls_osx_sa_min ).
                ls_osx_sa_max = COND #( WHEN <ls_sa>-zsa > ls_osx_sa_max THEN <ls_sa>-zsa ELSE ls_osx_sa_max ).
              ENDLOOP.

              DATA(lv_rj_est) = me->get_schicht( )->get_rj_est( ).

              IF ( ms_arbeitsstelle-zid_eiz = '10' AND lv_peri = 'GBT' ) OR
                 ( ms_arbeitsstelle-zid_eiz = '20' AND lv_peri = 'CBT' ).
                "wir schauen richtung norden
                SELECT * FROM zio_5_sa_abfolge
                 APPENDING TABLE @DATA(lt_gaps_sa)
                 WHERE (      zzperi = @lv_peri
                          AND sperrabschnitt = @lv_rj_est
                          AND signalabschnitt < @ls_rj_sa_min
                          AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) )
                        OR
                      (       zzperi = @lv_peri
                          AND sperrabschnitt = @lv_osx_zest
                          AND signalabschnitt > @ls_osx_sa_max
                          AND ( s_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
              ELSE.
                "wir schauen richtung süden
                SELECT * FROM zio_5_sa_abfolge
                 APPENDING TABLE @lt_gaps_sa
                 WHERE        zzperi = @lv_peri
                          AND (     sperrabschnitt = @lv_rj_est
                                AND signalabschnitt > @ls_rj_sa_min
                                AND ( s_sperrabschnitt = @lv_rj_est OR s_sperrabschnitt = @lv_osx_zest ) )
                          OR
                              (     sperrabschnitt = @lv_osx_zest
                                AND signalabschnitt < @ls_osx_sa_max
                                AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
              ENDIF.
            ENDAT.

          ENDLOOP.

          DATA: lr_sa TYPE RANGE OF zio_signalabschnitt.
          IF lines( lt_gaps_sa ) > 0.
            LOOP AT lt_gaps_sa ASSIGNING FIELD-SYMBOL(<ls_gap_sa>).
              APPEND INITIAL LINE TO lr_sa ASSIGNING FIELD-SYMBOL(<ls_ra_sa>).
              <ls_ra_sa>-sign = 'I'.
              <ls_ra_sa>-option = 'EQ'.
              <ls_ra_sa>-low = <ls_gap_sa>-signalabschnitt.
            ENDLOOP.

            SELECT * FROM zio_5_sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
              WHERE zzperi = @lv_peri
                AND zsa IN @lr_sa.

          ENDIF.

          SORT rt_sa BY zsa.
          DELETE ADJACENT DUPLICATES FROM rt_sa COMPARING zsa.

        ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SA_FOR_NEW_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RJ_EST                      TYPE        ZIO_ROEHRE
* | [--->] IV_TS_EST                      TYPE        ZIO_ROEHRE
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IO_5_AUFTRAG
* | [<-()] RT_SA                          TYPE        ZIO_5_SA_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sa_for_new_auftrag.
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Lesen Signalabschnitten aus dem Auftrag
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : REAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by:
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       10.01.2021   DXC / Holger Pluschke
*         Programmerstellung/creation of program
*         6800009662
*----------------------------------------------------------------------*
* >001<   7.50       10.09.2024   DXC / Roman Knap
*         Anpassung für REAL LI wegen neuen Intervallart LI=Lang Intervall
*         für Standortkennzeichen Q-Querschlag und M-Multifunktionstellen
*         soll ähnliche Logik wie für Intervallart RJ=Regel/Joker Intervall
*         funktionieren
*         6800036393 JADE-992
*----------------------------------------------------------------------*
    DATA: lr_est TYPE RANGE OF zio_roehre.

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

        CASE io_auftrag->get_data( )-zintervall.
          WHEN 'TS'.
            DATA(tmp) = io_auftrag->get_sp( ).
          WHEN 'RJ'.
            tmp = io_auftrag->get_sp( iv_rj_est ).
          WHEN 'LI'.                                      ">001< INS
            tmp = io_auftrag->get_sp( iv_rj_est ).        ">001< INS
          WHEN OTHERS.
        ENDCASE.

        LOOP AT tmp ASSIGNING FIELD-SYMBOL(<ls_tmp>).
          APPEND INITIAL LINE TO lr_est ASSIGNING FIELD-SYMBOL(<ls_est>).
          <ls_est>-sign = 'I'.
          <ls_est>-option = 'EQ'.
          <ls_est>-low = <ls_tmp>-sperrabschnitt.
        ENDLOOP.

        "Bei Sperrabschnitt W müssen die Auftragskilometer gemapt werden.
        READ TABLE tmp WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
        DATA(lv_sperrabschnitt_w) = COND #( WHEN syst-subrc = 0 THEN abap_true ELSE abap_false ).

        IF lv_sperrabschnitt_w EQ abap_true.
          DATA(lv_zzkmvpl) = io_auftrag->get_km_west( )-zkmin.
          DATA(lv_zzkmbpl) = io_auftrag->get_km_west( )-zkmax.
        ELSE.
          lv_zzkmvpl = io_auftrag->get_data( )-zzkmvpl.
          lv_zzkmbpl = io_auftrag->get_data( )-zzkmbpl.
        ENDIF.

        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************

        SELECT * FROM zio_5_sa AS sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lr_est.
        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zio_5_sa AS sa INTO @DATA(ls_ausdehnung_q)
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lr_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung_q IS NOT INITIAL.
          IF ( ls_ausdehnung_q-max - io_auftrag->mc_signal_km_abweich ) <= lv_zzkmbpl.   "ZIO_5_QUERSCHL
            "rechts noch einen mehr.
            DATA(ls_next_q) = zcl_io_5_utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung_q-max ]  ).
          ENDIF.

          IF ( ls_ausdehnung_q-min + io_auftrag->mc_signal_km_abweich ) >= lv_zzkmvpl.
            "links noch einen mehr.
            DATA(ls_prev_q) = zcl_io_5_utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung_q-min ]  ).
          ENDIF.

        ENDIF.
      WHEN 'M'.
        "*******************
        "* Multifunktionstellen
        "* => Mappingtabelle ZIO_5_MFS
        "* Bei TS ist   E/W erlaubt
        "* Bei RJ ist X/E/W erlaubt
        "* Es können bei X OST sowie WEST Kilometer angegeben werden
        "***************
        CASE io_auftrag->get_data( )-zintervall.
          WHEN 'TS'.
            tmp = io_auftrag->get_sp( ).
          WHEN 'RJ'.
            tmp = io_auftrag->get_sp( iv_rj_est ).
          WHEN 'LI'.                                      ">001< INS
            tmp = io_auftrag->get_sp( iv_rj_est ).        ">001< INS
          WHEN OTHERS.
        ENDCASE.

        LOOP AT tmp ASSIGNING <ls_tmp>.
          APPEND INITIAL LINE TO lr_est ASSIGNING <ls_est>.
          <ls_est>-sign = 'I'.
          <ls_est>-option = 'EQ'.
          <ls_est>-low = <ls_tmp>-sperrabschnitt.
        ENDLOOP.

        DATA(lv_mfs) = io_auftrag->get_data( )-zdidok.
        DATA(lv_km) = io_auftrag->get_data( )-zzkmvpl.

        SELECT SINGLE * FROM zio_5_mfs INTO @DATA(ls_mfs)
          WHERE zmfs EQ @lv_mfs
            AND zkm_mfs_von <= @lv_km AND zkm_mfs_bis >= @lv_km.

        lv_zzkmvpl = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).
        lv_zzkmbpl = COND #( WHEN iv_rj_est = 'E' THEN ls_mfs-zkm_e ELSE ls_mfs-zkm_w ).

        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************
        SELECT * FROM zio_5_sa AS sa APPENDING CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lr_est.
        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zio_5_sa AS sa INTO @ls_ausdehnung_q
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lr_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung_q IS NOT INITIAL.
          IF ( ls_ausdehnung_q-max - io_auftrag->mc_signal_km_abweich ) <= lv_zzkmbpl.   "ZIO_5_QUERSCHL
            "rechts noch einen mehr.
            ls_next_q = zcl_io_5_utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung_q-max ]  ).
          ENDIF.

          IF ( ls_ausdehnung_q-min + io_auftrag->mc_signal_km_abweich ) >= lv_zzkmvpl.
            "links noch einen mehr.
            ls_prev_q = zcl_io_5_utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung_q-min ]  ).
          ENDIF.

        ENDIF.

      WHEN OTHERS.
        "*******************
        "* Ermittlung Sperrabschnitte vom Auftrag
        "***************
        tmp = io_auftrag->get_sp( ).
        LOOP AT tmp ASSIGNING <ls_tmp>.
          APPEND INITIAL LINE TO lr_est ASSIGNING <ls_est>.
          <ls_est>-sign = 'I'.
          <ls_est>-option = 'EQ'.
          <ls_est>-low = <ls_tmp>-sperrabschnitt.
        ENDLOOP.

        lv_zzkmvpl = io_auftrag->get_data( )-zzkmvpl.
        lv_zzkmbpl = io_auftrag->get_data( )-zzkmbpl.

        "*******************
        "* Ermittlung Signalabschnitte für alle Sperrabschnitte
        "***************
        SELECT * FROM zio_5_sa AS sa INTO CORRESPONDING FIELDS OF TABLE @rt_sa
          WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
            AND sa~zest IN @lr_est.

        "*******************
        "* Min/Max Ermittlung
        "***************
        SELECT MIN( km_von ) AS min, MAX( km_bis ) AS max  FROM zio_5_sa AS sa INTO @DATA(ls_ausdehnung)
                 WHERE sa~zzperi = @lv_peri
            AND km_von <= @lv_zzkmbpl
            AND km_bis >= @lv_zzkmvpl
                   AND sa~zest IN @lr_est.

        "*******************
        "* Ermittlung ob noch ein SA angefügt werde muss oder nicht
        "***************
        IF ls_ausdehnung IS NOT INITIAL.
          IF ( ls_ausdehnung-max - io_auftrag->mc_signal_km_abweich ) <= lv_zzkmvpl.
            "rechts noch einen mehr.
            DATA(ls_next) = zcl_io_5_utilities=>get_signalabschnitt_next( EXPORTING is_sa = rt_sa[ km_bis = ls_ausdehnung-max ]  ).
          ENDIF.

          IF ( ls_ausdehnung-min + io_auftrag->mc_signal_km_abweich ) >= lv_zzkmvpl.
            "links noch einen mehr.
            DATA(ls_prev) = zcl_io_5_utilities=>get_signalabschnitt_prev( EXPORTING is_sa = rt_sa[ km_von = ls_ausdehnung-min ]  ).
          ENDIF.
        ENDIF.
    ENDCASE.


    IF ls_next IS NOT INITIAL. APPEND ls_next TO rt_sa. ENDIF.
    IF ls_prev IS NOT INITIAL. APPEND ls_prev TO rt_sa. ENDIF.
    IF ls_next_q IS NOT INITIAL. APPEND ls_next_q TO rt_sa. ENDIF.
    IF ls_prev_q IS NOT INITIAL. APPEND ls_prev_q TO rt_sa. ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SC
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIO_5_FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: ...
*
* SAP-Prozess : ...
*
* Grund:        ( ) QM-Meldung  : ...
*               ( ) Projekt     : OPTREAL
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Ëlvis Papa
*
*-------------Aenderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >000<   7.50       00.00.0000    /
*         Programmerstellung
*----------------------------------------------------------------------*
* >001<   7.50       20.09.2018   SBB AG / Arlene Bucher
*         OPTREAL-268 Alle SC Sicherheitschef aus AS auslesen
*----------------------------------------------------------------------*

    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_io_5_sitzplatz( lo_sitzplaetze_i->get_next( ) ).

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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_schicht.

    ro_schicht = me->mo_schicht.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SIGABS_BY_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INCLUDE_MANUAL              TYPE        BOOLEAN (default =ABAP_FALSE)
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [<-()] RT_SIGABS_EHB                  TYPE        ZIO_5_SA_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_sigabs_by_sp.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get signalabschnitte by Sperrabschnitte
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.5x      22.11.2019   SBB  / Holger Pluschke
*         S 6800000974: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      30.01.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Berücksichtigung von manuell hinzugefügten Benutzereinträgen
*          (aus ZIO_5_SIGNALUSR), wenn das Flag gesetzt ist
*----------------------------------------------------------------------*

   DATA: lt_sigabs_ehb_manual TYPE zio_5_sa_t. ">001<

   DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.
   lo_sp_km ?= mo_sp_kilometer->get( key = iv_sperras_id ).

   DATA(lv_min) = lo_sp_km->get_zkmin( ).
   DATA(lv_max) = lo_sp_km->get_zkmax( ).
   DATA(lv_est) = lo_sp_km->get_text( ).
   DATA(lv_zzperi) = me->mo_schicht->get_data( )-zzperi.


   SELECT * FROM zio_5_sa INTO TABLE @rt_sigabs_ehb
         WHERE  km_von >= @lv_min AND km_bis <= @lv_max
                AND zest EQ @lv_est
                AND zzperi = @lv_zzperi.


*--> Begin Insert >001<
   IF iv_include_manual EQ abap_true AND
     zcl_io_5_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.

     DATA(lt_manual_signals) = lo_sp_km->get_user_signals( ).
     lt_sigabs_ehb_manual = CORRESPONDING #( lt_manual_signals ).

     IF lt_sigabs_ehb_manual[] IS NOT INITIAL.
       APPEND LINES OF lt_sigabs_ehb_manual TO rt_sigabs_ehb.
       SORT rt_sigabs_ehb BY km_von.
     ENDIF.

   ENDIF.
*--> End Insert >001<

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SIGABS_BY_SP_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [<-()] RV_SIGABS_EHB                  TYPE        STRINGVAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sigabs_by_sp_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Erhält Signaltext (Signal ID + Km)
*                           basierend auf SperrabschnitID
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.5x      22.11.2019   SBB  / Holger Pluschke
*         S 6800000974: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      16.01.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Lesen Sie auch die Handbuchsignale (ZIO_5_SIGNALUSR)
*----------------------------------------------------------------------*

    DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.
    lo_sp_km ?= mo_sp_kilometer->get( key = iv_sperras_id ).

    DATA(lv_min) = lo_sp_km->get_zkmin( ).
    DATA(lv_max) = lo_sp_km->get_zkmax( ).
    DATA(lv_est) = lo_sp_km->get_text( ).
    DATA(lv_zzperi) = me->mo_schicht->get_data( )-zzperi.

    SELECT MIN( zsa )  AS von_sa,
           MIN( zehb ) AS von_ehb,
           MAX( zsa )  AS bis_sa,
           MAX( zehb ) AS bis_ehb
      FROM zio_5_sa INTO @DATA(ls_sa_ehb)
      WHERE  (    ( km_von <= @lv_min AND km_bis >= @lv_min ) " An Skizze aufzeichnen
               OR ( km_von >= @lv_min AND km_bis <= @lv_max )
               OR ( km_von < @lv_max AND km_bis >= @lv_max ) )
             AND zest EQ @lv_est
             AND zzperi = @lv_zzperi.

*--> Begin Insert >001<
    IF zcl_io_5_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
      DATA(lv_schicht) = me->mo_schicht->get_id( ).

      SELECT MIN( zsa )  AS von_sa,
             MIN( zehb ) AS von_ehb,
             MAX( zsa )  AS bis_sa,
             MAX( zehb ) AS bis_ehb
       FROM zio_5_signalusr
        INTO @DATA(ls_sa_user_ehb)
            WHERE zarbstl    = @me->ms_arbeitsstelle-zarbstl
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SIGNALABSCHNITT_NEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SA                          TYPE        ZIO_5_SA
* | [--->] IT_SA_RNG                      TYPE        ZIO_5_SPABSCH_RANGE_T(optional)
* | [<-()] RS_SA                          TYPE        ZIO_5_SA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalabschnitt_next.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Setzt den Nich Belegt-Flag
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >001<   7.50       19.07.2021   DXC / Piotr Stelmach
*         6100007427: REAL: Auftrag mit 2 Sperrabschnitte  IT_SA_RNG (+)
*----------------------------------------------------------------------*

    IF it_sa_rng IS INITIAL.   ">001< (+)
      DATA(lt_spabsch_range) = get_sperrabschnitte_range( ).
    ELSE.
      lt_spabsch_range = it_sa_rng.
    ENDIF.                     ">001< (+)

    rs_sa = zcl_io_5_utilities=>get_signalabschnitt_next( EXPORTING is_sa            = is_sa
                                                                    it_spabsch_range = lt_spabsch_range ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SIGNALABSCHNITT_PREV
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SA                          TYPE        ZIO_5_SA
* | [<-()] RS_SA                          TYPE        ZIO_5_SA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_signalabschnitt_prev.

    DATA(lt_spabsch_range) = get_sperrabschnitte_range( ).

    rs_sa = zcl_io_5_utilities=>get_signalabschnitt_prev( EXPORTING is_sa            = is_sa
                                                                    it_spabsch_range = lt_spabsch_range ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SITZPLAETZE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SITZPLAETZE                 TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sitzplaetze.

    DATA: lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug      TYPE REF TO zcl_io_5_fahrzeug,
          lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator,
          lo_sitzplatz     TYPE REF TO zcl_io_5_sitzplatz.

    CREATE OBJECT ro_sitzplaetze.
    lo_fahrzeuge_i ?= mo_fahrzeuge->get_values_iterator( ).

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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SITZPLATZ_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SITZPLATZ_ID                TYPE        ZIO_ID
* | [<-()] RO_SITZPLATZ                   TYPE REF TO ZCL_IO_5_SITZPLATZ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sitzplatz_by_id.

    DATA(lo_fahrzeuge_i) = mo_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ).
      DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplatz_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).

      WHILE lo_sitzplatz_i->has_next( ).
        DATA(lo_sitzplatz) = CAST zcl_io_5_sitzplatz( lo_sitzplatz_i->get_next( ) ).
        CHECK lo_sitzplatz->get_id( ) = iv_sitzplatz_id.

        ro_sitzplatz = lo_sitzplatz.
        RETURN.

      ENDWHILE.
    ENDWHILE.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SPERRABSCHNITTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIO_5_ZUGANGSART(optional)
* | [<-()] RT_MAP_AS_SZG                  TYPE        ZIO_5_MAP_AS_SZG_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte.

    rt_map_as_szg = mt_map_as_szg.

    IF iv_zugangsart IS NOT INITIAL.
      DELETE rt_map_as_szg WHERE zugangsart <> iv_zugangsart.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SPERRABSCHNITTE_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ZIO_5_SPERRABSCHNITT_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte_as_text.

    "Sperrabschnitt-Daten abrufen.
    SELECT sperrabschnitt, zintervallart, sperras_id
      INTO TABLE @DATA(lt_sp_data)
      FROM zio_5_v_map_as
      WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.
    CHECK lt_sp_data[] IS NOT INITIAL.

    SORT lt_sp_data BY sperrabschnitt zintervallart sperras_id.
    DELETE ADJACENT DUPLICATES FROM lt_sp_data COMPARING sperrabschnitt zintervallart.
    SORT lt_sp_data BY sperras_id.

    LOOP AT lt_sp_data ASSIGNING FIELD-SYMBOL(<ls_sp_data>).

      DATA(lv_spabs) = |{ <ls_sp_data>-sperrabschnitt }({ <ls_sp_data>-zintervallart })|.

      IF rv_value IS INITIAL.
        rv_value = lv_spabs.
      ELSE.
        rv_value = |{ rv_value }; { lv_spabs }|.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SPERRABSCHNITTE_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIO_5_ZUGANGSART(optional)
* | [<-()] RT_VALUE                       TYPE        ZIO_5_ARBSTL_SPABSCHT_KM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_sperrabschnitte_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Sperrabschnitte KM
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50      16.12.2020   SBB  / Thomas Frick
*         S 6800007835: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      19.09.2023   DXC  / Fatima De Villa
*         S 6800029552: NES-Jade-781
*         - Manuelle Signalabschnitte einbeziehen
*----------------------------------------------------------------------*
* >002<   7.52      24.09.2024   DXC  / Roman Knap
*         S 6800036668: JADE-997
*         - Manuelle Signalabschnitte sollen pro Arbeitstelle selektieren
*----------------------------------------------------------------------*
    DATA lt_zugangsart_r TYPE RANGE OF zio_5_map_as_szg-zugangsart.

    IF iv_zugangsart IS NOT INITIAL.
      lt_zugangsart_r = VALUE #( ( sign = 'I' option = 'EQ' low = iv_zugangsart ) ).
    ENDIF.

    SELECT spabs~zschicht,
           spkm~zarbstl,
           spkm~sperras_id,
           map~zugangsart,
           spabs~sperrabschnitt,
           spabs~zintervallart,
           spkm~zkmin,
           spkm~zkmax
      INTO CORRESPONDING FIELDS OF TABLE @rt_value
      FROM       zio_5_sp_km      AS spkm
      INNER JOIN zio_5_map_as_szg AS map ON map~zarbstl    = spkm~zarbstl
                                        AND map~sperras_id = spkm~sperras_id
      INNER JOIN zio_5_sp_schicht AS spabs ON spabs~sperras_id = spkm~sperras_id
      WHERE spkm~zarbstl   =  @ms_arbeitsstelle-zarbstl
        AND map~zugangsart IN @lt_zugangsart_r[].

*--> Begin Insert >001<
    SELECT spabs~zschicht,
           spkm~zarbstl,
           signalusr~sperras_id,
           spabs~sperrabschnitt,
           spabs~zintervallart,
           signalusr~km_von AS zkmin,
           signalusr~km_bis AS zkmax
    FROM       zio_5_sp_km      AS spkm
    INNER JOIN zio_5_sp_schicht AS spabs
       ON spabs~sperras_id = spkm~sperras_id
    INNER JOIN zio_5_signalusr  AS signalusr
       ON spabs~sperras_id =  signalusr~sperras_id
       AND spkm~zarbstl =  signalusr~zarbstl               ">003< INS
      WHERE spkm~zarbstl   =  @ms_arbeitsstelle-zarbstl
     APPENDING CORRESPONDING FIELDS OF TABLE @rt_value.
*--> End Insert >001<

    IF iv_zugangsart IS INITIAL.
      MODIFY rt_value FROM VALUE #( zugangsart = iv_zugangsart ) TRANSPORTING zugangsart WHERE zugangsart IS NOT INITIAL.
    ENDIF.

    SORT rt_value.
    DELETE ADJACENT DUPLICATES FROM rt_value COMPARING ALL FIELDS.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_SPERRABSCHNITTE_RANGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_RANGE                       TYPE        ZIO_5_SPABSCH_RANGE_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte_range.

*    DATA(lt_spabsch) = mo_schicht->get_sp_schicht( ).
*
*    rt_range = VALUE #( FOR <ls_spabsch> IN lt_spabsch ( sign = 'I' option = 'EQ' low = <ls_spabsch>-sperrabschnitt ) ).



    rt_range = VALUE #( ( sign = 'I' option = 'EQ' low = mo_schicht->get_rj_est( ) ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SPERRABSCHNITTE_WITH_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIO_5_ZUGANGSART(optional)
* | [<-()] RT_VALUE                       TYPE        ZIO_5_SPID_SPABS_INTART_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sperrabschnitte_with_id.
    DATA lt_zugangsart_r TYPE RANGE OF zio_5_map_as_szg-zugangsart.

    IF iv_zugangsart IS NOT INITIAL.
      lt_zugangsart_r = VALUE #( ( sign = 'I' option = 'EQ' low = iv_zugangsart ) ).
    ENDIF.

    SELECT map~sperras_id,
           map~zugangsart,
           spabs~sperrabschnitt,
           spabs~zintervallart
      INTO CORRESPONDING FIELDS OF TABLE @rt_value
      FROM       zio_5_map_as_szg AS map
      INNER JOIN zio_5_sp_schicht AS spabs ON spabs~sperras_id = map~sperras_id
      WHERE map~zarbstl    =  @ms_arbeitsstelle-zarbstl
        AND map~zugangsart IN @lt_zugangsart_r[].

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_DETAILS_WD
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_SP_EHB                      TYPE        ZIO_5_SP_EHB_WD_T
* | [<---] ET_SP_DETAILS                  TYPE        ZIO_5_SP_DETIALS_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_details_wd.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get SP Details WD
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.5x      22.11.2019   SBB  / Holger Pluschke
*         S 6800000974: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      25.03.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Sperrabs id-Feld ausfüllen
*----------------------------------------------------------------------*

    DATA: lo_sp_zeit       TYPE REF TO zcl_io_5_sp_zeiten,
          lo_sp_km         TYPE REF TO zcl_io_5_sp_kilometer,
          lt_sp_details_wd TYPE STANDARD TABLE OF zio_5_sp_detials_wd_s.
*          lt_sp_ehb        TYPE zio_5_sa_t.

    "Sperrabschnitt pro Schicht
    DATA(lt_sp_schicht) = mo_schicht->get_sp_schicht( ).

    "Alle zugeordnete Sperrabschnitte zur Arbeitsstelle
    DATA(lt_distinct_sp) = me->mt_map_as_szg.
    SORT lt_distinct_sp BY sperras_id.
    DELETE ADJACENT DUPLICATES FROM lt_distinct_sp COMPARING sperras_id.

    LOOP AT lt_distinct_sp ASSIGNING FIELD-SYMBOL(<ls_distinct_sp>) .
      READ TABLE me->mt_map_as_szg WITH KEY sperras_id = <ls_distinct_sp>-sperras_id ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

      lo_sp_zeit ?= me->mo_sp_zeiten->get( key = <ls_map_as_szg>-sperras_id ).
      DATA(ls_sp_zeit) = lo_sp_zeit->get_data( ).
      READ TABLE et_sp_details ASSIGNING FIELD-SYMBOL(<ls_sp_details_wd>) WITH KEY start_datum = ls_sp_zeit-start_datum
                                                                                   start_zeit = ls_sp_zeit-start_zeit
                                                                                   end_datum = ls_sp_zeit-end_datum
                                                                                   end_zeit = ls_sp_zeit-end_zeit.

      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WITH KEY sperras_id = <ls_map_as_szg>-sperras_id.

      "Gruppierung nach Datum/Zeit
      IF <ls_sp_details_wd> IS NOT ASSIGNED OR
         <ls_sp_schicht>-zintervallart = 'TS'.
        "Komination nicht vorhanden => neu

        lo_sp_km ?= me->mo_sp_kilometer->get( key = <ls_map_as_szg>-sperras_id ).

        APPEND INITIAL LINE TO et_sp_details ASSIGNING <ls_sp_details_wd>.
*--> Begin Insert >001<
        IF zcl_io_5_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
          <ls_sp_details_wd>-sperras_id  = ls_sp_zeit-sperras_id.
        ENDIF.
*--> End Insert >001<
        <ls_sp_details_wd>-start_datum = ls_sp_zeit-start_datum.
        <ls_sp_details_wd>-start_zeit  = ls_sp_zeit-start_zeit.
        <ls_sp_details_wd>-end_datum   = ls_sp_zeit-end_datum.
        <ls_sp_details_wd>-end_zeit    = ls_sp_zeit-end_zeit.
        <ls_sp_details_wd>-datum       = ls_sp_zeit-start_datum.
        <ls_sp_details_wd>-sp_zeiten = |{ ls_sp_zeit-start_zeit(2) }:{ ls_sp_zeit-start_zeit+2(2) }:{ ls_sp_zeit-start_zeit+4(2) } - {
                                          ls_sp_zeit-end_zeit(2) }:{ ls_sp_zeit-end_zeit+2(2) }:{ ls_sp_zeit-end_zeit+4(2) } {
                                          <ls_sp_schicht>-sperrabschnitt }|.
        <ls_sp_details_wd>-sp_kilometer = |KM: { lo_sp_km->get_ausdehnung_as_text( ) }|.
        <ls_sp_details_wd>-sp_sigabs_ehb = |Signalabschn./EHB: { me->get_sigabs_by_sp_as_text( <ls_map_as_szg>-sperras_id ) }|.
        <ls_sp_details_wd>-sp_filter = <ls_sp_schicht>-sperrabschnitt.
      ELSE.
        "Kombination vorhanden
        READ TABLE lt_sp_schicht ASSIGNING <ls_sp_schicht> WITH KEY sperras_id = <ls_map_as_szg>-sperras_id.
        <ls_sp_details_wd>-sp_zeiten = |{ <ls_sp_details_wd>-sp_zeiten };{ <ls_sp_schicht>-sperrabschnitt }|.
        <ls_sp_details_wd>-sp_filter = |{ <ls_sp_details_wd>-sp_filter }{ <ls_sp_schicht>-sperrabschnitt }|.
        CLEAR: <ls_sp_details_wd>-sp_kilometer, <ls_sp_details_wd>-sp_sigabs_ehb.
        "Zusammenfassung von Kilometer und Signalabschnitten/Erhaltungsbezirken
      ENDIF.

      DATA(lt_tmp) = get_sigabs_by_sp( iv_sperras_id = <ls_map_as_szg>-sperras_id ).
      LOOP AT lt_tmp ASSIGNING FIELD-SYMBOL(<ls_tmp>).
        APPEND INITIAL LINE TO et_sp_ehb ASSIGNING FIELD-SYMBOL(<ls_sp_ehb>).
        MOVE-CORRESPONDING <ls_tmp> TO <ls_sp_ehb>.
        <ls_sp_ehb>-sp_filter = <ls_sp_schicht>-sperrabschnitt.
      ENDLOOP.


    ENDLOOP.

*    MOVE-CORRESPONDING lt_sp_ehb TO et_sp_ehb.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_KILOMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SP_KILOMETER                TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_kilometer.

    ro_sp_kilometer = me->mo_sp_kilometer.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_KTEXT_TAB
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_DATA                        TYPE        TTY_SP_KTEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_ktext_tab.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get kurz Text SP Tabelle
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >001<   7.52       25.04.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-499
*----------------------------------------------------------------------*
    CONSTANTS lc_sort_asc    TYPE string     VALUE 'ASCENDING'.
    CONSTANTS lc_sort_desc   TYPE string     VALUE 'DESCENDING'.
    CONSTANTS lc_zid_eiz_sed TYPE zio_id_eiz VALUE 10.
    CONSTANTS lc_zid_eiz_fad TYPE zio_id_eiz VALUE 20.
    CONSTANTS lc_as_prefix_n TYPE zio_5_met_as_name_prefix VALUE 'N'.
    CONSTANTS lc_as_prefix_s TYPE zio_5_met_as_name_prefix VALUE 'S'.

    DATA(lt_as_sort)     = VALUE tty_as_km_sort( ).
    DATA(lv_prefix)      = VALUE char1( ).
    DATA(ls_data)        = VALUE ty_sp_ktext( ).
    DATA(lt_kenzchn_btg) = VALUE tty_pneu_kennzeichen( ).
    DATA(lv_zid_eiz)     = VALUE zio_id_eiz( ).  ">001< (+)
    DATA(lv_zid_eiz_as)  = VALUE zio_id_eiz( ).  ">001< (+)
    DATA(lv_sort_order)  = VALUE string( ).

    CLEAR et_data.
    CHECK mo_schicht IS BOUND.

    DATA(lo_auftrag) = me->get_auftrag( iv_index = 1 ).
    DATA(lv_perim) = COND #( WHEN lo_auftrag IS BOUND THEN lo_auftrag->get_data( )-zzperi ELSE mo_schicht->get_data( )-zzperi ).
    DATA(ls_zugangsarten) = me->get_zugangsarten( ).

    "1. Check only Schiene - Prefix N,S or C
    DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( mo_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.                                      "Collect all AS to determine the AS order
      DATA(lo_arbstelle) = CAST zcl_io_5_arbeitsstelle( lo_arbstelle_i->get_next( ) ).
*      IF lv_perim = 'GBT'.                           "Collect AS only for the sams EIZ(N or S) in GBT    ">001< (-)
*        CHECK ms_arbeitsstelle-zid_eiz = lo_arbstelle->get_data( )-zid_eiz.                              ">001< (-)
*      ENDIF.                                                                                             ">001< (-)

      CHECK NOT lo_arbstelle->is_btg( ).

      ">001< begin (+)
      lv_zid_eiz_as    = lo_arbstelle->get_data( )-zid_eiz.
      IF lo_arbstelle->has_met( ) .
        lv_zid_eiz_as = COND #( WHEN lo_arbstelle->get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_zid_eiz_sed ELSE lc_zid_eiz_fad ).
      ENDIF.

      lv_zid_eiz       = ms_arbeitsstelle-zid_eiz.
      IF ms_arbeitsstelle-prefix_met_as IS NOT INITIAL.
        lv_zid_eiz = COND #( WHEN me->get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_zid_eiz_sed ELSE lc_zid_eiz_fad ).
      ENDIF.

      IF lv_zid_eiz = lv_zid_eiz_as.
        IF lv_zid_eiz = lc_zid_eiz_sed OR lv_perim = zif_io_5_constant=>mc_perim-cbt.
          lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = lo_arbstelle->get_data( )-zarbstl km_max = lo_arbstelle->get_data( )-zkmin ) ).
        ELSEIF lv_zid_eiz = lc_zid_eiz_fad.
          lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = lo_arbstelle->get_data( )-zarbstl km_max = lo_arbstelle->get_data( )-zkmax ) ).
        ENDIF.
      ENDIF.
      ">001< end (+)
      ">001< begin (-)
*      IF ms_arbeitsstelle-zid_eiz = 10 OR lv_perim = 'CBT'. "N(GBT) or N(CBT)
*        lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = lo_arbstelle->get_data( )-zarbstl km_max = lo_arbstelle->get_data( )-zkmin ) ).
*      ELSEIF ms_arbeitsstelle-zid_eiz = 20.                 "S(GBT)
*        lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = lo_arbstelle->get_data( )-zarbstl km_max = lo_arbstelle->get_data( )-zkmax ) ).
*      ENDIF.
      ">001< end (-)
    ENDWHILE.

    ">002< begin (+)
    lo_arbstelle_i = CAST cl_object_collection_iterator( mo_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle = CAST zcl_io_5_arbeitsstelle( lo_arbstelle_i->get_next( ) ).
      DATA(lt_map_sp_as) = lo_arbstelle->get_map_sp_as( abap_true ).
      IF line_exists( lt_map_sp_as[ zarbstl = lo_arbstelle->get_id( ) sperrabschnitt = 'N7' ] ).
        ASSIGN lt_as_sort[ zarbstl = lo_arbstelle->get_id( ) ] TO FIELD-SYMBOL(<ls_as_sort>).
        IF sy-subrc = 0.
          <ls_as_sort>-km_max =  <ls_as_sort>-km_max - 100.
        ENDIF.
      ENDIF.
      IF line_exists( lt_map_sp_as[ zarbstl = lo_arbstelle->get_id( ) sperrabschnitt = 'S6' ] ).
        ASSIGN lt_as_sort[ zarbstl = lo_arbstelle->get_id( ) ] TO <ls_as_sort>.
        IF sy-subrc = 0.
          <ls_as_sort>-km_max =  <ls_as_sort>-km_max + 100.
        ENDIF.
      ENDIF.
    ENDWHILE.
    ">002< end (+)

    lt_map_sp_as = me->get_map_sp_as( abap_true ).                                "Get map data (Sperrabschintte<->Arbeitsstelle)

    ">001< begin (+)
    lv_sort_order = COND #( WHEN lv_perim =  zif_io_5_constant=>mc_perim-cbt THEN lc_sort_desc
                            WHEN has_met( )
                            THEN COND #( WHEN get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_sort_desc ELSE lc_sort_asc )
                            ELSE COND #( WHEN get_data( )-zid_eiz = lc_zid_eiz_sed       THEN lc_sort_desc ELSE lc_sort_asc ) ).
    IF lv_sort_order = lc_sort_desc.
      SORT lt_as_sort BY km_max DESCENDING.
    ELSEIF  lv_sort_order = lc_sort_asc.
      SORT lt_as_sort BY km_max.
    ENDIF.
    ">001< end (+)

    "HP: die Nummerrierung geht für alle Arbeitsstellen von der Tunnelmitte nach aussen, auch offene Strecke
    ">001< begin (-)
*    IF ms_arbeitsstelle-zid_eiz = 10 OR lv_perim = 'CBT'. "N(GBT) or N(CBT)
*      SORT lt_as_sort BY km_max DESCENDING.
*    ELSEIF ms_arbeitsstelle-zid_eiz = 20.                 "S(GBT)
*      SORT lt_as_sort BY km_max.
*    ENDIF.
    ">001< end (-)

    IF ( line_exists( lt_map_sp_as[ zugangsart = '1' ] ) OR ls_zugangsarten-schiene = abap_true ) AND me->is_schiene( ).
************      IF ms_arbeitsstelle-zid_eiz = 10 OR lv_perim = 'CBT'. "N(GBT) or N(CBT)
************        SORT lt_as_sort BY km_max DESCENDING.
************      ELSEIF ms_arbeitsstelle-zid_eiz = 20.                 "S(GBT)
************        SORT lt_as_sort BY km_max .
************      ENDIF.

      APPEND INITIAL LINE TO et_data ASSIGNING FIELD-SYMBOL(<ls_data>).
      <ls_data>-position   = lines( et_data ).
      <ls_data>-index      = line_index( lt_as_sort[ zarbstl = me->ms_arbeitsstelle-zarbstl ] ).
      <ls_data>-zugangsart = '1'.
      <ls_data>-prefix   = COND #( WHEN lv_perim = 'GBT' AND me->ms_arbeitsstelle-zid_eiz = 10 THEN 'N'
                                   WHEN lv_perim = 'GBT' AND me->ms_arbeitsstelle-zid_eiz = 20 THEN 'S'
                                   WHEN lv_perim = 'CBT' THEN 'C' ).
      ">001< begin (+)
      <ls_data>-prefix   = COND #( WHEN ms_arbeitsstelle-prefix_met_as IS NOT INITIAL THEN ms_arbeitsstelle-prefix_met_as
                                   ELSE <ls_data>-prefix  ).
      ">001< end (+)
    ENDIF.

    "2.Check Strasse - Prefix from ZIO_5_PLPERIM + Index which is the same as for Schiene(non-BTG) or from zio_5_gebaeude(BTG)
    IF ( line_exists( lt_map_sp_as[ zugangsart = '2' ] ) OR ls_zugangsarten-pneu = abap_true ).
      IF NOT me->is_btg( ).
        DATA(lt_kennzeichen) =  me->get_pneu_kennzeichen( ).
        LOOP AT lt_kennzeichen ASSIGNING FIELD-SYMBOL(<ls_kennzeichen>).
          DATA(lv_as_index) = line_index( lt_as_sort[ zarbstl = me->ms_arbeitsstelle-zarbstl ] ).
          CHECK NOT line_exists( et_data[ prefix = <ls_kennzeichen>-zarbstbez  index = lv_as_index  zugangsart = '2' ] ).
          et_data = VALUE #( BASE et_data ( position   = lines( et_data ) + 1
                                            prefix     = <ls_kennzeichen>-zarbstbez
                                            index      = lv_as_index
                                            zugangsart = '2' ) ).
        ENDLOOP.
      ENDIF.

      IF me->is_btg( ).   "Compare with other AS-BTG in Schicht (for the same Kenneichen ) to get INDEX
        lo_arbstelle_i = CAST cl_object_collection_iterator( mo_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).
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
        et_data = VALUE #( BASE et_data ( position   = lines( et_data ) + 1
                                          prefix     = lv_kennzeichen_btg
                                          index      = line_index( lt_kenzchn_btg[ index = lv_index ] )
                                          zugangsart = '2' ) ).
      ENDIF.
    ENDIF.

    SORT et_data BY position.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_ZEITEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SP_ZEITEN                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten.

    ro_sp_zeiten = mo_sp_zeiten.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_ZEITEN_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* | [<-()] RS_VALUE                       TYPE        ZIO_5_SP_ZEITEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten_data.

    DATA(lt_spabs) = get_sperrabschnitte_with_id( iv_zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ).
    READ TABLE lt_spabs ASSIGNING FIELD-SYMBOL(<ls_spabs>) WITH KEY sperrabschnitt = iv_sperrabschnitt.
    CHECK sy-subrc = 0.

    DATA(li_sp_zeiten_i) = mo_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_io_5_sp_zeiten( li_sp_zeiten_i->get_next( ) ).
      DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).
      CHECK ls_sp_zeiten-sperras_id = <ls_spabs>-sperras_id.

      rs_value = CORRESPONDING #( ls_sp_zeiten ).

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_SP_ZEITEN_TAB
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TTY_SP_ZEITEN_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_zeiten_tab.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Liefert die Tebelle mit Zeiten pro AS-Sperrabschnitte
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_sp_zeit       TYPE REF TO zcl_io_5_sp_zeiten.


    DATA(lt_sp_schicht) = me->mo_schicht->get_sp_schicht( ).

    LOOP AT me->mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).

      lo_sp_zeit ?= me->mo_sp_zeiten->get( key = <ls_map_as_szg>-sperras_id ).
      CHECK lo_sp_zeit IS BOUND.

      READ TABLE lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>)
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_SUPPLY_TYPE_AS_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DATA                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_supply_type_as_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get supply type as text
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52       03.04.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-618
*----------------------------------------------------------------------*
    DATA lt_sp_data TYPE STANDARD TABLE OF zio_5_v_map_as WITH DEFAULT KEY.

    SELECT supply_type
      INTO CORRESPONDING FIELDS OF TABLE @lt_sp_data
      FROM zio_5_v_map_as
      WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_TEXT_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGANGSART                  TYPE        ZIO_5_ZUGANGSART
* | [--->] IV_INC_TS                      TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RV_VALUE                       TYPE        ZIO_ARBST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_text_id.

    get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).

    LOOP AT lt_sp_ktext ASSIGNING FIELD-SYMBOL(<ls_sp_ktext>) WHERE zugangsart = iv_zugangsart.
      rv_value = |{ <ls_sp_ktext>-prefix }{ <ls_sp_ktext>-index }|.
      EXIT.
    ENDLOOP.
    CHECK rv_value IS NOT INITIAL.

    IF iv_inc_ts = abap_true.
      rv_value = |{ rv_value }{ COND #( WHEN has_ts( ) THEN `TS` ELSE `` ) }|.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_THF
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SITZPLAETZE                 TYPE        ZIO_5_FZG_PL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_thf.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: ...
*
* SAP-Prozess : ...
*
* Grund:        ( ) QM-Meldung  : ...
*               ( ) Projekt     : OPTREAL-334
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Ëlvis Papa
*
*-------------Aenderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >000<   7.50       00.00.0000    /
*         Programmerstellung
*----------------------------------------------------------------------*
* >001<   7.50       20.09.2018   SBB AG / Arlene Bucher
*         OPTREAL-268 Alle THf Temporäre Hilfsfunktion aus AS auslesen
*----------------------------------------------------------------------*

    DATA(lo_fahrzeuge) = get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).

      DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
      DATA(lo_sitzplaetze_i) = CAST cl_object_collection_iterator( lo_sitzplaetze->get_values_iterator( ) ).

      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_io_5_sitzplatz( lo_sitzplaetze_i->get_next( ) ).

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
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->GET_TRASSE_DATA_FOR_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_RICHTUNG
* | [--->] IV_INTERVALLART                TYPE        ZIO_5_INTERVALLART(optional)
* | [<---] EV_BETRIEBSPUNKT               TYPE        ZIO_5_BETRIEBSPUNKT
* | [<---] EV_DATE                        TYPE        DATS
* | [<---] EV_TIME                        TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_trasse_data_for_ez_form.

    ASSIGN it_ez_form[ zarbstl  = ms_arbeitsstelle-zarbstl
                       richtung = iv_richtung
                       ez_aktiv = abap_true ] TO FIELD-SYMBOL(<ls_ez_form>).

    CHECK sy-subrc = 0.
    CHECK <ls_ez_form>-zugnummer IS NOT INITIAL.
    mo_schicht->get_sp_schicht( ).
    ev_date = mo_schicht->get_data( )-start_datum.

    DATA(lv_time_field) = CONV fieldname( '' ).
    DATA(lt_trassen) = mo_schicht->get_trassen( iv_zugnummer       = <ls_ez_form>-zugnummer
                                                iv_arbstelle_level = abap_true ).
    CASE iv_richtung.
      WHEN zif_io_5_trasse=>mc_richtung_einfahrt.
        lv_time_field = 'ZAN'.
        SORT lt_trassen BY reihenfolge DESCENDING.
      WHEN zif_io_5_trasse=>mc_richtung_ausfahrt.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_WD_HEADER_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_TEXT                        TYPE        ZIO_5_AS_HEADER_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_wd_header_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Liefert den WD-Headertext - Schichtdetails view
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >001<   7.52       05.06.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
    CONSTANTS lc_separator_ver TYPE char1 VALUE '|'.
    DATA(lv_versorgung_txt) = VALUE string( ).        ">001< +

    DATA(ls_intervallarten) = me->get_intervallarten( ).      "Get intervall types

    rv_text = COND #(
        WHEN ls_intervallarten-jokerintervall = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_JOKERINTERVALL')
        WHEN ls_intervallarten-totalsperrung  = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_REGERINTERVALL_MIT_TS')
        WHEN ls_intervallarten-langintervall  = abap_true THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_LANGINTERVALL') ).     ">001< +
*        ELSE cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_REGERINTERVALL') ).                                                     ">001< +

    ">001< + begin - if no Intervallart exists for any Auftrag then get LI from Schicht (of course if exists)
    IF rv_text IS INITIAL.
      DATA(lt_sp_schicht) = mo_schicht->get_sperrabschnitte( ).
      rv_text = COND #( WHEN line_exists( lt_sp_schicht[ zintervallart = zif_io_5_constant=>mc_intervallart-li ] )
                        THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_LANGINTERVALL')
                        ELSE cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_REGERINTERVALL') ). "old logic
    ENDIF.
    ">001< + end

    ">001< + begin
    DATA(lv_supply_type) = mo_schicht->get_parameter( )->get_data( )-supply_type.
    IF lv_supply_type IS NOT INITIAL.
      lv_versorgung_txt = COND #( WHEN lv_supply_type = zif_io_5_constant=>mc_supply_type-versorgung
                                  THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_VERSORGUNGSSCHICHT')
                                  WHEN lv_supply_type = zif_io_5_constant=>mc_supply_type-entsorgung
                                  THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_ENTSORGUNG')
                                  WHEN lv_supply_type = zif_io_5_constant=>mc_supply_type-keine_fahrt
                                  THEN cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_KEINE_FAHRT')
                                  ELSE cl_wd_utilities=>get_otr_text_by_alias('ZIO_5/AS_KEINE_LOGISTIKSCHICHT') ).
      rv_text = |{ rv_text } | & |{ lc_separator_ver } | & |{ lv_versorgung_txt }|.
    ENDIF.
    ">001< + end

    rv_text = | { rv_text } | & | { lc_separator_ver } | & | { me->get_kurztext( ) } |.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->GET_ZUGANGSARTEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_ZUGANGSARTEN                TYPE        ZIO_5_ZUGANGSARTEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_zugangsarten.

    rs_zugangsarten-schiene = abap_false.
    rs_zugangsarten-pneu = abap_false.

    DATA: lo_auftgrag TYPE REF TO zcl_io_5_auftrag.

    DATA(lo_auftraege_iterator) = me->mo_orders->get_values_iterator( ).

    WHILE lo_auftraege_iterator->has_next( ).
      lo_auftgrag ?= lo_auftraege_iterator->get_next( ).

      CASE lo_auftgrag->get_data( )-zzzugangsart.
          WHEN '1':.  "1  Schiene
          rs_zugangsarten-schiene = abap_true.
          WHEN '2':.  "2  Strasse
          rs_zugangsarten-pneu = abap_true.
      ENDCASE.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->HAS_AUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_auftrag.

    rv_value = boolc( mo_orders->get( key = iv_aufnr ) IS BOUND ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->HAS_MET
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_met.

    IF me->ms_arbeitsstelle-zmet IS NOT INITIAL.
      rv_boolean = abap_true.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->HAS_OSX
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_osx.
    rv_boolean = abap_false.
    "-------------------------------------------------------------------------------------
    " prüft, ob es in Arbeitsstelle OSX enthält
    "-------------------------------------------------------------------------------------

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      SELECT substring( sperrabschnitt, 1, 1 ) AS sperrabschnitt
        FROM zio_5_sp_schicht
        WHERE sperras_id EQ @<ls_map_as_szg>-sperras_id
        APPENDING TABLE @DATA(lt_sps).
    ENDLOOP.

    "OSS
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'S' TRANSPORTING NO FIELDS.
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->HAS_TS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_HAS_TS                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_ts.

    rv_has_ts = abap_false.

    me->get_sp_ktext_tab( IMPORTING et_data = DATA(lt_sp_ktext) ).

    IF lt_sp_ktext IS INITIAL.
      RETURN.
    ENDIF.

    IF line_exists( mt_map_sp_as[ zintervallart = 'TS' ] ).
      rv_has_ts = abap_true.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IO_5_ARBEITSSTELLE=>INIT_MIN_KM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init_min_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Init Min Km
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50      22.10.2020   SBB   / Thomas Frick
*         S 6800007835: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      13.04.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-671
*         - E* und W* zur Auswahl hinzufügen
*----------------------------------------------------------------------*

    add_min_km( iv_perimeter = 'GBT' iv_sperrabschnitt = 'E' ).
    add_min_km( iv_perimeter = 'GBT' iv_sperrabschnitt = 'W' ).
    add_min_km( iv_perimeter = 'CBT' iv_sperrabschnitt = 'E' ).
    add_min_km( iv_perimeter = 'CBT' iv_sperrabschnitt = 'W' ).

*--> Begin Insert >001<
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
*--> End Insert >001<

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->INSERT_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD insert_ez_form.
    DATA lt_has_changed TYPE RANGE OF abap_bool.
    DATA lt_db TYPE STANDARD TABLE OF zio_5_ez_form WITH EMPTY KEY.

    IF get_perimeter( ) = 'GBT'.
      " for GBT save only changed records
      lt_has_changed = VALUE #( ( sign = 'I' option = 'EQ' low = abap_true ) ).
    ENDIF.

    lt_db = VALUE #( FOR <ls_ez_form> IN it_ez_form WHERE ( zarbstl     =  ms_arbeitsstelle-zarbstl
                                                      AND   ez_aktiv    =  abap_true
                                                      AND   has_changed IN lt_has_changed[] )
                         ( zschicht    = ms_arbeitsstelle-zschicht
                           zugnummer   = <ls_ez_form>-zugnummer
                           zarbstl     = ms_arbeitsstelle-zarbstl
                           zid_eiz     = ms_arbeitsstelle-zid_eiz
                           richtung    = <ls_ez_form>-richtung
                           data_origin = <ls_ez_form>-data_origin
                           ez_aktiv    = <ls_ez_form>-ez_aktiv
                           ernam       = sy-uname
                           erdat       = sy-datum
                           erzeit      = sy-uzeit ) ).

    CHECK lt_db[] IS NOT INITIAL.

    INSERT zio_5_ez_form FROM TABLE lt_db ACCEPTING DUPLICATE KEYS.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_ABHAENGIG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_abhaengig.

    rv_value = abap_false.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_BTG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_ID_BTG                      TYPE        ZIO_ID_BTG
* | [<-()] RV_BOOLEAN                     TYPE        WDY_BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_btg.

    "*******************
    "* Kennzeichen ob eine Arbeitsstelle in einem BTG ist
    "***************
    ev_id_btg = me->ms_arbeitsstelle-zid_btg.
    rv_boolean = COND #( WHEN me->ms_arbeitsstelle-zid_btg IS INITIAL THEN abap_false ELSE abap_true ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_EMPTY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_empty.

    TRY .
        rv_value = mo_orders->is_empty( ).

      CATCH cx_sy_ref_is_initial.
        rv_value = abap_true.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_FZG_KM_SA_TRENNUNG_VALID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_fzg_km_sa_trennung_valid.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Check if km/signal Zugsinformation is still
*                           valid
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      06.05.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.

    rv_value = abap_true. "Default

    lo_fahrzeuge_i ?= mo_fahrzeuge->get_values_iterator( ).

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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_IN_OS_NORD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_os_nord.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Check if AS is in OSN
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >001<   7.52       12.06.2025   DXC / Piotr Stelmach
*         6800040733: NES:JADE-1230
*----------------------------------------------------------------------*
    rv_boolean = abap_false.
    ">001< (+) begin
    IF ms_arbeitsstelle-zid_btg IS NOT INITIAL.
      RETURN.
    ENDIF.
    ">001< (+) begin

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      SELECT substring( sperrabschnitt, 1, 1 ) AS sperrabschnitt
        FROM zio_5_sp_schicht
        WHERE sperras_id EQ @<ls_map_as_szg>-sperras_id
        APPENDING TABLE @DATA(lt_sps).
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_IN_OS_SUED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_os_sued.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Check if AS is in OSS
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >001<   7.52       12.06.2025   DXC / Piotr Stelmach
*         6800040733: NES:JADE-1230
*----------------------------------------------------------------------*

    rv_boolean = abap_false.
    ">001< (+) begin
    IF ms_arbeitsstelle-zid_btg IS NOT INITIAL.
      RETURN.
    ENDIF.
    ">001< (+) begin

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      SELECT substring( sperrabschnitt, 1, 1 ) AS sperrabschnitt
        FROM zio_5_sp_schicht
        WHERE sperras_id EQ @<ls_map_as_szg>-sperras_id
        APPENDING TABLE @DATA(lt_sps).
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_in_tunnel.
*--------------änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*

    rv_boolean = abap_false.

    "*******************
    "* NEU: Prüfung auf die in der Arbeitstelle vorhandenen Sperrabschnitte
    "***************
    LOOP AT mt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      SELECT substring( sperrabschnitt, 1, 1 ) AS sperrabschnitt
        FROM zio_5_sp_schicht
        WHERE sperras_id EQ @<ls_map_as_szg>-sperras_id
        APPENDING TABLE @DATA(lt_sps).
    ENDLOOP.

    "Tunnel
    READ TABLE lt_sps WITH KEY sperrabschnitt = 'E' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

    READ TABLE lt_sps WITH KEY sperrabschnitt = 'W' TRANSPORTING NO FIELDS.
    IF syst-subrc = 0.
      rv_boolean = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_PNEU
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_pneu.

    rv_boolean = COND #( WHEN lines( mt_map_as_szg ) > 0
                         " NO Zugangsart Schine => Strasse ONLY => IS_PNEU returns TRUE
                         THEN boolc( NOT line_exists( mt_map_as_szg[ zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ] ) )
                         " NO Zugangsart at all
                         ELSE abap_false
                       ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->IS_SCHIENE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_schiene.

    rv_boolean = boolc( line_exists( mt_map_as_szg[ zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ] ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->LOCK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHECK                       TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/ description: Lock des Arbeitsplatzes
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:  Elvis Papa
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50       30.10.2019   SBB AG / Arlene Bucher
*         Programmerstellung/ creation
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

*-----------------------------------------------------------------
* Bei AS immer prüfen, ob Schicht gesperrt werden kann
*-----------------------------------------------------------------
    TRY.
        CALL METHOD mo_schicht->lock( iv_check = abap_true ).
      CATCH zcx_io_5_fehler INTO DATA(lo_fehler).
        RAISE EXCEPTION lo_fehler.
    ENDTRY.

*-----------------------------------------------------------------
* AS Sperren
*-----------------------------------------------------------------

    CALL FUNCTION 'ENQUEUE_EZ_5_ARBSTELLEN'
      EXPORTING
        mode_zio_5_arbstellen = lv_mode
        mandt                 = sy-mandt
        zarbstl               = ms_arbeitsstelle-zarbstl
        _scope                = '1'
      EXCEPTIONS
        foreign_lock          = 1
        system_failure        = 2
*       OTHERS                = 3
      .

*-----------------------------------------------------------------
* Rückgabe vorbereiten
*-----------------------------------------------------------------
    IF sy-subrc <> 0.
      IF sy-msgv1 IS NOT INITIAL.
        TRY.
            zcl_io_5_utilities=>get_user_details( EXPORTING iv_uname       = CONV uname( sy-msgv1 )
                                                  IMPORTING ev_voller_name = DATA(lv_name) ).
          CATCH zcx_io_5_fehler .
        ENDTRY.
      ENDIF.

      DATA(lv_kurztext) = get_kurztext( ).
      IF lo_fehler IS INITIAL.
        lo_fehler = NEW zcx_io_5_fehler( ).
      ENDIF.
      lo_fehler->add_error_msg( EXPORTING iv_msgid = 'ZIO_3_MMT'  iv_msgno =  155 iv_msgv1 = lv_kurztext iv_msgv2 = lv_name ).
      RAISE EXCEPTION lo_fehler.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->LOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHECK                       TYPE        BOOLEAN
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock_sub_objects.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/ description: Lock der Subobjekte des Arbeitsplatzes
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:  Elvis Papa
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50       30.10.2019   SBB AG / Arlene Bucher
*         Programmerstellung/ creation
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_fahrzeuge   TYPE REF TO cl_object_map,
          lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.

    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

    lo_fahrzeuge = get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      TRY.
          CALL METHOD lo_fahrzeug->lock EXPORTING iv_check = iv_check.
          CALL METHOD lo_fahrzeug->lock_subobjects EXPORTING iv_check = iv_check.
        CATCH zcx_io_5_fehler INTO DATA(lo_fehler).
          RAISE EXCEPTION lo_fehler.
      ENDTRY.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_AUSDEHNUNG_MET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_ausdehnung_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Refresh ausdehung
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >001<   7.52       12.07.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-715
*----------------------------------------------------------------------*
    IF me->ms_arbeitsstelle-zmet IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_met)        = zcl_io_5_met=>get_met_by_id( me->ms_arbeitsstelle-zmet ).
    DATA(ls_sa)         = zcl_io_5_utilities=>get_sa_by_km(
                            iv_peri    = mo_schicht->get_data( )-zzperi
                            iv_km      = ls_met-zkm
                            iv_zest    = ls_met-zzest
                            io_schicht = mo_schicht  ).  ">001< +
    DATA(lt_sp_schicht) = mo_schicht->get_sp_schicht( ).

    TRY.
        DATA(ls_sp_schicht) =  lt_sp_schicht[ sperrabschnitt = ls_met-zzest ].
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    "Extend the ausdehung of Sperrabschnitt
    DATA(lo_sp_km) = CAST zcl_io_5_sp_kilometer( mo_sp_kilometer->get( key = ls_sp_schicht-sperras_id ) ).
    IF lo_sp_km IS NOT BOUND.
      RETURN.
    ENDIF.

    DATA(ls_sp_km) = lo_sp_km->get_data( ).
    ls_sp_km-zkmin = COND #( WHEN ls_sa-km_von < ls_sp_km-zkmin THEN ls_sa-km_von ELSE ls_sp_km-zkmin ).
    ls_sp_km-zkmax = COND #( WHEN ls_sa-km_bis > ls_sp_km-zkmax THEN ls_sa-km_bis ELSE ls_sp_km-zkmax ).

    lo_sp_km->set_data( ls_sp_km ).
    mo_sp_kilometer->put( EXPORTING key = ls_sp_schicht-sperras_id value = lo_sp_km ).

    "Set the mon/max ausdehung of AS
    ms_arbeitsstelle-zkmin = COND #( WHEN ls_sa-km_von < ms_arbeitsstelle-zkmin THEN ls_sa-km_von ELSE ms_arbeitsstelle-zkmin ).
    ms_arbeitsstelle-zkmax = COND #( WHEN ls_sa-km_bis > ms_arbeitsstelle-zkmax THEN ls_sa-km_bis ELSE ms_arbeitsstelle-zkmax ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_AUSDEHUNG
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD refresh_ausdehung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get zkmin
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.5x      22.11.2019   SBB  / Holger Pluschke
*         S 6800000974: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      15.03.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Manuell hinzugefügte Benutzereinträge (aus ZIO_5_SIGNALUSR)
*           beim Abrufen des Mindestwerts berücksichtigen
*----------------------------------------------------------------------*
  DATA: lv_abs_min TYPE zio_km_von VALUE 1000,
        lb_abs_max TYPE zio_km_bis VALUE 0,
        lo_sp_km   TYPE REF TO zcl_io_5_sp_kilometer.

  "Sperrabschnitt Kilomter speichern
  DATA(lo_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
  WHILE lo_sp_km_i->has_next( ) = abap_true.
    lo_sp_km ?= lo_sp_km_i->get_next( ).

    CHECK lo_sp_km->get_intervallart( ) NE 'TS'.
*--> Begin Change >001<
    lv_abs_min = COND #( WHEN lv_abs_min < lo_sp_km->get_zkmin( abap_true ) THEN lv_abs_min ELSE lo_sp_km->get_zkmin( abap_true ) ).
    lb_abs_max = COND #( WHEN lb_abs_max > lo_sp_km->get_zkmax( abap_true )  THEN lb_abs_max ELSE lo_sp_km->get_zkmax( abap_true )  ).
*--> End Change >001<
  ENDWHILE.

  me->ms_arbeitsstelle-zkmin = lv_abs_min.
  me->ms_arbeitsstelle-zkmax = lb_abs_max.

  me->refresh_ausdehnung_met( ).

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_EIZ_EST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIO_5_AUFTR(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_eiz_est.
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        09.08.2018  SBB AG / Fredy Villiger
*         QM900088053: Feld ZSTDKZ beachten.
*----------------------------------------------------------------------*

*****    DATA lt_sperrabschnitte     TYPE stringtab.
*****    DATA lt_sperrabschnitte_as  TYPE stringtab.
*****    DATA lv_sperrabschnitt_as   TYPE string.
*****    DATA lv_standort            TYPE char1.
*****    DATA lv_est                 TYPE char5.
*****    DATA lo_auftraege_i         TYPE REF TO cl_object_collection_iterator.
*****    DATA lo_auftrag             TYPE REF TO zcl_io_5_auftrag.
*****
*****
*****    "Tunnel
*****    IF is_auftrag IS NOT INITIAL.
*****      IF me->ms_arbeitsstelle-zid_eiz = 0.
*****        me->ms_arbeitsstelle-zid_eiz = is_auftrag-zid_eiz.
*****      ENDIF.
*****      "IF me->ms_arbeitsstelle-zest = 'X'.                                       " DEL >001<
*****      IF me->ms_arbeitsstelle-zest = 'X' AND me->ms_arbeitsstelle-zstdkz NE 'G'. " INS >001<
*****        me->ms_arbeitsstelle-zest = is_auftrag-zest.
*****      ENDIF.
*****    ENDIF.
*****
*****    "Offene Strecke:
*****    IF me->check_as_is_in_tunnel( ) EQ abap_false.
*****
*****
*****
*****      "Step1: Alle Sperrabschnitte der eingeplanten Aufträger dieser Arbeitsstelle ermitteln
*****      lo_auftraege_i ?= me->get_auftraege( )->get_values_iterator( ).
*****      WHILE lo_auftraege_i->has_next( ) EQ abap_true.
*****
*****        lo_auftrag ?= lo_auftraege_i->get_next( ).
*****
*****        CLEAR lt_sperrabschnitte.
*****        CALL METHOD zcl_io_utilities=>get_sperrabschnitte_by_zzest
*****          EXPORTING
*****            iv_est             = lo_auftrag->get_data( )-zest
*****          IMPORTING
*****            ev_standort        = lv_standort
*****            et_sperrabschnitte = lt_sperrabschnitte.
*****
*****        APPEND LINES OF lt_sperrabschnitte TO lt_sperrabschnitte_as.
*****
*****      ENDWHILE.
*****
******      "Step2: Optinal: Falls zusätzlicher Auftrag angegeben, wird dieser ebenfalls beachtet (Beispiel: Aufruf aus Methode ADD_AUFTRAG_O
*****      IF is_auftrag IS NOT INITIAL.
*****        CLEAR lt_sperrabschnitte.
*****        CALL METHOD zcl_io_utilities=>get_sperrabschnitte_by_zzest
*****          EXPORTING
*****            iv_est             = is_auftrag-zest
*****          IMPORTING
*****            et_sperrabschnitte = lt_sperrabschnitte.
*****
*****        APPEND LINES OF lt_sperrabschnitte TO lt_sperrabschnitte_as.
*****      ENDIF.
*****
*****      "Step3: EST neu aufbauen
*****      SORT lt_sperrabschnitte_as.
*****      DELETE ADJACENT DUPLICATES FROM lt_sperrabschnitte_as.
*****
*****      "Step4: String aufbauen
*****      lv_est = lv_standort.
*****      LOOP AT lt_sperrabschnitte_as INTO  lv_sperrabschnitt_as.
*****        CONCATENATE lv_est  lv_sperrabschnitt_as INTO lv_est.
*****      ENDLOOP.
*****
*****      me->ms_arbeitsstelle-zest = lv_est.
*****
*****    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_FAHRLEITUNGSSCHALTUNG
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_fahrleitungsschaltung.

    DATA(lt_servprod_fls) = zcl_io_brfplus_interface=>get_fahrleitungsschaltung( ).

    " Standardmässig ist die Fahrleitung an
    me->ms_arbeitsstelle-zfls = abap_true.

    DATA(lo_auftrag_i) = CAST cl_object_collection_iterator( me->mo_orders->get_values_iterator( ) ).
    WHILE lo_auftrag_i->has_next( ) = abap_true.
      DATA(lo_auftrag) = CAST zcl_io_5_auftrag( lo_auftrag_i->get_next( ) ).

      DATA(lv_matsv) = lo_auftrag->get_data( )-matnr.

      READ TABLE lt_servprod_fls INTO DATA(ls_servprod_fls)  WITH KEY matsv = lv_matsv.

      IF sy-subrc = 0 AND ls_servprod_fls-zfls = abap_false.
        me->ms_arbeitsstelle-zfls = abap_false.
        EXIT.
      ENDIF.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_MANUAL_SIGNALS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD REFRESH_MANUAL_SIGNALS.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Manuelle Signale löschen
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      03.01.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*

    DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.

    DATA(lo_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE lo_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= lo_sp_km_i->get_next( ).
      lo_sp_km->refresh_user_signals( ).
      lo_sp_km->save_user_signals( ).
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_SA_SP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_sa_sp.

    "*******************
    "* Reload SP - SA Data
    "***************

    "Aufträge lesen
    DATA: lo_aufttag_i    TYPE REF TO cl_object_collection_iterator,
          lo_auftrag      TYPE REF TO zcl_io_5_auftrag,
          lt_sa_auftraege TYPE zio_5_sa_t.



    lo_aufttag_i ?= mo_orders->get_values_iterator( ).

    WHILE lo_aufttag_i->has_next( ) = abap_true.

      lo_auftrag ?= lo_aufttag_i->get_next( ).

      APPEND LINES OF me->get_sa_for_new_auftrag( iv_rj_est = me->get_schicht( )->get_rj_est( )
                                                  iv_ts_est = me->get_schicht( )->get_ts_est( )
                                                  io_auftrag = lo_auftrag ) TO lt_sa_auftraege.

    ENDWHILE.

    CHECK lines( lt_sa_auftraege ) > 0.

    SORT lt_sa_auftraege BY zsa.
    DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.

    DATA(lv_peri) = mo_schicht->get_data( )-zzperi.
    "Welche Sperrabschnitte haben wir denn so.
    LOOP AT lt_sa_auftraege ASSIGNING FIELD-SYMBOL(<ls_sa>).

      AT NEW zest.
        DATA(lt_tmp_sa) = lt_sa_auftraege.
        DELETE lt_tmp_sa WHERE zest <> <ls_sa>-zest.

        DATA(ls_sa_min) = lt_tmp_sa[ 1 ]-zsa.
        DATA(ls_sa_max) = lt_tmp_sa[ lines( lt_tmp_sa ) ]-zsa.

        SELECT * FROM zio_5_sa
          APPENDING TABLE @DATA(lt_reloaded_sa)
          WHERE zzperi = @lv_peri
            AND zsa >= @ls_sa_min
            AND zsa <= @ls_sa_max
            AND zest = @<ls_sa>-zest.

      ENDAT.

    ENDLOOP.

    APPEND LINES OF lt_reloaded_sa TO lt_sa_auftraege.
    SORT lt_sa_auftraege BY zsa.
    DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.

    "************
    "*     Hier sind dann die Lücken auf dem Einzelnen Intervallen geschlossen
    "**************
    DATA(ls_rj_sa_min) = 99999. DATA(ls_rj_sa_max) = 00000.
    "MIN MAX auf dem Regelintervall
    LOOP AT lt_sa_auftraege ASSIGNING <ls_sa> WHERE zest = me->get_schicht( )->get_rj_est( ).
      ls_rj_sa_min = COND #( WHEN <ls_sa>-zsa < ls_rj_sa_min THEN <ls_sa>-zsa ELSE ls_rj_sa_min ).
      ls_rj_sa_max = COND #( WHEN <ls_sa>-zsa > ls_rj_sa_max THEN <ls_sa>-zsa ELSE ls_rj_sa_max ).
    ENDLOOP.


    "Für jeden anderen RJ Sperrabschnitt müssen wir nun die Lücken Schliessen
    LOOP AT lt_sa_auftraege ASSIGNING <ls_sa> WHERE zest <> me->get_schicht( )->get_rj_est( )
                                                AND zest <> me->get_schicht( )->get_ts_est( ).
      AT NEW zest.
        DATA(lv_osx_zest) = <ls_sa>-zest.

        DATA(ls_osx_sa_min) = 99999. DATA(ls_osx_sa_max) = 00000.
        "MIN MAX auf dem Regelintervall
        LOOP AT lt_sa_auftraege ASSIGNING FIELD-SYMBOL(<ls_sa_osx>) WHERE zest = lv_osx_zest.
          ls_osx_sa_min = COND #( WHEN <ls_sa>-zsa < ls_osx_sa_min THEN <ls_sa>-zsa ELSE ls_osx_sa_min ).
          ls_osx_sa_max = COND #( WHEN <ls_sa>-zsa > ls_osx_sa_max THEN <ls_sa>-zsa ELSE ls_osx_sa_max ).
        ENDLOOP.


        DATA(lv_rj_est) = me->get_schicht( )->get_rj_est( ).

        IF ( ms_arbeitsstelle-zid_eiz = '10' AND lv_peri = 'GBT' ) OR
            ( ms_arbeitsstelle-zid_eiz = '20' AND lv_peri = 'CBT' ).
          "wir schauen richtung norden
          SELECT * FROM zio_5_sa_abfolge
           APPENDING TABLE @DATA(lt_gaps_sa)
           WHERE (      zzperi = @lv_peri
                    AND sperrabschnitt = @lv_rj_est
                    AND signalabschnitt < @ls_rj_sa_min
                    AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) )
                  OR
                (       zzperi = @lv_peri
                    AND sperrabschnitt = @lv_osx_zest
                    AND signalabschnitt > @ls_osx_sa_max
                    AND ( s_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
        ELSE.
          "wir schauen richtung süden
          SELECT * FROM zio_5_sa_abfolge
           APPENDING TABLE @lt_gaps_sa
           WHERE (      zzperi = @lv_peri
                    AND sperrabschnitt = @lv_rj_est
                    AND signalabschnitt < @ls_rj_sa_max
                    AND ( s_sperrabschnitt = @lv_rj_est OR s_sperrabschnitt = @lv_osx_zest ) )
                  OR
                (       zzperi = @lv_peri
                    AND sperrabschnitt = @lv_osx_zest
                    AND signalabschnitt > @ls_osx_sa_min
                    AND ( n_sperrabschnitt = @lv_rj_est OR n_sperrabschnitt = @lv_osx_zest ) ).
        ENDIF.
      ENDAT.

    ENDLOOP.

    DATA: lr_sa TYPE RANGE OF zio_signalabschnitt.
    IF lines( lt_gaps_sa ) > 0.
      LOOP AT lt_gaps_sa ASSIGNING FIELD-SYMBOL(<ls_gap_sa>).
        APPEND INITIAL LINE TO lr_sa ASSIGNING FIELD-SYMBOL(<ls_ra_sa>).
        <ls_ra_sa>-sign = 'I'.
        <ls_ra_sa>-option = 'EQ'.
        <ls_ra_sa>-low = <ls_gap_sa>-signalabschnitt.
      ENDLOOP.

      SELECT * FROM zio_5_sa APPENDING CORRESPONDING FIELDS OF TABLE @lt_sa_auftraege
        WHERE zzperi = @lv_peri
          AND zsa IN @lr_sa.

    ENDIF.

    SORT lt_sa_auftraege BY zsa.
    DELETE ADJACENT DUPLICATES FROM lt_sa_auftraege COMPARING zsa.
    "*******************
    "* Ab hier sind dann die Signalabschnitte wieder korrekt.
    "***************


    "Aufträge lesen
    DATA: lo_sp_km_i TYPE REF TO cl_object_collection_iterator,
          lo_sp_km   TYPE REF TO zcl_io_5_sp_kilometer.

    lo_sp_km_i ?= mo_sp_kilometer->get_values_iterator( ).

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
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->REFRESH_SPERRAS_AUSDEHNUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IO_5_AUFTRAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD refresh_sperras_ausdehnung.

*
*    DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.
*
*    lo_sp_km ?= me->mo_sp_kilometer->get( key = iv_sperras_id ).
*
*    DATA(lv_sp_zkmin) = lo_sp_km->get_zkmin( ).
*    DATA(lv_sp_zkmax) = lo_sp_km->get_zkmax( ).
*
*    DATA(lv_auf_zkmin) = io_auftrag->get_km_by_est( iv_est = lo_sp_km->get_sp( ) )-zkmin.
*    DATA(lv_auf_zkmax) = io_auftrag->get_km_by_est( iv_est = lo_sp_km->get_sp( ) )-zkmax.
*
*    lo_sp_km->set_zkmin( iv_zkmin = COND #( WHEN lv_auf_zkmin < lv_sp_zkmin THEN lv_auf_zkmin ELSE lv_sp_zkmin ) ).
*    lo_sp_km->set_zkmax( iv_zkmax = COND #( WHEN lv_auf_zkmax > lv_sp_zkmax THEN lv_auf_zkmax ELSE lv_sp_zkmax ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung:
*
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Rolf Wahle
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        07.11.2019  SBB AG / Holger Pluschke
*----------------------------------------------------------------------*


*****************************************************************************************************
** Arbeitsstelle einlesen
*****************************************************************************************************
    DATA: lo_arbstelle TYPE REF TO zcl_io_5_arbeitsstelle,
          lo_fahrzeug  TYPE REF TO zcl_io_5_fahrzeug,
          lo_auftrag   TYPE REF TO zcl_io_5_auftrag,
          lo_sp_zeit   TYPE REF TO zcl_io_5_sp_zeiten,
          lo_sp_km     TYPE REF TO zcl_io_5_sp_kilometer,
          lo_fehler    TYPE REF TO zcx_io_5_fehler.


    me->mo_fahrzeuge->clear( ).
    me->mo_orders->clear( ).
    me->mo_sp_zeiten->clear( ).
    me->mo_sp_kilometer->clear( ).

    SELECT SINGLE * FROM zio_5_arbstellen INTO @DATA(ls_arbstelle) WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.   "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zio_5_map_as_fz INTO TABLE @DATA(lt_fahrzeuge) WHERE zid_arbstl = @me->ms_arbeitsstelle-zarbstl.  "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zio_5_auftr INTO TABLE @DATA(lt_auftraege) WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.         "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zio_5_sp_zeiten INTO TABLE @DATA(lt_sp_zeiten) WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.     "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zio_5_sp_km INTO TABLE @DATA(lt_sp_km) WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.             "CI_ALL_FIELDS_NEEDED
    SELECT * FROM zio_5_map_as_szg INTO TABLE @mt_map_as_szg WHERE zarbstl = @me->ms_arbeitsstelle-zarbstl.         "CI_ALL_FIELDS_NEEDED

    me->mt_map_sp_as = me->get_map_sp_as( abap_true ).
    me->ms_arbeitsstelle = ls_arbstelle.

    DATA: lt_sa_auftraege	TYPE zio_5_sa_t.

    " Aufträge einlesen
    LOOP AT lt_auftraege ASSIGNING FIELD-SYMBOL(<ls_auftrag>).
      lo_auftrag = NEW zcl_io_5_auftrag( iv_aufnr = <ls_auftrag>-aufnr ).
      TRY.
          me->reload_auftrag_o( io_order = lo_auftrag ).
        CATCH zcx_io_5_fehler INTO lo_fehler.
      ENDTRY.
    ENDLOOP.

    " Fahrzeuge einlesen
    LOOP AT lt_fahrzeuge ASSIGNING FIELD-SYMBOL(<ls_fzg>).
      lo_fahrzeug = NEW zcl_io_5_fahrzeug( iv_id = <ls_fzg>-zid_fzg io_arbeitsstelle = me ).
      me->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
    ENDLOOP.

    "Sperrabschnitte-Zeiten
    LOOP AT lt_sp_zeiten ASSIGNING FIELD-SYMBOL(<ls_sp_zeiten>).
      lo_sp_zeit = zcl_io_5_sp_zeiten=>get_instance( iv_id = <ls_sp_zeiten>-sp_zeiten_id ).
      add_sp_zeit( io_sp_zeit = lo_sp_zeit ).
    ENDLOOP.

    "Sperrabschnitte-Kilometer
    LOOP AT lt_sp_km ASSIGNING FIELD-SYMBOL(<ls_sp_km>).
      lo_sp_km = NEW zcl_io_5_sp_kilometer( iv_id = <ls_sp_km>-sp_km_id ).
      me->add_sp_km( io_sp_km = lo_sp_km ).
      lo_sp_km->set_schicht( me->mo_schicht ).
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->RELOAD_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IO_5_AUFTRAG(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload_auftrag_o.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung:
*
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Thomas Frick
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        16.09.2019  SBB/Holger Pluschke
*         Erstellung
*----------------------------------------------------------------------*



    zcl_io_message_manager=>get_instance( )->add_message(  EXPORTING iv_msgid = 'ZIO_3_MMT'
                                                                     iv_msgno = 96
                                                                     iv_msgty = 'I'
                                                                     iv_msgv3 =
                                                                     io_order->get_data( )-aufnr ).

    me->mo_orders->put( EXPORTING key = io_order->get_data( )-aufnr   value = io_order ).
    io_order->set_schicht( iv_schicht = me->ms_arbeitsstelle-zschicht ).
    io_order->set_arbeitsstelle_id( iv_arbstl = me->ms_arbeitsstelle-zarbstl ).
    io_order->set_vorschau_flag( iv_vorschau = abap_false ).

    " EIZ + EST in Arbstelle updaten
**    TODO HP
**********    me->refresh_eiz_est( is_auftrag = ls_auftrag ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_AUFTRAEGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHANGE_ERP                  TYPE        BOOLEAN (default =ABAP_TRUE)
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_auftraege.

    DATA: lo_aufttag_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag   TYPE REF TO zcl_io_5_auftrag,
          lo_fehler    TYPE REF TO zcx_io_5_fehler.

    lo_aufttag_i ?= mo_orders->get_values_iterator( ).

    WHILE lo_aufttag_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_aufttag_i->get_next( ).

      CHECK lo_auftrag->get_data( )-zarbstl = me->ms_arbeitsstelle-zarbstl. "Story 222: Nur wirklich zugehörige Aufträge löschen

      TRY.
          me->remove_auftrag_o( io_object = lo_auftrag iv_change_erp = iv_change_erp ).
        CATCH zcx_io_5_fehler INTO lo_fehler.
          RAISE EXCEPTION lo_fehler.
      ENDTRY.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_AUFTRAG_O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECT                      TYPE REF TO ZCL_IO_5_AUFTRAG
* | [--->] IV_CHANGE_ERP                  TYPE        BOOLEAN (default =ABAP_TRUE)
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_auftrag_o.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung:
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Elvis Papa
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.50        10.10.2019  SBB AG / Holger Pluschke
*         Refactoring
*----------------------------------------------------------------------*


    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.
    DATA: lv_aufnr TYPE aufnr,
          lv_count TYPE i VALUE 0. "lt_auftraege TYPE zio_auftraege_t. "OPTREAL-91

    DATA: ls_auftrag   TYPE zio_5_auftr.

    DATA: lcx_fehler TYPE REF TO zcx_io_5_fehler.
    DATA:lv_ustat_tabg    TYPE boolean.

    FIELD-SYMBOLS <ls_auftrag> TYPE zio_5_auftr.


*-----------------------------------------------------------------------------------------------------------
* Info in Appl. Log schreiben
*-----------------------------------------------------------------------------------------------------------
    DATA(lo_log) = zcl_io_log=>get_instance( ).
    IF io_object IS BOUND AND mo_schicht IS BOUND.
      lo_log->add_info( EXPORTING iv_text       = |{ 'Auftrag entfernen' } { io_object->get_data( )-aufnr } { 'entfernen für Schicht:  ' } { mo_schicht->get_data( )-start_datum }|
                                  iv_sub_object = zcl_io_log=>mc_sub_object_planung ).
    ENDIF.
*-----------------------------------------------------------------------------------------------------------

    ls_auftrag = io_object->get_data( ).

    zlofpm_clh_application=>get_instance( iv_applid = 'GBT' ).
    IF zlofpm_cla_agency=>get_status_agent( )->get_ustat_as_string( iv_objnr = io_object->get_data( )-objnr ) CS 'tabg'.
      lv_ustat_tabg = abap_true.
    ENDIF.

    "In Abhängigkeit des Schichtstatus wird beim Einplanen der Status des Auftrags in SAP geändert
    IF    mo_schicht->get_status( ) GE zif_io_5_schicht_status=>mc_interval_provided
      AND iv_change_erp = abap_true
      AND lv_ustat_tabg = abap_false. "Aufträge mit Anwenderstatus "Technsich abgeschlossen" können nicht mehr geändert werden

      " Aufträge im ERP zurücksetzen (Originaldaten laden)
      DATA(lv_zstatus) = mo_schicht->get_status( ).
      IF    lv_zstatus GT zif_io_5_schicht_status=>mc_plannig_started
        AND lv_zstatus LT zif_io_5_schicht_status=>mc_shift_released .
        TRY.
            zcl_io_5_utilities=>restore_auftraege_erp( io_auftrag = io_object ).
          CATCH zcx_io_5_fehler INTO lcx_fehler.
            RAISE EXCEPTION lcx_fehler.
        ENDTRY.
      ENDIF.
    ENDIF.

* Entferne alle Einzelkapas des Auftrags aus den Fahrzeugen/Sitzplaetzen
    lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
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
    me->mo_orders->remove( key = io_object->get_data( )-aufnr ).

* Aktualisiere das Auftragsobjekt
    io_object->set_schicht( iv_schicht = 0 ).
    io_object->set_arbeitsstelle_id( iv_arbstl = 0 ).

* Aktuelisiere die Fahrleitungsschaltung
    me->refresh_fahrleitungsschaltung( ).

* AKtualisiere Ausdehnung
*    me->refresh_ausdehung( ).

*   EIZ + EST in Arbstelle updaten
    me->refresh_eiz_est( ).

* Datenbank aktualisieren
    lv_aufnr = io_object->get_data( )-aufnr.
    " OPTREAL-91 START
    DATA(lv_arbsort) = io_object->get_data( )-zarbsort.
    UPDATE zio_5_auftr SET zschicht = '0' zarbstl = '0' zarbsort = '0' zarbstl_ri = '0' WHERE aufnr = lv_aufnr.
    SELECT COUNT(*) INTO lv_count FROM zio_5_auftr WHERE zarbsort = lv_arbsort. "#EC CI_NOFIELD
    "     Falls ja: nichts tun, da noch abhängige Aufträge mit Arbeitsort
    "     Falls nein: Aufruf von REMOVE_ARBSORT, Arbeitsort wird entfernt
    IF lv_count = 0.
      TRY.
          CALL METHOD zcl_io_utilities=>remove_arbsort
            EXPORTING
              iv_arbsort = lv_arbsort.
        CATCH zcx_io_5_fehler INTO lcx_fehler.
          RAISE EXCEPTION lcx_fehler.
      ENDTRY.
    ENDIF. " OPTREAL-91 END

    IF lv_ustat_tabg = abap_true.
      UPDATE zio_5_auftr SET zstatus = 'E' WHERE aufnr = lv_aufnr.
    ENDIF.
    COMMIT WORK.

*
** Zugangsart zurücksetzen
*    IF me->get_auftraege( )->size( ) = 0.
*      DATA(lo_map) = me->get_abhaengige_as( ).
*      IF lo_map->is_empty( ) = abap_true.
*        me->ms_arbeitsstelle-zzugangsart = 0.
*      ENDIF.
*    ENDIF.
*
*
*    DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
*          lo_arbstelle   TYPE REF TO zcl_io_5_arbeitsstelle,
*          lo_loop_arb    TYPE REF TO zcl_io_5_arbeitsstelle,
*          lo_abhaengig   TYPE xfeld.  "INS LINE
*
*    lo_arbstelle_i ?= me->get_abhaengige_as( )->get_values_iterator( ).
*    "Loop über alle Arbeitsstellen
*
*    WHILE lo_arbstelle_i->has_next( ) = abap_true.
*      CLEAR: lo_abhaengig.  "INS LINE
*      lo_arbstelle ?= lo_arbstelle_i->get_next( ).
*
*      IF lo_arbstelle->is_empty( ).
**        DATA(lo_obj_arb) = lo_arbstelle->get_abhaengige_as( ).
*        DATA(lo_obj_arb) = lo_arbstelle->get_abhaengige_as( me->get_id( ) ).
*
*        "Über alle abhänigen Arbeitsstellen, die aber eventuell "leer" sind, also keine Aufträge haben
*        LOOP AT lo_obj_arb->map ASSIGNING FIELD-SYMBOL(<ls_obj_arb>).
*          lo_loop_arb ?= <ls_obj_arb>-value.
*          IF lo_loop_arb->is_empty( ).
**            me->get_schicht( )->remove_arbeitsstelle( EXPORTING io_object = lo_arbstelle iv_ignore_errors = abap_true ).
*          ELSE.                       "INS LINE
*            lo_abhaengig = abap_true. "INS LINE
*          ENDIF.
*        ENDLOOP.
**        IF sy-subrc <> 0.
*        IF lo_abhaengig = abap_false. "INS LINE
*          me->get_schicht( )->remove_arbeitsstelle( EXPORTING io_object = lo_arbstelle iv_ignore_errors = abap_true ).
*        ENDIF.
*      ENDIF.
*    ENDWHILE.

    refresh_sa_sp( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FAHRZEUG                    TYPE REF TO ZCL_IO_5_FAHRZEUG
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_fahrzeug.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: Testprogramm für die Klasse ZCL_IO_JOBPOOL_MMT.
*               Nach der Abnahme im I02 muss es gelöscht werden.
*
* SAP-Prozess : ...
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : REAL GBT
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Rolf Wahle
*
*--------------Änderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.52       27.11.2023   DXC / Piotr Stelmach
*         6800029711/ JADE-720
*----------------------------------------------------------------------*

    DATA: lv_id_zfg TYPE zio_id_fzg,
          lv_id_as  TYPE zio_id_arbstl.
    DATA: lo_fehler   TYPE REF TO zcx_io_5_fehler.

    lv_id_zfg = io_fahrzeug->get_data( )-zid_fzg.
    lv_id_as = me->ms_arbeitsstelle-zarbstl.
* mit Klassensave wird Fahrzeug gelöscht commit work?---------------------------------
* Delete sollte entfernt werden
    DELETE FROM zio_5_map_as_fz WHERE zid_arbstl = lv_id_as AND zid_fzg = lv_id_zfg.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
    " Aufträge entfernen
    DATA: lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag     TYPE REF TO zcl_io_5_auftrag.

    lo_auftraege_i ?= io_fahrzeug->get_auftraege( )->get_values_iterator( ).

    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).

      CHECK lo_auftrag->get_data( )-zarbstl = me->ms_arbeitsstelle-zarbstl AND lo_auftrag->get_data( )-zarbstl IS NOT INITIAL. "Story 222: Nur wirklich zugehörige Aufträge löschen

      TRY.
          me->remove_auftrag_o( io_object = lo_auftrag ).
        CATCH zcx_io_5_fehler INTO lo_fehler.
          RAISE EXCEPTION lo_fehler.
      ENDTRY.
    ENDWHILE.

    " Sitzplaetze entfernen
    io_fahrzeug->remove_sitzplaetze( ).

    " Delete from ObjectMap
    me->mo_fahrzeuge->remove( key = io_fahrzeug->get_data( )-zid_fzg ).

    "Remove referenced Fahrzeuge               ">001< + begin
    IF mo_schicht->is_versorgung_schicht( ).
      DATA(lt_fzg_ref) = io_fahrzeug->get_refernced_fahrzeuge( ).
      LOOP AT lt_fzg_ref ASSIGNING FIELD-SYMBOL(<ls_fzg_ref>).
        CHECK <ls_fzg_ref>-o_arbstl IS BOUND.
        CHECK <ls_fzg_ref>-o_fzg    IS BOUND.
        TRY.
            <ls_fzg_ref>-o_arbstl->remove_fahrzeug( <ls_fzg_ref>-o_fzg ).
          CATCH zcx_io_5_fehler.
            CONTINUE.
        ENDTRY.
      ENDLOOP.
    ENDIF.                                     ">001< + end

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_fahrzeuge.

    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_io_5_fahrzeug.
    DATA: lo_fehler     TYPE REF TO zcx_io_5_fehler.

    lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      TRY.
          me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
        CATCH zcx_io_5_fehler INTO lo_fehler.
          RAISE EXCEPTION lo_fehler.
      ENDTRY.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_MET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_met.

    DATA(lo_log) = zcl_io_5_log=>get_instance( ).
    MESSAGE s024(zio_5_real) WITH ms_arbeitsstelle-zschicht ms_arbeitsstelle-zarbstl ms_arbeitsstelle-zkmin ms_arbeitsstelle-zkmax INTO DATA(lv_msg).
    lo_log->add_info( iv_text = CONV #( lv_msg )  iv_sub_object = zcl_io_5_log=>mc_sub_object_planung ).

    "Remove MET-Fahrzeuge
    DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( me->mo_fahrzeuge->get_values_iterator( ) ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).
      CHECK lo_fahrzeug->get_fahrzeugtyp( )-zmet = abap_true.
      TRY.
          me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
          DATA(lv_missing_reihung) = lo_fahrzeug->get_reihung( ).
        CATCH zcx_io_5_fehler.
          EXIT.
      ENDTRY.
    ENDWHILE.

    "Remove empty AS
    IF me->mo_orders->size( ) = 0.
      TRY.
          mo_schicht->remove_arbeitsstelle( EXPORTING io_object = me ).
          mo_schicht->save( ).
        CATCH zcx_io_5_fehler.
          RETURN.
      ENDTRY.
      RETURN.
    ENDIF.

    me->ms_arbeitsstelle-zmet = 0.
    me->refresh_sa_sp( ).
    me->refresh_ausdehung( ).
    me->set_tremola_calc( abap_true ).

    IF me->mo_fahrzeuge->size( ) OR
       lv_missing_reihung IS INITIAL.
      RETURN.
    ENDIF.

    "Update Reihung - MET removed
    lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).
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
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_sp.

    me->mo_sp_kilometer->remove( key = iv_sperras_id ).
    DELETE me->mt_map_as_szg WHERE sperras_id =  iv_sperras_id.
    DELETE FROM zio_5_sp_km WHERE zarbstl = me->ms_arbeitsstelle-zarbstl AND sperras_id = iv_sperras_id.
    DELETE FROM zio_5_map_as_szg WHERE zarbstl = me->ms_arbeitsstelle-zarbstl AND sperras_id = iv_sperras_id.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->REMOVE_VORSCHAU
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_vorschau.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Entfernt alle Vorschauen
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         Programmerstellung/creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_fahrzeuge_i    TYPE REF TO cl_object_collection_iterator.
    DATA lo_sitzplaetze_i  TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftraege_i    TYPE REF TO cl_object_collection_iterator.
    DATA lo_fahrzeug       TYPE REF TO zcl_io_5_fahrzeug.
    DATA lo_sitzplatz      TYPE REF TO zcl_io_5_sitzplatz.
    DATA lo_auftrag        TYPE REF TO zcl_io_5_auftrag.


    lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).                     "Remove Vorschau-Flag from Fahrzeuge
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      IF lo_fahrzeug->get_vorschau_flag( ) = abap_true.
        me->remove_fahrzeug( io_fahrzeug = lo_fahrzeug ).
      ENDIF.
    ENDWHILE.

    lo_auftraege_i  ?= mo_orders->get_values_iterator( ).                           "Remove Vorschau-Flag from Auftraege
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).
      IF lo_auftrag->get_vorschau_flag( ) = abap_true.
        me->remove_auftrag_o( io_object = lo_auftrag ).
      ENDIF.
    ENDWHILE.

    lo_fahrzeuge_i ?= me->mo_fahrzeuge->get_values_iterator( ).                     "Remove Vorschau-Flag from Qualifikationen
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
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SAVE_DIRECTLY               TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Sichert die Daten der Arbeitsstelle
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      : ...
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50       tt.mm.2017   Firma(company) / Name(name)
*         Programmerstellung/ creation of program
*----------------------------------------------------------------------*
* >001<   7.52       21.02.2024   DXC  / Fatima De Villa
*         S 6800032044: NES:JADE-789 Manuelle Signale Refactorin
*         - Speichern Sie die manuellen Signale in der Tabelle ZIO_5_SIGNALUSR
*         - Arbeitsplatz aktualisieren KMs
*----------------------------------------------------------------------*
    DATA:
      ls_arbstelle TYPE zio_5_arbstellen,
      lo_orders    TYPE REF TO cl_object_map,
      lo_order     TYPE REF TO zcl_io_5_auftrag,
      lo_fahrzeuge TYPE REF TO cl_object_map,
      lo_fahrzeug  TYPE REF TO zcl_io_5_fahrzeug,
      lo_sp_zeit   TYPE REF TO zcl_io_5_sp_zeiten,
      lo_sp_km     TYPE REF TO zcl_io_5_sp_kilometer.


    "*******************
    "* Fahrzeuge in Z-tabelle speichern
    "***************
    lo_fahrzeuge = me->get_fahrzeuge( ).
    DATA(lo_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      lo_fahrzeug->set_vorschau_flag( iv_vorschau = abap_false ).
      lo_fahrzeug->save( ).
    ENDWHILE.

    "*******************
    "* Aufträge in Z-tabelle speichern
    "***************
    DATA(lo_order_i) = me->get_auftraege( )->get_values_iterator( ).
    WHILE lo_order_i->has_next( ) = abap_true.
      lo_order ?= lo_order_i->get_next( ).
      lo_order->set_vorschau_flag( iv_vorschau = abap_false ).
      DATA(ls_order) = lo_order->get_data( ).
      zcl_io_5_utilities=>set_update_data_any_structure( CHANGING cs_update_data_structure = ls_order ).
      UPDATE zio_5_auftr FROM ls_order.
    ENDWHILE.

    "Sperrabschnitt Zeiten speichern
    DATA(lo_sp_zeit_i) = me->get_sp_zeiten( )->get_values_iterator( ).
    WHILE lo_sp_zeit_i->has_next( ) = abap_true.
      lo_sp_zeit ?= lo_sp_zeit_i->get_next( ).
      DATA(ls_sp_zeit) = lo_sp_zeit->get_data( ).
      zcl_io_5_utilities=>set_update_data_any_structure( CHANGING cs_update_data_structure = ls_sp_zeit ).
      MODIFY zio_5_sp_zeiten FROM ls_sp_zeit.
    ENDWHILE.

    "Sperrabschnitt Kilomter speichern
    DATA(lo_sp_km_i) = me->get_sp_kilometer( )->get_values_iterator( ).
    WHILE lo_sp_km_i->has_next( ) = abap_true.
      lo_sp_km ?= lo_sp_km_i->get_next( ).
      DATA(ls_sp_km) = lo_sp_km->get_data( ).
      zcl_io_5_utilities=>set_update_data_any_structure( CHANGING cs_update_data_structure = ls_sp_km ).
      MODIFY zio_5_sp_km FROM ls_sp_km.
      lo_sp_km->save_user_signals( ). "+>001<
    ENDWHILE.

*--> Begin Insert >001<
    IF zcl_io_5_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true.
      me->refresh_ausdehung( ).
    ENDIF.
*--> End Insert >001<

    "Mapping Sperrabschnitt Arbeitsstelle speichern
    DATA(lt_map_as_szg) = me->get_sperrabschnitte( ).
    LOOP AT lt_map_as_szg ASSIGNING FIELD-SYMBOL(<ls_map_as_szg>).
      zcl_io_5_utilities=>set_update_data_any_structure( CHANGING cs_update_data_structure = <ls_map_as_szg> ).
    ENDLOOP.
    MODIFY zio_5_map_as_szg FROM TABLE lt_map_as_szg.

*--> Begin Insert >001<
    ls_arbstelle = me->get_data( ).
    zcl_io_5_utilities=>set_update_data_any_structure( CHANGING cs_update_data_structure = ls_arbstelle ).
    MODIFY zio_5_arbstellen FROM ls_arbstelle.
*--> End Insert >001<

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SAVE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* | [--->] IS_INNER_SP_ZEITEN             TYPE        ZIO_5_SP_ZEITEN(optional)
* | [--->] IV_CALLED_FROM                 TYPE        ZIO_5_TREMOLA_CALLED_FROM(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Save EZ Form
*
* SAP-Prozess/process: ...
*
* Grund/reason: ( ) Meldung/ticket      : ...
*               ( ) Projekt/project     : OPTREAL 2.0
*               ( ) Notkorrektur/emergency correction: ...
*               ( ) OSS-Hinweis/note    : ...
*               ( ) OSS-Meldung/message : ...
*               ( ) andere/other        : ...
*
* Auftraggeber/ordered by: Ëlvis Papa
*
*-----------Änderungsdokumentation/documentation of changes------------*
* >001<   7.52       27.01.2025   DXC / Piotr Stelmach
*         6800038063: NES:JADE-1027
*----------------------------------------------------------------------*
    DATA(lt_ez_form) = it_ez_form.
    DELETE lt_ez_form WHERE zarbstl <> ms_arbeitsstelle-zarbstl.

    set_zugnummer_from_ez_form( it_ez_form = lt_ez_form
                                 iv_called_from  = iv_called_from ).   ">001< +

    IF NOT mo_schicht->is_tremola_active( ).
      calculate_as_times( it_ez_form         = lt_ez_form
                          is_inner_sp_zeiten = is_inner_sp_zeiten ).
    ENDIF.

    delete_ez_form( it_ez_form = lt_ez_form ).

    insert_ez_form( it_ez_form = lt_ez_form ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IO_5_ARBEITSSTELLE=>SELECT_SA_KM_MIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIO_PRMTR
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_5_SPABS
* | [<-()] RT_VALUE                       TYPE        TT_MIN_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_sa_km_min.

    SELECT zzperi AS perimeter,
           zest   AS sperrabschnitt,
           km_von AS min_km
      INTO CORRESPONDING FIELDS OF TABLE @rt_value
      FROM zio_5_sa
      WHERE zzperi = @iv_perimeter
        AND zest   = @iv_sperrabschnitt.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->SELECT_SP_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [<-()] RS_VALUE                       TYPE        ZIO_5_SP_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_sp_schicht.

    SELECT SINGLE * FROM zio_5_sp_schicht
      INTO @rs_value
      WHERE sperras_id = @iv_sperras_id.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_BTG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_BTG                      TYPE        ZIO_ID_BTG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_btg.
    me->ms_arbeitsstelle-zid_btg = iv_id_btg.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZIO_5_ARBSTELLEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_data.
    DATA(lv_id_as) = me->ms_arbeitsstelle-zarbstl.

    me->ms_arbeitsstelle = is_data.
    me->ms_arbeitsstelle-zarbstl = lv_id_as.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_ETAPPENAUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_etappenauftrag.

    me->ms_arbeitsstelle-etappenauftrag = iv_aufnr.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_INITAL_AUSDEHNUNG_SP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRAS_ID                  TYPE        ZIO_5_SPERRAS_ID
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IO_5_AUFTRAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_inital_ausdehnung_sp.
    DATA: lo_sp_km TYPE REF TO zcl_io_5_sp_kilometer.
    DATA(lo_sp_km_i) = mo_sp_kilometer->get_values_iterator( ).

    lo_sp_km ?= mo_sp_kilometer->get( key = iv_sperras_id ).
    IF lo_sp_km IS NOT INITIAL.
      IF lo_sp_km->get_data( )-sperras_id EQ iv_sperras_id.

        DATA(lv_sp) = lo_sp_km->get_sp( ).

        lo_sp_km->set_zkmin( io_auftrag->get_km_by_est( lv_sp )-zkmin ).
        lo_sp_km->set_zkmax( io_auftrag->get_km_by_est( lv_sp )-zkmax ).

*        lo_sp_km->set_zkmin( io_auftrag->get_km_by_est(  me->mo_schicht->get_rj_est( )  )-zkmin ).
*        lo_sp_km->set_zkmax( io_auftrag->get_km_by_est(  me->mo_schicht->get_rj_est( )  )-zkmax ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_MET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_MET                      TYPE        ZIO_ID_MET
* | [--->] IV_IGNORE_ERRORS               TYPE        ABAP_BOOL(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_met.
    DATA lo_arbeitsstelle_i TYPE REF TO cl_object_collection_iterator.

    lo_arbeitsstelle_i ?= me->get_schicht( )->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE lo_arbeitsstelle_i->has_next( ) = abap_true.
      DATA(lo_arbeitsstelle) = CAST zcl_io_5_arbeitsstelle( lo_arbeitsstelle_i->get_next( ) ).
      CHECK lo_arbeitsstelle->has_met( ) = abap_true.
      lo_arbeitsstelle->remove_met( ).
    ENDWHILE.

    DATA(lo_fahrzeuge) = zcl_io_5_regeln=>get_met_fahrzeuge( iv_ignore_errors = iv_ignore_errors io_arbeitsstelle = me ).
    IF lo_fahrzeuge->size( ) > 0.
      me->add_fahrzeuge( io_objects = lo_fahrzeuge ).
    ENDIF.

    me->ms_arbeitsstelle-zmet = iv_id_met.
    me->refresh_sa_sp( ).
    me->refresh_ausdehung( ).

    DATA(lo_log) = zcl_io_5_log=>get_instance( ).
    MESSAGE s025(zio_5_real) WITH ms_arbeitsstelle-zschicht ms_arbeitsstelle-zarbstl ms_arbeitsstelle-zkmin ms_arbeitsstelle-zkmax INTO DATA(lv_msg).
    lo_log->add_info( iv_text = CONV #( lv_msg ) iv_sub_object = zcl_io_5_log=>mc_sub_object_planung ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_MET_AS_NAME_PREFIX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PREFIX                      TYPE        ZIO_5_MET_AS_NAME_PREFIX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_met_as_name_prefix.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Set MET AS name prefxix
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52       24.04.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-499
*----------------------------------------------------------------------*

    ms_arbeitsstelle-prefix_met_as = iv_prefix.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_schicht.

    me->mo_schicht = io_schicht.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_TREMOLA_CALC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_tremola_calc.

    me->ms_arbeitsstelle-tremola_calc = iv_data.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_ZKMAX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZKMAX                       TYPE        ZIO_5_ARBSTELLEN-ZKMAX
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zkmax.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Set ZKMAX
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      17.08.2023   DXC  / Fatima De Villa
*         S 6800028212: NES-Jade-733: Grafische Anpassung
*         JADE-761
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
    CHECK ms_arbeitsstelle-zkmax <> iv_zkmax.

    ms_arbeitsstelle-zkmax = iv_zkmax.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_ZKMIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZKMIN                       TYPE        ZIO_5_ARBSTELLEN-ZKMIN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zkmin.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Set ZKMIN
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      17.08.2023   DXC  / Fatima De Villa
*         S 6800028212: NES-Jade-733: Grafische Anpassung
*         JADE-761
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
    CHECK ms_arbeitsstelle-zkmin <> iv_zkmin.

    ms_arbeitsstelle-zkmin = iv_zkmin.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->SET_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGNUMMER                   TYPE        ZIO_5_ARBSTELLEN-ZID_ZUG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_zugnummer.
    CHECK ms_arbeitsstelle-zid_zug <> iv_zugnummer.

    ms_arbeitsstelle-zid_zug = iv_zugnummer.

    update_zugnummer( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->SET_ZUGNUMMER_FROM_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* | [--->] IV_CALLED_FROM                 TYPE        ZIO_5_TREMOLA_CALLED_FROM(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD set_zugnummer_from_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Set Zugnummer
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt/ project      : REAL-2.0
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52      27.11.2020   DXC  / Thomas Frick
*         S 6800007835: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.52      19.05.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-140
*         - Logik für manuell erstellte EZ-Form hinzufügen
*----------------------------------------------------------------------*
* >002<   7.52       02.01.2025   DXC / Piotr Stelmach
*         6800038063: NES:JADE-1027
*----------------------------------------------------------------------*

   clear_zugnummer( iv_called_from = iv_called_from  ).   ">002< MOD

   TRY .
       DATA(lv_zugnummer) = it_ez_form[ zarbstl  = ms_arbeitsstelle-zarbstl
                                        richtung = zif_io_5_trasse=>mc_richtung_einfahrt
                                        ez_aktiv = abap_true ]-zugnummer.
       set_zugnummer( lv_zugnummer ).

     CATCH cx_sy_itab_line_not_found.

       DATA(lt_ez_form_db) = me->get_ez_form_db( ).   "Check manual change
       ASSIGN lt_ez_form_db[ zarbstl     = ms_arbeitsstelle-zarbstl
                             richtung    = zif_io_5_trasse=>mc_richtung_einfahrt
                             data_origin = abap_false
                             ez_aktiv    = abap_true ]-zugnummer TO FIELD-SYMBOL(<lv_zugnummer>).

*--> Begin Insert >001<
       IF sy-subrc NE 0.
         ASSIGN lt_ez_form_db[ zarbstl     = ms_arbeitsstelle-zarbstl
                               richtung    = zif_io_5_trasse=>mc_richtung_einfahrt
                               data_origin = zif_io_5_constant=>mc_data_origin-manual
                               ez_aktiv    = abap_true ]-zugnummer TO <lv_zugnummer>.

       ENDIF.

       IF <lv_zugnummer> IS ASSIGNED.
*--> End Insert >001<
         set_zugnummer( <lv_zugnummer> ).
       ENDIF.

   ENDTRY.

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->UNLOCK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unlock.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/ description: Unlock des Arbeitsplatzes
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:  Elvis Papa
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50       30.10.2019   SBB AG / Arlene Bucher
*         Programmerstellung/ creation
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CALL FUNCTION 'DEQUEUE_EZ_5_ARBSTELLEN'
      EXPORTING
        mode_zio_5_arbstellen = 'E'
        mandt                 = sy-mandt
        zarbstl               = ms_arbeitsstelle-zarbstl
        x_zarbstl             = ' '
        _scope                = '3'
        _synchron             = 'X'
        _collect              = ' '.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_ARBEITSSTELLE->UNLOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unlock_sub_objects.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/ description: Unlock Unterobjekte des Arbeitsplatzes
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               (X) Projekt     : REAL GBT/CBT
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by:  Elvis Papa
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.50       30.10.2019   SBB AG / Arlene Bucher
*         Programmerstellung/ creation
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj   Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA lo_fahrzeuge_i     TYPE REF TO cl_object_collection_iterator.
    DATA lo_fahrzeuge       TYPE REF TO cl_object_map.
    DATA lo_fahrzeug        TYPE REF TO zcl_io_5_fahrzeug.
    DATA lo_fehler          TYPE REF TO zcx_io_5_fehler.


    lo_fahrzeuge = get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      lo_fahrzeug->unlock( ).
      lo_fahrzeug->unlock_subobjects( ).

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->UPDATE_ZEITEN_FROM_SPABSID
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_zeiten_from_spabsid.

    DATA(lt_map_spabs) = get_sperrabschnitte( iv_zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ).

    DATA(li_sp_zeiten_i) = mo_sp_zeiten->get_values_iterator( ).
    WHILE li_sp_zeiten_i->has_next( ).
      DATA(lo_sp_zeiten) = CAST zcl_io_5_sp_zeiten( li_sp_zeiten_i->get_next( ) ).

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
* | Instance Private Method ZCL_IO_5_ARBEITSSTELLE->UPDATE_ZUGNUMMER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_zugnummer.

    UPDATE zio_5_arbstellen SET
      zid_zug = @ms_arbeitsstelle-zid_zug
      WHERE zarbstl = @ms_arbeitsstelle-zarbstl.

  ENDMETHOD.
ENDCLASS.