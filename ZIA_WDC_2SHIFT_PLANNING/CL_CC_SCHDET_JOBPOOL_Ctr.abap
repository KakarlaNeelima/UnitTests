class CL_CC_SCHDET_JOBPOOL_Ctr implementation.
 
*=======================
method 
Constructor. "#EC NEEDED
*=======================
" Do NOT modify the Constructor, any changes will not be saved !
 
  Me->Wd_This =    Wd_This.
  Me->Wd_Context = Wd_Context.
  Me->Wd_Comp_Controller = Wd_This->get_ComponentController_Ctr( ).
  Me->Wd_Assist =    Wd_Assist.
endmethod.
 
* +-------------------------------------------------------------------+
* |  general methods                                                  |
* +-------------------------------------------------------------------+

METHOD wddoexit . "#EC NEEDED
ENDMETHOD.

METHOD wddoinit .
  wd_this->gv_distance_nord = `DISTANZ_NORD`.
  wd_this->gv_distance_sued = `DISTANZ_SUED`.

  wd_this->mo_cc_schichtplan = wd_this->get_cc_shichtplan_ctr( ).

  wd_this->init_user_statuses( ).

  wd_this->read_signalabschnitte( ).
ENDMETHOD.

METHOD add_auftrag_to_curr_arbst .
  CHECK io_auftrag IS BOUND.
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  DATA(lo_curr_arbstelle) = wd_comp_controller->mo_curr_arbstelle.

  DATA(lv_aufnr) = io_auftrag->get_data( )-aufnr.

  wd_this->mo_cc_schichtplan->validate_add_auftrag( io_arbeitsstelle = lo_curr_arbstelle
                                                    iv_aufnr         = lv_aufnr ).

  "Sind die Sperrabschnitte vom Auftrag für die Schicht geplant?
  io_auftrag->check_avaiable_sp_schicht( io_schicht = lo_curr_arbstelle->get_schicht( ) ).

  lo_curr_arbstelle->add_auftrag_o( EXPORTING io_order         = io_auftrag
                                              iv_vorschau      = iv_vorschau
                                              iv_ignore_errors = abap_true ).

  IF iv_vorschau = abap_false.
    wd_this->mo_cc_schichtplan->change_auftrag_status( io_arbeitsstelle = lo_curr_arbstelle
                                                       io_auftrag       = io_auftrag ).
  ENDIF.
ENDMETHOD.

METHOD add_selected_auftrags .
  " Define fixed phases for maintenance
  DATA lv_maintordovrlprocphase TYPE eam_ostat_phase." VALUE '06'.
  DATA lv_maintordovrlprocphase_05 TYPE eam_ostat_phase VALUE '05'.
  DATA lv_maintordovrlprocphase_06 TYPE eam_ostat_phase VALUE '06'.
  DATA lv_maintordovrlprocsubphase_60 TYPE eam_ostat_sphase VALUE '0060'.
  DATA lv_maintordovrlprocsubphase_55 TYPE eam_ostat_sphase VALUE '0055'.
  DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase VALUE '0060'.
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  wd_comp_controller->mo_message_manager->reset( ).

  DATA(lt_jobs) = wd_this->get_selected_jobs( iv_aufnr = iv_aufnr ).

  IF lt_jobs[] IS INITIAL.
    MESSAGE w017(zia_2_real) INTO DATA(lv_msg) ##NEEDED.
    wd_comp_controller->mo_message_manager->add_sys_message( ).

  ELSE.
    LOOP AT lt_jobs ASSIGNING FIELD-SYMBOL(<ls_job>).
      CHECK <ls_job>-aufnr IS NOT INITIAL.

      DATA(lo_auftrag) = <ls_job>-object.
      IF lo_auftrag IS NOT BOUND.
        lo_auftrag = wd_this->get_auftrag_from_curr_arbst( <ls_job>-aufnr ).
      ENDIF.
      IF lo_auftrag IS NOT BOUND.
        lo_auftrag = NEW zcl_ia_2order( iv_aufnr = <ls_job>-aufnr ).
      ENDIF.
      CHECK lo_auftrag IS BOUND.

      TRY .
          lo_auftrag->lock( ).
          wd_this->add_auftrag_to_curr_arbst( EXPORTING io_auftrag  = lo_auftrag
                                                        iv_vorschau = abap_false ).
          lo_auftrag->unlock( ).
          "------------------------------------------
          " changing the user status
          DATA(lo_shift) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
          DATA(ls_shift) = lo_shift->get_data( ).
          lo_shift->change_userstatus_by_prio( EXPORTING iv_qmnum = CONV zia_2_workshift( ls_shift-zschicht )
                                                       iv_order = <ls_job>-aufnr ).
          CASE ls_shift-zstatus.
            WHEN zcl_ia_2workshift=>mc_prio_1.
              lv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase_55.
              lv_maintordovrlprocphase = lv_maintordovrlprocphase_05.
            WHEN zcl_ia_2workshift=>mc_prio_2.
              lv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase_60.
              lv_maintordovrlprocphase = lv_maintordovrlprocphase_06.
            WHEN OTHERS.
          ENDCASE.
          zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr                    = <ls_job>-aufnr
                                                     iv_maintordovrlprocphase    = lv_maintordovrlprocphase
                                                     iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
          "-------------------------------------------------
          DATA(lv_save) = abap_true.
          wd_this->z_message_auftrag_added( iv_aufnr = <ls_job>-aufnr ).

        ##NO_HANDLER      CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
          lo_auftrag->unlock( ).
          wd_comp_controller->mo_message_manager->add_bapiret_t( lx_validation_error->gt_bapiret ).
        ##NO_HANDLER       CATCH zcx_ia_2static_check INTO DATA(lx_static_validation) ##NEEDED. "#EC EMPTY_CATCH
        ##NO_HANDLER    CATCH zcx_ia_2failure INTO DATA(lx_error).
          lo_auftrag->unlock( ).
          wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_error->get_bapiret( ) ).
      ENDTRY.
    ENDLOOP.

  ENDIF.

  IF lv_save = abap_true.
    rv_ok = abap_true.
    wd_comp_controller->mo_curr_arbstelle->refresh_ausdehung( ).
    wd_comp_controller->mo_curr_arbstelle->save( ).
    wd_comp_controller->mo_curr_arbstelle->get_schicht( )->reload( ). "+>001<
    wd_comp_controller->mo_curr_arbstelle->get_schicht( )->save( ).
    wd_comp_controller->mo_curr_arbstelle->reload( ). "+>001<

    wd_this->invctx_after_add_auftrag( ).
  ENDIF.

  wd_comp_controller->mo_message_manager->display_messages( ).
  wd_comp_controller->mo_message_manager->reset( ).

