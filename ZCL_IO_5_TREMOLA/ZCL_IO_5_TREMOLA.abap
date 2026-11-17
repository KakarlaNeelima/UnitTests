CLASS zcl_io_5_tremola DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPE-POOLS ihttp .

    CONSTANTS mc_data_origine TYPE zio_5_data_origin VALUE 'T' ##NO_TEXT.
    CONSTANTS mc_depot_bi TYPE string VALUE 'BI' ##NO_TEXT.
    CONSTANTS mc_depot_er TYPE string VALUE 'ER' ##NO_TEXT.
    CONSTANTS mc_eiz_10 TYPE zio_id_eiz VALUE '10' ##NO_TEXT.
    CONSTANTS mc_eiz_20 TYPE zio_id_eiz VALUE '20' ##NO_TEXT.
    CONSTANTS mc_eiz_gbtn TYPE zio_eiz VALUE 'GBTN' ##NO_TEXT.
    CONSTANTS mc_eiz_gbts TYPE zio_eiz VALUE 'GBTS' ##NO_TEXT.
    CONSTANTS mc_true TYPE string VALUE 'true' ##NO_TEXT.
    CONSTANTS mv_arrival TYPE string VALUE 'Arrival' ##NO_TEXT.
    CONSTANTS mv_departure TYPE string VALUE 'Departure' ##NO_TEXT.
    CONSTANTS mv_etcs_sh TYPE string VALUE 'SH' ##NO_TEXT.
    CONSTANTS mv_etc_mode_nl TYPE string VALUE 'NL' ##NO_TEXT.
    CONSTANTS mv_mime_pfad_orientierung_l TYPE zio_fztyp_mime_pfad VALUE '/SAP/BC/fp/graphics/PUBLIC/GRAPHICS/REAL/Dreieck_links.jpg' ##NO_TEXT.
    CONSTANTS mv_mime_pfad_orientierung_r TYPE zio_fztyp_mime_pfad VALUE '/SAP/BC/fp/graphics/PUBLIC/GRAPHICS/REAL/Dreieck_rechts.jpg' ##NO_TEXT.
    CONSTANTS mv_min_time TYPE string VALUE '0.00000001' ##NO_TEXT.
    CONSTANTS mv_procedure_running TYPE string VALUE 'Running' ##NO_TEXT.
    CONSTANTS mv_timezone_ergebnis TYPE timezone VALUE 'UTC+2' ##NO_TEXT.
    CONSTANTS mv_timezone_tremola TYPE timezone VALUE 'CET' ##NO_TEXT.
    CONSTANTS mv_trip_type_arr TYPE string VALUE 'Arr' ##NO_TEXT.
    CONSTANTS mv_trip_type_control TYPE string VALUE 'ControlTrip' ##NO_TEXT.
    CONSTANTS mv_trip_type_dep TYPE string VALUE 'Dep' ##NO_TEXT.
    CONSTANTS mv_trip_type_rangier TYPE string VALUE 'Running_SH' ##NO_TEXT.
    DATA ms_output TYPE zxi_cocalculate_timetable_requ .

    CLASS-METHODS get_instance
      IMPORTING
        !iv_schicht        TYPE zio_5_schicht OPTIONAL
        VALUE(io_schicht)  TYPE REF TO zcl_io_5_schicht OPTIONAL
        VALUE(iv_new)      TYPE abap_bool DEFAULT abap_false
        !iv_use_ez_db      TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_io_5_tremola .
    CLASS-METHODS get_instance_real1
      IMPORTING
        !iv_schicht        TYPE zio_schichten-zschicht
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_io_tremola .
    METHODS calculate_and_save
      IMPORTING
        VALUE(iv_testmode) TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    METHODS check_ez_form
      IMPORTING
        !it_ez_form_t     TYPE zio_5_ez_form_wd_t
      RETURNING
        VALUE(rv_success) TYPE boolean .
    METHODS constructor
      IMPORTING
        !io_schicht   TYPE REF TO zcl_io_5_schicht
        !iv_use_ez_db TYPE abap_bool DEFAULT abap_true
      RAISING
        zcx_io_5_fehler .
    METHODS get_as_details_by_as_id
      IMPORTING
        !iv_id_as       TYPE zio_id_arbstl
      EXPORTING
        !rv_start_datum TYPE dats
        !rv_end_datum   TYPE dats
        !rv_start_zeit  TYPE tims
        !rv_end_zeit    TYPE tims .
    METHODS get_catenary_sections
      RETURNING
        VALUE(rs_catenary_section) TYPE zxi_coos_tunnel_maintenance_d8 .
    METHODS get_ez_form
      EXPORTING
        !et_ez_form TYPE zio_5_ez_form_wd_t .
    METHODS get_fahrplan_by_as_id
      IMPORTING
        !iv_id_as          TYPE zio_id_arbstl
      RETURNING
        VALUE(rt_fahrplan) TYPE zio_tremola_fahrplan_t .
    METHODS get_fahrplan_image
      EXPORTING
        !ev_image       TYPE string
      RETURNING
        VALUE(rv_image) TYPE xstring .
    METHODS get_formation_by_as_id
      IMPORTING
        !iv_id_as           TYPE zio_id_as
        !iv_db              TYPE boolean OPTIONAL
      RETURNING
        VALUE(rt_formation) TYPE zio_tremola_formation_t .
    METHODS get_log
      EXPORTING
        !ev_technical_log  TYPE string
        !ev_functional_log TYPE string
        !ev_calc_success   TYPE boolean .
    METHODS get_parameter
      RETURNING
        VALUE(rs_parameter) TYPE zxi_coos_tunnel_maintenance_d5 .
    METHODS get_request_response
      EXPORTING
        !rs_request  TYPE string
        !rs_response TYPE string .
    METHODS get_schicht
      RETURNING
        VALUE(ro_schicht) TYPE REF TO zcl_io_5_schicht .
    METHODS get_shift
      IMPORTING
        !iv_db_read     TYPE boolean OPTIONAL
      RETURNING
        VALUE(rs_shift) TYPE zxi_coos_tunnel_maintenance_d1 .
    METHODS get_timezone
      IMPORTING
        !iv_schicht_date      TYPE dats
      EXPORTING
        !ev_timezone_tremola  TYPE timezone
        !ev_timezone_ergebnis TYPE timezone .
    METHODS get_track_sections
      RETURNING
        VALUE(rs_track_section) TYPE zxi_coos_tunnel_maintenance_d9 .
    METHODS get_trains_at_eiz
      EXPORTING
        !et_trains TYPE zio_train_at_eiz_t .
    METHODS has_valid_response
      RETURNING
        VALUE(rv_value) TYPE abap_bool .
    METHODS invalidate_response .
    METHODS invoke_webservice
      IMPORTING
        !iv_update_db TYPE abap_bool DEFAULT abap_true .
    METHODS is_active
      RETURNING
        VALUE(rv_value) TYPE abap_bool .
    METHODS save_ez_form
      IMPORTING
        !it_ez_form TYPE zio_5_ez_form_t .
    METHODS set_calculation_to_schicht .
    METHODS set_schicht
      IMPORTING
        !io_schicht TYPE REF TO zcl_io_5_schicht .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      tt_ez_form_db TYPE STANDARD TABLE OF zio_5_ez_form WITH EMPTY KEY .
    TYPES:
      tt_ez_form_wd_t TYPE STANDARD TABLE OF zio_ez_form_wd_s WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_trassen_fpl,
        zugnummer         TYPE zio_d_5trassen-zugnummer,
        zest              TYPE zio_d_5trassen-sperrabschnitt,
        zab               TYPE zio_d_5trassen-zab,
        zan               TYPE zio_d_5trassen-zan,
        zeiz              TYPE zio_d_5trassen-zeiz,
        zug               TYPE zio_d_5trassen-zug,
        betriebspunkt     TYPE zio_d_5trassen-betriebspunkt,
        startsignal       TYPE zio_d_5trassen-startsignal,
        gleis             TYPE zio_d_5trassen-gleis,
        zeit_am_start_tag TYPE zio_d_5trassen-zeit_am_start_tag,
        einfahrt          TYPE zio_d_5trassen-einfahrt,
        ausfahrt          TYPE zio_d_5trassen-ausfahrt,
        reihenfolge       TYPE zio_d_5trassen-reihenfolge,
        richtung          TYPE zio_d_5trassen-richtung,
        tremola_start     TYPE zio_d_5trassen-tremola_start,
        trasse_aktiv      TYPE zio_d_5trassen-trasse_aktiv,
        zzperi            TYPE zio_d_5trassen-zzperi,
        gueltig_von       TYPE zio_d_5trassen-gueltig_von,
        gueltig_bis       TYPE zio_d_5trassen-gueltig_bis,
        data_origin       TYPE zio_d_5trassen-data_origin,
      END   OF ts_trassen_fpl .
    TYPES:
      tt_trassen_fpl TYPE STANDARD TABLE OF ts_trassen_fpl WITH EMPTY KEY .

    CLASS-DATA mo_singleton TYPE REF TO zcl_io_5_tremola .
    DATA mo_schicht TYPE REF TO zcl_io_5_schicht .
    DATA mo_tremola_service TYPE REF TO zxi_coco_os_tunnel_maintenance .
    DATA ms_catenary_sections TYPE zxi_coos_tunnel_maintenance_d8 .
    DATA ms_parameter TYPE zxi_coos_tunnel_maintenance_d5 .
    DATA ms_request TYPE zxi_cocalculate_timetable_requ .
    DATA ms_response TYPE zxi_cocalculate_timetable_resp .
    DATA ms_shift TYPE zxi_coos_tunnel_maintenance_d1 .
    DATA ms_track_sections TYPE zxi_coos_tunnel_maintenance_d9 .
    DATA ms_train_routes TYPE zxi_cotrain_routes_type .
    DATA mv_use_ez_db TYPE abap_bool .

    METHODS adjust_km_by_spabschnitt
      IMPORTING
        !iv_sperrabschnitt TYPE zio_roehre
        !io_arbeitsstelle  TYPE REF TO zcl_io_5_arbeitsstelle
      CHANGING
        !cv_km_min         TYPE zio_km_von
        !cv_km_max         TYPE zio_km_bis .
    CLASS-METHODS get_current_schicht
      RETURNING
        VALUE(ro_schicht) TYPE REF TO zcl_io_5_schicht .
    METHODS read_catenary_sections .
    METHODS read_data_from_db .
    METHODS read_fahrplan_completion
      IMPORTING
        !iv_train_number   TYPE zio_train_number
        !iv_trip_type      TYPE string
        !iv_eiz            TYPE zio_id_eiz
        !iv_afs            TYPE boolean
      RETURNING
        VALUE(rt_fahrplan) TYPE zio_tremola_fahrplan_t .
    METHODS read_funcloc_attriutes
      IMPORTING
        VALUE(iv_tplnr)        TYPE tplnr
      RETURNING
        VALUE(rs_vehilce_attr) TYPE zio_funcloc_s .
    METHODS read_parameter .
    METHODS read_parameter_shift .
    METHODS read_shift
      RAISING
        zcx_io_5_fehler .
    METHODS read_track_sections .
    METHODS read_train_routes .
    METHODS select_trassen_fpl
      IMPORTING
        !iv_zugnummer     TYPE zio_5_trassen-zugnummer OPTIONAL
        !iv_reihenfolge   TYPE zio_5_trassen-reihenfolge OPTIONAL
        !iv_richtung      TYPE zio_5_trassen-richtung OPTIONAL
        !iv_start_signal  TYPE abap_bool DEFAULT abap_false
        !iv_tremola_start TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rt_trassen) TYPE tt_trassen_fpl .
    METHODS transform_and_update_db .
ENDCLASS.



