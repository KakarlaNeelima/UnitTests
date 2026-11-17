class CL_V_SCHICHTDETAILS_Ctr implementation.
 
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

method WDDOAFTERACTION . "#EC NEEDED
endmethod.

METHOD wddobeforeaction .
  DATA li_api_controller TYPE REF TO if_wd_view_controller.
  DATA li_action         TYPE REF TO if_wd_action.


  li_api_controller = wd_this->wd_get_api( ).
  li_action = li_api_controller->get_current_action( ).

  IF li_action IS NOT BOUND.
    RETURN.
  ENDIF.

  TRY.
      wd_this->mv_action_id = li_action->parameters[ name = 'ID' ]-value.
    CATCH cx_sy_itab_line_not_found.
      CLEAR wd_this->mv_action_id.
  ENDTRY.

ENDMETHOD.

method WDDOEXIT . "#EC NEEDED
endmethod.

METHOD wddoinit .
  DATA: lo_table_joblist TYPE REF TO cl_wd_table,
        lo_table_jobpool TYPE REF TO cl_wd_table,
        lo_view          TYPE REF TO cl_wdr_view.

  wd_this->mo_cc_main_schtab    = wd_this->get_cc_main_schtab_ctr( ).
  wd_this->mo_cc_schdet_arbst   = wd_this->get_cc_schdet_arbst_ctr( ).
  wd_this->mo_cc_schdet_fzeuge  = wd_this->get_cc_schdet_fahrzeuge_ctr( ).
  wd_this->mo_cc_schdet_joblist = wd_this->get_cc_schdet_jobliste_ctr( ).
  wd_this->mo_cc_schdet_jobpool = wd_this->get_cc_schdet_jobpool_ctr( ).
  wd_this->mo_cc_schdet_qualif  = wd_this->get_cc_schdet_qualif_ctr( ).
  wd_this->mo_cc_schdet_main    = wd_this->get_cc_schdet_main_ctr( ).
  wd_this->mo_cc_schdet_mat_table  = wd_this->get_cc_schdet_mat_table_ctr( ).  ">001< +
  wd_this->mo_cc_schdet_fzgref    = wd_this->get_cc_schdet_fzgref_ctr( ).

  wd_comp_controller->mo_view_schichtdetails ?= wd_this->wd_get_api( ).
  " Filter und Sortierung berücksichtigen

  lo_view ?= wd_this->wd_get_api( ).

**Jobliste eingeplante Jobs
  lo_table_joblist ?= lo_view->get_element( 'TAB_EING_JOBS' ).
  wd_comp_controller->mo_jobliste_filter_handle ?= lo_table_joblist->_method_handler.

**Jobpool
  lo_table_jobpool ?= lo_view->get_element( 'TAB_JOBPOOL' ).
  wd_comp_controller->mo_jobpool_filter_handle ?= lo_table_jobpool->_method_handler.

  "New attriubutes needed to store user's action - problem dusring SchichtDetails context validation after each action
  wd_this->mv_is_filter_on_jl = abap_true.
  wd_this->mv_is_filter_on_jp = abap_true.
ENDMETHOD.

METHOD wddomodifyview .
  DATA ls_jp_filter_icon TYPE wd_this->element_jp_filter_icon.
  DATA ls_jl_filter_icon TYPE wd_this->element_jl_filter_icon.
  DATA lo_table          TYPE REF TO cl_wd_table.
  DATA li_jp_node        TYPE REF TO if_wd_context_node.
  DATA li_jl_node        TYPE REF TO if_wd_context_node.

  DATA(li_schichtdetails_node) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails ).
  CHECK li_schichtdetails_node IS BOUND.

  li_jp_node = li_schichtdetails_node->get_child_node( name = wd_this->wdctx_filter
                                    )->get_child_node( name = wd_this->wdctx_jp_value_filter
                                    )->get_child_node( name = wd_this->wdctx_jp_filter_icon ) .

  li_jl_node = li_schichtdetails_node->get_child_node( name = wd_this->wdctx_filter
                                    )->get_child_node( name = wd_this->wdctx_jl_value_filter
                                    )->get_child_node( name = wd_this->wdctx_jl_filter_icon ).

* Find out whether filter is on
  li_jp_node->get_static_attributes( IMPORTING static_attributes = ls_jp_filter_icon ).

** Get reference of the table view element
  lo_table ?= view->get_element( 'TAB_JOBPOOL' ).
*
* Get reference to the Filter & Sorting API
  wd_comp_controller->mo_jobpool_filter_handle ?= lo_table->_method_handler.                                                           " JADE-183  >002< DEL

  wd_comp_controller->mo_jobpool_filter_handle->apply_filter( ).
  wd_comp_controller->mo_jobpool_filter_handle->apply_sorting( ).     " JADE-183  >002< INS

  "&------------------------------------------------------------------------*
  " Code for FILTER Jobliste Eingeplante Jobs
  "&------------------------------------------------------------------------*

  li_jl_node->get_static_attributes( IMPORTING static_attributes = ls_jl_filter_icon ).

  "Problem during SchichtDetails context validation after each action ls_jl_filter_icon is overwritten - we want to hold the user's action
  wd_this->mv_is_filter_on_jl = COND #( WHEN wd_this->mv_action_id = 'SWITCH_FILTER_JOBLIST' THEN ls_jl_filter_icon-is_filter_on_jobliste
                                        ELSE wd_this->mv_is_filter_on_jl ).
  ls_jl_filter_icon-is_filter_on_jobliste = wd_this->mv_is_filter_on_jl.

