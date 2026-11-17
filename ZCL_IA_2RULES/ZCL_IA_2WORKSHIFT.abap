class ZCL_IA_2WORKSHIFT definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ts_kein_log_schichten,
        supply_type TYPE zia_2_supply_type,
        zschicht    TYPE  zia_2_workshift,
        o_schicht   TYPE REF TO zcl_ia_2workshift,
      END OF ts_kein_log_schichten .
  types:
    tt_kein_log_schichten TYPE STANDARD TABLE OF ts_kein_log_schichten WITH DEFAULT KEY .
  types:
    tt_notif_longtext_tab TYPE STANDARD TABLE OF bapi2080_notfulltxti .

  constants:
    BEGIN OF mc_intervallarten,
        ji TYPE zia_2_intervallart VALUE 'JI',
        ri TYPE zia_2_intervallart VALUE 'RI',
        li TYPE zia_2_intervallart VALUE 'LI',
      END OF mc_intervallarten .
  constants:
    BEGIN OF mc_sperrabs,
        e  TYPE zia_2_blocking_section VALUE 'E',
        e1 TYPE zia_2_blocking_section VALUE 'E1',
        e2 TYPE zia_2_blocking_section VALUE 'E2',
        e3 TYPE zia_2_blocking_section VALUE 'E3',
        w  TYPE zia_2_blocking_section VALUE 'W',
        w1 TYPE zia_2_blocking_section VALUE 'W1',
        w2 TYPE zia_2_blocking_section VALUE 'W2',
        w3 TYPE zia_2_blocking_section VALUE 'W3',
      END OF mc_sperrabs .
  constants MC_IPHAS_2 type PM_PHASE value '2' ##NO_TEXT.
  class-data MO_REF_NOTIFICATION_SERVICE type ref to /ACI/CL_NOTIFICATION_SERVICE .
  constants MC_USER_STATUS_PL1 type J_TXT04 value 'PL1' ##NO_TEXT.
  constants MC_USER_STATUS_PL2 type J_TXT04 value 'PL2' ##NO_TEXT.
  constants MC_PRIO_1 type PRIOK value '1' ##NO_TEXT.
  constants MC_PRIO_2 type PRIOK value '2' ##NO_TEXT.
  constants MC_USER_STATUS_PL3 type J_TXT04 value 'PL3' ##NO_TEXT.
  class-data MV_MNCOD type MNCOD .

  class-methods CLASS_CONSTRUCTOR .
  methods ADD_ARBEITSSTELLE
    importing
      !IO_ARBSTELLE type ref to ZCL_IA_2WRKPLACE
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods ADD_NOTES
    importing
      !IV_BEMERKUNG type ZIA_2_SCHICHT_NOTES .
  methods CONSTRUCTOR
    importing
      !IV_ZSCHICHT type ZIA_2_WORKSHIFT .
  methods COPY_VERSORGUNG_FAHRZEUGE .
  methods CREATE_ARBEITSSTELLE
    importing
      !IV_AUFNR type AUFNR optional
      !IS_AUFTRAG type ZIA_2ORDER optional
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IV_IGNORE_ERRORS type BOOLEAN
      !IV_AUTO_PLANNING type BOOLEAN
    exporting
      !EO_ARBSTELLEN_ABH type ref to CL_OBJECT_MAP
    returning
      value(RO_ARBEITSSTELLE) type ref to ZCL_IA_2WRKPLACE .
  methods DELETE_EZ_FORM .
  methods DISTRIBUTE_GSMR .
  methods GET_ARBEITSSTELLEN
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods GET_ARBEITSSTELLE_BY_ID
    importing
      !IV_ID type ZIA_2_ID_ARBSTL
    returning
      value(RO_INSTANCE) type ref to ZCL_IA_2WRKPLACE .
  methods GET_ARBST_BY_ID_BTG
    importing
      !IV_ID_BTG type ZIA_2_ID_BTG
    returning
      value(RO_ARBST) type ref to ZCL_IA_2WRKPLACE
    raising
      ZCX_IA_2FAILURE .
  methods GET_AUFTRAEGE
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods GET_BEZEICHNUNG_SCHICHT
    returning
      value(RV_TEXT) type STRING .
  methods GET_DATA
    returning
      value(RS_DATA) type ZIA_2WRKSHIFTS_S .
  methods GET_ENTSORGUNG_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT .
  methods GET_EZ_FORM
    importing
      !IV_EIZ_ID type ZIA_2_ID_EIZ optional
      !IV_ZARBSTL type ZIA_2_ID_ARBSTL optional
      !IV_ZUGNUMMER type ZIA_2_ZUG_ID optional
      !IV_RICHTUNG type ZIA_2_RICHTUNG optional
      !IV_ACTIVE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_VALUE) type ZIA_2_EZ_FRM_T .
  methods GET_FAHRZEUGE
    importing
      !IV_FILTER_FZTYP type ZIA_2_ID_FZTYP optional
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods GET_FAHRZEUGE_FREI
    importing
      !IV_FILTER_FZTYP type ZIA_2_ID_FZTYP optional
    returning
      value(RT_FAHRZEUGE) type ZIA_2VEHICLES_T .
  methods GET_FAHRZEUGE_VERPLANT
    importing
      !IV_FILTER_FZTYP type ZIA_2_ID_FZTYP optional
    returning
      value(RT_FAHRZEUGE) type ZIA_2VEHICLES_T .
  methods GET_FAHRZEUG_BY_ID
    importing
      !IV_FGZ_ID type ZIA_2_ID_FZG
    returning
      value(RO_FAHRZEUG) type ref to ZCL_IA_2VEHICLE .
  methods GET_FIRST_ARBEITSSTELLE
    returning
      value(RO_ARBSTELLE) type ref to ZCL_IA_2WRKPLACE .
  methods GET_ID
    returning
      value(RV_ID) type ZIA_2_WORKSHIFT .
  methods GET_KEINE_LOGISTIK_SCHICHTEN
    returning
      value(RT_DATA) type TT_KEIN_LOG_SCHICHTEN .
  methods GET_MET_AS_NAME
    returning
      value(RV_DATA) type STRING .
  methods GET_MET_TYPE
    returning
      value(RV_DATA) type ZIF_IA_2_MET=>TV_MET_TYPE .
  methods GET_NOTES
    returning
      value(RT_DATA) type ZIA_2SHIFT_NOTES_T .
  methods GET_PARAMETER
    returning
      value(RO_OBJECT) type ref to ZCL_IA_2PARAMETER .
  methods GET_QUALIFIKATIONEN
    importing
      !IV_OBJTY type CR_OBJTY
      !IV_OBJID type CR_OBJID
    returning
      value(RT_QUALIS) type ZIA_2QUALIS_T .
  methods GET_RJ_EST
    returning
      value(RV_EST) type ZIA_2_BLOCKING_SECTION .
  methods GET_SCHICHTSAUFTRAG
    returning
      value(RV_AUFNR) type AUFNR .
  methods GET_SPERRABSCHNITTE
    returning
      value(RT_DATA) type ZIA_2_SP_INTVART_T .
  methods GET_SP_SCHICHT
    returning
      value(RT_SP_SCHICHT) type ZIA_2SP_SCHICHT_T .
  methods GET_START_TIMESTAMP_TEXT
    returning
      value(RV_VALUE) type STRING .
  methods GET_STATUS
    returning
      value(RV_STATUS) type ZIA_2_WRKSHFTSTATUS .
  methods GET_TRASSEN
    importing
      !IV_ZUGNUMMER type ZIA_2_ZUG_ID optional
      value(IV_ARBSTELLE_LEVEL) type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_TRASSEN) type ZIA_2TRASSEN_T .
  methods GET_TS_EST
    returning
      value(RV_EST) type ZIA_2_ROEHRE .
  methods GET_VERSORGUNG_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT .
  methods GET_WORKAREA
    importing
      !IV_SHIFT type ZIA_2_WORKSHIFT
      !IV_MARK type BOOLEAN optional .
  methods HAS_ARBEITSSTELLEN_IN_TUNNEL
    importing
      !IV_EIZ type ZIA_2_ID_EST optional
      !IV_SKIP_STRASSE type BOOLEAN optional
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods HAS_SCHICHT_PARAMETER
    returning
      value(RV_RETURN) type WDY_BOOLEAN .
  methods HAS_VERSORGUNG_SCHICHT
    returning
      value(RV_DATA) type ABAP_BOOL .
  methods IS_EMPTY
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_ENTSORGUNG_SCHICHT
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_JOKER
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_KEINE_FARHRT_SCHICHT
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_LOCKED
    returning
      value(RV_RETURN) type BOOLEAN .
  methods IS_PLANNED
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_TREMOLA_ACTIVE
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods IS_VERSORGUNG_SCHICHT
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods LOCK
    importing
      !IV_CHECK type BOOLEAN optional
    raising
      ZCX_IA_2FAILURE .
  methods LOCK_SUB_OBJECTS
    importing
      !IV_CHECK type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  methods RELOAD .
  methods REMOVE_ARBEITSSTELLE
    importing
      !IO_OBJECT type ref to ZCL_IA_2WRKPLACE
      !IV_IGNORE_ERRORS type BOOLEAN optional
    raising
      ZCX_IA_2FAILURE .
  methods RESET .
  methods SAVE
    returning
      value(RT_RETURN) type BAPIRET2_T .
  methods SAVE_EZ_FORM
    importing
      !IT_EZ_FORM type ZIA_2_EZ_FRM_T optional
      !IV_CALLED_FROM type ZIA_2_TREMOLA_CALLED_FROM optional .
  methods SET_INITAL_AUSDEHNUNG_SP
    importing
      !IV_SPERRAS_ID type ZIA_2_SPERRAS_ID
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER .
  methods SET_STATUS
    importing
      !IV_STATUS type ZIA_2_WRKSHFTSTATUS .
  methods SET_TREMOLA_CALCULATED
    importing
      !IV_TREMOLA_DONE type ABAP_BOOL .
  methods START_AUTO_PLANNING
    importing
      !IV_PERIMETER type ZIA_2_PERIMETERS .
  methods UNLOCK .
  methods UNLOCK_SUB_OBJECTS .
  methods GET_RA_EST
    importing
      !IV_AUTO_PLANNING type BOOLEAN
    returning
      value(RT_RANGE) type ZIA_2RANGE_STRING_T .
  methods GET_PLANUNGSINTERVALL
    returning
      value(RS_PLANUNGSINTERVALL) type ZIA_2_PLANNING_INTERVAL_S .
  methods GET_SF_QUALI
    importing
      !IO_ORDER type ref to ZCL_IA_2ORDER
      !IO_FAHRZEUG type ref to ZCL_IA_2VEHICLE
    exporting
      !EO_SITZPLATZ_TFF type ref to ZCL_IA_2SEAT
      value(ES_QUALI) type ZIA_2_QUALIS_S .
  methods GET_MOST_INNER_ARBEITSSTELLE
    exporting
      !EO_ARBSTELLE type ref to ZCL_IA_2WRKPLACE
      !EV_KM_MAX type ZIA_2_KM .
  methods CHANGE_USERSTATUS_BY_PRIO
    importing
      !IV_QMNUM type ZIA_2_WORKSHIFT
      !IV_ORDER type AUFNR
    raising
      ZCX_IA_2FAILURE .
  methods CHANGE_SINGLE_STATUS
    importing
      !IV_OBJNR type JSTO-OBJNR
      !IV_TXT04 type TJ02T-TXT04
      !IV_SET_INACTIVE type XFELD .
  methods DEACTIVATE_USER_STATUS
    importing
      !IV_QMNUM type ZIA_2_WORKSHIFT
      !IV_ORDER type AUFNR .
  methods HAS_SP_TS
    returning
      value(RV_BOOLEAN) type BOOLEAN .
protected section.

  data GV_EXT_OBJECT_ID type /SMFND/SYNC_OBJECT_KEY_DTE .
private section.

  types:
    BEGIN OF ts_eiz ,
      zid_eiz TYPE zia_2_id_eiz,
    END   OF ts_eiz .
  types:
    tt_eiz TYPE STANDARD TABLE OF ts_eiz WITH EMPTY KEY .

  data GS_SCHICHT type ZIA_2WRKSHIFTS_S .
  data GO_PARAMETER type ref to ZCL_IA_2PARAMETER .
  data GT_NOTES type ZIA_2SHIFT_NOTES_T .
  data GT_SP_SCHICHT type ZIA_2SP_SCHICHT_T .
  data GO_ARBEITSSTELLEN type ref to CL_OBJECT_MAP .
  data GT_TRASSEN type ZIA_2TRASSEN_T .
  data GT_EZ_FORM type ZIA_2_EZ_FRM_T .
  data GV_LOCKED type BOOLEAN .
  data GV_SCHICHTSAUFTRAG type AUFNR  ##NEEDED.
  data GS_SHIFT type ZIA_2_WRKSHIFTS  ##NEEDED.
  data GT_NOTIF_LONGTEXT type TT_NOTIF_LONGTEXT_TAB .
  data GO_SP_KILOMETER type ref to CL_OBJECT_MAP .

  methods CHANGE_NOTIFICATION_PRIORITY
    importing
      !IV_SHIFT type ZIA_2_WORKSHIFT
      !IV_MARK type BOOLEAN optional .
  methods CLEAR_EZ_FORM .
  methods FILTER_EZ_FORM
    changing
      !CT_DATA type ZIA_2_EZ_FRM_T .
  methods GET_EZ_FORM_TREMOLA .
  methods GET_TRASSEN_FOR_RICHTUNG
    importing
      !IT_TRASSEN type ZIA_2TRASSEN_T
      !IV_RICHTUNG type ZIA_2_RICHTUNG
      !IT_SORT_ORDER type ABAP_SORTORDER_TAB
    returning
      value(RT_TRASSEN) type ZIA_2TRASSEN_T .
  methods JOIN_EZ_FORM_FROM_TREMOLA
    changing
      !CT_EZ_FORM_WD type ZIA_2_EZ_FORM_WD_T .
  methods READ_EZ_FORM .
  methods SAVE_SHIFT_DATA
    returning
      value(RT_RETURN) type BAPIRET2_T .
  methods SELECT_BASE_DBTAB .
  methods SELECT_EZ_FORM .
  methods SELECT_TRASSEN .
*  DATA gs_schicht TYPE zia_2wrkshifts_s .
*  data GO_PARAMETER type ref to ZCL_IA_2PARAMETER .
  methods SET_STATUS_BY_STATE .
  methods SORT_EZ_FORM .
  methods GET_AUFTRAG_SP_INTVAR
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
    changing
      !CO_ARBSTELLE type ref to ZCL_IA_2WRKPLACE .
  methods GET_LV_ERROR   ##RELAX
    importing
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IV_IGNORE_ERRORS type BOOLEAN
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
      !IV_AUTO_PLANNNING type BOOLEAN
    exporting
      !EV_HAS_ERROR type BOOLEAN
      !EO_FAHRZEUGE type ref to CL_OBJECT_MAP .
ENDCLASS.



CLASS ZCL_IA_2WORKSHIFT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->ADD_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ARBSTELLE                   TYPE REF TO ZCL_IA_2WRKPLACE
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - ADD_ARBEITSSTELLE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
          lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
 ##NEEDED          ls_arbstelle     TYPE zia_2sf_wa,
 ##NEEDED          ls_new_arbstelle TYPE zia_2sf_wa.

    DATA: BEGIN OF ls_sort,
            object TYPE REF TO zcl_ia_2wrkplace,
            km_von TYPE zia_2_km_von,
          END OF ls_sort,

          lt_sort LIKE TABLE OF ls_sort.

    CHECK io_arbstelle IS NOT INITIAL.

    "ENTFERNEN, FALLS BEREITS EXISTIERT
    IF go_arbeitsstellen->get( key = io_arbstelle->get_data( )-zarbstl ) IS NOT INITIAL.
      go_arbeitsstellen->remove( key = io_arbstelle->get_data( )-zarbstl ).
    ENDIF.

    go_arbeitsstellen->put( EXPORTING key = io_arbstelle->get_data( )-zarbstl   value = io_arbstelle ).

    set_status_by_state( ).

    " ARBEITSSTELLEN SORTIEREN
    lo_arbstelle_i ?=  me->go_arbeitsstellen->get_values_iterator( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).
      ls_sort-km_von = lo_arbstelle->get_data( )-zkmin.

      ls_sort-object = lo_arbstelle.
      APPEND ls_sort TO lt_sort. CLEAR ls_sort.
    ENDWHILE.

    SORT lt_sort BY km_von.
    me->go_arbeitsstellen->clear( ).

    LOOP AT lt_sort INTO ls_sort.
      go_arbeitsstellen->put( EXPORTING key = ls_sort-object->get_data( )-zarbstl   value = ls_sort-object ).
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2WORKSHIFT=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM

*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    " DUMMY CODE
    ##NEEDED    DATA: lv_dummy TYPE i.
    lv_dummy = 123.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->CLEAR_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD clear_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - GET_SINGLE_TRASSE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    CLEAR gt_ez_form[].
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZSCHICHT                    TYPE        ZIA_2_WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - CONSTRUCTOR
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    "*******************
    "* SCHICHT ID INITIALISIERE
    "***************
    gs_schicht-zschicht = iv_zschicht.

    "*******************
    "* DATENINITIALISIERUNG
    "***************
    reload( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_ARBEITSSTELLEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_arbeitsstellen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - GET_ARBEITSSTELLEN
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ro_objects = me->go_arbeitsstellen.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2WRKSHIFTS_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - GET_DATA
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rs_data = me->gs_schicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_ENTSORGUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_entsorgung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - GET_ENTSORGUNG_SCHICHT
*----------------------------------------------------------------------*
* >001<   7.50       21.09.2026       TCS / Venkateswarlu Batta
*         Added the IF Condition for empty dates to prevent dumps
*----------------------------------------------------------------------*
    CONSTANTS lc_date_interval TYPE int1 VALUE 120.

    DATA lt_schicht_id TYPE RANGE OF zia_2_workshift.
    DATA(lv_index)    = VALUE int4( ).

    "VERSORGUNGSSCHICHT CANNOT HAVE VERSORGUNGSSCHICHT (ONLY K OR E)
    DATA(lv_supply_type) =  go_parameter->get_data( )-supply_type.
    IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung OR
       lv_supply_type IS INITIAL.
      RETURN.
    ENDIF.
    IF gs_schicht-start_datum IS NOT INITIAL AND gs_schicht-end_datum IS NOT INITIAL.  ">001<
      "WE DO NOT WANT TO GET ALL ENTRIES - WE ASSUME THAT THE SCHICHT LI DOES NOT LAST LONGER THAN 8 MONTHS ( 4 BACK AND FORWARD )
      DATA(lv_start_date) = gs_schicht-start_datum - lc_date_interval.
      DATA(lv_end_date)   = gs_schicht-end_datum   + lc_date_interval.
    ENDIF.

    "GET SCHICHTS THAT CAN BE RELATED TO THE CURRENT SCHICHT
*    SELECT zschicht
*      INTO TABLE @DATA(lt_zschicht)
*      FROM zia_2wrkshifts
*      WHERE start_datum >= @lv_start_date
*        AND end_datum   <= @lv_end_date
*        AND zzperi       = @gs_schicht-zzperi.

    SELECT qmnum AS zschicht
  INTO TABLE @DATA(lt_zschicht)
  FROM qmel
  WHERE qmart EQ 'NR'
    AND strmn >= @lv_start_date
    AND ltrmn   <= @lv_end_date
    AND qmcod      = @gs_schicht-zzperi.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.




    lt_schicht_id = VALUE #( FOR <ls_zschicht> IN lt_zschicht ( sign = 'I' option = 'EQ' low = <ls_zschicht> ) ).

*    SELECT b~manum   AS  sperras_id,
*           b~qmnum   AS  zschicht,
*           b~pster   AS start_datum,
*           b~pstur   AS start_zeit,
*           a~oteil   AS zintervallart,
*           a~fecod   AS supply_type,
*           b~fenum AS fenum
*       INTO TABLE @DATA(lt_sp_schicht)
*       FROM viqmfe AS a
*       INNER JOIN viqmma AS b
*         ON a~qmnum = b~qmnum
*        WHERE a~qmnum IN @lt_schicht_id.
    SELECT sperras_id, zschicht, start_datum, start_zeit, zintervallart, linumber, supply_type
         INTO TABLE @DATA(lt_sp_schicht)
         FROM zia_2sf_bs
         WHERE zschicht IN @lt_schicht_id.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.


    SORT lt_sp_schicht BY start_datum start_zeit.


    "FIND ENTRY OF CURRENT SCHICHT IN SP SCHICHT DATA
    LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WHERE zschicht = gs_schicht-zschicht
                                                                    AND linumber IS NOT INITIAL.
      DATA(ls_sp_schicht_curr) = <ls_sp_schicht>.
      EXIT.
    ENDLOOP.

    "GET INDEX OF THE CURRENT SCHICHT
    ##WARN_OK    lv_index = line_index( lt_sp_schicht[ sperras_id = ls_sp_schicht_curr-sperras_id zschicht = gs_schicht-zschicht ] ).

    "SCAN THE TABLE UP TO FIND THE VERSORGUNGSSCHACHT THAT IS ALWAYS FIRST IN THE GROUP
    WHILE lv_index > 0.
      lv_index = lv_index + 1.
      DATA(ls_sp_schicht_up) = VALUE #( lt_sp_schicht[ lv_index ] OPTIONAL ).

      IF   ls_sp_schicht_up-supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung.
        ro_schicht  = NEW #( iv_zschicht = ls_sp_schicht_up-zschicht ).
        EXIT.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_FAHRZEUGE_FREI
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FILTER_FZTYP                TYPE        ZIA_2_ID_FZTYP(optional)
* | [<-()] RT_FAHRZEUGE                   TYPE        ZIA_2VEHICLES_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRZEUGE_FREI
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       18.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
METHOD get_fahrzeuge_frei.
*
  DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.
  DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
        lo_fahrzeuge   TYPE REF TO cl_object_map,
        lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

  SELECT * FROM zia_2vehicles INTO TABLE @DATA(lt_fahrzeuge). "#EC CI_NOWHERE

  " Filter anwenden
  IF iv_filter_fztyp IS NOT INITIAL.
    DELETE lt_fahrzeuge WHERE zid_fztyp <> iv_filter_fztyp.
  ENDIF.

  lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    lo_fahrzeuge = lo_arbstelle->get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

      DELETE lt_fahrzeuge WHERE zid_fzg = lo_fahrzeug->get_id( ).
    ENDWHILE.
  ENDWHILE.

  rt_fahrzeuge = lt_fahrzeuge.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_FAHRZEUGE_VERPLANT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FILTER_FZTYP                TYPE        ZIA_2_ID_FZTYP(optional)
* | [<-()] RT_FAHRZEUGE                   TYPE        ZIA_2VEHICLES_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRZEUGE_VERPLANT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       18.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
METHOD get_fahrzeuge_verplant.

*     DATA: lt_fahrzeuge TYPE zia_2vehicles_t,
*           ls_fahrzeug  LIKE LINE OF lt_fahrzeuge.
*     DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
*           lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.
*     DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
*           lo_fahrzeuge   TYPE REF TO cl_object_map,
*           lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.
*
*     lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
*     WHILE lo_arbstelle_i->has_next( ) = abap_true.
*       lo_arbstelle ?= lo_arbstelle_i->get_next( ).
*
*       lo_fahrzeuge = lo_arbstelle->get_fahrzeuge( ).
*       lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
*       WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
*         lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
*
*         ls_fahrzeug = lo_fahrzeug->get_data( ).
*
*         " Filter anwenden
*         CHECK iv_filter_fztyp IS INITIAL OR iv_filter_fztyp =  ls_fahrzeug-zid_fztyp.
*
*         " Fahtzeug zurückgeben
*         APPEND ls_fahrzeug TO lt_fahrzeuge. CLEAR ls_fahrzeug.
*       ENDWHILE.
*     ENDWHILE.
*
*     rt_fahrzeuge = lt_fahrzeuge.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZIA_2_WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - GET_ID
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rv_id = me->gs_schicht-zschicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->LOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CHECK                       TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock_sub_objects.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: LOCK OBJECTS
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - LOCK_SUB_OBJECTS
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_arbstellen  TYPE REF TO cl_object_map,
          lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
          lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.

    ##NEEDED    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

    lo_arbstellen = get_arbeitsstellen( ).
    lo_arbstelle_i ?= lo_arbstellen->get_values_iterator( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).

      TRY.
          lo_arbstelle->lock( iv_check = iv_check ).
          lo_arbstelle->lock_sub_objects( iv_check = iv_check ).
        CATCH zcx_ia_2failure INTO DATA(lx_fehler).
          RAISE EXCEPTION lx_fehler.
      ENDTRY.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: RELOAD
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - RELOAD
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    select_base_dbtab( ).

    "PARAMETER
    go_parameter = NEW zcl_ia_2parameter( iv_schicht   = CONV zia_2_workshift( me->gs_schicht-zschicht )
                                          iv_perimeter = CONV zia_2_perimeters( me->gs_schicht-zzperi )  ).

*    SELECT * FROM zia_2shift_note INTO CORRESPONDING FIELDS OF TABLE @gt_notes WHERE zschicht EQ @me->gs_schicht-zschicht.
    " get short text
    DATA lt_longtext TYPE TABLE OF bapi2080_notfulltxte.

    CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
      EXPORTING
        number     = me->gs_schicht-zschicht
      TABLES
        notlongtxt = lt_longtext.

    DATA: lv_str TYPE string.
    LOOP AT lt_longtext ASSIGNING FIELD-SYMBOL(<ls_fs>) .
      lv_str = |{ lv_str }| & | | & |{ <ls_fs>-text_line }{ cl_abap_char_utilities=>newline }|.
    ENDLOOP.

*    IF lv_str IS NOT INITIAL.
*      APPEND VALUE #( bemerkung = lv_str ) TO gt_notes.
    CLEAR gt_notes.
*    DATA(lv_uname) = sy-uname.
    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name( ).
    IF lv_str IS NOT INITIAL.
      APPEND VALUE #( bemerkung = lv_str
                     uname     = lv_uname
                       ) TO gt_notes.
    ENDIF.


*    gt_notes = VALUE #( ( bemerkung = ls_header-short_text ) ).
    " SPERRABSCHNITTE EINLESEN
*    SELECT * FROM zia_2sf_bs INTO TABLE @gt_sp_schicht WHERE zschicht EQ @me->gs_schicht-zschicht.
***    IF gt_sp_schicht IS INITIAL.
***      SELECT a~oteil     AS zintervallart,
***             a~fecod     AS supply_type,
***             b~mncod     AS sperrabschnitt,
***              b~fenum   AS  sperras_id,  ""added
***             b~pster     AS start_datum,
***             b~peter     AS end_datum,
***             b~pstur     AS start_zeit,
***             b~petur     AS end_zeit
***        INTO TABLE @DATA(lt_shifts)
***        FROM viqmfe AS a
***        INNER JOIN viqmma AS b
***          ON a~qmnum = b~qmnum
***         WHERE a~qmnum EQ @me->gs_schicht-zschicht
***            AND a~fenum = b~fenum
***            AND a~kzloesch = ''
***            AND b~kzloesch = ''.
***
***      LOOP AT lt_shifts INTO DATA(ls_shift).
***        "removing space
***        DATA(lv_sperrabschnitt) = |{ ls_shift-sperrabschnitt ALPHA = OUT }|.
***        DATA(ls_sp_schicht) = VALUE zia_2sf_bs(
***       zintervallart   = ls_shift-zintervallart
***       supply_type     = ls_shift-supply_type
***       sperrabschnitt  = lv_sperrabschnitt
****     sperrabschnitt  = ls_shift-sperrabschnitt
***       start_datum     = ls_shift-start_datum
***       end_datum       = ls_shift-end_datum
***       start_zeit      = ls_shift-start_zeit
***       end_zeit        = ls_shift-end_zeit
****       sperras_id      = me->gs_schicht-zschicht  && ls_shift-sperras_id ""added
***       sperras_id      = |{ me->gs_schicht-zschicht && ls_shift-sperras_id }| ""added
***       zschicht        = me->gs_schicht-zschicht
***       linumber        = ''
***       aenam           = syst-uname
***       aedat           = sy-datum
***       aetim           = sy-uzeit ).
***        APPEND ls_sp_schicht TO gt_sp_schicht.
***        CLEAR lv_sperrabschnitt.
***      ENDLOOP.
***    ENDIF.

    IF gt_sp_schicht IS INITIAL.
      SELECT a~oteil     AS zintervallart,
             a~fecod     AS supply_type,
             b~mncod     AS sperrabschnitt,
              b~fenum   AS  sperras_id,  ""added
              b~manum   AS  manum,  ""added
             b~pster     AS start_datum,
             b~peter     AS end_datum,
             b~pstur     AS start_zeit,
             b~petur     AS end_zeit
        INTO TABLE @DATA(lt_shifts)
        FROM viqmfe AS a
        INNER JOIN viqmma AS b
          ON a~qmnum = b~qmnum
         WHERE a~qmnum EQ @me->gs_schicht-zschicht
            AND a~fenum = b~fenum
            AND a~kzloesch = ''
            AND b~kzloesch = ''.

      LOOP AT lt_shifts INTO DATA(ls_shift).
        "removing space
        DATA(lv_sperrabschnitt) = |{ ls_shift-sperrabschnitt ALPHA = OUT }|.
        DATA(ls_sp_schicht) = VALUE zia_2sf_bs(
       zintervallart   = ls_shift-zintervallart
       supply_type     = ls_shift-supply_type
       sperrabschnitt  = lv_sperrabschnitt
*     sperrabschnitt  = ls_shift-sperrabschnitt
       start_datum     = ls_shift-start_datum
       end_datum       = ls_shift-end_datum
       start_zeit      = ls_shift-start_zeit
       end_zeit        = ls_shift-end_zeit
*       sperras_id      = me->gs_schicht-zschicht  && ls_shift-sperras_id ""added
       sperras_id      = |{ me->gs_schicht-zschicht && ls_shift-sperras_id && ls_shift-manum }| ""added
       zschicht        = me->gs_schicht-zschicht
       linumber        = ''
       aenam           = lv_uname"syst-uname
       aedat           = sy-datum
       aetim           = sy-uzeit ).
        APPEND ls_sp_schicht TO gt_sp_schicht.
        CLEAR lv_sperrabschnitt.
      ENDLOOP.
    ENDIF.


    "*******************
    "* ARBEITSSTELLEN EINLESEN
    "***************
    go_arbeitsstellen = NEW cl_object_map( ).

    DATA: lo_arbstelle TYPE REF TO zcl_ia_2wrkplace.

    SELECT * FROM zia_2sf_wa INTO TABLE @DATA(lt_arbstellen) WHERE zschicht = @me->gs_schicht-zschicht.

    LOOP AT lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstelle>).
      CLEAR: lo_arbstelle.

      lo_arbstelle = NEW zcl_ia_2wrkplace( iv_id = <ls_arbstelle>-zarbstl
                                           io_schicht = me ).
      lo_arbstelle->set_data( is_data = <ls_arbstelle> ).

      me->add_arbeitsstelle( io_arbstelle = lo_arbstelle ).

    ENDLOOP.

    " JUST CLEAR, LOAD IS DEFERED ON DEMAND TO SELECT_EZ_FORM
    clear_ez_form( ).

    " JUST CLEAR, LOAD IS DEFERED ON DEMAND TO SELECT_TRASSEN
    CLEAR gt_trassen.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SELECT_BASE_DBTAB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_base_dbtab.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Execute main logic
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - SELECT_BASE_DBTAB
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_schicht-zschicht IS NOT INITIAL.
    " Initialize lv_id with the value of gs_schicht-zschicht, converting it to internal format (ALPHA is used for conversion)
    DATA(lv_id) = |{ gs_schicht-zschicht ALPHA = IN }|.
    " SELECT to retrieve specific data from viqmel based on lv_id
    SELECT
     qmnum         AS zschicht,
     qmcod         AS zzperi,
     strmn         AS start_datum,
     strur         AS start_zeit,
     ltrmn         AS end_datum,
     ltrur         AS end_zeit,
     priok         AS zstatus
   FROM viqmel
     UP TO 1 ROWS
     INTO CORRESPONDING FIELDS OF @gs_schicht
   WHERE qmnum = @lv_id " Match records where qmnum equals lv_id
     AND qmart = 'NR' " Only include records with qmart = 'NR'
     AND phase NE '5'.
    ENDSELECT.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SET_STATUS_BY_STATE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_status_by_state.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - SET_STATUS_BY_STATE
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_old_status) = gs_schicht-zstatus.

    IF me->is_empty( ).
      gs_schicht-zstatus = zif_ia_2_wrkshft_status=>mc_interval_provided.
    ELSE.

      IF gs_schicht-zstatus = zif_ia_2_wrkshft_status=>mc_interval_provided.
        gs_schicht-zstatus = zif_ia_2_wrkshft_status=>mc_plannig_started.
      ENDIF.

    ENDIF.

    CHECK gs_schicht-zstatus <> lv_old_status.
    save_shift_data( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_VERSORGUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_versorgung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_IA_2WORKSHIFT, METHOD - IS_VERSORGUNG_SCHICHT
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    "Versorgungsschicht cannot have Versorgungsschicht (only K or E)
    DATA(lv_supply_type) = go_parameter->get_data( )-supply_type.
    IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung.
      rv_value = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_OBJECT                      TYPE REF TO ZCL_IA_2PARAMETER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_parameter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: Get PARAMETER
*----------------------------------------------------------------------*
* >000<   7.50       05.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*CODE MIGRATED FROM - M02(201)
*M02 - CLASS - ZCL_MD_20013_A1, METHOD - GET_PARAMETER
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    ro_object = me->go_parameter.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_SPERRABSCHNITTE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        ZIA_2_SP_INTVART_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_sperrabschnitte.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method get_sperrabschnitte
* - Collects relevant sperrabschnitt entries from internal gt_sp_schicht table
* - Filters out entries with zintervallart 'TS'
* - Adds a special marker entry ('X') if conditions on sperrabschnitt and zintervallart are met
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
* Added condition to restrict loop to sperrabschnitt starting with 'W' or 'E'
*----------------------------------------------------------------------*

  " Collect entries excluding interval type 'TS'
  LOOP AT me->gt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>).
    CHECK <ls_sp_schicht>-zintervallart  <> 'TS'.
    rt_data = VALUE #( BASE rt_data ( sperrabschnitt = <ls_sp_schicht>-sperrabschnitt
                                      zintervallart  = <ls_sp_schicht>-zintervallart ) ).
  ENDLOOP.

  " Add special entry with sperrabschnitt = 'X' if sperrabschnitt starts with 'W' or 'E'
  " and interval type is one of RI, JI, or LI (constant)
  LOOP AT me->gt_sp_schicht ASSIGNING <ls_sp_schicht>
       WHERE ( sperrabschnitt(1) = mc_sperrabs-w
               OR sperrabschnitt(1) = mc_sperrabs-e )
         AND ( zintervallart = 'RI'
               OR zintervallart = 'JI'
               OR zintervallart = mc_intervallarten-li ).
    rt_data = VALUE #( BASE rt_data ( sperrabschnitt = 'X'
                                      zintervallart = <ls_sp_schicht>-zintervallart ) ).
    EXIT.
  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_SP_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_SP_SCHICHT                  TYPE        ZIA_2SP_SCHICHT_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sp_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*  This method retrieves the value of the 'gt_sp_schicht'
* internal table/attribute from the current object instance
* and returns it through the output parameter 'rt_sp_schicht'.
* The method does not alter any data, only retrieves it.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    rt_sp_schicht = me->gt_sp_schicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_RJ_EST
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EST                         TYPE        ZIA_2_BLOCKING_SECTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_rj_est.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                 *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*
* Method to determine and return the route section (RJ_EST) by
* looping over the shift schedule entries filtered by interval types
* and specific route section codes.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    " Loop through shift schedule entries filtered by interval type and route sections
    LOOP AT me->get_sp_schicht( ) ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>)
      WHERE ( zintervallart = 'RI' OR zintervallart = 'JI' OR zintervallart = mc_intervallarten-li )
        AND ( sperrabschnitt = mc_sperrabs-w   OR
              sperrabschnitt = mc_sperrabs-w1  OR
              sperrabschnitt = mc_sperrabs-w2  OR
              sperrabschnitt = mc_sperrabs-w3  OR
              sperrabschnitt = mc_sperrabs-e   OR
              sperrabschnitt = mc_sperrabs-e1  OR
              sperrabschnitt = mc_sperrabs-e2  OR
              sperrabschnitt = mc_sperrabs-e3 ).

      " If a matching entry is found, assign its section and exit loop
      IF <ls_sp_schicht> IS ASSIGNED.
        rv_est = <ls_sp_schicht>-sperrabschnitt.
        EXIT.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_VERSORGUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_versorgung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
*
* Method to retrieve the associated "Versorgungsschicht" (supply shift)
* for the current work shift. It checks constraints to exclude supply
* shifts themselves, limits the search to a date interval around the
* current shift, retrieves related shifts, and identifies the supply
* shift that is always the first in the group.
*----------------------------------------------------------------------*
* >001<   7.50       21.09.2026        TCS / Venkateswarlu Batta
*         Added the IF Condition for Empty date values to avoid Dumps
*----------------------------------------------------------------------*
    CONSTANTS lc_date_interval TYPE int1 VALUE 120.

    DATA lt_schicht_id TYPE RANGE OF zia_2_workshift.
    DATA(lv_index)    = VALUE int4( ).

    " Versorgungsschicht cannot have Versorgungsschicht (only types K or E)
    DATA(lv_supply_type) = go_parameter->get_data( )-supply_type.
    IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung OR
       lv_supply_type IS INITIAL.
      RETURN.
    ENDIF.

    IF gs_schicht-start_datum IS NOT INITIAL AND gs_schicht-end_datum IS NOT INITIAL.  ">001<
      " Define date range +/- 120 days around current shift
      DATA(lv_start_date) = gs_schicht-start_datum - lc_date_interval.
      DATA(lv_end_date)   = gs_schicht-end_datum   + lc_date_interval.
    ENDIF.

    " Retrieve shifts within the date range and matching the period (zzperi)
