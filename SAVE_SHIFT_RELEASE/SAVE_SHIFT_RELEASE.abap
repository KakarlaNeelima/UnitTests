METHOD save_shift_release .

  CLEAR rt_return.
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  DATA : lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
         lo_schicht     TYPE REF TO zcl_ia_2workshift,
 ##NEEDED        lo_shift       TYPE REF TO zcl_ia_2wrkplace.

  TYPES : BEGIN OF ts_bucket_response_early,
            mapped   TYPE RESPONSE FOR MAPPED   EARLY r_maintplanningbuckettp_2,
            failed   TYPE RESPONSE FOR FAILED   EARLY r_maintplanningbuckettp_2,
            reported TYPE RESPONSE FOR REPORTED EARLY r_maintplanningbuckettp_2,
          END OF ts_bucket_response_early,

          BEGIN OF ts_workarea_tot,
            zschicht        TYPE zia_2_workshift,
            fahrzeug_kosten TYPE zia_2_vh_cost,
          END OF ts_workarea_tot,

          BEGIN OF ts_wa_ord_tot,
            zschicht      TYPE char12, "ZIA_2_WORKSHIFT,
            wa_id         TYPE char12, "ZIA_2_ID_AS,
            wa_ord        TYPE aufnr,
            wa_count      TYPE i,
            wa_percentage TYPE zia_2_percent, "ZIA_2_AUSLASTUNG,
          END OF ts_wa_ord_tot,

          BEGIN OF ts_wa_details,
            wa_id TYPE char12,
            text  TYPE string,
          END OF ts_wa_details,


          BEGIN OF ts_admin_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            order    TYPE aufnr,
            n004_ord TYPE aufnr,
          END OF ts_admin_tot,

          BEGIN OF ts_n004_wbs,
            order   TYPE aufnr,
            zarbstl TYPE zia_2_id_wrkplace,
            wbs     TYPE ps_posid,
          END OF ts_n004_wbs,

          BEGIN OF ts_order_comp,
            aufnr       TYPE aufnr,
            start_datum TYPE zia_2_pm_ordgstrp,
            start_zeit  TYPE zia_2_co_gsuzp,
            reserv_no   TYPE rsnum,
            res_item    TYPE rspos,
            fzg_belad   TYPE char6,
          END OF ts_order_comp,

          BEGIN OF ts_wa_qual_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            wa_count TYPE i,
          END OF ts_wa_qual_tot,


          BEGIN OF ts_pb_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            wa_count TYPE i,
          END OF ts_pb_tot,

          BEGIN OF ts_total_count,
            admin_order TYPE aufnr,
            percentage  TYPE zia_2_percent,
          END OF ts_total_count,


          BEGIN OF ts_total_qual,
            admin_order TYPE aufnr,
            qual        TYPE i,
          END OF ts_total_qual,

          BEGIN OF ts_ord_qual_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            n004_ord TYPE aufnr,
            qual     TYPE i,
          END OF ts_ord_qual_tot,

          BEGIN OF ts_zia_2sf_veh_seat,
            zid_fzg_platz TYPE zia_2_id_vehicle_slot,
            uname         TYPE uname,
          END OF ts_zia_2sf_veh_seat ,

          BEGIN OF ts_qual_original,
            order TYPE aufnr,
            qual  TYPE zia_2sf_veh_seat,
          END OF ts_qual_original,

          BEGIN OF ts_qual_tff,
            wa_id TYPE char12,
            qual  TYPE zia_2sf_veh_seat,
          END OF ts_qual_tff,

          BEGIN OF ts_order_revi,
            pb   TYPE eam_plngbktlabel,
            revi TYPE revni,
          END OF ts_order_revi,

          ts_action_create_bucket TYPE STRUCTURE FOR ACTION IMPORT zir_cds_c_1planningbucket\\zzplngbktadditionalactions~createbucket.






  DATA: lt_create_bucket               TYPE TABLE FOR CREATE r_maintplanningbuckettp_2,
        lt_create_scope                TYPE TABLE FOR CREATE r_maintplanningbuckettp_2\\maintplngbucketscopenametp\_maintplanningbucketscopetp,
 ##NEEDED       ls_bucket_commit_failed        TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
 ##NEEDED       ls_bucket_commit_reported      TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
 ##NEEDED       ls_admin_order_commit_failed   TYPE RESPONSE FOR FAILED LATE r_maintenanceordertp,
 ##NEEDED       ls_admin_order_commit_reported TYPE RESPONSE FOR REPORTED LATE r_maintenanceordertp,
        ls_action_information TYPE ts_action_create_bucket,
 ##NEEDED       ls_result_parameter TYPE zir_cds_d_1pbactcreatepres,
  ##NEEDED       ls_commit_failed           TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
  ##NEEDED       ls_commit_reported         TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
  ls_bucket_response         TYPE ts_bucket_response_early,
  ls_bucket_response1        TYPE ts_bucket_response_early,
  lv_planbucktdesc           TYPE eam_plngbktdesc,
  lv_planbucktdesc_n4           TYPE eam_plngbktdesc,
 ##NEEDED lv_date                    TYPE char10,
  lv_shorttext               TYPE auftext,
  lv_startdatetime           TYPE char15, "EAM_PLNGBKTSTARTDATETIME,
  lv_enddatetime             TYPE char15, "EAM_PLNGBKTENDDATETIME,
  lv_maintplanningbucketuuid TYPE sysuuid_x,
  lv_shift_aufnr             TYPE aufnr,
  lv_tot_qual                TYPE i,
  ##NEEDED       lv_qual_per                TYPE zia_2_percent,
  lt_methods                 TYPE bapi_alm_order_method_t,
  lt_header                  TYPE bapi_alm_order_headers_i_t,
  lt_operation               TYPE TABLE OF bapi_alm_order_operation,
  lt_operation_up TYPE bapi_alm_order_operation_ut,
  ##NEEDED       ls_header_up               TYPE bapi_alm_order_headers_up,
  lt_header_up               TYPE TABLE OF bapi_alm_order_headers_up,
  lt_return                  TYPE bapiret2_t,
  lv_objectkey               TYPE bapi_alm_order_method-objectkey,
  lv_objectkeyo               TYPE bapi_alm_order_method-objectkey,
  lv_tot_admin_order         TYPE i,
  lv_activity TYPE vornr,
  lv_refnum TYPE i,
  lv_n003_qual TYPE i,
  lv_tot_wa TYPE i,
  lv_steus TYPE zia_2mo_fld_value,
  lv_use04 TYPE zia_2mo_fld_value,
  lv_usr04 TYPE zia_2mo_fld_value,
 ##NEEDED ls_return1 TYPE bapiret2,
 ##NEEDED lv_maintenanceevent  TYPE revni,
 ##NEEDED lv_maintenanceplanningplant  TYPE iwerk,
 ##NEEDED lv_maintplngbucketlabel  TYPE eam_plngbktlabel,
 ##NEEDED lv_startdatetime2  TYPE eam_plngbktstartdatetime,
 ##NEEDED lv_enddatetime2  TYPE eam_plngbktenddatetime,
 ##NEEDED lv_maintenanceplanningbucket  TYPE eam_plngbckt_objnr,
          lv_len TYPE i,
          lv_uname TYPE co_pernr,
 ##NEEDED lt_arbstl_obj  TYPE STANDARD TABLE OF REF TO zcl_ia_2wrkplace,
 ##NEEDED lt_components_all TYPE bapi_alm_order_component_et.




*GET PLANNED ORDER DETAILS
  ##NEEDED DATA: lo_auftraege_i      TYPE REF TO cl_object_collection_iterator,
         ls_order            TYPE zia_2order,
         lo_einzelkapa       TYPE REF TO zcl_ia_2indiv_capcity,
         lo_einzelkapas_i    TYPE REF TO cl_object_collection_iterator,
         lt_zia_2sf_veh_seat TYPE STANDARD TABLE OF ts_zia_2sf_veh_seat,
         lt_zia_2sf_veh_seat_all TYPE STANDARD TABLE OF ts_zia_2sf_veh_seat,
         lt_order            TYPE STANDARD TABLE OF zia_2order,
         lt_order_original   TYPE STANDARD TABLE OF zia_2order,
         ls_order_original   TYPE zia_2order,
         lt_order_n004       TYPE STANDARD TABLE OF zia_2order,
         ls_qual             TYPE zia_2sf_veh_seat,
  ##NEEDED       lt_qual             TYPE STANDARD TABLE OF zia_2sf_veh_seat,
         lt_qual_base        TYPE STANDARD TABLE OF zia_2sf_veh_seat,
          lt_qual_original   TYPE STANDARD TABLE OF ts_qual_original,
          ls_qual_original   TYPE ts_qual_original,
          ls_qual_tff   TYPE ts_qual_tff,
          lt_qual_tff   TYPE STANDARD TABLE OF ts_qual_tff,
  ##NEEDED       lt_qual_new         TYPE STANDARD TABLE OF zia_2sf_veh_seat,
  ##NEEDED       lt_qual_n004        TYPE STANDARD TABLE OF zia_2sf_veh_seat,
         lt_zia_2order_cap_total TYPE STANDARD TABLE OF zia_2order_cap,
         ls_zia_2order_cap_total TYPE zia_2order_cap,
         ls_zia_2sf_orderstr TYPE zia_2sf_orderstr,
         lt_zia_2sf_orderstr TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstrn TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstrl TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstc TYPE STANDARD TABLE OF zia_2sf_orderstr,
         ls_zia_2sf_veh_cost TYPE zia_2sf_veh_cost,
         lt_zia_2sf_veh_cost TYPE STANDARD TABLE OF zia_2sf_veh_cost,
         lt_zia_2sf_veh_costn TYPE STANDARD TABLE OF zia_2sf_veh_cost,
         lt_wa_details TYPE STANDARD TABLE OF ts_wa_details,
         ls_wa_details TYPE ts_wa_details,
         ls_workarea_tot     TYPE ts_workarea_tot,
         lt_workarea_tot     TYPE STANDARD TABLE OF ts_workarea_tot,
         ls_pb_tot TYPE ts_pb_tot,
         lt_pb_tot TYPE STANDARD TABLE OF ts_pb_tot,
         ls_wa_ord_tot       TYPE ts_wa_ord_tot,
         lt_wa_ord_tot       TYPE STANDARD TABLE OF ts_wa_ord_tot,
         ls_admin_tot TYPE ts_admin_tot,
         lt_admin_tot TYPE STANDARD TABLE OF ts_admin_tot,
         ls_wa_qual_tot TYPE ts_wa_qual_tot,
         lt_wa_qual_tot TYPE STANDARD TABLE OF ts_wa_qual_tot,
         lt_wa_ord_tot_n4       TYPE STANDARD TABLE OF ts_wa_ord_tot,
         ls_wa_ord_tot_n41       TYPE ts_wa_ord_tot,
         ls_wa_ord_tot_n42       TYPE ts_wa_ord_tot,
         ls_ord_qual_tot TYPE ts_ord_qual_tot,
         lt_ord_qual_tot TYPE STANDARD TABLE OF ts_ord_qual_tot,
         ls_ord_qual_o TYPE ts_ord_qual_tot,
         lt_ord_qual_o TYPE STANDARD TABLE OF ts_ord_qual_tot,
         lt_ord_qual TYPE STANDARD TABLE OF ts_ord_qual_tot,
 ##NEEDED        ls_total_labor      TYPE ts_total_count,
 ##NEEDED        lt_total_labor      TYPE STANDARD TABLE OF ts_total_count,
 ##NEEDED        ls_total_veh        TYPE ts_total_count,
 ##NEEDED        lt_total_veh        TYPE STANDARD TABLE OF ts_total_count,
 ##NEEDED        lt_total_vehc       TYPE STANDARD TABLE OF ts_total_count,
         ls_data TYPE bapi_alm_order_srule,
         lt_data TYPE STANDARD TABLE OF bapi_alm_order_srule,
         ls_total_qual TYPE ts_total_qual,
         lt_total_qual TYPE STANDARD TABLE OF ts_total_qual,

        ls_srule_up TYPE bapi_alm_order_srule_up,
        lt_srule_up TYPE STANDARD  TABLE OF bapi_alm_order_srule_up,
        ls_n004_wbs TYPE ts_n004_wbs,
        ls_n004_wbs_o TYPE ts_n004_wbs,
        lt_n004_wbs_o TYPE STANDARD TABLE OF ts_n004_wbs,
        lt_n004_wbs TYPE STANDARD TABLE OF ts_n004_wbs,
        lv_er_ir TYPE char2,
        lv_last TYPE char1,
        lv_revision TYPE revni,
        lt_order_revi TYPE STANDARD TABLE OF ts_order_revi,
        ls_order_revi TYPE ts_order_revi,
        lv_zdlz TYPE zia_2_proc_time,
        lt_order_comp TYPE STANDARD TABLE OF ts_order_comp,
        ls_order_comp TYPE ts_order_comp,
        lt_zia_2plperim TYPE STANDARD TABLE OF zia_2plperim,
        ls_zia_2plperim TYPE zia_2plperim,
        lv_txt1 TYPE char20,
        lv_txt2 TYPE char20.

  DATA(lt_data_mat)       = VALUE wd_this->elements_mat_table_data( ).
  DATA ls_data_mat LIKE LINE OF lt_data_mat.
  DATA :              lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator.

  CONSTANTS : lc_planning    TYPE arbpl VALUE 'MIXCEN',
              lc_work_center TYPE eam_plngbckt_scopename VALUE 'ARBPL'.


  wd_assist->populate_veh_typ_and_cost_blck( IMPORTING et_zia_2veh_typ_rat = DATA(lt_zia_2veh_typ_rat)
                                                       et_zia_2cost_blck = DATA(lt_zia_2cost_blck)
                                                       et_zia_2veh_typ_sp = DATA(lt_zia_2veh_typ_sp)
                                                       ev_steus = lv_steus
                                                       ev_use04 = lv_use04
                                                       ev_usr04 = lv_usr04 ).


