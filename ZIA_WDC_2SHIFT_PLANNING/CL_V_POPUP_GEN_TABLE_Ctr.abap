class CL_V_POPUP_GEN_TABLE_Ctr implementation.
 
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

method WDDOBEFOREACTION . "#EC NEEDED
*  data lo_api_controller type ref to if_wd_view_controller.
*  data lo_action         type ref to if_wd_action.

*  lo_api_controller = wd_this->wd_get_api( ).
*  lo_action = lo_api_controller->get_current_action( ).

*  if lo_action is bound.
*    case lo_action->name.
*      when '...'.

*    endcase.
*  endif.
endmethod.

METHOD wddoexit .

  IF wd_this->mo_message_menager IS BOUND.
    wd_this->mo_message_menager->clear_messages( ).
  ENDIF.

*--> Begin Insert >001<
  IF wd_this->mv_details_zugsinfo_error EQ abap_true.
    MESSAGE w071(zia_2_real) INTO DATA(lv_msg) ##NEEDED.
    wd_comp_controller->mo_message_manager->add_sys_message( ).
    wd_comp_controller->mo_message_manager->display_messages( ).
  ENDIF.
*--> End Insert >001<

ENDMETHOD.

METHOD wddoinit .
  DATA: ls_sp_details TYPE wd_comp_controller->element_sp_details. "+>002<

  DATA: lt_sp_ehb TYPE wd_comp_controller->elements_sp_ehb_filtered,
        ls_sp_ehb LIKE LINE OF lt_sp_ehb.

  CHECK wd_comp_controller->mv_current_action_event = 'LTA_SP_ZEITEN'.

  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
   )->get_child_node( name = wd_comp_controller->wdctx_details
   )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb ).


  CLEAR wd_comp_controller->gt_popup_user_added_signals[].
  CLEAR wd_comp_controller->gt_popup_action_tracer[].
  CLEAR wd_comp_controller->mv_current_action_buttons.

  DATA(lt_sp_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_sp_schicht( ).

*--> Begin Insert >002<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.

    wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
           )->get_child_node( name = wd_comp_controller->wdctx_details
           )->get_child_node( name = wd_comp_controller->wdctx_sp_details
           )->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).

    wd_this->ms_sp_schicht = VALUE #( lt_sp_schicht[ sperras_id = ls_sp_details-sperras_id ] OPTIONAL ).

    DATA(ls_sp_schicht) = wd_this->ms_sp_schicht.

    DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( wd_comp_controller->mo_curr_arbstelle->get_sp_kilometer( )->get( key = ls_sp_schicht-sperras_id ) ).

    IF lo_sp_km IS BOUND.
      wd_comp_controller->gt_popup_user_added_signals[] = lo_sp_km->get_user_signals( ).
    ENDIF.
  ELSE.
*--> End Insert >002<
    ls_sp_schicht = VALUE #( lt_sp_schicht[ 1 ] OPTIONAL ).

*    SELECT * FROM zia_2sf_sc_usr
*      INTO TABLE wd_comp_controller->gt_popup_user_added_signals[]
*      WHERE sperras_id = ls_sp_schicht-sperras_id
*        AND zschicht = ls_sp_schicht-zschicht.
    wd_comp_controller->gt_popup_user_added_signals[] = wd_assist->get_sig_sections( iv_sperras_id = ls_sp_schicht-sperras_id
                                                                                     iv_shift = ls_sp_schicht-zschicht ).
  ENDIF. "+>002<

  LOOP AT lt_sp_ehb[] ASSIGNING FIELD-SYMBOL(<ls_sp_ehb>).
    IF line_exists( wd_comp_controller->gt_popup_user_added_signals[ zest = <ls_sp_ehb>-zest zsa = <ls_sp_ehb>-zsa ] ).
      DELETE wd_comp_controller->gt_popup_user_added_signals[] WHERE zest = <ls_sp_ehb>-zest AND zsa = <ls_sp_ehb>-zsa. "#EC CI_STDSEQ
    ENDIF.
  ENDLOOP.

  "frame user table
  DATA(ls_first_line) = VALUE #( lt_sp_ehb[ 1 ] OPTIONAL ).
