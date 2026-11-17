class ZCL_IA_2TREMOLA definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ts_trassen_fpl,
        zugnummer         TYPE zia_cds_c_2tracks-zugnummer,
        zest              TYPE zia_cds_c_2tracks-sperrabschnitt,
        zab               TYPE zia_cds_c_2tracks-zab,
        zan               TYPE zia_cds_c_2tracks-zan,
        zeiz              TYPE zia_cds_c_2tracks-zeiz,
        zug               TYPE zia_cds_c_2tracks-zug,
        betriebspunkt     TYPE zia_cds_c_2tracks-betriebspunkt,
        startsignal       TYPE zia_cds_c_2tracks-startsignal,
        gleis             TYPE zia_cds_c_2tracks-gleis,
        zeit_am_start_tag TYPE zia_cds_c_2tracks-zeit_am_start_tag,
        einfahrt          TYPE zia_cds_c_2tracks-einfahrt,
        ausfahrt          TYPE zia_cds_c_2tracks-ausfahrt,
        reihenfolge       TYPE zia_cds_c_2tracks-reihenfolge,
        richtung          TYPE zia_cds_c_2tracks-richtung,
        tremola_start     TYPE zia_cds_c_2tracks-tremola_start,
        trasse_aktiv      TYPE zia_cds_c_2tracks-trasse_aktiv,
        zzperi            TYPE zia_cds_c_2tracks-zzperi,
        gueltig_von       TYPE zia_cds_c_2tracks-gueltig_von,
        gueltig_bis       TYPE zia_cds_c_2tracks-gueltig_bis,
        data_origin       TYPE zia_cds_c_2tracks-data_origin,
      END   OF ts_trassen_fpl .
  types:
    tt_map_as_fz  TYPE STANDARD TABLE OF zia_2sf_wa_veh .
  types:
    tt_trassen_fpl TYPE STANDARD TABLE OF ts_trassen_fpl WITH EMPTY KEY .
  types:
    tt_data TYPE STANDARD TABLE OF zia_2sf_ez_form .
  types:
    tt_Train_route TYPE STANDARD TABLE OF zia_2_xi_cotrain_route_type1 .
  types:
    tt_2sf_ez_form  TYPE STANDARD TABLE OF zia_2sf_ez_form WITH EMPTY KEY .

  constants MC_TRUE type STRING value 'true' ##NO_TEXT.
  constants MC_DEPOT_BI type STRING value 'BI' ##NO_TEXT.
  constants MC_DEPOT_ER type STRING value 'ER' ##NO_TEXT.
  constants MC_EIZ_GBTN type ZIA_2_EIZ value 'GBTN' ##NO_TEXT.
  constants MC_EIZ_GBTS type ZIA_2_EIZ value 'GBTS' ##NO_TEXT.
  constants MC_EIZ_10 type ZIA_2_ID_EIZ value '10' ##NO_TEXT.
  constants MC_EIZ_20 type ZIA_2_ID_EIZ value '20' ##NO_TEXT.
  constants MC_MIME_PFAD_ORIENTIERUNG_L type ZIA_2_FZTYP_MIME_PFAD value '/SAP/BC/fp/graphics/PUBLIC/GRAPHICS/REAL/Dreieck_links.jpg' ##NO_TEXT.
  constants MC_MIME_PFAD_ORIENTIERUNG_R type ZIA_2_FZTYP_MIME_PFAD value '/SAP/BC/fp/graphics/PUBLIC/GRAPHICS/REAL/Dreieck_rechts.jpg' ##NO_TEXT.
  constants MC_TIMEZONE_TREMOLA type TIMEZONE value 'CET' ##NO_TEXT.
  constants MC_TIMEZONE_ERGEBNIS type TIMEZONE value 'UTC+2' ##NO_TEXT.
  constants MC_DEPARTURE type STRING value 'Departure' ##NO_TEXT.
  constants MC_ARRIVAL type STRING value 'Arrival' ##NO_TEXT.
  constants MC_TRIP_TYPE_ARR type STRING value 'Arr' ##NO_TEXT.
  constants MC_PROCEDURE_RUNNING type STRING value 'Running' ##NO_TEXT.
  constants MC_TRIP_TYPE_DEP type STRING value 'Dep' ##NO_TEXT.
  constants MC_TRIP_TYPE_CONTROL type STRING value 'ControlTrip' ##NO_TEXT.
  constants MC_TRIP_TYPE_RANGIER type STRING value 'Running_SH' ##NO_TEXT.
  constants MC_ETCS_SH type STRING value 'SH' ##NO_TEXT.
  constants MC_ETC_MODE_NL type STRING value 'NL' ##NO_TEXT.
  constants MC_MIN_TIME type STRING value '0.00000001' ##NO_TEXT.
  data GT_EZ_FORM type ZIA_2EZ_FORM_T .
  data GS_OUTPUT type ZXI_1P2_CALCULATE_TIMETABLE_R1 .
  data GS_INPUT type ZIA_2_XI_COCALCULATE_TT_RESP .
  constants MC_DATA_ORIGINE type ZIA_2_DATA_ORIGIN value 'T' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT
      !IV_USE_EZ_DB type ABAP_BOOL default ABAP_TRUE
    raising
      ZCX_IA_2FAILURE .
  methods GET_PARAMETER
    returning
      value(RS_PARAMETER) type ZXI_1TREMOLA_INPUT_TYPE_PARAME .
  methods GET_EZ_FORM
    exporting
      !ET_EZ_FORM type ZIA_2_EZ_FORM_WD_T
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods GET_FAHRPLAN_BY_AS_ID
    importing
      !IV_ID_AS type ZIA_2_ID_AS
    returning
      value(RT_FAHRPLAN) type ZIA_2TREMOLA_FAHRPLAN_T .
  methods GET_FORMATION_BY_AS_ID
    importing
      !IV_ID_AS type ZIA_2_ID_AS
      !IV_DB type BOOLEAN optional
    returning
      value(RT_FORMATION) type ZIA_2TREMOLA_FORMATION_T .
  methods GET_TRAINS_AT_EIZ1
    importing
      !IT_ZIA_2MAP_AS_FZ type TT_MAP_AS_FZ
    exporting
      !ET_TREMOLA_VEHICLE type ZIA_2TREMOLA_FORMATION_T
      !EV_REIHUNG_COUNT type I .
  methods GET_TRAINS_AT_EIZ
    exporting
      !ET_TRAINS type ZIA_2TRAIN_AT_EIZ_T .
  methods GET_AS_DETAILS_BY_AS_ID
    importing
      !IV_ID_AS type ZIA_2_ID_AS
    exporting
      !EV_START_DATUM type DATS
      !EV_END_DATUM type DATS
      !EV_START_ZEIT type TIMS
      !EV_END_ZEIT type TIMS .
  methods GET_TIMEZONE
    importing
      !IV_SCHICHT_DATE type DATS
    exporting
      !EV_TIMEZONE_TREMOLA type TIMEZONE
      !EV_TIMEZONE_ERGEBNIS type TIMEZONE .
  class-methods GET_INSTANCE
    importing
      !IV_SCHICHT type ZIA_2_WORKSHIFT optional
      value(IO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT optional
      value(IV_NEW) type ABAP_BOOL default ABAP_FALSE
      !IV_USE_EZ_DB type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_INSTANCE) type ref to ZCL_IA_2TREMOLA .
  methods INVALIDATE_RESPONSE .
  methods CALCULATE_AND_SAVE
    importing
      value(IV_TESTMODE) type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_MESSAGES) type BAPIRET2_T .
  methods GET_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT .
  methods HAS_VALID_RESPONSE
    returning
      value(RV_VALUE) type ABAP_BOOL .
  methods INVOKE_WEBSERVICE
    importing
      !IV_UPDATE_DB type ABAP_BOOL default ABAP_TRUE .
  methods GET_FAHRPLAN_IMAGE
    exporting
      !EV_IMAGE type STRING
    returning
      value(RV_IMAGE) type XSTRING .
  methods GET_LOG
    exporting
      !EV_TECHNICAL_LOG type STRING
      !EV_FUNCTIONAL_LOG type STRING
      !EV_CALC_SUCCESS type BOOLEAN .
  methods GET_TIME_INFO
    importing
      !IS_TRASSEN_FPL_EIZ type TS_TRASSEN_FPL
      !IV_TEMP_DATE type DATS
      !IV_TIMEZONE_TREMOLA type TIMEZONE
    exporting
      !EV_TIME_EIZ type TIMESTAMP
      !EV_EIZ_TIME_PORTAL type TIMESTAMP
      !EV_TUNNEL_TIME_PORTAL type TIMESTAMP .
  PROTECTED SECTION.
private section.

*  data MO_SCHICHT type ref to ZCL_IA_2SCHICHT .
  data GS_PARAMETER type ZXI_1TREMOLA_INPUT_TYPE_PARAME .
  data GS_REQUEST type ZXI_1P2_CALCULATE_TIMETABLE_R1  ##NEEDED.
  data GS_RESPONSE type ZXI_1P2_CALCULATE_TIMETABLE_RE .
  data GO_SCHICHT type ref to ZCL_IA_2WORKSHIFT .
  class-data MO_SINGLETON type ref to ZCL_IA_2TREMOLA .
  data GO_TREMOLA_SERVICE type ref to ZXI_1CO_OS_TREMOLA_TUNNEL_MAIN .
  data GS_CATENARY_SECTIONS type ZXI_1TREMOLA_INPUT_TYPE_CATENA .
  data GS_TRACK_SECTIONS type ZXI_1TREMOLA_INPUT_TYPE_TRACK .
  data GS_TRAIN_ROUTES type ZXI_1TRAIN_ROUTES_TYPE .
  data GS_SHIFT type ZXI_1TREMOLA_INPUT_TYPE_SHIFT .

  methods READ_FUNCLOC_ATTRIUTES   ##RELAX
    importing
      !IV_TPLNR type TPLNR
    returning
      value(RS_VEHILCE_ATTR) type ZIA_2_FUNCLOC_S .
  methods READ_TRACK_SECTIONS .
  methods READ_DATA_FROM_DB .
  methods READ_PARAMETER .
  methods READ_CATENARY_SECTIONS .
  methods READ_TRAIN_ROUTES .
  methods READ_SHIFT
    importing
      !IV_DREHBUCH type BOOLEAN optional   ##NEEDED
    raising
      ZCX_IA_2FAILURE .
  methods READ_FAHRPLAN_COMPLETION   ##RELAX
    importing
      !IV_TRAIN_NUMBER type ZIA_2_TRAIN_NUMB
      !IV_TRIP_TYPE type STRING
      !IV_EIZ type ZIA_2_ID_EIZ
      !IV_AFS type BOOLEAN
    returning
      value(RT_FAHRPLAN) type ZIA_2TREMOLA_FAHRPLAN_T .
  methods READ_PARAMETER_SHIFT  ##RELAX.
  class-methods GET_CURRENT_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2WORKSHIFT .
  methods SELECT_TRASSEN_FPL
    importing
      !IV_ZUGNUMMER type ZIA_2TRACKS-ZUGNUMMER optional
      !IV_REIHENFOLGE type ZIA_2TRACKS-REIHENFOLGE optional
      !IV_RICHTUNG type ZIA_2TRACKS-RICHTUNG optional
      !IV_START_SIGNAL type ABAP_BOOL optional
      !IV_TREMOLA_START type ABAP_BOOL optional
    returning
      value(RT_TRASSEN) type TT_TRASSEN_FPL .
  methods LOAD_API_RESPONSE_DATA
    exporting
      !ET_PROCESS type ZXI_1PROCESS_TYPE_TAB
      !ET_FORMATION type ZXI_1FORMATION_TYPE_TAB
      !ET_PART_FORMATION type ZXI_1PART_FORMATION_TYPE_TAB
      !ET_JOB_SITES type ZXI_1JOB_SITE_OUTPUT_TYPE_TAB .
  methods ENRICH_TRASSEN_FPL
    changing
      !CT_TRASSEN_FPL type TT_TRASSEN_FPL .
  methods BUILD_EZ_ENTRIES_FROM_PROC
    importing
      !IT_PROCESSES type ZXI_1PROCESS_TYPE_TAB
      !IT_FORMATIONS type ZXI_1FORMATION_TYPE_TAB optional
      !IT_JOB_SITES type ZXI_1JOB_SITE_OUTPUT_TYPE_TAB optional
      !IT_TRASSEN_FPL type ZCL_IA_2TREMOLA=>TT_TRASSEN_FPL optional
      !IT_EZ_FORM_MA type TT_2SF_EZ_FORM optional
      !IS_SCHICHT type ZIA_2WRKSHIFTS_S optional
    changing
      !CT_EZ_FORM type ZIA_2_EZ_FORM_WD_T .
  methods TRANSFORM_AND_UPDATE_DB .
  methods ADJUST_KM_BY_SPABSCHNITT
    importing
      !IV_SPERRABSCHNITT type ZIA_2_ROEHRE
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
    changing
      !CV_KM_MIN type ZIA_2_KM_VON
      !CV_KM_MAX type ZIA_2_KM_BIS .
  methods INITIALIZE_SHIFT_DATA
    importing
      !IS_SCHICHT type ZIA_2WRKSHIFTS_S
      !IV_SPERRABSCHNITT type ZIA_2_ROEHRE .
  methods BUILD_NEEDED_VEHICLE_TYPES
    importing
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
    returning
      value(RT_NEEDED_VEHICLE_TYPE) type ZXI_1NEEDED_VEHICLE_TYPE_TAB .
  methods BUILD_JOB_SITE
    importing
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_SCHICHT type ZIA_2WRKSHIFTS_S
      !IT_NEEDED_VEHICLE_TYPE type ZXI_1NEEDED_VEHICLE_TYPE_TAB
      !IT_ZIO_EZ_FORM type TT_2SF_EZ_FORM
    returning
      value(RS_JOB_SITE) type ZXI_1JOB_SITE_INPUT_TYPE .
ENDCLASS.



CLASS ZCL_IA_2TREMOLA IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* | [--->] IV_USE_EZ_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
* CONSTRUCTOR
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA lx_fehler TYPE REF TO zcx_ia_2failure.

    ASSERT CONDITION io_schicht IS BOUND.

    go_schicht = io_schicht.

*------------------------------------------------------------------------------------
* WebService Objekt erzeugen
*------------------------------------------------------------------------------------
    TRY.
*        CREATE OBJECT go_tremola_service. "#EC PREF_NEW
        go_tremola_service = NEW zxi_1co_os_tremola_tunnel_main( ).

      CATCH cx_ai_system_fault INTO DATA(lx_ai_error) ##NEEDED .
        lx_fehler = NEW #( ).
        MESSAGE e062(zia_2_real).
        lx_fehler->raise_with_sys_msg( ).
        RAISE EXCEPTION lx_fehler.
    ENDTRY.

*------------------------------------------------------------------------------------
    "Daten des letzten Aufrufs aus der DB lesen
*------------------------------------------------------------------------------------
    read_data_from_db( ).

*------------------------------------------------------------------------------------
    "Parameter lesen
*------------------------------------------------------------------------------------
    read_parameter( ).

*------------------------------------------------------------------------------------
    "Fahrleitungsabschnitte lesen
*------------------------------------------------------------------------------------
    read_catenary_sections( ).

*------------------------------------------------------------------------------------
    "Signalabschnitte lesen
*------------------------------------------------------------------------------------
    read_track_sections( ).

*------------------------------------------------------------------------------------
    "Fahrplan lesen
*------------------------------------------------------------------------------------
    read_train_routes( ).

*------------------------------------------------------------------------------------
    "Schicht lesen (Schichtparameter)
*------------------------------------------------------------------------------------
    TRY.
        read_shift( ).

      CATCH zcx_ia_2failure INTO lx_fehler.
        RAISE EXCEPTION lx_fehler.
    ENDTRY.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_AS_DETAILS_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIA_2_ID_AS
* | [<---] EV_START_DATUM                 TYPE        DATS
* | [<---] EV_END_DATUM                   TYPE        DATS
* | [<---] EV_START_ZEIT                  TYPE        TIMS
* | [<---] EV_END_ZEIT                    TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_as_details_by_as_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_AS_DETAILS_BY_AS_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*


