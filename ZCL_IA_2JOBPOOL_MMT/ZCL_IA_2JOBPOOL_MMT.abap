class ZCL_IA_2JOBPOOL_MMT definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_IA_2JOBPOOL_MMT .
  methods MAIN
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT
    raising
      ZCX_IA_2FAILURE .
  methods CHECK_MAT_FZG_ASSIGNMENT
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT
      !IT_MAP_MATFZG type ZIA_2MAP_MATFZG_T optional
    raising
      ZCX_IA_2FAILURE .
  methods CHECK_SERVICEPRODUKT
    importing
      !IO_SHIFT type ref to ZCL_IA_2WORKSHIFT
    changing
      !CO_MSG type ref to ZCL_IA_2MESSAGE_MANAGER
    raising
      ZCX_IA_2FAILURE .
  methods CHECK_EXISTENCE_SCHICHT_AUFTR
    importing
      !IO_SHIFT type ref to ZCL_IA_2WORKSHIFT
    changing
      !CO_MSG type ref to ZCL_IA_2MESSAGE_MANAGER
    raising
      ZCX_IA_2FAILURE .
  methods CHECK_MRCPNTLOCPLNT
    importing
      !IO_SHIFT type ref to ZCL_IA_2WORKSHIFT
      !IT_MAP_MATFZG type ZIA_2MAP_MATFZG_T optional
    raising
      ZCX_IA_2FAILURE .
  methods CHECK_MATNR_PLANT
    importing
      !IO_SHIFT type ref to ZCL_IA_2WORKSHIFT
      !IT_MAP_MATFZG type ZIA_2MAP_MATFZG_T optional
    raising
      ZCX_IA_2FAILURE .
  PROTECTED SECTION.
private section.

  methods GET_MAP_MATFZG
    importing
      !IO_SCHICHT type ref to ZCL_IA_2WORKSHIFT
    returning
      value(RT_DATA) type ZIA_2MAP_MATFZG_T .
  methods GET_PLANT_BY_ZID_EIZ
    importing
      !IV_ZID_EIZ type ZIA_2ORDER-ZID_EIZ
    returning
      value(RV_PLANT) type MARC-WERKS .
ENDCLASS.



CLASS ZCL_IA_2JOBPOOL_MMT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->CHECK_EXISTENCE_SCHICHT_AUFTR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SHIFT                       TYPE REF TO ZCL_IA_2WORKSHIFT
* | [<-->] CO_MSG                         TYPE REF TO ZCL_IA_2MESSAGE_MANAGER
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_existence_schicht_auftr.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_INSTANCE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(lt_return)  = VALUE bapiret2_t( ).

    IF io_shift->get_status( ) LT zif_ia_2_wrkshft_status=>mc_disposition_released.
      RETURN.
    ENDIF.

    DATA(lv_schicht) = io_shift->get_id( ).

    SELECT SINGLE aufnr FROM viqmel INTO @DATA(lv_aufnr)
      WHERE qmnum = @lv_schicht.
    IF lv_aufnr IS INITIAL.
      MESSAGE e559(zia_2_real) INTO DATA(lv_message).
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_return INDEX 1.
      MESSAGE e550(zia_2_real) INTO lv_message.
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_return INDEX 1.
    ENDIF.

    IF lt_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->CHECK_MATNR_PLANT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SHIFT                       TYPE REF TO ZCL_IA_2WORKSHIFT