ENDMETHOD.

METHOD distance_add .

  DATA(lv_distance) = wd_this->get_distance( iv_field ).
  CHECK lv_distance < wd_this->gv_max_abschnitte.

  lv_distance = lv_distance + 1.

  wd_this->set_distance( iv_field    = iv_field
                         iv_distance = lv_distance ).

  wd_this->invctx_jobpool( ).
ENDMETHOD.

METHOD distance_sub .
  DATA(lv_distance) = wd_this->get_distance( iv_field ).
  CHECK lv_distance > 0.

  lv_distance = lv_distance - 1.

  wd_this->set_distance( iv_field    = iv_field
                         iv_distance = lv_distance ).

  wd_this->invctx_jobpool( ).

ENDMETHOD.

METHOD filter_by_signalabschnitte.

  DATA(lv_distance_nord) = wd_this->get_distance( wd_this->gv_distance_nord ).
  DATA(lv_distance_sued) = wd_this->get_distance( wd_this->gv_distance_sued ).

  " Type-safe FOR ALL ENTRIES: Build aux table with correct tabkey type
  TYPES: BEGIN OF ts_aufnr_key,
           aufnr TYPE eaml_d_lfe_data-tabkey, " Must match tabkey exactly
         END OF ts_aufnr_key.
  DATA: lt_aufnr_key TYPE STANDARD TABLE OF ts_aufnr_key WITH EMPTY KEY.

  LOOP AT ct_jobpool ASSIGNING FIELD-SYMBOL(<ls_jobpool>).
    APPEND VALUE #( aufnr = <ls_jobpool>-aufnr ) TO lt_aufnr_key.
  ENDLOOP.

  IF it_aufk_ext_sp IS INITIAL AND lt_aufnr_key IS NOT INITIAL.
**    SELECT tabkey, z_section
**      FROM eaml_d_lfe_data
**      INTO TABLE @DATA(lt_aufk_ext_sp)
**      FOR ALL ENTRIES IN @lt_aufnr_key
**      WHERE tabkey = @lt_aufnr_key-aufnr.
    ##NEEDED   DATA(lt_aufk_ext_sp) =  wd_assist->get_blocking_section( it_aufnr_key = lt_aufnr_key ) ##NEEDED.
  ENDIF.

  " Get Sperrabschnitte and related signalabschnitte
  DATA: lo_sp_km TYPE REF TO zcl_ia_2_sp_kilometer.
  DATA(ls_zugangsarten) = wd_comp_controller->mo_curr_arbstelle->get_zugangsarten( ).
  DATA(lv_zugangsart)   = COND #( WHEN ls_zugangsarten-schiene = abap_true THEN '1' ELSE '2' ).
  DATA(lt_as_sp)        = wd_comp_controller->mo_curr_arbstelle->get_sperrabschnitte( iv_zugangsart = lv_zugangsart ).
  DATA(ls_sp)           = VALUE #( lt_as_sp[ 1 ] OPTIONAL ).

  lo_sp_km ?= wd_comp_controller->mo_curr_arbstelle->get_sp_kilometer( )->get( key = ls_sp-sperras_id ).