CLASS ZCL_IO_5_TREMOLA IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->ADJUST_KM_BY_SPABSCHNITT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SPERRABSCHNITT              TYPE        ZIO_ROEHRE
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IO_5_ARBEITSSTELLE
* | [<-->] CV_KM_MIN                      TYPE        ZIO_KM_VON
* | [<-->] CV_KM_MAX                      TYPE        ZIO_KM_BIS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD adjust_km_by_spabschnitt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Adjust km by SP
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
* >001<   7.50      17.06.2024   DXC   / Piotr Stelmach
*         S800034763: NES:JADE-915 Signalabschnitte Tremola
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
        DATA(lo_sp_km) = CAST zcl_io_5_sp_kilometer( li_sp_km_i->get_next( ) ).
        CHECK lo_sp_km->get_sp( ) = iv_sperrabschnitt.
        cv_km_min = lo_sp_km->get_zkmin( ).
        cv_km_max = lo_sp_km->get_zkmax( ).
        RETURN.
      ENDWHILE.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->CALCULATE_AND_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TESTMODE                    TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RT_MESSAGES                    TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_and_save.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Calculate and save Tremola data
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
* >001<   7.52       18.12.2024   DXC / Piotr Stelmach
*         6800038063: NES:JADE-1051
*----------------------------------------------------------------------*

    DATA(lv_msg) = ``.

    DATA(lo_message_container) = zcl_se_8fact_log_a=>get_message_container( ).

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
          lo_message_container->add_bapiret_message( VALUE #( message = lv_log_tech type = 'E' ) ).
        ENDIF.

        IF lv_log_func IS NOT INITIAL.
          lo_message_container->add_bapiret_message( VALUE #( message = lv_log_func type = 'E' ) ).
        ENDIF.

        IF lv_success = abap_true.
          MESSAGE s088(zio_3_mmt) INTO lv_msg.
        ELSE.
          MESSAGE e086(zio_3_mmt) INTO lv_msg.
        ENDIF.
        lo_message_container->add_symsg( ).

        IF lv_success = abap_true.
          set_calculation_to_schicht( ).

          mo_schicht->save( ).
          mo_schicht->save_ez_form( ).

          COMMIT WORK.
        ENDIF.

      CATCH cx_root INTO DATA(lx_error).
        MESSAGE e086(zio_3_mmt) INTO lv_msg.
        lo_message_container->add_symsg( ).
        lo_message_container->add_exception( ix_error = lx_error ).
    ENDTRY.

    "    ENDIF. >001< (-)

    rt_messages = lo_message_container->get_bapiret_messages( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->CHECK_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM_T                   TYPE        ZIO_5_EZ_FORM_WD_T
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_ez_form.

    FIELD-SYMBOLS: <ls_ez_form> LIKE LINE OF it_ez_form_t.
    DATA: lt_ez_form       TYPE zio_5_ez_form_wd_t,
          lv_arbstl        TYPE zio_arbstl,
          lv_id_arbstl     TYPE zio_id_arbstl,
          lo_arbeitsstelle TYPE REF TO zcl_io_5_arbeitsstelle,
          lv_as_ktxt       TYPE char12,
          lv_einfahrt      TYPE boolean,
          lv_ausfahrt      TYPE boolean.

    TYPES: BEGIN OF ty_ez_check,
             zugnummer TYPE zio_zug_id,
             zarbstl   TYPE zio_arbstl,
           END OF ty_ez_check.

    DATA: lt_form_s_einfahrt TYPE tt_ez_form_wd_t,
          lt_form_s_ausfahrt TYPE tt_ez_form_wd_t,
          lt_form_n_einfahrt TYPE tt_ez_form_wd_t,
          lt_form_n_ausfahrt TYPE tt_ez_form_wd_t,
          lt_ez_as           TYPE tt_ez_form_wd_t,
          ls_ez_as           LIKE LINE OF lt_ez_as,
          lv_success         TYPE boolean.
    FIELD-SYMBOLS <ls_ez_as> LIKE LINE OF lt_ez_as.


    rv_success = abap_true.
    zcl_io_5_message_manager=>get_instance( )->reset( ).

*--------------------------------------------------------------------------------------------------------------------
    "CHECK ist Arbeitsstelle mehrmals vorhanden?
    " Tremola hat eine Arbeitsstelle N01 = abap_true in der Trasse 34001
    " und der Anwender wählt manuell die Arbeitsstelle N01 = abap_true in der Trasse 34002. Somit wären 2 Arbeitsstellen ausgewählt

    "ZUGNUMMER   ZARBSTL   ZID_EIZ   EINFAHRT   AUSFAHRT   EZ_AKTIV
    "34001       N01                   X
    "34002       N01                   X
*--------------------------------------------------------------------------------------------------------------------

    CLEAR lv_arbstl.
    "Tabelle mit Arbeitsstelle
    LOOP AT it_ez_form_t ASSIGNING <ls_ez_form>.
      IF lv_arbstl <> <ls_ez_form>-zarbstl.
        IF mo_schicht IS NOT INITIAL AND <ls_ez_form>-zarbstl IS NOT INITIAL.
          lo_arbeitsstelle = mo_schicht->get_arbeitsstelle_by_id( iv_id = <ls_ez_form>-zarbstl ).
          IF lo_arbeitsstelle IS NOT INITIAL.
            lv_as_ktxt = lo_arbeitsstelle->get_kurztext( ).
          ENDIF.
        ENDIF.
      ENDIF.
      ls_ez_as-zugnummer =   <ls_ez_form>-zugnummer.
      ls_ez_as-zarbstl =  <ls_ez_form>-zarbstl.
      ls_ez_as-zid_eiz  =  <ls_ez_form>-zid_eiz.
      ls_ez_as-einfahrt  =  <ls_ez_form>-einfahrt.
      ls_ez_as-ausfahrt  =  <ls_ez_form>-ausfahrt.
      ls_ez_as-ez_aktiv  =  <ls_ez_form>-ez_aktiv.
      ls_ez_as-has_changed = <ls_ez_form>-has_changed.
      APPEND ls_ez_as TO lt_ez_as.
    ENDLOOP.

    SORT lt_ez_as BY zid_eiz zarbstl einfahrt ausfahrt.
    DELETE lt_ez_as WHERE zarbstl = space.
    LOOP AT lt_ez_as INTO ls_ez_as.
      IF lv_id_arbstl = ls_ez_as-zarbstl.
        IF ls_ez_as-einfahrt = lv_einfahrt
          AND ls_ez_as-ausfahrt = lv_ausfahrt.
          rv_success = abap_false.
          zcl_io_message_manager=>get_instance( )->add_message(
      EXPORTING
      iv_msgno = '164'
      iv_msgty = 'E'
      iv_msgv1 = lv_as_ktxt
      iv_msgv2 = ' '
      iv_msgv3 = ' '
      ).
        ENDIF.
      ENDIF.
      lv_id_arbstl = ls_ez_as-zarbstl.
      lv_einfahrt = ls_ez_as-einfahrt.
      lv_ausfahrt = ls_ez_as-ausfahrt.
    ENDLOOP.

    LOOP AT lt_ez_as ASSIGNING <ls_ez_as>.
      CASE <ls_ez_as>-zid_eiz.
        WHEN mc_eiz_10.
          IF <ls_ez_as>-ausfahrt = abap_true.
            APPEND <ls_ez_as> TO lt_form_n_ausfahrt.
          ELSE.
            APPEND <ls_ez_as> TO lt_form_n_einfahrt.
          ENDIF.
        WHEN mc_eiz_20.
          IF <ls_ez_as>-ausfahrt = abap_true.
            APPEND <ls_ez_as> TO lt_form_s_ausfahrt.
          ELSE.
            APPEND <ls_ez_as> TO lt_form_s_einfahrt.
          ENDIF.
      ENDCASE.
    ENDLOOP.

*--------------------------------------------------------------------------------------------------------------------
    "CHECK ist Arbeitsstelle für Einfahrt und Ausfahrt definiert?

    "ZUGNUMMER   ZARBSTL   ZID_EIZ   EINFAHRT   AUSFAHRT   EZ_AKTIV
    "34001       N01                   X
    "34002       N01
*--------------------------------------------------------------------------------------------------------------------
    DATA: lv_efahrt TYPE i,
          lv_afahrt TYPE i,
          ls_es_as  TYPE zio_ez_form_wd_s.
    DESCRIBE TABLE lt_form_s_einfahrt LINES lv_efahrt.
    DESCRIBE TABLE lt_form_s_ausfahrt LINES lv_afahrt.
    IF lv_efahrt <> lv_afahrt.
      IF lv_efahrt > lv_afahrt. "mehr Einfahrten -> Ausfahrt/en fehlt
        LOOP AT lt_form_s_einfahrt ASSIGNING <ls_ez_as>.
          READ TABLE lt_form_s_ausfahrt INTO ls_ez_as WITH KEY fahrt_ktxt = <ls_ez_as>-fahrt_ktxt.
          IF sy-subrc <> 0.
            "Bei Ausfahrt fehlt Arbeitsstelle &1
            rv_success = abap_false.
            zcl_io_message_manager=>get_instance( )->add_message(
        EXPORTING
        iv_msgno = '167'
        iv_msgty = 'E'
        iv_msgv1 = <ls_ez_as>-fahrt_ktxt
        iv_msgv2 = ' '
        iv_msgv3 = ' '
        ).
          ENDIF.
        ENDLOOP.
      ELSE.
        LOOP AT lt_form_s_ausfahrt ASSIGNING <ls_ez_as>.
          READ TABLE lt_form_s_einfahrt INTO ls_ez_as WITH KEY fahrt_ktxt = <ls_ez_as>-fahrt_ktxt.
          IF sy-subrc <> 0.
            "Bei Einfahrt fehlt Arbeitsstelle &1
            rv_success = abap_false.
            zcl_io_message_manager=>get_instance( )->add_message(
        EXPORTING
        iv_msgno = '168'
        iv_msgty = 'E'
        iv_msgv1 = <ls_ez_as>-fahrt_ktxt
        iv_msgv2 = ' '
        iv_msgv3 = ' '
        ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
    DESCRIBE TABLE lt_form_n_einfahrt LINES lv_efahrt.
    DESCRIBE TABLE lt_form_n_ausfahrt LINES lv_afahrt.
    IF lv_efahrt <> lv_afahrt.
      IF lv_efahrt > lv_afahrt. "mehr Einfahrten -> Ausfahrt/en fehlt
        LOOP AT lt_form_n_einfahrt ASSIGNING <ls_ez_as>.
          READ TABLE lt_form_n_ausfahrt INTO ls_ez_as WITH KEY fahrt_ktxt = <ls_ez_as>-fahrt_ktxt.
          IF sy-subrc <> 0.
            "Bei Ausfahrt fehlt Arbeitsstelle &1
            rv_success = abap_false.
            zcl_io_message_manager=>get_instance( )->add_message(
        EXPORTING
        iv_msgno = '167'
        iv_msgty = 'E'
        iv_msgv1 = <ls_ez_as>-fahrt_ktxt
        iv_msgv2 = ' '
        iv_msgv3 = ' '
        ).
          ENDIF.
        ENDLOOP.
      ELSE.
        LOOP AT lt_form_n_ausfahrt ASSIGNING <ls_ez_as>.
          READ TABLE lt_form_n_einfahrt INTO ls_ez_as WITH KEY fahrt_ktxt = <ls_ez_as>-fahrt_ktxt.
          IF sy-subrc <> 0.
            "Bei Einfahrt fehlt Arbeitsstelle &1
            rv_success = abap_false.
            zcl_io_message_manager=>get_instance( )->add_message(
        EXPORTING
        iv_msgno = '168'
        iv_msgty = 'E'
        iv_msgv1 = <ls_ez_as>-fahrt_ktxt
        iv_msgv2 = ' '
        iv_msgv3 = ' '
        ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* | [--->] IV_USE_EZ_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    DATA lo_fehler TYPE REF TO zcx_io_5_fehler.

    ASSERT CONDITION io_schicht IS BOUND.

    mo_schicht = io_schicht.

*------------------------------------------------------------------------------------
* WebService Objekt erzeugen
*------------------------------------------------------------------------------------
    TRY.
        CREATE OBJECT mo_tremola_service.

      CATCH cx_ai_system_fault INTO DATA(lx_ai_error).
        lo_fehler = NEW #( ).
        MESSAGE e086(zio_5_real).
        lo_fehler->add_symsg( ).
        RAISE EXCEPTION lo_fehler.
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

      CATCH zcx_io_5_fehler INTO lo_fehler.
        RAISE EXCEPTION lo_fehler.
    ENDTRY.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_AS_DETAILS_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIO_ID_ARBSTL
* | [<---] RV_START_DATUM                 TYPE        DATS
* | [<---] RV_END_DATUM                   TYPE        DATS
* | [<---] RV_START_ZEIT                  TYPE        TIMS
* | [<---] RV_END_ZEIT                    TYPE        TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_as_details_by_as_id.

**********************************************************************************************
*    "Berücksichtigung Sommer- und Winterzeit
**********************************************************************************************
    get_timezone( EXPORTING iv_schicht_date      = ms_response-calculate_timetable_return-shift-begin
                  IMPORTING ev_timezone_tremola  = DATA(lv_timezone_tremola)
                            ev_timezone_ergebnis = DATA(lv_timezone_ergebnis) ).

    "Arbeitsstellen
    READ TABLE ms_response-calculate_timetable_return-shift-job_sites-job_site ASSIGNING FIELD-SYMBOL(<ls_job_site>) WITH KEY id = iv_id_as.

    IF <ls_job_site> IS ASSIGNED.

      CONVERT TIME STAMP <ls_job_site>-begin TIME ZONE lv_timezone_ergebnis INTO DATE rv_start_datum TIME rv_start_zeit.
      CONVERT TIME STAMP <ls_job_site>-end TIME ZONE lv_timezone_ergebnis INTO DATE rv_end_datum TIME rv_end_zeit.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_CATENARY_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_CATENARY_SECTION            TYPE        ZXI_COOS_TUNNEL_MAINTENANCE_D8
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_catenary_sections.

    IF ms_catenary_sections IS INITIAL.
      read_catenary_sections( ).
    ENDIF.

    rs_catenary_section = ms_catenary_sections.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IO_5_TREMOLA=>GET_CURRENT_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_current_schicht.

    TRY .
        ro_schicht = mo_singleton->get_schicht( ).

      CATCH cx_sy_ref_is_initial.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_WD_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ez_form.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get EZ Form
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
* >000<   7.50      13.08.2020   SBB   / Thomas Frick
*         S 6800006510: 5787: IT-GC CBT REAL-2.0
*         - Methode Erstellung/ Creation of method
*----------------------------------------------------------------------*
* >001<   7.50      23.05.2023   DXC  / Fatima De Villa
*         S 6800024336: NES:Jade REAL Langintervalle - JADE-140
*         - Logik für Speichern manuell hinzugefügter Trassen
*----------------------------------------------------------------------*
* >002<   7.50      19.08.2023   DXC  / Piotr Stelmach
*        S 6800035273: NES:JADE-756 Manuelle Trass. MIT Tremola
*----------------------------------------------------------------------*
* >003<   7.50      18.02.2023   DXC  / Piotr Stelmach
*        S 6800039069 : NES:JADE-1116 Zugnummer darf doppelt vorkommen
*                      (Manuellen Trassen und bei Standard Trassen)
*----------------------------------------------------------------------*

    DATA ls_trassen_fpl          TYPE LINE OF tt_trassen_fpl.
    DATA lt_processes            TYPE zxi_coprocess_type_tab.
    DATA ls_process              TYPE zxi_coprocess_type.
    DATA lt_processes_search     TYPE zxi_coprocess_type_tab.
    DATA ls_process_search       TYPE zxi_coprocess_type.
    DATA ls_process_treffer      TYPE zxi_coprocess_type.
    DATA lt_process_treffer      TYPE TABLE OF zxi_coprocess_type.
    DATA ls_train                TYPE zio_train_at_eiz_s.
    DATA lt_formation            TYPE  zxi_coformation_type_tab.
    DATA ls_formation            TYPE zxi_coformation_type.
    DATA ls_part                 TYPE zxi_coos_tunnel_maintenance_d3.
    DATA lt_part TYPE TABLE OF    zxi_coos_tunnel_maintenance_d3.
    DATA ls_train_formation      TYPE zio_train_formation_s.
    DATA lt_part_formation       TYPE zxi_copart_formation_type_tab.
    DATA ls_part_formation       TYPE zxi_copart_formation_type.
    DATA lt_job_sites            TYPE zxi_cojob_site_output_typ_tab1.
    DATA ls_job_sites            TYPE zxi_cojob_site_output_type1.
    DATA lv_train_number      TYPE string.
    DATA lt_ez_form_ma TYPE STANDARD TABLE OF zio_5_ez_form WITH EMPTY KEY.
    DATA ls_ez_form_ma LIKE LINE OF lt_ez_form_ma.
    DATA ls_ez_form    LIKE LINE OF et_ez_form.


    REFRESH et_ez_form.
    DATA(ls_schicht) = mo_schicht->get_data( ).

*--------------------------------------------------------------------------------------------------------------------
*   Daten aus Response holen
*--------------------------------------------------------------------------------------------------------------------
    lt_processes      = me->ms_response-calculate_timetable_return-shift-processes-process.
    lt_formation      = me->ms_response-calculate_timetable_return-shift-formations-formation.
    lt_part_formation = me->ms_response-calculate_timetable_return-shift-part_formations-part_formation.
    lt_job_sites      = me->ms_response-calculate_timetable_return-shift-job_sites-job_site.

*    SELECT * FROM zio_5_trassen INTO TABLE lt_trassen_fpl WHERE  zest = lv_est AND
*                                                            startsignal <> '' AND
*                                                            tremola_start = abap_true AND
*                                                            gueltig_von <= lv_start_datum  AND
*                                                            gueltig_bis >= lv_start_datum AND
*                                                            trasse_aktiv = abap_true.
    DATA(lt_trassen_fpl) = select_trassen_fpl( iv_start_signal  = abap_true
                                               iv_tremola_start = abap_false ).
    SORT lt_trassen_fpl BY zeiz ausfahrt einfahrt zab ASCENDING.

    LOOP AT lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl>).
      " es werden alle Zugfahrten angezeigt
*      SELECT * FROM zio_trassen_fpl INTO TABLE lt_trassen_fpl_zug WHERE  zugnummer = <ls_trassen_fpl>-zugnummer AND
*                                                               zest = lv_est AND
*                                                               gueltig_von <= lv_start_datum  AND
*                                                               gueltig_bis >= lv_start_datum AND
*                                                               trasse_aktiv = abap_true.

      "Do not overwrite manual entries
      CHECK <ls_trassen_fpl>-data_origin <> zif_io_5_constant=>mc_data_origin-manual.  ">003<  (+)

      DATA(lt_trassen_fpl_zug) = select_trassen_fpl( iv_zugnummer     = <ls_trassen_fpl>-zugnummer
                                                     iv_start_signal  = abap_false
                                                     iv_tremola_start = abap_false ).
      " bei Einfahrt für die Zeiten gilt Reihenfolge kleinster Wert
      IF <ls_trassen_fpl>-einfahrt = 'X'.
        SORT lt_trassen_fpl_zug BY reihenfolge ASCENDING.
        READ TABLE lt_trassen_fpl_zug ASSIGNING FIELD-SYMBOL(<ls_zug_zeiten_ef>) INDEX 1.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING <ls_zug_zeiten_ef> TO <ls_trassen_fpl>.
        ENDIF.
      ENDIF.
      " bei Ausfahrt für die Zeiten gilt Reihenfolge grösster Wert
      IF <ls_trassen_fpl>-ausfahrt = 'X'.
        SORT lt_trassen_fpl_zug BY reihenfolge DESCENDING.
        READ TABLE lt_trassen_fpl_zug ASSIGNING FIELD-SYMBOL(<ls_zug_zeiten_af>) INDEX 1.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING <ls_zug_zeiten_af> TO <ls_trassen_fpl>.
        ENDIF.
      ENDIF.
    ENDLOOP.

*--------------------------------------------------------------------------------------------------------------------
*   Manuelle Änderungen lesen
*--------------------------------------------------------------------------------------------------------------------
    SELECT * FROM zio_5_ez_form INTO TABLE lt_ez_form_ma WHERE zschicht = ls_schicht-zschicht.
    SORT lt_processes BY train_number ASCENDING.
    lt_processes_search = lt_processes.

    LOOP AT lt_processes INTO ls_process.
      CLEAR lt_process_treffer.
      IF ls_process-train_number <> lv_train_number.
        READ TABLE lt_trassen_fpl INTO ls_trassen_fpl WITH KEY zugnummer = ls_process-train_number.
        IF sy-subrc = 0.
          LOOP AT lt_processes_search INTO ls_process_search .
            IF ls_process-train_number = ls_process_search-train_number AND
               ls_process-formation_id(2) = 'EZ'.
              ls_process_treffer = ls_process_search.
              APPEND ls_process_treffer TO lt_process_treffer.
            ENDIF.
          ENDLOOP.
          IF ls_process-trip_type = 'Arr'.
            SORT lt_process_treffer BY start-time ASCENDING.
            READ TABLE lt_process_treffer INTO ls_process_treffer INDEX 1.
          ELSEIF ls_process-trip_type = 'Dep'.
            SORT lt_process_treffer BY start-time DESCENDING.
            READ TABLE lt_process_treffer INTO ls_process_treffer INDEX 1.
          ENDIF.
          ls_process = ls_process_treffer.
*--------------------------------------------------------------------------------------------------------------------
*     Zug wird verwendet und wird nun ausgewertet.
*--------------------------------------------------------------------------------------------------------------------
          CLEAR ls_ez_form.
          ls_ez_form-zugnummer = ls_process-train_number.

          ls_train-formation_id = ls_process-formation_id.
          ls_train-zug_nr = ls_process-train_number.

          CLEAR ls_formation.
          READ TABLE lt_formation INTO ls_formation WITH KEY id = ls_train-formation_id.
          IF sy-subrc = 0.

**--------------------------------------------------------------------------------------------------------------------
**     Teilzüge bearbeiten
**--------------------------------------------------------------------------------------------------------------------

            lt_part = ls_formation-parts.
            LOOP AT lt_part INTO ls_part.
*--------------------------------------------------------------------------------------------------------------------
*     Arbeitsstelle ermitteln
*--------------------------------------------------------------------------------------------------------------------
              CLEAR ls_ez_form.
              READ TABLE lt_job_sites  INTO ls_job_sites WITH KEY part_formation_id = ls_part-part_formation_id." ls_train-formation_id.
              IF sy-subrc EQ 0.
                ls_ez_form-zarbstl  = ls_job_sites-id. "check Nummer???
*--------------------------------------------------------------------------------------------------------------------
*     Manuelle Änderungen berücksichtigen
*--------------------------------------------------------------------------------------------------------------------
                IF ls_part-part_formation_id CS 'BI'.
                  ls_ez_form-zid_eiz = mc_eiz_20.
                ELSE.
                  ls_ez_form-zid_eiz = mc_eiz_10.
                ENDIF.
                ls_ez_form-zschicht = ls_schicht-zschicht.
                IF ls_process-trip_type = 'Arr'.
                  ls_ez_form-einfahrt = abap_true.
                  ls_ez_form-ausfahrt = abap_false.
                  ls_ez_form-richtung = zif_io_5_trasse=>mc_richtung_einfahrt.
                ELSEIF ls_process-trip_type = 'Dep'.
                  ls_ez_form-ausfahrt = abap_true.
                  ls_ez_form-einfahrt = abap_false.
                  ls_ez_form-richtung = zif_io_5_trasse=>mc_richtung_ausfahrt.
                ENDIF.
*--------------------------------------------------------------------------------------------------------------------
*     Tremola berücksichtigen
*--------------------------------------------------------------------------------------------------------------------
                ls_ez_form-zugnummer = ls_process-train_number.
                ls_ez_form-ez_aktiv = abap_true.

                READ TABLE lt_ez_form_ma INTO ls_ez_form_ma WITH KEY "zugnummer = ls_process-train_number  "<--- 914(-)
                                                                     zugnummer = ls_process-train_number  "<--- ">002< +
                                                                     zarbstl   = ls_job_sites-id
                                                                     zid_eiz   = ls_ez_form-zid_eiz
                                                                     richtung  = ls_ez_form-richtung
                                                                     "data_origin = abap_false              "<--- 914(+) ">002< -
                                                                     ez_aktiv    = abap_true.              "<--- 914(+)
*---> >002< begin (-)
**--> Begin Insert >001<
*                IF sy-subrc NE 0.
*                  READ TABLE lt_ez_form_ma
*                    INTO ls_ez_form_ma WITH KEY  zarbstl   = ls_job_sites-id
*                                                 zid_eiz   = ls_ez_form-zid_eiz
*                                                 richtung  = ls_ez_form-richtung
*                                                 data_origin = zif_io_5_constant=>mc_data_origin-manual
*                                                 ez_aktiv    = abap_true.
*                ENDIF.
**--> End Insert >001<
*---> >002<  end (-)
                "IF ls_ez_form_ma IS NOT INITIAL. "Change >001< ">002<  (-)
                IF sy-subrc = 0.
                  ls_ez_form-has_changed = abap_true. "manuelle Änderung übernehmen
                  ls_ez_form-ez_aktiv = ls_ez_form_ma-ez_aktiv. " -> Kennzeichen aktiv/inaktiv Trasse
*--> Begin Insert >001<
                  ls_ez_form-manually_created = COND #( WHEN ls_ez_form_ma-data_origin = zif_io_5_constant=>mc_data_origin-manual
                                                        THEN abap_true
                                                        ELSE abap_false ).
*--> End Insert >001<
                ENDIF.

                READ TABLE lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trasse>) WITH KEY zugnummer = ls_process-train_number.
                IF sy-subrc = 0.
                  ls_ez_form-fahrtzeit = COND #( WHEN <ls_trasse>-zab IS NOT INITIAL THEN <ls_trasse>-zab ELSE <ls_trasse>-zan ).
                  ls_ez_form-manually_created = COND #( WHEN <ls_trasse>-data_origin = zif_io_5_constant=>mc_data_origin-manual THEN abap_true ">002< +
                                                        ELSE ls_ez_form-manually_created ).  ">002< +
                  ls_ez_form-zeit_am_start_tag = <ls_trasse>-zeit_am_start_tag.              ">002< +
                ENDIF.

                APPEND ls_ez_form TO et_ez_form.
                CLEAR ls_ez_form.
              ENDIF.
            ENDLOOP.

          ENDIF.

        ENDIF.
      ENDIF.
      lv_train_number = ls_process-train_number.
    ENDLOOP.


    LOOP AT lt_trassen_fpl INTO ls_trassen_fpl.
      CLEAR ls_ez_form.
      READ TABLE et_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_tremola>) WITH KEY zugnummer   = ls_trassen_fpl-zugnummer
                                                                             data_origin = ls_trassen_fpl-data_origin. ">003< (+)
      IF sy-subrc <> 0.

        " ------------------------------------------------------------------------------------------------------------
        " es werden sämtliche Trassen aus der Tabelle  zio_trassen_fpl gesucht, auch wenn keine Arbeitsstelle vorhanden ist
        " ------------------------------------------------------------------------------------------------------------
        CASE ls_trassen_fpl-zeiz. "Erstfeld oder Biasca EIZ?
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
        ls_ez_form-data_origin = ls_trassen_fpl-data_origin.                                                              ">002< +
        ls_ez_form-manually_created = COND #( WHEN ls_trassen_fpl-data_origin = zif_io_5_constant=>mc_data_origin-manual  ">002< +
                                              THEN abap_true ).                                                           ">002< +

        ls_ez_form-deactivated = COND #( WHEN ls_trassen_fpl-trasse_aktiv EQ abap_true THEN abap_false ELSE  abap_true ).

        READ TABLE lt_ez_form_ma INTO ls_ez_form_ma WITH KEY "zugnummer = ls_trassen_fpl-zugnummer "Trasse inaktiv  "<--- 914(-)
                                                             zugnummer = ls_process-train_number  "<--- ">002< +
                                                             zid_eiz   = ls_ez_form-zid_eiz
                                                             zarbstl   = ' '
                                                             "data_origin = abap_false              "<--- 914(+)  ">002< -
                                                             ez_aktiv    = abap_true.              "<--- 914(+)