*          ls_calc_timesheet TYPE zia_2_xi_cotremola_output_type.
    DATA: ls_calc_timesheet TYPE zxi_1tremola_output_type.

*    DATA: ls_shift     TYPE  zia_2_xi_coshift_type,
    DATA: ls_shift     TYPE  zxi_1shift_type,
*          ls_job_sites TYPE  zia_2_xi_coos_tunnel_mntn_d6,
          ls_job_sites TYPE  zxi_1shift_type_job_sites,
*          ls_job_sites TYPE  zxi_1shift_type_part_formation,
*          lt_job_site  TYPE  zia_2xi_cojob_site_op_typ_t.
          lt_job_site  TYPE  zxi_1job_site_output_type_tab.

*    DATA: tz TYPE timezone.
    ##NEEDED    DATA: lv_timezone_tremola  TYPE timezone,
              lv_timezone_ergebnis TYPE timezone.


*    FIELD-SYMBOLS: <ls_job_site>  TYPE zia_2_xi_cojob_site_op_type1.
    FIELD-SYMBOLS: <ls_job_site>  TYPE zxi_1job_site_output_type.

    ls_calc_timesheet = me->gs_response-calculate_timetable_return.

    "Schicht
    ls_shift = ls_calc_timesheet-shift.

*********************************************************************************************
    "Berücksichtigung Sommer- und Winterzeit
*********************************************************************************************
    CALL METHOD me->get_timezone
      EXPORTING
        iv_schicht_date      = ls_shift-begin
      IMPORTING
        ev_timezone_tremola  = lv_timezone_tremola
        ev_timezone_ergebnis = lv_timezone_ergebnis.
    "Arbeitsstellen
    ls_job_sites = ls_shift-job_sites.
    lt_job_site = ls_job_sites-job_site.

    ##WARN_OK  READ TABLE lt_job_site ASSIGNING <ls_job_site> WITH KEY id = iv_id_as.

    IF <ls_job_site> IS ASSIGNED.
      CONVERT TIME STAMP <ls_job_site>-begin TIME ZONE lv_timezone_ergebnis INTO DATE ev_start_datum TIME ev_start_zeit.
      CONVERT TIME STAMP <ls_job_site>-end TIME ZONE lv_timezone_ergebnis INTO DATE ev_end_datum TIME ev_end_zeit.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2TREMOLA=>GET_CURRENT_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_current_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*         Retrieves the current work shift instance from singleton.
*         Handles exception if singleton is not yet initialized.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    TRY.
        " Attempt to get the current schicht from singleton
        ro_schicht = mo_singleton->get_schicht( ).
        ##NO_HANDLER
      CATCH cx_sy_ref_is_initial.
        " Exception caught if singleton is not initialized; no action needed
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_EZ_FORM                     TYPE        ZIA_2_EZ_FORM_WD_T
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Retrieve train composition data for each workplace                   *
* during the shift by using Tremola EZ form data,                      *
* and send it to the process order (PO).
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    DATA ls_trassen_fpl          TYPE LINE OF tt_trassen_fpl.
*    DATA lt_processes            TYPE zxi_1coprocess_type_tab.
    DATA lt_processes            TYPE zxi_1process_type_tab.
*    DATA ls_process              TYPE zxi_1coprocess_type.
    DATA ls_process              TYPE zxi_1process_type.
*    DATA lt_formation            TYPE  zxi_1coformation_type_tab.
    DATA lt_formation            TYPE  zxi_1formation_type_tab.
*    DATA lt_part_formation       TYPE zxi_1copart_formation_type_tab.
    ##NEEDED    DATA lt_part_formation       TYPE zxi_1part_formation_type_tab.
*    DATA lt_job_sites            TYPE zxi_1cojob_sit_output_typ_tab1.
    DATA lt_job_sites            TYPE zxi_1job_site_output_type_tab.
    DATA lt_ez_form_ma TYPE STANDARD TABLE OF zia_2sf_ez_form WITH EMPTY KEY.
    DATA ls_ez_form_ma LIKE LINE OF lt_ez_form_ma.
    DATA ls_ez_form    LIKE LINE OF et_ez_form.


    CLEAR et_ez_form.
    DATA(ls_schicht) = go_schicht->get_data( ).
*--------------------------------------------------------------------------------------------------------------------
    " Load relevant data from API response into local tables
*--------------------------------------------------------------------------------------------------------------------
    load_api_response_data( IMPORTING et_process        = lt_processes
                                      et_formation      = lt_formation
                                      et_part_formation = lt_part_formation
                                      et_job_sites      = lt_job_sites ).

    DATA lt_trassen_fpl TYPE zcl_ia_2tremola=>tt_trassen_fpl.

    lt_trassen_fpl = select_trassen_fpl( iv_start_signal  = abap_true
                                                iv_tremola_start = abap_false ).

*---------------------------------------------------------------
* Enrich track allocations with first/last train times
*---------------------------------------------------------------
    enrich_trassen_fpl( CHANGING ct_trassen_fpl = lt_trassen_fpl ).
*---------------------------------------------------------------
* Load manually maintained EZ entries from DB
*---------------------------------------------------------------
    SELECT * FROM zia_2sf_ez_form INTO TABLE lt_ez_form_ma WHERE zschicht = ls_schicht-zschicht.

    " Process loop logic starting with LOOP AT lt_processes INTO ls_process...
    build_ez_entries_from_proc(
      EXPORTING
        it_processes   = lt_processes
        it_formations  = lt_formation
        it_job_sites   = lt_job_sites
        it_trassen_fpl = lt_trassen_fpl
        it_ez_form_ma  = lt_ez_form_ma
        is_schicht     = ls_schicht
      CHANGING
        ct_ez_form     = et_ez_form ).

    LOOP AT lt_trassen_fpl INTO ls_trassen_fpl.
      CLEAR ls_ez_form.
      READ TABLE et_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_tremola>) WITH KEY zugnummer   = ls_trassen_fpl-zugnummer
                                                                             data_origin = ls_trassen_fpl-data_origin.
      IF sy-subrc <> 0.

        " ------------------------------------------------------------------------------------------------------------
        " all routes from the table zio_trassen_fpl are searched, even if no work site is available
        " ------------------------------------------------------------------------------------------------------------
        CASE ls_trassen_fpl-zeiz.
          WHEN mc_eiz_gbtn.
            ls_ez_form-zid_eiz = mc_eiz_10.
          WHEN mc_eiz_gbts.
            ls_ez_form-zid_eiz = mc_eiz_20.
        ENDCASE.
        ls_ez_form-zschicht = ls_schicht-zschicht.
        ls_ez_form-ausfahrt = ls_trassen_fpl-ausfahrt.
        ls_ez_form-einfahrt = ls_trassen_fpl-einfahrt.
        ls_ez_form-zugnummer = ls_trassen_fpl-zugnummer.
        ls_ez_form-fahrtzeit = COND #( WHEN ls_trassen_fpl-zab IS NOT INITIAL THEN ls_trassen_fpl-zab ELSE ls_trassen_fpl-zan ).
        ls_ez_form-zeit_am_start_tag = ls_trassen_fpl-zeit_am_start_tag.
        ls_ez_form-data_origin = ls_trassen_fpl-data_origin.
        ls_ez_form-manually_created = COND #( WHEN ls_trassen_fpl-data_origin = zif_ia_2_constant=>mc_data_origin-manual
                                              THEN abap_true ).

        ls_ez_form-deactivated = COND #( WHEN ls_trassen_fpl-trasse_aktiv EQ abap_true THEN abap_false ELSE  abap_true ).

        ##WARN_OK READ TABLE lt_ez_form_ma INTO ls_ez_form_ma WITH KEY "zugnummer = ls_trassen_fpl-zugnummer "Trasse inaktiv
                                                                     zugnummer = ls_process-train_number
                                                                     zid_eiz   = ls_ez_form-zid_eiz
                                                                     zarbstl   = ' '

                                                                     ez_aktiv    = abap_true.

        IF sy-subrc = 0.
          "Apply manual change to the entry
          ls_ez_form-ez_aktiv = abap_true.
          ls_ez_form-has_changed = abap_true.
          ls_ez_form-manually_created = COND #( WHEN ls_ez_form_ma-data_origin = zif_ia_2_constant=>mc_data_origin-manual
                                                 THEN abap_true
                                                ELSE abap_false ).
        ELSE.
          ls_ez_form-ez_aktiv = abap_false.
        ENDIF.

        IF     ls_ez_form-einfahrt = 'X'.
          ls_ez_form-richtung = zif_ia_2_trasse=>mc_richtung_einfahrt.
        ELSEIF ls_ez_form-ausfahrt = 'X'.
          ls_ez_form-richtung = zif_ia_2_trasse=>mc_richtung_ausfahrt.
        ENDIF.
        APPEND ls_ez_form TO et_ez_form.
        CLEAR ls_ez_form.
      ENDIF.
    ENDLOOP.

    SORT et_ez_form BY zid_eiz ausfahrt einfahrt zugnummer fahrtzeit ASCENDING.

  ENDMETHOD.                                              "#EC CI_CYCLO


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_FAHRPLAN_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIA_2_ID_AS
* | [<-()] RT_FAHRPLAN                    TYPE        ZIA_2TREMOLA_FAHRPLAN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrplan_by_as_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRPLAN_BY_AS_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    DATA : lt_formation_ids TYPE STANDARD TABLE OF zia_2_formation_info WITH EMPTY KEY,
           ls_formation_id  LIKE LINE OF lt_formation_ids,
           lv_last_line     TYPE i.

    FIELD-SYMBOLS <ls_fahrplan> LIKE LINE OF rt_fahrplan.

**********************************************************************************************
*    "Tremola Berechnung
**********************************************************************************************
    "Timesheet
    ASSIGN gs_response-calculate_timetable_return TO FIELD-SYMBOL(<ls_calc_timesheet>).
    "Schicht
    ASSIGN <ls_calc_timesheet>-shift TO FIELD-SYMBOL(<ls_shift>).

**********************************************************************************************
*    "Berücksichtigung Sommer- und Winterzeit
**********************************************************************************************
    ##NEEDED    get_timezone( EXPORTING iv_schicht_date      = <ls_shift>-begin
                      IMPORTING ev_timezone_tremola  = DATA(lv_timezone_tremola)
                                ev_timezone_ergebnis = DATA(lv_timezone_ergebnis) ).

    "Image
    ASSIGN <ls_calc_timesheet>-graphical_time_table TO FIELD-SYMBOL(<lv_graphical_time_table>).
    "Log
    ASSIGN <ls_calc_timesheet>-log TO FIELD-SYMBOL(<lv_log>).

    "Weitere Aufdröselung
    "Arbeitsschritte
    ASSIGN <ls_shift>-processes-process TO FIELD-SYMBOL(<lt_process>).

    "Arbeitsstellen
    ASSIGN <ls_shift>-job_sites-job_site TO FIELD-SYMBOL(<lt_job_site>).

    "Erhaltungszüge
    ASSIGN <ls_shift>-formations-formation TO FIELD-SYMBOL(<lt_formation>).

    "Teilerhaltungszüge
    ASSIGN <ls_shift>-part_formations-part_formation TO FIELD-SYMBOL(<lt_part_formation>).

    "Für gesuchte Arbeitsstelle
    ##WARN_OK    READ TABLE <lt_job_site> ASSIGNING FIELD-SYMBOL(<ls_job_site>) WITH KEY id = iv_id_as.
    IF <ls_job_site> IS ASSIGNED.

      CLEAR: lt_formation_ids, ls_formation_id.

      "Die Arbeitsstelle hat eine Teilerhaltungszug-ID
      ls_formation_id  = VALUE #( id = <ls_job_site>-part_formation_id
                                  first = abap_true
                                  last = abap_true ).
      APPEND ls_formation_id TO lt_formation_ids.
      CLEAR: ls_formation_id.

      "Lesen über alle Formationen ist die gesuchte ID vorhanden?
      LOOP AT <lt_formation> ASSIGNING FIELD-SYMBOL(<ls_formation>).
        "Lesen der Parts
        FIELD-SYMBOLS: <ls_part_formation> TYPE zxi_1coos_tunnel_maint_d3.

        LOOP AT <ls_formation>-parts TRANSPORTING NO FIELDS WHERE part_formation_id = <ls_job_site>-part_formation_id. "#EC CI_NESTED

          "finde Position innerhalb der formation für unseren zug
          ##OPERATOR[INT4]          DATA(lv_pos_first) = CONV int4( 1 ).
          ##OPERATOR[INT4]          DATA(lv_pos_last) = CONV int4( 1 ).
          ##OPERATOR[INT4]          DATA(lv_pos_formation) = CONV int4( 0 ).
          lv_pos_last = lines( <ls_formation>-parts ).

          READ TABLE <ls_formation>-parts ASSIGNING <ls_part_formation> WITH KEY part_formation_id = <ls_job_site>-part_formation_id.

          IF <ls_part_formation> IS ASSIGNED.
            lv_pos_formation = <ls_part_formation>-position.

            "Teilerhaltungszug gefunden
*            IF lv_pos_formation EQ lv_pos_first. ls_formation_id-first = abap_true. ENDIF.
            ls_formation_id =  VALUE #(  first =  COND #( WHEN lv_pos_formation EQ lv_pos_first THEN abap_true )
                                         last =  COND #( WHEN lv_pos_formation EQ lv_pos_last THEN abap_true )
*            IF lv_pos_formation EQ lv_pos_last. ls_formation_id-last = abap_true. ENDIF.
                                         id = <ls_formation>-id ).
            APPEND ls_formation_id TO lt_formation_ids.
            CLEAR: ls_formation_id.

          ENDIF.

        ENDLOOP.
      ENDLOOP.

      "Fahrplanerstellung mit ID in Tabelle: lt_formation_ids
      LOOP AT lt_formation_ids INTO ls_formation_id.
        LOOP AT <lt_process> ASSIGNING FIELD-SYMBOL(<ls_process>) WHERE formation_id = ls_formation_id-id. "#EC CI_NESTED

          APPEND INITIAL LINE TO rt_fahrplan ASSIGNING <ls_fahrplan>.

          ##ENH_OK          MOVE-CORRESPONDING <ls_process> TO <ls_fahrplan>.

          CONVERT TIME STAMP <ls_process>-start-time TIME ZONE lv_timezone_ergebnis INTO DATE <ls_fahrplan>-start_datum TIME <ls_fahrplan>-start_zeit.
*          <ls_fahrplan>-start_position = <ls_process>-start-position.
          CONVERT TIME STAMP <ls_process>-end-time TIME ZONE lv_timezone_ergebnis INTO DATE <ls_fahrplan>-end_datum TIME <ls_fahrplan>-end_zeit.
          <ls_fahrplan> = VALUE #( start_position = <ls_process>-start-position
                                   end_position = <ls_process>-end-position ).

          "Aktiver Führerstand
          "Nord
          IF <ls_process>-formation_id CS 'ERSTFELD'.
            "Arr          "last
            <ls_fahrplan>-afs = COND #( WHEN <ls_process>-trip_type EQ 'Arr' THEN
            COND #( WHEN ls_formation_id-last EQ abap_true THEN abap_true ) ).
            "Dep              "first
            <ls_fahrplan>-afs = COND #( WHEN  <ls_process>-trip_type EQ 'Dep' THEN
             COND #( WHEN ls_formation_id-first EQ abap_true THEN  abap_true ) ).
          ENDIF.

          "Süd
          IF <ls_process>-formation_id CS 'BIASCA'.
            "Arr    "first
            <ls_fahrplan>-afs =  COND #( WHEN <ls_process>-trip_type EQ 'Arr' THEN
            COND #( WHEN ls_formation_id-first EQ abap_true THEN abap_true ) ).
            "Dep

            <ls_fahrplan>-afs = COND #( WHEN <ls_process>-trip_type EQ 'Dep' THEN
            COND #( WHEN ls_formation_id-last EQ abap_true THEN abap_true ) ).

          ENDIF.

          "Spezialfall (Arbeit an der Arbeitsstelle)