*  IF lo_sp_km IS BOUND.
  CHECK lo_sp_km IS BOUND.

  DATA(lt_sa) = lo_sp_km->get_sa( iv_include_manual = abap_true ).

  IF lt_sa IS NOT INITIAL.

    DATA(ls_sigabsch_min) = lt_sa[ 1 ].
    DATA(ls_sigabsch_max) = lt_sa[ lines( lt_sa ) ].
  ENDIF.

  IF ls_sigabsch_min-zsa IS NOT INITIAL.
    DO lv_distance_nord TIMES.
      ls_sigabsch_min = wd_comp_controller->mo_curr_arbstelle->get_signalabschnitt_prev( ls_sigabsch_min ).
    ENDDO.
  ENDIF.

  IF ls_sigabsch_max-zsa IS NOT INITIAL.
    DO lv_distance_sued TIMES.
      ls_sigabsch_max = wd_comp_controller->mo_curr_arbstelle->get_signalabschnitt_next( ls_sigabsch_max ).
    ENDDO.
  ENDIF.
*  ENDIF.

  LOOP AT ct_jobpool ASSIGNING <ls_jobpool> WHERE zintervall <> 'TS'.

    DATA(lv_auftrag_km_von) = <ls_jobpool>-zzkmvpl.
    DATA(lv_auftrag_km_bis) = <ls_jobpool>-zzkmbpl.

    IF <ls_jobpool>-zstdkz = 'Q' AND
       ( wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w  OR
         wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w1 OR
         wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w2 OR
         wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w3 ).

      CHECK lv_auftrag_km_bis < ls_sigabsch_min-km_von_2
         OR lv_auftrag_km_von > ls_sigabsch_max-km_bis_2.
      DELETE ct_jobpool.

    ELSEIF <ls_jobpool>-zstdkz = 'M'.

      DATA(lo_mfs_auftrag) = NEW zcl_ia_2order( iv_aufnr = <ls_jobpool>-aufnr ).

      IF <ls_jobpool>-zintervall = 'RJ'.
        lv_auftrag_km_von = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) )-zkmin.
        lv_auftrag_km_bis = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) )-zkmax.
      ENDIF.

      IF <ls_jobpool>-zintervall = 'TS'.
        IF <ls_jobpool>-zzest = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ).
          lv_auftrag_km_von = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) )-zkmin.
          lv_auftrag_km_bis = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) )-zkmax.
        ELSE.
          lv_auftrag_km_von = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_ts_est( ) )-zkmin.
          lv_auftrag_km_bis = lo_mfs_auftrag->get_km_by_est( iv_est = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_ts_est( ) )-zkmax.
        ENDIF.
      ENDIF.

      CHECK lv_auftrag_km_bis < ls_sigabsch_min-km_von
         OR lv_auftrag_km_von > ls_sigabsch_max-km_bis.
      DELETE ct_jobpool.
      CLEAR lo_mfs_auftrag.

    ELSEIF <ls_jobpool>-zzest CS 'S' AND
           ( wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w  OR
             wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w1 OR
             wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w2 OR
             wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w3 ).

      DATA(ls_sigabsch_portal) = wd_comp_controller->mo_curr_arbstelle->get_signalabschnitt_next( ls_sigabsch_max ).
      DATA(ls_schicht)         = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_data( ).
      DATA(ls_sigabsch_start) = lt_sa[ lines( lt_sa ) ].

      IF ls_sigabsch_portal = ls_sigabsch_max.