** Get reference of the table view element
  lo_table ?= view->get_element( 'TAB_EING_JOBS' ).
*
* Get reference to the Filter & Sorting API
  wd_comp_controller->mo_jobliste_filter_handle ?= lo_table->_method_handler.

* Set or cancel the table's filter action
  IF ls_jl_filter_icon-is_filter_on_jobliste = abap_true.
    lo_table->set_on_filter( 'JOBLISTE_FILTER' ).  "set Action
  ELSE.
    lo_table->set_on_filter( '' ).
    DATA(lv_aufnr) = wd_this->joblist_get_selected_aufnr( ). " Get AUFNR for Lead Selection
    wd_comp_controller->mo_jobliste_filter_handle->apply_filter( )."nochmals ausführen
    wd_this->joblist_set_ls_by_aufnr( lv_aufnr ). " Restore Lead Selection for AUFNR if possible
  ENDIF.

  li_jl_node->set_static_attributes( EXPORTING static_attributes = ls_jl_filter_icon ).
  li_jp_node->set_static_attributes( EXPORTING static_attributes = ls_jp_filter_icon ).
  CLEAR wd_this->mv_action_id.

  "kilometer intervals update begin
  DATA: lt_sp_details  TYPE wd_comp_controller->elements_sp_details,
        lt_sp_ehb      TYPE wd_comp_controller->elements_sp_ehb_filtered,
        ls_sp_ehb_line LIKE LINE OF lt_sp_ehb.

**--> Begin Insert >001<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "For testing

    DATA(li_nd_sp_details) = wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
       )->get_child_node( name = wd_comp_controller->wdctx_details
       )->get_child_node( name = wd_comp_controller->wdctx_sp_details
       ).

    DATA(lv_lead_index) = li_nd_sp_details->get_lead_selection_index( ).

    wd_comp_controller->mo_curr_arbstelle->get_sp_details_wd( IMPORTING et_sp_ehb     = lt_sp_ehb
                                                               CHANGING          ct_sp_details = lt_sp_details ).

    wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
       )->get_child_node( name = wd_comp_controller->wdctx_details
       )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb
       )->bind_table( EXPORTING new_items = lt_sp_ehb set_initial_elements = abap_true  ).

    li_nd_sp_details->bind_table( EXPORTING new_items = lt_sp_details set_initial_elements = abap_true  ).

    li_nd_sp_details->set_lead_selection_index( lv_lead_index ).

  ELSE.


    wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
   )->get_child_node( name = wd_comp_controller->wdctx_details
   )->get_child_node( name = wd_comp_controller->wdctx_sp_details
   )->get_static_attributes_table( IMPORTING table = lt_sp_details ).

    wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
       )->get_child_node( name = wd_comp_controller->wdctx_details
       )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered
       )->get_static_attributes_table( IMPORTING table = lt_sp_ehb ).

*    SELECT SINGLE * FROM zia_2sf_wa INTO @DATA(ls_arb)
*  WHERE zarbstl = @wd_comp_controller->mo_curr_arbstelle->gs_arbeitsstelle-zarbstl.
    DATA(ls_arb) =   wd_assist->get_workplaces( iv_arbstl = wd_comp_controller->mo_curr_arbstelle->gs_arbeitsstelle-zarbstl  ).

    DATA(lt_sp_shicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_sp_schicht( ).
    DATA(ls_sp_shicht) = VALUE #( lt_sp_shicht[ 1 ] OPTIONAL ).

*    SELECT * FROM zia_2sf_sc_usr INTO TABLE @DATA(lt_user_added)
*    WHERE sperras_id = @ls_sp_shicht-sperras_id AND zschicht = @ls_sp_shicht-zschicht

    DATA(lt_user_added) = wd_assist->get_sig_sections( iv_sperras_id = ls_sp_shicht-sperras_id
                                                         iv_shift = ls_sp_shicht-zschicht ).

    LOOP AT lt_user_added[] ASSIGNING FIELD-SYMBOL(<ls_user_added>).
      MOVE-CORRESPONDING <ls_user_added> TO ls_sp_ehb_line.
      APPEND ls_sp_ehb_line TO lt_sp_ehb[].
    ENDLOOP.

    SORT lt_sp_ehb[] BY zsa ASCENDING.
    LOOP AT lt_sp_ehb[] ASSIGNING FIELD-SYMBOL(<ls_sp_ehb>).
      DATA(lv_index) = sy-tabix.
      IF lv_index = 1.
        DATA(lv_ehb_min) = |{ <ls_sp_ehb>-zsa ALPHA = OUT }| && |/ | && |{ <ls_sp_ehb>-zehb ALPHA = OUT }|. "#EC TEXT_ASSEMBLY
      ELSEIF lv_index = lines( lt_sp_ehb[] ).
        DATA(lv_ehb_max) = |{ <ls_sp_ehb>-zsa ALPHA = OUT }| && |/ | && |{ <ls_sp_ehb>-zehb ALPHA = OUT }|. "#EC TEXT_ASSEMBLY
      ENDIF.
    ENDLOOP.

    READ TABLE lt_sp_details[] ASSIGNING FIELD-SYMBOL(<ls_sp_details>) INDEX 1.
    IF <ls_sp_details> IS ASSIGNED.
      <ls_sp_details>-sp_kilometer = |KM: | && ls_arb-zkmin && | - | && ls_arb-zkmax. "#EC TEXT_ASSEMBLY
      IF lv_ehb_min IS NOT INITIAL AND lv_ehb_max IS NOT INITIAL.
        <ls_sp_details>-sp_sigabs_ehb = |Signalabschn./EHB: | && lv_ehb_min && |- | && lv_ehb_max. "#EC TEXT_ASSEMBLY
      ENDIF.
      wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
       )->get_child_node( name = wd_comp_controller->wdctx_details
       )->get_child_node( name = wd_comp_controller->wdctx_sp_details
       )->bind_table( EXPORTING new_items = lt_sp_details set_initial_elements = abap_true  ).
    ENDIF.

  ENDIF. "+>001<
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