*          IF <ls_process>-trip_type EQ 'Idle'.
          <ls_fahrplan> =  VALUE #(  afs = COND #( WHEN <ls_process>-trip_type EQ 'Idle' THEN abap_true )


          dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = <ls_fahrplan>-start_datum
                                                                             iv_start_time = <ls_fahrplan>-start_zeit
                                                                             iv_end_date   = <ls_fahrplan>-end_datum
                                                                             iv_end_time   = <ls_fahrplan>-end_zeit ) ).

        ENDLOOP.
      ENDLOOP.

      SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

    ENDIF.

**********************************************************************************************
*    "Fahrplan kommplementieren
**********************************************************************************************
    DATA(lv_eiz) = go_schicht->get_arbeitsstelle_by_id( iv_id = iv_id_as )->get_data( )-zid_eiz.

    "Zugnummer lesen von der Einfahrt
    READ TABLE rt_fahrplan ASSIGNING <ls_fahrplan> INDEX 1.
    IF sy-subrc = 0.

      APPEND LINES OF read_fahrplan_completion( iv_train_number = <ls_fahrplan>-train_number
                                                iv_trip_type    = <ls_fahrplan>-trip_type
                                                iv_eiz          = lv_eiz
                                                iv_afs          = <ls_fahrplan>-afs
                      ) TO rt_fahrplan.

      SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      "Zugnummer lesen von der Einfahrt
      lv_last_line = lines( rt_fahrplan ).

      READ TABLE rt_fahrplan ASSIGNING <ls_fahrplan> INDEX lv_last_line.

      APPEND LINES OF read_fahrplan_completion( iv_train_number = <ls_fahrplan>-train_number
                                                iv_trip_type    = <ls_fahrplan>-trip_type
                                                iv_eiz          = lv_eiz
                                                iv_afs          = <ls_fahrplan>-afs
                      ) TO rt_fahrplan.

      SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      LOOP AT rt_fahrplan ASSIGNING <ls_fahrplan>. "RGBT-848
        "Anpassung Kontroll- und Freifahrt
*        IF <ls_fahrplan>-procedure EQ mc_procedure_running AND <ls_fahrplan>-last EQ abap_true.
        <ls_fahrplan> = VALUE #(  procedure = COND #( WHEN <ls_fahrplan>-procedure EQ mc_procedure_running AND <ls_fahrplan>-last EQ abap_true
         THEN mc_trip_type_control
          WHEN <ls_fahrplan>-procedure EQ mc_procedure_running AND <ls_fahrplan>-etcs_mode EQ mc_etcs_sh
        THEN mc_trip_type_rangier )
*        ENDIF.
        "Anpassung bei Procedure Running und ETCS_MODE = SH = Procedure Running_SH -> Rangierbewegung
*        IF <ls_fahrplan>-procedure EQ mc_procedure_running AND <ls_fahrplan>-etcs_mode EQ mc_etcs_sh.
*        <ls_fahrplan>-procedure = COND #( WHEN <ls_fahrplan>-procedure EQ mc_procedure_running AND <ls_fahrplan>-etcs_mode EQ mc_etcs_sh
*        THEN mc_trip_type_rangier ).
*        ENDIF.
        "Anpassung wenn Führerstand Aktiv leer (nein) muss in Feld ETCS-Mode immer NL gefüllt werden

        etcs_mode = COND #( WHEN <ls_fahrplan>-afs EQ abap_false THEN mc_etc_mode_nl ) ).

      ENDLOOP.
    ENDIF.

  ENDMETHOD.                                              "#EC CI_CYCLO


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_FORMATION_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIA_2_ID_AS
* | [--->] IV_DB                          TYPE        BOOLEAN(optional)
* | [<-()] RT_FORMATION                   TYPE        ZIA_2TREMOLA_FORMATION_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_formation_by_as_id.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FORMATION_BY_AS_ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA lo_arbeitsstelle TYPE REF TO zcl_ia_2wrkplace.
    FIELD-SYMBOLS <ls_formation> LIKE LINE OF rt_formation.

    DATA(lv_tremola_calc)  = abap_false.
    DATA(lv_norden) = abap_false.
    DATA(lv_reihung_count) = 0.

    "Arbeitsstellen
    ASSIGN gs_response-calculate_timetable_return-shift-job_sites-job_site TO FIELD-SYMBOL(<lt_job_site>).
    IF <lt_job_site> IS INITIAL.
      RETURN.
    ENDIF.

    "Teilerhaltungszüge
    ASSIGN gs_response-calculate_timetable_return-shift-part_formations-part_formation TO FIELD-SYMBOL(<lt_part_formation>).
    IF <lt_part_formation> IS INITIAL.
      RETURN.
    ENDIF.

    "Für gesuchte Arbeitsstelle
    ##WARN_OK    READ TABLE <lt_job_site> ASSIGNING FIELD-SYMBOL(<ls_job_site>) WITH KEY id = iv_id_as.

    IF <ls_job_site> IS ASSIGNED.

      READ TABLE <lt_part_formation> ASSIGNING FIELD-SYMBOL(<ls_part_formations>) WITH KEY id = <ls_job_site>-part_formation_id.

      IF <ls_part_formations> IS ASSIGNED.

        ASSIGN <ls_part_formations>-vehicle TO FIELD-SYMBOL(<lt_vehicles>).

        IF <ls_part_formations>-id CS 'ERSTFELD'.
          lv_norden = abap_true.
        ENDIF.

        "Fahrzeuge an der Arbeitstelle
        LOOP AT <lt_vehicles> ASSIGNING FIELD-SYMBOL(<ls_vehicle>).
          APPEND INITIAL LINE TO rt_formation ASSIGNING <ls_formation>.

          <ls_formation>-id = sy-tabix.
          <ls_formation>-type = <ls_vehicle>-type.
          <ls_formation>-position = <ls_vehicle>-position.
          <ls_formation>-orientation = <ls_vehicle>-orientation.
          <ls_formation>-aux_drivers_cab = <ls_vehicle>-aux_drivers_cab.
          <ls_formation>-original_reihung_tremola = <ls_vehicle>-position.
          lv_reihung_count = lv_reihung_count + 1.
        ENDLOOP.

      ENDIF.

    ENDIF.

    "Falls die Methode für die Drehbücher ausgeführt wird, soll Orientierung & Reihung aus der REAL-DB gelesen werden.
    IF iv_db EQ abap_true.

      IF go_schicht IS NOT INITIAL AND iv_id_as IS NOT INITIAL.
        lo_arbeitsstelle = go_schicht->get_arbeitsstelle_by_id( iv_id = iv_id_as ).
        IF lo_arbeitsstelle IS BOUND.

          LOOP AT rt_formation ASSIGNING <ls_formation>.

            "Position und Orientierung aus REAL-DB lesen (da diese Methode zur Drehbuchgenerierung aufgerufen wird).
            DATA(lo_fahrzeuge) = lo_arbeitsstelle->get_fahrzeuge( iv_filter_fztyp =  <ls_formation>-type ).
            DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

            WHILE li_fahrzeuge_i->has_next( ).
              DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).
              <ls_formation>-position =  lo_fahrzeug->get_reihung( ).
              <ls_formation>-orientation = lo_fahrzeug->get_orientierung( ).
            ENDWHILE.

          ENDLOOP.

        ENDIF.
      ENDIF.

    ELSE.

      "Falls sich die Arbeitsstelle im Norden befindet, muss die Reihung "umgekehrt" werden
      "Die Original-Tremola Daten sind im diesem Fall aus dem Feld "original_reihung_tremola" weiterhin ersichtlich.
      SELECT SINGLE tremola_calc INTO lv_tremola_calc FROM zia_2sf_wa WHERE zarbstl EQ iv_id_as.

      IF    lv_norden EQ abap_true
        AND lv_tremola_calc EQ abap_true. "Nur ausführen bei 'TremolaCalc'

        SORT rt_formation BY position ASCENDING.

        LOOP AT rt_formation ASSIGNING <ls_formation>.
          <ls_formation>-position = lv_reihung_count.
          lv_reihung_count = lv_reihung_count - 1.
        ENDLOOP.

        SORT rt_formation BY position ASCENDING.

      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2TREMOLA=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT                     TYPE        ZIA_2_WORKSHIFT(optional)
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT(optional)
* | [--->] IV_NEW                         TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [--->] IV_USE_EZ_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IA_2TREMOLA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*         Method get_instance implements a singleton pattern to provide
*         a single instance of the class tied to a work shift (schicht).
*         It either reuses the existing instance or creates a new one if
*         the shift changes or new instance requested.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    " If io_schicht is not passed (not bound), create a new ZCL_IA_2WORKSHIFT instance
    io_schicht = COND #( WHEN io_schicht IS BOUND
                          THEN io_schicht
                          ELSE NEW zcl_ia_2workshift( iv_schicht ) ).
    ASSERT CONDITION io_schicht IS BOUND.

    " Get the currently active work shift instance
    DATA(lo_schicht) = get_current_schicht( ).

    "If a new instance is requested, clear the current shift to force new creation
    IF iv_new = abap_true.
      CLEAR lo_schicht.
    ENDIF.

    " If the current shift instance differs from the passed shift, create a new singleton instance
    IF lo_schicht <> io_schicht.
      mo_singleton = NEW #( io_schicht = io_schicht iv_use_ez_db = iv_use_ez_db ).
      mo_singleton->invalidate_response( ).
    ENDIF.

    "Return the singleton instance
    ro_instance = mo_singleton.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_PARAMETER                   TYPE        ZXI_1TREMOLA_INPUT_TYPE_PARAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_parameter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_PARAMETER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    IF me->gs_parameter IS INITIAL.
      me->read_parameter( ).
    ENDIF.

    rs_parameter = me->gs_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_SCHICHT
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
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*         Getter method for returning the current work shift (schicht) instance.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    " Return the current work shift singleton instance
    ro_schicht = go_schicht.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_TIMEZONE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT_DATE                TYPE        DATS
* | [<---] EV_TIMEZONE_TREMOLA            TYPE        TIMEZONE
* | [<---] EV_TIMEZONE_ERGEBNIS           TYPE        TIMEZONE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_timezone.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_TIMEZONE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    CONSTANTS: lc_timezone TYPE edm_timezone VALUE 'CET'.
    DATA: ls_ttzdf     TYPE ttzdf.

    DATA: lv_datum TYPE syst_datum.
*    MOVE iv_schicht_date TO lv_datum. "17.10.2017
    lv_datum = iv_schicht_date.
    CALL FUNCTION 'ISU_EDM_DST_DETERMINE' "#EC CI_SUBRC
      EXPORTING
        x_keydate          = lv_datum
        x_time_zone        = lc_timezone
      IMPORTING
        y_ttzdf            = ls_ttzdf
*       Y_SOUTH            =
      EXCEPTIONS
        timezone_not_valid = 1
        OTHERS             = 2.
*    IF sy-subrc = 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
** Implement suitable error handling here
*    ENDIF.
* Prüfen ist Systemdatum grösser als Sommerzeitbeginn
    IF lv_datum > ls_ttzdf-datefrom.
* Prüfen ist Systemdatum grösser als Sommerzeitende
      IF lv_datum > ls_ttzdf-dateto.
        " Winterzeit
        ev_timezone_tremola = 'UTC+1'.
        ev_timezone_ergebnis = 'UTC+1'.
      ELSE.
        " Sommerzeit
        ev_timezone_tremola = 'CET'.
        ev_timezone_ergebnis = 'UTC+2'.
      ENDIF.
    ELSE.
      " Winterzeit
      ev_timezone_tremola = 'UTC+1'.
      ev_timezone_ergebnis = 'UTC+1'.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_TRAINS_AT_EIZ
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_TRAINS                      TYPE        ZIA_2TRAIN_AT_EIZ_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_trains_at_eiz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : GET_TRAINS_AT_EIZ
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
*    DATA lt_formation TYPE zxi_1coformation_type_tab.
    DATA : lt_formation TYPE zxi_1formation_type_tab,
           ls_formation LIKE LINE OF lt_formation,
           lt_train_formation TYPE zia_2train_formation_t,
           ls_train_formation LIKE LINE OF lt_train_formation,
*    DATA lt_part_formation TYPE zxi_1copart_formation_type_tab.
           lt_part_formation TYPE TABLE OF zxi_1part_formation_type,
           ls_part_formation LIKE LINE OF lt_part_formation,
           lt_zio_map_as_fz TYPE STANDARD TABLE OF zia_2sf_wa_veh,
##NEEDED           ls_zio_map_as_fz LIKE LINE OF lt_zio_map_as_fz,
           lt_tremola_vehicle TYPE  zia_2tremola_formation_t,
           ls_tremola_vehicle LIKE LINE OF lt_tremola_vehicle,
##NEEDED           ls_zio_fahrzeuge TYPE zia_2vehicles,
           ls_train LIKE LINE OF et_trains,
##NEEDED           lv_mime_type TYPE zia_2_fztyp_mime_pfad,
           lv_reihung_count TYPE i,
##NEEDED           lv_orientierung TYPE char1,
##NEEDED           lv_arbstelle TYPE zia_2_id_arbstl,
           lv_norden TYPE boolean,
    ##NEEDED    lv_tremola_calc TYPE boolean,
##NEEDED           lo_arbeitsstelle TYPE REF TO zcl_ia_2wrkplace.

    CLEAR et_trains.

    ##NEEDED    DATA(ls_schicht) = go_schicht->get_data( ).

**--------------------------------------------------------------------------------------------------------------------
**   DATEN AUS RESPONSE HOLEN
**--------------------------------------------------------------------------------------------------------------------
    lt_formation = gs_response-calculate_timetable_return-shift-formations-formation.
    lt_part_formation = gs_response-calculate_timetable_return-shift-part_formations-part_formation.
    DATA(lt_processes) = gs_response-calculate_timetable_return-shift-processes-process.
    DATA(lt_job_sites) = gs_response-calculate_timetable_return-shift-job_sites-job_site.

**--------------------------------------------------------------------------------------------------------------------
**   ZÜGE AUS TRASSEN-FAHRPLAN ERMITTELN
**--------------------------------------------------------------------------------------------------------------------
*    SELECT * FROM ZIO_TRASSEN_FPL INTO TABLE LT_TRASSEN_FPL WHERE ZID_INTERVALL = LV_ID_INTERVALL AND
*                                                                     ZEST = LV_EST AND
*                                                                     REIHENFOLGE = '1' AND
*                                                                     EINFAHRT = 'X' AND
*                                                                     GUELTIG_VON <= LV_START_DATUM AND
*                                                                     GUELTIG_BIS >= LV_START_DATUM.
    DATA(lt_trassen_fpl) = select_trassen_fpl( iv_reihenfolge   = '1'
                                               iv_richtung      = zif_ia_2_tracks=>mc_richtung_einfahrt
                                               iv_start_signal  = abap_false
                                               iv_tremola_start = abap_false ).

    LOOP AT lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl>).

      READ TABLE lt_processes ASSIGNING FIELD-SYMBOL(<ls_process>) WITH KEY train_number = <ls_trassen_fpl>-zugnummer.

*--------------------------------------------------------------------------------------------------------------------
*     ZUG WIRD VERWENDET UND WIRD NUN AUSGEWERTET.
*--------------------------------------------------------------------------------------------------------------------
      IF sy-subrc EQ 0.

        ls_train = VALUE #( formation_id = <ls_process>-formation_id
                            zug_nr = <ls_process>-train_number ).

        CLEAR ls_formation.
        READ TABLE lt_formation INTO ls_formation WITH KEY id = ls_train-formation_id.

*--------------------------------------------------------------------------------------------------------------------
*     TEILZÜGE BEARBEITEN
*--------------------------------------------------------------------------------------------------------------------

        CLEAR lv_norden.
        LOOP AT ls_formation-parts INTO DATA(ls_part).   "#EC CI_NESTED

          ls_train_formation = VALUE #( position = ls_part-position
                                        formation_id = ls_part-part_formation_id ).

          CLEAR ls_part_formation.
          READ TABLE lt_part_formation INTO ls_part_formation WITH KEY id = ls_part-part_formation_id.