*
*        SELECT * FROM zia_2sc INTO TABLE @DATA(lt_sa_w)
*          WHERE zzperi = @ls_schicht-zzperi AND
*                ( zest = @zif_ia_2_constant=>mc_sperrabs-w  OR
*                  zest = @zif_ia_2_constant=>mc_sperrabs-w1 OR
*                  zest = @zif_ia_2_constant=>mc_sperrabs-w2 OR
*                  zest = @zif_ia_2_constant=>mc_sperrabs-w3 ).
        DATA(lt_sa_w) = wd_assist->get_signalsections1( iv_peri = ls_schicht-zzperi ).

        SORT lt_sa_w BY zsa.                           "#EC CI_SORTLOOP
        DATA(lv_start_ind) = line_index( lt_sa_w[ zsa = ls_sigabsch_start-zsa ] ).
        DATA(lv_end_ind)   = line_index( lt_sa_w[ zsa = ls_sigabsch_max-zsa ] ).

        DATA(lv_sp_count) = lines( lt_sa_w ) ##NEEDED.

        DATA(lv_distance_os) = ( lv_distance_sued + lv_start_ind ) - lv_end_ind.
        IF lv_distance_os > 0.
*          SELECT * FROM zia_2sc INTO TABLE @DATA(lt_sa_os)
*            WHERE zzperi = @ls_schicht-zzperi AND zest = @<ls_jobpool>-zzest.
          DATA(lt_sa_os) =    wd_assist->get_signsections( iv_peri = ls_schicht-zzperi iv_zest = <ls_jobpool>-zzest ).

          SORT lt_sa_os BY zsa.                        "#EC CI_SORTLOOP
          READ TABLE lt_sa_os INTO DATA(ls_sa_max_os) INDEX 1.

          DO lv_distance_os TIMES.
            DATA(lt_sa_rng) = VALUE zia_2spabsch_range_t( ( sign = 'I' option = 'EQ' low = <ls_jobpool>-zzest ) ).
            ls_sa_max_os = wd_comp_controller->mo_curr_arbstelle->get_signalabschnitt_next(
              is_sa     = ls_sa_max_os
              it_sa_rng = lt_sa_rng ).

            DATA(lv_dist_found) = COND abap_bool( WHEN ls_sa_max_os-km_von_3 <= lv_auftrag_km_bis AND
                                                       lv_auftrag_km_bis <= ls_sa_max_os-km_bis_3 THEN abap_true ).
            CHECK lv_dist_found = abap_true.
            EXIT.
          ENDDO.
        ENDIF.
      ENDIF.

      IF lv_dist_found = abap_false.
        DELETE ct_jobpool.
      ENDIF.

    ELSE.

      CHECK lv_auftrag_km_bis < ls_sigabsch_min-km_von
         OR lv_auftrag_km_von > ls_sigabsch_max-km_bis.
      CHECK <ls_jobpool>-zstdkz <> 'O'.
      DELETE ct_jobpool.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD get_aufnr_from_popin .
  DATA(lt_jobpool) = VALUE wd_this->elements_jobpool( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_jobpool )->get_static_attributes_table( IMPORTING table = lt_jobpool ).

  READ TABLE lt_jobpool WITH KEY table_popin = 'TABLEPOPIN' ASSIGNING FIELD-SYMBOL(<ls_jobpool>).
  CHECK <ls_jobpool> IS ASSIGNED.

  rv_aufnr = <ls_jobpool>-aufnr.

ENDMETHOD.

METHOD get_auftrag_from_curr_arbst .
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  ro_auftrag = wd_comp_controller->mo_curr_arbstelle->get_auftrag( iv_key = iv_aufnr ).
ENDMETHOD.

METHOD get_distance.

  DATA:  lv_distance        TYPE i.

  TRY.
      wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_filter
           )->get_child_node( name = wd_this->wdctx_jp_value_filter
           )->get_child_node( name = wd_this->wdctx_jp_filter_icon
           )->get_attribute( EXPORTING name  = iv_field
                             IMPORTING value = lv_distance ).
*      lv_distance = lv_distance_string. " implicit conversion
*      rv_distance = COND i( WHEN lv_distance < 0 THEN 0 ELSE lv_distance ).
*
*    CATCH cx_sy_conversion_error.
*      rv_distance = 0.
*
*  ENDTRY.


      rv_distance = lv_distance.
      rv_distance = COND #( WHEN rv_distance < 0 THEN 0 ELSE rv_distance ).
    CATCH cx_sy_conversion_error.
      rv_distance = 0.
  ENDTRY.

ENDMETHOD.

METHOD get_minmax_signalabschnitte .
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  DATA(ls_arbstelle) = wd_comp_controller->mo_curr_arbstelle->get_data( ).

  LOOP AT wd_this->gt_signalabschnitte ASSIGNING FIELD-SYMBOL(<ls_sa>)
    WHERE zzperi  = wd_this->gv_perimeter
      AND km_von >= ls_arbstelle-zkmin
      AND km_bis <= ls_arbstelle-zkmax.
    IF es_sa_min-zsa IS INITIAL.
      es_sa_min = CORRESPONDING #( <ls_sa> ).
    ENDIF.
    es_sa_max = CORRESPONDING #( <ls_sa> ).
  ENDLOOP.

