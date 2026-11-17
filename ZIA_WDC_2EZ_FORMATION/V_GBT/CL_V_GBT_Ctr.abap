class CL_V_GBT_Ctr implementation.

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
  IF wd_comp_controller->go_msg_wd_manager IS BOUND.
    wd_comp_controller->go_msg_wd_manager->clear_messages( ).
  ENDIF.
ENDMETHOD.

METHOD wddoinit .
  "Subscribe buttons
  wd_this->subscribe_buttons( ).
  wd_this->mc_popup_tremola_error = 'TREMOLA_ERROR'.  ">002< +
  wd_comp_controller->go_message_manager->reset( ).   ">002< +

ENDMETHOD.

METHOD wddomodifyview .

  wd_this->mo_view = view.
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD open_popup_on_tremola_err .
  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = `BAPIRET2`
                                                                      dref = REF #( gt_bapiret ) )
                                                                  ) ).



  DATA(lt_message) = VALUE string_table( ( cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/EZ_FORM_POPUP_TREMOLA_ERROR` ) ) ).

  wd_comp_controller->open_popup_message_with_params( iv_popup_id     = wd_this->mc_popup_tremola_error
                                                      io_parameters   = lo_parameters
                                                      iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIO_5/FEHLER` )
                                                      iv_button_kind  = if_wd_window=>co_buttons_yesno
                                                      "iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIO_3/RESET` )
                                                      it_text         = lt_message ).


ENDMETHOD.

METHOD report_message .
  DATA li_api_controller  TYPE REF TO if_wd_controller.

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

  li_api_controller          ?= wd_this->wd_get_api( ).
  IF wd_this->go_msg_wd_manager IS NOT BOUND.
    wd_this->go_msg_wd_manager = li_api_controller->get_message_manager( ).
  ENDIF.
  wd_this->go_msg_wd_manager->clear_messages( ).

  MESSAGE ID lv_msgid TYPE lv_msgty NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO DATA(lv_message).

  DATA(lv_msg_type) = COND #( WHEN lv_msgty = 'S' THEN if_wd_message_manager=>co_type_standard
                              WHEN lv_msgty = 'I' THEN if_wd_message_manager=>co_type_info
                              WHEN lv_msgty = 'W' THEN if_wd_message_manager=>co_type_warning
                              WHEN lv_msgty = 'E' THEN if_wd_message_manager=>co_type_error ).

  IF iv_attr_name IS NOT INITIAL AND
     io_ctx_el    IS BOUND.
    wd_this->go_msg_wd_manager->report_attribute_message(
      attribute_name = iv_attr_name
      message_type   = lv_msg_type
      message_text   = lv_message
      element        = io_ctx_el ).
  ELSE.
    wd_this->go_msg_wd_manager->report_message(
      message_text = lv_message
      message_type = lv_msg_type ).
  ENDIF.

ENDMETHOD.

METHOD set_ui_visibility .
  DATA(lt_ez_form) = VALUE wd_this->elements_ez_formation( ).
  DATA(ls_ui_vis)  = VALUE wd_this->element_ui_visibility( ).

  wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_static_attributes_table( IMPORTING table = lt_ez_form ).
  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_static_attributes( IMPORTING static_attributes = ls_ui_vis ).

  "If no ez formation data retrieved then disable Tremola button
  ls_ui_vis-ena_btn_tremola = COND #( WHEN lt_ez_form IS INITIAL THEN abap_false ELSE abap_true ).


  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->set_static_attributes( static_attributes = ls_ui_vis ).

ENDMETHOD.

METHOD subscribe_buttons .

  wd_comp_controller->subscribe_to_button_event( ii_view_controller = wd_this->wd_get_api( )
                                               iv_action          = `BTN_SAVE`
                                               iv_button          = if_wd_window=>co_button_yes ).

  wd_comp_controller->subscribe_to_button_event( ii_view_controller = wd_this->wd_get_api( )
                                                 iv_action          = `BTN_RESET`
                                                 iv_button          = if_wd_window=>co_button_no ).

  wd_comp_controller->subscribe_to_button_event( ii_view_controller = wd_this->wd_get_api( )
                                                 iv_action          = `BTN_CLOSE` ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionbtn_add .
  ##NEEDED DATA: lt_ez_form    TYPE TABLE OF zia_2_ez_form_wd_s,
         lt_arbstellen TYPE TABLE OF zia_2_ez_arbstelle_wd_s.

  "Get current value of table
  DATA(li_node_form) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation ).
  li_node_form->get_static_attributes_table( IMPORTING table = lt_ez_form ).

  ##NEEDED DATA(lt_ezform_elems) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_elements( ).

  DATA(li_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).

  "Get last row of section as template
  li_element->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

  CLEAR: ls_ez_formation-show_add_btn.
  "MODIFY lt_ez_form FROM ls_ez_formation INDEX li_element->get_index( ).  ">002< (-)

  DATA(lv_index) = li_element->get_index( ) + 1.

  DATA(ls_new_ez_formation) = ls_ez_formation.

  CLEAR: ls_new_ez_formation.

  ls_new_ez_formation-zschicht = ls_ez_formation-zschicht.
  ls_new_ez_formation-zid_eiz  = ls_ez_formation-zid_eiz.
  ls_new_ez_formation-eiz_ktxt = ls_ez_formation-eiz_ktxt.
  ls_new_ez_formation-einfahrt = ls_ez_formation-einfahrt.
  ls_new_ez_formation-ausfahrt = ls_ez_formation-ausfahrt.
  ls_new_ez_formation-richtung = ls_ez_formation-richtung.

  ls_new_ez_formation-manually_created = abap_true.
  ls_new_ez_formation-show_add_btn     = abap_true.
  ls_new_ez_formation-show_remove_btn    = abap_true.
  ls_new_ez_formation-ena_zeit_am_starttag = abap_true.        ">002< (+)

  "Insert after last row
  "INSERT ls_new_ez_formation INTO lt_ez_form INDEX lv_index.  ">002< (-)

  "li_node_form->bind_table( lt_ez_form ).   ">002< (-)
  li_node_form->set_static_attributes( EXPORTING index = li_element->get_index( ) static_attributes = ls_ez_formation ).
  li_node_form->bind_structure( EXPORTING index = lv_index set_initial_elements = abap_false new_item = ls_new_ez_formation ).