*GET WORKAREA DETAILS.
  lo_schicht = ls_schichtdetails-object.

  lo_arbstelle_i ?=  lo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    DATA(lo_arbstelle)  = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).
    DATA(lv_workarea_id) = lo_arbstelle->get_id( ).
    DATA(lv_workarea_text) = lo_arbstelle->get_kurztext( ).

*    Getting materials assigned to vehicles per workarea.
*    APPEND lo_arbstelle to lt_arbstl_obj  .
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_arb( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).
    "Append Level #2: Auftrag
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_auf( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).
    "Append Level #3: Material
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_mat( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).

* Keeping only relevant data.
    LOOP AT lt_data_mat INTO ls_data_mat WHERE level NE 'LEVEL_3'.
      DELETE TABLE lt_data_mat FROM ls_data_mat.
      CLEAR ls_data_mat.
    ENDLOOP.

*    DATA(LS_WORKAREA_ORDERS) = LO_ARBSTELLE->GET_AUFTRAEGE( ).
    DATA(lo_wa_orders) = lo_arbstelle->get_auftraege( ).
    DATA(lo_wa_order_coll) = CAST cl_object_collection_iterator( lo_wa_orders->get_values_iterator( ) ).

    CLEAR lt_order."IF ONLY WORK AREA ORDERS ARE NEEDED
    WHILE lo_wa_order_coll->has_next( ) = abap_true.
      DATA(lo_wa_order) = CAST zcl_ia_2order( lo_wa_order_coll->get_next( ) ).
      APPEND lo_wa_order->get_data( ) TO lt_order.

    ENDWHILE.

* collecting work area id and description.
    ls_wa_details-wa_id = lv_workarea_id.
    ls_wa_details-text = lv_workarea_text.
    APPEND ls_wa_details TO lt_wa_details.
    CLEAR ls_wa_details.

*    get individual capacities per order per workarea.
    IF lt_order IS NOT INITIAL.

      wd_assist->populate_zia_2order_cap( EXPORTING it_orders = lt_order
                                          IMPORTING et_zia_2order_cap = DATA(lt_zia_2order_cap)
                                                    et_zia_2sf_veh_seat = lt_zia_2sf_veh_seat ).

      APPEND LINES OF lt_zia_2order_cap TO lt_zia_2order_cap_total.
      APPEND LINES OF lt_zia_2sf_veh_seat TO lt_zia_2sf_veh_seat_all.
    ENDIF.

    LOOP AT lt_order INTO ls_order.
      APPEND ls_order TO lt_order_original.
      CLEAR ls_order.


    ENDLOOP.

*    move N004 orders to new table.
    LOOP AT lt_order INTO ls_order WHERE auart = 'N004'.
*      IF ls_order-auart = 'N004'.
      APPEND ls_order TO lt_order_n004.
      DELETE TABLE lt_order FROM ls_order." aufnr = ls_order-aufnr.
*      LOOP AT lt_zia_2order_cap INTO ls_zia_2order_cap WHERE aufnr = ls_order-aufnr.
*        ls_qualn = ls_zia_2order_cap .
*        ls_qualn-OBJID = ls_zia_2order_cap .
*
*      ENDLOOP.
*      ENDIF.
      CLEAR ls_order.
    ENDLOOP.



    " QUALIFICATION PER WORKPLACE (BOOLEAN)
    DATA(lo_fahrzeuge) = lo_arbstelle->get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).

    CLEAR : lt_qual, lv_tot_qual, lt_wa_ord_tot."ONLY IF THE QALIFICATIONS PER WORK AREA
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
      DATA(li_sitzplaetze_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
      WHILE li_sitzplaetze_i->has_next( ) = abap_true.
        CLEAR ls_qual.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplaetze_i->get_next( ) ).
        DATA(lv_auslastung) = lo_sitzplatz->get_auslastung( ).
        ##NEEDED       DATA(lv_dlz_max) = lo_sitzplatz->get_dlz_max( ).
        ##NEEDED       DATA(lv_dlz) = lo_sitzplatz->get_dlz( ).
        IF lo_sitzplatz->has_quali( ) = abap_true.
*          APPEND LO_SITZPLATZ->GET_DATA( ) TO LT_QUAL.
          ls_qual = lo_sitzplatz->get_data( ).
          " temporary populating this field with workcenter text.
          ls_qual-personalmodul = lo_sitzplatz->get_quali_ktext( ).
*          APPEND ls_qual TO lt_qual.

          APPEND ls_qual TO lt_qual_base. "the base quality table with unique ID.

          IF ls_qual-personalmodul CS 'TFF'.
            ls_qual_tff-wa_id = lv_workarea_id.
            ls_qual_tff-qual = ls_qual.
            APPEND ls_qual_tff TO lt_qual_tff.
            CLEAR ls_qual_tff.
          ENDIF.

        ENDIF.
*        lo_einzelkapas_i ?= lo_sitzplatz->get_einzelkapas_o( )->get_values_iterator( ).
*        WHILE lo_einzelkapas_i->has_next( ) = abap_true.
*          lo_einzelkapa ?= lo_einzelkapas_i->get_next( ).
*          DATA(lv_qual_order) = lo_einzelkapa->get_auftrag( )->get_id( ).
*        ENDWHILE.
*        Replacing read statement with Loop " T04K948750
*        READ TABLE lt_zia_2order_cap INTO DATA(ls_zia_2order_cap)
*                                     WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
        LOOP AT  lt_zia_2order_cap INTO DATA(ls_zia_2order_cap)
                             WHERE zid_fzg_platz = ls_qual-zid_fzg_platz.
*          creating a new table with total qualitites.
*          APPEND ls_qual TO lt_qual_original.
          ls_qual_original-order = ls_zia_2order_cap-aufnr.
          ls_qual_original-qual = ls_qual.
          APPEND ls_qual_original TO lt_qual_original.

*         collecting quality per workarea per order
          ls_ord_qual_o-wa_id = lv_workarea_id.
          ls_ord_qual_o-n004_ord = ls_zia_2order_cap-aufnr.
          ls_ord_qual_o-qual = 1.
          COLLECT ls_ord_qual_o INTO lt_ord_qual_o.        "#EC COLLECT
          CLEAR ls_ord_qual_o.

*          segregating the duration .
          ls_qual-zdlz = ls_zia_2order_cap-zdauer.

*          IF sy-subrc = 0.
          DATA(lv_qual_order) = ls_zia_2order_cap-aufnr.
*          ENDIF.

          READ TABLE lt_order INTO ls_order WITH KEY aufnr = lv_qual_order.
          IF sy-subrc = 0 AND ls_order-auart NE 'N004' AND ls_qual IS NOT INITIAL.
            IF ls_order-zzzugangsart NE '2'.
              APPEND ls_qual TO lt_qual.
              lv_n003_qual = lv_n003_qual + 1.

*          collecting quality per workarea or per N004 order
              ls_ord_qual_tot-wa_id = lv_workarea_id.
*            ls_ord_qual_tot-n004_ord
              ls_ord_qual_tot-qual = 1.
              COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot. "#EC COLLECT
              CLEAR ls_ord_qual_tot.
            ENDIF.
            IF ls_order-zzzugangsart EQ '2'.
              APPEND ls_qual TO lt_qual_n004.
              ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
              ls_wa_ord_tot-wa_id = lv_workarea_id.
              ls_wa_ord_tot-wa_ord = lv_qual_order.
              ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

              COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot_n4. "#EC COLLECT
              CLEAR ls_wa_ord_tot.


*          collecting quality per workarea or per N004 order
              ls_ord_qual_tot-wa_id = lv_workarea_id.
              ls_ord_qual_tot-n004_ord = lv_qual_order.
              ls_ord_qual_tot-qual = 1.

              COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot. "#EC COLLECT
              CLEAR ls_ord_qual_tot.

            ENDIF.
          ENDIF.

          READ TABLE lt_order_n004 INTO ls_order WITH KEY aufnr = lv_qual_order.
          IF sy-subrc = 0 AND ls_qual IS NOT INITIAL.
            APPEND ls_qual TO lt_qual_n004.
            ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
            ls_wa_ord_tot-wa_id = lv_workarea_id.
            ls_wa_ord_tot-wa_ord = lv_qual_order.
            ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

            COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot_n4.   "#EC COLLECT
            CLEAR ls_wa_ord_tot.


*          collecting quality per workarea or per N004 order
            ls_ord_qual_tot-wa_id = lv_workarea_id.
            ls_ord_qual_tot-n004_ord = lv_qual_order.
            ls_ord_qual_tot-qual = 1.

            COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot.  "#EC COLLECT
            CLEAR ls_ord_qual_tot.

          ENDIF.

*        POPOULATE PERSON PER ORDER TABLE.
          IF lv_auslastung IS NOT INITIAL.
            ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
            ls_wa_ord_tot-wa_id = lv_workarea_id.
            ls_wa_ord_tot-wa_ord = lv_qual_order.
            ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

            COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot.      "#EC COLLECT
            lv_tot_qual = lv_tot_qual + 1.

*the below count is used to segregte total count per work area.
            ls_wa_qual_tot-wa_id = lv_workarea_id.
            ls_wa_qual_tot-wa_count = 1.
            COLLECT ls_wa_qual_tot INTO lt_wa_qual_tot.    "#EC COLLECT

            CLEAR : ls_wa_qual_tot, ls_wa_ord_tot.
          ENDIF.
          CLEAR lv_qual_order.

        ENDLOOP.
      ENDWHILE.
    ENDWHILE.

*collecting the duration for each same person
    CLEAR : ls_qual, lt_qual_new.
    LOOP AT lt_qual INTO ls_qual.
      COLLECT ls_qual INTO lt_qual_new.                    "#EC COLLECT
      CLEAR ls_qual.
    ENDLOOP.
    lt_qual[] = lt_qual_new[].

*        POPOULATE percentage PER ORDER .
    LOOP AT lt_wa_ord_tot INTO ls_wa_ord_tot.
      ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / lv_tot_qual ) * 100.
*      lv_qual_per = ls_wa_ord_tot-wa_count / lv_tot_qual .
*      ls_wa_ord_tot-wa_percentage = lv_qual_per * 100.
      MODIFY lt_wa_ord_tot FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
      CLEAR ls_wa_ord_tot.

    ENDLOOP.


    LOOP AT lt_wa_ord_tot_n4 INTO ls_wa_ord_tot.
      READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_wa_ord_tot-wa_id.
      IF sy-subrc = 0.
*      ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / lv_tot_qual ) * 100.
        ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / ls_wa_qual_tot-wa_count ) * 100.

        MODIFY lt_wa_ord_tot_n4 FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
        CLEAR ls_wa_ord_tot.
      ENDIF.