ENDMETHOD.

METHOD get_os_included .

  DATA: ls_jp_filter_icon TYPE wd_this->element_jp_filter_icon.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
             )->get_child_node( name = wd_this->wdctx_filter
             )->get_child_node( name = wd_this->wdctx_jp_value_filter
             )->get_child_node( name = wd_this->wdctx_jp_filter_icon
             )->get_static_attributes( IMPORTING static_attributes = ls_jp_filter_icon ).

  rv_os_included = ls_jp_filter_icon-os_included.

ENDMETHOD.

METHOD get_selected_jobs .

  DATA(lt_elements) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                               )->get_child_node( name = wd_this->wdctx_jobpool )->get_elements( ).

  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    DATA(ls_jobpool) = VALUE ig_cc_schdet_jobpool=>element_jobpool( ).
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_jobpool ).
    IF iv_aufnr IS INITIAL.
      CHECK ls_jobpool-select_job = abap_true.
    ELSE.
      CHECK ls_jobpool-aufnr = iv_aufnr.
    ENDIF.
    APPEND ls_jobpool TO rt_jobs.
  ENDLOOP.

ENDMETHOD.

METHOD init_user_statuses .
*  wd_this->gv_status_maok = 'maok'.
  wd_this->gv_status_real = 'REAL'.
*  wd_this->gv_status_antl = 'antl'.

  wd_this->gt_status_range_erp = VALUE #(
*  ( sign = 'I' option = 'EQ' low = wd_this->gv_status_maok )
                                          ( sign = 'I' option = 'EQ' low = wd_this->gv_status_real ) ).
ENDMETHOD.

METHOD invctx_after_add_auftrag .

  " invalidate nodes of SCHICHTDETAILS
  wd_comp_controller->invctx_jobpool( ).
  wd_comp_controller->invctx_jobliste( ).
  wd_comp_controller->invctx_fahrzeug( ).
  wd_comp_controller->invctx_sitzplatz( ).
  wd_comp_controller->invctx_arbst_vis( ).
  wd_comp_controller->invctx_details( ).
  wd_comp_controller->invctx_schichtdetails( ).

  " invalidate SCHICHTPLAN
  wd_comp_controller->invctx_schichtplan( ).
ENDMETHOD.

METHOD invctx_jobpool .

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_jobpool )->invalidate( ).

ENDMETHOD.

METHOD nord_distance_add .

  wd_this->distance_add( wd_this->gv_distance_nord ).
*  wd_this->distance_add( wd_this->gv_distance_nord ).

ENDMETHOD.

METHOD nord_distance_sub .

  wd_this->distance_sub( wd_this->gv_distance_nord ).

ENDMETHOD.

METHOD on_popin_jobpool_collapse .

  TRY.
      wd_comp_controller->popin_aufnr_release( ).
      wd_comp_controller->mo_curr_arbstelle->remove_vorschau( ).
    CATCH zcx_ia_2failure INTO DATA(lx_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_error->gt_bapiret ).
  ENDTRY.

  wd_this->popin_collapsed( ).

ENDMETHOD.

METHOD on_popin_jobpool_expand .
  DATA lx_error TYPE REF TO zcx_ia_2failure.

  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  wd_comp_controller->popin_aufnr_release( ).

  zcl_ia_2context_helper=>refresh_popin_jobpool( io_event = io_event ii_context = wd_context ).

  DATA(lv_aufnr) = wd_this->get_aufnr_from_popin( ).
  CHECK lv_aufnr IS NOT INITIAL.

  wd_comp_controller->popin_aufnr_create( lv_aufnr ).
  CHECK wd_comp_controller->mo_jobpool_popin_aufnr IS BOUND.

  TRY.
      wd_comp_controller->mo_curr_arbstelle->remove_vorschau( ).
    CATCH zcx_ia_2failure INTO lx_error.
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_error->gt_bapiret ).
  ENDTRY.

  wd_this->popin_expanded( ).

  TRY .
      add_auftrag_to_curr_arbst( io_auftrag  = wd_comp_controller->mo_jobpool_popin_aufnr
                                 iv_vorschau = abap_true ).
      wd_comp_controller->mo_curr_arbstelle->refresh_ausdehung( ).

    ##NO_HANDLER   CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_validation_error->gt_bapiret ).
    ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_validation) ##NEEDED. "#EC EMPTY_CATCH
    ##NO_HANDLER   CATCH zcx_ia_2failure INTO lx_error.
      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_error->get_bapiret( ) ).
  ENDTRY.

ENDMETHOD.