*    SELECT zschicht
*      INTO TABLE @DATA(lt_zschicht)
*      FROM zia_2wrkshifts
*      WHERE start_datum >= @lv_start_date
*        AND end_datum   <= @lv_end_date
*        AND zzperi       = @gs_schicht-zzperi.

    SELECT qmnum
INTO TABLE @DATA(lt_zschicht)
FROM qmel
WHERE strmn >= @lv_start_date
AND ltrmn <= @lv_end_date
AND qmcod      = @gs_schicht-zzperi.


    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Create range table for filtering Sp Schicht data
    lt_schicht_id = VALUE #( FOR <ls_zschicht> IN lt_zschicht ( sign = 'I' option = 'EQ' low = <ls_zschicht> ) ).

    TYPES: BEGIN OF ts_sp_schicht,
             sperras_id     TYPE viqmfe-fenum,
             sperrabschnitt TYPE viqmma-mncod,
             zschicht       TYPE viqmfe-qmnum,
             start_datum    TYPE viqmma-pster,
             start_zeit     TYPE viqmma-pstur,
             zintervallart  TYPE viqmfe-oteil,
             supply_type    TYPE viqmfe-fecod,
             linnumber      TYPE zia_2_linumber,
           END OF ts_sp_schicht.

    DATA: lt_sp_schicht TYPE STANDARD TABLE OF ts_sp_schicht.


    " Retrieve Sp Schicht data for the selected shifts
**    SELECT sperras_id, zschicht, start_datum, start_zeit, zintervallart, linumber, supply_type
**      INTO TABLE @lt_sp_schicht
**      FROM zia_2sf_bs
**      WHERE zschicht IN @lt_schicht_id.

    SELECT b~fenum   AS  sperras_id,
 b~mncod     AS sperrabschnitt,
 a~qmnum AS zschicht,
 b~pster     AS start_datum,
 b~pstur     AS start_zeit,
 a~oteil     AS zintervallart,
 a~fecod     AS supply_type
INTO TABLE @lt_sp_schicht  ##TOO_MANY_ITAB_FIELDS
FROM viqmfe AS a
INNER JOIN viqmma AS b
ON a~qmnum = b~qmnum
WHERE a~qmnum IN @lt_schicht_id AND a~fenum = b~fenum.

    DELETE lt_sp_schicht WHERE zintervallart <> zif_ia_2_constant=>mc_intervallart-li.

*  FIELD-SYMBOLS: <ls_schicht> TYPE LINE OF lt_,
*                 <ls_char>    TYPE bapi1003_alloc_values_char.
    DATA: lt_alloclist       TYPE TABLE OF bapi1003_alloc_list,
          lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
          lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
          lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
          lt_return          TYPE TABLE OF bapiret2.

    DATA: lv_objkey TYPE bapi1003_key-object.


    FIELD-SYMBOLS:
      <ls_sp>   TYPE ts_sp_schicht,
      <ls_char> TYPE bapi1003_alloc_values_char.


    LOOP AT lt_sp_schicht ASSIGNING <ls_sp>.

      CLEAR: lt_alloclist,
             lt_allocvalueschar,
             lt_allocvaluescurr,
             lt_allocvaluesnum,
             lt_return.

      lv_objkey = |{ <ls_sp>-zschicht ALPHA = IN }{ <ls_sp>-sperras_id ALPHA = IN }|.

      CALL FUNCTION 'BAPI_OBJCL_GETCLASSES'
        EXPORTING
          objectkey_imp   = lv_objkey
          objecttable_imp = 'QMFE'
          classtype_imp   = '015'
          read_valuations = 'X'
        TABLES
          alloclist       = lt_alloclist
          allocvalueschar = lt_allocvalueschar
          allocvaluescurr = lt_allocvaluescurr
          allocvaluesnum  = lt_allocvaluesnum
          return          = lt_return.

      LOOP AT lt_allocvalueschar ASSIGNING <ls_char>     "#EC CI_NESTED
  WHERE charact = 'ZIA_2_LONG_INTERVALL_NR'.

        " LINENUMBER from classification

        IF sy-subrc = 0.
          " THIS LINE UPDATES lt_sp_schicht1
          <ls_sp>-linnumber = <ls_char>-value_char.
        ENDIF.
      ENDLOOP.

    ENDLOOP.


    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    SORT lt_sp_schicht BY start_datum start_zeit.

    " Find the current Schicht entry with a valid line number
    LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WHERE zschicht = gs_schicht-zschicht
                                                                    AND linnumber IS NOT INITIAL.
      DATA(ls_sp_schicht_curr) = <ls_sp_schicht>.
      EXIT.
    ENDLOOP.

    " Get index of the current Schicht in Sp Schicht table
    ##WARN_OK    lv_index = line_index( lt_sp_schicht[ sperras_id = ls_sp_schicht_curr-sperras_id
                                                       zschicht = gs_schicht-zschicht ] ).

    " Scan upwards to find the Versorgungsschicht, which is always first in the group
    WHILE lv_index > 0.
      lv_index = lv_index - 1.
      DATA(ls_sp_schicht_up) = VALUE #( lt_sp_schicht[ lv_index ] OPTIONAL ).

      " Check if still in the same linumber group
      CHECK ls_sp_schicht_up-linnumber = ls_sp_schicht_curr-linnumber.

      " Check if this is Versorgungsschicht
      IF ls_sp_schicht_up-supply_type = zif_ia_2_constant=>mc_supply_type-versorgung.
*        ro_schicht  = NEW #( iv_zschicht = ls_sp_schicht_up-zschicht ).
        ro_schicht = NEW zcl_ia_2workshift( iv_zschicht = CONV zia_2_workshift( ls_sp_schicht_up-zschicht ) ).
        EXIT.
      ENDIF.
    ENDWHILE.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_KEINE_FARHRT_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_keine_farhrt_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*
* Method to check if the current supply type corresponds to
* "keine Fahrt" (no operation) and returns true if so.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_supply_type) = go_parameter->get_data( )-supply_type.
    IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt.
      rv_value = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->FILTER_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_DATA                        TYPE        ZIA_2_EZ_FRM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD filter_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method filter_ez_form
* - Filters EZ form entries by direction depending on supply type of Schicht
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Remove entries with direction 'Ausfahrt' if this is a Versorgung Schicht
  IF is_versorgung_schicht( ).
    DELETE ct_data WHERE richtung = zif_ia_2_constant=>mc_richtung-ausfahrt.
  ENDIF.

  " Remove entries with direction 'Einfahrt' if this is an Entsorgung Schicht
  IF is_entsorgung_schicht( ).
    DELETE ct_data WHERE richtung = zif_ia_2_constant=>mc_richtung-einfahrt.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EIZ_ID                      TYPE        ZIA_2_ID_EIZ(optional)
* | [--->] IV_ZARBSTL                     TYPE        ZIA_2_ID_ARBSTL(optional)
* | [--->] IV_ZUGNUMMER                   TYPE        ZIA_2_ZUG_ID(optional)
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG(optional)
* | [--->] IV_ACTIVE                      TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RT_VALUE                       TYPE        ZIA_2_EZ_FRM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*
* Method to retrieve and filter EZ form data based on various optional
* input parameters such as active status, eiz_id, zarbstl, zugnummer,
* and richtung. The result is returned in rt_value.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    read_ez_form( ).

    rt_value[] = gt_ez_form[].

    IF iv_active = abap_true.
      DELETE rt_value WHERE ez_aktiv <> abap_true.
    ENDIF.

    IF iv_eiz_id IS NOT INITIAL.
      DELETE rt_value WHERE zid_eiz <> iv_eiz_id.
    ENDIF.

    IF iv_zarbstl IS NOT INITIAL.
      DELETE rt_value WHERE zarbstl <> iv_zarbstl.
    ENDIF.

    IF iv_zugnummer IS NOT INITIAL.
      DELETE rt_value WHERE zugnummer <> iv_zugnummer.
    ENDIF.

    IF iv_richtung IS NOT INITIAL.
      DELETE rt_value WHERE richtung <> iv_richtung.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->GET_EZ_FORM_TREMOLA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_ez_form_tremola.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method get_ez_form_tremola
* - Fetches EZ form data from Tremola service instance
* - Filters, sorts and merges EZ form data from Tremola with local data
* - Handles exceptions during service call
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  TRY .
      DATA(lo_tremola) = zcl_ia_2tremola=>get_instance( io_schicht = me ).

      IF NOT lo_tremola->has_valid_response( ).
        lo_tremola->invoke_webservice( ).
      ENDIF.

      lo_tremola->get_ez_form( IMPORTING et_ez_form = DATA(lt_ez_form_wd) ).
      DELETE lt_ez_form_wd WHERE zarbstl IS INITIAL.

    CATCH cx_no_check INTO DATA(lx_error).
      DATA(lv_msg) = lx_error->if_message~get_text( ) ##NEEDED.
