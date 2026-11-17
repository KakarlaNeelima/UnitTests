class ZCL_IA_2RULES definition
  public
  final
  create public .

public section.

  constants MC_APPLID type ZSE_2_APPLICATION value 'ZIA_2_REAL' ##NO_TEXT.
  constants MC_PNAME type ZIA_2LOFPM_PNAME value 'KM_SIGNAL_DEV' ##NO_TEXT.

  class-methods GET_FAHRZEUG
    importing
      !IV_FZTYP type ZIA_2_ID_FZTYP
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IV_IGNORE_ERRORS type BOOLEAN
    returning
      value(RO_FAHRZEUG) type ref to ZCL_IA_2VEHICLE .
  class-methods GET_BASIS_FAHRZEUG
    importing
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IV_IGNORE_ERRORS type BOOLEAN
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER
    exporting
      !EO_FAHRZEUGE type ref to CL_OBJECT_MAP
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods GET_MET_FAHRZEUGE
    importing
      !IV_IGNORE_ERRORS type BOOLEAN
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
    returning
      value(RO_FAHRZEUGE) type ref to CL_OBJECT_MAP .
  class-methods IS_REGEL_PFLICHT
    importing
      !IV_REGEL type ZIA_2_REGEL
      !IV_OFFENE_STRECKE type BOOLEAN
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  class-methods CHECK_QUER_KM
    importing
      !IS_AUFTRAG type ZIA_2ORDER
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods CHECK_DATUM
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_AUFTRAG type ZIA_2ORDER optional
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods CHECK_AS_AUSDEHNUNG
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_AUFTRAG type ZIA_2ORDER optional
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods CHECK_SA_GAP
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_AUFTRAG type ZIA_2ORDER optional
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods GET_FAHRZEUGE
    importing
      !IO_AUFTRAG type ref to ZCL_IA_2ORDER optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
      !IS_AUFTRAG type ZIA_2ORDER optional
      !IV_IGNORE_ERRORS type BOOLEAN
      !IV_VORSCHAU type ZIA_2_VORSCHAU optional
    exporting
      !EO_FAHRZEUGE type ref to CL_OBJECT_MAP
    returning
      value(RV_SUCCESS) type BOOLEAN .
  class-methods CHECK_AUF_EINZELKAPAS
    importing
      !IS_AUFTRAG type ZIA_2ORDER
      !IV_IGNORE_ERRORS type BOOLEAN optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE
    exporting
      !ET_EINZELKAPAS type ZIA_2_ORDER_CAP_T
      !EV_CRITICAL_ERROR type BOOLEAN
    returning
      value(RV_IS_VALID) type BOOLEAN .
  class-methods GET_REGELSTEUERUNG
    returning
      value(RT_REGELN) type ZIA_2CONTROL_AP_T .
  class-methods GET_SITZPLATZ
    importing
      !IV_MAX_AUSLASTUNG type ZIA_2_AUSLASTUNG_TIME
      !IV_ZDAUER type ZIA_2_DLZ
    changing
      !CO_SITZPLATZ_A type ref to ZCL_IA_2SEAT
      !CO_SITZPLATZ type ref to ZCL_IA_2SEAT
      !CV_ERROR type BOOLEAN .
  class-methods CHECK_AUF_EINZELKAPAS_RULES
    importing
      !IO_SITZPLATZ_A type ref to ZCL_IA_2SEAT
      !IO_SITZPLATZ_FREI type ref to ZCL_IA_2SEAT
      !IO_SITZPLATZ_V type ref to ZCL_IA_2SEAT
    exporting
      !EO_SITZPLATZ_A type ref to ZCL_IA_2SEAT
      !EV_ERROR type BOOLEAN
      !EV_IS_VALID type BOOLEAN
      !EV_ERROR_FLAG type BOOLEAN .
  class-methods MOVE_SEATS_INSTANCE
    exporting
      !EV_IS_VALID type BOOLEAN
      !EV_CRITICAL_ERROR type BOOLEAN .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA mt_regelsteuerung TYPE zia_2control_ap_t .

    CLASS-METHODS write_to_mm
      IMPORTING
        !iv_regel          TYPE zia_2_regel
        !io_arbeitsstelle  TYPE REF TO zcl_ia_2wrkplace
        !is_auftrag        TYPE zia_2order OPTIONAL
        !iv_success        TYPE boolean
        !iv_offene_strecke TYPE boolean OPTIONAL .
ENDCLASS.