*--> >002< begin (-)
**--> Begin Insert >001<
*        IF sy-subrc NE 0.
*          READ TABLE lt_ez_form_ma
*            INTO ls_ez_form_ma WITH KEY  zid_eiz   = ls_ez_form-zid_eiz
*                                         zarbstl   = ' '
*                                         data_origin = zif_io_5_constant=>mc_data_origin-manual
*                                         ez_aktiv    = abap_true.
*        ENDIF.
**--> End Insert >001<
*--> >002< end (-)
        "IF ls_ez_form_ma IS NOT INITIAL. "Change >001<  ">002< (-)
        IF sy-subrc = 0. ">002< (+)
          " Einfahrt manuelle Änderung übernehmen
          ls_ez_form-ez_aktiv = abap_true.
          ls_ez_form-has_changed = abap_true. "manuelle Änderung übernehmen
*--> Begin Insert >001<
          ls_ez_form-manually_created = COND #( WHEN ls_ez_form_ma-data_origin = zif_io_5_constant=>mc_data_origin-manual
                                                 THEN abap_true
                                                ELSE abap_false ).
*--> End Insert >001<
        ELSE.
          ls_ez_form-ez_aktiv = abap_false.
        ENDIF.

        IF     ls_ez_form-einfahrt = 'X'.
          ls_ez_form-richtung = zif_io_5_trasse=>mc_richtung_einfahrt.
        ELSEIF ls_ez_form-ausfahrt = 'X'.
          ls_ez_form-richtung = zif_io_5_trasse=>mc_richtung_ausfahrt.
        ENDIF.
        APPEND ls_ez_form TO et_ez_form.
        CLEAR ls_ez_form.
      ENDIF.
    ENDLOOP.

    SORT et_ez_form BY zid_eiz ausfahrt einfahrt zugnummer fahrtzeit ASCENDING.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_FAHRPLAN_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIO_ID_ARBSTL
* | [<-()] RT_FAHRPLAN                    TYPE        ZIO_TREMOLA_FAHRPLAN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrplan_by_as_id.

    DATA lt_formation_ids TYPE STANDARD TABLE OF zio_formation_info WITH EMPTY KEY.
    DATA ls_formation_id LIKE LINE OF lt_formation_ids.
    FIELD-SYMBOLS <ls_fahrplan> LIKE LINE OF rt_fahrplan.

**********************************************************************************************
*    "Tremola Berechnung
**********************************************************************************************
    "Timesheet
    ASSIGN ms_response-calculate_timetable_return TO FIELD-SYMBOL(<ls_calc_timesheet>).
    "Schicht
    ASSIGN <ls_calc_timesheet>-shift TO FIELD-SYMBOL(<ls_shift>).

**********************************************************************************************
*    "Berücksichtigung Sommer- und Winterzeit
**********************************************************************************************
    get_timezone( EXPORTING iv_schicht_date      = <ls_shift>-begin
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
    READ TABLE <lt_job_site> ASSIGNING FIELD-SYMBOL(<ls_job_site>) WITH KEY id = iv_id_as.
    IF <ls_job_site> IS ASSIGNED.

      CLEAR: lt_formation_ids, ls_formation_id.

      "Die Arbeitsstelle hat eine Teilerhaltungszug-ID
      ls_formation_id-id = <ls_job_site>-part_formation_id.
      ls_formation_id-first = abap_true.
      ls_formation_id-last = abap_true.
      APPEND ls_formation_id TO lt_formation_ids.
      CLEAR: ls_formation_id.

      "Lesen über alle Formationen ist die gesuchte ID vorhanden?
      LOOP AT <lt_formation> ASSIGNING FIELD-SYMBOL(<ls_formation>).
        "Lesen der Parts
        FIELD-SYMBOLS: <ls_part_formation> TYPE zxi_coos_tunnel_maintenance_d3.

        LOOP AT <ls_formation>-parts TRANSPORTING NO FIELDS WHERE part_formation_id = <ls_job_site>-part_formation_id.

          "finde Position innerhalb der formation für unseren zug
          DATA(lv_pos_first) = CONV int4( 1 ).
          DATA(lv_pos_last) = CONV int4( 1 ).
          DATA(lv_pos_formation) = CONV int4( 0 ).

          DESCRIBE TABLE <ls_formation>-parts LINES lv_pos_last.

          READ TABLE <ls_formation>-parts ASSIGNING <ls_part_formation> WITH KEY part_formation_id = <ls_job_site>-part_formation_id.

          IF <ls_part_formation> IS ASSIGNED.
            lv_pos_formation = <ls_part_formation>-position.

            "Teilerhaltungszug gefunden
            IF lv_pos_formation EQ lv_pos_first. ls_formation_id-first = abap_true. ENDIF.
            IF lv_pos_formation EQ lv_pos_last. ls_formation_id-last = abap_true. ENDIF.
            ls_formation_id-id = <ls_formation>-id.
            APPEND ls_formation_id TO lt_formation_ids.
            CLEAR: ls_formation_id.

          ENDIF.

        ENDLOOP.
      ENDLOOP.

      "Fahrplanerstellung mit ID in Tabelle: lt_formation_ids
      LOOP AT lt_formation_ids INTO ls_formation_id.
        LOOP AT <lt_process> ASSIGNING FIELD-SYMBOL(<ls_process>) WHERE formation_id = ls_formation_id-id.

          APPEND INITIAL LINE TO rt_fahrplan ASSIGNING <ls_fahrplan>.

          MOVE-CORRESPONDING <ls_process> TO <ls_fahrplan>.

          CONVERT TIME STAMP <ls_process>-start-time TIME ZONE lv_timezone_ergebnis INTO DATE <ls_fahrplan>-start_datum TIME <ls_fahrplan>-start_zeit.
          <ls_fahrplan>-start_position = <ls_process>-start-position.

          CONVERT TIME STAMP <ls_process>-end-time TIME ZONE lv_timezone_ergebnis INTO DATE <ls_fahrplan>-end_datum TIME <ls_fahrplan>-end_zeit.
          <ls_fahrplan>-end_position = <ls_process>-end-position.

          "Aktiver Führerstand
          "Nord
          IF <ls_process>-formation_id CS 'ERSTFELD'.
            "Arr
            IF <ls_process>-trip_type EQ 'Arr'.
              "last
              IF ls_formation_id-last EQ abap_true.
                <ls_fahrplan>-afs = abap_true.
              ENDIF.
            ENDIF.
            "Dep
            IF <ls_process>-trip_type EQ 'Dep'.
              "first
              IF ls_formation_id-first EQ abap_true.
                <ls_fahrplan>-afs = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.

          "Süd
          IF <ls_process>-formation_id CS 'BIASCA'.
            "Arr
            IF <ls_process>-trip_type EQ 'Arr'.
              "first
              IF ls_formation_id-first EQ abap_true.
                <ls_fahrplan>-afs = abap_true.
              ENDIF.
            ENDIF.
            "Dep
            IF <ls_process>-trip_type EQ 'Dep'.
              "last
              IF ls_formation_id-last EQ abap_true.
                <ls_fahrplan>-afs = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.

          "Spezialfall (Arbeit an der Arbeitsstelle)
          IF <ls_process>-trip_type EQ 'Idle'.
            <ls_fahrplan>-afs = abap_true.
          ENDIF.

          <ls_fahrplan>-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = <ls_fahrplan>-start_datum
                                                                             iv_start_time = <ls_fahrplan>-start_zeit
                                                                             iv_end_date   = <ls_fahrplan>-end_datum
                                                                             iv_end_time   = <ls_fahrplan>-end_zeit ).

        ENDLOOP.
      ENDLOOP.

      SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

    ENDIF.