*--------------------------------------------------------------------------------------------------------------------
*     FAHRZEUGE ERMITTELN
*--------------------------------------------------------------------------------------------------------------------

*      --------------------------------------------------------------------------------
          "SELBE LOGIK WIE IN GET_FORMATION_BY_AS_ID
          "FALLS SICH DIE ARBEITSSTELLE IM NORDEN BEFINDET, MUSS DIE REIHUNG "UMGEKEHRT" WERDEN
          "ES SEI DENN, DIE METHODE WIRD FÜR DAS DREHBUCH AUFGERUFEN.

          lv_norden = abap_false.
          lv_reihung_count = 0.

          lv_norden = COND abap_bool( WHEN ls_part_formation-id CS 'ERSTFELD' THEN abap_true
                              ELSE abap_false ).

          SELECT SINGLE tremola_calc INTO lv_tremola_calc FROM zia_2sf_wa WHERE zarbstl EQ ls_part-part_formation_id.

          IF lv_norden EQ abap_true .
            SORT ls_part_formation-vehicle BY position ASCENDING. "#EC CI_SORTLOOP
            LOOP AT ls_part_formation-vehicle ASSIGNING FIELD-SYMBOL(<ls_vehicle>). "#EC CI_NESTED
              <ls_vehicle>-position = lv_reihung_count.
              lv_reihung_count = lv_reihung_count - 1.
            ENDLOOP.
*            SORT LS_PART_FORMATION-VEHICLE BY POSITION ASCENDING.
          ENDIF.

*      --------------------------------------------------------------------------------

          CLEAR: lt_zio_map_as_fz, ls_zio_map_as_fz, ls_tremola_vehicle-arbstelle.
          READ TABLE lt_job_sites ASSIGNING FIELD-SYMBOL(<ls_job_sites>) WITH KEY part_formation_id = ls_train_formation-formation_id.
          ls_tremola_vehicle-arbstelle = COND #( WHEN sy-subrc EQ 0 THEN  <ls_job_sites>-id ).
          SELECT * INTO TABLE lt_zio_map_as_fz FROM zia_2sf_wa_veh
                               WHERE  zid_arbstl  = ls_tremola_vehicle-arbstelle.
          lv_arbstelle = ls_tremola_vehicle-arbstelle.

*          lv_reihung_count = 0.
*
          "          LOOP AT lt_zio_map_as_fz INTO ls_zio_map_as_fz. "#EC CI_NESTED
*            FREE: ls_tremola_vehicle, ls_zio_fahrzeuge.
*            ls_tremola_vehicle-id = ls_zio_map_as_fz-reihung.
*            " FAHRZEUGTYP ERMITTELN
*            SELECT SINGLE * INTO ls_zio_fahrzeuge FROM zia_2vehicles
*                  WHERE zid_fzg  = ls_zio_map_as_fz-zid_fzg
*                    AND loekn    = space.
          "            ls_tremola_vehicle = VALUE #( type = COND #( WHEN sy-subrc EQ 0 THEN  ls_zio_fahrzeuge-zid_fztyp )
*                                          position = ls_zio_map_as_fz-reihung
*                                          orientation = ls_zio_map_as_fz-orientierung
*                                          arbstelle = lv_arbstelle ).
*            lo_arbeitsstelle = go_schicht->get_arbeitsstelle_by_id( iv_id = ls_tremola_vehicle-arbstelle ).
*
*            ls_tremola_vehicle-arbstelle_txt = COND #( WHEN lo_arbeitsstelle IS NOT INITIAL THEN  lo_arbeitsstelle->get_kurztext( ) ).
*
*            IF ls_tremola_vehicle-type IS NOT INITIAL.
*              ##WARN_OK              SELECT SINGLE zfztyp_txt FROM zia_2veh_typ_t
*              INTO ls_tremola_vehicle-fahrzeug_type_txt
          "              WHERE zid_fztyp EQ ls_tremola_vehicle-type.
          "            ENDIF.
*            "MIME-TYPE DES FAHRZEUGTYPES ERMITTELN
*            CLEAR lv_mime_type.
*            lv_orientierung = ls_tremola_vehicle-orientation.
          "            zcl_ia_2utilities=>get_mime_pfad_by_fztyp( EXPORTING iv_fztype       = ls_tremola_vehicle-type
*                                                                iv_orientierung = lv_orientierung
          "                                                      IMPORTING ev_mime_pfad    = lv_mime_type ).
**            IF lv_mime_type IS NOT INITIAL.
          "              CONCATENATE zcl_ia_2utilities=>mc_mime_pfad_images lv_mime_type INTO ls_tremola_vehicle-fahrzeug_img_mime.
          "            ELSE.
**              ls_tremola_vehicle-fahrzeug_img_mime = '/SAP/BC/FP/GRAPHICS/PUBLIC/GRAPHICS/REAL/BASISFAHRZEUG.PNG'.
          "            ENDIF.
*            ls_tremola_vehicle-fahrzeug_img_mime =  |{ COND string(
*                WHEN lv_mime_type IS NOT INITIAL THEN |{ zcl_ia_2utilities=>mc_mime_pfad_images } { lv_mime_type }  |
          "                ELSE '/SAP/BC/FP/GRAPHICS/PUBLIC/GRAPHICS/REAL/BASISFAHRZEUG.PNG' ) } |.
*
*            DATA(li_mime_api) = cl_mime_repository_api=>get_api( ).
          "            li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-fahrzeug_img_mime
*                              IMPORTING e_content = ls_tremola_vehicle-fahrzeug_img ).
*            "MIME-ICON FÜR ORIENTATION
*            IF ls_tremola_vehicle-orientation IS INITIAL.
*              FREE: ls_tremola_vehicle-orientation_img_mime, ls_tremola_vehicle-orientation_img.
*            ELSE.
*              ls_tremola_vehicle-orientation_img_mime = COND #( WHEN ls_tremola_vehicle-orientation EQ 'N' THEN mc_mime_pfad_orientierung_l
*               ELSE  mc_mime_pfad_orientierung_r ).
*
*
*              li_mime_api = cl_mime_repository_api=>get_api( ).
          "              li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-orientation_img_mime
*                                IMPORTING e_content = ls_tremola_vehicle-orientation_img ).
*            ENDIF.
*            APPEND ls_tremola_vehicle TO lt_tremola_vehicle.
*            lv_reihung_count = lv_reihung_count + 1.
          "          ENDLOOP.
*
*          SORT lt_tremola_vehicle BY position.         "#EC CI_SORTLOOP
*
          "          lv_norden = COND #( WHEN ls_part_formation-id CS 'ERSTFELD' THEN abap_true
          "          ELSE '' ).
*
*          IF lv_norden EQ abap_true .
*
*            CLEAR : lv_mime_type, ls_tremola_vehicle-fahrzeug_img_mime.
*
*
*            SORT lt_tremola_vehicle BY position ASCENDING. "#EC CI_SORTLOOP
*
*            LOOP AT lt_tremola_vehicle ASSIGNING FIELD-SYMBOL(<ls_tremola_vehicle>). "#EC CI_NESTED
*              <ls_tremola_vehicle>-sort_db = lv_reihung_count.
*              lv_reihung_count = lv_reihung_count - 1.
*
*            ENDLOOP.
*
*            SORT lt_tremola_vehicle BY position DESCENDING. "#EC CI_SORTLOOP
*          ENDIF.
*
*          "-------------------------------------------------------------------------
*
*          ls_train_formation-vehicles = lt_tremola_vehicle.
          get_trains_at_eiz1( EXPORTING it_zia_2map_as_fz = lt_zio_map_as_fz
                                               IMPORTING   et_tremola_vehicle =  lt_tremola_vehicle
                                                 ev_reihung_count = lv_reihung_count ).


          APPEND ls_train_formation TO lt_train_formation. CLEAR: ls_train_formation-vehicles, lt_tremola_vehicle.

        ENDLOOP.

        IF sy-subrc EQ 0.

          SORT lt_train_formation BY position.         "#EC CI_SORTLOOP

          ls_train-train_formation = lt_train_formation.
          APPEND ls_train TO et_trains.
          CLEAR: ls_train-train_formation , lt_train_formation.
        ENDIF.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->HAS_VALID_RESPONSE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_valid_response.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Added method has_valid_response to check if the timetable
* response corresponds to the current shift and contains
* graphical timetable data.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    " Convert current shift ID from object to integer for comparison
    DATA(lv_schicht) = CONV i( go_schicht->get_id( ) ).

    " Check if response shift ID matches current shift ID
    " and if graphical timetable data is available (not initial)
    rv_value = boolc(
      gs_response-calculate_timetable_return-shift-id = lv_schicht
      AND gs_response-calculate_timetable_return-graphical_time_table IS NOT INITIAL
    ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->INVALIDATE_RESPONSE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD invalidate_response.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Added method invalidate_response to clear the response data,
* effectively invalidating any current timetable response.
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    " Clear the response structure to invalidate the current timetable data
    CLEAR gs_response.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_CATENARY_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_catenary_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_CATENARY_SECTIONS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    DATA(lv_sp) = VALUE zia_2_roehre( ).   ">001< (+)


    DATA(lv_est) = go_schicht->get_rj_est( ).
    lv_sp = COND #( WHEN strlen( lv_est ) >= 2 THEN lv_est(1) ELSE lv_est ).  ">001< (+)

    SELECT * FROM zia_2tremola_ooc INTO TABLE @DATA(lt_fahrl_abschn) WHERE zest = @lv_sp.

    ##NEEDED    DATA(lt_catenary_section) = VALUE zxi_1catenary_section_type_tab( ).

    LOOP AT lt_fahrl_abschn ASSIGNING FIELD-SYMBOL(<ls_fahrl_abschn>).
      APPEND VALUE #( begin = <ls_fahrl_abschn>-km_von
                      end = <ls_fahrl_abschn>-km_bis
                    ) TO gs_catenary_sections-catenary_section.
    ENDLOOP.

    gs_output-scenario-catenary_sections = gs_catenary_sections.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_DATA_FROM_DB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_data_from_db.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_DATA_FROM_DB
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       17.06.2026        TCS / Roshan Wadhwani
*         changing datatype to zia_2_workshift
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    DATA: ls_tremola_data TYPE zia_2tremola_dat,
          lv_schicht_id   TYPE zia_2_workshift.

    CLEAR: me->gs_request, me->gs_response, ls_tremola_data.

    "Daten lesen
    lv_schicht_id = me->go_schicht->get_id( ).
    SELECT SINGLE * FROM zia_2tremola_dat INTO ls_tremola_data WHERE schicht = lv_schicht_id.

    IF sy-subrc EQ 0.
      "Request
      CALL TRANSFORMATION ('ID')
         SOURCE XML ls_tremola_data-request
         RESULT request = me->gs_request.

      "Response
      CALL TRANSFORMATION ('ID')
       SOURCE XML ls_tremola_data-response
       RESULT response = me->gs_response.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_FAHRPLAN_COMPLETION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TRAIN_NUMBER                TYPE        ZIA_2_TRAIN_NUMB
* | [--->] IV_TRIP_TYPE                   TYPE        STRING
* | [--->] IV_EIZ                         TYPE        ZIA_2_ID_EIZ
* | [--->] IV_AFS                         TYPE        BOOLEAN
* | [<-()] RT_FAHRPLAN                    TYPE        ZIA_2TREMOLA_FAHRPLAN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_fahrplan_completion.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_FAHRPLAN_COMPLETION
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA lt_trassen_fpl TYPE tt_trassen_fpl.
    DATA ls_fahrplan LIKE LINE OF rt_fahrplan.
    FIELD-SYMBOLS <ls_trassen_fpl> LIKE LINE OF lt_trassen_fpl.


    DATA(ls_schicht) = go_schicht->get_data( ).

    lt_trassen_fpl = select_trassen_fpl( iv_zugnummer     = CONV #( iv_train_number )
                                         iv_start_signal  = abap_false
                                         iv_tremola_start = abap_false ).
    CHECK lt_trassen_fpl[] IS NOT INITIAL.

    SORT lt_trassen_fpl ASCENDING BY reihenfolge.

    IF iv_eiz EQ mc_eiz_10. "norden
**************************************************
*********ARRIVAL
**************************************************
      IF iv_trip_type EQ 'Arr'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan = VALUE #( train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zab
                               afs = iv_afs
                               trip_type = mc_trip_type_arr
                               procedure = mc_procedure_running
                               start_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }| ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zan
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|
                               dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        ls_fahrplan = VALUE #( afs = iv_afs
                               trip_type = mc_trip_type_arr "'Arr'.
                               procedure = mc_procedure_running "'Running'.
                               train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zan
                               start_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                      ELSE ls_schicht-start_datum + 1 )

                               start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }| ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 3.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zab
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                     ELSE ls_schicht-start_datum + 1 )
                               end_id = <ls_trassen_fpl>-startsignal
                               dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                                     iv_start_time = ls_fahrplan-start_zeit
                                                                                     iv_end_date   = ls_fahrplan-end_datum
                                                                                     iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Zweite Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

**************************************************
*********DEPARTURE
**************************************************
      IF iv_trip_type EQ 'Dep'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan = VALUE #( afs = iv_afs
                               trip_type = mc_trip_type_dep "'Dep'.
                               procedure = mc_procedure_running "'Running'.
                               train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zan
                               start_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                          ELSE ls_schicht-start_datum + 1 )
                               start_id = <ls_trassen_fpl>-startsignal ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zab
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                   ELSE ls_schicht-start_datum + 1 )
                               end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|
                               dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        ls_fahrplan = VALUE #( afs = iv_afs
                               trip_type = mc_trip_type_dep "'Dep'.
                               procedure = mc_procedure_running "'Running'.
                               train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zab
                               start_datum = COND #( WHEN  <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN  ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }| ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 3.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zan
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|
        dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                  iv_start_time = ls_fahrplan-start_zeit
                                                  iv_end_date   = ls_fahrplan-end_datum
                                                  iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Zweite Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

    ENDIF.

***********************************************************************
***********************************************************************
****
****                              Süd
****
***********************************************************************
***********************************************************************

    IF iv_eiz EQ mc_eiz_20. "süden
**************************************************
*********ARRIVAL
**************************************************
      IF iv_trip_type EQ 'Arr'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan = VALUE #( afs = iv_afs
                               trip_type = mc_trip_type_arr "'Arr'.
                               procedure = mc_procedure_running "'Running'.
                               train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zab
                               start_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN  ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }| ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zan
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                   ELSE ls_schicht-start_datum + 1 )
                               end_id = <ls_trassen_fpl>-startsignal
                               dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

**************************************************
*********DEPARTURE
**************************************************
      IF iv_trip_type EQ 'Dep'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan = VALUE #( afs = iv_afs
                               trip_type = mc_trip_type_dep "'Dep'.
                               procedure = mc_procedure_running "'Running'.
                               train_number = <ls_trassen_fpl>-zugnummer
                               start_zeit = <ls_trassen_fpl>-zab
                               start_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                     ELSE ls_schicht-start_datum + 1 )
                               start_id = <ls_trassen_fpl>-startsignal ).

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan = VALUE #( end_zeit = <ls_trassen_fpl>-zan
                               end_datum = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true THEN ls_schicht-start_datum
                                                   ELSE ls_schicht-start_datum + 1 )
                               end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|
                               dauer = zcl_ia_2utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ) ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_FUNCLOC_ATTRIUTES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TPLNR                       TYPE        TPLNR
* | [<-()] RS_VEHILCE_ATTR                TYPE        ZIA_2_FUNCLOC_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_funcloc_attriutes.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_FUNCLOC_ATTRIUTES
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

    DATA: lo_funcloc_agent TYPE REF TO zcl_ia_2lofpm_cla_funcloc,
          lo_funcloc       TYPE REF TO zcl_ia_2lofpm_clo_funcloc.

    DATA: lo_funcloc_calssif TYPE REF TO zcl_ia_2lofpm_clo_classificati,
          lt_details         TYPE zia_2lofpm_classif_details_t.

    DATA: ls_num_values  TYPE bapi1003_alloc_values_num,
          ls_char_values TYPE bapi1003_alloc_values_char.

    FIELD-SYMBOLS <ls_details> TYPE zia_2_lofpm_classif_details.

    zcl_ia_2lofpm_clh_app=>get_instance( iv_applid = 'GBT' ).

    lo_funcloc_agent = zcl_ia_2lofpm_cla_agency=>get_funcloc_agent( ).

    "ZUM TESTEN
    IF iv_tplnr IS INITIAL.