*      RETURN."""
  ENDTRY.

  select_ez_form( ).
  join_ez_form_from_tremola( CHANGING ct_ez_form_wd = lt_ez_form_wd ).

  gt_ez_form[] = VALUE #( BASE gt_ez_form FOR <ls_ez_form> IN lt_ez_form_wd (
                          zschicht    = <ls_ez_form>-zschicht
                          zugnummer   = <ls_ez_form>-zugnummer
                          zarbstl     = <ls_ez_form>-zarbstl
                          zid_eiz     = <ls_ez_form>-zid_eiz
                          richtung    = <ls_ez_form>-richtung
                          data_origin = zcl_ia_2tremola=>mc_data_origine
                          ez_aktiv    = <ls_ez_form>-ez_aktiv ) ).

  filter_ez_form( CHANGING ct_data = gt_ez_form ).
  sort_ez_form( ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_KEINE_LOGISTIK_SCHICHTEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        TT_KEIN_LOG_SCHICHTEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_keine_logistik_schichten.
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
* - Retrieves "Keine Logistik Schichten" (no logistics shifts) related
*   to the current Versorgungsschicht (supply shift)
* - Filters data for relevant date range and supply types
*----------------------------------------------------------------------*
* >001<   7.50       21.09.2026       TCS / Venkateswarlu Batta
*         Added the IF Condition for empty dates to prevent dumps
*----------------------------------------------------------------------*

  CONSTANTS lc_date_interval TYPE int1 VALUE 120.

  DATA lt_schicht_id TYPE RANGE OF zia_2_workshift.
  DATA(lv_index)    = VALUE int4( ).

  " Only Versorgungsschicht (supply type) can have Logistikschichten (only K or E)
  DATA(lv_supply_type) = go_parameter->get_data( )-supply_type.
  IF lv_supply_type <> zif_ia_2_constant=>mc_supply_type-versorgung OR
     lv_supply_type IS INITIAL.
    RETURN.
  ENDIF.

  IF gs_schicht-start_datum IS NOT INITIAL AND gs_schicht-end_datum IS NOT INITIAL.  ">001<
    " Limit search range: Schicht LI is assumed to last max ~8 months (4 months back and forward)
    DATA(lv_start_date) = gs_schicht-start_datum - lc_date_interval.
    DATA(lv_end_date)   = gs_schicht-end_datum   + lc_date_interval.
  ENDIF.

  " Get related Schicht IDs from date range and period
*  SELECT zschicht
*    INTO TABLE @DATA(lt_zschicht)
*    FROM zia_2wrkshifts
*    WHERE start_datum >= @lv_start_date
*      AND end_datum   <= @lv_end_date
*      AND zzperi       = @gs_schicht-zzperi.

  SELECT qmnum
INTO TABLE @DATA(lt_zschicht)
FROM qmel
WHERE strmn >= @lv_start_date
  AND ltrmn <= @lv_end_date
  AND qmcod      = @gs_schicht-zzperi.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  lt_schicht_id = VALUE #( FOR <ls_zschicht> IN lt_zschicht ( sign = 'I' option = 'EQ' low = <ls_zschicht> ) ).

  " Select Sp Schicht data for the relevant Schichten
**  SELECT sperras_id, sperrabschnitt, zschicht, start_datum, start_zeit, zintervallart, linumber, supply_type
**    INTO TABLE @DATA(lt_sp_schicht)
**    FROM zia_2sf_bs
**    WHERE zschicht IN @lt_schicht_id.

  TYPES: BEGIN OF ts_sp_schicht,
           sperras_id     TYPE viqmfe-fenum,
           sperrabschnitt TYPE viqmma-mncod,
           zschicht       TYPE viqmfe-qmnum,
           start_datum    TYPE viqmma-pster,
           start_zeit     TYPE viqmma-pstur,
           zintervallart  TYPE viqmfe-oteil,
           supply_type    TYPE viqmfe-fecod,
           linnumber      TYPE zia_2_linumber,
         END OF ts_sp_schicht.

  DATA: lt_sp_schicht TYPE STANDARD TABLE OF ts_sp_schicht.


  SELECT b~fenum   AS  sperras_id,
  b~mncod     AS sperrabschnitt,
  a~qmnum AS zschicht,
  b~pster     AS start_datum,
  b~pstur     AS start_zeit,
  a~oteil     AS zintervallart,
  a~fecod     AS supply_type
INTO TABLE @lt_sp_schicht  ##TOO_MANY_ITAB_FIELDS
FROM viqmfe AS a
INNER JOIN viqmma AS b
ON a~qmnum = b~qmnum
WHERE a~qmnum IN @lt_schicht_id AND a~fenum = b~fenum.

  DELETE lt_sp_schicht WHERE zintervallart <> zif_ia_2_constant=>mc_intervallart-li.

*  FIELD-SYMBOLS: <ls_schicht> TYPE LINE OF lt_,
*                 <ls_char>    TYPE bapi1003_alloc_values_char.
  DATA: lt_alloclist       TYPE TABLE OF bapi1003_alloc_list,
        lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
        lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
        lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
        lt_return          TYPE TABLE OF bapiret2.

  DATA: lv_objkey TYPE bapi1003_key-object.


  FIELD-SYMBOLS:
    <ls_sp>   TYPE ts_sp_schicht,
    <ls_char> TYPE bapi1003_alloc_values_char.


  LOOP AT lt_sp_schicht ASSIGNING <ls_sp>.

    CLEAR: lt_alloclist,
           lt_allocvalueschar,
           lt_allocvaluescurr,
           lt_allocvaluesnum,
           lt_return.

    lv_objkey = |{ <ls_sp>-zschicht ALPHA = IN }{ <ls_sp>-sperras_id ALPHA = IN }|.

    CALL FUNCTION 'BAPI_OBJCL_GETCLASSES'
      EXPORTING
        objectkey_imp   = lv_objkey
        objecttable_imp = 'QMFE'
        classtype_imp   = '015'
        read_valuations = 'X'
      TABLES
        alloclist       = lt_alloclist
        allocvalueschar = lt_allocvalueschar
        allocvaluescurr = lt_allocvaluescurr
        allocvaluesnum  = lt_allocvaluesnum
        return          = lt_return.

    LOOP AT lt_allocvalueschar ASSIGNING <ls_char>       "#EC CI_NESTED
WHERE charact = 'ZIA_2_LONG_INTERVALL_NR'.

      " LINENUMBER from classification

      IF sy-subrc = 0.
        " THIS LINE UPDATES lt_sp_schicht1
        <ls_sp>-linnumber = <ls_char>-value_char.
      ENDIF.


    ENDLOOP.

  ENDLOOP.



  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  " Keep only Logistikschichten interval type LI and where linumber is set
  DELETE lt_sp_schicht WHERE zintervallart <> zif_ia_2_constant=>mc_intervallart-li OR linnumber IS INITIAL.

  SORT lt_sp_schicht BY start_datum start_zeit sperrabschnitt.

  " Find current Schicht entry in Sp Schicht data
  LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>) WHERE zschicht = gs_schicht-zschicht AND linnumber IS NOT INITIAL.
    DATA(ls_sp_schicht_curr) = <ls_sp_schicht>.
    EXIT.
  ENDLOOP.

  " Get index of the current Schicht in lt_sp_schicht
  ##WARN_OK
  lv_index = line_index( lt_sp_schicht[ sperras_id = ls_sp_schicht_curr-sperras_id zschicht = gs_schicht-zschicht ] ).

  " Iterate forward in lt_sp_schicht to find all related Logistikschichten
  WHILE lv_index < lines( lt_sp_schicht ).
    lv_index = lv_index + 1.
    DATA(ls_sp_schicht_down) = VALUE #( lt_sp_schicht[ lv_index ] OPTIONAL ).

    " Exit if next Versorgungsschicht or no entry found
    IF ls_sp_schicht_down-supply_type = zif_ia_2_constant=>mc_supply_type-versorgung OR
       ls_sp_schicht_down-supply_type IS INITIAL.
      EXIT.
    ENDIF.

    " Check if still in the same linumber group
    CHECK ls_sp_schicht_down-linnumber = ls_sp_schicht_curr-linnumber.

    " Only consider Entsorgung or Keine Fahrt supply types
    CHECK ls_sp_schicht_down-supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung OR
          ls_sp_schicht_down-supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt.

    " Instantiate object and append to result table
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = CONV zia_2_workshift( ls_sp_schicht_down-zschicht ) ).
    CHECK lo_schicht IS BOUND.

    APPEND VALUE #( ) TO rt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    <ls_data>-supply_type = ls_sp_schicht_down-supply_type.
    <ls_data>-zschicht    = ls_sp_schicht_down-zschicht.
    <ls_data>-o_schicht   = lo_schicht.
  ENDWHILE.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_TRASSEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGNUMMER                   TYPE        ZIA_2_ZUG_ID(optional)
* | [--->] IV_ARBSTELLE_LEVEL             TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RT_TRASSEN                     TYPE        ZIA_2TRASSEN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_trassen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method get_trassen
* - Retrieves and filters train routes ("Trassen") based on input parameters
* - Supports filtering by Zugnummer (train number)
* - Handles data at EIZ (entry/exit zone) and Arbeitsstelle (work site) levels
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Adjust Arbeitsstelle level flag if Zugnummer is missing (Zugnummer required on Arbeitsstelle level)
  iv_arbstelle_level = COND #( WHEN iv_zugnummer IS INITIAL THEN abap_false ELSE iv_arbstelle_level ).

  " Populate gt_trassen by selecting trassen data
  select_trassen( ).

  " Copy selected trassen into a local table for processing
  DATA(lt_trassen) = gt_trassen.

  " If Zugnummer is specified, delete all entries that do not match the Zugnummer
  IF iv_zugnummer IS NOT INITIAL.
    DELETE lt_trassen WHERE zugnummer <> iv_zugnummer.
  ENDIF.

  " Initialize output table with existing content of rt_trassen (if any)
  DATA(lt_trassen_out) = rt_trassen.

  " 1. EIZ level trassen processing
  " Get trassen for Einfahrt (entry) direction, sorted ascending by REIHENFOLGE (sequence)
  lt_trassen_out = get_trassen_for_richtung( it_trassen    = lt_trassen
                                             iv_richtung   = zif_ia_2_trasse=>mc_richtung_einfahrt
                                             it_sort_order = VALUE #( ( name = 'REIHENFOLGE' descending = abap_false ) ) ).
  APPEND LINES OF lt_trassen_out TO rt_trassen.

  " Get trassen for Ausfahrt (exit) direction, sorted descending by REIHENFOLGE
  lt_trassen_out = get_trassen_for_richtung( it_trassen    = lt_trassen
                                             iv_richtung   = zif_ia_2_trasse=>mc_richtung_ausfahrt
                                             it_sort_order = VALUE #( ( name = 'REIHENFOLGE' descending = abap_true ) ) ).
  APPEND LINES OF lt_trassen_out TO rt_trassen.

  " 2. Arbeitsstelle level processing (only if enabled)
  IF iv_arbstelle_level = abap_true.

    " Get trassen for Einfahrt direction, sorted descending by REIHENFOLGE
    lt_trassen_out = get_trassen_for_richtung( it_trassen    = lt_trassen
                                               iv_richtung   = zif_ia_2_trasse=>mc_richtung_einfahrt
                                               it_sort_order = VALUE #( ( name = 'REIHENFOLGE' descending = abap_true ) ) ).
    APPEND LINES OF lt_trassen_out TO rt_trassen.

    " Get trassen for Ausfahrt direction, sorted ascending by REIHENFOLGE
    lt_trassen_out = get_trassen_for_richtung( it_trassen    = lt_trassen
                                               iv_richtung   = zif_ia_2_trasse=>mc_richtung_ausfahrt
                                               it_sort_order = VALUE #( ( name = 'REIHENFOLGE' descending = abap_false ) ) ).
    APPEND LINES OF lt_trassen_out TO rt_trassen.

  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->GET_TRASSEN_FOR_RICHTUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TRASSEN                     TYPE        ZIA_2TRASSEN_T
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2_RICHTUNG
* | [--->] IT_SORT_ORDER                  TYPE        ABAP_SORTORDER_TAB
* | [<-()] RT_TRASSEN                     TYPE        ZIA_2TRASSEN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_trassen_for_richtung.
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
* - Filters and sorts Trassen entries by given direction and sorting order
* - For each unique EIZ (operating point), collects Trassen with minimum or maximum Reihenfolge
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Copy input table to local working table
  DATA(lt_trassen) = it_trassen.

  " Remove entries not matching the requested direction
  DELETE lt_trassen WHERE richtung <> iv_richtung.

  " Extract unique EIZ (operating points) from filtered trassen
  DATA(lt_eiz) = CORRESPONDING tt_eiz( lt_trassen ).
  SORT lt_eiz BY zid_eiz. " Sorting needed for DELETE ADJACENT DUPLICATES
  DELETE ADJACENT DUPLICATES FROM lt_eiz COMPARING zid_eiz.

  " Sort trassen by dynamic sort order passed as parameter
  SORT lt_trassen BY (it_sort_order).

  " Loop over each unique EIZ
  LOOP AT lt_eiz ASSIGNING FIELD-SYMBOL(<ls_eiz>).

    DATA(lt_trassen_eiz) = lt_trassen.

    " Remove all trassen entries that do not belong to the current EIZ
    DELETE lt_trassen_eiz WHERE zid_eiz <> <ls_eiz>-zid_eiz. "#EC CI_STDSEQ

    " Loop over trassen for current EIZ
    LOOP AT lt_trassen_eiz ASSIGNING FIELD-SYMBOL(<ls_trasse>). "#EC CI_NESTED

      AT FIRST.
        " Save the Reihenfolge of the first entry
        DATA(lv_reihenfolge) = <ls_trasse>-reihenfolge.
      ENDAT.

      " Exit loop when Reihenfolge changes (only want trassen with same Reihenfolge)
      IF <ls_trasse>-reihenfolge <> lv_reihenfolge.
        EXIT.
      ENDIF.

      " Append matching trassen to result table
      APPEND <ls_trasse> TO rt_trassen.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_ENTSORGUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD is_entsorgung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method is_entsorgung_schicht
* - Checks if the current supply type corresponds to 'Entsorgung' (disposal)
* - Returns abap_true if yes, otherwise abap_false (default)
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Get the supply type from global parameter object
  DATA(lv_supply_type) = go_parameter->get_data( )-supply_type.

  " Check if supply type equals 'Entsorgung'
  IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung.
    rv_value = abap_true.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_TREMOLA_ACTIVE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_tremola_active.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                 *
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*
* Method to check if the Tremola feature is active for the current
* shift (gs_schicht). The method evaluates based on certain date ranges,
* section (Sperrabschnitt), and flags in the database table zia_2trassen.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    " Initialize the local variable for section (Sperrabschnitt)
    DATA(lv_sp) = VALUE zia_2_roehre( ).

    " If the period code is 'CBT', Tremola is not active
    IF gs_schicht-zzperi = 'CBT'.
      rv_value = abap_false.
    ELSE.
      " Convert route estimation to Sperrabschnitt format
      DATA(lv_sperrabsch) = CONV zia_2_sperrabschnitt( get_rj_est( ) ).

      " Extract first character if Sperrabschnitt is not initial
      lv_sp = COND #( WHEN lv_sperrabsch IS NOT INITIAL THEN lv_sperrabsch(1) ).

      " Count entries where Tremola is active for the current shift and section
      SELECT COUNT( * )
        INTO @DATA(lv_count)
        FROM zia_2tracks
        WHERE zzperi         = @gs_schicht-zzperi
          AND gueltig_von   <= @gs_schicht-start_datum
          AND gueltig_bis   >= @gs_schicht-start_datum
          AND sperrabschnitt = @lv_sp
          AND tremola_start  = 'X'
          AND trasse_aktiv   = 'X'.

      " Return TRUE if any matching records found, else FALSE
      rv_value = boolc( lv_count > 0 ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->JOIN_EZ_FORM_FROM_TREMOLA
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_EZ_FORM_WD                  TYPE        ZIA_2_EZ_FORM_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD join_ez_form_from_tremola.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method join_ez_form_from_tremola
* - Merges EZ form data from Tremola web service into internal table
* - Ensures manual changes have priority over Tremola data
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         Added logic to remove Tremola entries if manual entry exists
*----------------------------------------------------------------------*

  " Map incoming EZ form WD data to internal EZ form structure
  DATA(lt_ez_form) = CORRESPONDING zia_2_ez_frm_t(
                      ct_ez_form_wd
                      MAPPING zid_eiz  = zid_eiz
                              zarbstl  = zarbstl
                              richtung = richtung ).

  " Sort and remove duplicate entries
  SORT lt_ez_form.
  DELETE ADJACENT DUPLICATES FROM lt_ez_form COMPARING ALL FIELDS.

  " Sort by zid_eiz ascending, richtung descending, zarbstl ascending
  SORT lt_ez_form BY zid_eiz ASCENDING
                     richtung DESCENDING
                     zarbstl ASCENDING.

  LOOP AT lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form>).

    " Create a copy of manual EZ form data, excluding Tremola-origin data
    DATA(lt_ez_form_manual) = gt_ez_form.
    DELETE lt_ez_form_manual WHERE data_origin EQ zif_ia_2_constant=>mc_data_origin-tremola. "#EC CI_STDSEQ

    " Check if a manual entry exists for current Tremola EZ form entry
    READ TABLE lt_ez_form_manual TRANSPORTING NO FIELDS "#EC PREF_LINE_EX  "#EC CI_STDSEQ
      WITH KEY zid_eiz  = <ls_ez_form>-zid_eiz
               richtung = <ls_ez_form>-richtung
               zarbstl  = <ls_ez_form>-zarbstl
               ez_aktiv = abap_true.

    IF sy-subrc = 0.
      " Manual EZ form entry has priority, so remove Tremola entry from output
      DELETE ct_ez_form_wd WHERE zid_eiz  = <ls_ez_form>-zid_eiz "#EC CI_STDSEQ
                             AND richtung = <ls_ez_form>-richtung
                             AND zarbstl  = <ls_ez_form>-zarbstl
                             AND ez_aktiv = abap_true.
    ENDIF.

  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->READ_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD read_ez_form.
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
* - Reads EZ Formation data either from Tremola webservice or database
* - Decides source based on tremola activation flag
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Only proceed if internal EZ form table is empty (no previous data loaded)
  CHECK gt_ez_form[] IS INITIAL.

  " If Tremola webservice is active, fetch EZ form data from Tremola
  IF is_tremola_active( ).
    get_ez_form_tremola( ). """
    CLEAR sy-subrc.
  ELSE.
    " Otherwise select EZ form data from local database table
    select_ez_form( ).
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SELECT_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD select_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method select_ez_form
* - Selects EZ form records for the current work shift (zschicht)
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
* Added filtering and sorting of EZ form data after selection
*----------------------------------------------------------------------*

  " Select EZ form entries from database table zia_2ez_form for the current shift
  SELECT zschicht, zugnummer, zarbstl, zid_eiz, richtung, data_origin, ez_aktiv
 ##TOO_MANY_ITAB_FIELDS   INTO CORRESPONDING FIELDS OF TABLE @gt_ez_form
    FROM zia_2sf_ez_form
    WHERE zschicht = @gs_schicht-zschicht.

  " Filter the EZ form data according to business logic
  filter_ez_form( CHANGING ct_data = gt_ez_form ).  ">001< +

  " Sort the EZ form data for further processing or output
  sort_ez_form( ).

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SELECT_TRASSEN
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD select_trassen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
* Initial creation of method select_trassen
* - Selects track routes ("Trassen") relevant for the current shift
* - Filters by period, validity date, and active status
* - Enhances each route with its corresponding EIZ (entry/exit zone) ID
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Exit if gt_trassen is already populated
  CHECK gt_trassen[] IS INITIAL.

  " Convert RJ estimation to Sperrabschnitt type
  DATA(lv_sperrabsch) = CONV zia_2_sperrabschnitt( get_rj_est( ) ).

  " Select trassen (routes) for the current period and sperrabschnitt
  SELECT zugnummer,
         sperrabschnitt,
         zab,
         zan,
         zug,
         betriebspunkt,
         startsignal,
         gleis,
         zeit_am_start_tag,
         richtung,
         reihenfolge,
         tremola_start,
         spitzkehre,
         data_origin "+>001<
##TOO_MANY_ITAB_FIELDS    INTO CORRESPONDING FIELDS OF TABLE @gt_trassen
    FROM zia_2tracks
    WHERE zzperi = @gs_schicht-zzperi
      AND gueltig_von <= @gs_schicht-start_datum
      AND gueltig_bis >= @gs_schicht-start_datum
      AND sperrabschnitt = @lv_sperrabsch
      AND trasse_aktiv = 'X'.

  " Loop over selected routes to assign EIZ (entry/exit zone) IDs
  LOOP AT gt_trassen ASSIGNING FIELD-SYMBOL(<ls_trassen>).
    <ls_trassen>-zid_eiz = zcl_ia_2operating_point=>get_eiz( iv_betriebspunkt = <ls_trassen>-betriebspunkt ).
  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SORT_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD sort_ez_form.
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
* - Sorts EZ form internal table by key fields
* - Removes duplicate entries keeping only those with data_origin REAL
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  " Sort the EZ form data by keys and data origin ascending,
  " so that entries with data_origin 'REAL' come first
  SORT gt_ez_form BY zschicht
                      zugnummer
                      zarbstl
                      zid_eiz
                      richtung
                      data_origin ASCENDING.

  " Remove duplicates based on key fields, keeping the first occurrence
  DELETE ADJACENT DUPLICATES FROM gt_ez_form COMPARING zschicht
                                                            zugnummer
                                                            zarbstl
                                                            zid_eiz
                                                            richtung.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_AUFTRAEGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftraege.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AUFTRAEGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_arbstelle_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftraege   TYPE REF TO cl_object_map.
    DATA lo_auftraege_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftrag     TYPE REF TO zcl_ia_2order.


    ro_objects = NEW cl_object_map( ).

    lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle   ?= lo_arbstelle_i->get_next( ).
      lo_auftraege   = lo_arbstelle->get_auftraege(  ).
      lo_auftraege_i ?= lo_auftraege->get_values_iterator( ).
      WHILE lo_auftraege_i->has_next( ) = abap_true.
        lo_auftrag ?= lo_auftraege_i->get_next( ).
        CHECK lo_auftrag->get_vorschau_flag( ) = abap_false.
        ro_objects->put( EXPORTING key = lo_auftrag->get_data( )-aufnr   value = lo_auftrag ).
      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_BEZEICHNUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_TEXT                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bezeichnung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_BEZEICHNUNG_SCHICHT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_text      TYPE string.

    DATA(lt_sp_schicht) = gt_sp_schicht.
    SORT lt_sp_schicht BY sperrabschnitt zintervallart.
    DELETE ADJACENT DUPLICATES FROM lt_sp_schicht COMPARING sperrabschnitt zintervallart.

    LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>).
      CHECK <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-e
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-e1
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-e2
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-e3
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-w
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-w1
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-w2
         OR <ls_sp_schicht>-sperrabschnitt = mc_sperrabs-w3.

      lv_text =  |{ lv_text } { '| ' } { <ls_sp_schicht>-zintervallart } - { <ls_sp_schicht>-sperrabschnitt }|.
    ENDLOOP.
    ">001< + end
    IF lv_text IS NOT INITIAL. " Sperrabschnitt im Tunnel
      rv_text = lv_text.
    ELSE.
      "Offene Strecke Sperrabschnitte ermitteln
      "OSS bei GBT
      LOOP AT gt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht_oss>).
        IF <ls_sp_schicht_oss>-sperrabschnitt(1) EQ 'S'.
          lv_text =  |{ '|' } { <ls_sp_schicht_oss>-zintervallart } - { <ls_sp_schicht_oss>-sperrabschnitt(1) }|.
          EXIT. " Treffer, also weiter mit OSN
        ENDIF.
      ENDLOOP.
      "OSN bei GBT
      LOOP AT gt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht_osn>).
        IF <ls_sp_schicht_oss>-sperrabschnitt(1) EQ 'N'.
          lv_text =  |{ lv_text } { '|' } { <ls_sp_schicht>-zintervallart } - { <ls_sp_schicht_osn>-sperrabschnitt(1) }|. "#EC CI_NOORDER
          EXIT.
        ENDIF.
      ENDLOOP.
      "OSC bei CBT
      LOOP AT gt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht_osc>).
        IF <ls_sp_schicht_osc>-sperrabschnitt(1) EQ 'C'.
          lv_text =  |{ lv_text } { '|' } { <ls_sp_schicht_osc>-zintervallart } - { <ls_sp_schicht_osc>-sperrabschnitt(1) }|. "#EC CI_NOORDER
          EXIT.
        ENDIF.
      ENDLOOP.
      rv_text = lv_text.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_NOTES
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        ZIA_2SHIFT_NOTES_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_notes.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_NOTES
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
*    IF me->gt_notif_longtext IS NOT INITIAL.
*      rv_boolean = abap_true.
*    ENDIF.
    rt_data = me->gt_notes
    .
    SORT rt_data BY aedtm DESCENDING.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_SCHICHTSAUFTRAG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_AUFNR                       TYPE        AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_schichtsauftrag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :GET_SCHICHTSAUFTRAG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    SELECT SINGLE aufnr
      FROM qmel
      INTO @rv_aufnr
      WHERE qmnum =  @gs_schicht-zschicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_STATUS                      TYPE        ZIA_2_WRKSHFTSTATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_STATUS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CONSTANTS: lc_method_supply_ui_schicht TYPE string VALUE 'SUPPLY_UI_SCHICHT'.
    DATA: lt_abap_callstack TYPE abap_callstack.

    rv_status = me->gs_schicht-zstatus.

    CALL FUNCTION 'SYSTEM_CALLSTACK'
      EXPORTING
        max_level = 2
      IMPORTING
        callstack = lt_abap_callstack.

    IF line_exists( lt_abap_callstack[ 2 ] ) AND
       lt_abap_callstack[ 2 ]-blockname = lc_method_supply_ui_schicht.
      rv_status = zif_ia_2_wrkshft_status=>mc_shift_released.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_EMPTY
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
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_value = go_arbeitsstellen->is_empty( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->UNLOCK
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
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

  " Call the DEQUEUE_EIQMEL function module to release the lock on the object
  CALL FUNCTION 'DEQUEUE_EIQMEL'
    EXPORTING
      mode_qmel = 'E'
      mandt     = sy-mandt
      qmnum     = me->gs_schicht-zschicht "CONV qmel-qmnum( me->gs_schicht-zschicht )
      x_qmnum   = ' '
      _scope    = '1'
      _synchron = 'X'
      _collect  = ' '.
  "   Current client
  " Quality management number from the shift data
*  Empty value for x_qmnum, used to release the lock
* Scope of the lock (1 = single object)
* Indicates synchronous operation (lock/unlock in real-time)
*  No collection is needed for the lock release


  " Set the gv_locked variable to false after unlocking
  me->gv_locked = abap_false.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->UNLOCK_SUB_OBJECTS
* +-------------------------------------------------------------------------------------------------+
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
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  " Declare variables for iterating over work areas (Arbeitsstellen)
  DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,   " Iterator for work areas
        lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.               " Work area object

  " Get the iterator for all work areas (Arbeitsstellen)
  lo_arbstelle_i ?= get_arbeitsstellen( )->get_values_iterator( ).

  " Loop through each work area in the collection
  WHILE lo_arbstelle_i->has_next( ) = abap_true.

    " Get the next work area object in the collection
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    " Unlock the current work area
    lo_arbstelle->unlock( ).

    " Try to unlock the sub-objects associated with this work area
    TRY.
        lo_arbstelle->unlock_sub_objects( ).   " Unlock any sub-objects of the work area
      CATCH zcx_ia_2failure INTO DATA(lx_fehler).   " If there is a failure during unlocking
        RAISE EXCEPTION lx_fehler.    " Raise the exception to be handled by the calling program
    ENDTRY.

  ENDWHILE.  " Continue to the next work area until all have been processed
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FILTER_FZTYP                TYPE        ZIA_2_ID_FZTYP(optional)
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRZEUGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
          lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

    ro_objects = NEW #( ).
    lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).

    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).

      lo_fahrzeuge_i ?= lo_arbstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        " Filter anwenden
        CHECK iv_filter_fztyp IS INITIAL OR lo_fahrzeug->get_data( )-zid_fztyp = iv_filter_fztyp.
        " Fahtzeug zurückgeben
        ro_objects->put( EXPORTING key = lo_fahrzeug->get_id( )   value = lo_fahrzeug ).
      ENDWHILE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->HAS_SCHICHT_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RETURN                      TYPE        WDY_BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_schicht_parameter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : HAS_SCHICHT_PARAMETER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    SELECT SINGLE zschicht
          FROM zia_2sf_params
          WHERE zschicht = @me->gs_schicht-zschicht
          INTO @DATA(lv_zschicht).

    rv_return = COND #( WHEN syst-subrc EQ 0 THEN abap_true ELSE abap_false ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_LOCKED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RETURN                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_locked.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_LOCKED
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_return = me->gv_locked.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_FAHRZEUG_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FGZ_ID                      TYPE        ZIA_2_ID_FZG
* | [<-()] RO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_fahrzeug_by_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRZEUG_BY_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
   DATA lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator.
   DATA lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.

   DATA(lo_fahreuge) = get_fahrzeuge( ).
   lo_fahrzeuge_i ?= lo_fahreuge->get_values_iterator( ).

   WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
     lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
     CHECK iv_fgz_id = lo_fahrzeug->get_id( ).
     ro_fahrzeug = lo_fahrzeug.
     EXIT.
   ENDWHILE.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_ARBEITSSTELLE_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIA_2_ID_ARBSTL
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IA_2WRKPLACE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_arbeitsstelle_by_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_ARBEITSSTELLE_BY_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(li_iterator) = go_arbeitsstellen->get_values_iterator( ).

    WHILE li_iterator->has_next( ).
      TRY .
          ro_instance ?= li_iterator->get_next( ).
          CHECK ro_instance->get_id( ) = iv_id.
          " instance of Arbeitsstelle found
          RETURN.
        ##NO_HANDLER        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDWHILE.

    " NO instance of Arbeitsstelle found
    CLEAR ro_instance.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_FIRST_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_ARBSTELLE                   TYPE REF TO ZCL_IA_2WRKPLACE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_first_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FIRST_ARBEITSSTELLE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       05.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ro_arbstelle ?= go_arbeitsstellen->get_by_position( 1 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_START_TIMESTAMP_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_start_timestamp_text.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_START_TIMESTAMP_TEXT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_date) = get_data( )-start_datum.
    DATA(lv_time) = get_data( )-start_zeit.

    rv_value = |{ lv_date+6(2) }.{ lv_date+4(2) }.{ lv_date+0(4) } / { lv_time+0(2) }:{ lv_time+2(2) }|.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->LOCK
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
    DATA: lv_message_v1 TYPE symsgv,
          lv_zschicht   TYPE zia_2_wrkshifts-zschicht.


    DATA(lv_mode) = COND #( WHEN iv_check IS NOT INITIAL THEN 'V' ELSE 'E' ).