**********************************************************************************************
*    "Fahrplan kommplementieren
**********************************************************************************************
    DATA(lv_eiz) = mo_schicht->get_arbeitsstelle_by_id( iv_id = iv_id_as )->get_data( )-zid_eiz.

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
      DATA lv_last_line TYPE i.

      DESCRIBE TABLE rt_fahrplan LINES lv_last_line.
      READ TABLE rt_fahrplan ASSIGNING <ls_fahrplan> INDEX lv_last_line.

      APPEND LINES OF read_fahrplan_completion( iv_train_number = <ls_fahrplan>-train_number
                                                iv_trip_type    = <ls_fahrplan>-trip_type
                                                iv_eiz          = lv_eiz
                                                iv_afs          = <ls_fahrplan>-afs
                      ) TO rt_fahrplan.

      SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      LOOP AT rt_fahrplan ASSIGNING <ls_fahrplan>. "RGBT-848
        "Anpassung Kontroll- und Freifahrt
        IF <ls_fahrplan>-procedure EQ mv_procedure_running AND <ls_fahrplan>-last EQ abap_true.
          <ls_fahrplan>-procedure = mv_trip_type_control.
        ENDIF.
        "Anpassung bei Procedure Running und ETCS_MODE = SH = Procedure Running_SH -> Rangierbewegung
        IF <ls_fahrplan>-procedure EQ mv_procedure_running AND <ls_fahrplan>-etcs_mode EQ mv_etcs_sh.
          <ls_fahrplan>-procedure = mv_trip_type_rangier.
        ENDIF.
        "Anpassung wenn Führerstand Aktiv leer (nein) muss in Feld ETCS-Mode immer NL gefüllt werden
        IF <ls_fahrplan>-afs EQ abap_false.
          <ls_fahrplan>-etcs_mode = mv_etc_mode_nl.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_FAHRPLAN_IMAGE
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_IMAGE                       TYPE        STRING
* | [<-()] RV_IMAGE                       TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrplan_image.

    CALL FUNCTION 'SSFC_BASE64_DECODE'
      EXPORTING
        b64data = ms_response-calculate_timetable_return-graphical_time_table
      IMPORTING
        bindata = rv_image.

    DATA(lif_cached_response) = CAST if_http_response( NEW cl_http_response( add_c_msg = 1 ) ).

    lif_cached_response->set_data( rv_image ).
    lif_cached_response->set_header_field( name = if_http_header_fields=>content_type value = 'IMAGE/PJPEG' ).
    lif_cached_response->set_status( code = 200 reason = 'OK' ).
    lif_cached_response->server_cache_expire_rel( expires_rel = 180 ).

    DATA(lv_guid32) = cl_system_uuid=>create_uuid_c32_static( ).

    cl_wd_utilities=>construct_wd_url( EXPORTING application_name = 'ZIO_5_SCHICHTPLANUNG'
                                       IMPORTING out_absolute_url = ev_image ).

    CONCATENATE ev_image '/' lv_guid32 sy-uzeit INTO ev_image.