*      lo_funcloc ?= lo_funcloc_agent->get_object( EXPORTING iv_tplnr = lo_funcloc_agent->tplnr_convert_internal( iv_tplnr = 'GBT_XS_1' ) ).
      lo_funcloc = lo_funcloc_agent->get_object( EXPORTING iv_tplnr = lo_funcloc_agent->tplnr_convert_internal( iv_tplnr = 'REAL_XAS_2' ) ).
    ELSE.
*      lo_funcloc ?= lo_funcloc_agent->get_object( EXPORTING iv_tplnr = iv_tplnr ).
      lo_funcloc = lo_funcloc_agent->get_object( EXPORTING iv_tplnr = iv_tplnr ).
    ENDIF.

*    lo_funcloc_calssif ?= lo_funcloc->get_classification( ).
    lo_funcloc_calssif = lo_funcloc->get_classification( ).

    lt_details = lo_funcloc_calssif->get_characteristics(
      EXPORTING
        iv_classnum        = 'R_TP_INFRA_REAL' " KLASSENNUMMER
        iv_classtype       = '003'  " KLASSENART
    ).

    READ TABLE lt_details INDEX 1 ASSIGNING <ls_details>.

    IF <ls_details> IS ASSIGNED.
      "ZEICHENARTIGE WERTE
      READ TABLE <ls_details>-valueschar WITH KEY charact = 'R_FZ_TYP' INTO ls_char_values.
      rs_vehilce_attr-m_fz_typ = ls_char_values-value_char. CLEAR: ls_char_values.
**      READ TABLE <LS_DETAILS>-VALUESCHAR WITH KEY CHARACT = 'M_ZV_BAUART_DER_KUPPLUNGEN' INTO  LS_CHAR_VALUES.
**      RS_VEHILCE_ATTR-M_ZV_BAUART_DER_KUPPLUNGEN = LS_CHAR_VALUES-VALUE_CHAR. CLEAR: LS_CHAR_VALUES.
      READ TABLE <ls_details>-valueschar WITH KEY charact = 'R_AUTOM_KUPPLUNG_VORHANDEN' INTO  ls_char_values.
      rs_vehilce_attr-m_autom_kupplung_vorhanden = ls_char_values-value_char. CLEAR: ls_char_values.
      " ETCS
      READ TABLE <ls_details>-valueschar WITH KEY charact = 'R_ETCS' INTO ls_char_values."

      rs_vehilce_attr-m_etcs  = COND #( WHEN ls_char_values-value_neutral = 'NON' THEN  'FALSE'
                                WHEN ls_char_values-value_neutral = ' ' THEN  'FALSE'
                                ELSE 'TRUE' ).
*      RS_VEHILCE_ATTR-M_ETCS = LS_CHAR_VALUES-VALUE_CHAR. CLEAR: LS_CHAR_VALUES."OPTREAL-162


      "ZAHLEN WERTE
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_LAENGE_UEBER_PUFFER_LUEP' INTO ls_num_values.
      rs_vehilce_attr-m_laenge_ueber_puffer_luep = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_VMAX_ALLEINFAHREND' INTO ls_num_values.
      rs_vehilce_attr-m_vmax_alleinfahrend = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_VMAX_GESCHLEPPT' INTO ls_num_values.
      rs_vehilce_attr-m_vmax_geschleppt = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_VMAX_RUECKWAERTS' INTO ls_num_values. "OPTREAL-259
      rs_vehilce_attr-m_vmax_rueckwaerts = ls_num_values-value_from. CLEAR: ls_num_values.          "OPTREAL-259
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_EIGENGEWICHT_TARA' INTO ls_num_values.
      rs_vehilce_attr-m_eigengewicht_tara = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_THERM_MOTOR_GESAMTLEISTUNG' INTO ls_num_values.
      rs_vehilce_attr-m_therm_motor_gesamtleistung = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_THERM_MOTOR_ANZAHL' INTO ls_num_values.
      rs_vehilce_attr-m_therm_motor_anzahl = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_EL_MOTOR_ANZAHL' INTO ls_num_values.
      rs_vehilce_attr-m_el_motor_anzahl = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_ROTATIONSBEIWERT' INTO ls_num_values.
      rs_vehilce_attr-m_rotationsbeiwert = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_BREMSHUNDERTSTEL' INTO ls_num_values.
      rs_vehilce_attr-m_bremshundertstel = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_EL_MOTOR_GESAMTLEISTUNG' INTO ls_num_values.
      rs_vehilce_attr-m_el_motor_gesamtleistung = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_EL_ANFAHRZUGKRAFT_MAX' INTO ls_num_values.
      rs_vehilce_attr-m_el_anfahrzugkraft_max = ls_num_values-value_from. CLEAR: ls_num_values.
      READ TABLE <ls_details>-valuesnum WITH KEY charact = 'R_THERM_ANFAHRZUGKRAFT_MAX' INTO ls_num_values.
      rs_vehilce_attr-m_therm_anfahrzugkraft_max = ls_num_values-value_from. CLEAR: ls_num_values.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_parameter.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_PARAMETER
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    "LESEN DER PARAMETERTABELLE

    DATA: ls_parameter TYPE zia_2tremola_par.

    ##WARN_OK SELECT SINGLE * FROM zia_2tremola_par INTO ls_parameter.

    me->gs_parameter-target = ls_parameter-target.
    me->gs_parameter-symmetric = ls_parameter-symmetric.
    me->gs_parameter-multiple_coupling = ls_parameter-multiplecoupling.
    me->gs_parameter-max_speed_forwards_fs = ls_parameter-maxspeedforwardsfs.
    me->gs_parameter-max_speed_backwards_fs = ls_parameter-maxspeedbackwardsfs.
    me->gs_parameter-max_speed_sh = ls_parameter-maxspeedsh.
    me->gs_parameter-slow_speed_sh = ls_parameter-slowspeedsh.
    me->gs_parameter-headway = ls_parameter-headway.
    me->gs_parameter-section_blocking = ls_parameter-sectionblocking.
    me->gs_parameter-section_deblocking = ls_parameter-sectiondeblocking.
    me->gs_parameter-section_entering = ls_parameter-sectionentering.
    me->gs_parameter-section_leaving = ls_parameter-sectionleaving.
    me->gs_parameter-axle_counter_reset = ls_parameter-axlecounterreset.
    me->gs_parameter-catenary_stop = ls_parameter-catenarystop.
    me->gs_parameter-catenary_activation = ls_parameter-catenaryactivation.
    me->gs_parameter-automatic_coupling = ls_parameter-automaticcoupling.
    me->gs_parameter-automatic_decoupling = ls_parameter-automaticdecoupling.
    me->gs_parameter-manual_coupling = ls_parameter-manualcoupling.
    me->gs_parameter-manual_decoupling = ls_parameter-manualdecoupling.
    me->gs_parameter-release_trip = ls_parameter-releasetrip.
    me->gs_parameter-max_train_length = ls_parameter-maxtrainlength.
    me->gs_parameter-run_time_reserve = ls_parameter-runtimereserve.
    me->gs_parameter-max_calc_time = ls_parameter-maxcalctime.

    DATA(lo_parameter) = me->go_schicht->get_parameter( ).

    IF lo_parameter IS NOT INITIAL AND lo_parameter->get_data( ) IS NOT INITIAL.
      me->gs_parameter-met_setup_time = lo_parameter->get_data( )-abzug_met.
    ELSE.
      me->gs_parameter-met_setup_time = 0. " or whatever default you need
    ENDIF.
    "    ME->MS_PARAMETER-MET_SETUP_TIME = LS_PARAMETER-MET_SETUP_TIME."RGBT-1026 SCHICHTPARAMETER LESEN NICHT AUS PARAMETERTABELLE NUR BEI MET?
*    me->gs_parameter-met_setup_time = me->go_schicht->get_parameter( )->get_data( )-abzug_met. "RGBT-1026 TABELLE ZIO_PARAMS

    gs_output-scenario-parameters = me->gs_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_PARAMETER_SHIFT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_parameter_shift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_PARAMETER_SHIFT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    DATA: lv_max_dist_fs_fahrt TYPE numc2,
          lv_shift             TYPE zia_2_layer.


    lv_shift = me->go_schicht->get_data( )-zschicht.
    IF lv_shift IS INITIAL.
      lv_shift = 0.
    ENDIF.
    "LESEN SCHICHTPARAMETER
    SELECT SINGLE max_dist_fs_fahrt FROM zia_2sf_params INTO lv_max_dist_fs_fahrt WHERE zschicht = lv_shift.
    me->gs_parameter-max_reverse_distance = lv_max_dist_fs_fahrt. "ME->MS_PARAMETER-MAX_CALC_TIME
    gs_output-scenario-parameters = me->gs_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DREHBUCH                    TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD read_shift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_SHIFT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*

   IF gs_train_routes IS INITIAL.
     read_train_routes( ).
   ENDIF.

   DATA(ls_schicht) = go_schicht->get_data( ).
   DATA(lv_sperrabschnitt) = go_schicht->get_rj_est( ).

   initialize_shift_data( is_schicht = ls_schicht
                          iv_sperrabschnitt = lv_sperrabschnitt ).

   read_parameter_shift( ).

   CLEAR: gs_shift-job_sites, gs_shift-rolling_stock.
   SELECT * FROM zia_2sf_ez_form INTO TABLE @DATA(lt_zio_ez_form) WHERE zschicht = @gs_shift-id.

   DATA(li_arbeitsstelle_i) = go_schicht->get_arbeitsstellen( )->get_values_iterator( ).
   WHILE li_arbeitsstelle_i->has_next( ).
     DATA(lo_arbeitsstelle) = CAST zcl_ia_2wrkplace( li_arbeitsstelle_i->get_next( ) ).
     DATA(lv_as_sperrabschnitt) = lo_arbeitsstelle->get_rj_est( ).
     DATA(ls_arbeitsstelle) = lo_arbeitsstelle->get_data( ).
     CHECK ( lo_arbeitsstelle->get_auftraege( )->size( ) GT 0 OR lo_arbeitsstelle->has_met( ) ) AND NOT lo_arbeitsstelle->is_btg( ) AND NOT ( lo_arbeitsstelle->is_in_os_nord( ) OR lo_arbeitsstelle->is_in_os_sued( ) ).
     IF lo_arbeitsstelle->is_pneu( ).
       CHECK go_schicht->has_arbeitsstellen_in_tunnel( iv_eiz = ls_arbeitsstelle-zid_eiz iv_skip_strasse = abap_true ).
     ENDIF.
     adjust_km_by_spabschnitt( EXPORTING iv_sperrabschnitt = lv_as_sperrabschnitt io_arbeitsstelle = lo_arbeitsstelle CHANGING cv_km_min = ls_arbeitsstelle-zkmin cv_km_max = ls_arbeitsstelle-zkmax ).
     DATA(lt_needed_vehicle_type) = build_needed_vehicle_types( lo_arbeitsstelle ).
     DATA(ls_job_site) = build_job_site( io_arbeitsstelle = lo_arbeitsstelle
                                        is_schicht = ls_schicht
                                        it_needed_vehicle_type = lt_needed_vehicle_type
                                        it_zio_ez_form = lt_zio_ez_form ).
     APPEND ls_job_site TO gs_shift-job_sites-job_site.
   ENDWHILE.

   gs_output-scenario-shift = gs_shift.
 ENDMETHOD.                                               "#EC CI_CYCLO


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_TRACK_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_track_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_TRACK_SECTIONS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA(lv_sp) = VALUE zia_2_roehre( ).   ">001< (+)

    CLEAR gs_track_sections-track_section[].

    DATA(lv_perimeter) = go_schicht->get_data( )-zzperi.
    DATA(lv_est) = go_schicht->get_rj_est( ).
    lv_sp = COND #( WHEN strlen( lv_est ) >= 2 THEN lv_est(1) ELSE lv_est ).  ">001< (+)

    SELECT * FROM zia_2sc INTO TABLE @DATA(lt_sa)
      WHERE zzperi = @lv_perimeter
        AND zest = @lv_sp.

    LOOP AT lt_sa ASSIGNING FIELD-SYMBOL(<ls_sa>).
      APPEND VALUE #( begin = <ls_sa>-km_von
                      end = <ls_sa>-km_bis
                      track_number = <ls_sa>-zsa
                      block_sector = <ls_sa>-zest
                      entry_direction = <ls_sa>-einfahrtrichtung
             ) TO gs_track_sections-track_section.
    ENDLOOP.

    gs_output-scenario-track_sections = gs_track_sections.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->READ_TRAIN_ROUTES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD read_train_routes.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : READ_TRAIN_ROUTES
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
   DATA : lv_time_stamp         TYPE timestamp,
##NEEDED           lv_time_eiz           TYPE timestamp,
##NEEDED           lv_eiz_time_portal    TYPE timestamp,
##NEEDED           lv_tunnel_time_portal TYPE timestamp.
   TYPES: BEGIN OF ts_data,
            ls_schicht TYPE  zia_2wrkshifts_s,
            lv_est     TYPE zia_2_blocking_section,
            lv_schicht TYPE zia_2_workshift,
          END OF ts_data.
   DATA      ls_data          TYPE ts_data.
   ls_data = VALUE #( ls_schicht = go_schicht->get_data( )
                         lv_est = go_schicht->get_rj_est( )
                         lv_schicht = go_schicht->get_id( ) ).

*
*    DATA(LS_SCHICHT) = GO_SCHICHT->GET_DATA( ).
*    ##NEEDED    DATA(LV_EST) = GO_SCHICHT->GET_RJ_EST( ).
*--------------------------------------------------------------------------------------------------------------------
*   BERÜCKSICHTIGUNG SOMMER- WINTERZEIT
*--------------------------------------------------------------------------------------------------------------------
   ##NEEDED    get_timezone( EXPORTING iv_schicht_date      = ls_data-ls_schicht-start_datum
                     IMPORTING ev_timezone_tremola  = DATA(lv_timezone_tremola)
                               ev_timezone_ergebnis = DATA(lv_timezone_ergebnis) ).

**--------------------------------------------------------------------------------------------------------------------
**   MANUELLE ÄNDERUNGEN LESEN (FÜR ZUSATZ USE_ROUTE BEFÜLLEN)
**--------------------------------------------------------------------------------------------------------------------
*    DATA(LV_SCHICHT) = GO_SCHICHT->GET_ID( ).
   SELECT * FROM zia_2sf_ez_form INTO TABLE @DATA(lt_ez_form_ma) WHERE zschicht = @ls_data-lv_schicht.

   DATA(lt_trassen_fpl) = select_trassen_fpl( iv_start_signal  = abap_true
                                              iv_tremola_start = abap_true ).

   SORT lt_trassen_fpl BY zugnummer ASCENDING
                          einfahrt ASCENDING
                          reihenfolge ASCENDING.


*-----------------------------------------------------------------------------------------------------------------------------------
* TREMOLA EIZTIMEPORTAL, TIMEEIZ UND TUNNELTIMEPORTAL BEI ALLEN TRASSEN BEFÜLLEN OPTREAL-163
*------------------------------------------------------------------------------------------------------------------------------------->>>>>>

   DATA(lt_trassen_fpl_eiz) = select_trassen_fpl( iv_start_signal  = abap_false
                                                  iv_tremola_start = abap_false ).

   SORT lt_trassen_fpl_eiz BY zugnummer ASCENDING
                              zeiz ASCENDING
                              einfahrt ASCENDING
                              reihenfolge ASCENDING.

   "AUFBEREITEN DER ABFAHRTEN UND ANKÜNFTE AM SIGNAL VOR DEM TUNNELPORTAL
   LOOP AT lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl>).

     APPEND INITIAL LINE TO gs_train_routes-train_route ASSIGNING FIELD-SYMBOL(<ls_train_route>).

     DATA(lv_temp_date) = ls_data-ls_schicht-start_datum.