*  DESCRIBE TABLE lt_sp_ehb[] LINES DATA(lv_offset).
  DATA(lv_offset) = lines( lt_sp_ehb[] ).


  DATA(ls_last_line) = VALUE #( lt_sp_ehb[ lv_offset ] OPTIONAL ).

  "update north
  SORT wd_comp_controller->gt_popup_user_added_signals[] BY zsa DESCENDING .
  LOOP AT wd_comp_controller->gt_popup_user_added_signals[] ASSIGNING FIELD-SYMBOL(<ls_user_line>).
    IF <ls_user_line>-zsa <= ls_first_line-zsa.
      MOVE-CORRESPONDING <ls_user_line> TO ls_sp_ehb .
      ls_sp_ehb-sp_filter =  <ls_user_line>-zest. "+>002<
      INSERT ls_sp_ehb INTO lt_sp_ehb[] INDEX 1.
      INSERT 'N' INTO wd_comp_controller->gt_popup_action_tracer[] INDEX 1. "dont lose the trace
    ENDIF.
  ENDLOOP.

  "update south
  SORT wd_comp_controller->gt_popup_user_added_signals[] BY zsa ASCENDING .
  LOOP AT wd_comp_controller->gt_popup_user_added_signals[] ASSIGNING <ls_user_line>.
    IF <ls_user_line>-zsa >= ls_last_line-zsa.
      MOVE-CORRESPONDING <ls_user_line> TO ls_sp_ehb .
      ls_sp_ehb-sp_filter =  <ls_user_line>-zest. "+>002<
      APPEND ls_sp_ehb TO lt_sp_ehb[].
      APPEND 'S' TO wd_comp_controller->gt_popup_action_tracer[].  "dont lose the trace
    ENDIF.
  ENDLOOP.

  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
 )->get_child_node( name = wd_comp_controller->wdctx_details
 )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered )->bind_table( new_items = lt_sp_ehb[] set_initial_elements = abap_true ).

ENDMETHOD.

METHOD wddomodifyview .

  DATA: lo_root            TYPE REF TO cl_wd_uielement_container,
        ls_popup_gen_table TYPE wd_this->element_popup_gen_table,
 ##NEEDED       lt_sp_ehb_user     TYPE wd_comp_controller->elements_sp_ehb_filtered,
        lo_btn_controller  TYPE REF TO cl_wd_uielement.

  lo_root ?= view->get_element( 'TC_TABLE' ).

  wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->get_static_attributes( IMPORTING static_attributes = ls_popup_gen_table ).

  wd_this->wd_get_api( )->get_embedding_window( )->set_window_title( title = ls_popup_gen_table-title  ).

*  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtplan )->get_static_attributes( importing static_attributes = ls_schichtplan ). ">003< DEL
*>003< Begin Insert: Schichtdaten für aktuellen Schicht algemein lesen
  DATA(li_tab_schichten_node) = wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten ).
  DATA(ls_tab_schichten)  = VALUE wd_this->element_tabs_schichten( ).
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  IF li_tab_schichten_node IS BOUND.
    DATA(li_schicht_tab_elem) = li_tab_schichten_node->get_lead_selection( ).
    IF li_schicht_tab_elem IS BOUND.
      li_schicht_tab_elem->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).
      IF ls_tab_schichten-object IS BOUND.
        DATA(ls_schicht) = ls_tab_schichten-object->get_data( ) ##NEEDED.
        DATA(lv_status)  = ls_tab_schichten-object->get_status( ).
        ls_schichtdetails   = CORRESPONDING #( ls_tab_schichten-object->get_data( ) ).
        IF lv_status = zif_ia_2_wrkshft_status=>mc_plannig_started   OR
           lv_status = zif_ia_2_wrkshft_status=>mc_disposition_released .
          ls_schichtdetails-edit_mode      = COND #( WHEN ls_tab_schichten-object->is_locked( ) THEN abap_true ELSE abap_false ).
        ELSE.
          ls_schichtdetails-edit_mode  = abap_false.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*>003< End   Insert: Schichtdaten für aktuellen Schicht algemein lesen
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  CASE wd_comp_controller->mo_event->get_name( ).
*--> Begin Insert >002<
    WHEN 'ON_CELL_ACTION'.
      lo_btn_controller ?= view->get_element( 'TC_BUTTONS_WRAPPER' ).
      lo_btn_controller->set_visible( 00 ).
      lo_btn_controller ?= view->get_element( 'CLOS_EBTN' ).
      lo_btn_controller->set_visible( 00 ).
      lo_btn_controller ?= view->get_element( 'SAVE_BUTTON' ).
      lo_btn_controller->set_visible( 00 ).