*   Write the object to the cache
    DATA(lv_vhost) = CONV i( 0 ).
    cl_http_server=>server_cache_upload( url          = ev_image
                                         response     = lif_cached_response
                                         scope        = ihttp_inv_global
                                         virtual_host = lv_vhost ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_FORMATION_BY_AS_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_AS                       TYPE        ZIO_ID_AS
* | [--->] IV_DB                          TYPE        BOOLEAN(optional)
* | [<-()] RT_FORMATION                   TYPE        ZIO_TREMOLA_FORMATION_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_formation_by_as_id.

    DATA lo_arbeitsstelle TYPE REF TO zcl_io_5_arbeitsstelle.
    FIELD-SYMBOLS <ls_formation> LIKE LINE OF rt_formation.

    DATA(lv_tremola_calc)  = abap_false.
    DATA(lv_norden) = abap_false.
    DATA(lv_reihung_count) = 0.

    "Arbeitsstellen
    ASSIGN ms_response-calculate_timetable_return-shift-job_sites-job_site TO FIELD-SYMBOL(<lt_job_site>).
    IF <lt_job_site> IS INITIAL.
      RETURN.
    ENDIF.

    "Teilerhaltungszüge
    ASSIGN ms_response-calculate_timetable_return-shift-part_formations-part_formation TO FIELD-SYMBOL(<lt_part_formation>).
    IF <lt_part_formation> IS INITIAL.
      RETURN.
    ENDIF.

    "Für gesuchte Arbeitsstelle
    READ TABLE <lt_job_site> ASSIGNING FIELD-SYMBOL(<ls_job_site>) WITH KEY id = iv_id_as.

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

      IF mo_schicht IS NOT INITIAL AND iv_id_as IS NOT INITIAL.
        lo_arbeitsstelle = mo_schicht->get_arbeitsstelle_by_id( iv_id = iv_id_as ).
        IF lo_arbeitsstelle IS BOUND.

          LOOP AT rt_formation ASSIGNING <ls_formation>.

            "Position und Orientierung aus REAL-DB lesen (da diese Methode zur Drehbuchgenerierung aufgerufen wird).
            DATA(lo_fahrzeuge) = lo_arbeitsstelle->get_fahrzeuge( iv_filter_fztyp =  <ls_formation>-type ).
            DATA(lo_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

            WHILE lo_fahrzeuge_i->has_next( ).
              DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( lo_fahrzeuge_i->get_next( ) ).
              <ls_formation>-position =  lo_fahrzeug->get_reihung( ).
              <ls_formation>-orientation = lo_fahrzeug->get_orientierung( ).
            ENDWHILE.

          ENDLOOP.

        ENDIF.
      ENDIF.

    ELSE.

      "Falls sich die Arbeitsstelle im Norden befindet, muss die Reihung "umgekehrt" werden
      "Die Original-Tremola Daten sind im diesem Fall aus dem Feld "original_reihung_tremola" weiterhin ersichtlich.
      SELECT SINGLE tremola_calc INTO lv_tremola_calc FROM zio_5_arbstellen WHERE zarbstl EQ iv_id_as.

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
* | Static Public Method ZCL_IO_5_TREMOLA=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT                     TYPE        ZIO_5_SCHICHT(optional)
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT(optional)
* | [--->] IV_NEW                         TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [--->] IV_USE_EZ_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IO_5_TREMOLA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.

    io_schicht = COND #( WHEN io_schicht IS BOUND THEN io_schicht ELSE NEW zcl_io_5_schicht( iv_schicht ) ).
    ASSERT CONDITION io_schicht IS BOUND.

    DATA(lo_schicht) = get_current_schicht( ).

    IF iv_new = abap_true.
      CLEAR lo_schicht.
    ENDIF.

    IF lo_schicht <> io_schicht.
      mo_singleton = NEW #( io_schicht = io_schicht iv_use_ez_db = iv_use_ez_db ).
      mo_singleton->invalidate_response( ).
    ENDIF.

    ro_instance = mo_singleton.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IO_5_TREMOLA=>GET_INSTANCE_REAL1
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT                     TYPE        ZIO_SCHICHTEN-ZSCHICHT
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IO_TREMOLA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance_real1.

    DATA(lo_schicht) = NEW zcl_io_schicht( iv_schicht_nr = iv_schicht ).

    ro_instance = NEW #( io_schicht = lo_schicht ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_LOG
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_TECHNICAL_LOG               TYPE        STRING
* | [<---] EV_FUNCTIONAL_LOG              TYPE        STRING
* | [<---] EV_CALC_SUCCESS                TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_log.

*   Falls ein Bild erstellt wurde, hat die Berechnung funktioniert.
    ev_calc_success = boolc( ms_response-calculate_timetable_return-graphical_time_table IS NOT INITIAL ).

    SPLIT ms_response-calculate_timetable_return-log AT '###' INTO TABLE DATA(lt_log).

    IF lines( lt_log ) EQ 1.
      READ TABLE lt_log INTO ev_technical_log INDEX 1. "technischer Fehler
    ELSE.
      READ TABLE lt_log INTO ev_functional_log INDEX 1. "anwendergerechter Fehler
      READ TABLE lt_log INTO ev_technical_log INDEX 2. "technischer Fehler
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_PARAMETER                   TYPE        ZXI_COOS_TUNNEL_MAINTENANCE_D5
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_parameter.

    IF ms_parameter IS INITIAL.
      read_parameter( ).
    ENDIF.

    rs_parameter = ms_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_REQUEST_RESPONSE
* +-------------------------------------------------------------------------------------------------+
* | [<---] RS_REQUEST                     TYPE        STRING
* | [<---] RS_RESPONSE                    TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_request_response.

    CALL TRANSFORMATION ('ID') SOURCE request = ms_request RESULT XML rs_request.

    CALL TRANSFORMATION ('ID') SOURCE response = ms_response RESULT XML rs_response.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_schicht.

    ro_schicht = mo_schicht.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DB_READ                     TYPE        BOOLEAN(optional)
* | [<-()] RS_SHIFT                       TYPE        ZXI_COOS_TUNNEL_MAINTENANCE_D1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_shift.

    IF ms_shift IS INITIAL OR iv_db_read EQ abap_true.
      read_shift( ) .
    ENDIF.

    rs_shift = ms_shift.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_TIMEZONE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SCHICHT_DATE                TYPE        DATS
* | [<---] EV_TIMEZONE_TREMOLA            TYPE        TIMEZONE
* | [<---] EV_TIMEZONE_ERGEBNIS           TYPE        TIMEZONE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_timezone.

    " Europäische Zeitzone ist in Constante enthalten
    " Zeitumstellung des Jahres
    " Je nach Sommer-/Winterzeit werden die Rückgabeparameter befüllt
    CONSTANTS lc_timezone TYPE edm_timezone VALUE 'CET'.

    DATA(ls_ttzdf) = VALUE ttzdf( ).
    DATA(lv_datum) = CONV syst_datum( iv_schicht_date ).

    CALL FUNCTION 'ISU_EDM_DST_DETERMINE'
      EXPORTING
        x_keydate          = lv_datum
        x_time_zone        = lc_timezone
      IMPORTING
        y_ttzdf            = ls_ttzdf
      EXCEPTIONS
        timezone_not_valid = 8
        OTHERS             = 99.

    " Prüfen ist Systemdatum grösser als Sommerzeitbeginn
    IF lv_datum > ls_ttzdf-datefrom.
      " Prüfen ist Systemdatum grösser als Sommerzeitende
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
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_TRACK_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_TRACK_SECTION               TYPE        ZXI_COOS_TUNNEL_MAINTENANCE_D9
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_track_sections.

    IF ms_track_sections IS INITIAL.
      read_track_sections( ).
    ENDIF.

    rs_track_section = ms_track_sections.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->GET_TRAINS_AT_EIZ
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_TRAINS                      TYPE        ZIO_TRAIN_AT_EIZ_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_trains_at_eiz.

    DATA lt_formation TYPE zxi_coformation_type_tab.
    DATA ls_formation LIKE LINE OF lt_formation.
    DATA lt_train_formation TYPE zio_train_formation_t.
    DATA ls_train_formation LIKE LINE OF lt_train_formation.
    DATA lt_part_formation TYPE zxi_copart_formation_type_tab.
    DATA ls_part_formation LIKE LINE OF lt_part_formation.
    DATA lt_zio_map_as_fz TYPE STANDARD TABLE OF zio_5_map_as_fz.
    DATA ls_zio_map_as_fz LIKE LINE OF lt_zio_map_as_fz.
    DATA lt_tremola_vehicle TYPE  zio_tremola_formation_t.
    DATA ls_tremola_vehicle LIKE LINE OF lt_tremola_vehicle.
    DATA ls_zio_fahrzeuge TYPE zio_5_fzg.
    DATA ls_train LIKE LINE OF et_trains.
    DATA lv_mime_type TYPE zio_fztyp_mime_pfad.
    DATA lv_reihung_count TYPE i.
    DATA lv_orientierung TYPE char1.
    DATA lv_arbstelle TYPE zio_id_arbstl.
    DATA lv_norden TYPE boolean.
    DATA lv_tremola_calc TYPE boolean.
    DATA lo_arbeitsstelle TYPE REF TO zcl_io_5_arbeitsstelle.

    REFRESH et_trains.

    DATA(ls_schicht) = mo_schicht->get_data( ).

**--------------------------------------------------------------------------------------------------------------------
**   Daten aus Response holen
**--------------------------------------------------------------------------------------------------------------------
    lt_formation = ms_response-calculate_timetable_return-shift-formations-formation.
    lt_part_formation = ms_response-calculate_timetable_return-shift-part_formations-part_formation.
    DATA(lt_processes) = ms_response-calculate_timetable_return-shift-processes-process.
    DATA(lt_job_sites) = ms_response-calculate_timetable_return-shift-job_sites-job_site.

**--------------------------------------------------------------------------------------------------------------------
**   Züge aus Trassen-Fahrplan ermitteln
**--------------------------------------------------------------------------------------------------------------------
*    SELECT * FROM zio_trassen_fpl INTO TABLE lt_trassen_fpl WHERE zid_intervall = lv_id_intervall AND
*                                                                     zest = lv_est AND
*                                                                     reihenfolge = '1' AND
*                                                                     einfahrt = 'X' AND
*                                                                     gueltig_von <= lv_start_datum AND
*                                                                     gueltig_bis >= lv_start_datum.
    DATA(lt_trassen_fpl) = select_trassen_fpl( iv_reihenfolge   = '1'
                                               iv_richtung      = zif_io_5_trasse=>mc_richtung_einfahrt
                                               iv_start_signal  = abap_false
                                               iv_tremola_start = abap_false ).

    LOOP AT lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl>).

      READ TABLE lt_processes ASSIGNING FIELD-SYMBOL(<ls_process>) WITH KEY train_number = <ls_trassen_fpl>-zugnummer.

*--------------------------------------------------------------------------------------------------------------------
*     Zug wird verwendet und wird nun ausgewertet.
*--------------------------------------------------------------------------------------------------------------------
      IF sy-subrc EQ 0.

        ls_train-formation_id = <ls_process>-formation_id.
        ls_train-zug_nr = <ls_process>-train_number.

        CLEAR ls_formation.
        READ TABLE lt_formation INTO ls_formation WITH KEY id = ls_train-formation_id.

*--------------------------------------------------------------------------------------------------------------------
*     Teilzüge bearbeiten
*--------------------------------------------------------------------------------------------------------------------

        CLEAR lv_norden.
        LOOP AT ls_formation-parts INTO DATA(ls_part).

          ls_train_formation-position = ls_part-position.
          ls_train_formation-formation_id = ls_part-part_formation_id.

          CLEAR ls_part_formation.
          READ TABLE lt_part_formation INTO ls_part_formation WITH KEY id = ls_part-part_formation_id.
*--------------------------------------------------------------------------------------------------------------------
*     Fahrzeuge ermitteln
*--------------------------------------------------------------------------------------------------------------------

*      --------------------------------------------------------------------------------
          "Selbe Logik wie in GET_FORMATION_BY_AS_ID
          "Falls sich die Arbeitsstelle im Norden befindet, muss die Reihung "umgekehrt" werden
          "Es sei denn, die Methode wird für das Drehbuch aufgerufen.

          lv_norden = abap_false.
          lv_reihung_count = 0.

          IF ls_part_formation-id CS 'ERSTFELD'.
            lv_norden = abap_true.
          ELSE.
            CLEAR lv_norden.
          ENDIF.

          SELECT SINGLE tremola_calc INTO lv_tremola_calc FROM zio_5_arbstellen WHERE zarbstl EQ ls_part-part_formation_id.

          IF lv_norden EQ abap_true .
            SORT ls_part_formation-vehicle BY position ASCENDING.
            LOOP AT ls_part_formation-vehicle ASSIGNING FIELD-SYMBOL(<ls_vehicle>).
              <ls_vehicle>-position = lv_reihung_count.
              lv_reihung_count = lv_reihung_count - 1.
            ENDLOOP.
            SORT ls_part_formation-vehicle BY position ASCENDING.
          ENDIF.

*      --------------------------------------------------------------------------------

          CLEAR: lt_zio_map_as_fz, ls_zio_map_as_fz, ls_tremola_vehicle-arbstelle.
          READ TABLE lt_job_sites ASSIGNING FIELD-SYMBOL(<ls_job_sites>) WITH KEY part_formation_id = ls_train_formation-formation_id.
          IF sy-subrc EQ 0.
            ls_tremola_vehicle-arbstelle = <ls_job_sites>-id.
          ENDIF.
          SELECT * INTO TABLE lt_zio_map_as_fz FROM zio_map_as_fz
            WHERE  zid_arbstl  = ls_tremola_vehicle-arbstelle.
          lv_arbstelle = ls_tremola_vehicle-arbstelle.

          lv_reihung_count = 0.

          LOOP AT lt_zio_map_as_fz INTO ls_zio_map_as_fz.
            FREE: ls_tremola_vehicle, ls_zio_fahrzeuge.
            ls_tremola_vehicle-id = ls_zio_map_as_fz-reihung.
            " Fahrzeugtyp ermitteln
            SELECT SINGLE * INTO ls_zio_fahrzeuge FROM zio_5_fzg
                  WHERE zid_fzg  = ls_zio_map_as_fz-zid_fzg
                    AND loekn    = space.
            IF sy-subrc EQ 0.
              ls_tremola_vehicle-type = ls_zio_fahrzeuge-zid_fztyp.
            ENDIF.
            ls_tremola_vehicle-position = ls_zio_map_as_fz-reihung.
            ls_tremola_vehicle-orientation = ls_zio_map_as_fz-orientierung.
            ls_tremola_vehicle-arbstelle = lv_arbstelle.
            lo_arbeitsstelle = mo_schicht->get_arbeitsstelle_by_id( iv_id = ls_tremola_vehicle-arbstelle ).
            IF lo_arbeitsstelle IS NOT INITIAL.
              ls_tremola_vehicle-arbstelle_txt = lo_arbeitsstelle->get_kurztext( ).
            ENDIF.
            IF ls_tremola_vehicle-type IS NOT INITIAL.
              SELECT SINGLE zfztyp_txt FROM zio_fztyp_bschr INTO ls_tremola_vehicle-fahrzeug_type_txt WHERE zid_fztyp EQ ls_tremola_vehicle-type.
            ENDIF.
            "MIME-Type des Fahrzeugtypes ermitteln
            CLEAR lv_mime_type.
            lv_orientierung = ls_tremola_vehicle-orientation.
            zcl_io_utilities=>get_mime_pfad_by_fztyp( EXPORTING iv_fztype       = ls_tremola_vehicle-type
                                                                iv_orientierung = lv_orientierung
                                                      IMPORTING ev_mime_pfad    = lv_mime_type ).
            IF lv_mime_type IS NOT INITIAL.
              CONCATENATE zcl_io_utilities=>mv_mime_pfad_images lv_mime_type INTO ls_tremola_vehicle-fahrzeug_img_mime.
            ELSE.
              ls_tremola_vehicle-fahrzeug_img_mime = '/SAP/BC/fp/graphics/PUBLIC/GRAPHICS/REAL/Basisfahrzeug.png'.
            ENDIF.
            DATA(li_mime_api) = cl_mime_repository_api=>get_api( ).
            li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-fahrzeug_img_mime
                              IMPORTING e_content = ls_tremola_vehicle-fahrzeug_img ).
            "MIME-ICON für Orientation
            IF ls_tremola_vehicle-orientation IS INITIAL.
              FREE: ls_tremola_vehicle-orientation_img_mime, ls_tremola_vehicle-orientation_img.
            ELSE.

              IF ls_tremola_vehicle-orientation EQ 'N'.
                ls_tremola_vehicle-orientation_img_mime = mv_mime_pfad_orientierung_l.
              ELSE.
                ls_tremola_vehicle-orientation_img_mime = mv_mime_pfad_orientierung_r.
              ENDIF.

              li_mime_api = cl_mime_repository_api=>get_api( ).
              li_mime_api->get( EXPORTING i_url = ls_tremola_vehicle-orientation_img_mime
                                IMPORTING e_content = ls_tremola_vehicle-orientation_img ).
            ENDIF.
            APPEND ls_tremola_vehicle TO lt_tremola_vehicle.
            lv_reihung_count = lv_reihung_count + 1.
          ENDLOOP.

          SORT lt_tremola_vehicle BY position.

          IF ls_part_formation-id CS 'ERSTFELD'.
            lv_norden = abap_true.
          ENDIF.


          "-------------------------------------------------------------------------
          " Im Norden:
          " Für die Drehbücher (ausschliesslich!) soll die Sortierung (nicht die Position gem. Bezeichnung) noch mal explizit umgesetellt werden
          " Die Orientierung soll nicht gedreht werden.
          "-------------------------------------------------------------------------

          IF ls_part_formation-id CS 'ERSTFELD'.
            lv_norden = abap_true.
          ELSE.
            CLEAR lv_norden.
          ENDIF.


          IF lv_norden EQ abap_true .

            CLEAR lv_mime_type.
            CLEAR ls_tremola_vehicle-fahrzeug_img_mime.


            SORT lt_tremola_vehicle BY position ASCENDING.

            LOOP AT lt_tremola_vehicle ASSIGNING FIELD-SYMBOL(<ls_tremola_vehicle>).
              <ls_tremola_vehicle>-sort_db = lv_reihung_count.
              lv_reihung_count = lv_reihung_count - 1.

            ENDLOOP.

            SORT lt_tremola_vehicle BY position DESCENDING.
          ENDIF.

          "-------------------------------------------------------------------------

          ls_train_formation-vehicles = lt_tremola_vehicle.


          APPEND ls_train_formation TO lt_train_formation. CLEAR: ls_train_formation-vehicles, lt_tremola_vehicle.

        ENDLOOP.

        IF sy-subrc EQ 0.

          SORT lt_train_formation BY position.

          ls_train-train_formation = lt_train_formation.
          APPEND ls_train TO et_trains.
          CLEAR: ls_train-train_formation , lt_train_formation.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->HAS_VALID_RESPONSE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_valid_response.

    DATA(lv_schicht) = CONV i( mo_schicht->get_id( ) ).

    rv_value = boolc( ms_response-calculate_timetable_return-shift-id = lv_schicht AND ms_response-calculate_timetable_return-graphical_time_table IS NOT INITIAL ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->INVALIDATE_RESPONSE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD invalidate_response.

    CLEAR ms_response.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->INVOKE_WEBSERVICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_UPDATE_DB                   TYPE        ABAP_BOOL (default =ABAP_TRUE)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD invoke_webservice.

    invalidate_response( ).

    mo_tremola_service->os_tunnel_maintenance_data( EXPORTING output = ms_output
                                                    IMPORTING input  = ms_response ).
    CHECK has_valid_response( ).

    IF iv_update_db = abap_true.
      transform_and_update_db( ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->IS_ACTIVE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_active.

    rv_value = boolc( mo_schicht->get_data( )-zzperi = 'GBT' AND select_trassen_fpl( iv_tremola_start = abap_true ) IS NOT INITIAL ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_CATENARY_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_catenary_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Read catenary section
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
* >001<   7.52       11.03.2025   DXC / Piotr Stelmach
*         6800039067: NES-JADE: REAL LI (JADE-1114)
*----------------------------------------------------------------------*
    DATA(lv_sp) = VALUE zio_roehre( ).   ">001< (+)


    DATA(lv_est) = mo_schicht->get_rj_est( ).
    lv_sp = COND #( WHEN strlen( lv_est ) >= 2 THEN lv_est(1) ELSE lv_est ).  ">001< (+)

    SELECT * FROM zio_fahrl_abschn INTO TABLE @DATA(lt_fahrl_abschn) WHERE zest = @lv_sp.

    DATA(lt_catenary_section) = VALUE zxi_cocatenary_section_typ_tab( ).

    LOOP AT lt_fahrl_abschn ASSIGNING FIELD-SYMBOL(<ls_fahrl_abschn>).
      APPEND VALUE #( begin = <ls_fahrl_abschn>-km_von
                      end = <ls_fahrl_abschn>-km_bis
                    ) TO ms_catenary_sections-catenary_section.
    ENDLOOP.

    ms_output-scenario-catenary_sections = ms_catenary_sections.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_DATA_FROM_DB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_data_from_db.

    CLEAR ms_request.
    CLEAR ms_response.

    "Daten lesen
    DATA(lv_schicht_id) = mo_schicht->get_id( ).
    SELECT SINGLE * FROM zio_5_tremola INTO @DATA(ls_tremola_data) WHERE schicht = @lv_schicht_id.

    IF sy-subrc EQ 0.
      CALL TRANSFORMATION ('ID') SOURCE XML ls_tremola_data-request RESULT request = ms_request.
      CALL TRANSFORMATION ('ID') SOURCE XML ls_tremola_data-response RESULT response = ms_response.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_FAHRPLAN_COMPLETION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TRAIN_NUMBER                TYPE        ZIO_TRAIN_NUMBER
* | [--->] IV_TRIP_TYPE                   TYPE        STRING
* | [--->] IV_EIZ                         TYPE        ZIO_ID_EIZ
* | [--->] IV_AFS                         TYPE        BOOLEAN
* | [<-()] RT_FAHRPLAN                    TYPE        ZIO_TREMOLA_FAHRPLAN_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_fahrplan_completion.

    DATA lt_trassen_fpl TYPE tt_trassen_fpl.
    DATA ls_fahrplan LIKE LINE OF rt_fahrplan.
    FIELD-SYMBOLS <ls_trassen_fpl> LIKE LINE OF lt_trassen_fpl.


    DATA(ls_schicht) = mo_schicht->get_data( ).

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

        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zab.
        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_arr.
        ls_fahrplan-procedure = mv_procedure_running.

        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_arr. "'Arr'.
        ls_fahrplan-procedure = mv_procedure_running. "'Running'.
        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 3.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zab.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = <ls_trassen_fpl>-startsignal.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

        "Zweite Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

**************************************************
*********DEPARTURE
**************************************************
      IF iv_trip_type EQ 'Dep'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_dep. "'Dep'.
        ls_fahrplan-procedure = mv_procedure_running. "'Running'.
        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = <ls_trassen_fpl>-startsignal.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zab.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_dep. "'Dep'.
        ls_fahrplan-procedure = mv_procedure_running. "'Running'.
        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zab.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 3.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

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

        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_arr. "'Arr'.
        ls_fahrplan-procedure = mv_procedure_running. "'Running'.
        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zab.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = <ls_trassen_fpl>-startsignal.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

**************************************************
*********DEPARTURE
**************************************************
      IF iv_trip_type EQ 'Dep'.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 1.

        ls_fahrplan-afs = iv_afs.
        ls_fahrplan-trip_type = mv_trip_type_dep. "'Dep'.
        ls_fahrplan-procedure = mv_procedure_running. "'Running'.
        ls_fahrplan-train_number = <ls_trassen_fpl>-zugnummer.
        ls_fahrplan-start_zeit = <ls_trassen_fpl>-zab.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-start_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-start_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-start_id = <ls_trassen_fpl>-startsignal.

        READ TABLE lt_trassen_fpl ASSIGNING <ls_trassen_fpl> INDEX 2.

        ls_fahrplan-end_zeit = <ls_trassen_fpl>-zan.
        IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
          ls_fahrplan-end_datum = ls_schicht-start_datum.
        ELSE.
          ls_fahrplan-end_datum = ls_schicht-start_datum + 1.
        ENDIF.
        ls_fahrplan-end_id = |{ <ls_trassen_fpl>-betriebspunkt } - Gleis: { <ls_trassen_fpl>-gleis }|.

        ls_fahrplan-dauer = zcl_io_utilities=>calculate_time_difference( iv_start_date = ls_fahrplan-start_datum
                                                                         iv_start_time = ls_fahrplan-start_zeit
                                                                         iv_end_date   = ls_fahrplan-end_datum
                                                                         iv_end_time   = ls_fahrplan-end_zeit ).

        "Erste Bewegung
        APPEND ls_fahrplan TO rt_fahrplan. CLEAR: ls_fahrplan.

        SORT rt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.

      ENDIF.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_FUNCLOC_ATTRIUTES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TPLNR                       TYPE        TPLNR
* | [<-()] RS_VEHILCE_ATTR                TYPE        ZIO_FUNCLOC_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_funcloc_attriutes.

    zlofpm_clh_application=>get_instance( iv_applid = 'GBT' ).

    DATA(lo_funcloc_agent) = zlofpm_cla_agency=>get_funcloc_agent( ).

    "Zum testen
    iv_tplnr = COND #( WHEN iv_tplnr IS INITIAL THEN lo_funcloc_agent->tplnr_convert_internal( iv_tplnr = 'GBT_XS_1' ) ELSE iv_tplnr ).
    DATA(lo_funcloc) = lo_funcloc_agent->get_object( EXPORTING iv_tplnr = iv_tplnr ).

    DATA(lo_funcloc_calssif) = lo_funcloc->get_classification( ).

    DATA(lt_details) = lo_funcloc_calssif->get_characteristics( iv_classnum  = 'FZ_GBT_STAMMDATEN'
                                                                iv_classtype = 'Z03' ).

    READ TABLE lt_details INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_details>).
    CHECK <ls_details> IS ASSIGNED.

    DATA(ls_char_values) = VALUE bapi1003_alloc_values_char( ).

    CLEAR ls_char_values.
    READ TABLE <ls_details>-valueschar WITH KEY charact = 'M_FZ_TYP' INTO ls_char_values.
    rs_vehilce_attr-m_fz_typ = ls_char_values-value_char.

    CLEAR ls_char_values.
    READ TABLE <ls_details>-valueschar WITH KEY charact = 'M_AUTOM_KUPPLUNG_VORHANDEN' INTO  ls_char_values.
    rs_vehilce_attr-m_autom_kupplung_vorhanden = ls_char_values-value_char.

    CLEAR ls_char_values.
    READ TABLE <ls_details>-valueschar WITH KEY charact = 'M_ETCS' INTO ls_char_values.
    rs_vehilce_attr-m_etcs = SWITCH #( ls_char_values-value_neutral
                                       WHEN 'Non' THEN 'false'
                                       WHEN ' '   THEN 'false'
                                       ELSE 'true'
                                     ).

    DATA(ls_num_values) = VALUE bapi1003_alloc_values_num( ).

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_LAENGE_UEBER_PUFFER_LUEP' INTO ls_num_values.
    rs_vehilce_attr-m_laenge_ueber_puffer_luep = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_VMAX_ALLEINFAHREND' INTO ls_num_values.
    rs_vehilce_attr-m_vmax_alleinfahrend = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_VMAX_GESCHLEPPT' INTO ls_num_values.
    rs_vehilce_attr-m_vmax_geschleppt = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_VMAX_RUECKWAERTS' INTO ls_num_values.
    rs_vehilce_attr-m_vmax_rueckwaerts = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_EIGENGEWICHT_TARA' INTO ls_num_values.
    rs_vehilce_attr-m_eigengewicht_tara = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_THERM_MOTOR_GESAMTLEISTUNG' INTO ls_num_values.
    rs_vehilce_attr-m_therm_motor_gesamtleistung = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_THERM_MOTOR_ANZAHL' INTO ls_num_values.
    rs_vehilce_attr-m_therm_motor_anzahl = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_EL_MOTOR_ANZAHL' INTO ls_num_values.
    rs_vehilce_attr-m_el_motor_anzahl = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_ROTATIONSBEIWERT' INTO ls_num_values.
    rs_vehilce_attr-m_rotationsbeiwert = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_BREMSHUNDERTSTEL' INTO ls_num_values.
    rs_vehilce_attr-m_bremshundertstel = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_EL_MOTOR_GESAMTLEISTUNG' INTO ls_num_values.
    rs_vehilce_attr-m_el_motor_gesamtleistung = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_EL_ANFAHRZUGKRAFT_MAX' INTO ls_num_values.
    rs_vehilce_attr-m_el_anfahrzugkraft_max = ls_num_values-value_from.

    CLEAR ls_num_values.
    READ TABLE <ls_details>-valuesnum WITH KEY charact = 'M_THERM_ANFAHRZUGKRAFT_MAX' INTO ls_num_values.
    rs_vehilce_attr-m_therm_anfahrzugkraft_max = ls_num_values-value_from.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_parameter.

    SELECT SINGLE * FROM zio_params_tremo INTO @DATA(ls_parameter).

    ms_parameter = CORRESPONDING #( ls_parameter
                            MAPPING target = target
                                    symmetric = symmetric
                                    multiple_coupling = multiplecoupling
                                    max_speed_forwards_fs = maxspeedforwardsfs
                                    max_speed_backwards_fs = maxspeedbackwardsfs
                                    max_speed_sh = maxspeedsh
                                    slow_speed_sh = slowspeedsh
                                    max_train_length = maxtrainlength
                                    run_time_reserve = runtimereserve
                                    max_calc_time = maxcalctime
                                    automatic_coupling = automaticcoupling
                                    manual_coupling = manualcoupling
                                    section_entering = sectionentering
                                    section_leaving = sectionleaving
                                    section_blocking = sectionblocking
                                    section_deblocking = sectiondeblocking
                                    manual_decoupling = manualdecoupling
                                    automatic_decoupling = automaticdecoupling
                                    catenary_activation = catenaryactivation
                                    release_trip = releasetrip
                                    catenary_stop = catenarystop
                                    headway = headway
                                    axle_counter_reset = axlecounterreset
                   ).

    ms_parameter-met_setup_time = mo_schicht->get_parameter( )->get_data( )-abzug_met.

    ms_output-scenario-parameters = ms_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_PARAMETER_SHIFT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_parameter_shift.

    ms_parameter-max_reverse_distance = mo_schicht->get_parameter( )->get_data( )-max_dist_fs_fahrt.
    ms_output-scenario-parameters = ms_parameter.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_IO_5_FEHLER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_shift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Raise with system message
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
* >001<   7.50       12.02.2021   DXC / Piotr Stelmach(EXT525176)
*        SAPCBT-914 (Jira)
*----------------------------------------------------------------------*
* >002<   7.50       08.12.2024   DXC / Piotr Stelmach(EXT525176)
*         6800038045: NES:JADE-1032 Falsche Tremola Berechnung
*----------------------------------------------------------------------*
* >003<   7.52       11.03.2025   DXC / Piotr Stelmach
*         6800039067: NES-JADE: REAL LI (JADE-1114)
*----------------------------------------------------------------------*

    DATA lt_needed_vehicle_type TYPE zxi_coneeded_vehicle_type_tab.
    DATA ls_needed_vehicle_type TYPE zxi_coneeded_vehicle_type.

    "Fahrplan vorhanden?
    IF ms_train_routes IS INITIAL.
      read_train_routes( ).
    ENDIF.

    DATA(lv_sperrabschnitt) = mo_schicht->get_rj_est( ).

    "Fahrplandaten
    ms_shift-train_routes = ms_train_routes.

    "Schicht Parameter
    DATA(ls_schicht) = mo_schicht->get_data( ).
    ms_shift-id = ls_schicht-zschicht.
    ms_shift-begin = ls_schicht-start_datum.
    ms_shift-end = ls_schicht-end_datum.
    "ms_shift-tube = lv_sperrabschnitt.  >003< (-)
    ms_shift-tube = COND #( WHEN lv_sperrabschnitt IS NOT INITIAL THEN lv_sperrabschnitt(1) ). ">003< (+)

    " Schicht Parameter für Tremola
    read_parameter_shift( ).

    DATA(ls_job_site) = VALUE zxi_cojob_site_input_type1( ).
    CLEAR ms_shift-job_sites.
    CLEAR ms_shift-rolling_stock.

    " Manuelle Änderungen lesen
    SELECT * FROM zio_5_ez_form INTO TABLE @DATA(lt_zio_ez_form) WHERE zschicht = @ms_shift-id.