*--------------------------------------------------------------------------------------------------------------------
* OPTREAL-163 ERWEITERUNG GRAFISCHER FAHRPLAN TREMOLA
* DIE ANKUNFT UND ABFAHRT BEIM TUNNEL WERDEN ÜBER DIE BEIDEN ATTRIBUTE "EIZTIMEPORTAL" UND "TUNNELTIMEPORTAL" DEFINIERT.
* DIESE ATTRIBUTE BEFINDEN SICH IM ELEMENT TRAINROUTE
* BEI DER EINFAHRT IN DEN TUNNEL:   EIZTIMEPORTAL -> TUNNELTIMEPORTAL
* BEI DER AUSFAHRT AUS DEM TUNNEL:  TUNNELTIMEPORTAL -> EIZTIMEPORTAL
*--------------------------------------------------------------------------------------------------------------------
     READ TABLE lt_trassen_fpl_eiz TRANSPORTING NO FIELDS WITH KEY zugnummer = <ls_trassen_fpl>-zugnummer BINARY SEARCH.
     DATA(lv_index_from) = sy-tabix.

     LOOP AT lt_trassen_fpl_eiz ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl_eiz>) FROM lv_index_from. "#EC CI_NESTED
       IF <ls_trassen_fpl_eiz>-zugnummer <> <ls_trassen_fpl>-zugnummer.
         EXIT. " TO THE OUTER LOOP
       ENDIF.

*--------------------------------------------------------------------------------------------------------------------
* ZEIT AM START BERÜCKSICHIGEN
*--------------------------------------------------------------------------------------------------------------------
       lv_temp_date = COND #( WHEN <ls_trassen_fpl_eiz>-zeit_am_start_tag = abap_true THEN ls_data-ls_schicht-start_datum
                              ELSE ls_data-ls_schicht-start_datum + 1 ).

       me->get_time_info( EXPORTING is_trassen_fpl_eiz = <ls_trassen_fpl_eiz>
                                               iv_temp_date = lv_temp_date
                                               iv_timezone_tremola = lv_timezone_tremola
                                       IMPORTING ev_time_eiz = <ls_train_route>-time_eiz
                                               ev_eiz_time_portal = <ls_train_route>-eiz_time_portal
                                               ev_tunnel_time_portal = <ls_train_route>-tunnel_time_portal ).
*      ENDIF.

     ENDLOOP.
*--------------------------------------------------------------------------------------------------------------------
     <ls_trassen_fpl>-startsignal =  to_lower( <ls_trassen_fpl>-startsignal ).
     <ls_train_route>-train_number = <ls_trassen_fpl>-zugnummer.
     <ls_train_route>-place_portal = <ls_trassen_fpl>-startsignal .
     <ls_train_route>-depot = SWITCH #( <ls_trassen_fpl>-zeiz WHEN 'GBTN' THEN 'ER'
                                                   WHEN 'GBTS' THEN 'BIA'
                                                   ELSE '' ).
     ##CONDITIONAL_CONSTR_OK  <ls_train_route>-use_route = COND #( WHEN <ls_trassen_fpl>-trasse_aktiv = abap_true THEN 'TRUE'
                                                                   ELSE 'FALSE' ) .
     "--------------------------------------------------------------------------------------------------------------------
     "  MANUELLE ÄNDERUNG BEACHTEN BEI FELD USE_ROUTE
     "--------------------------------------------------------------------------------------------------------------------
     DATA(lv_eiz) = SWITCH #( <ls_trassen_fpl>-zeiz WHEN mc_eiz_gbtn THEN mc_eiz_10
                                                    WHEN mc_eiz_gbts THEN mc_eiz_20 ).

     " TRASSE AKTIV IST ARBEITSSTELLENÜBERGREIFEND, AUS DIESEM GRUND DEF. FÜR DIESEN EINTRAG IN DER TABELLE ZIO_EZ_FORM FÜR MANUELLE ÄNDERUNGEN
     " -> ARBEITSSTELLE MIT SPACE BEFÜLLT UND DEFINITION FÜR EIN- UND AUSFAHRT IMMER ABAP_FALSE
     ##WARN_OK     READ TABLE lt_ez_form_ma INTO DATA(ls_ez_form_ma) WITH KEY zugnummer = <ls_trassen_fpl>-zugnummer
                                                                     zid_eiz   = lv_eiz
                                                                     zarbstl   = space.


     IF sy-subrc = 0.
       <ls_train_route>-use_route =  COND #( WHEN ls_ez_form_ma-ez_aktiv = abap_true THEN 'FALSE' ) .
     ENDIF.


     <ls_train_route>-dep_arr = COND #( WHEN <ls_trassen_fpl>-einfahrt EQ abap_true THEN mc_departure
                                                  WHEN <ls_trassen_fpl>-ausfahrt EQ abap_true THEN mc_arrival ) .


     lv_temp_date = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag = abap_true THEN ls_data-ls_schicht-start_datum ELSE ls_data-ls_schicht-start_datum + 1 ).

     IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
       "STARTDATUM DER SCHICHT
       CASE <ls_trassen_fpl>-zeiz.
         WHEN 'GBTN'.
           IF <ls_trassen_fpl>-einfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zab INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ELSEIF <ls_trassen_fpl>-ausfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zan INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ENDIF.
         WHEN 'GBTS'.
           IF <ls_trassen_fpl>-einfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zan INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ELSEIF <ls_trassen_fpl>-ausfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zab INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ENDIF.
       ENDCASE.

     ELSE.
       "STARTDATUM DER SCHICHT +1 (FOLGETAG)
       CASE <ls_trassen_fpl>-zeiz.
         WHEN 'GBTN'.
           IF <ls_trassen_fpl>-einfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zab INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ELSEIF <ls_trassen_fpl>-ausfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zan INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ENDIF.
         WHEN 'GBTS'.
           IF <ls_trassen_fpl>-einfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zan INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ELSEIF <ls_trassen_fpl>-ausfahrt EQ abap_true.
             CONVERT DATE lv_temp_date TIME <ls_trassen_fpl>-zab INTO TIME STAMP lv_time_stamp TIME ZONE lv_timezone_tremola.
           ENDIF.
       ENDCASE.

     ENDIF.

     <ls_train_route>-tunnel_time_portal = lv_time_stamp.
     CLEAR: lv_time_stamp , lv_temp_date.

   ENDLOOP.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->SELECT_TRASSEN_FPL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGNUMMER                   TYPE        ZIA_2TRACKS-ZUGNUMMER(optional)
* | [--->] IV_REIHENFOLGE                 TYPE        ZIA_2TRACKS-REIHENFOLGE(optional)
* | [--->] IV_RICHTUNG                    TYPE        ZIA_2TRACKS-RICHTUNG(optional)
* | [--->] IV_START_SIGNAL                TYPE        ABAP_BOOL(optional)
* | [--->] IV_TREMOLA_START               TYPE        ABAP_BOOL(optional)
* | [<-()] RT_TRASSEN                     TYPE        TT_TRASSEN_FPL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_trassen_fpl.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       20.08.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    DATA lt_zugnummer_range     TYPE RANGE OF zia_2tracks-zugnummer.
    DATA lt_reihenfolge_range   TYPE RANGE OF zia_2tracks-reihenfolge.
    DATA lt_richtung_range      TYPE RANGE OF zia_2tracks-richtung.
    DATA lt_startsignal_range   TYPE RANGE OF zia_2tracks-startsignal.
    DATA lt_tremola_start_range TYPE RANGE OF zia_2tracks-tremola_start.
    DATA lt_data_origin_range   TYPE RANGE OF zia_2tracks-data_origin.
    DATA(lv_sp) = VALUE zia_2_roehre( ).

    IF iv_zugnummer IS NOT INITIAL.
      lt_zugnummer_range = VALUE #( ( sign = 'I' option = 'EQ' low = iv_zugnummer ) ).
    ENDIF.

    IF iv_reihenfolge IS NOT INITIAL.
      lt_reihenfolge_range = VALUE #( ( sign = 'I' option = 'EQ' low = iv_reihenfolge ) ).
    ENDIF.

    IF iv_richtung IS NOT INITIAL.
      lt_richtung_range = VALUE #( ( sign = 'I' option = 'EQ' low = iv_richtung ) ).
    ENDIF.

    IF iv_start_signal = abap_true.
      lt_startsignal_range = VALUE #( ( sign = 'I' option = 'NE' low = 'X' ) ).
    ENDIF.

    IF iv_tremola_start = abap_true.
      lt_tremola_start_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'X' ) ).
    ENDIF.

    ">001< + begin  "Exclude Vorlage entries
    APPEND VALUE #( sign = 'E' option = 'EQ' low = zif_ia_2_constant=>mc_data_origin-vorlage ) TO lt_data_origin_range.
    ">001< + end


    DATA(ls_schicht) = go_schicht->get_data( ).
    DATA(lv_est) = go_schicht->get_rj_est( ).
    lv_sp = COND #( WHEN strlen( lv_est ) >= 2 THEN lv_est(1) ELSE lv_est ).  ">002< (+)

    SELECT  zugnummer AS zugnummer,
            sperrabschnitt AS zest,
            zab AS zab,
            zan AS zan,
            zeiz AS zeiz,
            zug AS zug,
            betriebspunkt AS betriebspunkt,
            startsignal AS startsignal,
            gleis AS gleis,
            zeit_am_start_tag AS zeit_am_start_tag,
            einfahrt AS einfahrt,
            ausfahrt AS ausfahrt,
            reihenfolge AS reihenfolge,
            richtung AS richtung,
            tremola_start AS tremola_start,
            trasse_aktiv AS trasse_aktiv,
            zzperi AS zzperi,
            gueltig_von AS gueltig_von,
            gueltig_bis AS gueltig_bis,
            data_origin
      FROM zia_cds_c_2tracks AS trasse
##TOO_MANY_ITAB_FIELDS    INTO CORRESPONDING FIELDS OF TABLE @rt_trassen
    WHERE zzperi = @ls_schicht-zzperi
    AND gueltig_von <= @ls_schicht-start_datum
    AND gueltig_bis >= @ls_schicht-start_datum
    AND zugnummer IN @lt_zugnummer_range[]
    AND reihenfolge IN @lt_reihenfolge_range[]
    AND richtung IN @lt_richtung_range[]
    AND sperrabschnitt = @lv_sp
    AND startsignal IN @lt_startsignal_range[]
    AND tremola_start IN @lt_tremola_start_range[]
    AND data_origin   IN @lt_data_origin_range.
    " sort

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->LOAD_API_RESPONSE_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_PROCESS                     TYPE        ZXI_1PROCESS_TYPE_TAB
* | [<---] ET_FORMATION                   TYPE        ZXI_1FORMATION_TYPE_TAB
* | [<---] ET_PART_FORMATION              TYPE        ZXI_1PART_FORMATION_TYPE_TAB
* | [<---] ET_JOB_SITES                   TYPE        ZXI_1JOB_SITE_OUTPUT_TYPE_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD load_api_response_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Retrieve train composition data for each workplace                   *
* during the shift by using Tremola EZ form data,                      *
* and send it to the process order (PO).
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    et_process        = me->gs_response-calculate_timetable_return-shift-processes-process.
    et_formation      = me->gs_response-calculate_timetable_return-shift-formations-formation.
    et_part_formation = me->gs_response-calculate_timetable_return-shift-part_formations-part_formation.
    et_job_sites      = me->gs_response-calculate_timetable_return-shift-job_sites-job_site.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->ENRICH_TRASSEN_FPL
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_TRASSEN_FPL                 TYPE        TT_TRASSEN_FPL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD enrich_trassen_fpl.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
* Retrieve train composition data for each workplace                   *
* during the shift by using Tremola EZ form data,                      *
* and send it to the process order (PO).
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    FIELD-SYMBOLS: <ls_trassen_fpl>   TYPE zcl_ia_2tremola=>ts_trassen_fpl,
                   <ls_zug_zeiten_ef> TYPE zcl_ia_2tremola=>ts_trassen_fpl,
                   <ls_zug_zeiten_af> TYPE zcl_ia_2tremola=>ts_trassen_fpl.

    LOOP AT ct_trassen_fpl ASSIGNING <ls_trassen_fpl>.
      " Skip manual entries
      CHECK <ls_trassen_fpl>-data_origin <> zif_ia_2_constant=>mc_data_origin-manual.

      " Get all entries for same train number
      DATA(lt_trassen_fpl_zug) = select_trassen_fpl(
                                    iv_zugnummer     = <ls_trassen_fpl>-zugnummer
                                    iv_start_signal  = abap_false
                                    iv_tremola_start = abap_false ).

      " For Arrivals (Einfahrt): take first entry (smallest Reihenfolge)
      IF <ls_trassen_fpl>-einfahrt = abap_true.
        SORT lt_trassen_fpl_zug BY reihenfolge ASCENDING. "#EC CI_SORTLOOP
        READ TABLE lt_trassen_fpl_zug ASSIGNING <ls_zug_zeiten_ef> INDEX 1.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING <ls_zug_zeiten_ef> TO <ls_trassen_fpl>.
        ENDIF.
      ENDIF.

      " For Departures (Ausfahrt): take last entry (largest Reihenfolge)
      IF <ls_trassen_fpl>-ausfahrt = abap_true.
        SORT lt_trassen_fpl_zug BY reihenfolge DESCENDING. "#EC CI_SORTLOOP
        READ TABLE lt_trassen_fpl_zug ASSIGNING <ls_zug_zeiten_af> INDEX 1.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING <ls_zug_zeiten_af> TO <ls_trassen_fpl>.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->BUILD_EZ_ENTRIES_FROM_PROC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_PROCESSES                   TYPE        ZXI_1PROCESS_TYPE_TAB
* | [--->] IT_FORMATIONS                  TYPE        ZXI_1FORMATION_TYPE_TAB(optional)
* | [--->] IT_JOB_SITES                   TYPE        ZXI_1JOB_SITE_OUTPUT_TYPE_TAB(optional)
* | [--->] IT_TRASSEN_FPL                 TYPE        ZCL_IA_2TREMOLA=>TT_TRASSEN_FPL(optional)
* | [--->] IT_EZ_FORM_MA                  TYPE        TT_2SF_EZ_FORM(optional)
* | [--->] IS_SCHICHT                     TYPE        ZIA_2WRKSHIFTS_S(optional)
* | [<-->] CT_EZ_FORM                     TYPE        ZIA_2_EZ_FORM_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD build_ez_entries_from_proc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*----------------------------------------------------------------------*
* >000<   7.50       25.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA: lv_train_number    TYPE string,
*          ls_process         TYPE zxi_1coprocess_type,
*          ls_process_search  TYPE zxi_1coprocess_type,
*          ls_process_treffer TYPE zxi_1coprocess_type,

          ls_process         TYPE zxi_1process_type,
          ls_process_search  TYPE zxi_1process_type,
          ls_process_treffer TYPE zxi_1process_type,

*          lt_process_search  TYPE zxi_1coprocess_type_tab,
*          lt_process_treffer TYPE zxi_1coprocess_type_tab,

          lt_process_search  TYPE zxi_1process_type_tab,
          lt_process_treffer TYPE zxi_1process_type_tab,

*          ls_formation       TYPE zxi_1coformation_type,
          ls_formation       TYPE zxi_1formation_type,

*          lt_part            TYPE TABLE OF zxi_1coos_tunnel_maint_d3,
          lt_part            TYPE TABLE OF zxi_1formation_type_parts,