*      lv_qual_per = ls_wa_ord_tot-wa_count / lv_tot_qual .
*      ls_wa_ord_tot-wa_percentage = lv_qual_per * 100.
*      MODIFY lt_wa_ord_tot_n4 FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
*      CLEAR ls_wa_ord_tot.

    ENDLOOP.



*deleting orders with similar access type.
    SORT lt_order BY zzzugangsart.
    DELETE ADJACENT DUPLICATES FROM lt_order COMPARING zzzugangsart.

    READ TABLE lt_order INTO ls_order WITH KEY zzzugangsart = '2'.
    IF sy-subrc = 0.
      APPEND ls_order TO lt_order_n004.

      DELETE TABLE lt_order FROM ls_order.
      CLEAR ls_order.
    ENDIF.

    IF lv_workarea_text IS INITIAL.
      lv_workarea_text = 'XXX'.
    ENDIF.

*    CONCATENATE 'REAL_'
*                ls_schichtdetails-zzperi
*                '_'
*                ls_schichtdetails-zschicht
*                '_'
*                lv_workarea_text(3)
*           INTO lv_planbucktdesc.

    CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
                ls_schichtdetails-start_datum+4(2) '.'
                ls_schichtdetails-start_datum(4) '_'
                ls_schichtdetails-zzperi '_'
                lv_workarea_text '_'
                'ER_'
                ls_order-zzzugangsart
                INTO lv_planbucktdesc.

    CONCATENATE ls_schichtdetails-start_datum
                ls_schichtdetails-start_zeit
           INTO lv_startdatetime.

    CONCATENATE ls_schichtdetails-end_datum
                ls_schichtdetails-end_zeit
           INTO lv_enddatetime.


*    SELECT SINGLE AUFNR
*      FROM QMEL
*      INTO LV_SHIFT_AUFNR
*      WHERE QMNUM =  LS_SCHICHTDETAILS-ZSCHICHT.
*
*    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
*      INTO @DATA(LS_AUFK)
*      FROM AUFK
*     WHERE AUFNR = @LV_SHIFT_AUFNR.

    wd_assist->populate_shift_order_details( EXPORTING iv_schicht     = ls_schichtdetails-zschicht
                                             IMPORTING ev_shift_aufnr = lv_shift_aufnr
                                                       es_aufk        = DATA(ls_aufk) ).


*    ##WARN_OK   SELECT SINGLE workcenterinternalid
*         FROM i_workcenter
*           INTO @DATA(lv_workcenterinternalid)
*             WHERE workcenter EQ @zif_ir_1pb_c=>mc_main_work_center-planning
*             AND   plant      EQ @ls_action_information-%param-planningplant.

    wd_assist->populate_workcenterinternalid( EXPORTING iv_workcenter = 'MIXCEN'"zif_ir_1pb_c=>mc_main_work_center-planning
                                                        iv_plant = ls_action_information-%param-planningplant
                                              IMPORTING ev_workcenterinternalid = DATA(lv_workcenterinternalid) ).


    IF lt_order IS NOT INITIAL. "checking if any non N004 orders exists
*      IF sy-uname = 'E564128'.
*
*        wd_assist->create_plng_bukt_maint_ord( EXPORTING is_aufk = ls_aufk
*                                                              iv_workcenterinternalid = lv_workcenterinternalid
*                                                              iv_planbucktdesc = lv_planbucktdesc
*                                                              iv_startdatetime = lv_startdatetime
*                                                              iv_enddatetime = lv_enddatetime
*                                                              it_qual = lt_qual
*                                                              iv_steus = lv_steus
*                                                   IMPORTING ev_bucket_cid = DATA(lv_bucket_cid1)
*                                                             ev_tot_admin_order = lv_tot_admin_order
*                                                             es_return = ls_return1
*                                                             es_result_maintenanceevent = lv_maintenanceevent
*                                                             es_result_maintenanceplanningp = lv_maintenanceplanningplant
*                                                             es_result_maintplngbucketlabel = lv_maintplngbucketlabel
*                                                             es_result_maintplanningbuckets = lv_startdatetime2
*                                                             es_result_maintplanningbuckete = lv_enddatetime2
*                                                             es_result_maintenanceplanningb = lv_maintenanceplanningbucket ).
*
*      ENDIF.

*    DATA(LS_ACTION_INFORMATION) = ME->GET_ACTION_INFORMATION( ).
      DATA(lv_bucket_cid)         = xco_cp=>uuid( )->value. "commented on 20.04 by E564128

      " WITH THE INSTALLATION OF NOTE 3671143 IS IT REQUIRED TO CREATE THE PLANNING BUCKET IN A DRAFT MODE TO ENSURE THE DEFAULT SCOPE ARE CREATED. THUS WE MUST CREATE THE PLANNING BUCKET IN DRAFT MODE.
      lt_create_bucket = VALUE #( ( %cid                                    = lv_bucket_cid
                                    %is_draft                               = if_abap_behv=>mk-on
                                    maintplanningbucketdescription          = lv_planbucktdesc "'TEST DESC'"LS_ACTION_INFORMATION-%PARAM-BUCKETDESCRIPTION
                                    nrofmaintplngbucketsinadvance           = 1
                                    maintplngbucketgenerationdate           = sy-datum
                                    maintplanningbuckettype                 = 'STO'"zif_ir_1pb_c=>mc_pb_type-event_based_maintenance
                                    maintenanceplanningplant                = ls_aufk-werks "'8331'"LS_ACTION_INFORMATION-%PARAM-PLANNINGPLANT
                                    maintenanceplant                        = ' ' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEPLANT
                                    maintplngbucketstartdatetime            = lv_startdatetime "'20260316110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-STARTDATEANDTIME
                                    maintplngbucketenddatetime              = lv_enddatetime "'20260318110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-ENDDATEANDTIME
                                    maintplngbucketrecurrencetype           = if_eam_mtplngbkt_const=>maintplngbcktrecurrencetype-once
                                    maintplngbcktrcrrcinterval              = 1
                                    maintenanceeventtype                    = 'NA' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE
                                    mainworkcenter                          = lc_planning
                                    adminvordworkcenterinternal             = lv_workcenterinternalid
                                    zir_1pb_veh_type_mpb                    = ' ' "LS_ACTION_INFORMATION-%PARAM-VEHICLETYPE
                                    zir_1pb_rfs_mpb                         = ' ' "LS_ACTION_INFORMATION-%PARAM-REASONFORSTAY
                                    %control-maintplanningbucketdescription = if_abap_behv=>mk-on
                                    %control-nrofmaintplngbucketsinadvance  = if_abap_behv=>mk-on
                                    %control-maintplngbucketgenerationdate  = if_abap_behv=>mk-on
                                    %control-maintplanningbuckettype        = if_abap_behv=>mk-on
                                    %control-maintenanceplanningplant       = if_abap_behv=>mk-on
                                    %control-maintenanceplant               = if_abap_behv=>mk-on
                                    %control-maintplngbucketstartdatetime   = if_abap_behv=>mk-on
                                    %control-maintplngbucketenddatetime     = if_abap_behv=>mk-on
                                    %control-maintplngbucketrecurrencetype  = if_abap_behv=>mk-on
                                    %control-maintplngbcktrcrrcinterval     = if_abap_behv=>mk-on
                                    %control-maintenanceeventtype           = if_abap_behv=>mk-on
                                    %control-mainworkcenter                 = if_abap_behv=>mk-on
                                    %control-adminvordworkcenterinternal    = if_abap_behv=>mk-on
                                    %control-zir_1pb_veh_type_mpb           = if_abap_behv=>mk-on
                                    %control-zir_1pb_rfs_mpb                = if_abap_behv=>mk-on ) ).


      lt_create_scope = VALUE #( ( %cid_ref                       = lv_bucket_cid"ls_action_information-%cid
                                   %is_draft                      = if_abap_behv=>mk-on
                                   maintplngbcktscprangefieldname = lc_work_center
                            %target  = VALUE  #( ( %cid                              = xco_cp=>uuid( )->value
                                                   %is_draft                         = if_abap_behv=>mk-on
                                                   maintplngbucketscopergsg          = 'I'
                                                   maintplngbucketscopergop          = 'EQ'
                                                   maintplngbucketscopergfr          = lc_planning
                                                   mainworkcenter                    = lc_planning
                                                   workcenterinternalid              = lv_workcenterinternalid
                                                   mainworkcenterplant               = ls_action_information-%param-planningplant
                                                   maintenanceplanningplant          = ls_action_information-%param-planningplant
                                                   maintenanceplant                  = ls_action_information-%param-maintenanceplant
                                                   %control-maintplngbucketscopergsg = if_abap_behv=>mk-on
                                                   %control-maintplngbucketscopergop = if_abap_behv=>mk-on
                                                   %control-maintplngbucketscopergfr = if_abap_behv=>mk-on
                                                   %control-mainworkcenter           = if_abap_behv=>mk-on
                                                   %control-workcenterinternalid     = if_abap_behv=>mk-on
                                                   %control-mainworkcenterplant      = if_abap_behv=>mk-on
                                                   %control-maintenanceplanningplant = if_abap_behv=>mk-on
                                                   %control-maintenanceplant         = if_abap_behv=>mk-on ) ) ) ).

*    MODIFY ENTITIES OF r_maintplanningbuckettp_2
*      ENTITY maintplanningbuckettp
*       CREATE FROM lt_create_bucket
*    MAPPED   ls_bucket_response-mapped
*    FAILED   ls_bucket_response-failed
*    REPORTED ls_bucket_response-reported.
      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
         CREATE FROM lt_create_bucket
        ENTITY maintplngbucketscopenametp
         CREATE BY \_maintplanningbucketscopetp
          FROM lt_create_scope
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.


      ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped>) ELSE UNASSIGN.
      IF <ls_mapped> IS ASSIGNED.
        lv_maintplanningbucketuuid = <ls_mapped>-maintplanningbucketuuid.
      ENDIF.

      IF <ls_mapped>                                     IS NOT ASSIGNED
      OR ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
      OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*    OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.


      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE prepare
            FROM VALUE #( ( %key-maintplanningbucketuuid = <ls_mapped>-maintplanningbucketuuid ) )
          MAPPED   ls_bucket_response-mapped
          FAILED   ls_bucket_response-failed
          REPORTED ls_bucket_response-reported.

      ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped1>) ELSE UNASSIGN.


      IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
         OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE activate
              FROM VALUE #( ( %cid                         = lv_bucket_cid
*                          %KEY-MAINTPLANNINGBUCKETUUID = <LS_MAPPED1>-MAINTPLANNINGBUCKETUUID  ) )
                              %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.

      IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
         OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.

*    COMMIT ENTITIES
*      RESPONSE OF R_MAINTPLANNINGBUCKETTP_2
*        FAILED   LS_COMMIT_FAILED
*        REPORTED LS_COMMIT_REPORTED.

      wd_assist->commit_pb( ).

*****************  CREATE MAINTENANCE EVENT.
*    DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~createmaintenanceevent.
      DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~edit.

      ##NEEDED   DATA(lv_is_draft)           = if_abap_behv=>mk-on.



*    DATA(LV_BUCKET_UUID) = ME->GET_BUCKET_UUID( ).

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE edit
           AUTO FILL CID
            WITH VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response1-mapped
        FAILED   ls_bucket_response1-failed
        REPORTED ls_bucket_response1-reported.


      ##PRIMKEY[ENTITY]
      ASSIGN ls_bucket_response1-mapped-maintplanningbuckettp[ %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ] TO FIELD-SYMBOL(<ls_bucket>).
      IF <ls_bucket> IS ASSIGNED.

        lt_create_maintenance_event = VALUE #( ( %cid                   = lv_bucket_cid "uncommented by e564128 on 20.04.26
                                                 %key                        = <ls_bucket>-%key "<LS_MAPPED>-%KEY
                                                 %param = 'N' "uncommented by e564128 on 20.04.26
                                                 ) ). "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE ) ).

        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