******************
* Beginn Arbeitsstelle
    DATA(li_arbeitsstelle_i) = mo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE li_arbeitsstelle_i->has_next( ).
      DATA(lo_arbeitsstelle) = CAST zcl_io_5_arbeitsstelle( li_arbeitsstelle_i->get_next( ) ).
      DATA(lv_as_sperrabschnitt) = lo_arbeitsstelle->get_rj_est( ). ">003< (+)

      DATA(ls_arbeitsstelle) = lo_arbeitsstelle->get_data( ).

      "Update Sprint 9: Da es von jetzt an auch abhängige AS gibt, muss geprüft werden, ob die AS Jobs hat.
      CHECK lo_arbeitsstelle->get_auftraege( )->size( ) GT 0" .bei MET müssen keine Aufträge vorhanden sein RGBT-1026
         OR lo_arbeitsstelle->has_met( ).

      " BTG werden nicht an Tremola gesendet
      CHECK NOT lo_arbeitsstelle->is_btg( ).
      CHECK NOT lo_arbeitsstelle->is_in_os_nord( ) AND NOT lo_arbeitsstelle->is_in_os_sued( ).

      IF lo_arbeitsstelle->is_in_tunnel( ) AND
         lo_arbeitsstelle->is_schiene( ).         ">002< +
        "TS-Arbeitsstellen in Totalsperrungsschicht werden nicht beachten
      ELSEIF lo_arbeitsstelle->is_pneu( ).
        "Es dürfen nur Arbeitsstellen OSx oder BTG übergeben werden, wenn sich im Tunnel zu diesem EIZ ebenfalls AS befinden.
        CHECK mo_schicht->has_arbeitsstellen_in_tunnel( iv_eiz = ls_arbeitsstelle-zid_eiz iv_skip_strasse = abap_true ).
      ENDIF.

      adjust_km_by_spabschnitt( EXPORTING "iv_sperrabschnitt = lv_sperrabschnitt       ">003< (-)
                                          iv_sperrabschnitt = lv_as_sperrabschnitt     ">003< (+)
                                          io_arbeitsstelle  = lo_arbeitsstelle
                                CHANGING  cv_km_min         = ls_arbeitsstelle-zkmin
                                          cv_km_max         = ls_arbeitsstelle-zkmax ).

      " Begin Fahrzeuge
      DATA(li_fahrzeuge_i) = lo_arbeitsstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE li_fahrzeuge_i->has_next( ).
        DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( li_fahrzeuge_i->get_next( ) ).

        DATA(ls_fahrzeugtyp) = lo_fahrzeug->get_fahrzeugtyp( ).

*        lo_fahrzeug->is_basis_fz_os( )
        CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).
        CLEAR ls_needed_vehicle_type.

        ls_needed_vehicle_type-type = ls_fahrzeugtyp-zid_fztyp.

        " Bei Berechnung Tremola wird immer die vom Benutzer definierte Position und Reihung beachtet ms_map_as_fz
        ls_needed_vehicle_type-orientation = lo_fahrzeug->get_orientierung( iv_incl_spitzkehre = abap_false ).
        ls_needed_vehicle_type-position = lo_fahrzeug->get_reihung( ).

        APPEND ls_needed_vehicle_type TO lt_needed_vehicle_type.

        " Begin Rolling Stock
        READ TABLE ms_shift-rolling_stock-vehicle_type WITH KEY type = ls_fahrzeugtyp-zid_fztyp TRANSPORTING NO FIELDS.
        "Typ noch nicht vorhanden => hinzufügen
        IF sy-subrc NE 0.
          APPEND VALUE #( type = ls_fahrzeugtyp-zid_fztyp ) TO ms_shift-rolling_stock-vehicle_type ASSIGNING FIELD-SYMBOL(<ls_vehicle_type>).

          "Attribute lesen für Fahrzeug
          DATA(ls_vehicle_attr) = read_funcloc_attriutes( iv_tplnr = ls_fahrzeugtyp-tplnr ).

          "Antrieb: elektrisch
          IF ls_vehicle_attr-m_el_motor_anzahl GT 0.
            APPEND VALUE #( transmission    = 'E'
                            tractive_effort = ls_vehicle_attr-m_el_anfahrzugkraft_max * 1000
                            power           = ls_vehicle_attr-m_el_motor_gesamtleistung * 10000
                          ) TO <ls_vehicle_type>-propulsion.
          ENDIF.

          "Antrieb: thermisch
          IF ls_vehicle_attr-m_therm_motor_anzahl GT 0.
            APPEND VALUE #( transmission    = 'T'
                            tractive_effort = ls_vehicle_attr-m_therm_anfahrzugkraft_max * 1000
                            power           = ls_vehicle_attr-m_therm_motor_gesamtleistung * 1000
                          ) TO <ls_vehicle_type>-propulsion.
          ENDIF.

*          "Fahrzeug Attribute
          <ls_vehicle_type>-length = ls_vehicle_attr-m_laenge_ueber_puffer_luep / 1000.
          <ls_vehicle_type>-max_speed = ls_vehicle_attr-m_vmax_alleinfahrend.
          <ls_vehicle_type>-towing_speed = ls_vehicle_attr-m_vmax_geschleppt.
          <ls_vehicle_type>-max_speed_backwards = ls_vehicle_attr-m_vmax_rueckwaerts.
          <ls_vehicle_type>-weight = ls_vehicle_attr-m_eigengewicht_tara.
          <ls_vehicle_type>-payload = lo_fahrzeug->get_payload( ) / 1000.
          <ls_vehicle_type>-brake_percentage = ls_vehicle_attr-m_bremshundertstel.
          <ls_vehicle_type>-automatic_coupling = COND #( WHEN ls_vehicle_attr-m_autom_kupplung_vorhanden EQ 'X' THEN abap_true ELSE abap_false ).
          <ls_vehicle_type>-rotation_mass_factor = ls_vehicle_attr-m_rotationsbeiwert.
          "ETCS wird gleich gesetzt wie Fahrzeug-Attribut-ETCS
          <ls_vehicle_type>-etcs = ls_vehicle_attr-m_etcs.

        ENDIF. " Ende Rolling Stock

      ENDWHILE. " Ende Fahrzeuge

      " Quick&Dirty: Bei EIZ Nord muss Reihung invertiert werden
      IF ls_arbeitsstelle-zid_eiz = 10.
        DATA(lv_reihung) = lines( lt_needed_vehicle_type ).

        SORT lt_needed_vehicle_type BY position.
        " Die Reihung wird vom Planer bestimmt und wird nicht verändert ba 26.6.2017
        LOOP AT lt_needed_vehicle_type ASSIGNING FIELD-SYMBOL(<ls_temp>).
          <ls_temp>-position = lv_reihung.
          lv_reihung = lv_reihung - 1.
        ENDLOOP.
      ENDIF.

      "Arbeitsstellendetails
      ls_job_site-needed_vehicle = lt_needed_vehicle_type.
      ls_job_site-id = ls_arbeitsstelle-zarbstl.
*--------------------------------------------------------------------------------------------------------------------
*     Arbeitsstellenbezeichnung OPTREAL-163
*     In der XSD-Definition sollte das Element "JobSite" durch das Attribut "Description" (Typ String) erweitert werden.
*     Dieses Feld wird mit jedem Aufruf durch die Beschreibung der Arbeitsstelle befüllt und auf dem grafischen Fahrplan angezeigt.
*--------------------------------------------------------------------------------------------------------------------
      ls_job_site-description = lo_arbeitsstelle->get_text_id( iv_zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ).

      "Type: E = Erhaltungsrbeit, NE =Erhaltung auf offener Strecke, mit Pneufahrzeug oder virtuelle Arbeitsstelle
      IF    lo_arbeitsstelle->is_in_tunnel( )
        AND lo_arbeitsstelle->is_schiene( )
        .
        ls_job_site-type = 'E'.
      ELSE.
        ls_job_site-type = 'NE'.
      ENDIF.

      ls_job_site-depot = SWITCH #( ls_arbeitsstelle-zid_eiz WHEN mc_eiz_10 THEN 'ER'
                                                             WHEN mc_eiz_20 THEN 'BIA' ).

      ls_job_site-start_pos = ls_arbeitsstelle-zkmin.
      ls_job_site-end_pos = ls_arbeitsstelle-zkmax.

      " Unterscheidung Biasca Erstfeld START
      IF ls_arbeitsstelle-zid_eiz EQ mc_eiz_10.
        ls_job_site-prio_pos = ls_arbeitsstelle-zkmax.
      ELSE.
        ls_job_site-prio_pos = ls_arbeitsstelle-zkmin.
      ENDIF.

      "Sperrabschnitt der Positionen: Im Tunnel E oder W, auf den offenen Strecken N5-N8 und S5-S7
      "REAL1
      DATA(lv_sp_block_sector) = mo_schicht->get_rj_est( ).  ">003< (+)
      ls_job_site-block_sector = COND #( WHEN lv_sp_block_sector IS NOT INITIAL THEN lv_sp_block_sector(1) ).  ">003< (+)
      "ls_job_site-block_sector = mo_schicht->get_rj_est( ).  ">003< (-)