*--> End Insert >002<
    WHEN 'ON_ACTION'.
      IF wd_comp_controller->mv_current_action_event <> 'LTA_SP_ZEITEN'.
        lo_btn_controller ?= view->get_element( 'TC_BUTTONS_WRAPPER' ).
        lo_btn_controller->set_visible( 01 ).
        lo_btn_controller ?= view->get_element( 'CLOS_EBTN' ).
        lo_btn_controller->set_visible( 01 ).
        lo_btn_controller ?= view->get_element( 'SAVE_BUTTON' ).
        lo_btn_controller->set_visible( 01 ).
      ELSEIF ls_schichtdetails-edit_mode = abap_false.   ">003< UPD: "ls_schichtdetails" statt "ls_schichtplan" nutzten, um zu Editbarkeit determienieren
*        lo_btn_controller ?= view->get_element( |TC_BUTTONS_WRAPPER| ).
        lo_btn_controller ?= view->get_element( 'TC_BUTTONS_WRAPPER' ).
        lo_btn_controller->set_enabled( abap_false ).
*        lo_btn_controller ?= view->get_element( |SAVE_BUTTON| ).
        lo_btn_controller ?= view->get_element( 'SAVE_BUTTON' ).
        lo_btn_controller->set_enabled( abap_false ).
      ELSE.
        wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
        )->get_child_node( name = wd_comp_controller->wdctx_details
        )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb_user ).

        "save button does not apply to pairing +/- buttons with action traces
        lo_btn_controller ?= view->get_element( 'SAVE_BUTTON' ).
        lo_btn_controller->set_enabled( abap_true ).

        IF wd_comp_controller->gt_popup_action_tracer[] IS INITIAL AND wd_comp_controller->gt_popup_user_added_signals[] IS INITIAL.
          lo_btn_controller ?= view->get_element( 'NORTH_SUB' ).
          lo_btn_controller->set_enabled( abap_false ).
          lo_btn_controller ?= view->get_element( 'SOUTH_SUB' ).
          lo_btn_controller->set_enabled( abap_false ).
        ELSE.

          CASE wd_comp_controller->mv_current_action_buttons.
            WHEN ''.
              lo_btn_controller ?= view->get_element( 'NORTH_SUB' ).
              IF line_exists( wd_comp_controller->gt_popup_action_tracer[ table_line = 'N' ] ).
                lo_btn_controller->set_enabled( abap_true ).
              ELSE.
                lo_btn_controller->set_enabled( abap_false ).
              ENDIF.

              lo_btn_controller ?= view->get_element( 'SOUTH_SUB' ).
              IF line_exists( wd_comp_controller->gt_popup_action_tracer[ table_line = 'S' ] ).
                lo_btn_controller->set_enabled( abap_true ).
              ELSE.
                lo_btn_controller->set_enabled( abap_false ).
              ENDIF.

            WHEN 'N'.
              lo_btn_controller ?= view->get_element( 'NORTH_SUB' ).
              IF line_exists( wd_comp_controller->gt_popup_action_tracer[ table_line = 'N' ] ).
                lo_btn_controller->set_enabled( abap_true ).
              ELSE.
                lo_btn_controller->set_enabled( abap_false ).
              ENDIF.

              ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
                                                                         )->get_child_node( name = wd_comp_controller->wdctx_details
                                                                         )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered ).
            WHEN 'S'.
              lo_btn_controller ?= view->get_element( 'SOUTH_SUB' ).
              IF line_exists( wd_comp_controller->gt_popup_action_tracer[ table_line = 'S' ] ).
                lo_btn_controller->set_enabled( abap_true ).
              ELSE.
                lo_btn_controller->set_enabled( abap_false ).
              ENDIF.
              "update display values
              ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
                                                                         )->get_child_node( name = wd_comp_controller->wdctx_details
                                                                         )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered ).
            WHEN OTHERS.
          ENDCASE.
        ENDIF.
      ENDIF.
  ENDCASE.
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  DATA: lo_table TYPE REF TO cl_wd_table.

  lo_table = cl_wd_dynamic_tool=>create_table_from_node( ui_parent = lo_root
                                                         table_id  = 'TBL_TABLE'
                                                         node      = ls_popup_gen_table-node_to_schow_as_table ).
  IF lo_table IS NOT INITIAL.
    lo_table->set_visible_row_count( value = -1 ).
  ENDIF.

  wd_this->report_message( ).

ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD add_message .
  DATA(lt_msg) = VALUE wd_this->elements_popup_get_table_msg( ).

  DATA(lv_msgid) = COND #( WHEN iv_msgid IS NOT INITIAL THEN iv_msgid ELSE sy-msgid ).
  DATA(lv_msgty) = COND #( WHEN iv_msgty IS NOT INITIAL THEN iv_msgty ELSE sy-msgty ).
  DATA(lv_msgno) = COND #( WHEN iv_msgno IS NOT INITIAL THEN iv_msgno ELSE sy-msgno ).
  DATA(lv_msgv1) = COND #( WHEN iv_msgv1 IS NOT INITIAL THEN iv_msgv1 ELSE sy-msgv1 ).
  DATA(lv_msgv2) = COND #( WHEN iv_msgv2 IS NOT INITIAL THEN iv_msgv2 ELSE sy-msgv2 ).
  DATA(lv_msgv3) = COND #( WHEN iv_msgv3 IS NOT INITIAL THEN iv_msgv3 ELSE sy-msgv3 ).
  DATA(lv_msgv4) = COND #( WHEN iv_msgv4 IS NOT INITIAL THEN iv_msgv4 ELSE sy-msgv4 ).

  IF lv_msgid IS INITIAL OR
     lv_msgno IS INITIAL OR
     lv_msgty IS INITIAL.
    RETURN.
  ENDIF.

  MESSAGE ID lv_msgid TYPE lv_msgty NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO DATA(lv_message).
  wd_context->get_child_node( name = wd_this->wdctx_popup_get_table_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).
  APPEND VALUE #( msgty = lv_msgty msg = lv_message ) TO lt_msg.
  wd_context->get_child_node( name = wd_this->wdctx_popup_get_table_msg )->bind_table( new_items = lt_msg set_initial_elements = abap_true ).