*          """"" EXECUTE createmaintenanceevent
            EXECUTE edit
              FROM lt_create_maintenance_event
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.



        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE prepare
              FROM VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
            MAPPED   ls_bucket_response-mapped
            FAILED   ls_bucket_response-failed
            REPORTED ls_bucket_response-reported.


        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE activate
              FROM VALUE #( ( %cid                         = lv_bucket_cid
                              %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.


*      COMMIT ENTITIES.
        wd_assist->commit_entities( ).


*get the total number of planning buckets.
        ls_pb_tot-wa_id = lv_workarea_id.
        ls_pb_tot-wa_count = 1.
        COLLECT ls_pb_tot INTO lt_pb_tot.                  "#EC COLLECT

        READ ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
      ALL FIELDS WITH
*    FIELDS ( MAINTPLANNINGBUCKET ) " SPECIFY FIELDS TO READ
*    VALUE #( ( %KEY-MAINTPLANNINGBUCKETUUID = '123' ) )
        VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      RESULT DATA(lt_result)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

        DATA ls_result LIKE LINE OF lt_result.

        READ TABLE lt_result INTO ls_result WITH KEY maintplanningbucketuuid = lv_maintplanningbucketuuid.

**LS_RESULT-MAINTENANCEPLANNINGBUCKET
*LS_RESULT-MAINTPLANNINGBUCKETENDDATE

*CREATE MAINTENANCE ORDER.

        CLEAR: lt_methods,
               lt_header,
               lt_operation,
               ls_header_up,
               lt_header_up,
               lt_return,
               lv_objectkey.


        lv_objectkey = '%00000000001'.
        FREE lt_methods.

*   METHODS - ANLEGEN
        APPEND VALUE #(
          refnumber  = 1
          objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
          method     = if_eams_bo_const=>gc_bapi_ord_method-create
          objectkey  = lv_objectkey
        ) TO lt_methods.


*   POPULATE THE HEADER TABLE
        CLEAR : lv_date, lv_shorttext.
        CONCATENATE ls_schichtdetails-start_datum+6(2)
                    ls_schichtdetails-start_datum+4(2)
                    ls_schichtdetails-start_datum(4)
        INTO lv_date
        SEPARATED BY '.'.

*        CONCATENATE lv_date
*                    lv_workarea_text(3)
*                    ls_order-zzperi
*                    ls_order-zdidok
*                    ls_order-zlage
*        INTO lv_shorttext
*        SEPARATED BY '_'.

        lv_shorttext = lv_planbucktdesc." the description has to be same.

        APPEND VALUE #(
          orderid     = lv_objectkey
          order_type  = ls_aufk-auart    "'N007'
          pmacttype   = 'NAA'
          revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
          maintplant  = ls_result-maintenanceplanningplant
          planplant   = ls_result-maintenanceplanningplant
          plant       = ls_result-maintenanceplanningplant
          mn_wk_ctr   = 'CH'
*          short_text  = ls_result-maintplngbucketlabel
          short_text  = lv_shorttext
*          start_date  = ls_result-maintplanningbucketstartdate     "SEE START DATE FROM WORK AREA
          start_date  = ls_schichtdetails-start_datum     "SEE START DATE FROM Shift details
*          finish_date = ls_result-maintplanningbucketenddate     "SEE ENDDATE WORK AREA
          finish_date = ls_schichtdetails-end_datum     "SEE ENDDATE from shift details
        ) TO lt_header.


        APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up>).
        IF <ls_orderheader_up> IS ASSIGNED.
          <ls_orderheader_up>-orderid    = lv_objectkey.
          <ls_orderheader_up>-maintplant = abap_true.
          <ls_orderheader_up>-plant      = abap_true.
        ENDIF.
        UNASSIGN <ls_orderheader_up>.

*        adding TFF details in qualifications table.
        LOOP AT lt_qual_tff INTO ls_qual_tff WHERE wa_id = lv_workarea_id.
          APPEND ls_qual_tff-qual TO lt_qual.
          CLEAR ls_qual_tff .
        ENDLOOP.

        CLEAR : ls_qual, lv_activity,lv_objectkeyo, lv_refnum.
        LOOP AT lt_qual INTO ls_qual.


          READ TABLE lt_zia_2sf_veh_seat_all INTO DATA(ls_zia_2sf_veh_seat)
                                         WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
          IF sy-subrc = 0 AND ls_zia_2sf_veh_seat-uname IS NOT INITIAL  AND ls_zia_2sf_veh_seat-uname(3) NE 'EXT'.
            lv_len = strlen( ls_zia_2sf_veh_seat-uname ).
            lv_len = lv_len - 1.
            lv_uname = ls_zia_2sf_veh_seat-uname+1(lv_len).
          ELSE.
            CLEAR lv_uname.
            IF ls_qual-personalmodul = 'ER-TFF' AND ls_qual-uname IS NOT INITIAL.
              lv_len = strlen( ls_qual-uname ).
              lv_len = lv_len - 1.
              lv_uname = ls_qual-uname+1(lv_len).
            ENDIF.
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
            control_key = lv_steus "'PM01'
            work_cntr   = ls_qual-personalmodul    "'CH'
            plant       = ls_result-maintenanceplanningplant
            description = lv_shorttext"ls_result-maintplngbucketlabel
            field_key = 'N_DIENS'
            duration_normal = ls_qual-zdlz
            pers_no = lv_uname
            usr04 = lv_usr04
            use04 = lv_use04
            start_cons = ls_schichtdetails-start_datum
            strttimcon = ls_schichtdetails-start_zeit
            fin_constr = ls_schichtdetails-end_datum
            fintimcons = ls_schichtdetails-end_zeit
          ) TO lt_operation.

        ENDLOOP.

        "Fill update structure of operation
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
            it_header       = lt_header
            it_header_up    = lt_header_up
            it_operation    = lt_operation
            it_operation_up = lt_operation_up
            return          = lt_return.

*   RÜCKGABEVERARBEITUNG
        IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          READ TABLE lt_return WITH KEY id = 'IWO_BAPI2' number = '112' INTO DATA(ls_return).

          IF sy-subrc = 0.
*      RV_NUMBER = LS_RETURN-MESSAGE_V2.   " WEGEN FÜHRENDEN NULLEN
            lv_tot_admin_order  = lv_tot_admin_order + 1.
            CLEAR sy-subrc.

*            capture all admin orders created.
            ls_admin_tot-wa_id = lv_workarea_id."LS_ORDER-ZARBSTL
            ls_admin_tot-order = ls_return-message_v2.
            APPEND ls_admin_tot TO lt_admin_tot.
            CLEAR ls_admin_tot.
          ENDIF.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

*          populate total quantity per admin order.
          ls_total_qual-admin_order = ls_return-message_v2.
          ls_total_qual-qual = lv_n003_qual.
          APPEND ls_total_qual TO lt_total_qual.
          CLEAR ls_total_qual.

          ls_admin_tot-order = ls_return-message_v2.


*Updating revision number in planned orders.
          LOOP AT lt_order INTO ls_order.

            wd_assist->update_revision_number( EXPORTING is_order = ls_order
                                                           iv_revision = ls_result-maintenanceevent ).
          ENDLOOP.

*Call program ZIA_20001_M1
*          WAIT UP TO 2 seconds.
          wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).

          wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_admin_tot-order
                                                            iv_phase = '07'
                                                            iv_subphase = '0065' ).
          CLEAR ls_admin_tot-order.

        ENDIF.
      ENDIF.
*      Adding Planning Bucket details
      ls_order_revi-pb = ls_result-maintenanceplanningbucket.
      ls_order_revi-revi = ls_result-maintenanceevent.
      APPEND ls_order_revi TO lt_order_revi.
      CLEAR ls_order_revi.


    ENDIF. "checking if any non N004 orders exists
*GET VEHICLE DETAILS.

    lo_fahrzeuge_i     ?=  lo_arbstelle->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
*        CHECK ABAP_FALSE  = LO_FAHRZEUG->IS_BASIS_FZ_PNEU( ).       "CHECK ONLY SCHIENE
      IF lv_workarea_text CS 'RAIL' OR lv_workarea_text CS 'SCHIENE' OR lv_workarea_text CS 'ROTAIA' .
***
*      DATA(LS_VEHICLE_DATA) = LO_ARBSTELLE->GET_DATA( ).
        DATA(ls_vehicle_data) = lo_fahrzeug->get_data( ).
*      DATA(LS_VEHICLE_TYPE) = LO_ARBSTELLE->GET_ID( ).
        DATA(lv_vehicle_type) = lo_fahrzeug->get_id( ) ##NEEDED.




*      POPULATE TABLE ZIA_2SF_VEH_COST
        ls_zia_2sf_veh_cost-mandt = sy-mandt. "MANDT
        ls_zia_2sf_veh_cost-zschicht = ls_schichtdetails-zschicht. "SHIFT ID
        ls_zia_2sf_veh_cost-schicht_auftrag = lv_shift_aufnr. "SHIFT ORDER
        ls_zia_2sf_veh_cost-arbeitstellen_id = lv_workarea_id. "WORK AREA ID
        ls_zia_2sf_veh_cost-etap_aufnr = ls_return-message_v2. "STAGE ORDER
        ls_zia_2sf_veh_cost-zid_fzg = ls_vehicle_data-zid_fzg. "VEHICLE ID
        ls_zia_2sf_veh_cost-zid_fztyp = ls_vehicle_data-zid_fztyp. "  ID FOR THE VEHICLE TYPE

        READ TABLE lt_zia_2veh_typ_rat INTO DATA(ls_zia_2veh_typ_rat)
                      WITH KEY zid_fztyp = ls_vehicle_data-zid_fztyp.
        IF sy-subrc = 0.
          ls_zia_2sf_veh_cost-fahrzeug_kosten = ls_zia_2veh_typ_rat-zfahrzeugtarif."VEHICLE COSTS

        ENDIF.
        ##NEEDED         READ TABLE lt_zia_2veh_typ_sp INTO DATA(ls_zia_2veh_typ_sp)
                               WITH KEY zzperi = ls_schichtdetails-zzperi
                                        zid_fztyp = ls_zia_2sf_veh_cost-zid_fztyp.
        IF sy-subrc = 0.
          IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
            ls_zia_2sf_veh_cost-er_ir = 'ER'. "ER/ IR default for now.
          ENDIF.

          IF ls_order-auart = 'N004' .
            ls_zia_2sf_veh_cost-er_ir = 'IR'. "ER/ IR
          ENDIF.
          READ TABLE lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck1)
                    WITH KEY jahr = sy-datum(4)
                             perimeter = ls_schichtdetails-zzperi.
*                               kategorie = 'Vehicles'.
          IF sy-subrc = 0.

            ls_zia_2sf_veh_cost-spez_fzg_kstenblck = ls_zia_2cost_blck1-aufnr.

          ENDIF.
        ENDIF.

        APPEND ls_zia_2sf_veh_cost TO lt_zia_2sf_veh_cost.

        MOVE-CORRESPONDING ls_zia_2sf_veh_cost TO ls_workarea_tot.
        COLLECT ls_workarea_tot INTO lt_workarea_tot.      "#EC COLLECT


        CLEAR: ls_zia_2sf_veh_cost, ls_workarea_tot.

      ENDIF.

***
    ENDWHILE.

*        POPOULATE ZIA_2SF_ORDERSTR INCLUING THE PLANNED ORDERS.
*    IF lt_order IS NOT INITIAL.

    LOOP AT lt_order INTO ls_order.

      ls_zia_2sf_orderstr-mandt = sy-mandt."MANDT
      ls_zia_2sf_orderstr-zschicht = ls_schichtdetails-zschicht."LS_ORDER-ZSCHICHT. "SHIFT ID
      ls_zia_2sf_orderstr-schicht_auftrag = lv_shift_aufnr."LS_ORDER-AUFNR. "SHIFT ORDER
      ls_zia_2sf_orderstr-arbeitstellen_id = lv_workarea_id."LS_ORDER-ZARBSTL. "WORK AREA ID
      ls_zia_2sf_orderstr-maintplngbucketlabel = ls_result-maintenanceplanningbucket."lv_planbucktdesc. "MAINTENANCE PLANNING BUCKET LABEL.
      ls_zia_2sf_orderstr-etap_aufnr = ls_return-message_v2. " STAGE ORDER ( ADMIN ORDER )
      ls_zia_2sf_orderstr-aufnr = ls_order-aufnr. "PLANNED ORDERS

      IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
        ls_zia_2sf_orderstr-er_ir = 'ER'. "ER/ IR
      ENDIF.

      IF ls_order-auart = 'N004' .
        ls_zia_2sf_orderstr-er_ir = 'IR'. "ER/ IR
      ENDIF.
      LOOP AT lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck) "#EC CI_NESTED "#EC CI_STDSEQ
                  WHERE jahr = sy-datum(4)
                    AND perimeter = ls_order-zzperi.
        TRANSLATE ls_zia_2cost_blck TO UPPER CASE.  "#EC DEPRECATED_KEY
        IF ls_zia_2cost_blck-kategorie = 'PERSONAL'.
          ls_zia_2sf_orderstr-kostenblock = ls_zia_2cost_blck-aufnr. " COST BLOCK PERSONAL
        ENDIF.
        IF ls_zia_2cost_blck-kategorie = 'VEHICLES'.
          ls_zia_2sf_orderstr-kostenblock_vehicle = ls_zia_2cost_blck-aufnr. " COST BLOCK PERSONAL
        ENDIF.

      ENDLOOP.

*      ##WARN_OK           READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot "#EC CI_STDSEQ
      ##WARN_OK           READ TABLE lt_ord_qual_o INTO ls_ord_qual_o "#EC CI_STDSEQ
          WITH KEY "zschicht = ls_zia_2sf_orderstr-zschicht
                   wa_id = ls_zia_2sf_orderstr-arbeitstellen_id
                   n004_ord = ls_zia_2sf_orderstr-aufnr.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-anzahl_qual = ls_ord_qual_o-qual.
*          ls_zia_2sf_orderstr-percentage =  ls_wa_ord_tot-wa_percentage.
        ##WARN_OK         READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
        IF sy-subrc = 0.
          ls_zia_2sf_orderstr-percentage = ( ls_zia_2sf_orderstr-anzahl_qual / ls_wa_qual_tot-wa_count ) * 100 .
        ENDIF.
      ENDIF.
      ls_zia_2sf_orderstr-accesstype = ls_order-zzzugangsart. " access type.
*  LS_ZIA_2SF_ORDERSTR- = LS_ORDER-. "
      APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstr.
      CLEAR : ls_zia_2sf_orderstr .", ls_order.

*populate revision number using maintenace event.

*Get Order details

      IF ls_order = '1'.

        wd_assist->populate_revision_number( EXPORTING is_order = ls_order
                                                       iv_revision = ls_result-maintenanceevent ).

      ENDIF.

      DATA: lt_order_data    TYPE eams_t_bo_ord_header,
            ls_order_data	   TYPE eams_s_bo_ord_header,
            lv_objnr         TYPE jsto-objnr,
            lv_txt04         TYPE tj02t-txt04,
            lv_status_number TYPE jest-stat.

      "fetch Maintenance Order Details
      ##NEEDED
      cl_eams_bo_order=>s_get_instance( )->get_order_header(
        EXPORTING
*        it_node_id     =  VALUE #( ( eams_aufnr = mv_number ) )                 "Business Object Order - Identification
          it_node_id     =  VALUE #( ( eams_aufnr = ls_order-aufnr ) )                 "Business Object Order - Identification
        IMPORTING
          et_node_data   =  lt_order_data                                         "Business Object Order - Header Data
          et_node_id_rel =  DATA(lt_node_id_rel1)                                 "Relationship between index of source and target node ID
          et_messages    =  DATA(lt_message) ).                                   "Message

      CHECK lt_order_data IS NOT INITIAL.
      ls_order_data = VALUE #( lt_order_data[ eams_aufnr = ls_order-aufnr ] ).

*            deactivate PL2 if it exists.
      IF ls_order_data-userstatus CS 'PL2'.

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
*                                                   iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
                                                 iv_maintordovrlprocsubphase = '0065' ).


*CHANGE MAINTENANCE ORDER.

      CLEAR: lt_methods,
             lt_header,
             lt_operation,
             ls_header_up,
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

*   VORGANG HINZUFÜGEN
*            APPEND VALUE #(
*              refnumber  = 1
*              objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
*              method     = if_eams_bo_const=>gc_bapi_ord_method-change
*              objectkey  = lv_objectkey
*            ) TO lt_methods.
*   POPULATE THE HEADER TABLE
      APPEND VALUE #(
        orderid     = lv_objectkey
        order_type  = ls_order-auart
        revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
      ) TO lt_header.


      APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up1>).
      IF <ls_orderheader_up1> IS ASSIGNED.
        <ls_orderheader_up1>-orderid    = lv_objectkey.
        <ls_orderheader_up1>-revision = abap_true.
*              <ls_orderheader_up1>-plant      = abap_true.
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
*         it_operation = lt_operation
          return       = lt_return.
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.

    ENDLOOP.

*Call program ZIA_20001_M1
*    wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).

*Updating all planned orders with status.
    LOOP AT lt_order INTO ls_order.

*      resetting ready for scheduling order status.
      cl_eams_bo_order=>s_get_instance( )->if_eams_bo_order~reset_ready_for_scheduling(
        EXPORTING
          it_ord_id       = VALUE #( ( eams_aufnr = ls_order-aufnr ) )
        IMPORTING
  ##NEEDED  et_message      = DATA(lt_messager)
  ##NEEDED  et_index_failed = DATA(lt_index_failed) ).

      wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_order-aufnr
                                                        iv_phase = '07'
                                                        iv_subphase = '0065' ).

      CLEAR ls_order.
    ENDLOOP.


  ENDWHILE.

*          POPOULATE % VALUE IN THE TABLE LT_ZIA_2SF_VEH_COST
*  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
*    READ TABLE lt_workarea_tot INTO ls_workarea_tot      "#EC CI_STDSEQ
*            WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
**                     SCHICHT_AUFTRAG = LS_ZIA_2SF_VEH_COST-SCHICHT_AUFTRAG
**                     ARBEITSTELLEN_ID = LS_ZIA_2SF_VEH_COST-ARBEITSTELLEN_ID
**                     ETAP_AUFNR = LS_ZIA_2SF_VEH_COST-ETAP_AUFNR.
*    IF sy-subrc = 0.
*      ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten ) * 100.
*    ENDIF.
*    MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
*    CLEAR : ls_zia_2sf_veh_cost, ls_workarea_tot.
*  ENDLOOP.

*  MODIFY zia_2sf_veh_cost FROM TABLE lt_zia_2sf_veh_cost.
*  MODIFY zia_2sf_orderstr FROM TABLE lt_zia_2sf_orderstr.

*shifting at the end. 12/05/2026.
*  wd_assist->modify_settlement_tables( EXPORTING it_zia_2sf_orderstr = lt_zia_2sf_orderstr
*                                                 it_zia_2sf_veh_cost = lt_zia_2sf_veh_cost ).


*deleteing orders with same WBS.
  DATA : ls_header1 TYPE bapi_alm_order_header_e,
         lt_srules1 TYPE STANDARD TABLE OF bapi_alm_order_srule_e,
         ls_srules1 TYPE bapi_alm_order_srule_e,
         lt_ret     TYPE STANDARD TABLE OF bapiret2.

  LOOP AT lt_order_n004 INTO ls_order.
    ls_n004_wbs-order = ls_order-aufnr.
    ls_n004_wbs-zarbstl = ls_order-zarbstl.

    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number    = ls_order-aufnr
      IMPORTING
        es_header = ls_header1
      TABLES
        et_srules = lt_srules1
        return    = lt_ret.

    IF ls_header1-order_type = 'N004'.
      READ TABLE lt_srules1 INTO ls_srules1 INDEX 1.
      IF sy-subrc = 0.
        ls_n004_wbs-wbs = ls_srules1-wbs_element.
      ELSE.
        ls_n004_wbs-wbs = ls_order-aufnr."this is done so that n003 orders of access type 2 are not deleted.
      ENDIF.
    ENDIF.
    APPEND ls_n004_wbs TO lt_n004_wbs.
    CLEAR : ls_order, ls_n004_wbs.
  ENDLOOP.
  lt_n004_wbs_o[] = lt_n004_wbs[]. " just keeping this table to use it for reading later.
  SORT lt_n004_wbs BY wbs.
  DELETE ADJACENT DUPLICATES FROM lt_n004_wbs COMPARING zarbstl wbs.


  LOOP AT lt_order_n004 INTO ls_order.

    READ TABLE lt_n004_wbs INTO ls_n004_wbs WITH KEY order = ls_order-aufnr.
    IF sy-subrc NE 0.
      CONTINUE. " here it will skip the below code if the record is not found.
    ENDIF.
    ##WARN_OK
    READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order-zarbstl.

    CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
                ls_schichtdetails-start_datum+4(2) '.'
                ls_schichtdetails-start_datum(4) '_'
                ls_schichtdetails-zzperi '_'
                ls_wa_details-text '_'
                'IR_'
                ls_order-zzzugangsart '_'
                ls_n004_wbs-wbs
                INTO lv_planbucktdesc_n4.

*    DATA(lv_bucket_cid)         = xco_cp=>uuid( )->value.
    lv_bucket_cid         = xco_cp=>uuid( )->value.
    lt_create_bucket = VALUE #( ( %cid                                    = lv_bucket_cid
                                 %is_draft                               = if_abap_behv=>mk-on
                                 maintplanningbucketdescription          = lv_planbucktdesc_n4 "'TEST DESC'"LS_ACTION_INFORMATION-%PARAM-BUCKETDESCRIPTION
                                 nrofmaintplngbucketsinadvance           = 1
                                 maintplngbucketgenerationdate           = sy-datum
                                 maintplanningbuckettype                 = 'STO'"zif_ir_1pb_c=>mc_pb_type-event_based_maintenance
                                 maintenanceplanningplant                = ls_aufk-werks "'8331'"LS_ACTION_INFORMATION-%PARAM-PLANNINGPLANT
                                 maintenanceplant                        = ' ' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEPLANT
                                 maintplngbucketstartdatetime            = lv_startdatetime "'20260316110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-STARTDATEANDTIME
                                 maintplngbucketenddatetime              = lv_enddatetime "'20260318110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-ENDDATEANDTIME
                                 maintplngbucketrecurrencetype           = if_eam_mtplngbkt_const=>maintplngbcktrecurrencetype-once
                                 maintplngbcktrcrrcinterval              = 1
                                 maintenanceeventtype                    = 'NA' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE
                                 mainworkcenter                          = lc_planning
                                 adminvordworkcenterinternal             = lv_workcenterinternalid
                                 zir_1pb_veh_type_mpb                    = ' ' "LS_ACTION_INFORMATION-%PARAM-VEHICLETYPE
                                 zir_1pb_rfs_mpb                         = ' ' "LS_ACTION_INFORMATION-%PARAM-REASONFORSTAY
                                 %control-maintplanningbucketdescription = if_abap_behv=>mk-on
                                 %control-nrofmaintplngbucketsinadvance  = if_abap_behv=>mk-on
                                 %control-maintplngbucketgenerationdate  = if_abap_behv=>mk-on
                                 %control-maintplanningbuckettype        = if_abap_behv=>mk-on
                                 %control-maintenanceplanningplant       = if_abap_behv=>mk-on
                                 %control-maintenanceplant               = if_abap_behv=>mk-on
                                 %control-maintplngbucketstartdatetime   = if_abap_behv=>mk-on
                                 %control-maintplngbucketenddatetime     = if_abap_behv=>mk-on
                                 %control-maintplngbucketrecurrencetype  = if_abap_behv=>mk-on
                                 %control-maintplngbcktrcrrcinterval     = if_abap_behv=>mk-on
                                 %control-maintenanceeventtype           = if_abap_behv=>mk-on
                                 %control-mainworkcenter                 = if_abap_behv=>mk-on
                                 %control-adminvordworkcenterinternal    = if_abap_behv=>mk-on
                                 %control-zir_1pb_veh_type_mpb           = if_abap_behv=>mk-on
                                 %control-zir_1pb_rfs_mpb                = if_abap_behv=>mk-on ) ).


    lt_create_scope = VALUE #( ( %cid_ref                       = lv_bucket_cid"ls_action_information-%cid
                                 %is_draft                      = if_abap_behv=>mk-on
                                 maintplngbcktscprangefieldname = lc_work_center
                          %target  = VALUE  #( ( %cid                              = xco_cp=>uuid( )->value
                                                 %is_draft                         = if_abap_behv=>mk-on
                                                 maintplngbucketscopergsg          = 'I'
                                                 maintplngbucketscopergop          = 'EQ'
                                                 maintplngbucketscopergfr          = lc_planning
                                                 mainworkcenter                    = lc_planning
                                                 workcenterinternalid              = lv_workcenterinternalid
                                                 mainworkcenterplant               = ls_action_information-%param-planningplant
                                                 maintenanceplanningplant          = ls_action_information-%param-planningplant
                                                 maintenanceplant                  = ls_action_information-%param-maintenanceplant
                                                 %control-maintplngbucketscopergsg = if_abap_behv=>mk-on
                                                 %control-maintplngbucketscopergop = if_abap_behv=>mk-on
                                                 %control-maintplngbucketscopergfr = if_abap_behv=>mk-on
                                                 %control-mainworkcenter           = if_abap_behv=>mk-on
                                                 %control-workcenterinternalid     = if_abap_behv=>mk-on
                                                 %control-mainworkcenterplant      = if_abap_behv=>mk-on
                                                 %control-maintenanceplanningplant = if_abap_behv=>mk-on
                                                 %control-maintenanceplant         = if_abap_behv=>mk-on ) ) ) ).

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
       CREATE FROM lt_create_bucket
      ENTITY maintplngbucketscopenametp
       CREATE BY \_maintplanningbucketscopetp
        FROM lt_create_scope
    MAPPED   ls_bucket_response-mapped
    FAILED   ls_bucket_response-failed
    REPORTED ls_bucket_response-reported.


    ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped_n4>) ELSE UNASSIGN.
    IF <ls_mapped_n4> IS ASSIGNED.
      lv_maintplanningbucketuuid = <ls_mapped_n4>-maintplanningbucketuuid.
    ENDIF.

    IF <ls_mapped_n4>                                     IS NOT ASSIGNED
    OR ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
    OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.


    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
        EXECUTE prepare
          FROM VALUE #( ( %key-maintplanningbucketuuid = <ls_mapped_n4>-maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.

    ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped1_n4>) ELSE UNASSIGN.


    IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE activate
            FROM VALUE #( ( %cid                         = lv_bucket_cid
                            %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.

    IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.

    wd_assist->commit_pb( ).


*get the total number of planning buckets.
    ls_pb_tot-wa_id = ls_order-zarbstl.
    ls_pb_tot-wa_count = 1.
    COLLECT ls_pb_tot INTO lt_pb_tot.                      "#EC COLLECT

*****************  CREATE MAINTENANCE EVENT.
*    DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~edit.
*    ##NEEDED   DATA(lv_is_draft)           = if_abap_behv=>mk-on.

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
        EXECUTE edit
         AUTO FILL CID
          WITH VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response1-mapped
      FAILED   ls_bucket_response1-failed
      REPORTED ls_bucket_response1-reported.

    ##PRIMKEY[ENTITY]
    ASSIGN ls_bucket_response1-mapped-maintplanningbuckettp[ %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ] TO FIELD-SYMBOL(<ls_bucket_n4>).
    IF <ls_bucket_n4> IS ASSIGNED.

      lt_create_maintenance_event = VALUE #( ( %cid                   = lv_bucket_cid "uncommented by e564128 on 20.04.26
                                               %key                        = <ls_bucket_n4>-%key "<LS_MAPPED>-%KEY
                                               %param = 'N' "uncommented by e564128 on 20.04.26
                                               ) ). "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE ) ).

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
*          """"" EXECUTE createmaintenanceevent
          EXECUTE edit
            FROM lt_create_maintenance_event
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.



      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE prepare
            FROM VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
          MAPPED   ls_bucket_response-mapped
          FAILED   ls_bucket_response-failed
          REPORTED ls_bucket_response-reported.


      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE activate
            FROM VALUE #( ( %cid                         = lv_bucket_cid
                            %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.