* | [--->] IT_MAP_MATFZG                  TYPE        ZIA_2MAP_MATFZG_T(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_matnr_plant.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob alle Materialien dem Fahrzeug zugeordnet wurden
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
* >000<   7.52       14.09.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
* >001<   7.52       05.10.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-791
*----------------------------------------------------------------------*

    DATA: lo_auftraege   TYPE REF TO cl_object_map,
          lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag     TYPE REF TO zcl_ia_2order,
          ls_order       TYPE zia_2order,
          lt_order       TYPE STANDARD TABLE OF zia_2order.

    DATA(lt_mat_fzg) = VALUE zia_2map_matfzg_t( ).
    DATA(lt_return)  = VALUE bapiret2_t( ).
    DATA(lt_comp)    = VALUE bapi_alm_order_component_et( ).

    lt_mat_fzg = COND #( WHEN it_map_matfzg IS NOT INITIAL THEN it_map_matfzg ELSE get_map_matfzg( io_schicht = io_shift ) ).

    lo_auftraege = io_shift->get_auftraege( ).
    lo_auftraege_i ?= lo_auftraege->get_values_iterator( ).
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).
      CHECK lo_auftrag->get_vorschau_flag( ) = abap_false.
      CLEAR ls_order.
      ls_order = lo_auftrag->get_data( ).
      APPEND ls_order TO lt_order.
      TRY.
          zcl_ia_2lofpm_clh_application=>get_instance( iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
          DATA(lt_comp_tmp) = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent( )->get_object( iv_aufnr = lo_auftrag->get_data( )-aufnr )->get_components( ).
        ##NO_HANDLER        CATCH zcx_ia_2lofpm_agent.
        ##NO_HANDLER     CATCH cx_static_check.
          CONTINUE.
      ENDTRY.
      APPEND LINES OF lt_comp_tmp TO lt_comp.
    ENDWHILE.

    LOOP AT lt_mat_fzg INTO DATA(ls_mat_fzg).
      READ TABLE lt_order INTO ls_order WITH KEY aufnr = ls_mat_fzg-aufnr.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_comp TRANSPORTING NO FIELDS WITH KEY reserv_no = ls_mat_fzg-rsnum res_item = ls_mat_fzg-rspos
          delete_ind = abap_false orderid = ls_mat_fzg-aufnr.
        IF sy-subrc IS NOT INITIAL.
          CONTINUE.
        ENDIF.
        DATA(lv_plant) = get_plant_by_zid_eiz( ls_order-zid_eiz ).
        DATA(lv_exists) = cl_listing_check=>check_marc_exists( i_matnr = ls_mat_fzg-matnr i_werks = lv_plant ).
        IF lv_exists IS INITIAL.
          MESSAGE e562(zia_2_real) INTO DATA(lv_message) WITH ls_mat_fzg-matnr lv_plant ls_mat_fzg-aufnr.
          INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 ) INTO lt_return INDEX 1.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->CHECK_MAT_FZG_ASSIGNMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* | [--->] IT_MAP_MATFZG                  TYPE        ZIA_2MAP_MATFZG_T(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_mat_fzg_assignment.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob alle Materialien dem Fahrzeug zugeordnet wurden
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
* >000<   7.52       14.09.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
* >001<   7.52       05.10.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-791
*----------------------------------------------------------------------*
    DATA lo_auftrag_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_arbstl_i  TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftrag   TYPE REF TO zcl_ia_2order.
    DATA lo_arbstl    TYPE REF TO zcl_ia_2wrkplace.
    DATA(lt_mat_fzg) = VALUE zia_2map_matfzg_t( ).
    DATA(lt_comp)    = VALUE bapi_alm_order_component_et( ).
    DATA(lt_return)  = VALUE bapiret2_t( ).
    DATA(lv_as_name) = VALUE char3( ).


    lt_mat_fzg = COND #( WHEN it_map_matfzg IS NOT INITIAL THEN it_map_matfzg ELSE get_map_matfzg( io_schicht = io_schicht ) ).

    "Collect all schicht components/materials
    lo_auftrag_i ?= io_schicht->get_auftraege( )->get_values_iterator( ).
    WHILE lo_auftrag_i->has_next( ).
      lo_auftrag ?= lo_auftrag_i->get_next( ).
      CHECK 1 = lo_auftrag->get_data( )-zzzugangsart.   ">001< +
*      DATA(lv_aufnr) = lo_auftrag->get_data( )-aufnr.

      TRY.
          zcl_ia_2lofpm_clh_application=>get_instance( iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
          DATA(lt_comp_tmp) = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent( )->get_object( iv_aufnr = lo_auftrag->get_data( )-aufnr )->get_components( ).
        ##NO_HANDLER        CATCH zcx_ia_2lofpm_agent.
        ##NO_HANDLER      CATCH cx_static_check.
          CONTINUE.
      ENDTRY.
      APPEND LINES OF lt_comp_tmp TO lt_comp.
    ENDWHILE.

    "Check material Fzg assignment
    LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
      CHECK <ls_comp>-reserv_no  IS NOT INITIAL.
      CHECK <ls_comp>-res_item   IS NOT INITIAL.
      CHECK <ls_comp>-delete_ind IS INITIAL.
      CHECK <ls_comp>-withdrawn  IS INITIAL.                 ">001< +
      CHECK <ls_comp>-requirement_quantity IS NOT INITIAL.   ">001< +

      CHECK NOT line_exists( lt_mat_fzg[ rsnum = <ls_comp>-reserv_no rspos = <ls_comp>-res_item ] ).

      lo_arbstl_i ?= io_schicht->get_arbeitsstellen( )->get_values_iterator( ).
      WHILE lo_arbstl_i->has_next( ).
        lo_arbstl ?= lo_arbstl_i->get_next( ).
        lo_auftrag = lo_arbstl->get_auftrag( EXPORTING iv_key = <ls_comp>-orderid ).
        CHECK lo_auftrag IS BOUND.
        lv_as_name = lo_arbstl->get_kurztext( ).
        MESSAGE e558(zia_2_real) WITH lv_as_name INTO DATA(lv_msg).
        APPEND VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message_v1 = lv_as_name message = lv_msg ) TO lt_return.
*        EXIT.
      ENDWHILE.
    ENDLOOP.

    SORT lt_return.
    DELETE ADJACENT DUPLICATES FROM lt_return.

    IF lt_return IS NOT INITIAL.
      MESSAGE e557(zia_2_real) INTO lv_msg.
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_msg ) INTO lt_return INDEX 1.
*      MESSAGE e051(zia_2_real) INTO lv_msg.
*      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_msg ) INTO lt_return INDEX 1.
      MESSAGE e550(zia_2_real) INTO lv_msg.
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_msg ) INTO lt_return INDEX 1.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->CHECK_MRCPNTLOCPLNT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SHIFT                       TYPE REF TO ZCL_IA_2WORKSHIFT
* | [--->] IT_MAP_MATFZG                  TYPE        ZIA_2MAP_MATFZG_T(optional)
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_mrcpntlocplnt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob alle Materialien dem Fahrzeug zugeordnet wurden
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
* >000<   7.52       14.09.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
* >001<   7.52       05.10.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-791
*----------------------------------------------------------------------*

    TYPES: BEGIN OF ts_order_rcpntloc_plant,
             aufnr                   TYPE zia_2order-aufnr,
             werks                   TYPE eam_rcpntlocplnt-werks,
             recipient_location_code TYPE eam_rcpntlocplnt-recipient_location_code,
           END OF ts_order_rcpntloc_plant.

    DATA: lt_order_rcpntloc_plant TYPE TABLE OF ts_order_rcpntloc_plant,
          ls_order_rcpntloc_plant TYPE ts_order_rcpntloc_plant,
          lo_auftraege            TYPE REF TO cl_object_map,
          lo_auftraege_i          TYPE REF TO cl_object_collection_iterator,
          lo_auftrag              TYPE REF TO zcl_ia_2order,
          ls_order                TYPE zia_2order,
          lt_order                TYPE STANDARD TABLE OF zia_2order.

    DATA(lt_mat_fzg) = VALUE zia_2map_matfzg_t( ).
    DATA(lt_return)  = VALUE bapiret2_t( ).

    lt_mat_fzg = COND #( WHEN it_map_matfzg IS NOT INITIAL THEN it_map_matfzg ELSE get_map_matfzg( io_schicht = io_shift ) ).

    lo_auftraege = io_shift->get_auftraege( ).
    lo_auftraege_i ?= lo_auftraege->get_values_iterator( ).
    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).
      CHECK lo_auftrag->get_vorschau_flag( ) = abap_false.
      CLEAR ls_order.
      ls_order = lo_auftrag->get_data( ).
      APPEND ls_order TO lt_order.
    ENDWHILE.

    LOOP AT lt_mat_fzg INTO DATA(ls_mat_fzg).
      CLEAR ls_order_rcpntloc_plant.
      ls_order_rcpntloc_plant-aufnr = ls_mat_fzg-aufnr.
      READ TABLE lt_order INTO ls_order WITH KEY aufnr = ls_mat_fzg-aufnr.
      IF sy-subrc IS INITIAL.
        ls_order_rcpntloc_plant-werks = get_plant_by_zid_eiz( ls_order-zid_eiz ).
        ls_order_rcpntloc_plant-recipient_location_code = ls_mat_fzg-ablad.
        APPEND ls_order_rcpntloc_plant TO lt_order_rcpntloc_plant.
      ENDIF.
    ENDLOOP.

    SORT lt_order_rcpntloc_plant.
    DELETE ADJACENT DUPLICATES FROM lt_order_rcpntloc_plant.

    IF lt_order_rcpntloc_plant IS NOT INITIAL.
      SELECT * FROM eam_rcpntlocplnt
        INTO TABLE @DATA(lt_active_rcpntloc_plant)
        FOR ALL ENTRIES IN @lt_order_rcpntloc_plant
        WHERE recipient_location_code = @lt_order_rcpntloc_plant-recipient_location_code AND
          werks = @lt_order_rcpntloc_plant-werks AND
          recipient_location_status = '1'. "active
      IF sy-subrc IS INITIAL.
        SORT lt_active_rcpntloc_plant BY recipient_location_code werks.
      ENDIF.
    ENDIF.

    LOOP AT lt_order_rcpntloc_plant INTO ls_order_rcpntloc_plant.
      IF NOT line_exists( lt_active_rcpntloc_plant[ recipient_location_code = ls_order_rcpntloc_plant-recipient_location_code werks = ls_order_rcpntloc_plant-werks ] ).
        MESSAGE e561(zia_2_real) INTO DATA(lv_message) WITH ls_order_rcpntloc_plant-recipient_location_code
        ls_order_rcpntloc_plant-werks ls_order_rcpntloc_plant-aufnr.
        INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 ) INTO lt_return INDEX 1.
      ENDIF.
    ENDLOOP.