method CLOSE_EMPTY_SCHICHT .
    DATA(lo_schicht) = wd_this->get_schicht( ).
  CHECK lo_schicht->is_empty( ).

  wd_this->mo_cc_main_schtab->close_tab_schicht( lo_schicht ).

  wd_this->fire_to_planungscockpit_plg( ).
endmethod.

METHOD download_zip .
  "Get the binary stream for ZIP file
  DATA(lv_zip_xstring) = wd_comp_controller->mo_zip->save( ).
  DATA:ls_schichtdetails   TYPE wd_this->element_schichtdetails.
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  "Zip File als Download bereitstellen
  cl_wd_runtime_services=>attach_file_to_response(
    EXPORTING
      i_filename      = |{ sy-sysid }_:{ ls_schichtdetails-object->get_data( )-zzperi }_:{ ls_schichtdetails-object->get_data( )-start_datum }:{ ls_schichtdetails-object->get_data( )-start_zeit(4) }.zip|
      i_content       = lv_zip_xstring
      i_mime_type     = 'application/zip'
  ).

ENDMETHOD.

METHOD get_aufnr_from_ctx_elem .

  DATA(ls_attributes) = VALUE zia_2_visorder_wd_s( ).

  TRY .
      DATA(li_element) = io_wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
      li_element->get_static_attributes( IMPORTING static_attributes = ls_attributes ).

      rv_value = ls_attributes-aufnr.

    ##NO_HANDLER   CATCH cx_no_check.
  ENDTRY.
ENDMETHOD.

METHOD get_comp_popup_ez_formation .
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_ez_formation( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  ri_component = wd_this->wd_cpifc_popup_ez_formation( ).
ENDMETHOD.

METHOD get_schicht .
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name = `OBJECT` IMPORTING value = ro_schicht ).
ENDMETHOD.

METHOD get_sitzplatz_from_ctx_elem .

  TRY .
      DATA(ls_sitzplatz) = VALUE zia_2_visquali_wd_s( ).
      DATA(li_element) = io_wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
      li_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).

      ro_instance = ls_sitzplatz-object.

    ##NO_HANDLER   CATCH cx_no_check.
  ENDTRY.

ENDMETHOD.

METHOD joblist_get_selected_aufnr .
  TRY .
      DATA(ls_joblist) = VALUE wd_this->element_jobliste( ).
      DATA(li_node_schichtdetail) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails ).
      DATA(li_node_joblist) = li_node_schichtdetail->get_child_node( name = wd_this->wdctx_jobliste ).
      DATA(li_elem_joblist) = li_node_joblist->get_lead_selection( ).
      IF li_elem_joblist IS BOUND.
        li_elem_joblist->get_static_attributes( IMPORTING static_attributes = ls_joblist ).
        rv_value = ls_joblist-aufnr.
      ENDIF.
    ##NO_HANDLER   CATCH cx_no_check INTO DATA(lx_error) ##NEEDED.
  ENDTRY.
ENDMETHOD.

METHOD joblist_set_ls_by_aufnr .
  CHECK iv_aufnr IS NOT INITIAL.

  DATA(lt_jobliste) = VALUE wd_this->elements_jobliste( ).

  TRY .
      DATA(li_node_schichtdetail) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails ).
      DATA(li_node_jobliste) = li_node_schichtdetail->get_child_node( name = wd_this->wdctx_jobliste ).
      li_node_jobliste->get_static_attributes_table( IMPORTING table = lt_jobliste ).
    ##NO_HANDLER   CATCH cx_no_check.
  ENDTRY.

  LOOP AT lt_jobliste REFERENCE INTO DATA(ld_jobliste) WHERE aufnr = iv_aufnr ##NEEDED.
    DATA(lv_lead_selection_index) = sy-tabix.
    li_node_jobliste->set_lead_selection_index( index = lv_lead_selection_index ).
  ENDLOOP.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

method HANDLEDETAILS_IN . "#EC NEEDED
endmethod.

method ONACTIONADD_FAHRZEUGE .
   wd_this->mo_cc_schdet_fzeuge->check_add_fahrzeuge( ).
endmethod.

method ONACTIONBTN_AS_EDIT .
  wd_this->mo_cc_schdet_arbst->switch_arbeitsstelle_edit( ).
endmethod.

METHOD onactioncheck_status_change .
  wd_comp_controller->set_current_event( wdevent ).