*      COMMIT ENTITIES.
      wd_assist->commit_entities( ).

      READ ENTITIES OF r_maintplanningbuckettp_2
    ENTITY maintplanningbuckettp
    ALL FIELDS WITH
      VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
    RESULT DATA(lt_result_n4)
    FAILED DATA(ls_failed_n4)
    REPORTED DATA(ls_reported_n4).

*      DATA ls_result LIKE LINE OF lt_result.

      READ TABLE lt_result_n4 INTO ls_result WITH KEY maintplanningbucketuuid = lv_maintplanningbucketuuid.

*CREATE MAINTENANCE ORDER.

      CLEAR: lt_methods,
             lt_header,
             lt_operation,
             ls_header_up,
             lt_header_up,
             lt_return,
             lv_objectkey.


      lv_objectkey = '%00000000001'.
      FREE lt_methods.

*   METHODS - ANLEGEN
      APPEND VALUE #(
        refnumber  = 1
        objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
        method     = if_eams_bo_const=>gc_bapi_ord_method-create
        objectkey  = lv_objectkey
      ) TO lt_methods.


*   POPULATE THE HEADER TABLE
      CLEAR : lv_date, lv_shorttext.
      CONCATENATE ls_schichtdetails-start_datum+6(2)
                  ls_schichtdetails-start_datum+4(2)
                  ls_schichtdetails-start_datum(4)
      INTO lv_date
      SEPARATED BY '.'.