ENDMETHOD.

METHOD check_on_add .
  DATA(lt_sp_ehb_user) = VALUE wd_this->elements_sp_ehb_filtered( ).
  DATA lo_as_i         TYPE REF TO cl_object_collection_iterator.


  DATA(lo_curr_as) = wd_comp_controller->mo_curr_arbstelle.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
    )->get_child_node( name = wd_this->wdctx_details
    )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb_user ).

*****************************************************************************************************************************************
  "1. Check Ausdehnung
  DATA(ls_param) = lo_curr_as->get_schicht( )->get_parameter( )->get_data( ).
  IF ls_param-max_ausdehnung =< lines( lt_sp_ehb_user ).
    ##NEEDED   MESSAGE e462(zia_2_real) INTO DATA(lv_message).
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.
*****************************************************************************************************************************************
  "2. Check if SA overlaps another AS
  DATA(ls_sa_next) = wd_this->get_next_sa( iv_button ).

  lo_as_i ?= lo_curr_as->get_schicht( )->get_arbeitsstellen( )->get_values_iterator( ).
  WHILE lo_as_i->has_next( ) = abap_true.
    DATA(lo_as) = CAST zcl_ia_2wrkplace( lo_as_i->get_next( ) ).
    CHECK lo_as->get_id( ) <> lo_curr_as->get_id( ).
    DATA(ls_as) = lo_as->get_data( ).
    IF ls_sa_next-km_von >= ls_as-zkmin AND
       ls_sa_next-km_von <= ls_as-zkmax.
      MESSAGE e063(zia_2_real) INTO lv_message.
*      RAISE EXCEPTION TYPE zcx_ia_2failure.
*      zcx_ia_2failure=>raise_with_sys_msg( ).
    ENDIF.
  ENDWHILE.

ENDMETHOD.

METHOD get_next_sa .
  DATA(lt_sp_ehb) = VALUE wd_this->elements_sp_ehb_filtered( ).
  DATA(ls_sp_ehb) = VALUE wd_this->element_sp_ehb_filtered( ).


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
    )->get_child_node( name = wd_this->wdctx_details
    )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb ).


  ls_sp_ehb = COND #( WHEN iv_button = 'NORTH_ADD' THEN VALUE #( lt_sp_ehb[ 1 ] OPTIONAL )
                      WHEN iv_button = 'NORTH_SUB' THEN VALUE #( lt_sp_ehb[ 1 ] OPTIONAL )
                      WHEN iv_button = 'SOUTH_ADD' THEN VALUE #( lt_sp_ehb[ lines( lt_sp_ehb ) ] OPTIONAL )
                      WHEN iv_button = 'SOUTH_SUB' THEN VALUE #( lt_sp_ehb[ lines( lt_sp_ehb ) ] OPTIONAL ) ).

  "Get next SA