***  DATA(lv_status) = wd_comp_controller->get_string_from_curr_event( 'STEP' ).
***  IF lv_status = 'S30'."Shift Released
***    DATA(lv_has_error) = wd_comp_controller->check_shift_release( ).
***    IF lv_has_error IS NOT INITIAL.
***      RETURN.
***    ELSE.
****    IF syst-uname = 'E564128' OR syst-uname = 'E541515' ##USER_OK.
***        wd_comp_controller->save_shift_release(  ).
****      ENDIF.
***      RETURN.
***    ENDIF.
***  ENDIF.

  MESSAGE s021(zia_2_real)
     WITH zcl_ia_2utils_wd_a=>get_domain_value_text( iv_dtel  = VALUE zia_2_shift_status( )
                                                        iv_value = CONV #( wdevent->get_string( 'STEP' ) ) )
     INTO DATA(lv_status_question).

  wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                          iv_button_kind  = if_wd_window=>co_buttons_yesno
                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFT_STATUS_CHANGE' )
                                          it_text         = VALUE #( ( lv_status_question ) )
                                          iv_btn1_action  = `STATUS_CONFIRM`
                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/CONFIRM' )
                                          iv_btn1_type    = if_wd_window=>co_button_yes
                                          iv_btn2_action  = `STATUS_CANCEL`
                                          iv_btn2_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/CANCEL' )
                                          iv_btn2_type    = if_wd_window=>co_button_no
                                          ).
ENDMETHOD.

METHOD onactionclose .
  DATA: lt_sp_ehb_user      TYPE wd_comp_controller->elements_sp_ehb_filtered,
 ##NEEDED       lt_sp_ehb_in        TYPE wd_comp_controller->elements_sp_ehb,
        lt_wdctx_arbstellen TYPE wd_comp_controller->elements_arbstellen,
        lv_zarbstl TYPE zia_2_id_arbstl.

  wd_comp_controller->mo_curr_arbstelle->get_sp_details_wd( IMPORTING et_sp_ehb = lt_sp_ehb_in ).
  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
   )->get_child_node( name = wd_comp_controller->wdctx_details
   )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb_user ).

  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtplan
   )->get_child_node( name = wd_comp_controller->wdctx_arbstellen )->get_static_attributes_table( IMPORTING table = lt_wdctx_arbstellen ).


  LOOP AT lt_wdctx_arbstellen ASSIGNING FIELD-SYMBOL(<ls_wdctx_arbstellen>) WHERE tooltip IS NOT INITIAL.
    DATA: lv_off TYPE i,
          lv_len TYPE i.

    FIND REGEX '\d{12}' IN <ls_wdctx_arbstellen>-tooltip
       MATCH OFFSET lv_off
       MATCH LENGTH lv_len.

    IF sy-subrc = 0.


      lv_zarbstl = <ls_wdctx_arbstellen>-tooltip+lv_off(lv_len).
*      SELECT SINGLE * FROM zia_2sf_wa INTO @DATA(ls_arb)
*      WHERE zarbstl = @<ls_wdctx_arbstellen>-tooltip+lv_off(lv_len).
      DATA(ls_arb) =   wd_assist->get_workplaces( iv_arbstl = lv_zarbstl ).

      IF sy-subrc  = 0.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  LOOP AT lt_sp_ehb_user[] ASSIGNING FIELD-SYMBOL(<ls_user_line>).
    DATA(lv_index) = sy-tabix.
    IF lv_index = 1.
      ls_arb-zkmin = <ls_user_line>-km_von.
    ENDIF."+>002<
    IF lv_index = lines( lt_sp_ehb_user[] ). "Change >002<
      ls_arb-zkmax = <ls_user_line>-km_bis.
    ENDIF.

  ENDLOOP.

*--> Begin Insert >002<
  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
  DATA(lo_arbstelle) = lo_schicht->get_arbeitsstelle_by_id( ls_arb-zarbstl ).

  lo_arbstelle->set_zkmin( ls_arb-zkmin ).
  lo_arbstelle->set_zkmax( ls_arb-zkmax ).
  wd_comp_controller->mo_curr_arbstelle = lo_arbstelle.

  lo_schicht->save( ).
  lo_schicht->reload( ).
*--> End Insert >002<

  wd_comp_controller->mo_current_popup->close( ).

ENDMETHOD.

METHOD onactiondelete_arbstelle .
  wd_this->mo_cc_schdet_arbst->delete_curr_arbstelle( ).
ENDMETHOD.

method ONACTIONDOWNLOAD_DB . "#EC NEEDED
endmethod.