*-----------------------------------------------------------------
* Sperren
*-----------------------------------------------------------------
    lv_zschicht = me->gs_schicht-zschicht.
    CALL FUNCTION 'ENQUEUE_EIQMEL'
      EXPORTING
        mode_qmel      = lv_mode
        mandt          = sy-mandt
        qmnum          = CONV qmel-qmnum( lv_zschicht )
        x_qmnum        = ' '
        _scope         = '1'
        _wait          = ' '
        _collect       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
*-----------------------------------------------------------------
* Exception
*-----------------------------------------------------------------
    IF sy-subrc <> 0.
      me->gv_locked = abap_false.
      IF sy-msgv1 IS NOT INITIAL.
        TRY.
            zcl_ia_2utilities=>get_user_details( EXPORTING iv_uname       = CONV uname( sy-msgv1 )
                                                  IMPORTING ev_voller_name = DATA(lv_name) ).
          ##NO_HANDLER          CATCH zcx_ia_2failure .
        ENDTRY.
      ENDIF.

      DATA(lx_fehler) = NEW zcx_ia_2failure( ).

      WRITE me->gs_schicht-start_datum DD/MM/YYYY TO lv_message_v1.

      lx_fehler->add_error_msg( EXPORTING iv_msgid = 'ZIA_2_REAL'
                                          iv_msgno =  72
                                          iv_msgv1 = lv_message_v1
                                          iv_msgv2 = lv_name ).
      RAISE EXCEPTION lx_fehler.
    ELSE.
      IF iv_check IS INITIAL.
        me->gv_locked = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->REMOVE_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OBJECT                      TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : REMOVE_ARBEITSSTELLE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       13.08.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: ls_data   TYPE zia_2sf_wa,
          lx_fehler TYPE REF TO zcx_ia_2failure.

    ls_data = io_object->get_data( ).

*-----------------------------------------------------------------------------------------------------------
* Info in Appl. Log schreiben
*-----------------------------------------------------------------------------------------------------------
    DATA(lo_log) = zcl_ia_2log=>get_instance( ).
    lo_log->add_info( EXPORTING iv_text       = |{ 'Arbeitsstelle entfernen:' }{ ls_data-zarbstl } { 'Schicht:' }{ ls_data-zschicht }|
                                iv_sub_object = zcl_ia_2log=>mc_sub_object_planung ).
*-----------------------------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------------------------------------
* Abhängigen Objekte sperren
*-----------------------------------------------------------------------------------------------------------
    TRY.
        "Zunächst prüfen
        io_object->lock_sub_objects( EXPORTING iv_check = abap_true ).
      CATCH zcx_ia_2failure INTO lx_fehler.
        RAISE EXCEPTION lx_fehler.
    ENDTRY.

*-----------------------------------------------------------------------------------------------------------
* Effektive Arbeitsstelle löschen
*-----------------------------------------------------------------------------------------------------------
    " Aufträge im ERP zurücksetzen (Originaldaten laden)
    DATA(lv_zstatus) = get_status( ).
    IF    lv_zstatus GT zif_ia_2_wrkshft_status=>mc_plannig_started
      AND lv_zstatus LT zif_ia_2_wrkshft_status=>mc_shift_released .
      TRY.
          zcl_ia_2utilities=>restore_auftraege_erp( io_auftraege = io_object->get_auftraege( ) ).
        CATCH zcx_ia_2failure INTO lx_fehler.
          RAISE EXCEPTION lx_fehler.
      ENDTRY.
    ENDIF.


    IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
      io_object->refresh_manual_signals( ).
    ENDIF.


    " Remove Jobs from AS
    TRY.
        io_object->remove_auftraege( iv_change_erp = abap_false ).
      CATCH zcx_ia_2failure INTO lx_fehler.
        RAISE EXCEPTION lx_fehler.
    ENDTRY.

    " Remove AS from ObjectMap
    go_arbeitsstellen->remove( key = io_object->get_data( )-zarbstl ).

    set_status_by_state( ).

    " Remove AS from DB
    ls_data = io_object->get_data( ).
    DELETE FROM zia_2sf_wa WHERE zschicht = ls_data-zschicht AND zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2sf_veh_seat WHERE zschicht = ls_data-zschicht AND zid_as = ls_data-zarbstl.
    DELETE FROM zia_2sf_wa_veh WHERE zid_arbstl = ls_data-zarbstl.

    DELETE FROM zia_2bs_km WHERE zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2sf_bs_time WHERE zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2map_as_szg WHERE zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2sf_ez_form   WHERE zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2map_matfzg WHERE zarbstl = ls_data-zarbstl.
    DELETE FROM zia_2order_bup WHERE zschicht = ls_data-zschicht.
    COMMIT WORK.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->RESET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reset.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Reset
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_arbstelle TYPE REF TO zcl_ia_2wrkplace,    " Local variable for work area
##NEEDED          lx_fehler    TYPE REF TO zcx_ia_2failure.    " Exception handling for failures
    DATA lv_order TYPE aufnr.
    DATA(lv_mark) = abap_true.    " Flag for marking the work area
    " Define fixed phases for maintenance
    DATA lv_maintordovrlprocphase TYPE eam_ostat_phase VALUE '05'.
    DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase VALUE '0055'.

    " 1. Get the work area based on the current shift and mark
    me->get_workarea( EXPORTING iv_shift = CONV zia_2_workshift( gs_schicht-zschicht )
                                iv_mark  = lv_mark ).
    " 2. Try unlocking the work area and its sub-objects
    TRY.
        me->unlock( ).               " Unlock the work area
        me->unlock_sub_objects( ).   " Unlock any sub-objects associated with the work area
      ##NO_HANDLER      CATCH zcx_ia_2failure INTO lx_fehler.
        " If unlocking fails, the exception is caught but not further processed
    ENDTRY.

    " 3. Iterate over all work areas (Arbeitsstellen)
    DATA(li_arbstelle_i) = go_arbeitsstellen->get_values_iterator( ).

    WHILE li_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= li_arbstelle_i->get_next( ).
      DATA(lo_orders) =  lo_arbstelle->get_auftraege( ).

      TRY.
          zcl_ia_2order_utils=>reset_orsc_status( io_auftraege = lo_orders ).
        ##NO_HANDLER CATCH zcx_ia_2failure." INTO DATA(lx_orsc_error).
      ENDTRY.
      IF line_exists( lo_orders->map[ 1 ] ) AND lo_orders->map[ 1 ]-key IS NOT INITIAL.
        lv_order = lo_orders->map[ 1 ]-key.
        me->deactivate_user_status( iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
                                   iv_order = lv_order ).
      ENDIF.
      READ TABLE lo_orders->map INDEX 1 INTO DATA(ls_entry).

      IF sy-subrc = 0 AND ls_entry-key IS NOT INITIAL.
        lv_order = ls_entry-key.
***        me->deactivate_user_status( iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
***                    iv_order = lv_order ).

        " Updating Phase
        zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = lv_order
                                                   iv_maintordovrlprocphase = lv_maintordovrlprocphase
                                                   iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
      ENDIF.

      " 4. For each work area, remove associated orders and vehicles
      TRY.
          lo_arbstelle->remove_auftraege( ).   " Remove associated orders
          lo_arbstelle->remove_fahrzeuge( ).   " Remove associated vehicles
        ##NO_HANDLER        CATCH zcx_ia_2failure INTO lx_fehler.
          " If there is a failure during removal, the exception is caught but not raised again
*          RAISE EXCEPTION lo_fehler.
      ENDTRY.


      " 5. Remove the work area from the system
      me->remove_arbeitsstelle( io_object = lo_arbstelle    iv_ignore_errors = abap_true ).
    ENDWHILE.

    " 6. Delete related entries in the zia_2sf_wa table for the current shift
    DELETE FROM zia_2sf_wa WHERE zschicht = me->gs_schicht-zschicht.

    " 7. Reset the shift status in gs_schicht
    gs_schicht-zstatus       = zif_ia_2_wrkshft_status=>mc_interval_provided.  " Mark the status as interval provided
    gs_schicht-ztremola_done = abap_false.  " Set temporary rollback done flag to false


*    UPDATE zia_2wrkshifts SET
*        zstatus       = @gs_schicht-zstatus,
*        ztremola_done = @gs_schicht-ztremola_done
*      WHERE zschicht = @gs_schicht-zschicht.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->SAVE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_RETURN                      TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Save
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_schicht-zschicht IS NOT INITIAL.

    DATA(lt_return) = save_shift_data( ).
    APPEND LINES OF lt_return TO rt_return.

    "*******************
    "* Planungsparameter in Z-tabelle speichern
    "***************
    go_parameter->save( ).

    "*******************
    "* Arbeitsstellen in Z-tabelle speichern
    "***************
    DATA(li_arbstellen_i) = go_arbeitsstellen->get_values_iterator( ).

    WHILE li_arbstellen_i->has_next( ) = abap_true.
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbstellen_i->get_next( ) ).

      TRY .
          lo_arbstelle->lock( iv_check = abap_true ).
          lo_arbstelle->save( ).
        CATCH zcx_ia_2failure INTO DATA(lx_status_error).
          APPEND LINES OF lx_status_error->gt_bapiret TO rt_return.
          CONTINUE.
      ENDTRY.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->SAVE_SHIFT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_RETURN                      TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_shift_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SAVE_SHIFT_DATA
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CHECK gs_schicht-zschicht IS NOT INITIAL.
*
    zcl_ia_2utilities=>set_update_data_any_structure( CHANGING cv_update_data_structure = gs_schicht ).
*
*    MODIFY zia_2wrkshifts FROM @gs_schicht.

    DATA: ls_notif_header_in  TYPE bapi2080_nothdri,  " Input structure for notification header
##NEEDED          ls_notif_header_out TYPE bapi2080_nothdre,  " Output structure for notification header
          ls_notifheader_x    TYPE bapi2080_nothdri_x. " Change indicator for notification header

    DATA: lt_message      TYPE bapiret2_t,         " Table for capturing messages from BAPI calls
          lt_message_save TYPE bapiret2_t.         " Table for messages related to saving the notification


    ls_notif_header_in-priority = gs_schicht-zstatus.
    ls_notifheader_x-priority   = 'X'.

    " Call BAPI to modify the notification data (priority field)
    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
      EXPORTING
*       number             = CONV qmnum( gs_schicht-zschicht )  " Convert shift number to QM number format
        number             = gs_schicht-zschicht
        notifheader        = ls_notif_header_in
        notifheader_x      = ls_notifheader_x
      IMPORTING
        notifheader_export = ls_notif_header_out
      TABLES
        return             = lt_message.           " Return table for error messages

    " If no error messages are returned, proceed to save the notification
    IF lt_message IS INITIAL. " If the modification was successful, save the notification
      " Call BAPI to save the notification changes
      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