*      CONCATENATE lv_date
*                  lv_workarea_text(3)
*                  ls_order-zzperi
*                  ls_order-zdidok
*                  ls_order-zlage
*      INTO lv_shorttext
*      SEPARATED BY '_'.


      lv_shorttext = lv_planbucktdesc_n4." the description has to be same.

      APPEND VALUE #(
        orderid     = lv_objectkey
        order_type  = ls_aufk-auart    "'N007'
        pmacttype   = 'NAA'
        revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
        maintplant  = ls_result-maintenanceplanningplant
        planplant   = ls_result-maintenanceplanningplant
        plant       = ls_result-maintenanceplanningplant
        mn_wk_ctr   = 'CH'
*        short_text  = ls_result-maintplngbucketlabel
        short_text  = lv_shorttext
*          start_date  = ls_result-maintplanningbucketstartdate     "SEE START DATE FROM WORK AREA
          start_date  = ls_schichtdetails-start_datum     "SEE START DATE FROM Shift details
*          finish_date = ls_result-maintplanningbucketenddate     "SEE ENDDATE WORK AREA
          finish_date = ls_schichtdetails-end_datum     "SEE ENDDATE from shift details
      ) TO lt_header.


      APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up_n4>).
      IF <ls_orderheader_up_n4> IS ASSIGNED.
        <ls_orderheader_up_n4>-orderid    = lv_objectkey.
        <ls_orderheader_up_n4>-maintplant = abap_true.
        <ls_orderheader_up_n4>-plant      = abap_true.
      ENDIF.
      UNASSIGN <ls_orderheader_up_n4>.

      CLEAR : ls_qual, lv_activity,lv_objectkeyo, lv_refnum.
*      LOOP AT lt_qual_n004 INTO ls_qual.                 "#EC CI_NESTED
*      LOOP AT lt_qual_original INTO ls_qual_original WHERE order = ls_order-aufnr. "#EC CI_NESTED "New for all entries in qualities table.
      LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_order-aufnr. "#EC CI_NESTED "New for all entries in qualities table.
*        ls_qual = ls_qual_original-qual.
*        The below check is done to ensure that only this particular orders qualities are added.
*        READ TABLE lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
*        IF ls_zia_2order_cap_total-aufnr = ls_order-aufnr.
*        LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE zid_fzg_platz = ls_qual-zid_fzg_platz
*                                                                       AND aufnr = ls_order-aufnr.

*      Below code is written to get the total duration per employee
        IF ls_order-auart = 'N003'.
          CLEAR : ls_wa_ord_tot_n41,ls_wa_ord_tot_n42, lv_zdlz.
          LOOP AT lt_order_original INTO ls_order_original WHERE auart = ls_order-auart
                                                             AND zzzugangsart = ls_order-zzzugangsart. "#EC CI_NESTED
            READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot_n41 WITH KEY wa_ord = ls_order_original-aufnr.

            LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_order_original-aufnr
                                                                           AND zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz. "#EC CI_NESTED
              READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot_n42 WITH KEY wa_ord = ls_zia_2order_cap_total-aufnr.

              IF ls_wa_ord_tot_n41-wa_id = ls_wa_ord_tot_n42-wa_id. "this is to check if the workareas are same.
                lv_zdlz = lv_zdlz + ls_zia_2order_cap_total-zdauer.
                READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.
              ENDIF.

            ENDLOOP.

          ENDLOOP.
        ELSE.
*          The below code is written to get the multiple quantities on same wbs in same workarea.

          CLEAR : lv_zdlz.
          READ TABLE lt_n004_wbs_o INTO ls_n004_wbs WITH KEY order = ls_order-aufnr.
          IF sy-subrc = 0 AND ls_n004_wbs-wbs IS NOT INITIAL.
            LOOP AT lt_n004_wbs_o INTO ls_n004_wbs_o WHERE zarbstl = ls_n004_wbs-zarbstl AND wbs = ls_n004_wbs-wbs. "#EC CI_NESTED
              LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_n004_wbs_o-order
                                                                     AND zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz. "#EC CI_NESTED
                lv_zdlz = lv_zdlz + ls_zia_2order_cap_total-zdauer.
                READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.


              ENDLOOP.
            ENDLOOP.
          ENDIF.

*          if the quantity is not filled in above logic, then the below is triggered.
          IF lv_zdlz IS INITIAL.
            lv_zdlz = ls_zia_2order_cap_total-zdauer.
            READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.

          ENDIF.


        ENDIF.





        READ TABLE lt_zia_2sf_veh_seat_all INTO ls_zia_2sf_veh_seat
*                                       WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
                                       WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.
        IF sy-subrc = 0 AND ls_zia_2sf_veh_seat-uname IS NOT INITIAL  AND ls_zia_2sf_veh_seat-uname(3) NE 'EXT'.
          lv_len = strlen( ls_zia_2sf_veh_seat-uname ).
          lv_len = lv_len - 1.
          lv_uname = ls_zia_2sf_veh_seat-uname+1(lv_len).
        ELSE.
          CLEAR lv_uname.
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
          control_key = lv_steus "'PM01'
          work_cntr   = ls_qual-personalmodul    "'CH'
          plant       = ls_result-maintenanceplanningplant
          description = lv_shorttext"ls_result-maintplngbucketlabel
          field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
          duration_normal = lv_zdlz
          pers_no = lv_uname
          usr04 = lv_usr04
          use04 = lv_use04
          start_cons = ls_schichtdetails-start_datum
          strttimcon = ls_schichtdetails-start_zeit
          fin_constr = ls_schichtdetails-end_datum
          fintimcons = ls_schichtdetails-end_zeit
        ) TO lt_operation.

*        ENDIF.

*        ENDLOOP.
      ENDLOOP.

*      Adding TFF values to qualifications.
      LOOP AT lt_qual_tff INTO ls_qual_tff WHERE wa_id = ls_order-zarbstl. "#EC CI_NESTED
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
          control_key = lv_steus "'PM01'
          work_cntr   = ls_qual_tff-qual-personalmodul    "'CH'
          plant       = ls_result-maintenanceplanningplant
          description = lv_shorttext"ls_result-maintplngbucketlabel
          field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
          duration_normal = '0'"lv_zdlz
          pers_no = lv_uname
          usr04 = lv_usr04
          use04 = lv_use04
          start_cons = ls_schichtdetails-start_datum
          strttimcon = ls_schichtdetails-start_zeit
          fin_constr = ls_schichtdetails-end_datum
          fintimcons = ls_schichtdetails-end_zeit
        ) TO lt_operation.

      ENDLOOP.

      "Fill update structure of operation
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
          it_header       = lt_header
          it_header_up    = lt_header_up
          it_operation    = lt_operation
          it_operation_up = lt_operation_up
          return          = lt_return.

*   RÜCKGABEVERARBEITUNG
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        READ TABLE lt_return WITH KEY id = 'IWO_BAPI2' number = '112' INTO ls_return.

        IF sy-subrc = 0.
*      RV_NUMBER = LS_RETURN-MESSAGE_V2.   " WEGEN FÜHRENDEN NULLEN
          lv_tot_admin_order  = lv_tot_admin_order + 1.
          CLEAR sy-subrc.