*  SELECT SINGLE *
*    FROM zia_2sc_seq
*    INTO @DATA(ls_sa_abfolge)
*    WHERE sperrabschnitt  = @ls_sp_ehb-zest
*      AND signalabschnitt = @ls_sp_ehb-zsa.
  DATA(ls_sa_abfolge) = wd_assist->get_signalsections( iv_zest = ls_sp_ehb-zest iv_zsa = ls_sp_ehb-zsa ).

  IF ls_sa_abfolge IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lv_zsa)    = COND #( WHEN iv_button(1) = 'N' THEN ls_sa_abfolge-n_signalabschnitt ELSE ls_sa_abfolge-s_signalabschnitt ) ##NEEDED.
  DATA(lv_zest)   = COND #( WHEN iv_button(1) = 'N' THEN ls_sa_abfolge-n_sperrabschnitt  ELSE ls_sa_abfolge-s_sperrabschnitt  ) ##NEEDED.
  DATA(lv_zzperi) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_data( )-zzperi ##NEEDED.

*  SELECT SINGLE *
*    FROM zia_2sc INTO @rs_data
*    WHERE zzperi = @lv_zzperi
*      AND zsa    = @lv_zsa
*      AND zest   = @lv_zest.

  IF rs_data IS INITIAL.
    RETURN.
  ENDIF.

ENDMETHOD.

METHOD init_message .
  DATA(lt_msg) = VALUE wd_this->elements_popup_get_table_msg( ).

  wd_context->get_child_node( name = wd_this->wdctx_popup_get_table_msg )->bind_table( EXPORTING new_items = lt_msg ).

  IF wd_this->mo_message_menager IS BOUND.
    wd_this->mo_message_menager->clear_messages( ).
  ENDIF.

ENDMETHOD.

METHOD report_message .
  DATA li_api_controller  TYPE REF TO if_wd_controller.
  DATA(lt_msg) = VALUE wd_this->elements_popup_get_table_msg( ).


  wd_context->get_child_node( name = wd_this->wdctx_popup_get_table_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).

  li_api_controller          ?= wd_this->wd_get_api( ).
  wd_this->mo_message_menager = li_api_controller->get_message_manager( ).
  wd_this->mo_message_menager->clear_messages( ).

  LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<ls_msg>).
    CASE <ls_msg>-msgty.
      WHEN 'S'.
        wd_this->mo_message_menager->report_success( message_text = <ls_msg>-msg ).
      WHEN 'W'.
        wd_this->mo_message_menager->report_warning( message_text = <ls_msg>-msg ).
      WHEN 'E'.
        wd_this->mo_message_menager->report_error_message( message_text = <ls_msg>-msg ).
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDMETHOD.

METHOD with_messages .
  DATA(lt_msg) = VALUE wd_this->elements_popup_get_table_msg( ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_get_table_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).

  IF lt_msg[] IS NOT INITIAL.
    rv_value = abap_true.
  ENDIF.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionclose .
  CLEAR wd_comp_controller->gt_popup_user_added_signals[].
  CLEAR wd_comp_controller->gt_popup_action_tracer[].
  CLEAR wd_comp_controller->mv_current_action_buttons.
  wd_comp_controller->mo_current_popup->close( ).
ENDMETHOD.

METHOD onactionnorth_add .
  TRY.
      wd_this->init_message( ).                                                             ">002< +
      wd_this->check_on_add( 'NORTH_ADD' ).                                                 ">002< +
      wd_comp_controller->btn_handler_popup( EXPORTING iv_button = 'NORTH_ADD' ).
    CATCH zcx_ia_2failure.
      wd_this->add_message( ).                                                              ">002< +
  ENDTRY.
ENDMETHOD.

METHOD onactionnorth_sub .
  wd_this->init_message( ).                                                    ">002< +
  wd_comp_controller->btn_handler_popup( iv_button = 'NORTH_SUB' ).
ENDMETHOD.