METHOD onactiondrop_on_sitzplatz .
  DATA li_target_sitzplatz_elem TYPE REF TO if_wd_context_element.

  DATA(li_dd_flavor) = zcl_ia_2utils_wd_a=>get_flavor_from_event( wdevent ).

  TRY .
      CASE li_dd_flavor->gv_name.

        WHEN zif_ia_2_wd_indiv_capacity=>mc_dd_flavor_move.
          DATA(lv_source_einzelkapa_id) = CONV zia_2_id_einzelkapa( wdevent->get_string( `DATA` ) ).
          li_target_sitzplatz_elem = wdevent->get_context_element( `CONTEXT_ELEMENT` ).

          wd_this->mo_cc_schdet_qualif->move_einzelkapa_to_sitzplatz( iv_einzelkapa_id     = lv_source_einzelkapa_id
                                                                      io_sitzplatz_element = li_target_sitzplatz_elem ).

        WHEN zif_ia_2_wd_qualification=>mc_dd_flavor_move.
          DATA(lv_source_sitzplatz_id) = CONV zia_2_id_fzg_platz( wdevent->get_string( `DATA` ) ).
          li_target_sitzplatz_elem = wdevent->get_context_element( `CONTEXT_ELEMENT` ).

          wd_this->mo_cc_schdet_qualif->move_qualif_to_sitzplatz( iv_source_sitzplatz_id   = lv_source_sitzplatz_id
                                                                  io_target_sitzplatz_elem = li_target_sitzplatz_elem ).

      ENDCASE.

    ##NO_HANDLER CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD onactionexport_jobliste .

  TRY.
      wd_this->mo_cc_schdet_joblist->export_to_xls( ).
    ##NO_HANDLER   CATCH zcx_excel.
  ENDTRY.

ENDMETHOD.

method ONACTIONGET_ZIP_AS_RESPONSE .
   wd_this->download_zip( ).
endmethod.

METHOD onactionjobliste_filter .
  wd_comp_controller->mo_jobliste_filter_handle->apply_filter( ).
ENDMETHOD.

METHOD onactionjobliste_lead_select .
  DATA(lv_aufnr) = wd_this->joblist_get_selected_aufnr( ).
  zcl_ia_2context_helper=>mark_einzelkapas_by_aufnr( ii_context = wd_context
                                                      iv_aufnr   = lv_aufnr
                                                      iv_image   = zif_ia_2_wd_indiv_capacity=>mc_image_selected ).

ENDMETHOD.

method ONACTIONJOBPOOL_FILTER .
wd_comp_controller->mo_jobpool_filter_handle->apply_filter( ).
endmethod.

method ONACTIONJP_AUFTR_EINPLANEN .
   wd_this->mo_cc_schdet_jobpool->add_selected_auftrags( ).
endmethod.

METHOD onactionnord_distance_add .
  wd_this->mo_cc_schdet_jobpool->nord_distance_add( ).
ENDMETHOD.

METHOD onactionnord_distance_sub .
  wd_this->mo_cc_schdet_jobpool->nord_distance_sub( ).
ENDMETHOD.

METHOD onactionon_check_shift_rel.

  DATA lt_bapiret TYPE bapiret2_t.

  DATA(lv_has_error) = wd_comp_controller->check_shift_release( ).
  IF lv_has_error IS INITIAL.
    MESSAGE s565(zia_2_real) INTO DATA(lv_message).
    INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_bapiret INDEX 1.
    wd_comp_controller->mo_message_manager->add_bapiret_t( lt_bapiret ).
    wd_comp_controller->mo_message_manager->display_messages( ).
  ENDIF.

ENDMETHOD.

METHOD onactionon_drop_fahrzeuge .
  DATA li_target_fzg_el TYPE REF TO if_wd_context_element.


  DATA(li_dd_flavor) = zcl_ia_2utils_wd_a=>get_flavor_from_event( wdevent ).
  TRY .
      CASE li_dd_flavor->gv_name.
        WHEN zif_ia_2_wd_mat_table=>mc_dd_flavor_move.
          DATA(lv_mat_path) = CONV string( wdevent->get_string( `DATA` ) ).
          li_target_fzg_el  = wdevent->get_context_element( `CONTEXT_ELEMENT` ).
          wd_this->mo_cc_schdet_fzeuge->move_material_to_fahrzeug( io_fzg_element = li_target_fzg_el iv_mat_path = lv_mat_path ).
      ENDCASE.
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

method ONACTIONON_MAT_TABLE .
   wd_this->mo_cc_schdet_mat_table->process_event( wdevent ).
endmethod.

method ONACTIONON_SORT_JOBLIST .
  wd_comp_controller->mo_jobliste_filter_handle->apply_sorting( ).
endmethod.

METHOD onactionon_sort_jobpool .
  wd_comp_controller->mo_jobpool_filter_handle->apply_sorting( ).
ENDMETHOD.

METHOD onactionopen_reiloscope .
  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).

  DATA(li_railoscope) = zcl_ia_2railoscope=>get_instance( io_schicht = lo_schicht ).

  DATA(lv_url) = li_railoscope->get_url( ).
  IF lv_url IS INITIAL.
    ##NEEDED   MESSAGE e024(zia_2_real) INTO DATA(lv_msg).
    wd_comp_controller->mo_message_manager->display_sys_message( ).
    RETURN.
  ENDIF.

  DATA(li_component_api) = wd_comp_controller->wd_get_api( ).
  DATA(li_window_manager) = li_component_api->get_window_manager( ).

  DATA(li_window) = li_window_manager->create_external_window( url            = lv_url
                                                               modal          = abap_false
                                                               has_menubar    = abap_true
                                                               is_resizable   = abap_true
                                                               has_scrollbars = abap_true
                                                               has_statusbar  = abap_true
                                                               has_toolbar    = abap_true
                                                               has_location   = abap_true
                                                               use_post       = abap_true ).

  li_window->open( ).

ENDMETHOD.