*            capture all admin orders created.
          ls_admin_tot-wa_id = ls_order-zarbstl."lv_workarea_id."
          ls_admin_tot-order = ls_return-message_v2.
          ls_admin_tot-n004_ord = ls_order-aufnr.
          APPEND ls_admin_tot TO lt_admin_tot.
          CLEAR ls_admin_tot.
          READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot WITH KEY wa_ord = ls_order-aufnr.
          IF sy-subrc = 0.

*          populate total quantity per admin order.
            ls_total_qual-admin_order = ls_return-message_v2.
            ls_total_qual-qual = ls_wa_ord_tot-wa_count.
            APPEND ls_total_qual TO lt_total_qual.
            CLEAR ls_total_qual.

          ENDIF.
        ENDIF.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        ls_total_qual-admin_order = ls_return-message_v2.
*Updating revision number in planned orders.
        wd_assist->update_revision_number( EXPORTING is_order = ls_order
                                                       iv_revision = ls_result-maintenanceevent ).


*        Call program ZIA_20001_M1


        wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).

        wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_total_qual-admin_order
                                                          iv_phase = '07'
                                                          iv_subphase = '0065' ).
        CLEAR ls_total_qual-admin_order.
      ENDIF.
    ENDIF.



    ls_zia_2sf_orderstr-mandt = sy-mandt."MANDT
    ls_zia_2sf_orderstr-zschicht = ls_schichtdetails-zschicht."LS_ORDER-ZSCHICHT. "SHIFT ID
    ls_zia_2sf_orderstr-schicht_auftrag = lv_shift_aufnr."LS_ORDER-AUFNR. "SHIFT ORDER
    ls_zia_2sf_orderstr-arbeitstellen_id = ls_order-zarbstl. "WORK AREA ID
    ls_zia_2sf_orderstr-maintplngbucketlabel = ls_result-maintenanceplanningbucket."lv_planbucktdesc. "MAINTENANCE PLANNING BUCKET LABEL.
    ls_zia_2sf_orderstr-etap_aufnr = ls_return-message_v2. " STAGE ORDER ( ADMIN ORDER )
    ls_zia_2sf_orderstr-aufnr = ls_order-aufnr. "PLANNED ORDERS

    IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
      ls_zia_2sf_orderstr-er_ir = 'ER'. "ER/ IR
    ENDIF.

    IF ls_order-auart = 'N004' .
      ls_zia_2sf_orderstr-er_ir = 'IR'. "ER/ IR
    ENDIF.
    LOOP AT lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck2) "#EC CI_NESTED "#EC CI_STDSEQ
                WHERE jahr = sy-datum(4)
                  AND perimeter = ls_order-zzperi.
      TRANSLATE ls_zia_2cost_blck2 TO UPPER CASE.   "#EC DEPRECATED_KEY
      IF ls_zia_2cost_blck2-kategorie = 'PERSONAL'.
        ls_zia_2sf_orderstr-kostenblock = ls_zia_2cost_blck2-aufnr. " COST BLOCK PERSONAL
      ENDIF.
      IF ls_zia_2cost_blck2-kategorie = 'VEHICLES'.
        ls_zia_2sf_orderstr-kostenblock_vehicle = ls_zia_2cost_blck2-aufnr. " COST BLOCK PERSONAL
      ENDIF.

    ENDLOOP.

*    ##WARN_OK           READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot "#EC CI_STDSEQ
    ##WARN_OK           READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot "#EC CI_STDSEQ
        WITH KEY zschicht = ls_zia_2sf_orderstr-zschicht
                 wa_id = ls_zia_2sf_orderstr-arbeitstellen_id
                 wa_ord = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-anzahl_qual = ls_wa_ord_tot-wa_count.
*      ls_zia_2sf_orderstr-percentage =  ls_wa_ord_tot-wa_percentage.
      ##WARN_OK     READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-percentage = ( ls_zia_2sf_orderstr-anzahl_qual / ls_wa_qual_tot-wa_count ) * 100 .
      ENDIF.
    ENDIF.
    ls_zia_2sf_orderstr-accesstype = ls_order-zzzugangsart. " access type.
    READ TABLE lt_n004_wbs_o INTO ls_n004_wbs WITH KEY order = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-wbs = ls_n004_wbs-wbs.
    ENDIF.
*  LS_ZIA_2SF_ORDERSTR- = LS_ORDER-. "
    APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstr.
    CLEAR : ls_zia_2sf_orderstr .", ls_order.

*populate revision number using maintenace event.

*Get Order details

*        IF ls_order = '1'.
*Shifted the below code before calling program ZIA_20001_M1
*    wd_assist->populate_revision_number( EXPORTING is_order = ls_order
*                                                   iv_revision = ls_result-maintenanceevent ).


*Call program ZIA_20001_M1
*    wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).


*add vehicle details for N004 orders.
    LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost
                              WHERE arbeitstellen_id = ls_order-zarbstl. "#EC CI_NESTED

      ##WARN_OK     READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order-zarbstl. ##WARN_OK
      IF ls_wa_details-text CS 'RAIL' OR ls_wa_details-text CS 'SCHIENE' OR ls_wa_details-text CS 'ROTAIA' .

        ls_zia_2sf_veh_cost-etap_aufnr = ls_return-message_v2.
        ls_zia_2sf_veh_cost-er_ir = 'IR'.
*      READ TABLE lt_workarea_tot INTO ls_workarea_tot    "#EC CI_STDSEQ
*          WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
*      IF sy-subrc = 0.
*        ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten ) * 100.
*      ENDIF.
        APPEND ls_zia_2sf_veh_cost TO lt_zia_2sf_veh_costn.
        CLEAR ls_zia_2sf_veh_cost.

      ENDIF.
    ENDLOOP.


*      Adding Planning Bucket details
    ls_order_revi-pb = ls_result-maintenanceplanningbucket.
    ls_order_revi-revi = ls_result-maintenanceevent.
    APPEND ls_order_revi TO lt_order_revi.
    CLEAR ls_order_revi.


*        ENDIF.
  ENDLOOP.

*  *  Modifying z tables.
  APPEND LINES OF lt_zia_2sf_veh_costn TO lt_zia_2sf_veh_cost.

*deleting records where admin order is not created.
  DELETE lt_zia_2sf_veh_cost WHERE etap_aufnr IS INITIAL.

*  populating data for settlement rule per shift order.
  CLEAR : lv_qual_per, lv_n003_qual.

*  populating total orders table.
*  lt_zia_2sf_orderstc[] = lt_zia_2sf_orderstr[].
*  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstc COMPARING etap_aufnr.
*  LOOP AT lt_zia_2sf_orderstc INTO ls_zia_2sf_orderstr.
*
*    AT LAST.
*      ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*      ls_total_labor-percentage = 100 - lv_qual_per.
*      DATA(lv_last) = 'X'.
*    ENDAT.
*    IF lv_last = 'X'.
*      ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*    ENDIF.
*    IF lv_last IS INITIAL.
*      AT NEW etap_aufnr.
*
*        ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*        ls_total_labor-percentage   = ( 1 / lv_tot_admin_order ) * 100.
*        lv_qual_per = lv_qual_per + ls_total_labor-percentage.
*      ENDAT.
*    ENDIF.
*
*
*    APPEND ls_total_labor TO lt_total_labor.
*
*  ENDLOOP.
* New calculation for total labor
*  DESCRIBE TABLE lt_wa_qual_tot LINES DATA(lv_tot_wa).

  lv_tot_wa = lines( lt_wa_qual_tot ).
*  commented below loop on 20.07.26, moved this table to last.
*  new calculation for total labor
*  LOOP AT lt_total_qual INTO ls_total_qual.
*
*    AT LAST.
*      ls_total_labor-admin_order = ls_total_qual-admin_order.
*      ls_total_labor-percentage = 100 - lv_qual_per.
*      DATA(lv_last) = 'X'.
*    ENDAT.
*    IF lv_last = 'X'.
*      ls_total_labor-admin_order = ls_total_qual-admin_order.
*    ENDIF.
*    IF lv_last IS INITIAL.
*      CLEAR lv_n003_qual.
*      lv_n003_qual = ls_total_qual-qual. " temporaty use of variable.
*      AT NEW admin_order.
*
*        ls_total_labor-admin_order = ls_total_qual-admin_order.
*        ls_total_labor-percentage   = ( lv_n003_qual / lv_tot_qual ) * 100.
*        lv_qual_per = lv_qual_per + ls_total_labor-percentage.
*      ENDAT.
*    ENDIF.
*
*
*    APPEND ls_total_labor TO lt_total_labor.
*
*  ENDLOOP.

* populating total vehicle and special product table.
  CLEAR : lv_qual_per, lv_last.

  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
    AT LAST.
      lv_last = 'X'.
    ENDAT.
*    at new etap_aufnr.
    IF ls_zia_2sf_veh_cost-spez_fzg_kstenblck IS INITIAL.

      ls_total_veh-admin_order = ls_zia_2sf_veh_cost-etap_aufnr.

    ELSE.
      ls_total_veh-admin_order = ls_zia_2sf_veh_cost-spez_fzg_kstenblck.
    ENDIF.
*    ls_total_veh-percentage = ls_zia_2sf_veh_cost-prozent.

    IF lv_last = 'X'.
      ls_total_veh-percentage = 100 - lv_qual_per.
      IF ls_total_veh-percentage = 0.
        ls_total_veh-percentage = 100.
      ENDIF.
    ELSE.
      ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
      IF sy-subrc = 0.
        READ TABLE lt_workarea_tot INTO ls_workarea_tot  "#EC CI_STDSEQ
           WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
        IF sy-subrc = 0.
          ls_total_veh-percentage = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
          lv_qual_per = lv_qual_per + ls_total_veh-percentage.
        ENDIF.

      ENDIF.
    ENDIF.

*    COLLECT ls_total_veh INTO lt_total_veh.                "#EC COLLECT
    APPEND ls_total_veh TO lt_total_veh.

    COLLECT ls_total_veh INTO lt_total_vehc.               "#EC COLLECT
    CLEAR ls_total_veh.


  ENDLOOP.



  CLEAR : lv_qual_per, lv_last.

  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.

    AT LAST.
      ls_zia_2sf_veh_cost-prozent = 100 - lv_qual_per.
      lv_last = 'X'.
      IF ls_zia_2sf_veh_cost-prozent = 0.
        ls_zia_2sf_veh_cost-prozent = 100.
      ENDIF.

      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
      CLEAR ls_zia_2sf_veh_cost.
    ENDAT.
    IF lv_last IS INITIAL.

      ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
      IF sy-subrc = 0.
        READ TABLE lt_workarea_tot INTO ls_workarea_tot  "#EC CI_STDSEQ
           WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
        IF sy-subrc = 0.
          ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
          lv_qual_per = lv_qual_per + ls_zia_2sf_veh_cost-prozent.
        ENDIF.

      ENDIF.
      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
      CLEAR ls_zia_2sf_veh_cost.

    ENDIF.

  ENDLOOP.

*  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
*    ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
*    IF sy-subrc = 0.
*      READ TABLE lt_workarea_tot INTO ls_workarea_tot    "#EC CI_STDSEQ
*         WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
*      IF sy-subrc = 0.
*        ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
*      ENDIF.
*      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
*      CLEAR ls_zia_2sf_veh_cost.
*
*    ENDIF.
*
*  ENDLOOP.lt_ord_qual.
*adding the missing planned orders in the orderstr table.
  LOOP AT lt_order_original INTO ls_order.


    READ TABLE lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr WITH KEY aufnr = ls_order-aufnr.
    IF sy-subrc NE 0.
      IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
        lv_er_ir = 'ER'. "ER/ IR
      ENDIF.
      IF ls_order-auart = 'N004' .
        lv_er_ir = 'IR'. "ER/ IR
      ENDIF.

      READ TABLE lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr WITH KEY arbeitstellen_id = ls_order-zarbstl
                                                                       er_ir = lv_er_ir
                                                                       accesstype = ls_order-zzzugangsart.
      IF sy-subrc = 0.