CLASS ZCL_IA_2RULES IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FZTYP                       TYPE        ZIA_2_ID_FZTYP
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [<-()] RO_FAHRZEUG                    TYPE REF TO ZCL_IA_2VEHICLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrzeug.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_FAHRZEUG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       18.09.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lo_schicht) = io_arbeitsstelle->get_schicht( ).

    DATA(lt_fahrzeuge_verplant) = lo_schicht->get_fahrzeuge_verplant( ).
    DATA(lt_fahrzeuge_frei) = lo_schicht->get_fahrzeuge_frei( ).

    DATA(lv_fztyp_count) = lo_schicht->get_fahrzeuge( iv_filter_fztyp = iv_fztyp )->size( ).
    DATA(lv_fztyp_max)   = lo_schicht->get_parameter( )->get_single_fztyp_params( iv_id_fztyp = iv_fztyp )-zanz_fz.

    " Verfügbarkeit des Fahrzeugtyps berücksichtigen (Anzahl bereits verplante Fahrzeugtypen < Anzahl verfügbare Fahrzeugtypen)
    IF lv_fztyp_count < lv_fztyp_max OR iv_ignore_errors = abap_true.

      READ TABLE lt_fahrzeuge_frei WITH KEY zid_fztyp = iv_fztyp INTO DATA(ls_fahrzeug).
      IF sy-subrc <> 0.
        " Kein verfügbares fahrzeug gefunden, Neues Fahrzeug anlegen
        ls_fahrzeug-zid_fzg   = zcl_ia_2utilities2=>get_next_id( ).
        ls_fahrzeug-zid_fztyp = iv_fztyp.
        INSERT zia_2vehicles FROM ls_fahrzeug.
        COMMIT WORK.
      ENDIF.

*      CREATE OBJECT ro_fahrzeug
*        EXPORTING
*          iv_id            = ls_fahrzeug-zid_fzg
*          io_arbeitsstelle = io_arbeitsstelle.

      ro_fahrzeug = NEW zcl_ia_2vehicle(
                      iv_id = ls_fahrzeug-zid_fzg
                      io_arbeitsstelle = io_arbeitsstelle ).


    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_BASIS_FAHRZEUG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER
* | [<---] EO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_basis_fahrzeug.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_BASIS_FAHRZEUG
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CONSTANTS: lc_regel   TYPE zia_2_rule VALUE 302.
    DATA: ls_auftrag   TYPE zia_2order.
    DATA: lt_fahrzeuge TYPE zia_2vehicles_t,
          ls_fahrzeug  TYPE zia_2vehicles,
          lt_fzg_type  TYPE TABLE OF zia_2_id_fztyp,
          lt_basis_fzg TYPE TABLE OF zia_2veh_typ,
          lo_fahrzeug  TYPE REF TO zcl_ia_2vehicle.

    eo_fahrzeuge = NEW cl_object_map( ).

    rv_success = abap_true.
    "Typ des Basisfahrzeugs ermitteln
    IF io_auftrag->get_data( )-zzzugangsart EQ 2.
      SELECT * FROM zia_2veh_typ INTO TABLE lt_basis_fzg WHERE zbasisfzg_pneu EQ abap_true.
    ELSEIF io_arbeitsstelle->is_in_tunnel( ) EQ abap_true.
      SELECT * FROM zia_2veh_typ INTO TABLE lt_basis_fzg WHERE zbasisfzg EQ abap_true.
    ELSE.
      SELECT * FROM zia_2veh_typ INTO TABLE lt_basis_fzg WHERE zbasisfzg_os EQ abap_true.
    ENDIF.

***************************************************************************************************
*    Business Logik der Regel
***************************************************************************************************
    " Hole verfügbare Fahrzeuge
    lt_fahrzeuge = io_arbeitsstelle->get_schicht( )->get_fahrzeuge_frei( ).

    LOOP AT lt_basis_fzg INTO DATA(ls_basis_fzg).

      DO ls_basis_fzg-zanz_bfz TIMES. "OPTREAL-90

        " Verfügbarkeit des Fahrzeugtyps berücksichtigen (Anzahl bereits verplante Fahrzeugtypen < Anzahl verfügbare Fahrzeugtypen)
        IF io_arbeitsstelle->get_schicht( )->get_fahrzeuge( iv_filter_fztyp = ls_basis_fzg-zid_fztyp )->size( ) < io_arbeitsstelle->get_schicht( )->get_parameter( )->get_single_fztyp_params( iv_id_fztyp = ls_basis_fzg-zid_fztyp )-zanz_fz
          OR iv_ignore_errors = abap_true.
          READ TABLE lt_fahrzeuge WITH KEY zid_fztyp = ls_basis_fzg-zid_fztyp INTO ls_fahrzeug.

          IF sy-subrc <> 0.
            " Kein verfügbares fahrzeug gefunden, Neues Fahrzeug anlegen
            ls_fahrzeug-zid_fzg = zcl_ia_2utilities2=>get_next_id( ).
            ls_fahrzeug-zid_fztyp = ls_basis_fzg-zid_fztyp.
            INSERT zia_2vehicles FROM ls_fahrzeug.
          ENDIF.