METHOD onactionorientation_selected .
  DATA(li_fahrzeug_elem) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(lv_orient_index)  = wdevent->get_int( name = 'INDEX' ).

  wd_this->mo_cc_schdet_fzeuge->set_orientation_of_fahrzeug( io_fahrzeug_elem = li_fahrzeug_elem
                                                             iv_orient_index  = lv_orient_index ).

ENDMETHOD.

METHOD onactionos_include .
  wd_this->mo_cc_schdet_jobpool->invctx_jobpool( ).

ENDMETHOD.

method ONACTIONPOPIN_JOBPOOL_TOGGLE .
    wd_this->mo_cc_schdet_jobpool->on_popin_jobpool_toggle( wdevent ).
endmethod.

METHOD onactionpopup_add_fahrzeuge .
  IF wd_comp_controller->mo_curr_arbstelle->is_pneu( ).
    ##NEEDED   MESSAGE e340(zia_2_real) INTO DATA(lv_err_is_pneu).
    wd_comp_controller->mo_message_manager->add_message( ).
    RETURN.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_fahrzeug_type_count )->invalidate( ).

  wd_comp_controller->open_window_in_popup( io_view_controller = wd_this->wd_get_api( )
                                            iv_window_name     = 'W_POPUP_ADD_FZ'
                                            iv_title           = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/ADD_VEHICLE' )
                                            iv_action_name     = 'ADD_FAHRZEUGE' ).
ENDMETHOD.