*        CLEAR : ls_header1, lt_ret.
*
*        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
*          EXPORTING
*            number    = ls_zia_2sf_orderstr-aufnr
*          IMPORTING
*            es_header = ls_header1
*          TABLES
*            return    = lt_ret.

        ls_zia_2sf_orderstr-aufnr = ls_order-aufnr.

        READ TABLE lt_ord_qual_o INTO ls_ord_qual_o WITH KEY wa_id = ls_order-zarbstl ##WARN_OK
                                                             n004_ord = ls_order-aufnr.
        IF sy-subrc = 0.
          ls_zia_2sf_orderstr-anzahl_qual = ls_ord_qual_o-qual.
        ENDIF.


        APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstrn.
        CLEAR ls_zia_2sf_orderstr.



*moved this before calling program zia_20001_m1
*        wd_assist->update_revision_number( EXPORTING is_order = ls_order
*                                                       iv_revision = ls_header1-revision ).


      ENDIF.

    ENDIF.
  ENDLOOP.

  APPEND LINES OF lt_zia_2sf_orderstrn TO lt_zia_2sf_orderstr. " adding missing orders here.


  LOOP AT lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr.

    CLEAR : ls_header1, lt_ret.

    READ TABLE lt_order_revi INTO ls_order_revi
        WITH KEY pb = ls_zia_2sf_orderstr-maintplngbucketlabel.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-revision = ls_order_revi-revi.
    ENDIF.

    wd_assist->update_revision_number( EXPORTING is_order = ls_order
                                           iv_revision = ls_zia_2sf_orderstr-revision ).

    READ TABLE lt_ord_qual_o INTO ls_ord_qual_o WITH KEY n004_ord = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ##WARN_OK     READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-percentage = ( 100 / lv_tot_wa ) * ( ls_ord_qual_o-qual / ls_wa_qual_tot-wa_count ).

        MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING revision percentage .

      ELSE.
        MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING revision.

      ENDIF.
    ENDIF.

  ENDLOOP.


  CLEAR : lv_qual_per, lv_last.
  LOOP AT lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr.
    DATA(ls_zia_2sf_orderstrl) = ls_zia_2sf_orderstr.
*    AT END OF arbeitstellen_id.
*      ls_zia_2sf_orderstrl-percentage = 100 - lv_qual_per.
*
*      IF ls_zia_2sf_orderstrl-percentage = 0.
*        ls_zia_2sf_orderstrl-percentage = 100.
*      ENDIF.
*      lv_last = 'X'.
**      MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING percentage.
**      CLEAR : ls_zia_2sf_orderstr, lv_qual_per, lv_last.
**      CONTINUE.
*    ENDAT.
    AT LAST.
      ls_zia_2sf_orderstrl-percentage = 100 - lv_qual_per.
      lv_last = 'X'.
    ENDAT.
    IF lv_last = 'X'.

      APPEND ls_zia_2sf_orderstrl TO lt_zia_2sf_orderstrl .

      ls_total_labor-percentage = ls_zia_2sf_orderstrl-percentage.
      ls_total_labor-admin_order = ls_zia_2sf_orderstrl-etap_aufnr.
      COLLECT ls_total_labor INTO lt_total_labor.          "#EC COLLECT
      CLEAR ls_total_labor .
      CLEAR : ls_zia_2sf_orderstr, lv_qual_per, lv_last, ls_zia_2sf_orderstrl.
      CONTINUE.
    ENDIF.

    IF lv_last IS INITIAL.
      lv_qual_per = lv_qual_per + ls_zia_2sf_orderstr-percentage.

    ENDIF.

    APPEND ls_zia_2sf_orderstrl TO lt_zia_2sf_orderstrl .

    ls_total_labor-percentage = ls_zia_2sf_orderstrl-percentage.
    ls_total_labor-admin_order = ls_zia_2sf_orderstrl-etap_aufnr.
    COLLECT ls_total_labor INTO lt_total_labor.            "#EC COLLECT
    CLEAR ls_total_labor .


  ENDLOOP.

  lt_zia_2sf_orderstr[] = lt_zia_2sf_orderstrl[].


*  Populating Setllement rule table

*  BAPI_ALM_ORDER_SRULE
  CLEAR : lv_tot_qual, ls_total_labor.

  LOOP AT lt_total_labor INTO ls_total_labor.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_total_labor-admin_order
      IMPORTING
        output = ls_total_labor-admin_order.


    lv_tot_qual = lv_tot_qual + 1.
    APPEND VALUE #( objnr      = lv_shift_aufnr "Shift Order
                    lfdnr      = lv_tot_qual
                    settl_type = 'PER'"lc_settl_type
                    source     = 'L_3'"mc_src_per              "+>001<
                    orderid    = ls_total_labor-admin_order
                    percentage = ls_total_labor-percentage )
                    TO lt_data.

  ENDLOOP.


  LOOP AT lt_total_vehc INTO ls_total_veh.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_total_veh-admin_order
      IMPORTING
        output = ls_total_veh-admin_order.


    lv_tot_qual = lv_tot_qual + 1.
    APPEND VALUE #( objnr      = lv_shift_aufnr "Shift Order
                    lfdnr      = lv_tot_qual
                    settl_type = 'PER'"lc_settl_type
                    source     = 'I_2'"mc_src_fzg              "+>001<
                    orderid    = ls_total_veh-admin_order
                    percentage = ls_total_veh-percentage )
                    TO lt_data.

  ENDLOOP.

  CLEAR ls_data.

  DATA(lt_methods1) = VALUE  bapi_alm_order_method_t( ).
  DATA(lt_return1)  = VALUE  bapiret2_t( ).


  LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
*      DATA(lv_tabix) = sy-tabix.
    APPEND VALUE #( refnumber  = <ls_data>-lfdnr
                    objecttype = 'SRULE'
                    method     = 'CREATE'
*                    method     = 'CHANGE'
                    objectkey  = lv_shift_aufnr ) TO lt_methods1.

    APPEND VALUE #( refnumber = <ls_data>-lfdnr
                    method    = 'SAVE'
                    objectkey  = lv_shift_aufnr ) TO lt_methods1.

    ls_srule_up-equiv_number = 'X'.
    APPEND ls_srule_up TO lt_srule_up.
  ENDLOOP.

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods1
*     it_header  = lt_header
*     it_header_up = lt_header_up
      it_srule   = lt_data
*     it_srule_up = lt_srule_up
      return     = lt_return1.

  IF NOT line_exists( lt_return1[ type = 'E' ] ) AND
     NOT line_exists( lt_return1[ type = 'A' ] ) AND
     NOT line_exists( lt_return1[ type = 'X' ] ).
*       iv_test_run = abap_false.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*    IF lt_return1 IS NOT INITIAL.                  "#EC EMPTY_IF_BRANCH
**        RAISE EXCEPTION TYPE zcx_io_5_fehler EXPORTING bapiret = lt_return.
*    ENDIF.
  ENDIF.

  wd_assist->modify_settlement_tables( EXPORTING it_zia_2sf_orderstr = lt_zia_2sf_orderstr
                                                 it_zia_2sf_veh_cost = lt_zia_2sf_veh_cost ).



*Updating all planned orders with status.
  LOOP AT lt_order_n004 INTO ls_order.

*      resetting ready for scheduling order status.
    cl_eams_bo_order=>s_get_instance( )->if_eams_bo_order~reset_ready_for_scheduling(
      EXPORTING
        it_ord_id       = VALUE #( ( eams_aufnr = ls_order-aufnr ) )
      IMPORTING
        et_message      = lt_messager
        et_index_failed = lt_index_failed ).

    wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_order-aufnr
                                                      iv_phase = '07'
                                                      iv_subphase = '0065' ).

    CLEAR ls_order.
  ENDLOOP.

*Updating componenets of orders with materials.
  LOOP AT lt_data_mat INTO ls_data_mat .
    CLEAR : lv_txt1, lv_txt2.

    ls_order_comp-aufnr = ls_data_mat-aufnr.
    ls_order_comp-start_datum = ls_schichtdetails-start_datum.
    ls_order_comp-start_zeit = ls_schichtdetails-start_zeit.
    ls_order_comp-reserv_no = ls_data_mat-rsnum.
    ls_order_comp-res_item = ls_data_mat-rspos.
    ls_order_comp-fzg_belad = ls_data_mat-fzg_belad.
    IF ls_order_comp-fzg_belad IS INITIAL.
      READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_order_comp-aufnr.
      IF sy-subrc = 0.
        ##WARN_OK   READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order_original-zarbstl.
        IF sy-subrc = 0.
*            SPLIT ls_wa_details-text AT ls_zia_2plperim-zarbstbez INTO lv_txt1 lv_txt2.
          IF ls_wa_details-text CA '-'.
            SPLIT ls_wa_details-text AT '-' INTO lv_txt1 lv_txt2.
            SPLIT lv_txt2 AT '(' INTO lv_txt1 lv_txt2.
          ELSE.
            SPLIT ls_wa_details-text AT '(' INTO lv_txt1 lv_txt2.
          ENDIF.
          IF lv_txt1 IS NOT INITIAL.
            ls_order_comp-fzg_belad = lv_txt1.
            CONDENSE ls_order_comp-fzg_belad.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    APPEND ls_order_comp TO lt_order_comp.
    CLEAR ls_order_comp.

  ENDLOOP.
  wd_assist->update_components( EXPORTING it_orders = lt_order_comp ).



* Add TFF operations per empty shift.

  LOOP AT lt_wa_details INTO ls_wa_details.
*  to check if there are no orders in the shift.
    ##WARN_OK
    READ TABLE lt_order_original INTO ls_order_original WITH KEY zarbstl = ls_wa_details-wa_id.
    IF sy-subrc NE 0.

* Deleting qualification which are already updated.
      DELETE lt_qual_tff WHERE wa_id NE ls_wa_details-wa_id.

      wd_assist->update_tff_in_shift_order( EXPORTING iv_shift_aufnr = lv_shift_aufnr
                                                      it_qual_tff = lt_qual_tff
                                                      is_schichtdetails = ls_schichtdetails
                                                      iv_maintenanceplanningplant = ls_result-maintenanceplanningplant
                                                      iv_shorttext = lv_shorttext
                                                      iv_steus = lv_steus
                                                      iv_use04 = lv_use04
                                                      iv_usr04 = lv_usr04 ).


    ENDIF.

  ENDLOOP.
* Releasing Shift order
  DATA: lt_methods_so TYPE TABLE OF bapi_alm_order_method,
        ls_method_so  TYPE bapi_alm_order_method,
        lt_return_so  TYPE TABLE OF bapiret2,
  ##NEEDED       ls_return_so  TYPE bapiret2,
  ##NEEDED       lv_aufnr_so   TYPE aufk-aufnr . "VALUE '000001234567'. " Replace with your order number

* 1. Define the method to release the order header
  ls_method_so-refnumber = '1'.
  ls_method_so-objecttype = 'HEADER'.
  ls_method_so-method     = 'RELEASE'.
  ls_method_so-objectkey  = lv_shift_aufnr.
  APPEND ls_method_so TO lt_methods_so.

* 2. Define the save method
  CLEAR ls_method_so.
  ls_method_so-refnumber = '1'.
  ls_method_so-objecttype = ''.
  ls_method_so-method     = 'SAVE'.
  ls_method_so-objectkey  = lv_shift_aufnr.
  APPEND ls_method_so TO lt_methods_so.

* 3. Call the BAPI to process the release and save
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods_so
      return     = lt_return_so.

* 4. Check for errors and commit
  READ TABLE lt_return_so INTO ls_return_so WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

*    changing status of shift admin order.
  wd_assist->update_order_phase_subphase( EXPORTING iv_order = lv_shift_aufnr
                                                              iv_phase = '07'
                                                              iv_subphase = '0065' ).


  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.


*Update priority in Notification

  IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CLEAR lt_return.
*          LS_SCHICHTDETAILS-ZSCHICHT
    DATA : lv_notif    TYPE bapi2080_nothdre-notif_no,
           ls_headern  TYPE bapi2080_nothdri,
           ls_headernx TYPE bapi2080_nothdri_x.
    lv_notif = ls_schichtdetails-zschicht.
    ls_headern-priority = 3.
    ls_headernx-priority = 'X'.

    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
      EXPORTING
        number        = lv_notif
        notifheader   = ls_headern
        notifheader_x = ls_headernx
      TABLES
        return        = lt_return.
    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CLEAR lt_return.
      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number = lv_notif
        TABLES
          return = lt_return.
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      ENDIF.
    ENDIF.
  ENDIF.


ENDMETHOD.