METHOD on_popin_jobpool_toggle .

  DATA(li_element)     = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(lv_is_expanded) = io_event->get_string( name = 'EXPANDED' ).
  DATA(lv_new_index)   = li_element->get_index( ).

  wd_comp_controller->mo_message_manager->reset( ).

  IF lv_is_expanded EQ abap_true.
    wd_this->on_popin_jobpool_expand( io_event ).
  ELSE.
    wd_this->on_popin_jobpool_collapse( io_event ).
  ENDIF.

  DATA(li_schicht_det_ctx) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails ).
  li_schicht_det_ctx->get_child_node( name = wd_this->wdctx_jobpool )->set_lead_selection_index( index = lv_new_index ).
  li_schicht_det_ctx->get_child_node( name = wd_this->wdctx_fahrzeug )->invalidate( ).
  li_schicht_det_ctx->get_child_node( name = wd_this->wdctx_sitzplatz )->invalidate( ).
  li_schicht_det_ctx->get_child_node( name = wd_this->wdctx_details )->invalidate( ).
  li_schicht_det_ctx->get_child_node( name = wd_this->wdctx_table_popin_jobpool
                   )->get_child_node( name = wd_this->wdctx_jp_popin_detail )->invalidate( ).

ENDMETHOD.

METHOD popin_collapsed .
  " selection chackbox is editable
  wd_this->switch_auftrag_sel_chbox( iv_read_only = abap_false ).
  " button "Auftrag einplanen" is enabled
  wd_this->switch_auftrag_einplanen( iv_enabled = abap_true ).

ENDMETHOD.

METHOD popin_expanded .
  " selection chackbox is Read Only
  wd_this->switch_auftrag_sel_chbox( iv_read_only = abap_true ).
  " button "Auftrag einplanen" is disabled
  wd_this->switch_auftrag_einplanen( iv_enabled = abap_false ).
ENDMETHOD.

METHOD read_signalabschnitte .
**  SELECT zzperi, zsa, lfdnr,
**        km_von, km_bis,
**        km_von_2, km_bis_2,
**        zehb, zest, zspw,
**        zid_joker_1, zid_joker_2,
**        zio_gleis, zio_spa_abf, einfahrtrichtung
**   INTO CORRESPONDING FIELDS OF TABLE @wd_this->gt_signalabschnitte
**   FROM zia_2sc
**   ORDER BY PRIMARY KEY.
  wd_this->gt_signalabschnitte = wd_assist->read_signalabschnitte(  ).
ENDMETHOD.

METHOD remove_auftrag .
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  wd_comp_controller->mo_message_manager->reset( ).

  DATA(lo_auftrag)  = NEW zcl_ia_2order( iv_aufnr = iv_aufnr ).
  CHECK lo_auftrag IS BOUND.

  TRY.
      lo_auftrag->remove_from_jobpool( EXPORTING iv_aufnr           = iv_aufnr
                                                 iv_objnr           = lo_auftrag->get_data( )-objnr
                                                 io_message_manager = wd_comp_controller->mo_message_manager ).
    CATCH zcx_ia_2failure INTO DATA(lx_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      wd_comp_controller->mo_message_manager->reset( ).
  ENDTRY.

  wd_this->invctx_after_add_auftrag( ).


ENDMETHOD.

METHOD set_auftrag_status_s20.

  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_aufnr              dref = REF #( iv_aufnr ) )
                                                                 ( name = zif_ia_2_validator=>mc_param_schicht_status     dref = REF #( zif_ia_2_wrkshft_status=>mc_disposition_released ) )
                                                                 ( name = zif_ia_2_validator=>mc_param_obj_status_str_rng dref = REF #( wd_this->gt_status_range_erp ) )
                                                               ) ).
  wd_comp_controller->mo_message_manager->reset( ).

  TRY.
      zcl_ia_2lib_validation_a=>change_auftrag_jp_status( lo_parameters ).
    ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_check) ##NEEDED. "#EC EMPTY_CATCH
  ENDTRY.

  DATA(lo_auftrag)   = NEW zcl_ia_2order( iv_aufnr = iv_aufnr ).
  DATA(lo_auftraege) = NEW cl_object_map( ).
  lo_auftraege->put( key = lo_auftrag->get_id( ) value = lo_auftrag ).

  zcl_ia_2order_utils=>change_user_status( io_auftraege   = lo_auftraege
                                                io_schicht     = io_arbstl->get_schicht( )
                                                iv_status      = 'PL2'
*                                                iv_status      = wd_this->gv_status_antl
                                                iv_arbzeit_upd = abap_false
                                              ).
  lo_auftrag->set_arbstl_arbeitszeit( io_arbstl  = io_arbstl
                                      iv_save_db = abap_true ).