METHOD onactionpopup_del_arbstelle .
  DATA: lv_text         TYPE string,
        lv_popup_height TYPE string,
        lv_popup_width  TYPE string,
        lt_bapiret      TYPE bapiret2_t,
        lt_msg          TYPE bapiret2_t.

  DATA(lo_schicht) = wd_this->get_schicht( ).
  DATA(lt_aufnr) = CAST cl_object_map( lo_schicht->get_auftraege( ) )->get_keys( ).
  TRY.
      LOOP AT lt_aufnr ASSIGNING FIELD-SYMBOL(<lv_aufnr>).

        wd_comp_controller->mo_curr_arbstelle->check_lock_orders(
                EXPORTING
                  iv_aufnr = |{ <lv_aufnr> ALPHA = IN }|
                IMPORTING
                  et_bapiret = lt_bapiret                 " Return Parameter
              ).
        APPEND LINES OF lt_bapiret TO lt_msg.
        CLEAR lt_bapiret.
      ENDLOOP.

      IF lt_msg IS INITIAL.

        DATA(lt_message) = VALUE string_table( ( cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/DELETE_JOB_TEXT` ) ) ).
      ELSE.
        RAISE EXCEPTION TYPE zcx_ia_2failure
          EXPORTING
            gt_bapiret = lt_msg.
      ENDIF.
*--> Begin Insert >001<

      DATA(lo_curr_arbstelle) = wd_comp_controller->mo_curr_arbstelle.

      IF lo_schicht->is_versorgung_schicht( ) AND
        lo_curr_arbstelle->are_vehicles_referenced( ).

        lv_text = cl_abap_char_utilities=>newline.
        APPEND lv_text TO lt_message.

        lv_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_JOB_POSITION_REF_TEXT' ).
        APPEND lv_text TO lt_message.
        lv_popup_width  =  '550px'.

      ENDIF.

      wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                              iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                              iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DELETE_WORKAREA' )
                                              it_text         = lt_message
                                              iv_btn1_action  = `DELETE_ARBSTELLE`
                                              iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DELETE' )
                                              iv_btn1_type    = if_wd_window=>co_button_ok
                                              iv_close_button = abap_true
                                              iv_height       = lv_popup_height
                                              iv_width        = lv_popup_width
                                            ).
    CATCH zcx_ia_2failure INTO DATA(lx_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      wd_comp_controller->mo_message_manager->reset( ).
  ENDTRY.

ENDMETHOD.

METHOD onactionpopup_ez_formation .
  DATA(li_popup_ez_formation) = wd_this->get_comp_popup_ez_formation( ).

  DATA(lo_schicht) = wd_this->get_schicht( ).

  li_popup_ez_formation->open( lo_schicht ).
ENDMETHOD.

METHOD onactionpopup_fahrplan .
  DATA(lo_schicht) = wd_this->get_schicht( ).

  wd_this->mo_cc_schdet_main->open_popup_fahrplan( io_schicht = lo_schicht ).

ENDMETHOD.

METHOD onactionpopup_qualification .
  wd_this->mo_cc_schdet_qualif->open_popup_qualification( ).
ENDMETHOD.

METHOD onactionpopup_rem_fahrzeug .
  DATA(lt_string)       = VALUE string_table( ).   ">001< +
  DATA(lv_popup_height) = VALUE string( ).
  DATA(lv_popup_width)  = VALUE string( ).

  IF wd_comp_controller->mo_curr_arbstelle->is_pneu( ).
    ##NEEDED   MESSAGE e140(zia_2_mmt) INTO DATA(lv_err_is_pneu).
    wd_comp_controller->mo_message_manager->add_message( ).
    RETURN.
  ENDIF.

  DATA(lt_fahrzeuge) = VALUE wd_this->elements_fahrzeug( ).

  wd_context->get_child_node( wd_this->wdctx_schichtdetails
           )->get_child_node( wd_this->wdctx_fahrzeug
           )->get_static_attributes_table( IMPORTING table = lt_fahrzeuge ).
  READ TABLE lt_fahrzeuge REFERENCE INTO DATA(ld_fahrzeuge) WITH KEY auswahl = abap_true.
  CHECK ld_fahrzeuge IS BOUND.

  DATA(lv_text) = COND string( WHEN ld_fahrzeuge->object->is_basis_fz_os( )
                               THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_VEH_OS_TXT' )
                               ELSE cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_VEHICLE_TXT' ) ).
  ">001< + begin
  APPEND lv_text TO lt_string.
  IF ld_fahrzeuge->object->is_referenced( ).

    lv_text = cl_abap_char_utilities=>newline.
    APPEND lv_text TO lt_string.

    lv_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_VEHICLE_REF_TXT' ).
    APPEND lv_text TO lt_string.
*
*    lv_text = cl_abap_char_utilities=>newline.
*    APPEND lv_text TO lt_string.
*
*    lv_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_VEHICLE_REF_TXT_CONT' ).
*    APPEND lv_text TO lt_string.

    lv_popup_width  =  '550px'.
  ENDIF.
  ">001< + end
  wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_VEHICLE' )
                                          it_text         = lt_string  ">001< +
                                          iv_btn1_action  = `REMOVE_FAHRZEUG`
                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE' )
                                          iv_btn1_type    = if_wd_window=>co_button_ok
                                          iv_close_button = abap_true
                                          iv_height       = lv_popup_height  ">001< +
                                          iv_width        = lv_popup_width   ">001< +
                                          ).
ENDMETHOD.

METHOD onactionpopup_rem_qualifs .
  CHECK zcl_ia_2context_helper=>is_ready_to_remove_qualifs( wd_context ).

  wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_QUALIFICATIONS' )
                                          it_text         = VALUE #( ( cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_SELECTED_QUALIFICATIONS' ) ) )
                                          iv_btn1_action  = `REMOVE_QUALIFS`
                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE' )
                                          iv_btn1_type    = if_wd_window=>co_button_ok
                                          iv_close_button = abap_true
                                        ).
ENDMETHOD.

METHOD onactionprocess_event .
  wd_comp_controller->z_pe_schichtdetails( io_event = wdevent ).
ENDMETHOD.

METHOD onactionreihung_selected .
  DATA(li_fahrzeug_elem) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(lv_reihung_index) = wdevent->get_int( name = 'INDEX' ).

  wd_this->mo_cc_schdet_fzeuge->set_reihung_to_fahrzeug( io_fahrzeug_elem = li_fahrzeug_elem
                                                         iv_reihung_index = lv_reihung_index ).

ENDMETHOD.

METHOD onactionremove_fahrzeug .
  DATA(lt_fahrzeuge) = VALUE wd_this->elements_fahrzeug( ).

  wd_context->get_child_node( wd_this->wdctx_schichtdetails
           )->get_child_node( wd_this->wdctx_fahrzeug
           )->get_static_attributes_table( IMPORTING table = lt_fahrzeuge ).
*  READ TABLE lt_fahrzeuge REFERENCE INTO DATA(ld_fahrzeuge) WITH KEY auswahl = abap_true.
  LOOP AT lt_fahrzeuge REFERENCE INTO DATA(ld_fahrzeuge) WHERE auswahl = abap_true.
    CHECK ld_fahrzeuge IS BOUND.
    TRY.
        ld_fahrzeuge->object->lock( iv_check = abap_true ).
        ld_fahrzeuge->object->unlock( ).
        ld_fahrzeuge->object->unlock_subobjects( ).
        ld_fahrzeuge->object->remove_material_all( ). ">001< +
        wd_comp_controller->mo_curr_arbstelle->remove_fahrzeug( io_fahrzeug = ld_fahrzeuge->object ).

        IF wd_comp_controller->mo_curr_arbstelle->get_schicht( ) IS BOUND.
          " Arbeitsstelle still in the Shift
          wd_comp_controller->mo_curr_arbstelle->save( ).
        ELSE.
          " Arbeitsstelle has been removed from the Shift
          CLEAR wd_comp_controller->mo_curr_arbstelle.
        ENDIF.

      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        wd_comp_controller->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
    ENDTRY.
  ENDLOOP.

  wd_comp_controller->invctx_fahrzeug( ).
  wd_comp_controller->invctx_sitzplatz( ).
  wd_comp_controller->invctx_jobliste( ).
  wd_comp_controller->invctx_jobpool( ).
  wd_comp_controller->invctx_details( ).
  wd_this->mo_cc_schdet_mat_table->invalidate_mat_fzg( ).            ">001< +
  wd_this->mo_cc_schdet_mat_table->invalidate_mat_table_data( ).     ">001< +
ENDMETHOD.

METHOD onactionremove_qualifs .

  DATA(li_sitzplatze_collection) = zcl_ia_2context_helper=>get_qualifications_to_remove( wd_context ).
  DATA(ls_vis_quali)   = VALUE wd_this->element_sitzplatz( ).
  DATA(lo_sitzplatze_i) = li_sitzplatze_collection->get_iterator( ).
  DATA(lv_has_qualif) = abap_false.

  WHILE lo_sitzplatze_i->has_next( ).
    DATA(lo_sitzplatz) = CAST zcl_ia_2seat( lo_sitzplatze_i->get_next( ) ).

    TRY.
        lo_sitzplatz->lock( iv_check = abap_true ).
        lo_sitzplatz->remove_qualifikation( ).
        lo_sitzplatz->save( ).
      CATCH zcx_ia_2failure INTO DATA(lx_error).
        wd_comp_controller->mo_message_manager->display_exception( lx_error ).
    ENDTRY.
  ENDWHILE.

  wd_comp_controller->invctx_sitzplatz( ).
  wd_comp_controller->invctx_jobliste( ).
  wd_comp_controller->invctx_jobpool( ).
  wd_comp_controller->invctx_fahrzeug( ).
  wd_comp_controller->invctx_auftraege_alv( ).
  wd_comp_controller->invctx_details( ).

  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
  DATA(lt_wa_keys) = lo_schicht->get_arbeitsstellen( )->get_keys( ).
  DATA(lv_wa_count) = lines( lt_wa_keys ).
  IF lv_wa_count = 1.
    DATA(li_sitzplatz_node) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name =  wd_this->wdctx_sitzplatz ).
    DATA(lt_sitzplatz_elems) = li_sitzplatz_node->get_elements( ).
    LOOP AT lt_sitzplatz_elems INTO DATA(li_sitzplatz_elem).
      li_sitzplatz_elem->get_static_attributes( IMPORTING static_attributes = ls_vis_quali ).
      CLEAR lo_sitzplatz.
      lo_sitzplatz = CAST zcl_ia_2seat( ls_vis_quali-object ).
      CHECK lo_sitzplatz IS BOUND.
      IF lo_sitzplatz->has_quali( ) IS NOT INITIAL.
        lv_has_qualif = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

* Check if there are no further qualifications with capacity, means the last qualif with capacify is removed abvoe
  IF lv_has_qualif IS INITIAL.
    TRY.
        DATA(lt_event_parameters) = VALUE wdr_event_parameter_list( ( name = 'ID' value = NEW string( 'BTN_ARBSTELLE_LOESCHEN' ) ) ).
        DATA(lo_btn_del_wa_evt) = NEW cl_wd_custom_event( name = 'ON_ACTION' parameters = lt_event_parameters ).
        wd_this->onactionpopup_del_arbstelle( wdevent = lo_btn_del_wa_evt  ).
      CATCH zcx_ia_2failure INTO DATA(lx_error_arbst).
        wd_comp_controller->mo_message_manager->display_exception( lx_error_arbst ).
    ENDTRY.
  ENDIF.

ENDMETHOD.

METHOD onactionselect_einzelkapa .
  DATA(lv_aufnr) = wd_this->get_aufnr_from_ctx_elem( wdevent ).
  wd_this->joblist_set_ls_by_aufnr( lv_aufnr ).
  zcl_ia_2context_helper=>mark_einzelkapas_by_aufnr( ii_context = wd_context
                                                      iv_aufnr   = lv_aufnr
                                                      iv_image   = zif_ia_2_wd_indiv_capacity=>mc_image_selected ).
ENDMETHOD.

METHOD onactionstatus_cancel .
  wd_comp_controller->set_current_event( ).
ENDMETHOD.

METHOD onactionstatus_confirm .
  wd_comp_controller->z_pe_schichtdetails( wd_comp_controller->mo_curr_event ).
ENDMETHOD.

METHOD onactionsued_distance_add .
  wd_this->mo_cc_schdet_jobpool->sued_distance_add( ).
ENDMETHOD.

METHOD onactionsued_distance_sub .
  wd_this->mo_cc_schdet_jobpool->sued_distance_sub( ).
ENDMETHOD.

METHOD onactiontoggle_etcs .
  DATA lo_fahrzeug TYPE REF TO zcl_ia_2vehicle.

  DATA(li_element) = wdevent->get_context_element( name = `CONTEXT_ELEMENT` ).
  li_element->get_attribute( EXPORTING name  = `OBJECT`
                             IMPORTING value = lo_fahrzeug ).
  DATA(lv_checkbox) = wdevent->get_char( name = `CHECKED` ).

  wd_this->mo_cc_schdet_fzeuge->toggle_etcs( io_fahrzeug = lo_fahrzeug
                                             iv_checkbox = lv_checkbox ).
ENDMETHOD.

METHOD onactiontoggle_joblist_popin .
  wd_this->mo_cc_schdet_joblist->on_view_event( io_event = wdevent ) .
endmethod.

METHOD onactiontremola_berechnen .
  TRY .
      wd_comp_controller->mo_message_manager->reset( ).

      DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).

      DATA(lo_tremola) = zcl_ia_2tremola=>get_instance( io_schicht = lo_schicht
                                                         iv_new     = abap_true ).
      DATA(lt_messages) = lo_tremola->calculate_and_save( ).

      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lt_messages ).
      wd_comp_controller->mo_message_manager->display_messages( ).

      wd_comp_controller->invctx_details( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD on_arbstelle_deleted .
  wd_this->close_empty_schicht( ).
ENDMETHOD.

METHOD on_ezform_closed .
  wd_comp_controller->invctx_details( ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

method SUPPLY_MAT_TABLE_DATA . "#EC NEEDED
endmethod.

method SUPPLY_MAT_TABLE_UI . "#EC NEEDED
endmethod.

endclass.
 