*         CREATE OBJECT lo_fahrzeug EXPORTING iv_id = ls_fahrzeug-zid_fzg io_arbeitsstelle = io_arbeitsstelle.

          lo_fahrzeug = NEW zcl_ia_2vehicle(
                           iv_id = ls_fahrzeug-zid_fzg
                           io_arbeitsstelle = io_arbeitsstelle ).

          eo_fahrzeuge->put(  EXPORTING key = lo_fahrzeug->get_id( )      value = lo_fahrzeug ).
          DELETE lt_fahrzeuge WHERE zid_fzg = ls_fahrzeug-zid_fzg. "Jdes FZ darf nur 1 mal verwendet werden
        ELSE.
          rv_success = abap_false.
        ENDIF.
      ENDDO.
    ENDLOOP.

    write_to_mm( EXPORTING iv_regel = lc_regel   io_arbeitsstelle = io_arbeitsstelle   is_auftrag = ls_auftrag   iv_success = rv_success ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_MET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [<-()] RO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_met_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_MET_FAHRZEUGE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    ro_fahrzeuge = NEW cl_object_map( ).
    SELECT * FROM zia_2veh_typ INTO TABLE @DATA(lt_fz_typen) WHERE zmet = @abap_true.

    LOOP AT lt_fz_typen ASSIGNING FIELD-SYMBOL(<ls_fz_typ>).
      CHECK io_arbeitsstelle->get_fahrzeuge( iv_filter_fztyp = <ls_fz_typ>-zid_fztyp )->is_empty( ) = abap_true.
      DATA(lo_fahrzeug) = get_fahrzeug( EXPORTING iv_fztyp = <ls_fz_typ>-zid_fztyp    io_arbeitsstelle = io_arbeitsstelle   iv_ignore_errors = iv_ignore_errors ).

      IF lo_fahrzeug IS BOUND.
        ro_fahrzeuge->put( EXPORTING key = lo_fahrzeug->get_id( ) value = lo_fahrzeug ).
      ENDIF.
    ENDLOOP.

    write_to_mm(
      EXPORTING iv_regel = 110
                io_arbeitsstelle = io_arbeitsstelle
                iv_success = COND #( WHEN ro_fahrzeuge->size( ) > 0 THEN abap_true ELSE abap_false )
    ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>IS_REGEL_PFLICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REGEL                       TYPE        ZIA_2_REGEL
* | [--->] IV_OFFENE_STRECKE              TYPE        BOOLEAN
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_regel_pflicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : IS_REGEL_PFLICHT
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lt_regeln TYPE zia_2control_ap_t,
          ls_regel  TYPE zia_2control_ap.

    lt_regeln = zcl_ia_2rules=>get_regelsteuerung( ).
    READ TABLE lt_regeln WITH KEY zregel = iv_regel INTO ls_regel.

    IF sy-subrc = 0.
      IF iv_offene_strecke = abap_false AND ls_regel-zgbt_man_plan = 2.
        rv_boolean = abap_true.
      ELSEIF iv_offene_strecke = abap_true AND ls_regel-zosx_man_plan = 2.
        rv_boolean = abap_true.
      ENDIF.
    ELSE.
      rv_boolean = abap_true.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2RULES=>WRITE_TO_MM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REGEL                       TYPE        ZIA_2_REGEL
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [--->] IV_SUCCESS                     TYPE        BOOLEAN
* | [--->] IV_OFFENE_STRECKE              TYPE        BOOLEAN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD write_to_mm.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : WRITE_TO_MM
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: lv_msgty      TYPE syst-msgty.

    lv_msgty = COND #( WHEN iv_success = abap_true
                       THEN 'S'
                       ELSE COND #( WHEN zcl_ia_2rules=>is_regel_pflicht( iv_regel = iv_regel   iv_offene_strecke = iv_offene_strecke ) = abap_true
                                    THEN 'E'
                                    ELSE 'W' ) ).

    zcl_ia_2message_manager=>get_instance( )->add_message( EXPORTING iv_msgno = iv_regel
                                                                      iv_msgty = lv_msgty
                                                                      iv_msgv1 = io_arbeitsstelle->get_schicht( )->get_id( )
                                                                      iv_msgv2 = io_arbeitsstelle->get_id( )
                                                                      iv_msgv3 = is_auftrag-aufnr ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_DATUM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_datum.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : UNLOCK
*----------------------------------------------------------------------*
* >000<   7.50       20.05.2025     tcs / Pratima Sahu
* The check_datum method checks if an order's start and end dates fall
* within the valid date range of a shift at a workplace. It assigns the
*appropriate order data based on input parameters (is_auftrag or io_auftrag),
* and if the order's dates are valid, it sets a success flag (rv_success).
*Finally, the method writes this information to the MM system with a
* specified rule identifier.
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*

    " Define a constant for the rule identifier
    CONSTANTS: lc_regel   TYPE zia_2_rule VALUE 306.

    " Declare a variable to store the order data
    DATA: ls_auftrag    TYPE zia_2order.

    " Check if the input parameter is_auftrag is not initial (not empty)
    IF is_auftrag IS NOT INITIAL.
      ls_auftrag = is_auftrag.  " Assign the value of is_auftrag to ls_auftrag
    ELSEIF io_auftrag IS NOT INITIAL.
      " If is_auftrag is empty, get order data from io_auftrag object
      ls_auftrag = io_auftrag->get_data( ).
    ENDIF.

    "* OPTREAL-211: The order is checked with the shift date, since the workplace date includes the deduction parameter for entry and exit"

    " Check if the order's start and end dates (gstrp and gltrp) fall within the shift date range
    IF NOT ( ls_auftrag-gstrp > io_arbeitsstelle->get_schicht( )->get_data( )-end_datum OR ls_auftrag-gltrp < io_arbeitsstelle->get_schicht( )->get_data( )-start_datum ).
      rv_success = abap_true.  " Set success flag to true if the order is within the valid date range
    ENDIF.

    " Write data to mm with the rule, workplace, order, and success flag
    write_to_mm( EXPORTING iv_regel = lc_regel
                                 io_arbeitsstelle = io_arbeitsstelle
                                 is_auftrag = ls_auftrag
                                 iv_success = rv_success ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_QUER_KM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_quer_km.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA: ls_quer  TYPE zia_2lateral_tb.

    IF is_auftrag-zstdkz = 'Q'.
      SELECT SINGLE * INTO ls_quer
        FROM zia_2lateral_tb
        WHERE zkm_e = is_auftrag-zzkmvpl AND zzperi = is_auftrag-zzperi.

      IF sy-subrc = 0.
        IF ls_quer-zqs CS is_auftrag-zlage.
          rv_success = abap_true.
        ENDIF.
      ENDIF.
    ELSE.
      rv_success = abap_true.
    ENDIF.

    IF rv_success = abap_false.

      zcl_ia_2message_mnger=>get_instance( )->add_message(
        EXPORTING
        iv_msgno = 180
        iv_msgty = 'E'
        iv_msgv1 = is_auftrag-aufnr
        iv_msgv2 = is_auftrag-zlage
        ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_AS_AUSDEHNUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_as_ausdehnung.
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

    " DECLARE LOCAL VARIABLES
    DATA: lt_ausdehnungen TYPE zia_2range_km_t.    " TABLE TO HOLD RANGE OF KILOMETERS
    DATA: ls_auftrag TYPE zia_2order.               " ORDER STRUCTURE
    CONSTANTS: lc_regel TYPE zia_2_rule VALUE 304. " RULE IDENTIFIER CONSTANT

    " GET THE SIGNAL SECTIONS FOR THE NEW ORDER
    DATA(lt_signalabschn) = io_arbeitsstelle->get_sa_ext_for_new_auftrag( io_auftrag = io_auftrag ).

    " GET THE MAXIMUM EXTENSION VALUE FROM THE WORKPLACE SHIFT PARAMETERS
    DATA(lv_max_ausdehnung) = io_arbeitsstelle->get_schicht( )->get_parameter( )->get_data( )-max_ausdehnung.

    " CHECK IF THE NUMBER OF SIGNAL SECTIONS DOES NOT EXCEED THE MAXIMUM ALLOWED EXTENSION
    IF lines( lt_signalabschn ) <= lv_max_ausdehnung.
      rv_success = abap_true.   " SET SUCCESS FLAG TO TRUE IF CONDITION IS MET
    ENDIF.

    " GET THE ORDER DATA
    ls_auftrag = io_auftrag->get_data( ).

    " WRITE THE RESULT TO THE MM SYSTEM WITH THE RULE IDENTIFIER, WORKPLACE, ORDER, AND SUCCESS FLAG
    write_to_mm( EXPORTING iv_regel = lc_regel
                                 io_arbeitsstelle = io_arbeitsstelle
                                 is_auftrag = ls_auftrag
                                 iv_success = rv_success ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_AUF_EINZELKAPAS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [<---] ET_EINZELKAPAS                 TYPE        ZIA_2_ORDER_CAP_T
* | [<---] EV_CRITICAL_ERROR              TYPE        BOOLEAN
* | [<-()] RV_IS_VALID                    TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_auf_einzelkapas.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    DATA: lo_fahrzeuge_i      TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeug         TYPE REF TO zcl_ia_2vehicle,
          lo_sitzplaetze_i    TYPE REF TO cl_object_collection_iterator,
          lo_sitzplaetze      TYPE REF TO cl_object_map,
          lo_sitzplatz        TYPE REF TO zcl_ia_2seat,
          lt_benutzte_plaetze TYPE zia_2range_string_t,
          ls_benutzte_plaetze LIKE LINE OF lt_benutzte_plaetze,
          lo_sitzplatz_v      TYPE REF TO zcl_ia_2seat,
          lo_sitzplatz_a      TYPE REF TO zcl_ia_2seat,
          lo_sitzplatz_frei   TYPE REF TO zcl_ia_2seat,
          lo_sitzplatz_belegt TYPE REF TO zcl_ia_2seat.

    rv_is_valid = abap_true.

    " NETTOARBEITSZEIT DER SCHICHT BERECHNEN
    DATA(lv_max_auslastung) = io_arbeitsstelle->get_max_auslastung( ).

    " HOLE EINZELKAPAS ZUM AUFTRAG
    SELECT * FROM zia_2order_cap INTO TABLE @DATA(lt_einzelkapazitaeten) WHERE aufnr = @is_auftrag-aufnr.

    "*******************
    "* FINDE DEN PASSENDSTEN SITZPLATZ
    "* DURCHLAUFE ALLE AUFTRAGSVORGÄNGE
    "***************
    LOOP AT lt_einzelkapazitaeten ASSIGNING FIELD-SYMBOL(<ls_einzelkapazitaet>).
      DATA(lv_max_auslastung_a) = lv_max_auslastung.

      " ÜBERSCHREITET DIE EINZELKAPAZITÄT DIE MAXIMALE AUSLASTUNG?
      IF <ls_einzelkapazitaet>-zdauer > lv_max_auslastung AND iv_ignore_errors = abap_false.
        DATA(lv_error) = abap_true.
        rv_is_valid = abap_false.
        write_to_mm( EXPORTING iv_regel = 500 io_arbeitsstelle = io_arbeitsstelle is_auftrag = is_auftrag iv_success = rv_is_valid ).
        RETURN.
      ENDIF.


      " DURCHLAUFE ALLE FAHRZEUGE
      lo_fahrzeuge_i ?= io_arbeitsstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).

        "AUFTRÄGE MIT ZUGANGSART PNEU NUR AUF PNEUFAHRZEUGEN
        IF ( is_auftrag-zzzugangsart = zcl_ia_2order=>mc_zgart_pneu AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_false ) OR
           ( is_auftrag-zzzugangsart = zcl_ia_2order=>mc_zgart_schiene AND lo_fahrzeug->is_basis_fz_pneu( ) EQ abap_true ).
          CONTINUE.
        ENDIF.

        " DURCHLAUFE ALLE SITZPLÄTZE
        lo_sitzplaetze = lo_fahrzeug->get_sitzplaetze( ).
        lo_sitzplaetze_i ?= lo_sitzplaetze->get_values_iterator( ).
        WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
          lo_sitzplatz ?= lo_sitzplaetze_i->get_next( ).

          CHECK lo_sitzplatz->is_reserviert( ) = abap_false.

          " EIN BENUTZETER PLATZ DARF FÜR DENSELBEN AUFTRAG KEIN ZWEITES MAL VERWENDET WERDEN
                                                   "#EC EMPTY_IF_BRANCH
          IF lt_benutzte_plaetze IS INITIAL OR ( lt_benutzte_plaetze IS NOT INITIAL AND lo_sitzplatz->get_id( ) NOT IN lt_benutzte_plaetze ). "#EC EMPTY_IF_BRANCH
            CLEAR sy-subrc. " THIS IS JUST ADDED TO GET RID OF ATC.
          ELSE.
            CONTINUE.
          ENDIF.

          " BELEGTEN SITZPLATZ BEFÜLLEN
          IF lo_sitzplatz_belegt IS INITIAL AND lo_sitzplatz->is_frei( ) = abap_false.
            lo_sitzplatz_belegt = lo_sitzplatz.
          ENDIF.


          " FREIEN SITZPLATZ BEFÜLLEN (KÖNNTE SCHON MIT ANDERER EK AUS AUFTRAG BEFÜLLT SEIN, AUFTRAG WIRD IN DIESER METHODE NICHT GEUPDATED)
          IF lo_sitzplatz->get_data( )-zobjid = 0 AND lo_sitzplatz_frei IS INITIAL.
            lo_sitzplatz_frei = lo_sitzplatz.
          ENDIF.



          IF lo_sitzplatz_v IS INITIAL.
            lo_sitzplatz_v = lo_sitzplatz.
          ENDIF.

          " STIMMT DIE QUALIFIKATION?
                                                   "#EC EMPTY_IF_BRANCH
          IF lo_sitzplatz->get_data( )-zobjid = <ls_einzelkapazitaet>-zobjid AND lo_sitzplatz->get_data( )-zobjty = <ls_einzelkapazitaet>-zobjty.
            CLEAR sy-subrc. " THIS IS JUST ADDED TO GET RID OF ATC.
          ELSE.
            IF lo_sitzplatz->is_frei( ) = abap_false.
              CLEAR sy-subrc. " THIS IS JUST ADDED TO GET RID OF ATC.
            ENDIF.
            CONTINUE.
          ENDIF.

          " STRATEGIE V - FINDE DEN GEEIGNETSTEN SITZPLATZ
          IF lo_sitzplatz->get_dlz( ) < lo_sitzplatz_v->get_dlz( ).
            lo_sitzplatz_v = lo_sitzplatz.
          ENDIF.

          " STRATEGIE A
          DATA lv_dauer2 TYPE zia_2_dlz.
          lv_dauer2 = lo_sitzplatz->get_dlz( ) + <ls_einzelkapazitaet>-zdauer.
          IF lv_dauer2 <= lv_max_auslastung_a AND ( lo_sitzplatz_a IS INITIAL OR lo_sitzplatz->get_dlz( ) > lo_sitzplatz_a->get_dlz( ) ).
            lo_sitzplatz_a = lo_sitzplatz.
            lv_error = abap_true.
          ENDIF.
        ENDWHILE.

      ENDWHILE.
*********************************************************************************************************************
* PRÜFE, OB MAX. AUSLASTUNG ÜBERSCHRITTEN WIRD UND NEHME FREIEN SITZPLATZ
*********************************************************************************************************************
      zcl_ia_2rules=>check_auf_einzelkapas_rules( EXPORTING
                                                  io_sitzplatz_a = lo_sitzplatz_a
                                                  io_sitzplatz_v = lo_sitzplatz_v
                                                  io_sitzplatz_frei = lo_sitzplatz_frei
                                                  IMPORTING
                                                  eo_sitzplatz_a = lo_sitzplatz_a
                                                  ev_error = lv_error
                                                  ev_is_valid = rv_is_valid
                                                  ev_error_flag = <ls_einzelkapazitaet>-error_flag ).
*********************************************************************************************************************
* RÜCKGABESTRUKTUR ANPASSEN ODER ABBRECHEN
*********************************************************************************************************************

      IF lo_sitzplatz_v IS INITIAL OR lo_sitzplatz_a IS INITIAL.
        zcl_ia_2rules=>move_seats_instance( IMPORTING ev_critical_error = ev_critical_error ev_is_valid = rv_is_valid ).
        write_to_mm( EXPORTING iv_regel = 324   io_arbeitsstelle = io_arbeitsstelle   is_auftrag = is_auftrag   iv_success = rv_is_valid ).
        RETURN.
      ELSEIF lv_error = abap_false OR iv_ignore_errors = abap_true.

        <ls_einzelkapazitaet>-zid_fzg_platz = lo_sitzplatz_a->get_id( ).

        " DER SITZPLATZ DARF FÜR DIESEN AUFTRAG KEIN ZWEITES MAL MEHR BENUTZT WERDEN
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <ls_einzelkapazitaet>-zid_fzg_platz ) TO lt_benutzte_plaetze.
      ELSE.
        rv_is_valid = abap_false.
        write_to_mm( EXPORTING iv_regel = 501   io_arbeitsstelle = io_arbeitsstelle   is_auftrag = is_auftrag   iv_success = rv_is_valid ).
      ENDIF.

      CLEAR: lo_sitzplatz_a, lo_sitzplatz_v, lo_sitzplatz_frei, lo_sitzplatz_belegt.
    ENDLOOP.
    CLEAR: lt_benutzte_plaetze.

    et_einzelkapas = lt_einzelkapazitaeten.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_SA_GAP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_sa_gap.
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

    " DECLARE LOCAL DATA TYPES AND VARIABLES
    DATA: lt_ausdehnungen TYPE zia_2_range_km_t,
          ls_sa           TYPE zia_2sc,
          ls_start_sa     TYPE zia_2sc,
          ls_end_sa       TYPE zia_2sc,
          ls_met_start_sa TYPE zia_2sc,
          ls_met_end_sa   TYPE zia_2sc.
    DATA: ls_auftrag TYPE zia_2order.
    DATA: ls_nachfolgender_sa  TYPE zia_2sc,
          ls_vorhergehender_sa TYPE zia_2sc.
    DATA: lv_auf_start TYPE zia_2_kmin,
          lv_auf_end   TYPE zia_2_kmax.
    CONSTANTS: lc_regel   TYPE zia_2_rule VALUE 315.
    DATA: ls_met       TYPE zia_2met.
    DATA:   lv_signal_km_abweich TYPE zia_2_lofpm_appdesc.
    DATA: lv_km_abstand TYPE zia_2_km.

    " READ THE DEVIATION PARAMETER FOR THE DISTANCE SIGNAL SECTION
    SELECT SINGLE value
      FROM zse_2_params_dep
      INTO lv_signal_km_abweich
      WHERE application = mc_applid AND name = mc_pname.

    " GET THE ORDER DATA
    ls_auftrag = io_auftrag->get_data( ).

    " RETRIEVE NEW SIGNAL SECTIONS FOR THE ORDER
    DATA(lt_sa_auftrag) = io_arbeitsstelle->get_sa_ext_for_new_auftrag( io_auftrag = io_auftrag ).
    DATA(lt_sp_autrag) = io_auftrag->get_sp( ).

    " INITIALIZE SUCCESS FLAG
    rv_success = abap_true.

    " RETRIEVE THE SIGNAL SECTIONS FROM PREVIOUS WORKPLACES
    DATA(li_arbst_i) = io_arbeitsstelle->get_schicht( )->get_arbeitsstellen( )->get_values_iterator( ).
    DATA lt_sa_other_arbst TYPE zia_2_sgnl_sec_t.

    " LOOP THROUGH ALL PREVIOUS WORKPLACES TO CHECK SIGNAL SECTION OVERLAPS
    WHILE li_arbst_i->has_next( ) AND rv_success EQ abap_true.
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbst_i->get_next( ) ).
      CHECK lo_arbstelle->get_id( ) NE io_arbeitsstelle->get_id( ). " SKIP THE CURRENT WORKPLACE
      CHECK lo_arbstelle->is_btg( ) EQ abap_false. " SKIP BTG WORKPLACES
      DATA(li_sp_km_i) = lo_arbstelle->get_sp_kilometer( )->get_values_iterator( ).

      " LOOP THROUGH THE KILOMETERS OF THE PREVIOUS WORKPLACE AND PROCESS SIGNAL SECTIONS
      WHILE li_sp_km_i->has_next( ).
        DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( li_sp_km_i->get_next( ) ).
        APPEND LINES OF lo_sp_km->get_sa( ) TO lt_sa_other_arbst.
        SORT lt_sa_other_arbst BY km_von ASCENDING.

        " HANDLE OVERLAPS BETWEEN SIGNAL SECTIONS
        CLEAR: lt_sa_other_arbst.
        APPEND LINES OF lo_sp_km->get_sa( ) TO lt_sa_other_arbst.
        SORT lt_sa_other_arbst BY km_von ASCENDING.

        LOOP AT lt_sa_auftrag ASSIGNING FIELD-SYMBOL(<ls_sa_autrag>).
          READ TABLE lt_sa_other_arbst WITH KEY zsa = <ls_sa_autrag>-zsa TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
          IF syst-subrc = 0.
            rv_success = abap_false. " SET FAILURE FLAG IF OVERLAP DETECTED
            zcl_ia_2message_manager=>get_instance( )->add_message( EXPORTING iv_msgno = 115
                                                                      iv_msgty = 'E'
                                                                      iv_msgv1 = io_arbeitsstelle->get_schicht( )->get_id( )
                                                                      iv_msgv2 = io_arbeitsstelle->get_id( )
                                                                      iv_msgv3 = is_auftrag-aufnr ).
            RETURN.
          ENDIF.
        ENDLOOP.

        " HANDLE DISTANCE CHECKS FOR SIGNAL SECTION
        IF io_arbeitsstelle->get_data( )-zid_eiz = lo_arbstelle->get_data( )-zid_eiz.
*        IF lt_sa_other_arbst IS NOT INITIAL.
          DATA(ls_prev) = zcl_ia_2utilities2=>get_signalabschnitt_prev( EXPORTING is_sa = lt_sa_other_arbst[ 1 ] ).
          DATA(ls_next) = zcl_ia_2utilities2=>get_signalabschnitt_next( EXPORTING is_sa = lt_sa_other_arbst[ lines( lt_sa_other_arbst ) ] ).

          APPEND ls_prev TO lt_sa_other_arbst.
          APPEND ls_next TO lt_sa_other_arbst.
          SORT lt_sa_other_arbst BY km_von ASCENDING.
*        ENDIF.

          LOOP AT lt_sa_auftrag ASSIGNING <ls_sa_autrag>.
            READ TABLE lt_sa_other_arbst WITH KEY zsa = <ls_sa_autrag>-zsa TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
            IF syst-subrc = 0.
              zcl_ia_2message_manager=>get_instance( )->add_message( EXPORTING iv_msgno = 115
                                                                        iv_msgty = 'W'
                                                                        iv_msgv1 = io_arbeitsstelle->get_schicht( )->get_id( )
                                                                        iv_msgv2 = io_arbeitsstelle->get_id( )
                                                                        iv_msgv3 = is_auftrag-aufnr ).
            ENDIF.
          ENDLOOP.
        ELSE.
          " IF EIZ IDS DO NOT MATCH, HANDLE ACCORDINGLY
*        IF lt_sa_other_arbst IS NOT INITIAL.
          ls_prev = zcl_ia_2utilities2=>get_signalabschnitt_prev( EXPORTING is_sa = lt_sa_other_arbst[ 1 ] ).
          ls_next = zcl_ia_2utilities2=>get_signalabschnitt_next( EXPORTING is_sa = lt_sa_other_arbst[ lines( lt_sa_other_arbst ) ] ).

          APPEND ls_prev TO lt_sa_other_arbst.
          APPEND ls_next TO lt_sa_other_arbst.
          SORT lt_sa_other_arbst BY km_von ASCENDING.
          ls_prev = zcl_ia_2utilities2=>get_signalabschnitt_prev( EXPORTING is_sa = lt_sa_other_arbst[ 1 ] ).
          ls_next = zcl_ia_2utilities2=>get_signalabschnitt_next( EXPORTING is_sa = lt_sa_other_arbst[ lines( lt_sa_other_arbst ) ] ).
          APPEND ls_prev TO lt_sa_other_arbst.
          APPEND ls_next TO lt_sa_other_arbst.
          SORT lt_sa_other_arbst BY km_von ASCENDING.


          LOOP AT lt_sa_auftrag ASSIGNING <ls_sa_autrag>.
            READ TABLE lt_sa_other_arbst WITH KEY zsa = <ls_sa_autrag>-zsa TRANSPORTING NO FIELDS. "#EC PREF_LINE_EX
            IF syst-subrc = 0.
              zcl_ia_2message_manager=>get_instance( )->add_message( EXPORTING iv_msgno = 115
                                                                        iv_msgty = 'W'
                                                                        iv_msgv1 = io_arbeitsstelle->get_schicht( )->get_id( )
                                                                        iv_msgv2 = io_arbeitsstelle->get_id( )
                                                                        iv_msgv3 = is_auftrag-aufnr ).
            ENDIF.
          ENDLOOP.
        ENDIF.

        CLEAR lt_sa_other_arbst. " CLEAR SIGNAL SECTION LIST FOR THE NEXT ITERATION

      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_FAHRZEUGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUFTRAG                     TYPE REF TO ZCL_IA_2ORDER(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE
* | [--->] IS_AUFTRAG                     TYPE        ZIA_2ORDER(optional)
* | [--->] IV_IGNORE_ERRORS               TYPE        BOOLEAN
* | [--->] IV_VORSCHAU                    TYPE        ZIA_2_VORSCHAU(optional)
* | [<---] EO_FAHRZEUGE                   TYPE REF TO CL_OBJECT_MAP
* | [<-()] RV_SUCCESS                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fahrzeuge.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CONSTANTS: lc_regel   TYPE zia_2_rule VALUE 303.
    DATA: lt_ausdehnungen TYPE zia_2_range_km_t,
          ls_auftrag      TYPE zia_2order.

    IF is_auftrag IS NOT INITIAL.
      ls_auftrag = is_auftrag.
    ELSEIF io_auftrag IS NOT INITIAL.
      ls_auftrag = io_auftrag->get_data( ).
    ENDIF.

***************************************************************************************************
*    Business Logik der Regel
***************************************************************************************************
    DATA: lt_mapping  TYPE TABLE OF zia_2veh_typ_sp,
          ls_mapping  LIKE LINE OF lt_mapping,
          lv_ser_prod TYPE matsv,
          lv_skip     TYPE boolean.
    DATA: lo_fahrzeug           TYPE REF TO zcl_ia_2vehicle.
    DATA: lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator,
          lo_fahrzeuge   TYPE REF TO cl_object_map.

    eo_fahrzeuge = NEW cl_object_map( ).

    lv_ser_prod = ls_auftrag-matnr.

    SELECT * FROM zia_2veh_typ_sp INTO TABLE lt_mapping WHERE zzperi = ls_auftrag-zzperi AND matsv = lv_ser_prod.

    rv_success = abap_true.

    LOOP AT lt_mapping INTO ls_mapping.
      " Hat die AS bereits ein passendes Fahrzeug?
      CHECK io_arbeitsstelle->get_fahrzeuge( iv_filter_fztyp = ls_mapping-zid_fztyp )->is_empty( ) = abap_true.

      lo_fahrzeug = get_fahrzeug( EXPORTING iv_fztyp = ls_mapping-zid_fztyp     io_arbeitsstelle = io_arbeitsstelle   iv_ignore_errors = iv_ignore_errors ).

      IF lo_fahrzeug IS NOT INITIAL.
        lo_fahrzeug->set_vorschau_flag( iv_vorschau = iv_vorschau ).
        eo_fahrzeuge->put( EXPORTING key = lo_fahrzeug->get_id( )   value = lo_fahrzeug ).
        rv_success = abap_true.
      ELSE.
        rv_success = abap_false.
        EXIT.
      ENDIF.

      CLEAR lo_fahrzeug.
    ENDLOOP.

    write_to_mm( EXPORTING iv_regel = lc_regel   io_arbeitsstelle = io_arbeitsstelle   is_auftrag = ls_auftrag   iv_success = rv_success ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_REGELSTEUERUNG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_REGELN                      TYPE        ZIA_2CONTROL_AP_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_regelsteuerung.
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

    " Check if the internal table mt_regelsteuerung is empty (INITIAL)
    IF mt_regelsteuerung IS INITIAL.
      " If empty, fetch data from the zia_2control_ap table into mt_regelsteuerung
      SELECT * FROM zia_2control_ap INTO TABLE mt_regelsteuerung. "#EC CI_NOWHERE
    ENDIF.

    " Return the content of mt_regelsteuerung to rt_regeln
    rt_regeln = mt_regelsteuerung.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>GET_SITZPLATZ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MAX_AUSLASTUNG              TYPE        ZIA_2_AUSLASTUNG_TIME
* | [--->] IV_ZDAUER                      TYPE        ZIA_2_DLZ
* | [<-->] CO_SITZPLATZ_A                 TYPE REF TO ZCL_IA_2SEAT
* | [<-->] CO_SITZPLATZ                   TYPE REF TO ZCL_IA_2SEAT
* | [<-->] CV_ERROR                       TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sitzplatz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lv_dauer2 TYPE zia_2_dlz.
*    DATA(lv_dauer2) = co_sitzplatz->get_dlz( ) + iv_zdauer.
    lv_dauer2 = co_sitzplatz->get_dlz( ) + iv_zdauer.
    IF lv_dauer2 <= iv_max_auslastung.
      IF co_sitzplatz_a IS INITIAL.
        co_sitzplatz_a = co_sitzplatz.
      ELSEIF co_sitzplatz->get_dlz( ) > co_sitzplatz_a->get_dlz( ).
        co_sitzplatz_a = co_sitzplatz.
        cv_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>CHECK_AUF_EINZELKAPAS_RULES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SITZPLATZ_A                 TYPE REF TO ZCL_IA_2SEAT
* | [--->] IO_SITZPLATZ_FREI              TYPE REF TO ZCL_IA_2SEAT
* | [--->] IO_SITZPLATZ_V                 TYPE REF TO ZCL_IA_2SEAT
* | [<---] EO_SITZPLATZ_A                 TYPE REF TO ZCL_IA_2SEAT
* | [<---] EV_ERROR                       TYPE        BOOLEAN
* | [<---] EV_IS_VALID                    TYPE        BOOLEAN
* | [<---] EV_ERROR_FLAG                  TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_auf_einzelkapas_rules.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     TCS / SIVASURYA K
*         PROGRAMMERSTELLUNG / CREATION OF PROGRAM
*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
    IF io_sitzplatz_a IS INITIAL AND io_sitzplatz_frei IS NOT INITIAL.
      eo_sitzplatz_a = io_sitzplatz_frei.
    ELSE.
      ev_error = abap_true.
      ev_is_valid = abap_false.
      eo_sitzplatz_a = io_sitzplatz_v.
      ev_error_flag = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RULES=>MOVE_SEATS_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_IS_VALID                    TYPE        BOOLEAN
* | [<---] EV_CRITICAL_ERROR              TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD move_seats_instance.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       14.10.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    ev_critical_error = abap_true.
    ev_is_valid = abap_false.
  ENDMETHOD.
ENDCLASS.