ENDMETHOD.

METHOD set_distance .
  DATA(lv_distance) = |{ COND int4( WHEN iv_distance < 0 THEN 0 ELSE iv_distance ) }|.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_filter
           )->get_child_node( name = wd_this->wdctx_jp_value_filter
           )->get_child_node( name = wd_this->wdctx_jp_filter_icon
           )->set_attribute( name  = iv_field
                             value = lv_distance ).

ENDMETHOD.

METHOD set_max_abschnitte .
  CHECK wd_this->gv_perimeter IS NOT INITIAL.

  wd_this->gv_max_abschnitte = 0.
  LOOP AT wd_this->gt_signalabschnitte TRANSPORTING NO FIELDS WHERE zzperi = wd_this->gv_perimeter.
    wd_this->gv_max_abschnitte = wd_this->gv_max_abschnitte + 1.
  ENDLOOP.

ENDMETHOD.

METHOD set_perimeter .

  wd_this->gv_perimeter = iv_value.

  wd_this->set_max_abschnitte( ).
ENDMETHOD.

METHOD sued_distance_add .
  wd_this->distance_add( wd_this->gv_distance_sued ).
ENDMETHOD.

METHOD sued_distance_sub .

  wd_this->distance_sub( wd_this->gv_distance_sued ).
ENDMETHOD.

METHOD supply_jobpool .
  DATA(lt_jobpool)        = VALUE wd_this->elements_jobpool( ).
  DATA(ls_date_nav)       = VALUE wd_this->element_date_navigator( ).
  ##NEEDED DATA(ls_date_navigator) = VALUE wd_this->element_date_navigator_gbt( ) ##NEEDED.
  DATA(lt_aufk_ext_sp)    = VALUE eaml_t_lfe_data( ).
  DATA(lt_aufk_ext_sp_split)    = VALUE eaml_t_lfe_data( ).
  DATA(lv_id_btg)         = VALUE zia_2_id_btg( ).

  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator
           )->get_child_node( name = ls_date_nav-last_klicked_calender
           )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_navigator ).

  DATA(lo_arbstelle) = wd_comp_controller->mo_curr_arbstelle.

  DATA(lo_schicht) = lo_arbstelle->get_schicht( ).
  DATA(ls_schicht) = lo_schicht->get_data( ).

  DATA(lv_schicht_start_datum) = ls_schicht-start_datum.
  DATA(lv_schicht_end_datum)   = ls_schicht-end_datum.
  DATA(lv_schicht_start_zeit) = ls_schicht-start_zeit.
  DATA(lv_schicht_end_zeit) = ls_schicht-end_zeit.
  DATA(lv_perim)               = ls_schicht-zzperi.
  ##NEEDED DATA(lt_sp_schicht2)         = lo_schicht->get_sperrabschnitte( ).

  IF lo_arbstelle->is_btg( IMPORTING ev_id_btg = lv_id_btg ).

    lt_jobpool = wd_assist->get_jobpool( iv_id_btg              = lv_id_btg
                                         iv_perim               = lv_perim
                                         iv_schicht_end_datum   = lv_schicht_end_datum
                                         iv_schicht_end_zeit    = lv_schicht_end_zeit
                                         iv_schicht_start_datum = lv_schicht_start_datum
                                         iv_schicht_start_zeit  = lv_schicht_start_zeit ).
  ELSE.

    DATA(lv_id_eiz) = wd_comp_controller->mo_curr_arbstelle->get_data( )-zid_eiz.

    lt_jobpool = wd_assist->get_jobpool(
      iv_mark   = abap_true
      iv_id_eiz = lv_id_eiz
      iv_shift  = ls_schicht-zschicht ).
  ENDIF.

  "*******************
  "* HP HACK
  "***************
  IF wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_ts_est( ) IS INITIAL.
    DELETE lt_jobpool WHERE zintervall = 'TS'.
  ENDIF.
  TYPES: BEGIN OF ts_aufnr_key,
           aufnr TYPE eaml_d_lfe_data-tabkey, " Must match tabkey exactly
         END OF ts_aufnr_key.
  DATA: lt_aufnr_key TYPE STANDARD TABLE OF ts_aufnr_key WITH EMPTY KEY.

  LOOP AT lt_jobpool ASSIGNING FIELD-SYMBOL(<ls_jobpool>).
    APPEND VALUE #( aufnr = <ls_jobpool>-aufnr ) TO lt_aufnr_key.
  ENDLOOP.

  "Sperrabschnitte für die selektieren Aufträge lesen
  IF lt_jobpool IS NOT INITIAL.
    lt_aufk_ext_sp =  wd_assist->get_blocking_section( it_aufnr_key = lt_aufnr_key ).
  ENDIF.

  IF lt_aufk_ext_sp IS NOT INITIAL.
    LOOP AT lt_aufk_ext_sp ASSIGNING FIELD-SYMBOL(<ls_data>).
      SPLIT <ls_data>-z_section AT ',' INTO TABLE DATA(lt_sections).
      LOOP AT lt_sections INTO DATA(lv_section).  "#EC CI_NESTED
        APPEND VALUE #( BASE CORRESPONDING #( <ls_data> )
                        z_section = condense( lv_section ) ) TO lt_aufk_ext_sp_split.
      ENDLOOP.
    ENDLOOP.
    lt_aufk_ext_sp = lt_aufk_ext_sp_split.
  ENDIF.

  LOOP AT lt_jobpool ASSIGNING FIELD-SYMBOL(<ls_tmp>)
    WHERE ( zintervall = 'RJ' OR zintervall = 'RI' OR zintervall = 'JI' )
      AND zstdkz <> 'O'
      AND zzest <> 'X'.
    READ TABLE lt_aufk_ext_sp WITH KEY tabkey = <ls_tmp>-aufnr z_section = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_rj_est( ) TRANSPORTING NO FIELDS. "#EC CI_STDSEQ
    IF syst-subrc <> 0.
      DELETE lt_jobpool WHERE aufnr = <ls_tmp>-aufnr.    "#EC CI_STDSEQ
    ENDIF.
  ENDLOOP.


  IF NOT lo_arbstelle->is_btg( ) AND lo_arbstelle->is_in_tunnel( ).
    wd_this->filter_by_signalabschnitte( CHANGING ct_jobpool = lt_jobpool ).
  ENDIF.

  "Offene Strecke - SAPCBT-912
  IF NOT lo_arbstelle->is_btg( ) AND NOT lo_arbstelle->is_in_tunnel( ).
    DELETE lt_jobpool WHERE zstdkz <> 'O'.
  ENDIF.

  IF wd_this->get_os_included( ) NE abap_true.
    DELETE lt_jobpool WHERE zstdkz = 'O'.
  ENDIF.