*          ls_part            TYPE zxi_1coos_tunnel_maint_d3,
          ls_part            TYPE zxi_1formation_type_parts,
          ls_job_site        TYPE zxi_1job_site_output_type,
  ##NEEDED ls_trassen_fpl     TYPE zcl_ia_2tremola=>ts_trassen_fpl,
          ls_ez_form         TYPE zia_2_ez_form_wd_s,
          ls_ez_form_ma      TYPE zia_2sf_ez_form.

    FIELD-SYMBOLS: <ls_trasse> TYPE zcl_ia_2tremola=>ts_trassen_fpl.

    DATA(lt_processes_local) = it_processes.
    SORT lt_processes_local BY train_number ASCENDING.

    LOOP AT it_processes INTO ls_process.
      CLEAR lt_process_treffer.

      " Avoid duplicates
      IF ls_process-train_number <> lv_train_number.
        " Match trassen
        ##WARN_OK READ TABLE it_trassen_fpl INTO ls_trassen_fpl WITH KEY zugnummer = ls_process-train_number.
        IF sy-subrc = 0.

          " Filter for relevant process entries
          LOOP AT lt_process_search INTO ls_process_search. "#EC CI_NESTED
            IF ls_process-train_number = ls_process_search-train_number AND
               ls_process-formation_id(2) = 'EZ'.
              APPEND ls_process_search TO lt_process_treffer.
            ENDIF.
          ENDLOOP.

          " Select entry by direction
          IF ls_process-trip_type = 'Arr'.
            SORT lt_process_treffer BY start-time ASCENDING. "#EC CI_SORTLOOP
          ELSEIF ls_process-trip_type = 'Dep'.
            SORT lt_process_treffer BY start-time DESCENDING. "#EC CI_SORTLOOP
          ENDIF.

          READ TABLE lt_process_treffer INTO ls_process_treffer INDEX 1.
          IF sy-subrc = 0.
            ls_process = ls_process_treffer.
          ENDIF.

          " Get formation details
          READ TABLE it_formations INTO ls_formation WITH KEY id = ls_process-formation_id.
          IF sy-subrc = 0.
            lt_part = ls_formation-parts.

            LOOP AT lt_part INTO ls_part.                "#EC CI_NESTED
              CLEAR ls_ez_form.

              " Match job site
              READ TABLE it_job_sites INTO ls_job_site WITH KEY part_formation_id = ls_part-part_formation_id.
              IF sy-subrc = 0.
                ls_ez_form-zarbstl = ls_job_site-id.

                " Determine EIZ ID
                IF ls_part-part_formation_id CS 'BI'.
                  ls_ez_form-zid_eiz = mc_eiz_20.
                ELSE.
                  ls_ez_form-zid_eiz = mc_eiz_10.
                ENDIF.

                ls_ez_form-zschicht = is_schicht-zschicht.
                ls_ez_form-zugnummer = ls_process-train_number.
                ls_ez_form-ez_aktiv = abap_true.

                IF ls_process-trip_type = 'Arr'.
                  ls_ez_form-einfahrt = abap_true.
                  ls_ez_form-ausfahrt = abap_false.
                  ls_ez_form-richtung = zif_ia_2_trasse=>mc_richtung_einfahrt.
                ELSEIF ls_process-trip_type = 'Dep'.
                  ls_ez_form-ausfahrt = abap_true.
                  ls_ez_form-einfahrt = abap_false.
                  ls_ez_form-richtung = zif_ia_2_trasse=>mc_richtung_ausfahrt.
                ENDIF.
                .
                " Check for manual override
                ##WARN_OK READ TABLE it_ez_form_ma INTO ls_ez_form_ma WITH KEY
                                    zugnummer = ls_process-train_number
                                    zarbstl   = ls_job_site-id
                                    zid_eiz   = ls_ez_form-zid_eiz
                                    richtung  = ls_ez_form-richtung
                                    ez_aktiv  = abap_true.

                IF sy-subrc = 0.
                  ls_ez_form-has_changed = abap_true.
                  ls_ez_form-ez_aktiv = ls_ez_form_ma-ez_aktiv.
                  ls_ez_form-manually_created = COND #( WHEN ls_ez_form_ma-data_origin = zif_ia_2_constant=>mc_data_origin-manual
                                                        THEN abap_true ELSE abap_false ).
                ENDIF.

                ##WARN_OK       READ TABLE it_trassen_fpl ASSIGNING <ls_trasse> WITH KEY zugnummer = ls_process-train_number.
                IF sy-subrc = 0.
                  ls_ez_form-fahrtzeit = COND #( WHEN <ls_trasse>-zab IS NOT INITIAL THEN <ls_trasse>-zab ELSE <ls_trasse>-zan ).
                  ls_ez_form-manually_created = COND #( WHEN <ls_trasse>-data_origin = zif_ia_2_constant=>mc_data_origin-manual
                                                        THEN abap_true ELSE ls_ez_form-manually_created ).
                  ls_ez_form-zeit_am_start_tag = <ls_trasse>-zeit_am_start_tag.
                ENDIF.

                APPEND ls_ez_form TO ct_ez_form.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.

      lv_train_number = ls_process-train_number.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_FAHRPLAN_IMAGE
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_IMAGE                       TYPE        STRING
* | [<-()] RV_IMAGE                       TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD get_fahrplan_image.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRPLAN_IMAGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

   ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'SSFC_BASE64_DECODE'
     EXPORTING
       b64data = gs_response-calculate_timetable_return-graphical_time_table
     IMPORTING
       bindata = rv_image.

   DATA(li_cached_response) = CAST if_http_response( NEW cl_http_response( add_c_msg = 1 ) ).

   li_cached_response->set_data( rv_image ).
   li_cached_response->set_header_field( name = if_http_header_fields=>content_type value = 'IMAGE/PJPEG' ).
   li_cached_response->set_status( code = 200 reason = 'OK' ).
   li_cached_response->server_cache_expire_rel( expires_rel = 180 ).

   TRY.
       DATA(lv_guid32) = cl_system_uuid=>create_uuid_c32_static( ).
     CATCH cx_uuid_error INTO DATA(lx_uuid_error).
       MESSAGE lx_uuid_error->get_text( ) TYPE 'E'.
       RETURN.
   ENDTRY.

   cl_wd_utilities=>construct_wd_url(
     EXPORTING application_name = 'ZIA_WDC_2SHIFT_PLANNING'
     IMPORTING out_absolute_url = ev_image ).

   CONCATENATE ev_image '/' lv_guid32 sy-uzeit INTO ev_image.

* Write the object to the cache
   DATA(lv_vhost) = 0.
   cl_http_server=>server_cache_upload(
     url          = ev_image
     response     = li_cached_response
     scope        = ihttp_inv_global
     virtual_host = lv_vhost ).

 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->INVOKE_WEBSERVICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_UPDATE_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD invoke_webservice.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : INVOKE_WEBSERVICE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       15.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  invalidate_response( ).

  go_tremola_service->os_tremola_tunnel_maintenance( EXPORTING input  = gs_output
                                                 IMPORTING output = gs_response  ).
  CHECK has_valid_response( ).

  IF iv_update_db = abap_true.
    transform_and_update_db( ).
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->TRANSFORM_AND_UPDATE_DB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD transform_and_update_db.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : INVOKE_WEBSERVICE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.02.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of Method
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*


*    DATA(ls_tremola_data) = VALUE zio_5_tremola( ).
    DATA(ls_tremola_data) = VALUE zia_2tremola_dat( ).

    CALL TRANSFORMATION ('ID') SOURCE request = gs_output RESULT XML ls_tremola_data-request.
    CALL TRANSFORMATION ('ID') SOURCE response = gs_response RESULT XML ls_tremola_data-response.

    ls_tremola_data-schicht = go_schicht->get_id( ).

    MODIFY zia_2tremola_dat FROM ls_tremola_data.

    gs_request = gs_output.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->CALCULATE_AND_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TESTMODE                    TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RT_MESSAGES                    TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_and_save.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : INVOKE_WEBSERVICE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.02.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of Method
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lv_msg) = ``.

***    DATA(lo_message_container) = zcl_se_8fact_log_a=>get_message_container( ).
    DATA(lt_bapiret)   = VALUE bapiret2_t( ).

    "    IF mo_schicht->is_joker( ).             >001< (-) begin
    "MESSAGE e019(zio_3_mmt) INTO lv_msg.
    "lo_message_container->add_symsg( ).

    "    ELSE.                                   >001< (-) end

    TRY .
        IF NOT has_valid_response( ).
          invoke_webservice( ).
        ENDIF.
        get_log( IMPORTING ev_technical_log  = DATA(lv_log_tech)
                           ev_functional_log = DATA(lv_log_func)
                           ev_calc_success   = DATA(lv_success) ).

        IF lv_log_tech IS NOT INITIAL AND iv_testmode = abap_true.