*         number      = CONV qmnum( gs_schicht-zschicht )     " Pass the notification number
          number      = gs_schicht-zschicht     " Pass the notification number
        IMPORTING
          notifheader = ls_notif_header_out        " Exported notification header after saving
        TABLES
          return      = lt_message_save.           " Table for return messages from the save BAPI

      " If the save was successful, commit the transaction
      IF lt_message_save IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.   " Wait for commit to complete before returning
      ELSE.
        APPEND LINES OF lt_message TO rt_return.
      ENDIF.
    ELSE.
      APPEND LINES OF lt_message TO rt_return.
    ENDIF.















  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_JOKER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_joker.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_JOKER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    READ TABLE me->gt_sp_schicht WITH KEY zintervallart = 'JI' TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
    IF syst-subrc = 0.
      rv_boolean = abap_true.
    ELSE.
      rv_boolean = abap_false.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->DISTRIBUTE_GSMR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : DISTRIBUTE_GSMR
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
METHOD distribute_gsmr.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->SET_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STATUS                      TYPE        ZIA_2_WRKSHFTSTATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_STATUS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_schicht-zstatus = iv_status.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->DELETE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
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
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    clear_ez_form( ).

    DELETE FROM zia_2sf_ez_form WHERE zschicht = @gs_schicht-zschicht.

    COMMIT WORK.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->SAVE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIA_2_EZ_FRM_T(optional)
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
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  DATA(lt_ez_form_inp) = COND #( WHEN it_ez_form[] IS NOT INITIAL THEN it_ez_form[] ELSE gt_ez_form[] ).

  DATA(lv_sperrabschnitt) = CONV zia_2_spabs( get_rj_est( ) ).

  " Get the most inner Arbeitsstelle in the Tunnel
  get_most_inner_arbeitsstelle( IMPORTING eo_arbstelle = DATA(lo_most_inner_arbstelle) ).

  " and put it first to the object collection.
  DATA(lo_arbstelle_collection) = NEW cl_object_collection( ).

  IF lo_most_inner_arbstelle IS BOUND. "+>001<
    lo_arbstelle_collection->add( element = lo_most_inner_arbstelle ).
  ENDIF. "+>001<

  " Than put all the other Arbeitsstellen for Zugangsart Schine to the object collection.
  DATA(li_arbstelle_i) = go_arbeitsstellen->get_values_iterator( ).
  WHILE li_arbstelle_i->has_next( ).
    DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbstelle_i->get_next( ) ).
    "CHECK lo_arbstelle->get_zugangsarten( )-schiene = abap_true.     "<--- SAPCBT 914 (-)
    CHECK lo_arbstelle->is_schiene( ).                                "<--- SAPCBT 914 (+)
    CHECK lo_arbstelle <> lo_most_inner_arbstelle.

    lo_arbstelle_collection->add( element = lo_arbstelle ).

  ENDWHILE.

  clear_ez_form( ).

  " Save EZ Form now for all Arbeitsstellen with the most inner one as the first one.
  li_arbstelle_i = CAST if_object_collection_iterator( lo_arbstelle_collection->get_iterator( ) ).
  WHILE li_arbstelle_i->has_next( ).
    lo_arbstelle = CAST zcl_ia_2wrkplace( li_arbstelle_i->get_next( ) ).

    DATA(lv_zarbstl) = lo_arbstelle->get_id( ).

    DATA(lt_ez_form) = VALUE zia_2_ez_frm_t( FOR <ls_ez_form> IN lt_ez_form_inp
                                              WHERE (     zschicht = gs_schicht-zschicht
                                                      AND zarbstl  = lv_zarbstl )
                                              ( <ls_ez_form> ) ).
    ">002< + begin
    IF is_versorgung_schicht( ).
      DELETE lt_ez_form WHERE richtung = zif_ia_2_constant=>mc_richtung-ausfahrt.
    ELSEIF is_entsorgung_schicht( ).
      DELETE lt_ez_form WHERE richtung = zif_ia_2_constant=>mc_richtung-einfahrt.
    ENDIF.
    ">002< + end

    CHECK lt_ez_form[] IS NOT INITIAL.

    IF lo_arbstelle = lo_most_inner_arbstelle.
      lo_arbstelle->save_ez_form( it_ez_form = lt_ez_form ).
      DATA(ls_inner_sp_zeiten) = lo_arbstelle->get_sp_zeiten_data( iv_sperrabschnitt = lv_sperrabschnitt ).
    ELSE.
      lo_arbstelle->save_ez_form( it_ez_form         = lt_ez_form
                                  is_inner_sp_zeiten = ls_inner_sp_zeiten
                                  iv_called_from     = iv_called_from ).      ">003< +
    ENDIF.

  ENDWHILE.

  COMMIT WORK AND WAIT.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->COPY_VERSORGUNG_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_versorgung_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lo_fahrzg TYPE REF TO zcl_ia_2vehicle.
    DATA lo_arbstl TYPE REF TO zcl_ia_2wrkplace.
    DATA(ls_fzg) = VALUE zia_2vehicles( ).

    DATA(lo_v_schicht) = get_versorgung_schicht( ).
    IF lo_v_schicht IS NOT BOUND.
      RETURN.
    ENDIF.

    DATA(lt_matrix_src) = zcl_ia_2utilities2=>get_schicht_objects_matrix( io_schicht = lo_v_schicht iv_level = zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug ).
    DATA(lt_matrix_trg) = zcl_ia_2utilities2=>get_schicht_objects_matrix( io_schicht = me iv_level = zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug ).
    DELETE lt_matrix_src WHERE level <> zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug.
    DELETE lt_matrix_trg WHERE level <> zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug.
    SORT: lt_matrix_src, lt_matrix_trg BY arbstl_ktxt fahrzg_id.

    LOOP AT lt_matrix_src ASSIGNING FIELD-SYMBOL(<ls_matrix_src>) WHERE level = zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug.
      "We assume that the same Arbeitsstelle already exists in target Schicht
      ASSIGN lt_matrix_trg[ arbstl_ktxt = <ls_matrix_src>-arbstl_ktxt ] TO FIELD-SYMBOL(<ls_matrix_trg>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      FREE lo_fahrzg.
      lo_arbstl = <ls_matrix_trg>-o_arbstl.
      DATA(lo_fahrzg_src) = <ls_matrix_src>-o_fahrzg.
      "Check if Fahrzeug was already referenced
      ASSIGN lt_matrix_trg[ fahrzg_ref_id = <ls_matrix_src>-fahrzg_id ] TO <ls_matrix_trg>.
      IF sy-subrc = 0.
        lo_fahrzg = <ls_matrix_trg>-o_fahrzg.
      ELSE. "new or existing fahrzeug
        LOOP AT lt_matrix_trg ASSIGNING <ls_matrix_trg>. "#EC CI_NESTED
          CHECK <ls_matrix_trg>-arbstl_ktxt = <ls_matrix_src>-arbstl_ktxt
            AND <ls_matrix_trg>-fahrzg_typ  = <ls_matrix_src>-fahrzg_typ
            AND <ls_matrix_trg>-o_fahrzg->get_ref_fzg_id( ) IS INITIAL.
          "Similar Fahrzeuge already exists in the traget AS
          lo_fahrzg = <ls_matrix_trg>-o_fahrzg.
          EXIT.
        ENDLOOP.

        IF lo_fahrzg IS NOT BOUND.
          "There is no Fahrzeug in target AS - create a new one
          ls_fzg-zid_fztyp = <ls_matrix_src>-o_fahrzg->get_data( )-zid_fztyp.
          ls_fzg-zid_fzg   = zcl_ia_2utilities=>get_next_id( ).
          MODIFY zia_2vehicles FROM ls_fzg.         "#EC CI_IMUD_NESTED
          COMMIT WORK.
          lo_fahrzg = NEW #( iv_id = ls_fzg-zid_fzg io_arbeitsstelle = lo_arbstl ).
          lo_arbstl->add_fahrzeug( io_fahrzeug = lo_fahrzg ).
        ENDIF.
      ENDIF.

      "Update Fahrzeug data
      lo_fahrzg->set_uic_nummer( iv_uic_nummer = lo_fahrzg_src->get_uic_nummer( ) ).
      lo_fahrzg->set_reihung( iv_reihung = lo_fahrzg_src->get_reihung( ) ).
      lo_fahrzg->set_orientierung( iv_orientierung = lo_fahrzg_src->get_orientierung( ) ).
      lo_fahrzg->set_orientierung_src( iv_orient_src = lo_fahrzg_src->get_orientierung_src( ) ).
      lo_fahrzg->set_etcs( iv_is_etcs = lo_fahrzg_src->get_etcs( ) ).
      lo_fahrzg->set_original_tremola_reihung( iv_reihung = lo_fahrzg_src->get_original_reihung( ) ).
      lo_fahrzg->set_trennung( iv_trennung  = lo_fahrzg_src->get_trennung( ) ).
      lo_fahrzg->set_ref_schicht( <ls_matrix_src>-schicht_id ).
      lo_fahrzg->set_ref_arbstl( <ls_matrix_src>-arbstl_id ).
      lo_fahrzg->set_ref_fzg( <ls_matrix_src>-fahrzg_id ).
      lo_arbstl->save( ).
    ENDLOOP.

    COMMIT WORK AND WAIT.

    "Remove Fahrzeuge without refernce
    LOOP AT lt_matrix_trg ASSIGNING <ls_matrix_trg> WHERE level = zif_ia_2_constant=>mc_schicht_obj_matrix_lvl-fahrzeug.
      CHECK <ls_matrix_trg>-o_fahrzg IS BOUND.
      CHECK <ls_matrix_trg>-o_fahrzg->get_ref_fzg_id( ) IS INITIAL.
      <ls_matrix_trg>-o_arbstl->remove_fahrzeug( io_fahrzeug = <ls_matrix_trg>-o_fahrzg ).
      <ls_matrix_trg>-o_arbstl->save( ).
      COMMIT WORK.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_MET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DATA                        TYPE        ZIF_IA_2_MET=>TV_MET_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_met_type.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_MET_TYPE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( go_arbeitsstellen->get_values_iterator( ) ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).

      CHECK lo_arbstelle->has_met( ).
      rv_data = zcl_ia_2met=>zif_ia_2_met~get_met_type( lo_arbstelle->get_data( )-zmet ).
      EXIT.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_QUALIFIKATIONEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OBJTY                       TYPE        CR_OBJTY
* | [--->] IV_OBJID                       TYPE        CR_OBJID
* | [<-()] RT_QUALIS                      TYPE        ZIA_2QUALIS_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_qualifikationen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
          lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace.
    DATA: lo_auftraege   TYPE REF TO cl_object_map,
##NEEDED          lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
 ##NEEDED          lo_auftrag     TYPE REF TO zcl_ia_2order.
    DATA: ls_qualis        LIKE LINE OF rt_qualis.
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeuge   TYPE REF TO cl_object_map,
          lo_fahrzeug    TYPE REF TO zcl_ia_2vehicle.
    DATA: lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator,
          lo_sitzplaetze   TYPE REF TO cl_object_map,
          lo_sitzplatz     TYPE REF TO zcl_ia_2seat.

    lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).

      lo_auftraege = lo_arbstelle->get_auftraege(  ).
      lo_auftraege_i ?= lo_auftraege->get_values_iterator( ).

      lo_fahrzeuge = lo_arbstelle->get_fahrzeuge( ).
      lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        lo_sitzplaetze = lo_fahrzeug->get_sitzplaetze( ).
        lo_sitzplaetze_i ?= lo_sitzplaetze->get_values_iterator( ).
        WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
          lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).

          CHECK iv_objid IS INITIAL OR lo_sitzplatz->get_data( )-zobjid = iv_objid.
          CHECK iv_objty IS INITIAL OR  lo_sitzplatz->get_data( )-zobjty = iv_objty.

          ls_qualis-objid =  lo_sitzplatz->get_data( )-zobjid.
          ls_qualis-objty =  lo_sitzplatz->get_data( )-zobjty.

          APPEND ls_qualis TO rt_qualis. CLEAR ls_qualis.

        ENDWHILE.
      ENDWHILE.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->HAS_VERSORGUNG_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DATA                        TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_versorgung_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : HAS_VERSORGUNG_SCHICHT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lo_schicht) = get_versorgung_schicht( ).
    IF lo_schicht IS BOUND.
      rv_data = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->SET_TREMOLA_CALCULATED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TREMOLA_DONE                TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_tremola_calculated.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_TREMOLA_CALCULATED
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_schicht-ztremola_done = iv_tremola_done.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->IS_PLANNED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_planned.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF me->go_arbeitsstellen->size( ) > 0.
      rv_boolean = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_TS_EST
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EST                         TYPE        ZIA_2_ROEHRE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ts_est.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_TS_EST
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    LOOP AT me->get_sp_schicht( ) ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>)
            WHERE ( zintervallart = 'TS' )  AND ( sperrabschnitt = 'W' OR sperrabschnitt = 'E' ).
      IF <ls_sp_schicht> IS ASSIGNED.

        rv_est =  <ls_sp_schicht>-sperrabschnitt.

        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_MET_AS_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DATA                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_met_as_name.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_ktext) = VALUE  char12( ).


    DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( go_arbeitsstellen->get_values_iterator( ) ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).

      CHECK lo_arbstelle->has_met( ).
      lv_ktext = lo_arbstelle->get_kurztext( ).
      rv_data  = lv_ktext(3).
      EXIT.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->ADD_NOTES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BEMERKUNG                   TYPE        ZIA_2_SCHICHT_NOTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_notes.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Add _notes
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ##NEEDED    DATA: ls_note TYPE zia_2shift_notes.


*---------------------------------------------------------------------------------------
* Prüfen, ob bereits Bemerkungen von diesem Benutzer existieren
*---------------------------------------------------------------------------------------
*    SELECT SINGLE * FROM zia_2shift_note INTO ls_note WHERE zschicht EQ me->gs_schicht-zschicht AND uname EQ syst-uname.

*---------------------------------------------------------------------------------------
* UPDATE
*---------------------------------------------------------------------------------------
*    IF sy-subrc EQ 0.
*
*      ls_note-bemerkung = iv_bemerkung.
*      ls_note-aedtm = sy-datum.
*      ls_note-zschicht = me->gs_schicht-zschicht.
*      UPDATE zia_2shift_note FROM ls_note.

*---------------------------------------------------------------------------------------
* INSERT
*---------------------------------------------------------------------------------------
*    ELSE.
*
*      ls_note-bemerkung = iv_bemerkung.
*      ls_note-erstdtm = sy-datum.
*      ls_note-aedtm = sy-datum.
*      ls_note-uname = syst-uname.
*      ls_note-zschicht = me->gs_schicht-zschicht.
*
*      INSERT INTO zia_2shift_note VALUES ls_note.
*
*    ENDIF.


*****************************************************************************************************
** Bemerkungen einlesen
*****************************************************************************************************
*    SELECT * FROM zia_2shift_note INTO TABLE gt_notes WHERE zschicht EQ me->gs_schicht-zschicht.
    DATA: lt_return       TYPE bapiret2_t,
          lt_message_save TYPE bapiret2_t.

    " Get Notification Long Text
    me->gt_notif_longtext = VALUE #( (   objtype = 'QMEL'
                                         text_line = iv_bemerkung ) ).
    " Caoll BAPI to update the long text
    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_ADD'
      EXPORTING
        number     = me->gs_schicht-zschicht
      TABLES
        notfulltxt = me->gt_notif_longtext
        return     = lt_return.

    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      " SAVE Notification
      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number = me->gs_schicht-zschicht
        TABLES
          return = lt_message_save.
    ENDIF.
    " Trasancation Commit
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

*    me->gt_notes = VALUE #( ( bemerkung = iv_bemerkung  ) ).

    " get short text
    DATA lt_longtext TYPE TABLE OF bapi2080_notfulltxte.

    CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
      EXPORTING
        number     = me->gs_schicht-zschicht
      TABLES
        notlongtxt = lt_longtext.

    DATA: lv_str TYPE string.
    LOOP AT lt_longtext ASSIGNING FIELD-SYMBOL(<ls_fs>) .
      lv_str = |{ lv_str }| & | | & |{ <ls_fs>-text_line }{ cl_abap_char_utilities=>newline }|.
    ENDLOOP.

    CLEAR gt_notes.

    IF lv_str IS NOT INITIAL.
      APPEND VALUE #( bemerkung = lv_str
*                     uname     = syst-uname
                     uname     = cl_abap_context_info=>get_user_technical_name( )
                       ) TO gt_notes.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->HAS_ARBEITSSTELLEN_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EIZ                         TYPE        ZIA_2_ID_EST(optional)
* | [--->] IV_SKIP_STRASSE                TYPE        BOOLEAN(optional)
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_arbeitsstellen_in_tunnel.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : HAS_ARBEITSSTELLEN_IN_TUNNEL
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       31.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_boolean = abap_false.

    " Hole alle Arbstellen und liefere X zurück, falls eine AS im Tunnel ist.
    DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( go_arbeitsstellen->get_values_iterator( ) ).

    IF iv_eiz IS INITIAL.
      WHILE lo_arbstelle_i->has_next( ) = abap_true.
        DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).

        IF iv_skip_strasse EQ abap_true.
          CHECK lo_arbstelle->is_pneu( ) EQ abap_false.
        ENDIF.

        IF lo_arbstelle->check_as_is_in_tunnel( ) EQ abap_true.
          rv_boolean = abap_true.
          RETURN.
        ENDIF.
      ENDWHILE.
    ELSE.
      WHILE lo_arbstelle_i->has_next( ) = abap_true.
        lo_arbstelle ?= lo_arbstelle_i->get_next( ).

        IF iv_skip_strasse EQ abap_true.
          CHECK lo_arbstelle->is_pneu( ) EQ abap_false.
        ENDIF.

        IF lo_arbstelle->check_as_is_in_tunnel( ) EQ abap_true AND lo_arbstelle->get_data( )-zid_eiz EQ iv_eiz.
          rv_boolean = abap_true.
          RETURN.
        ENDIF.
      ENDWHILE.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->CREATE_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR(optional)
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN
* | [<---] EO_ARBSTELLEN_ABH              TYPE REF TO CL_OBJECT_MAP
* | [<-()] RO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       16.11.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM

*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    TYPES: BEGIN OF ts_data,
             has_1_cpm TYPE boolean,
             has_l_sc  TYPE boolean,
           END OF ts_data.

    DATA: ls_arbstelle     TYPE zia_2sf_wa,
          lv_id_btg        TYPE zia_2_id_btg,
          lv_max_tff       TYPE i,
          ls_data          TYPE ts_data,
          lo_basis_fzg     TYPE REF TO cl_object_map,
          lo_basis_fzg_i   TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug      TYPE REF TO zcl_ia_2vehicle,
          ls_quali         TYPE zia_2_qualis_s,
          lo_sitzplatz_tff TYPE REF TO zcl_ia_2seat,
          lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator,
          lo_sitzplatz     TYPE REF TO zcl_ia_2seat,
          lv_count         TYPE i VALUE 0.


    IF is_auftrag IS NOT INITIAL.
      DATA(ls_auftrag) = is_auftrag.
    ELSEIF iv_aufnr IS NOT INITIAL.
      SELECT SINGLE * FROM zia_2order INTO @ls_auftrag WHERE aufnr = @iv_aufnr. "#EC CI_ALL_FIELDS_NEEDED
    ELSEIF io_auftrag IS NOT INITIAL.
      ls_auftrag = io_auftrag->get_data( ).
    ENDIF.

    "CREATE A NEW JOB WITH AN INITIAL ASSIGNMENT"
    DATA(lo_auftrag) = COND #( WHEN io_auftrag IS INITIAL
                               THEN NEW zcl_ia_2order( iv_aufnr = ls_auftrag-aufnr )
                               ELSE io_auftrag ).

    lo_auftrag->set_schicht( iv_schicht = CONV zia_2_schicht( me->gs_schicht-zschicht ) ).
*    ls_arbstelle-zid_eiz = ls_auftrag-zid_eiz.
*    ls_arbstelle-zschicht = me->gs_schicht-zschicht.

    me->get_rj_est( ).
    ls_arbstelle = VALUE #( zid_eiz = ls_auftrag-zid_eiz
                            zschicht = me->gs_schicht-zschicht
                            zkmin = lo_auftrag->get_km_by_est( me->get_rj_est( )  )-zkmin
                            zkmax = lo_auftrag->get_km_by_est( me->get_rj_est( )  )-zkmax
                            zid_btg = COND #( WHEN lo_auftrag->is_in_btg( IMPORTING ev_id_btg = lv_id_btg ) EQ abap_true
                                              THEN lv_id_btg  ) ).
*    ls_arbstelle-zkmin = lo_auftrag->get_km_by_est( me->get_rj_est( )  )-zkmin.
*    ls_arbstelle-zkmax = lo_auftrag->get_km_by_est( me->get_rj_est( )  )-zkmax.

    "*******************
    "* NEU
    "***************

****    IF lo_auftrag->is_in_btg( IMPORTING ev_id_btg = lv_id_btg ) EQ abap_true.
****      ls_arbstelle-zid_btg = lv_id_btg.
****    ENDIF.

    DATA(lo_arbstelle) = NEW zcl_ia_2wrkplace( ).
    lo_arbstelle->set_data( is_data = ls_arbstelle ).
    lo_arbstelle->set_schicht( io_schicht = me ).

*********************************
    "HP: HIER KOMMEN DIE SPERRABSCHNITTE REIN
*    AUS DEM AUFTRAG LESEN => NICHT WERTE ERMITTELN => IN DIE ARBEITSSTELLE KOPIEREN

*    DATA: LV_SPERRABSCHNITT TYPE STRING,
*          LT_SPERRABSCHNITT TYPE TABLE OF STRING,
*          LS_SP_SCHICHT     TYPE ZIA_2SP_SCHICHT_T.

***********    DATA(LT_AUFTRAG_SP_INTVART) = LO_AUFTRAG->GET_SP_INTVART( IV_TS_EST = ME->GET_TS_EST( )
***********                                                              IV_RJ_EST = ME->GET_RJ_EST( ) ).


**    LOOP AT LT_AUFTRAG_SP_INTVART ASSIGNING FIELD-SYMBOL(<LS_AUFTRAG_SP_INTVART>).
**
**
**      DATA LT_SPERRABSCHNITT TYPE TABLE OF STRING.
**      SPLIT <LS_AUFTRAG_SP_INTVART>-SPERRABSCHNITT AT ',' INTO TABLE LT_SPERRABSCHNITT.
**
**      " LOOP THROUGH EACH SPERRABSCHNITT VALUE
**      LOOP AT LT_SPERRABSCHNITT INTO DATA(LV_SPERRABSCHNITT).
**
**        " PERFORM READ TABLE FOR EACH SPERRABSCHNITT
**        READ TABLE GT_SP_SCHICHT WITH KEY SPERRABSCHNITT = LV_SPERRABSCHNITT
**                                           ZINTERVALLART = <LS_AUFTRAG_SP_INTVART>-ZINTERVALLART
**                                           INTO DATA(LS_SP_SCHICHT).
**
**        IF SY-SUBRC = 0.
**          " PROCESS THE MATCHING ENTRY
**          LO_ARBSTELLE->ADD_SP( IV_SPERRAS_ID = LS_SP_SCHICHT-SPERRAS_ID
**                                IV_ZUGANGSART = LO_AUFTRAG->GET_DATA( )-ZZZUGANGSART ).
**
**          LO_ARBSTELLE->SET_INITAL_AUSDEHNUNG_SP( IV_SPERRAS_ID = LS_SP_SCHICHT-SPERRAS_ID
**                                                  IO_AUFTRAG = LO_AUFTRAG ).
**        ENDIF.


*      ENDLOOP.

*    ENDLOOP.