*--------------------------------------------------------------------------------------------------------------------
*     OPTREAL-170 Popup mit Möglichkeit zur Bestimmung Zugformation
*     pro Arbeitsstelle wird bei Manueller Änderung die Erhaltungszugnummer mitgegeben
*--------------------------------------------------------------------------------------------------------------------
      FIELD-SYMBOLS <ls_zio_ez_form> LIKE LINE OF lt_zio_ez_form.

      "IF mv_use_ez_db = abap_true.  ">001< (+)
      READ TABLE lt_zio_ez_form ASSIGNING <ls_zio_ez_form> WITH KEY zarbstl     = ls_arbeitsstelle-zarbstl
                                                                    richtung    = zif_io_5_trasse=>mc_richtung_einfahrt
                                                                    data_origin = abap_false.
      IF sy-subrc = 0.
        ls_job_site-train_route_departure = <ls_zio_ez_form>-zugnummer.
      ELSE.
        ASSIGN lt_zio_ez_form[ zarbstl  = ls_arbeitsstelle-zarbstl
                               richtung = zif_io_5_trasse=>mc_richtung_einfahrt ] TO FIELD-SYMBOL(<ls_zio_ez_form_ein>).
        IF sy-subrc = 0.
          ls_job_site-train_route_departure = <ls_zio_ez_form_ein>-zugnummer.
        ENDIF.
      ENDIF.

      READ TABLE lt_zio_ez_form ASSIGNING <ls_zio_ez_form> WITH KEY zarbstl     = ls_arbeitsstelle-zarbstl
                                                                    richtung    = zif_io_5_trasse=>mc_richtung_ausfahrt
                                                                    data_origin = abap_false.
      IF sy-subrc = 0.
        ls_job_site-train_route_arrival = <ls_zio_ez_form>-zugnummer.
      ELSE.
        ASSIGN lt_zio_ez_form[ zarbstl  = ls_arbeitsstelle-zarbstl
                               richtung = zif_io_5_trasse=>mc_richtung_ausfahrt ] TO FIELD-SYMBOL(<ls_zio_ez_form_aus>).
        IF sy-subrc = 0.
          ls_job_site-train_route_arrival = <ls_zio_ez_form_aus>-zugnummer.
        ENDIF.
      ENDIF.
      " ENDIF.
*--------------------------------------------------------------------------------------------------------------------

      "Falls sich bei diesem Auftrag das MET befindet, wir dieser Kilometer verwendet.
      "REAL1

      IF lo_arbeitsstelle->has_met( ).
        DATA(ls_met) = lo_arbeitsstelle->get_met( ).

        "Position des MET
        ls_job_site-met_pos = ls_met-zkm.

        "KM VON / BIS aus ZIO_SA ermitteln
        SELECT * FROM zio_5_sa INTO TABLE @DATA(lt_sa)
          WHERE zzperi EQ @ls_schicht-zzperi
            AND km_von LE @ls_met-zkm
            AND km_bis GE @ls_met-zkm
            AND zest   EQ @ls_met-zzest.
        READ TABLE lt_sa INTO DATA(ls_sa) INDEX 1.
        "----------------------------------------------------------------------------------
        " Falls Kilometrierung der Arbeitsstelle grösser ist als Kilometrierung MET
        " wird die Kilometrierung der Arbeitsstelle übernommen
        "----------------------------------------------------------------------------------
        IF ls_arbeitsstelle-zkmin IS NOT INITIAL.   "Arbeitsstelle Beginn
          IF ls_sa-km_von <= ls_arbeitsstelle-zkmin.
            ls_job_site-start_pos = ls_sa-km_von.
          ELSE.
            ls_job_site-start_pos = ls_arbeitsstelle-zkmin.
          ENDIF.
        ELSE.
          ls_job_site-start_pos = ls_sa-km_von.
        ENDIF.
        IF ls_arbeitsstelle-zkmax IS NOT INITIAL.   "Arbeitsstelle Ende
          IF ls_sa-km_bis <= ls_arbeitsstelle-zkmax.
            ls_job_site-end_pos = ls_arbeitsstelle-zkmax.
          ELSE.
            ls_job_site-end_pos = ls_sa-km_bis.
          ENDIF.
        ELSE.
          ls_job_site-end_pos = ls_sa-km_bis.
        ENDIF.

      ENDIF. " MET exists

      ls_job_site-min_time = mv_min_time.

      "REAL1
*      DATA(lv_coupling_allowed) = lo_arbeitsstelle->get_data( )-zehz_alleinfahrt.
      DATA(lv_coupling_allowed) = abap_false.
      ls_job_site-coupling_allowed = boolc( lv_coupling_allowed <> abap_true ).

      ls_job_site-catenary_stop_needed = abap_false.
      APPEND ls_job_site TO ms_shift-job_sites-job_site.
      CLEAR: ls_job_site, lt_needed_vehicle_type.

    ENDWHILE. " Ende Arbeitsstelle

    ms_output-scenario-shift = ms_shift.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_TRACK_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_track_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Read track section
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
* >001<   7.52       11.03.2025   DXC / Piotr Stelmach
*         6800039067: NES-JADE: REAL LI (JADE-1114)
*----------------------------------------------------------------------*
    DATA(lv_sp) = VALUE zio_roehre( ).   ">001< (+)

    CLEAR ms_track_sections-track_section[].

    DATA(lv_perimeter) = mo_schicht->get_data( )-zzperi.
    DATA(lv_est) = mo_schicht->get_rj_est( ).
    lv_sp = COND #( WHEN strlen( lv_est ) >= 2 THEN lv_est(1) ELSE lv_est ).  ">001< (+)

    SELECT * FROM zio_5_sa INTO TABLE @DATA(lt_sa)
      WHERE zzperi = @lv_perimeter
        AND zest = @lv_sp.

    LOOP AT lt_sa ASSIGNING FIELD-SYMBOL(<ls_sa>).
      APPEND VALUE #( begin = <ls_sa>-km_von
                      end = <ls_sa>-km_bis
                      track_number = <ls_sa>-zsa
                      block_sector = <ls_sa>-zest
                      entry_direction = <ls_sa>-einfahrtrichtung
             ) TO ms_track_sections-track_section.
    ENDLOOP.

    ms_output-scenario-track_sections = ms_track_sections.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->READ_TRAIN_ROUTES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_train_routes.

    DATA lv_time_stamp TYPE timestamp.
    DATA lv_time_eiz TYPE timestamp.
    DATA lv_eiz_time_portal TYPE timestamp.
    DATA lv_tunnel_time_portal TYPE timestamp.


    DATA(ls_schicht) = mo_schicht->get_data( ).
    DATA(lv_est) = mo_schicht->get_rj_est( ).
*--------------------------------------------------------------------------------------------------------------------
*   Berücksichtigung Sommer- Winterzeit
*--------------------------------------------------------------------------------------------------------------------
    get_timezone( EXPORTING iv_schicht_date      = ls_schicht-start_datum
                  IMPORTING ev_timezone_tremola  = DATA(lv_timezone_tremola)
                            ev_timezone_ergebnis = DATA(lv_timezone_ergebnis) ).

**--------------------------------------------------------------------------------------------------------------------
**   Manuelle Änderungen lesen (für Zusatz use_route befüllen)
**--------------------------------------------------------------------------------------------------------------------
    DATA(lv_schicht) = mo_schicht->get_id( ).
    SELECT * FROM zio_5_ez_form INTO TABLE @DATA(lt_ez_form_ma) WHERE zschicht = @lv_schicht.

*    SELECT trasse~zugnummer AS zugnummer,
*           trasse~sperrabschnitt AS zest,
*           trasse~zab AS zab,
*           trasse~zan AS zan,
*           bpunkt~zeiz AS zeiz,
*           trasse~zug AS zug,
*           trasse~betriebspunkt AS betriebspunkt,
*           trasse~startsignal AS startsignal,
*           trasse~gleis AS gleis,
*           trasse~zeit_am_start_tag AS zeit_am_start_tag,
*           CAST( ( CASE trasse~richtung WHEN @zif_io_5_trasse=>mc_richtung_einfahrt THEN 'X' ELSE ' ' END ) AS CHAR( 1 ) ) AS einfahrt,
*           CAST( ( CASE trasse~richtung WHEN @zif_io_5_trasse=>mc_richtung_ausfahrt THEN 'X' ELSE ' ' END ) AS CHAR( 1 ) ) AS ausfahrt,
*           trasse~reihenfolge AS reihenfolge,
*           trasse~richtung AS richtung,
*           trasse~trasse_aktiv AS trasse_aktiv
*      FROM zio_5_trassen AS trasse
*      INNER JOIN zio_5_btrbspunkt AS bpunkt ON bpunkt~betriebspunkt = trasse~betriebspunkt
*      INTO TABLE @DATA(lt_trassen_fpl)
*      WHERE trasse~zzperi = @ls_schicht-zzperi
*        AND trasse~gueltig_von <= @ls_schicht-start_datum
*        AND trasse~gueltig_bis >= @ls_schicht-start_datum
*        AND trasse~sperrabschnitt = @lv_est
*        AND trasse~startsignal <> ''
*        AND trasse~tremola_start = @abap_true.
    DATA(lt_trassen_fpl) = select_trassen_fpl( iv_start_signal  = abap_true
                                               iv_tremola_start = abap_true ).

    SORT lt_trassen_fpl BY zugnummer ASCENDING
                           einfahrt ASCENDING
                           reihenfolge ASCENDING.


*-----------------------------------------------------------------------------------------------------------------------------------
* Tremola eizTimePortal, TimeEiz und TunnelTimePortal bei allen Trassen befüllen OPTREAL-163
*------------------------------------------------------------------------------------------------------------------------------------->>>>>>
*    SELECT trasse~zugnummer AS zugnummer,
*           trasse~sperrabschnitt AS zest,
*           trasse~zab AS zab,
*           trasse~zan AS zan,
*           bpunkt~zeiz AS zeiz,
*           trasse~zug AS zug,
*           trasse~betriebspunkt AS betriebspunkt,
*           trasse~startsignal AS startsignal,
*           trasse~gleis AS gleis,
*           trasse~zeit_am_start_tag AS zeit_am_start_tag,
*           CAST( ( CASE trasse~richtung WHEN @zif_io_5_trasse=>mc_richtung_einfahrt THEN 'X' ELSE ' ' END ) AS CHAR( 1 ) ) AS einfahrt,
*           CAST( ( CASE trasse~richtung WHEN @zif_io_5_trasse=>mc_richtung_ausfahrt THEN 'X' ELSE ' ' END ) AS CHAR( 1 ) ) AS ausfahrt,
*           trasse~reihenfolge AS reihenfolge,
*           trasse~richtung AS richtung,
*           trasse~trasse_aktiv AS trasse_aktiv
*      FROM zio_5_trassen AS trasse
*      INNER JOIN zio_5_btrbspunkt AS bpunkt ON bpunkt~betriebspunkt = trasse~betriebspunkt
*      INTO TABLE @DATA(lt_trassen_fpl_eiz)
*      WHERE zzperi = @ls_schicht-zzperi
*        AND gueltig_von <= @ls_schicht-start_datum
*        AND gueltig_bis >= @ls_schicht-start_datum
*        AND sperrabschnitt = @lv_est.
    DATA(lt_trassen_fpl_eiz) = select_trassen_fpl( iv_start_signal  = abap_false
                                                   iv_tremola_start = abap_false ).

    SORT lt_trassen_fpl_eiz BY zugnummer ASCENDING
                               zeiz ASCENDING
                               einfahrt ASCENDING
                               reihenfolge ASCENDING.

    "Aufbereiten der Abfahrten und Ankünfte am Signal vor dem Tunnelportal
    LOOP AT lt_trassen_fpl ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl>).

      APPEND INITIAL LINE TO ms_train_routes-train_route ASSIGNING FIELD-SYMBOL(<ls_train_route>).

      DATA(lv_temp_date) = ls_schicht-start_datum.

*--------------------------------------------------------------------------------------------------------------------
* OPTREAL-163 Erweiterung grafischer Fahrplan TreMOla
* Die Ankunft und Abfahrt beim Tunnel werden über die beiden Attribute "eizTimePortal" und "tunnelTimePortal" definiert.
* Diese Attribute befinden sich im Element TrainRoute
* Bei der Einfahrt in den Tunnel:   eizTimePortal -> tunnelTimePortal
* Bei der Ausfahrt aus dem Tunnel:  tunnelTimePortal -> eizTimePortal
*--------------------------------------------------------------------------------------------------------------------
      READ TABLE lt_trassen_fpl_eiz TRANSPORTING NO FIELDS WITH KEY zugnummer = <ls_trassen_fpl>-zugnummer BINARY SEARCH.
      DATA(lv_index_from) = sy-tabix.

      LOOP AT lt_trassen_fpl_eiz ASSIGNING FIELD-SYMBOL(<ls_trassen_fpl_eiz>) FROM lv_index_from.
        IF <ls_trassen_fpl_eiz>-zugnummer <> <ls_trassen_fpl>-zugnummer.
          EXIT. " to the outer LOOP
        ENDIF.

*--------------------------------------------------------------------------------------------------------------------
* Zeit am Start berücksichigen
*--------------------------------------------------------------------------------------------------------------------
        lv_temp_date = COND #( WHEN <ls_trassen_fpl_eiz>-zeit_am_start_tag = abap_true THEN ls_schicht-start_datum ELSE ls_schicht-start_datum + 1 ).

        IF <ls_trassen_fpl_eiz>-zeiz = 'GBTN'.
          IF <ls_trassen_fpl_eiz>-einfahrt = abap_true. "EINFAHRT
            CASE <ls_trassen_fpl_eiz>-reihenfolge.
              WHEN '1'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zab INTO TIME STAMP lv_time_eiz TIME ZONE lv_timezone_tremola.
                <ls_train_route>-time_eiz = lv_time_eiz.
              WHEN '2'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zan INTO TIME STAMP lv_eiz_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-eiz_time_portal = lv_eiz_time_portal.
              WHEN '3'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zab INTO TIME STAMP lv_tunnel_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-tunnel_time_portal = lv_tunnel_time_portal.
            ENDCASE.
          ELSE. "AUSFAHRT
            CASE <ls_trassen_fpl_eiz>-reihenfolge.
              WHEN '3'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zan INTO TIME STAMP lv_time_eiz TIME ZONE lv_timezone_tremola.
                <ls_train_route>-time_eiz = lv_time_eiz.
              WHEN '2'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zab INTO TIME STAMP lv_eiz_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-eiz_time_portal = lv_eiz_time_portal.
              WHEN '1'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zan INTO TIME STAMP lv_tunnel_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-tunnel_time_portal = lv_tunnel_time_portal.
            ENDCASE.
          ENDIF.

        ELSE.
          IF <ls_trassen_fpl_eiz>-einfahrt = abap_true. "EINFAHRT
            CASE <ls_trassen_fpl_eiz>-reihenfolge.
              WHEN '1'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zab INTO TIME STAMP lv_time_eiz TIME ZONE lv_timezone_tremola.
                <ls_train_route>-time_eiz = lv_time_eiz.
              WHEN '2'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zan INTO TIME STAMP lv_eiz_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-eiz_time_portal = lv_eiz_time_portal.
                <ls_train_route>-tunnel_time_portal = lv_eiz_time_portal.
            ENDCASE.
          ELSE. "AUSFAHRT
            CASE <ls_trassen_fpl_eiz>-reihenfolge.
              WHEN '2'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zan INTO TIME STAMP lv_time_eiz TIME ZONE lv_timezone_tremola.
                <ls_train_route>-time_eiz = lv_time_eiz.
              WHEN '1'.
                CONVERT DATE lv_temp_date TIME <ls_trassen_fpl_eiz>-zab INTO TIME STAMP lv_eiz_time_portal TIME ZONE lv_timezone_tremola.
                <ls_train_route>-eiz_time_portal = lv_eiz_time_portal.
                <ls_train_route>-tunnel_time_portal = lv_eiz_time_portal.
            ENDCASE.
          ENDIF.
        ENDIF.

      ENDLOOP.