*--> Begin Insert >002<
  DATA(lt_sp_schicht) = lo_arbstelle->get_schicht( )->get_sp_schicht( ).
  SORT lt_sp_schicht BY zintervallart.
  DELETE ADJACENT DUPLICATES FROM lt_sp_schicht COMPARING zintervallart.

  DATA(lt_jobpool_orig) = lt_jobpool.
  CLEAR: lt_jobpool.

  LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>).

    DATA(lv_sp_intervallart) = <ls_sp_schicht>-zintervallart.
    DATA(lv_intervallart) = lv_sp_intervallart.

    IF line_exists( lt_jobpool[ zintervall = lv_intervallart ] ).
      CONTINUE.
    ELSE.
      DATA(lt_jobpool_copy) = lt_jobpool_orig.

      DELETE lt_jobpool_copy WHERE zintervall NE lv_intervallart. "#EC CI_STDSEQ
      APPEND LINES OF lt_jobpool_copy TO lt_jobpool.

    ENDIF.

  ENDLOOP.
*--> End Insert >002<

  LOOP AT lt_jobpool ASSIGNING <ls_jobpool>.
    <ls_jobpool>-table_popin = ''.
    <ls_jobpool>-zzest       = zcl_ia_2order=>get_assigned_sperrabs( it_data = lt_aufk_ext_sp iv_aufnr = <ls_jobpool>-aufnr ).
  ENDLOOP.


  node->bind_table( new_items = lt_jobpool set_initial_elements = abap_true ).

ENDMETHOD.

METHOD switch_auftrag_einplanen .

  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
           )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle
           )->set_attribute( name  = `ENA_BTN_JP_AUF_EINPL`
                             value = iv_enabled ).

ENDMETHOD.

METHOD switch_auftrag_sel_chbox .

  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
           )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle
           )->set_attribute( name  = `REA_CKB_JP_SEL_AUFTR`
                             value = iv_read_only ).

ENDMETHOD.

METHOD z_message_auftrag_added .

  TRY .
      DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
      DATA(lv_arbstelle) = wd_comp_controller->mo_curr_arbstelle->get_kurztext( ).
      DATA(lv_schicht_date) = lo_schicht->get_start_timestamp_text( ).

      ##NEEDED     MESSAGE i160(zia_2_mmt) WITH iv_aufnr lv_schicht_date lv_arbstelle INTO DATA(lv_msg).
      wd_comp_controller->mo_message_manager->add_sys_message( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

endclass.
 