***          lo_message_container->add_bapiret_message( VALUE #( message = lv_log_tech type = 'E' ) ).
          lt_bapiret = VALUE #( BASE lt_bapiret ( type = 'E' message = lv_log_tech ) ).
        ENDIF.

        IF lv_log_func IS NOT INITIAL.
***          lo_message_container->add_bapiret_message( VALUE #( message = lv_log_func type = 'E' ) ).
          lt_bapiret = VALUE #( BASE lt_bapiret ( type = 'E' message = lv_log_func ) ).
        ENDIF.

        IF lv_success = abap_true.
          MESSAGE s088(zia_2_real) INTO lv_msg.
        ELSE.
          MESSAGE e086(zia_2_real) INTO lv_msg.
        ENDIF.
***        lo_message_container->add_symsg( ).
        lt_bapiret = VALUE #( BASE lt_bapiret ( type = sy-msgty id = sy-msgid number = sy-msgno message = lv_msg ) ).

        IF lv_success = abap_true.
***          set_calculation_to_schicht( ).

          go_schicht->save( ).
          go_schicht->save_ez_form( ).

          COMMIT WORK.
        ENDIF.


      CATCH cx_no_check. "#EC NEED_CX_ROOT                                  "#EC NEED_CX_ROOT
        MESSAGE e086(zia_2_real) INTO lv_msg.
***        lo_message_container->add_symsg( ).
***        lo_message_container->add_exception( ix_error = lx_error ).
        lt_bapiret = VALUE #( BASE lt_bapiret ( type = sy-msgty id = sy-msgid number = sy-msgno message = lv_msg ) ).
    ENDTRY.

    "    ENDIF. >001< (-)

***    rt_messages = lo_message_container->get_bapiret_messages( ).
    rt_messages = lt_bapiret.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->ADJUST_KM_BY_SPABSCHNITT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_ROEHRE
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [<-->] CV_KM_MIN                      TYPE        ZIA_2_KM_VON
* | [<-->] CV_KM_MAX                      TYPE        ZIA_2_KM_BIS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD adjust_km_by_spabschnitt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : ADJUST_KM_BY_SPABSCHNITT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       29.06.2026     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    IF io_arbeitsstelle IS NOT BOUND.
      RETURN.
    ENDIF.

    ">001< (+) begin
    DATA(lt_sp_km) = io_arbeitsstelle->get_sperrabschnitte_km( ).
    DELETE lt_sp_km WHERE sperrabschnitt <> iv_sperrabschnitt.
    SORT lt_sp_km BY zkmin ASCENDING.
    cv_km_min = VALUE #( lt_sp_km[ 1 ]-zkmin OPTIONAL ).
    SORT lt_sp_km BY zkmax DESCENDING.
    cv_km_max = VALUE #( lt_sp_km[ 1 ]-zkmax OPTIONAL ).
    ">001< (+) end

    IF cv_km_min IS INITIAL OR
       cv_km_max IS INITIAL.
      DATA(li_sp_km_i) = io_arbeitsstelle->get_sp_kilometer( )->get_values_iterator( ).
      WHILE li_sp_km_i->has_next( ).
        DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( li_sp_km_i->get_next( ) ).
        CHECK lo_sp_km->get_sp( ) = iv_sperrabschnitt.
        cv_km_min = lo_sp_km->get_zkmin( ).
        cv_km_max = lo_sp_km->get_zkmax( ).
        RETURN.
      ENDWHILE.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_LOG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_TECHNICAL_LOG               TYPE        STRING
* | [<---] EV_FUNCTIONAL_LOG              TYPE        STRING
* | [<---] EV_CALC_SUCCESS                TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_log.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : INVOKE_WEBSERVICE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.02.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of Method
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

*   Falls ein Bild erstellt wurde, hat die Berechnung funktioniert.
    ev_calc_success = boolc( gs_response-calculate_timetable_return-graphical_time_table IS NOT INITIAL ).

    SPLIT gs_response-calculate_timetable_return-log AT '###' INTO TABLE DATA(lt_log).

    IF lines( lt_log ) EQ 1.
      READ TABLE lt_log INTO ev_technical_log INDEX 1. "technischer Fehler
    ELSE.
      READ TABLE lt_log INTO ev_functional_log INDEX 1. "anwendergerechter Fehler
      READ TABLE lt_log INTO ev_technical_log INDEX 2. "technischer Fehler
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_TIME_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_TRASSEN_FPL_EIZ             TYPE        TS_TRASSEN_FPL
* | [--->] IV_TEMP_DATE                   TYPE        DATS
* | [--->] IV_TIMEZONE_TREMOLA            TYPE        TIMEZONE
* | [<---] EV_TIME_EIZ                    TYPE        TIMESTAMP
* | [<---] EV_EIZ_TIME_PORTAL             TYPE        TIMESTAMP
* | [<---] EV_TUNNEL_TIME_PORTAL          TYPE        TIMESTAMP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_time_info.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : GET_TIME_INFO
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
    DATA:
##NEEDED    lv_time_eiz           TYPE timestamp,
##NEEDED    lv_eiz_time_portal    TYPE timestamp,
##NEEDED    lv_tunnel_time_portal TYPE timestamp.

    IF is_trassen_fpl_eiz-zeiz = 'GBTN'.
      IF is_trassen_fpl_eiz-einfahrt = abap_true. "EINFAHRT
        CASE is_trassen_fpl_eiz-reihenfolge.
          WHEN '1'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zab INTO TIME STAMP lv_time_eiz TIME ZONE iv_timezone_tremola.
            ev_time_eiz = lv_time_eiz.
          WHEN '2'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zan INTO TIME STAMP lv_eiz_time_portal TIME ZONE iv_timezone_tremola.
            ev_eiz_time_portal = lv_eiz_time_portal.
          WHEN '3'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zab INTO TIME STAMP lv_tunnel_time_portal TIME ZONE iv_timezone_tremola.
            ev_tunnel_time_portal = lv_tunnel_time_portal.
        ENDCASE.
      ELSE. "AUSFAHRT
        CASE is_trassen_fpl_eiz-reihenfolge.
          WHEN '3'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zan INTO TIME STAMP lv_time_eiz TIME ZONE iv_timezone_tremola.
            ev_time_eiz = lv_time_eiz.
          WHEN '2'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zab INTO TIME STAMP lv_eiz_time_portal TIME ZONE iv_timezone_tremola.
            ev_eiz_time_portal = lv_eiz_time_portal.
          WHEN '1'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zan INTO TIME STAMP lv_tunnel_time_portal TIME ZONE iv_timezone_tremola.
            ev_tunnel_time_portal = lv_tunnel_time_portal.
        ENDCASE.
      ENDIF.
    ELSE.
      IF is_trassen_fpl_eiz-einfahrt = abap_true. "EINFAHRT
        CASE is_trassen_fpl_eiz-reihenfolge.
          WHEN '1'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zab INTO TIME STAMP lv_time_eiz TIME ZONE iv_timezone_tremola.
            ev_time_eiz = lv_time_eiz.
          WHEN '2'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zan INTO TIME STAMP lv_eiz_time_portal TIME ZONE iv_timezone_tremola.
            ev_eiz_time_portal = lv_eiz_time_portal.
            ev_tunnel_time_portal = lv_eiz_time_portal.
        ENDCASE.
      ELSE. "AUSFAHRT
        CASE is_trassen_fpl_eiz-reihenfolge.
          WHEN '2'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zan INTO TIME STAMP lv_time_eiz TIME ZONE iv_timezone_tremola.
            ev_time_eiz = lv_time_eiz.
          WHEN '1'.
            CONVERT DATE iv_temp_date TIME is_trassen_fpl_eiz-zab INTO TIME STAMP lv_eiz_time_portal TIME ZONE iv_timezone_tremola.
            ev_eiz_time_portal = lv_eiz_time_portal.
            ev_tunnel_time_portal = lv_eiz_time_portal.
        ENDCASE.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->BUILD_JOB_SITE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_SCHICHT                     TYPE        ZIA_2WRKSHIFTS_S
* | [--->] IT_NEEDED_VEHICLE_TYPE         TYPE        ZXI_1NEEDED_VEHICLE_TYPE_TAB
* | [--->] IT_ZIO_EZ_FORM                 TYPE        TT_2SF_EZ_FORM
* | [<-()] RS_JOB_SITE                    TYPE        ZXI_1JOB_SITE_INPUT_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD build_job_site.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_SHIFT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
  DATA(ls_arbeitsstelle) = io_arbeitsstelle->get_data( ).
  DATA(lv_sp_block_sector) = go_schicht->get_rj_est( ).

  rs_job_site-needed_vehicle = it_needed_vehicle_type.
  rs_job_site-id = ls_arbeitsstelle-zarbstl.
  rs_job_site-description = io_arbeitsstelle->get_text_id( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene ).
  rs_job_site-type = COND #( WHEN io_arbeitsstelle->is_in_tunnel( ) AND io_arbeitsstelle->is_schiene( ) THEN 'E' ELSE 'NE' ).
  rs_job_site-depot = SWITCH #( ls_arbeitsstelle-zid_eiz WHEN mc_eiz_10 THEN 'ER' WHEN mc_eiz_20 THEN 'BIA' ).
  rs_job_site-start_pos = ls_arbeitsstelle-zkmin.
  rs_job_site-end_pos = ls_arbeitsstelle-zkmax.
  rs_job_site-prio_pos = COND #( WHEN ls_arbeitsstelle-zid_eiz = mc_eiz_10 THEN ls_arbeitsstelle-zkmax ELSE ls_arbeitsstelle-zkmin ).
  rs_job_site-block_sector = COND #( WHEN lv_sp_block_sector IS NOT INITIAL THEN lv_sp_block_sector(1) ELSE '' ).

  FIELD-SYMBOLS <ls_zio_ez_form> LIKE LINE OF it_zio_ez_form.
  READ TABLE it_zio_ez_form ASSIGNING <ls_zio_ez_form> WITH KEY zarbstl = ls_arbeitsstelle-zarbstl richtung = zif_ia_2_tracks=>mc_richtung_einfahrt data_origin = abap_false.
  IF sy-subrc NE 0.
    ASSIGN it_zio_ez_form[ zarbstl = ls_arbeitsstelle-zarbstl richtung = zif_ia_2_tracks=>mc_richtung_einfahrt ] TO <ls_zio_ez_form>.
  ENDIF.
  IF <ls_zio_ez_form> IS ASSIGNED.
    rs_job_site-train_route_departure = <ls_zio_ez_form>-zugnummer.
  ENDIF.

  READ TABLE it_zio_ez_form ASSIGNING <ls_zio_ez_form> WITH KEY zarbstl = ls_arbeitsstelle-zarbstl richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt data_origin = abap_false.
  IF sy-subrc NE 0.
    ASSIGN it_zio_ez_form[ zarbstl = ls_arbeitsstelle-zarbstl richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt ] TO <ls_zio_ez_form>.
  ENDIF.
  IF <ls_zio_ez_form> IS ASSIGNED.
    rs_job_site-train_route_arrival = <ls_zio_ez_form>-zugnummer.
  ENDIF.

  IF io_arbeitsstelle->has_met( ).
    DATA(ls_met) = io_arbeitsstelle->get_met( ).
    rs_job_site-met_pos = ls_met-zkm.

    SELECT * FROM zia_2sc INTO TABLE @DATA(lt_sa)
      WHERE zzperi EQ @is_schicht-zzperi AND km_von LE @ls_met-zkm AND km_bis GE @ls_met-zkm AND zest EQ @ls_met-zzest.
    READ TABLE lt_sa INTO DATA(ls_sa) INDEX 1.

    rs_job_site-start_pos = COND #( WHEN ls_arbeitsstelle-zkmin IS NOT INITIAL THEN COND #( WHEN ls_sa-km_von <= ls_arbeitsstelle-zkmin THEN ls_sa-km_von ELSE ls_arbeitsstelle-zkmin ) ELSE ls_sa-km_von ).
    rs_job_site-end_pos = COND #( WHEN ls_arbeitsstelle-zkmax IS NOT INITIAL THEN COND #( WHEN ls_sa-km_bis <= ls_arbeitsstelle-zkmax THEN ls_arbeitsstelle-zkmax ELSE ls_sa-km_bis ) ELSE ls_sa-km_bis ).
  ENDIF.

  rs_job_site-min_time = mc_min_time.
  rs_job_site-coupling_allowed = boolc( abap_false <> abap_true ) ##BOOL_OK.
  rs_job_site-catenary_stop_needed = abap_false.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->BUILD_NEEDED_VEHICLE_TYPES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [<-()] RT_NEEDED_VEHICLE_TYPE         TYPE        ZXI_1NEEDED_VEHICLE_TYPE_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD build_needed_vehicle_types.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_SHIFT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
  DATA ls_needed_vehicle_type TYPE zxi_1needed_vehicle_type.
  DATA(ls_arbeitsstelle) = io_arbeitsstelle->get_data( ).

  DATA(li_fahrzeuge_i) = io_arbeitsstelle->get_fahrzeuge( )->get_values_iterator( ).
  WHILE li_fahrzeuge_i->has_next( ).
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).
    DATA(ls_fahrzeugtyp) = lo_fahrzeug->get_fahrzeugtyp( ).

    CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).

    ls_needed_vehicle_type-type = ls_fahrzeugtyp-zid_fztyp.
    ls_needed_vehicle_type-orientation = lo_fahrzeug->get_orientierung( iv_incl_spitzkehre = abap_false ).
    ls_needed_vehicle_type-position = lo_fahrzeug->get_reihung( ).
    APPEND ls_needed_vehicle_type TO rt_needed_vehicle_type.

    ##WARN_OK READ TABLE gs_shift-rolling_stock-vehicle_type WITH KEY type = ls_fahrzeugtyp-zid_fztyp TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.
      CONTINUE.
    ENDIF.

    DATA(ls_vehicle_attr) = read_funcloc_attriutes( iv_tplnr = ls_fahrzeugtyp-tplnr ).
    APPEND VALUE #( type = ls_fahrzeugtyp-zid_fztyp ) TO gs_shift-rolling_stock-vehicle_type ASSIGNING FIELD-SYMBOL(<ls_vehicle_type>).

    IF ls_vehicle_attr-m_el_motor_anzahl GT 0.
      APPEND VALUE #( transmission = 'E' tractive_effort = ls_vehicle_attr-m_el_anfahrzugkraft_max * 1000 power = ls_vehicle_attr-m_el_motor_gesamtleistung * 10000 ) TO <ls_vehicle_type>-propulsion.
    ENDIF.
    IF ls_vehicle_attr-m_therm_motor_anzahl GT 0.
      APPEND VALUE #( transmission = 'T' tractive_effort = ls_vehicle_attr-m_therm_anfahrzugkraft_max * 1000 power = ls_vehicle_attr-m_therm_motor_gesamtleistung * 1000 ) TO <ls_vehicle_type>-propulsion.
    ENDIF.

    <ls_vehicle_type>-length = ls_vehicle_attr-m_laenge_ueber_puffer_luep / 1000.
    <ls_vehicle_type>-max_speed = ls_vehicle_attr-m_vmax_alleinfahrend.
    <ls_vehicle_type>-towing_speed = ls_vehicle_attr-m_vmax_geschleppt.
    <ls_vehicle_type>-max_speed_backwards = ls_vehicle_attr-m_vmax_rueckwaerts.
    <ls_vehicle_type>-weight = ls_vehicle_attr-m_eigengewicht_tara.
    <ls_vehicle_type>-payload = lo_fahrzeug->get_payload( ) / 1000.
    <ls_vehicle_type>-brake_percentage = ls_vehicle_attr-m_bremshundertstel.
    <ls_vehicle_type>-automatic_coupling = boolc( ls_vehicle_attr-m_autom_kupplung_vorhanden = 'X' ).
    <ls_vehicle_type>-rotation_mass_factor = ls_vehicle_attr-m_rotationsbeiwert.
    <ls_vehicle_type>-etcs = ls_vehicle_attr-m_etcs.
  ENDWHILE.

  IF ls_arbeitsstelle-zid_eiz <> mc_eiz_10.
    RETURN.
  ENDIF.

  SORT rt_needed_vehicle_type BY position.
  DATA(lv_reihung) = lines( rt_needed_vehicle_type ).
  LOOP AT rt_needed_vehicle_type ASSIGNING FIELD-SYMBOL(<ls_temp>).
    <ls_temp>-position = lv_reihung.
    lv_reihung -= 1.
  ENDLOOP.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2TREMOLA->INITIALIZE_SHIFT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SCHICHT                     TYPE        ZIA_2WRKSHIFTS_S
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIA_2_ROEHRE
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD initialize_shift_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION : READ_SHIFT
*        CODE MIGRATED FROM - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     TCS / PRATIMA SAHU
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*
*----------------------------------------------------------------------*
  gs_shift-train_routes = gs_train_routes.
  gs_shift-id = is_schicht-zschicht.
  gs_shift-begin = is_schicht-start_datum.
  gs_shift-end = is_schicht-end_datum.
  gs_shift-tube = COND #( WHEN iv_sperrabschnitt IS NOT INITIAL THEN iv_sperrabschnitt(1) ELSE '' ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2TREMOLA->GET_TRAINS_AT_EIZ1
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ZIA_2MAP_AS_FZ              TYPE        TT_MAP_AS_FZ
* | [<---] ET_TREMOLA_VEHICLE             TYPE        ZIA_2TREMOLA_FORMATION_T
* | [<---] EV_REIHUNG_COUNT               TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_trains_at_eiz1.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_TRAINS_AT_EIZ1
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    DATA :ls_tremola_vehicle LIKE LINE OF et_tremola_vehicle,
          ls_zio_map_as_fz LIKE LINE OF it_zia_2map_as_fz,
          lt_part_formation TYPE TABLE OF zxi_1part_formation_type,
           ls_part_formation LIKE LINE OF lt_part_formation,
           lt_train_formation TYPE zia_2train_formation_t,
##NEEDED           ls_train_formation LIKE LINE OF lt_train_formation,
            ls_zio_fahrzeuge TYPE zia_2vehicles,
             lv_mime_type TYPE zia_2_fztyp_mime_pfad,
             lv_reihung_count TYPE i,
             lv_orientierung TYPE char1,
             lv_arbstelle TYPE zia_2_id_arbstl,
             lv_norden TYPE boolean,
             ##NEEDED    lv_tremola_calc TYPE boolean,
             lo_arbeitsstelle TYPE REF TO zcl_ia_2wrkplace.
*    SELECT * INTO TABLE it_zia_2map_as_fz FROM zia_2sf_wa_veh
*                               WHERE  zid_arbstl  = ls_tremola_vehicle-arbstelle.
*    lv_arbstelle = ls_tremola_vehicle-arbstelle.

    ev_reihung_count = 0.

    LOOP AT it_zia_2map_as_fz INTO ls_zio_map_as_fz.     "#EC CI_NESTED
      FREE: ls_tremola_vehicle, ls_zio_fahrzeuge.
      ls_tremola_vehicle-id = ls_zio_map_as_fz-reihung.
      " FAHRZEUGTYP ERMITTELN
      SELECT SINGLE * INTO ls_zio_fahrzeuge FROM zia_2vehicles
            WHERE zid_fzg  = ls_zio_map_as_fz-zid_fzg
              AND loekn    = space.
      ls_tremola_vehicle = VALUE #( type = COND #( WHEN sy-subrc EQ 0 THEN  ls_zio_fahrzeuge-zid_fztyp )
                                    position = ls_zio_map_as_fz-reihung
                                    orientation = ls_zio_map_as_fz-orientierung
                                    arbstelle = lv_arbstelle ).
      lo_arbeitsstelle = go_schicht->get_arbeitsstelle_by_id( iv_id = ls_tremola_vehicle-arbstelle ).

      ls_tremola_vehicle-arbstelle_txt = COND #( WHEN lo_arbeitsstelle IS NOT INITIAL THEN  lo_arbeitsstelle->get_kurztext( ) ).

      IF ls_tremola_vehicle-type IS NOT INITIAL.
        ##WARN_OK              SELECT SINGLE zfztyp_txt FROM zia_2veh_typ_t
        INTO ls_tremola_vehicle-fahrzeug_type_txt
        WHERE zid_fztyp EQ ls_tremola_vehicle-type.
      ENDIF.
      "MIME-TYPE DES FAHRZEUGTYPES ERMITTELN
      CLEAR lv_mime_type.
      lv_orientierung = ls_tremola_vehicle-orientation.
      zcl_ia_2utilities=>get_mime_pfad_by_fztyp( EXPORTING iv_fztype       = ls_tremola_vehicle-type
                                                          iv_orientierung = lv_orientierung
                                                IMPORTING ev_mime_pfad    = lv_mime_type ).
*            IF lv_mime_type IS NOT INITIAL.
*              CONCATENATE zcl_ia_2utilities=>mc_mime_pfad_images lv_mime_type INTO ls_tremola_vehicle-fahrzeug_img_mime.
*            ELSE.
*              ls_tremola_vehicle-fahrzeug_img_mime = '/SAP/BC/FP/GRAPHICS/PUBLIC/GRAPHICS/REAL/BASISFAHRZEUG.PNG'.
*            ENDIF.
      ls_tremola_vehicle-fahrzeug_img_mime =  |{ COND string(
          WHEN lv_mime_type IS NOT INITIAL THEN |{ zcl_ia_2utilities=>mc_mime_pfad_images } { lv_mime_type }  |
          ELSE '/SAP/BC/FP/GRAPHICS/PUBLIC/GRAPHICS/REAL/BASISFAHRZEUG.PNG' ) } |.

      DATA(li_mime_api) = cl_mime_repository_api=>get_api( ).
      li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-fahrzeug_img_mime
                        IMPORTING e_content = ls_tremola_vehicle-fahrzeug_img ).
      "MIME-ICON FÜR ORIENTATION
      IF ls_tremola_vehicle-orientation IS INITIAL.
        FREE: ls_tremola_vehicle-orientation_img_mime, ls_tremola_vehicle-orientation_img.
      ELSE.
        ls_tremola_vehicle-orientation_img_mime = COND #( WHEN ls_tremola_vehicle-orientation EQ 'N' THEN mc_mime_pfad_orientierung_l
         ELSE  mc_mime_pfad_orientierung_r ).


        li_mime_api = cl_mime_repository_api=>get_api( ).
        li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-orientation_img_mime
                          IMPORTING e_content = ls_tremola_vehicle-orientation_img ).
      ENDIF.
      APPEND ls_tremola_vehicle TO et_tremola_vehicle.
      lv_reihung_count = lv_reihung_count + 1.
    ENDLOOP.

    SORT et_tremola_vehicle BY position.               "#EC CI_SORTLOOP

    lv_norden = COND #( WHEN ls_part_formation-id CS 'ERSTFELD' THEN abap_true
    ELSE '' ).

    IF lv_norden EQ abap_true .

      CLEAR : lv_mime_type, ls_tremola_vehicle-fahrzeug_img_mime.


      SORT et_tremola_vehicle BY position ASCENDING.   "#EC CI_SORTLOOP

      LOOP AT et_tremola_vehicle ASSIGNING FIELD-SYMBOL(<ls_tremola_vehicle>). "#EC CI_NESTED
        <ls_tremola_vehicle>-sort_db = lv_reihung_count.
        lv_reihung_count = lv_reihung_count - 1.

      ENDLOOP.

      SORT et_tremola_vehicle BY position DESCENDING.  "#EC CI_SORTLOOP
    ENDIF.

    "-------------------------------------------------------------------------

    ls_train_formation-vehicles = et_tremola_vehicle.

  ENDMETHOD.
ENDCLASS.