*    DATA(LT_AUFTRAG_SP_INTVART) = LO_AUFTRAG->GET_SP_INTVART( IV_TS_EST = ME->GET_TS_EST( )
*                                                               IV_RJ_EST = ME->GET_RJ_EST( ) ).
***************************    LOOP AT LT_AUFTRAG_SP_INTVART ASSIGNING FIELD-SYMBOL(<LS_AUFTRAG_SP_INTVART>).
***************************      READ TABLE GT_SP_SCHICHT WITH KEY SPERRABSCHNITT = <LS_AUFTRAG_SP_INTVART>-SPERRABSCHNITT
***************************                                        ZINTERVALLART  = <LS_AUFTRAG_SP_INTVART>-ZINTERVALLART INTO DATA(LS_SP_SCHICHT).
***************************      IF SYST-SUBRC = 0.
***************************
***************************        LO_ARBSTELLE->ADD_SP( IV_SPERRAS_ID = LS_SP_SCHICHT-SPERRAS_ID
***************************                              IV_ZUGANGSART = LO_AUFTRAG->GET_DATA( )-ZZZUGANGSART ).
***************************        LO_ARBSTELLE->SET_INITAL_AUSDEHNUNG_SP( IV_SPERRAS_ID = LS_SP_SCHICHT-SPERRAS_ID
***************************                                                IO_AUFTRAG = LO_AUFTRAG ).
***************************      ENDIF.
***************************    ENDLOOP.


    get_auftrag_sp_intvar( EXPORTING io_auftrag = lo_auftrag
                           CHANGING co_arbstelle = lo_arbstelle ).

    ls_arbstelle-zarbstl = lo_arbstelle->get_id( ).
    lo_auftrag->set_arbeitsstelle_id( ls_arbstelle-zarbstl ).
    lo_arbstelle->set_data( is_data = ls_arbstelle ).
    lo_arbstelle->set_schicht( io_schicht = me ).

    "CREATE BASE VEHICLE
    "--------FOR SIMPLICITY, I'LL JUST CREATE A VEHICLE AND LEAVE OUT ALL THE RULE-BASED CONTROL FOR NOW--------

    """ GET VEHICLE
    IF zcl_ia_2rules=>get_basis_fahrzeug( EXPORTING io_arbeitsstelle = lo_arbstelle
                                                    iv_ignore_errors = iv_ignore_errors
                                                    io_auftrag = lo_auftrag
                                          IMPORTING eo_fahrzeuge = lo_basis_fzg ) = abap_false.
      IF iv_auto_planning = abap_true.
        RETURN.
      ELSE.
        DATA(lv_has_errors) = abap_true.
      ENDIF.
    ENDIF.

    IF lv_has_errors = abap_false.

      lo_basis_fzg_i ?= lo_basis_fzg->get_values_iterator( ).

      WHILE lo_basis_fzg_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_basis_fzg_i->get_next( ).

******************************************************************************************************************************************************
*********** TFF SETZEN           AKO/CPM
******************************************************************************************************************************************************


*        DATA(LS_DATA-HAS_1_CPM) = ABAP_FALSE.
*        DATA(LV_HAS_1_SC) = ABAP_FALSE.
        ls_data = VALUE #( has_1_cpm = abap_false
                           has_l_sc  =  abap_false ).

        IF lo_fahrzeug->is_basis_fz_pneu( ) = abap_false.  "WAS IST MIT BASISFZG OS
******          lo_sitzplatz_tff = lo_fahrzeug->get_sitzplatz_frei( ).
******
******          IF lo_sitzplatz_tff IS NOT INITIAL AND lo_auftrag->get_data( )-zid_eiz = 10.
******            SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF ls_quali WHERE arbpl = 'ER-TFF' .
******          ELSE.
******            SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF ls_quali WHERE arbpl = 'BIA-TFF' .
******          ENDIF.
*          get_sf_quali( EXPORTING io_order = io_auftrag io_fahrzeug = lo_fahrzeug "commented by Venkat B
          get_sf_quali( EXPORTING io_order = lo_auftrag io_fahrzeug = lo_fahrzeug
                        IMPORTING eo_sitzplatz_tff = lo_sitzplatz_tff es_quali = ls_quali ).
        ENDIF.

        " PRÜFE, OB ES NOCH FREIE TFFS GIBT

        lv_max_tff =  me->get_parameter( )->get_single_quali_param( EXPORTING iv_objid = ls_quali-objid   iv_objty = ls_quali-objty )-kapazitaet.

        IF lines( me->get_qualifikationen( EXPORTING iv_objid = ls_quali-objid    iv_objty = ls_quali-objty ) ) < lv_max_tff.
*              "TFF HINZUFÜGEN
          lo_sitzplatz_tff->set_qualifikation( EXPORTING iv_objid = ls_quali-objid iv_objty = ls_quali-objty ).
*
          IF ls_data-has_1_cpm = abap_false.
*                "FALLS ARBEITSSTELLE IN OS ODER BTG WIRD KEIN CPM GESETZT                              ">003< INS
            IF lo_arbstelle->is_btg( ) = abap_false AND lo_arbstelle->is_in_os_nord( ) = abap_false AND lo_arbstelle->is_in_os_sued( ) = abap_false. ">003< INS
              lo_sitzplatz_tff->set_ako( iv_boolean = abap_true ).
              ls_data-has_1_cpm = abap_true. " AUS PERFORMANCE-GRÜNDEN WIRD NICHT MIT METHODE GET_AKO GESUCHT
            ENDIF.                                                                              ">003< INS
          ENDIF.

          IF ls_data-has_l_sc = abap_false.                                                                                    ">003< INS START
            lo_sitzplatz_tff->set_sc( iv_boolean = abap_true ).
            ls_data-has_l_sc = abap_true. " AUS PERFORMANCE-GRÜNDEN WIRD NICHT MIT METHODE GET_SC GESUCHT
          ENDIF.

*            IF LINES( ME->GET_QUALIFIKATIONEN( EXPORTING IV_OBJID = LS_QUALI-OBJID IV_OBJTY = LS_QUALI-OBJTY ) ) < LV_MAX_TFF.
*              "TFF HINZUFÜGEN
*              LO_SITZPLATZ_TFF->SET_QUALIFIKATION( EXPORTING IV_OBJID = LS_QUALI-OBJID IV_OBJTY = LS_QUALI-OBJTY ).
*
*              IF LS_DATA-HAS_1_CPM = ABAP_FALSE AND LO_ARBSTELLE->IS_BTG( ) = ABAP_FALSE AND LO_ARBSTELLE->IS_IN_OS_NORD( ) = ABAP_FALSE AND LO_ARBSTELLE->IS_IN_OS_SUED( ) = ABAP_FALSE.
*                LO_SITZPLATZ_TFF->SET_AKO( IV_BOOLEAN = ABAP_TRUE ).
*                LS_DATA-HAS_1_CPM = ABAP_TRUE. " AUS PERFORMANCE-GRÜNDEN WIRD NICHT MIT METHODE GET_AKO GESUCHT
*              ENDIF.
*
*              IF LV_HAS_1_SC = ABAP_FALSE.
*                LO_SITZPLATZ_TFF->SET_SC( IV_BOOLEAN = ABAP_TRUE ).
*                LV_HAS_1_SC = ABAP_TRUE. " AUS PERFORMANCE-GRÜNDEN WIRD NICHT MIT METHODE GET_SC GESUCHT
*              ENDIF.
        ENDIF.


********************************************************************************************************************************************
* RESERVIERE SITZPLÄTZE
********************************************************************************************************************************************

        IF lo_arbstelle->is_pneu( ) = abap_false.
          lo_sitzplaetze_i ?= lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
          WHILE lo_sitzplaetze_i->has_next( ) = abap_true." AND SY-INDEX <= ME->GET_PARAMETER( )->GET_DATA( )-RES_PLAETZE.
            lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).

            CHECK lo_sitzplatz->has_quali( ) = abap_false AND lv_count < me->get_parameter( )->get_data( )-res_plaetze.
            lo_sitzplatz->set_reserviert( iv_is_reserviert = abap_true ).
            lv_count = lv_count + 1.
          ENDWHILE.
          CLEAR lv_count.
        ENDIF.

        lo_arbstelle->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
      ENDWHILE.
    ENDIF.

    """"
    TRY .
        IF lo_arbstelle->add_auftrag_o( io_order         = lo_auftrag
                                        iv_first_order   = abap_true
                                        iv_auto_planning  = iv_auto_planning
                                        iv_ignore_errors  = iv_ignore_errors ) = abap_false.
          CLEAR lo_arbstelle.
          RETURN. "EXIT.
        ENDIF.

      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        zcl_ia_2message_mnger=>get_instance( )->add_bapiret_t( lx_fehler->get_bapiret( ) ).
        CLEAR lo_arbstelle.
        RETURN. "EXIT.
    ENDTRY.

    ro_arbeitsstelle = lo_arbstelle.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_ARBST_BY_ID_BTG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_BTG                      TYPE        ZIA_2_ID_BTG
* | [<-()] RO_ARBST                       TYPE REF TO ZCL_IA_2WRKPLACE
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_arbst_by_id_btg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
          lo_arbstelle   TYPE REF TO zcl_ia_2wrkplace,
          lv_id_btg      TYPE zia_2_id_btg.

    lo_arbstelle_i ?= me->go_arbeitsstellen->get_values_iterator( ).

    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      lo_arbstelle ?= lo_arbstelle_i->get_next( ).

      IF lo_arbstelle->is_btg( IMPORTING ev_id_btg = lv_id_btg ) EQ abap_true.
        IF lv_id_btg EQ iv_id_btg.
          ro_arbst = lo_arbstelle.
          RETURN.
        ENDIF.
      ENDIF.

    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->SET_INITAL_AUSDEHNUNG_SP
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
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
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
* | Instance Private Method ZCL_IA_2WORKSHIFT->CHANGE_NOTIFICATION_PRIORITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IV_MARK                        TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD change_notification_priority.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       16.11.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Set Notication Priority
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

  DATA: ls_notif_header_in  TYPE bapi2080_nothdri,  " Input structure for notification header
##NEEDED        ls_notif_header_out TYPE bapi2080_nothdre,  " Output structure for notification header
        ls_notifheader_x    TYPE bapi2080_nothdri_x. " Change indicator for notification header

  DATA: lt_message      TYPE bapiret2_t,         " Table for capturing messages from BAPI calls
        lt_message_save TYPE bapiret2_t.         " Table for messages related to saving the notification

  " Determine notification priority based on the input parameter (iv_mark)
  IF iv_mark IS NOT INITIAL.
    ls_notif_header_in-priority = '0'.  " Set priority to '0' (low priority)
    ls_notifheader_x-priority   = 'X'.  " Mark priority field as changed
  ELSE.
    ls_notif_header_in-priority = '1'.  " Set priority to '1' (high priority)
    ls_notifheader_x-priority   = 'X'.  " Mark priority field as changed
  ENDIF.

  " Call BAPI to modify the notification data (priority field)
  CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
    EXPORTING
      number             = CONV qmnum( iv_shift )  " Convert shift number to QM number format
      notifheader        = ls_notif_header_in    " Input notification header with new priority
      notifheader_x      = ls_notifheader_x      " Change indicator for priority
    IMPORTING
      notifheader_export = ls_notif_header_out   " Output notification header after modification
    TABLES
      return             = lt_message.           " Return table for error messages

  " If no error messages are returned, proceed to save the notification
  IF lt_message IS INITIAL. " If the modification was successful, save the notification
    " Call BAPI to save the notification changes
    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number      = CONV qmnum( iv_shift )     " Pass the notification number
      IMPORTING
        notifheader = ls_notif_header_out        " Exported notification header after saving
      TABLES
        return      = lt_message_save.           " Table for return messages from the save BAPI

    " If the save was successful, commit the transaction
    IF lt_message_save IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.   " Wait for commit to complete before returning
    ENDIF.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->GET_AUFTRAG_SP_INTVAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [<-->] CO_ARBSTELLE                   TYPE REF TO ZCL_IA_2WRKPLACE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_auftrag_sp_intvar.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA: lt_sperrabschnitt TYPE STANDARD TABLE OF string,
          lv_sperrabschnitt TYPE string.

    DATA(lt_auftrag_sp_intvart) = io_auftrag->get_sp_intvart( iv_ts_est = me->get_ts_est( )
                                                             iv_rj_est = me->get_rj_est( ) ).

    LOOP AT lt_auftrag_sp_intvart ASSIGNING FIELD-SYMBOL(<ls_auftrag_sp_intvart>).

      SPLIT <ls_auftrag_sp_intvart>-sperrabschnitt
      AT ','
     INTO TABLE lt_sperrabschnitt.
      LOOP AT lt_sperrabschnitt INTO lv_sperrabschnitt.  "#EC CI_NESTED

*        READ TABLE gt_sp_schicht WITH KEY sperrabschnitt = <ls_auftrag_sp_intvart>-sperrabschnitt
        READ TABLE gt_sp_schicht WITH KEY sperrabschnitt = lv_sperrabschnitt                 ##WARN_OK "#EC CI_STDSEQ
                                          zintervallart  = <ls_auftrag_sp_intvart>-zintervallart INTO DATA(ls_sp_schicht).
        IF syst-subrc = 0.
          mv_mncod = lv_sperrabschnitt.

          co_arbstelle->add_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                                iv_zugangsart = io_auftrag->get_data( )-zzzugangsart ).
          co_arbstelle->set_inital_ausdehnung_sp( iv_sperras_id = ls_sp_schicht-sperras_id
                                                  io_auftrag = io_auftrag ).
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2WORKSHIFT->GET_LV_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [--->] IV_AUTO_PLANNNING              TYPE        BOOLEAN
* | [<---] EV_HAS_ERROR                   TYPE        BOOLEAN
* | [<---] EO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_lv_error.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    ##NEEDED    DATA: lo_fahrzeug TYPE REF TO zcl_ia_2vehicle.


    IF zcl_ia_2rules=>get_basis_fahrzeug( EXPORTING io_arbeitsstelle = io_arbeitsstelle
                                                      iv_ignore_errors = iv_ignore_errors
                                                      io_auftrag       = io_auftrag
                                            IMPORTING eo_fahrzeuge = eo_fahrzeuge ) = abap_false.

      IF iv_auto_plannning = abap_true.
        RETURN.
      ELSE.
        ev_has_error = abap_true.
      ENDIF.
    ENDIF.

*    IF ev_has_error = abap_false.
*
*      lo_basis_fzg_i ?= lo_basis_fzg->get_values_iterator( ).
*
*      WHILE lo_basis_fzg_i->has_next( ) = abap_true.
*        lo_fahrzeug ?= lo_basis_fzg_i->get_next( ).
*
*******************************************************************************************************************************************************
************ TFF setzen           AKO/CPM
*******************************************************************************************************************************************************
*
*
*        DATA(lv_has_1_cpm) = abap_false.
*        DATA(lv_has_1_sc) = abap_false.
*
*        IF lo_fahrzeug->is_basis_fz_pneu( ) = abap_false.  "WAS IST MIT BASISFZG OS
*          lo_sitzplatz_tff = lo_fahrzeug->get_sitzplatz_frei( ).
*          IF lo_sitzplatz_tff IS NOT INITIAL.
*            IF io_auftrag->get_data( )-zid_eiz = 10.
*              SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF ls_quali WHERE arbpl = 'ER-TFF' .
    "            ELSE.
*              SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF ls_quali WHERE arbpl = 'BIA-TFF' .
    "            ENDIF.
*
*            " Prüfe, ob es noch freie TFFs gibt
    "            DATA: lv_max_tff      TYPE i.
    "            lv_max_tff =  me->get_parameter( )->get_single_quali_param( EXPORTING iv_objid = ls_quali-objid   iv_objty = ls_quali-objty )-kapazitaet.
    "           IF lines( me->get_qualifikationen( EXPORTING iv_objid = ls_quali-objid    iv_objty = ls_quali-objty ) ) < lv_max_tff.
*              "TFF hinzufügen
    "              lo_sitzplatz_tff->set_qualifikation( EXPORTING iv_objid = ls_quali-objid iv_objty = ls_quali-objty ).
*              IF lv_has_1_cpm = abap_false.
*                "Falls Arbeitsstelle in OS oder BTG wird kein CPM gesetzt                              ">003< INS
    "                IF io_arbeitsstelle->is_btg( ) = abap_false AND io_arbeitsstelle->is_in_os_nord( ) = abap_false AND io_arbeitsstelle->is_in_os_sued( ) = abap_false. ">003< INS
*                  lo_sitzplatz_tff->set_ako( iv_boolean = abap_true ).
*                  lv_has_1_cpm = abap_true. " aus Performance-Gründen wird nicht mit Methode get_ako gesucht
    "                ENDIF.                                                                              ">003< INS
    "              ENDIF.
    "              IF lv_has_1_sc = abap_false.                                                                                    ">003< INS START
*                lo_sitzplatz_tff->set_sc( iv_boolean = abap_true ).
*                lv_has_1_sc = abap_true. " aus Performance-Gründen wird nicht mit Methode get_sc gesucht
*              ENDIF.                                                                                                          ">003< INS END
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*
*
*
*
*      ENDWHILE.
*    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_WORKAREA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SHIFT                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IV_MARK                        TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workarea.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF iv_shift IS NOT INITIAL.

      ##WARN_OK      SELECT SINGLE zarbstl
              FROM zia_2sf_wa
              INTO @DATA(lv_arbstl)
              WHERE zschicht = @iv_shift.

      IF lv_arbstl IS NOT INITIAL.
        change_notification_priority( iv_shift = iv_shift iv_mark = iv_mark ).
      ENDIF.
    ENDIF.





  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->START_AUTO_PLANNING
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD start_auto_planning.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       10.05.2025     tcs / sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       23.09.2026     TCS / Venkateswarlu Batta
*         added the PL1 user status for the orders
*----------------------------------------------------------------------*

   DATA: lv_return         TYPE boolean,
         lo_arbstelle_i    TYPE REF TO cl_object_collection_iterator,
         lo_arbstelle_tmp  TYPE REF TO zcl_ia_2wrkplace,
         lo_arbstelle      TYPE REF TO zcl_ia_2wrkplace,
##NEEDED         lo_arbstellen_abh TYPE REF TO cl_object_map.

*-----------------------------------------------------------------------------------------------------------
* Info in Appl. Log schreiben
*-----------------------------------------------------------------------------------------------------------
*   DATA(lo_log) = zcl_ia_2log=>get_instance( ).
*   lo_log->
   zcl_ia_2log=>get_instance( )->add_info( EXPORTING iv_text       = |{ 'Schichtplanung wird gestartet fuer:' } { gs_schicht-zschicht } { 'Datum:' } { gs_schicht-start_datum } Perimerter: { iv_perimeter }|
                               iv_sub_object = zcl_ia_2log=>mc_sub_object_planung ).

**********************************************************************************************************
* Vorbereitungen
**********************************************************************************************************
*    " Priorisiere alle unverplanten Aufträge neu
   zcl_ia_2order=>priorisiere_auftraege( iv_perimeter = iv_perimeter ).
*
***********************************************************************************************************
** DYNAMISCHE PLANUNG
***********************************************************************************************************
*    " Plane die einzelnen Tunnelabschnitte
   DO 2 TIMES.

     IF sy-index = 1.
       " Ermittle, wie viele neue Arbstellen gebildet werden müssen
       DATA(lv_anz_neue_arbstellen) = me->go_parameter->get_data( )-anz_arbstellen_nord.
       DATA(lv_id_eiz) = 10.
       IF iv_perimeter = 'CBT'. sy-index = 2.  lv_id_eiz = 20. ENDIF.
     ELSE.
       " Ermittle, wie viele neue Arbstellen gebildet werden müssen
       lv_anz_neue_arbstellen = me->go_parameter->get_data( )-anz_arbstellen_sued.
       lv_id_eiz = 20.
     ENDIF.

     "Range aller Sperrabschnitte            "Hat die Schicht bereits ein EST?