*--------------------------------------------------------------------------------------------------------------------

      <ls_train_route>-train_number = <ls_trassen_fpl>-zugnummer.

      TRANSLATE <ls_trassen_fpl>-startsignal TO LOWER CASE.
      <ls_train_route>-place_portal = <ls_trassen_fpl>-startsignal.
      "Depo - Auswertung nach EST
      <ls_train_route>-depot = SWITCH #( <ls_trassen_fpl>-zeiz WHEN 'GBTN' THEN 'ER'
                                                               WHEN 'GBTS' THEN 'BIA'
                                                               ELSE '' ).
      " Trasse aktiv
      <ls_train_route>-use_route = COND #( WHEN <ls_trassen_fpl>-trasse_aktiv = abap_true THEN 'true' ELSE 'false' ).

      "--------------------------------------------------------------------------------------------------------------------
      "  manuelle Änderung beachten bei Feld use_route
      "--------------------------------------------------------------------------------------------------------------------
      DATA(lv_eiz) = SWITCH #( <ls_trassen_fpl>-zeiz WHEN mc_eiz_gbtn THEN mc_eiz_10
                                                     WHEN mc_eiz_gbts THEN mc_eiz_20 ).

      " Trasse aktiv ist Arbeitsstellenübergreifend, aus diesem Grund Def. für diesen Eintrag in der Tabelle ZIO_EZ_FORM für manuelle Änderungen
      " -> Arbeitsstelle mit space befüllt und Definition für Ein- und Ausfahrt immer abap_false
      READ TABLE lt_ez_form_ma INTO DATA(ls_ez_form_ma) WITH KEY zugnummer = <ls_trassen_fpl>-zugnummer
                                                                 zid_eiz   = lv_eiz
                                                                 zarbstl   = space.
      IF sy-subrc = 0.
        IF ls_ez_form_ma-ez_aktiv = abap_true.
          <ls_train_route>-use_route = 'false'.
        ENDIF.
      ENDIF.

      "--------------------------------------------------------------------------------------------------------------------

      "Einfahrt und Ausfahrten - für Tremola ist es umgekerht.
      IF <ls_trassen_fpl>-einfahrt EQ abap_true.
        <ls_train_route>-dep_arr = mv_departure.
      ELSEIF <ls_trassen_fpl>-ausfahrt EQ abap_true.
        <ls_train_route>-dep_arr = mv_arrival.
      ENDIF.

      lv_temp_date = COND #( WHEN <ls_trassen_fpl>-zeit_am_start_tag = abap_true THEN ls_schicht-start_datum ELSE ls_schicht-start_datum + 1 ).

      IF <ls_trassen_fpl>-zeit_am_start_tag EQ abap_true.
        "Startdatum der Schicht
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
        "Startdatum der Schicht +1 (Folgetag)
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
      CLEAR lv_time_stamp.
      CLEAR lv_temp_date.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->SAVE_EZ_FORM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_EZ_FORM                     TYPE        ZIO_5_EZ_FORM_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_ez_form.

    DATA(lv_schicht) = mo_schicht->get_id( ).
    " Zugnummer muss in Arbeitsstelle angepasst werden

    DATA(lt_db_new) = VALUE tt_ez_form_db( FOR <ls_wa> IN it_ez_form WHERE ( zschicht = lv_schicht AND zugnummer IS NOT INITIAL )
                                         ( zschicht  = <ls_wa>-zschicht
                                           zugnummer = <ls_wa>-zugnummer
                                           zarbstl   = <ls_wa>-zarbstl
                                           zid_eiz   = <ls_wa>-zid_eiz
                                           richtung  = <ls_wa>-richtung
                                           ez_aktiv  = <ls_wa>-ez_aktiv
                                           ernam     = sy-uname
                                           erdat     = sy-datlo
                                           erzeit    = sy-timlo )
                      ).
    SORT lt_db_new BY zschicht zugnummer zarbstl zid_eiz richtung.
    DELETE ADJACENT DUPLICATES FROM lt_db_new COMPARING zschicht zugnummer zarbstl zid_eiz richtung.

    SELECT zarbstl
      INTO TABLE @DATA(lt_arbstellen)
      FROM zio_5_arbstellen
      WHERE zschicht = @lv_schicht .
    SORT lt_arbstellen BY zarbstl.

    SELECT *
      INTO TABLE @DATA(lt_ez_form)
      FROM zio_5_ez_form
      WHERE zschicht = @lv_schicht.

    " zuerst müssen bei allen Arbeitsstellen die Zugnummern rausgelöscht werden
    LOOP AT lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form_del>).
      READ TABLE lt_arbstellen TRANSPORTING NO FIELDS WITH KEY zarbstl = <ls_ez_form_del>-zarbstl BINARY SEARCH.
      CHECK sy-subrc = 0.
      UPDATE zio_5_arbstellen SET
        zid_zug = ' '
        WHERE zschicht = @lv_schicht
          AND zarbstl = @<ls_ez_form_del>-zarbstl.
    ENDLOOP.

    " die neuen Änderungen mit der Zugnummer werden in den Arbeitsstellen angepasst
    LOOP AT lt_db_new ASSIGNING FIELD-SYMBOL(<ls_ez_form_new>).
      READ TABLE lt_arbstellen TRANSPORTING NO FIELDS WITH KEY zarbstl = <ls_ez_form_new>-zarbstl BINARY SEARCH.
      CHECK sy-subrc = 0.
      UPDATE zio_5_arbstellen SET
        zid_zug = @<ls_ez_form_new>-zugnummer
        WHERE zschicht = @lv_schicht
          AND zarbstl = @<ls_ez_form_new>-zarbstl.
    ENDLOOP.

    DELETE FROM zio_5_ez_form WHERE zschicht = @lv_schicht.
    INSERT zio_5_ez_form FROM TABLE @lt_db_new.

    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->SELECT_TRASSEN_FPL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZUGNUMMER                   TYPE        ZIO_5_TRASSEN-ZUGNUMMER(optional)
* | [--->] IV_REIHENFOLGE                 TYPE        ZIO_5_TRASSEN-REIHENFOLGE(optional)
* | [--->] IV_RICHTUNG                    TYPE        ZIO_5_TRASSEN-RICHTUNG(optional)
* | [--->] IV_START_SIGNAL                TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [--->] IV_TREMOLA_START               TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RT_TRASSEN                     TYPE        TT_TRASSEN_FPL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_trassen_fpl.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Supply EZ Formation Tremola
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
* >001<   7.50      01.08.2023   DXC  / Piotr Stelmach
*        S 6800035273: NES:JADE-756 Manuelle Trass. MIT Tremola
*----------------------------------------------------------------------*
* >002<   7.52       11.03.2025   DXC / Piotr Stelmach
*         6800039067: NES-JADE: REAL LI (JADE-1114)
*----------------------------------------------------------------------*
    DATA lt_zugnummer_range    TYPE RANGE OF zio_5_trassen-zugnummer.
    DATA lt_reihenfolge_range   TYPE RANGE OF zio_5_trassen-reihenfolge.
    DATA lt_richtung_range      TYPE RANGE OF zio_5_trassen-richtung.
    DATA lt_startsignal_range   TYPE RANGE OF zio_5_trassen-startsignal.
    DATA lt_tremola_start_range TYPE RANGE OF zio_5_trassen-tremola_start.
    DATA lt_data_origin_range   TYPE RANGE OF zio_5_trassen-data_origin.   ">001< +
    DATA(lv_sp) = VALUE zio_roehre( ).   ">002< (+)

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
      lt_startsignal_range = VALUE #( ( sign = 'I' option = 'NE' ) ).
    ENDIF.

    IF iv_tremola_start = abap_true.
      lt_tremola_start_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'X' ) ).
    ENDIF.

    ">001< + begin  "Exclude Vorlage entries
    APPEND VALUE #( sign = 'E' option = 'EQ' low = zif_io_5_constant=>mc_data_origin-vorlage ) TO lt_data_origin_range.
    ">001< + end


    DATA(ls_schicht) = mo_schicht->get_data( ).
    DATA(lv_est) = mo_schicht->get_rj_est( ).
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
            data_origin                     ">001< +
      FROM zio_d_5trassen AS trasse
      INTO CORRESPONDING FIELDS OF TABLE @rt_trassen
      WHERE zzperi = @ls_schicht-zzperi
        AND gueltig_von <= @ls_schicht-start_datum
        AND gueltig_bis >= @ls_schicht-start_datum
        AND zugnummer IN @lt_zugnummer_range[]
        AND reihenfolge IN @lt_reihenfolge_range[]
        AND richtung IN @lt_richtung_range[]
        AND sperrabschnitt = @lv_sp
        AND startsignal IN @lt_startsignal_range[]
        AND tremola_start IN @lt_tremola_start_range[]
        AND data_origin   IN @lt_data_origin_range.     ">001< +

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->SET_CALCULATION_TO_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_calculation_to_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern
*----------------------------------------------------------------------*
* Beschreibung: Liefert die Quelle der Orientierung
*
* SAP-Prozess : ...
*
* Grund:        ( ) QM-Meldung  : ...
*               (X) Projekt     : ...
*               ( ) Notkorrektur: ...
*               ( ) OSS-Hinweis : ...
*               ( ) OSS-Meldung : ...
*               ( ) andere      : ...
*
* Auftraggeber: Valentin Rupp
*
*-------------Aenderungsdokumentation----------------------------------*
* Edition SAP-Rel    Datum        Bearbeiter
*         Beschreibung
*----------------------------------------------------------------------*
* >001<   7.52       25.05.2022  DXC / Piotr Stelmach
*  Check the orientierung source to avoid overwritting the planer manual entry
*----------------------------------------------------------------------*
    CONSTANTS lc_orient_src_tremola  TYPE zio_5_orientierung_src VALUE 'T'.   ">001< (+)
    CONSTANTS lc_orient_src_manual   TYPE zio_5_orientierung_src VALUE 'M'.   ">001< (+)
    CONSTANTS lc_orient_src_not_spec TYPE zio_5_orientierung_src VALUE ''.    ">001< (+)

    CHECK has_valid_response( ).

    DATA(li_arbeitsstelle_i) = mo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    DATA(lt_sp_schicht)      = mo_schicht->get_sp_schicht( ).

    WHILE li_arbeitsstelle_i->has_next( ).
      DATA(lo_arbeitsstelle) = CAST zcl_io_5_arbeitsstelle( li_arbeitsstelle_i->get_next( ) ).

      DATA(ls_arbeitsstelle) = lo_arbeitsstelle->get_data( ).


      get_as_details_by_as_id( EXPORTING iv_id_as       = ls_arbeitsstelle-zarbstl
                               IMPORTING rv_start_datum = ls_arbeitsstelle-start_datum
                                         rv_start_zeit  = ls_arbeitsstelle-start_zeit
                                         rv_end_datum   = ls_arbeitsstelle-end_datum
                                         rv_end_zeit    = ls_arbeitsstelle-end_zeit ).

      CHECK ls_arbeitsstelle-start_datum IS NOT INITIAL.
      ls_arbeitsstelle-tremola_calc = abap_true.

      DATA(lt_fahrplan) = get_fahrplan_by_as_id( iv_id_as = ls_arbeitsstelle-zarbstl ).
      SORT lt_fahrplan BY start_datum ASCENDING start_zeit ASCENDING.
      TRY .
          ls_arbeitsstelle-zid_zug = lt_fahrplan[ 1 ]-train_number.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      lo_arbeitsstelle->set_data( is_data = ls_arbeitsstelle ).

      DATA(lt_map_spabs) = lo_arbeitsstelle->get_sperrabschnitte( iv_zugangsart = zcl_io_5_utilities=>mc_zugangsart_schiene ).

      DATA(li_sp_zeiten_i) = lo_arbeitsstelle->get_sp_zeiten( )->get_values_iterator( ).
      WHILE li_sp_zeiten_i->has_next( ).
        DATA(lo_sp_zeiten) = CAST zcl_io_5_sp_zeiten( li_sp_zeiten_i->get_next( ) ).
        DATA(ls_sp_zeiten) = lo_sp_zeiten->get_data( ).

        ASSIGN lt_map_spabs[ sperras_id = ls_sp_zeiten-sperras_id ] TO FIELD-SYMBOL(<ls_map_spabs>).
        CHECK sy-subrc = 0.

        ASSIGN lt_sp_schicht[ sperras_id = <ls_map_spabs>-sperras_id ] TO FIELD-SYMBOL(<ls_sp_schicht>).
        CHECK sy-subrc = 0.

        CHECK <ls_sp_schicht>-zintervallart <> zcl_io_5_utilities=>mc_intervart_sp_ts.

        ls_sp_zeiten-start_datum = ls_arbeitsstelle-start_datum.
        ls_sp_zeiten-start_zeit  = ls_arbeitsstelle-start_zeit.
        ls_sp_zeiten-end_datum   = ls_arbeitsstelle-end_datum.
        ls_sp_zeiten-end_zeit    = ls_arbeitsstelle-end_zeit.
        lo_sp_zeiten->set_data( is_data = ls_sp_zeiten ).
      ENDWHILE.

      DATA(lt_formation) = get_formation_by_as_id( iv_id_as = ls_arbeitsstelle-zarbstl ).

      DATA(li_fahrzeuge_i) = lo_arbeitsstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE li_fahrzeuge_i->has_next( ).
        DATA(lo_fahrzeug) = CAST zcl_io_5_fahrzeug( li_fahrzeuge_i->get_next( ) ).
        DATA(lv_reihung) = lo_fahrzeug->get_reihung( ).
        READ TABLE lt_formation INTO DATA(ls_formation) WITH KEY position = lv_reihung.
        IF sy-subrc = 0.
          DELETE lt_formation INDEX sy-tabix.
          IF lc_orient_src_manual <> lo_fahrzeug->get_orientierung_src( ).                             ">001< (+)
            lo_fahrzeug->set_orientierung( iv_orientierung = CONV #( ls_formation-orientation ) ).
            lo_fahrzeug->set_original_tremola_reihung( iv_reihung = CONV #( ls_formation-original_reihung_tremola ) ).
            lo_fahrzeug->set_orientierung_src( lc_orient_src_tremola ).                                ">001< (+)
          ENDIF.                                                                                       ">001< (+)
        ENDIF.
      ENDWHILE.

    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IO_5_TREMOLA->SET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IO_5_SCHICHT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_schicht.

    mo_schicht = io_schicht.

    CLEAR ms_output-scenario-shift.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IO_5_TREMOLA->TRANSFORM_AND_UPDATE_DB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD transform_and_update_db.

    DATA(ls_tremola_data) = VALUE zio_5_tremola( ).

    CALL TRANSFORMATION ('ID') SOURCE request = ms_output RESULT XML ls_tremola_data-request.
    CALL TRANSFORMATION ('ID') SOURCE response = ms_response RESULT XML ls_tremola_data-response.

    ls_tremola_data-schicht = mo_schicht->get_id( ).

    MODIFY zio_5_tremola FROM ls_tremola_data.

    ms_request = ms_output.

  ENDMETHOD.
ENDCLASS.