METHOD onactionsave .
  DATA: lt_sp_ehb_user TYPE wd_comp_controller->elements_sp_ehb_filtered,
        lt_sp_ehb_in   TYPE wd_comp_controller->elements_sp_ehb ##NEEDED,
        lt_sp_details  TYPE wd_comp_controller->elements_sp_details.

  wd_comp_controller->mo_curr_arbstelle->get_sp_details_wd( IMPORTING et_sp_ehb = lt_sp_ehb_in ).
  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
   )->get_child_node( name = wd_comp_controller->wdctx_details
   )->get_child_node( name = wd_comp_controller->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb_user ).

  wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
     )->get_child_node( name = wd_comp_controller->wdctx_details
     )->get_child_node( name = wd_comp_controller->wdctx_sp_details )->get_static_attributes_table( IMPORTING table = lt_sp_details ).

  DATA(lt_sp_shicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_sp_schicht( ).
  DATA(ls_sp_shicht) = VALUE #( lt_sp_shicht[ 1 ] OPTIONAL ).

*--> Begin Insert >003<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true AND  "temp while testing.
    wd_this->ms_sp_schicht IS NOT INITIAL.

    ls_sp_shicht = wd_this->ms_sp_schicht.

  ENDIF.
*--> End Insert >003<

*  SELECT SINGLE * FROM zia_2sf_wa INTO @DATA(ls_arb)
*  WHERE zarbstl = @wd_comp_controller->mo_curr_arbstelle->gs_arbeitsstelle-zarbstl.
  DATA(ls_arb) =   wd_assist->get_workplaces( iv_arbstl = wd_comp_controller->mo_curr_arbstelle->gs_arbeitsstelle-zarbstl ).

  LOOP AT lt_sp_ehb_user[] ASSIGNING FIELD-SYMBOL(<ls_user_line>).
    DATA(lv_index) = sy-tabix.
    IF lv_index = 1.
      ls_arb-zkmin = <ls_user_line>-km_von.
      DATA(lv_ehb_min) = |{ <ls_user_line>-zsa ALPHA = OUT }| && |/| && |{ <ls_user_line>-zehb ALPHA = OUT }|. "#EC TEXT_ASSEMBLY
    ENDIF. "+>002<
    IF lv_index = lines( lt_sp_ehb_user[] ). "Change >002<
      ls_arb-zkmax = <ls_user_line>-km_bis.
      DATA(lv_ehb_max) = |{ <ls_user_line>-zsa ALPHA = OUT }| && |/| && |{ <ls_user_line>-zehb ALPHA = OUT }|. "#EC TEXT_ASSEMBLY
    ENDIF.
  ENDLOOP.

  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_false. "temp while testing. "+003<
    "KM: 111.111 - 222.222
    READ TABLE lt_sp_details ASSIGNING FIELD-SYMBOL(<ls_sp_details>) INDEX 1.
    IF <ls_sp_details> IS ASSIGNED.
      <ls_sp_details>-sp_kilometer = |KM: | && ls_arb-zkmin && | - | && ls_arb-zkmax. "#EC TEXT_ASSEMBLY
      <ls_sp_details>-sp_sigabs_ehb = |Signalabschn./EHB: | && lv_ehb_min && | - | && lv_ehb_max. "#EC TEXT_ASSEMBLY
      wd_context->get_child_node( name = wd_comp_controller->wdctx_schichtdetails
       )->get_child_node( name = wd_comp_controller->wdctx_details
       )->get_child_node( name = wd_comp_controller->wdctx_sp_details )->bind_table( EXPORTING new_items = lt_sp_details set_initial_elements = abap_true  ).
    ENDIF.

*    DELETE FROM zia_2sf_sc_usr WHERE sperras_id = ls_sp_shicht-sperras_id
*                                      AND zschicht = ls_sp_shicht-zschicht.
    wd_assist->delete_signal_sections( iv_sperras_id = ls_sp_shicht-sperras_id iv_shift = ls_sp_shicht-zschicht it_user_add_signals = wd_comp_controller->gt_popup_user_added_signals[] ).
*    MODIFY zia_2sf_sc_usr FROM TABLE wd_comp_controller->gt_popup_user_added_signals[].
  ENDIF. "+>003<

*--> Begin Insert >002<
  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
  DATA(lo_arbstelle) = lo_schicht->get_arbeitsstelle_by_id( ls_arb-zarbstl ).

*--> Begin Insert >003<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
    DATA(lo_sp_km) = CAST zcl_ia_2_sp_kilometer( lo_arbstelle->get_sp_kilometer( )->get( key = ls_sp_shicht-sperras_id ) ).
    IF lo_sp_km IS BOUND.
      lo_sp_km->set_user_signals( wd_comp_controller->gt_popup_user_added_signals[] ).
    ENDIF.
  ENDIF.
*--> End Insert >003<

  lo_arbstelle->set_zkmin( ls_arb-zkmin ).
  lo_arbstelle->set_zkmax( ls_arb-zkmax ).

*--> Begin Insert >003<
  CLEAR: wd_this->mv_details_zugsinfo_error.
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true AND  "temp while testing.
     lo_arbstelle->is_fzg_km_sa_trennung_valid( ) EQ abap_false.
    wd_this->mv_details_zugsinfo_error = abap_true.
  ENDIF.
**--> End Insert >003<

  wd_comp_controller->mo_curr_arbstelle = lo_arbstelle.
  lo_schicht->save( ).
  lo_schicht->reload( ).
*--> End Insert >002<

*--> Begin Insert >003<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.
    "Update jobpool / arbst vis after manual signals are added
    wd_comp_controller->invctx_jobpool( ).
    wd_comp_controller->invctx_arbst_vis( ).
  ENDIF.
*--> End Insert >003<

*  COMMIT WORK AND WAIT. "re-enter slowdown
  wd_assist->run_commit( ).

  wd_this->onactionclose( wdevent ). "+>003<

ENDMETHOD.

METHOD onactionsouth_add .
  TRY.
      wd_this->init_message( ).                                                    ">002< +
      wd_this->check_on_add( 'SOUTH_ADD' ).                                        ">002< +
      wd_comp_controller->btn_handler_popup( iv_button = 'SOUTH_ADD' ).
    CATCH zcx_ia_2failure.
      wd_this->add_message( ).                                                     ">002< +
  ENDTRY.
ENDMETHOD.

METHOD onactionsouth_sub .
  wd_this->init_message( ).                                                     ">002< +
  wd_comp_controller->btn_handler_popup( iv_button = 'SOUTH_SUB' ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

method SUPPLY_JOBPOOL_POPIN_DETAILS . "#EC NEEDED
* General Notes
* =============
* A common scenario for a supply method is to aquire key
* informations from the parameter <parent_element> and then
* to invoke a data provider.
* A free navigation thru the context, especially to nodes on
* the same or deeper hierachical level is strongly discouraged,
* because such a strategy may easily lead to unresolvable
* situations!!

*  if necessary, get static attributes of parent element
*  DATA ls_parent_attributes TYPE wd_this->element_table_popin_jobpool.
*  parent_element->get_static_attributes(
*    IMPORTING
*      static_attributes = ls_parent_attributes ).

*
** data declaration
*  DATA lt_jp_popin_detail TYPE wd_this->Elements_jp_popin_detail.
*  DATA ls_jp_popin_detail LIKE LINE OF lt_jp_popin_detail.
** @TODO compute values
** e.g. call a data providing FuBa
*
** bind all the elements
*  node->bind_table(
*    new_items            =  lt_jp_popin_detail
*    set_initial_elements = abap_true ).
*
endmethod.

method SUPPLY_SP_INTVART_AS . "#EC NEEDED
* General Notes
* =============
* A common scenario for a supply method is to aquire key
* informations from the parameter <parent_element> and then
* to invoke a data provider.
* A free navigation thru the context, especially to nodes on
* the same or deeper hierachical level is strongly discouraged,
* because such a strategy may easily lead to unresolvable
* situations!!

*  if necessary, get static attributes of parent element
*  DATA ls_parent_attributes TYPE wd_this->element_schichtdetails.
*  parent_element->get_static_attributes(
*    IMPORTING
*      static_attributes = ls_parent_attributes ).

*
** data declaration
*  DATA lt_sp_intvart_as TYPE wd_this->Elements_sp_intvart_as.
*  DATA ls_sp_intvart_as LIKE LINE OF lt_sp_intvart_as.
** @TODO compute values
** e.g. call a data providing FuBa
*
** bind all the elements
*  node->bind_table(
*    new_items            =  lt_sp_intvart_as
*    set_initial_elements = abap_true ).
*
endmethod.

endclass.
 