*     ##NEEDED     DATA(lt_ra_est) = me->get_ra_est( iv_auto_planning = abap_true ).
     DATA: lt_orders TYPE TABLE OF zia_2order.

     "Hole passende Aufträge
     SELECT auftr~*
       FROM viqmel AS s
                INNER JOIN zia_2order AS auftr ON s~qmcod = auftr~zzperi
*                                                AND s~aufnr = auftr~aufnr
                                             AND (   s~strmn BETWEEN auftr~gstrp AND auftr~gltrp
                                                  OR s~ltrmn BETWEEN auftr~gstrp AND auftr~gltrp )
              INNER JOIN eaml_d_lfe_data AS sp ON sp~tabkey = auftr~aufnr
                                                "AND ( sp~sperrabschnitt = 'E' OR sp~sperrabschnitt = 'X' )
       WHERE s~qmnum = @me->gs_schicht-zschicht
         AND ( auftr~zstdkz <> 'G' AND auftr~zstdkz <> 'O' )
         AND auftr~zzzugangsart = '1'
         AND ( auftr~zid_eiz = @lv_id_eiz OR auftr~zid_eiz = 0 )
         AND auftr~zzperi = @iv_perimeter
         AND auftr~zschicht = 0
         AND auftr~zarbstl = 0
         AND auftr~zintervall <> 'TS'
         AND auftr~zintervall <> 'LI'
       ORDER BY zpprio ASCENDING
       INTO TABLE @lt_orders.


***********************************************************************************************************
** Arbeitsstellen anlegen
***********************************************************************************************************
*      " ACHTUNG, stabile Arbstellen müssen noch abgezogen werden
     DO lv_anz_neue_arbstellen TIMES.
       " Setze Arbeitsstellennummer
       ##NEEDED       DATA(lv_arbstl) = zcl_ia_2utilities=>get_next_id( ).
*
       LOOP AT lt_orders ASSIGNING FIELD-SYMBOL(<ls_order>). "INTO ls_first_order.
         CLEAR lv_return.
         DATA(lv_sp_not_found) = abap_false.
         DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = <ls_order>-aufnr ).
*
*
         DATA(lt_sp_schicht) =  me->get_sp_schicht( ).
         DELETE lt_sp_schicht WHERE zintervallart = 'TS'. "#EC CI_STDSEQ
         LOOP AT lo_auftrag->get_sp( iv_rj_est = me->get_rj_est( ) ) ASSIGNING FIELD-SYMBOL(<ls_sp>). "#EC CI_NESTED
           READ TABLE lt_sp_schicht WITH KEY sperrabschnitt = <ls_sp>-sperrabschnitt TRANSPORTING NO FIELDS. "#EC CI_STDSEQ
           IF syst-subrc NE 0. lv_sp_not_found = abap_true. EXIT. ENDIF.
         ENDLOOP.
*
         IF lv_sp_not_found = abap_true. CONTINUE. ENDIF.


         " Prüfe, ob Auftrag einer bestehenden AS hizugefügt werden könnte -> Dann Auftrag überspringen
         lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
         WHILE lo_arbstelle_i->has_next( ) = abap_true.
           lo_arbstelle_tmp ?= lo_arbstelle_i->get_next( ).

           DATA(lt_auftrag_sa) = lo_auftrag->get_signalabschnitte( iv_est = me->get_rj_est( ) ).
           lo_arbstelle_tmp->get_sp_details_wd( IMPORTING et_sp_ehb = DATA(lt_arbst_sa) ).

           LOOP AT lt_auftrag_sa ASSIGNING FIELD-SYMBOL(<ls_auftrag_sa>).
             READ TABLE lt_arbst_sa WITH KEY zsa = <ls_auftrag_sa>-zsa TRANSPORTING NO FIELDS. "#EC CI_STDSEQ
             IF syst-subrc = 0.
               lv_return = abap_true.
               CONTINUE.
             ENDIF.
           ENDLOOP.
         ENDWHILE.

         CHECK lv_return = abap_false.

         lo_arbstelle = me->create_arbeitsstelle( EXPORTING is_auftrag = <ls_order>
                                                            iv_ignore_errors =  abap_false
                                                            iv_auto_planning =  abap_true
                                                 IMPORTING  eo_arbstellen_abh = lo_arbstellen_abh ).
*
         CHECK lo_arbstelle IS NOT INITIAL.

         me->add_arbeitsstelle( io_arbstelle = lo_arbstelle ).
****
         me->save( ).
*          "Der eingeplante Auftrag ist nicht mehr _frei_
         DELETE TABLE lt_orders FROM <ls_order>.         "#EC CI_STDSEQ
         EXIT.
       ENDLOOP.
     ENDDO."Arbeitsstellen
   ENDDO."Tunnelabschnitte

****************************************************************************************************************
******* Fülle Arbeitsstellen mit Aufträgen
****************************************************************************************************************
   lo_arbstelle_i ?= go_arbeitsstellen->get_values_iterator( ).
   WHILE lo_arbstelle_i->has_next( ) = abap_true.
     lo_arbstelle_tmp ?= lo_arbstelle_i->get_next( ).
     lo_arbstelle_tmp->fuelle_arbeitsstelle( iv_max_auslastung = me->go_parameter->get_data( )-auslastung_1 ).
     me->save( ).
     "Begin of >001<
     LOOP AT lo_arbstelle_tmp->get_auftraege( )->map ASSIGNING FIELD-SYMBOL(<ls_map>).
       change_userstatus_by_prio(
       iv_qmnum = lo_arbstelle_tmp->gs_arbeitsstelle-zschicht                   " Notification Number
       iv_order = CAST zcl_ia_2order( <ls_map>-value )->get_data( )-aufnr
       ).
     ENDLOOP.
     "End of >001<

   ENDWHILE.


 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_PLANUNGSINTERVALL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_PLANUNGSINTERVALL           TYPE        ZIA_2_PLANNING_INTERVAL_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED  METHOD get_planungsintervall.
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
*    DATA: lv_zeitgrenze TYPE uzeit.
*
*    SELECT SINGLE pvalue FROM zse_2_params_dep INTO @DATA(lv_pvalue) WHERE applid = 'GBT' AND pname = 'LOG_GBT_ECKENDZEIT'.
*
*    REPLACE ALL OCCURRENCES OF ':' IN lv_pvalue WITH ''.
*    lv_zeitgrenze = lv_pvalue.
*
*    IF me->gs_schicht-start_zeit <= lv_zeitgrenze.
*      rv_planungsintervall-gstrp = me->gs_schicht-start_datum - 1.
*      rv_planungsintervall-gltrp = me->gs_schicht-start_datum.
*    ELSE.
*      rv_planungsintervall-gstrp = me->gs_schicht-start_datum.
*      rv_planungsintervall-gltrp = me->gs_schicht-start_datum + 1.
*    ENDIF.
*
*    rv_planungsintervall-gsuzp = lv_zeitgrenze.
*    rv_planungsintervall-gluzp = lv_zeitgrenze.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_RA_EST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUTO_PLANNING               TYPE        BOOLEAN
* | [<-()] RT_RANGE                       TYPE        ZIA_2RANGE_STRING_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ra_est.
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
    DATA: ls_range    LIKE LINE OF rt_range.

    ls_range-sign = 'I'.
    ls_range-option = 'EQ'.
    APPEND ls_range TO rt_range.
    ls_range-low = 'W'.
    APPEND ls_range TO rt_range.
    ls_range-low = 'E'.
    APPEND ls_range TO rt_range.

*--> Begin Insert >001<
    ls_range-low = mc_sperrabs-e1.
    APPEND ls_range TO rt_range.

    ls_range-low = mc_sperrabs-e2.
    APPEND ls_range TO rt_range.

    ls_range-low = mc_sperrabs-e3.
    APPEND ls_range TO rt_range.

    ls_range-low = mc_sperrabs-w1.
    APPEND ls_range TO rt_range.

    ls_range-low = mc_sperrabs-w2.
    APPEND ls_range TO rt_range.

    ls_range-low = mc_sperrabs-w3.
    APPEND ls_range TO rt_range.

    IF iv_auto_planning EQ abap_false.
      "---offene Strecke
      ls_range-low = 'N5'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'N6'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'N7'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'N8'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'S6'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'S7'.
      APPEND ls_range TO rt_range.
      ls_range-low = 'S8'.
      APPEND ls_range TO rt_range.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->CHANGE_SINGLE_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OBJNR                       TYPE        JSTO-OBJNR
* | [--->] IV_TXT04                       TYPE        TJ02T-TXT04
* | [--->] IV_SET_INACTIVE                TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_single_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       12.03.2026        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* activate and deactivate user status
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*

    DATA lv_estat TYPE jest-stat.

    " Convert TXT04 -> technical ESTAT
    CALL FUNCTION 'STATUS_TEXT_CONVERSION'
      EXPORTING
        language      = sy-langu
        mode          = 'E'      " TXT04 -> ESTAT
        objnr         = iv_objnr
        txt04         = iv_txt04
      IMPORTING
        status_number = lv_estat
      EXCEPTIONS
        not_found     = 2
        OTHERS        = 5.
    " activate & deactivate the user status
    IF sy-subrc = 0 AND lv_estat IS NOT INITIAL.
      ##UNHANDLED_FUNC_EXCEPTION_OK
      CALL FUNCTION 'STATUS_CHANGE_EXTERN'
        EXPORTING
          objnr       = iv_objnr
          user_status = lv_estat
          set_inact   = iv_set_inactive.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->CHANGE_USERSTATUS_BY_PRIO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_QMNUM                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IV_ORDER                       TYPE        AUFNR
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD change_userstatus_by_prio.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: EXECUTE MAIN LOGIC
*----------------------------------------------------------------------*
* >000<   7.50       11.03.2026        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Change the user status based on the notification priority
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  "--------------------------
  " Local data
  "--------------------------
  DATA: lv_prio         TYPE priok,
        lv_objnr        TYPE jsto-objnr,
        lv_target_txt04 TYPE tj02t-txt04,   " target TXT04 (PL1/PL2)
        lv_user_line    TYPE bsvx-sttxt.    " active user statuses (plain text)

  " Family of PL* statuses you control
  DATA lt_pl_txt04 TYPE TABLE OF tj02t-txt04.
  lt_pl_txt04 = VALUE #( ( mc_user_status_pl1 )
                         ( mc_user_status_pl2 )
                         ( mc_user_status_pl3 ) ).
  "--------------------------
  " Guards
  "--------------------------
  CHECK iv_qmnum IS NOT INITIAL.
  CHECK iv_order IS NOT INITIAL.

  "--------------------------
  "  Read priority from QMEL
  "--------------------------
  SELECT SINGLE priok
    INTO @lv_prio
    FROM qmel
    WHERE qmnum = @iv_qmnum.
  CHECK lv_prio IS NOT INITIAL.

  "--------------------------
  "  Decide target TXT04 (PL1 if prio=1, PL2 if prio=2)
  "--------------------------
  lv_target_txt04 = COND #(
    WHEN lv_prio = mc_prio_1 THEN mc_user_status_pl1
    WHEN lv_prio = mc_prio_2 THEN mc_user_status_pl2
    ELSE '' ).

  CHECK lv_target_txt04 IS NOT INITIAL.

  "--------------------------
  "  Resolve OBJNR from order (AUFK)
  "--------------------------
  SELECT SINGLE objnr
    INTO @lv_objnr
    FROM aufkv
    WHERE aufnr = @iv_order.
  CHECK lv_objnr IS NOT INITIAL.

  "--------------------------
  "  Read active USER statuses on the order
  "--------------------------
  ##UNHANDLED_FUNC_EXCEPTION_OK
  CALL FUNCTION 'STATUS_TEXT_EDIT'
    EXPORTING
      objnr         = lv_objnr
      spras         = sy-langu
      only_active   = 'X'
      flg_user_stat = 'X'
    IMPORTING
      user_line     = lv_user_line.

  " Parse the active user-line into a table (e.g., 'PL1 REAL' -> [ 'PL1','REAL' ])
  DATA lt_active_user TYPE TABLE OF tj02t-txt04.
  SPLIT lv_user_line AT space INTO TABLE lt_active_user.
  DELETE lt_active_user WHERE table_line IS INITIAL.
  "--------------------------
  "  Enforce exclusivity: deactivate any other PL* that is active
  "     and not equal to the chosen target (e.g., if target=PL1, deactivate PL2/PL3)
  "--------------------------

  LOOP AT lt_pl_txt04 INTO DATA(lv_pl_txt04).
    IF lv_pl_txt04 = lv_target_txt04.
      CONTINUE.         " keep the target
    ENDIF.
    IF line_exists( lt_active_user[ table_line = lv_pl_txt04 ] ).
      me->change_single_status(
        iv_objnr        = lv_objnr
        iv_txt04        = lv_pl_txt04
        iv_set_inactive = abap_true ).

    ENDIF.
  ENDLOOP.

  "--------------------------
  " Activate the chosen target (PL1 or PL2)
  "--------------------------
  " activate target
  me->change_single_status(
    iv_objnr        = lv_objnr
    iv_txt04        = lv_target_txt04
    iv_set_inactive = abap_false ).
  "--------------------------
  "  Commit
  "--------------------------
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->DEACTIVATE_USER_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_QMNUM                       TYPE        ZIA_2_WORKSHIFT
* | [--->] IV_ORDER                       TYPE        AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD deactivate_user_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       19.03.2025        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Deactivating the user status - PL1 and PL2
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    "--------------------------
    " Local data
    "--------------------------
    DATA: lv_prio          TYPE priok,
          lv_objnr         TYPE jsto-objnr,
 ##NEEDED          lv_status_number TYPE jest-stat,
          lv_user_line     TYPE bsvx-sttxt.    " active user statuses (plain text)


    DATA lt_pl_txt04 TYPE TABLE OF tj02t-txt04.
    lt_pl_txt04 = VALUE #( ( mc_user_status_pl1 )
                           ( mc_user_status_pl2 )
                           ( mc_user_status_pl3 ) ).

    CHECK iv_qmnum IS NOT INITIAL.
    CHECK iv_order IS NOT INITIAL.


    "--------------------------
    "  Read priority from QMEL
    "--------------------------
    SELECT SINGLE priok
      INTO @lv_prio
      FROM qmel
      WHERE qmnum = @iv_qmnum.



    CHECK lv_prio IS NOT INITIAL.

    "--------------------------
    "  Resolve OBJNR from order (AUFK)
    "--------------------------
    SELECT SINGLE objnr
      INTO @lv_objnr
      FROM aufkv
      WHERE aufnr = @iv_order.
    CHECK lv_objnr IS NOT INITIAL.

    "--------------------------
    "  Read active USER statuses on the order
    "--------------------------
    ##UNHANDLED_FUNC_EXCEPTION_OK
    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
        objnr         = lv_objnr
        spras         = sy-langu
        only_active   = 'X'
        flg_user_stat = 'X'
      IMPORTING
        user_line     = lv_user_line.

    " Parse the active user-line into a table (e.g., 'PL1 REAL' -> [ 'PL1','REAL' ])
    DATA lt_active_user TYPE TABLE OF tj02t-txt04.
    SPLIT lv_user_line AT space INTO TABLE lt_active_user.
    DELETE lt_active_user WHERE table_line IS INITIAL.

    LOOP AT lt_pl_txt04 INTO DATA(lv_pl_txt04).
      IF line_exists( lt_active_user[ table_line = lv_pl_txt04 ] ).
        me->change_single_status(
          iv_objnr        = lv_objnr
          iv_txt04        = lv_pl_txt04
          iv_set_inactive = abap_true ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_MOST_INNER_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [<---] EO_ARBSTELLE                   TYPE REF TO ZCL_IA_2WRKPLACE
* | [<---] EV_KM_MAX                      TYPE        ZIA_2_KM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_most_inner_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :GET_MOST_INNER_ARBEITSSTELLE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       09.03.2025     tcs / Sivasurya Kucherla
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_sperrabschnitt) = CONV zia_2_spabs( get_rj_est( ) ).

    DATA(li_arbstelle_i) = go_arbeitsstellen->get_values_iterator( ).

    WHILE li_arbstelle_i->has_next( ).
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbstelle_i->get_next( ) ).

      DATA(lt_spabs) = lo_arbstelle->get_sperrabschnitte_with_id( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ).
      READ TABLE lt_spabs ASSIGNING FIELD-SYMBOL(<ls_spabs>) WITH KEY sperrabschnitt = lv_sperrabschnitt.
      CHECK sy-subrc = 0.

      DATA(li_sp_km_i) = lo_arbstelle->get_sp_kilometer( )->get_values_iterator( ).

      WHILE li_sp_km_i->has_next( ).
        DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( li_sp_km_i->get_next( ) ).
        DATA(ls_sp_km) = lo_sp_km->get_data( ).
        CHECK ls_sp_km-sperras_id = <ls_spabs>-sperras_id.

        ev_km_max = ls_sp_km-zkmax.
        eo_arbstelle = lo_arbstelle.

      ENDWHILE.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->GET_SF_QUALI
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ORDER                       TYPE REF TO ZCL_IA_2ORDER
* | [--->] IO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* | [<---] EO_SITZPLATZ_TFF               TYPE REF TO ZCL_IA_2SEAT
* | [<---] ES_QUALI                       TYPE        ZIA_2_QUALIS_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sf_quali.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION: CONSTRUCTOR
*----------------------------------------------------------------------*
* >000<   7.50       26.02.2026        TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM

*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA lv_value TYPE value.
    eo_sitzplatz_tff = io_fahrzeug->get_sitzplatz_frei( ).


    IF eo_sitzplatz_tff IS NOT INITIAL AND io_order->get_data( )-zid_eiz = 10.

      ##WARN_OK     SELECT SINGLE value
            FROM zse_2_params_dep
            INTO lv_value
            WHERE name = 'WC_TFF_ER'.
      ##WARN_OK      SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF @es_quali WHERE arbpl = @lv_value .
    ELSE.
      ##WARN_OK      SELECT SINGLE value
            FROM zse_2_params_dep
            INTO lv_value
            WHERE name = 'WC_TFF_BA'.
      ##WARN_OK   SELECT SINGLE * FROM zia_2sf_quali INTO CORRESPONDING FIELDS OF @es_quali WHERE arbpl = @lv_value .
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKSHIFT->HAS_SP_TS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD has_sp_ts.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : HAS_SP_TS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

  READ TABLE me->gt_sp_schicht WITH KEY zintervallart = 'TS' TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
  IF syst-subrc = 0.
    rv_boolean = abap_true.
  ELSE.
    rv_boolean = abap_false.
  ENDIF.
ENDMETHOD.
ENDCLASS.