ENDMETHOD.

METHOD onactionbtn_close .
  wd_comp_controller->close( ).
ENDMETHOD.

METHOD onactionbtn_remove .

  DATA: lt_ez_form TYPE TABLE OF zia_2_ez_form_wd_s.

  "Get current value of table
  ##NEEDED DATA(lt_ez_formations) = VALUE wd_comp_controller->elements_ez_formation( ).

  DATA(li_node_form) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation ).
  ##NEEDED DATA(lt_elems_form) = li_node_form->get_elements( ).

  li_node_form->get_static_attributes_table( IMPORTING table = lt_ez_form ).

  "Get selected row
  DATA(li_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
  li_element->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

  "Get index of row
  DATA(lv_index) = li_element->get_index( ).

  IF ls_ez_formation-manually_created EQ abap_true. "And in Edit mOde

    IF lt_ez_form[ lv_index ]-show_add_btn = abap_true.
      "Move Add button
      lt_ez_form[ lv_index - 1 ]-show_add_btn = abap_true.
    ENDIF.

    DELETE lt_ez_form INDEX lv_index.
  ENDIF.

  li_node_form->bind_table( lt_ez_form ).


ENDMETHOD.

METHOD onactionbtn_reset .

  wd_comp_controller->delete_ez_form( ).

  wd_comp_controller->reset_schicht( ).

  wd_comp_controller->tremola_calc_and_save( ).

  wd_comp_controller->save_tremola_ez_form( ).
ENDMETHOD.

METHOD onactionbtn_save .
  TRY.
      wd_comp_controller->check_on_save( ).
      wd_comp_controller->save_data( ).
      wd_comp_controller->reset_schicht( ).
      wd_comp_controller->tremola_calc_and_save( IMPORTING et_bapiret = DATA(lt_bapiret) ).  ">001< mod
      wd_comp_controller->invalidate_context( ).
      wd_this->set_ui_visibility( ).
      IF line_exists( lt_bapiret[ type = 'E' ] ).                             ">001< +
        wd_this->open_popup_on_tremola_err( gt_bapiret = lt_bapiret ).        ">001< +
      ELSE.                                                                 ">001< +
        wd_comp_controller->close( ).
      ENDIF.
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.

ENDMETHOD.

METHOD onactionbtn_tremola_calc .
  TRY.
      wd_comp_controller->save_data( ).
      wd_comp_controller->reset_schicht( ).
      wd_comp_controller->tremola_calc_and_save( ).
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.
ENDMETHOD.

METHOD onactionpopup_ez_form_trenn .
  DATA(li_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).

  DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
  li_element->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

  TRY.
      wd_comp_controller->open_popup_trennung( is_ez_form_trennung = CORRESPONDING #( ls_ez_formation ) ).
    CATCH zcx_ia_2failure.
      ASSERT 1 = 1.
  ENDTRY.

ENDMETHOD.

METHOD onactionselect_arbstelle .
  DATA(li_ctx_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(lv_checked) = CONV wdy_boolean( wdevent->get_char( name = 'CHECKED' ) ).

  wd_comp_controller->set_checkbox_changed( ii_element = li_ctx_element ).

  wd_comp_controller->switch_arbstelle_checkbox( ii_element = li_ctx_element
                                                 iv_checked = lv_checked ).

ENDMETHOD.

METHOD on_popup_tremola_err_confirmed .
  DATA lt_bapiret2 TYPE bapiret2_t.

  IF iv_popup_id <> wd_this->mc_popup_tremola_error.
    RETURN.
  ENDIF.

  io_parameters->get_table( EXPORTING iv_name = 'BAPIRET2' IMPORTING et_any = lt_bapiret2 ).
  wd_comp_controller->go_message_manager->add_bapiret_t( it_table = lt_bapiret2 ).
  wd_comp_controller->close( ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_ui_visibility .
  DATA(ls_ui_visibility) = VALUE wd_this->element_ui_visibility( ).


  DATA(lv_edit_mode) = wd_comp_controller->get_edit_mode( ).
  wd_comp_controller->gi_window->set_button_enabled( EXPORTING button = if_wd_window=>co_button_yes is_enabled = lv_edit_mode ).
  wd_comp_controller->gi_window->set_button_enabled( EXPORTING button = if_wd_window=>co_button_no  is_enabled = lv_edit_mode ).
  ls_ui_visibility-data_origine = COND #( WHEN lv_edit_mode = abap_false THEN abap_false ELSE wd_comp_controller->gv_testmode ).

  DATA(li_view)   = CAST if_wd_view( wd_this->wd_get_api( ) ).
  DATA(lo_button) = CAST cl_wd_button( li_view->get_element( 'BTN_TREMOLA' ) ).
  IF lo_button IS BOUND.
    lo_button->set_enabled( lv_edit_mode ).
  ENDIF.

  node->bind_structure( new_item = ls_ui_visibility ).

ENDMETHOD.

endclass.