*    CL_LISTING_CHECK=>CHECK_MARC_EXISTS

    IF lt_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->CHECK_SERVICEPRODUKT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SHIFT                       TYPE REF TO ZCL_IA_2WORKSHIFT
* | [<-->] CO_MSG                         TYPE REF TO ZCL_IA_2MESSAGE_MANAGER
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_serviceprodukt.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob alle Materialien dem Fahrzeug zugeordnet wurden
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
* >000<   7.52       14.09.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
* >001<   7.52       05.10.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-791
*----------------------------------------------------------------------*

    DATA: lo_auftraege   TYPE REF TO cl_object_map,
          lo_auftraege_i TYPE REF TO cl_object_collection_iterator,
          lo_auftrag     TYPE REF TO zcl_ia_2order,
          ls_order       TYPE zia_2order,
          lt_order       TYPE STANDARD TABLE OF zia_2order,
          lt_spverteil   TYPE STANDARD TABLE OF zia_2moestcost.

    DATA(lt_return)  = VALUE bapiret2_t( ).
    lo_auftraege = io_shift->get_auftraege( ).
    lo_auftraege_i ?= lo_auftraege->get_values_iterator( ).

    WHILE lo_auftraege_i->has_next( ) = abap_true.
      lo_auftrag ?= lo_auftraege_i->get_next( ).
      CHECK lo_auftrag->get_vorschau_flag( ) = abap_false.
      CLEAR ls_order.
      ls_order = lo_auftrag->get_data( ).
      APPEND ls_order TO lt_order.
    ENDWHILE.

    IF lt_order IS NOT INITIAL.
      SELECT aufnr, plnnr, gstrp
           FROM viaufkst
           INTO TABLE @DATA(lt_aufnr_plnnr)
           FOR ALL ENTRIES IN @lt_order
           WHERE aufnr = @lt_order-aufnr.
      IF sy-subrc IS INITIAL.
        SORT lt_aufnr_plnnr BY plnnr.
      ENDIF.
    ENDIF.

    IF lt_aufnr_plnnr IS NOT INITIAL.
      SELECT  plnnr
        FROM zia_2moestcost
        INTO CORRESPONDING FIELDS OF TABLE @lt_spverteil  ##TOO_MANY_ITAB_FIELDS
         FOR ALL ENTRIES IN @lt_aufnr_plnnr
       WHERE plnnr  = @lt_aufnr_plnnr-plnnr AND
             datuv <= @lt_aufnr_plnnr-gstrp AND
             datub >= @lt_aufnr_plnnr-gstrp.
      IF sy-subrc IS INITIAL.
        SORT lt_spverteil BY plnnr.
      ENDIF.
    ENDIF.

    LOOP AT lt_aufnr_plnnr ASSIGNING FIELD-SYMBOL(<ls_aufnr_plnnr>).
      IF NOT line_exists( lt_spverteil[ plnnr = <ls_aufnr_plnnr>-plnnr ] ).
        MESSAGE e560(zia_2_real) INTO DATA(lv_message) WITH <ls_aufnr_plnnr>-plnnr <ls_aufnr_plnnr>-aufnr.
        INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message message_v1 = sy-msgv1 message_v2 = sy-msgv2 ) INTO lt_return INDEX 1.
      ENDIF.
    ENDLOOP.

    IF lt_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2JOBPOOL_MMT=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IA_2JOBPOOL_MMT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_INSTANCE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    IF ro_instance IS NOT BOUND.
      ro_instance = NEW zcl_ia_2jobpool_mmt( ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2JOBPOOL_MMT->GET_MAP_MATFZG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* | [<-()] RT_DATA                        TYPE        ZIA_2MAP_MATFZG_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_map_matfzg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Get Fahrzeugmaterialien
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
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
    DATA lo_auftrag_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftrag   TYPE REF TO zcl_ia_2order.
    DATA(lt_aufnr)    = VALUE aufnr_t( ).


    lo_auftrag_i ?= io_schicht->get_auftraege( )->get_values_iterator( ).
    WHILE lo_auftrag_i->has_next( ).
      lo_auftrag ?= lo_auftrag_i->get_next( ).
      DATA(lv_aufnr) = lo_auftrag->get_data( )-aufnr.
      CHECK io_schicht->get_id( ) = lo_auftrag->get_data( )-zschicht.
      APPEND lv_aufnr TO lt_aufnr.
    ENDWHILE.

    IF lt_aufnr IS NOT INITIAL.
      SELECT *
        FROM zia_2map_matfzg
        INTO CORRESPONDING FIELDS OF TABLE @rt_data
        FOR ALL ENTRIES IN @lt_aufnr
        WHERE aufnr = @lt_aufnr-aufnr.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF .
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2JOBPOOL_MMT->GET_PLANT_BY_ZID_EIZ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ZID_EIZ                     TYPE        ZIA_2ORDER-ZID_EIZ
* | [<-()] RV_PLANT                       TYPE        MARC-WERKS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_plant_by_zid_eiz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_INSTANCE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    rv_plant = SWITCH #( iv_zid_eiz
                 WHEN zif_ia_2_constant=>mc_eizid_gbtn THEN '8325'  ##NO_TEXT
                 WHEN zif_ia_2_constant=>mc_eizid_gbts THEN '8324'   ##NO_TEXT
                 ELSE '' ).
    RETURN rv_plant.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2JOBPOOL_MMT->MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SCHICHT                     TYPE REF TO ZCL_IA_2WORKSHIFT
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD main ##NEEDED.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_INSTANCE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  ENDMETHOD.
ENDCLASS.