class CL_V_POPIN_JOBLISTE_Ctr implementation.
 
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

method WDDOEXIT . "#EC NEEDED
endmethod.

METHOD wddoinit .
  wd_this->mo_cc_schdet_jobliste = wd_this->get_cc_schdet_jobliste_ctr( ).
ENDMETHOD.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionpopup_remove_auftrag .

  CONSTANTS: lc_otr_window_title   TYPE string VALUE 'ZIA_2GBT_PG2/MANUAL_SIGNAL_SEGMENTS',
             lc_otr_ja             TYPE string VALUE 'ZIA_2GBT_PG2/YES',
             lc_otr_nein           TYPE string VALUE 'ZIA_2GBT_PG2/NO',
             lc_action_remove_auft TYPE string VALUE 'REMOVE_AUFTRAG'.

  CHECK: wd_comp_controller->mo_curr_arbstelle IS BOUND.

  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true AND  "For Testing
     wd_comp_controller->mo_curr_arbstelle->contains_manual_signals( ).

    MESSAGE i064(zia_2_real) INTO DATA(lv_message_1).
    MESSAGE i065(zia_2_real) INTO DATA(lv_message_2).
    MESSAGE i066(zia_2_real) INTO DATA(lv_message_3).

    DATA(lv_message) = |{ lv_message_1 }{ lv_message_2 }|.

    DATA(lt_text) = VALUE string_table( ( lv_message ) ( lv_message_3 ) ).

    wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_window_title )
                                          it_text         = lt_text
                                          iv_btn1_action  = lc_action_remove_auft
                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_ja )
                                          iv_btn1_type    = if_wd_window=>co_button_ok
                                          iv_btn2_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_nein )
                                          iv_btn2_type    = if_wd_window=>co_button_no
                                          iv_close_button = abap_true
                                          ).

  ELSE.

    wd_this->onactionremove_auftrag( wdevent ).

  ENDIF.

ENDMETHOD.

METHOD onactionprocess_event .

  wd_comp_controller->z_pe_popin_jobliste( io_event = wdevent ).

ENDMETHOD.

METHOD onactionremove_auftrag .
*--> Begin Insert >001<
  wd_comp_controller->mo_message_manager->reset( ).

  wd_comp_controller->remove_manual_signals( ).
*--> End Insert >001<

  wd_this->mo_cc_schdet_jobliste->remove_auftrag( ).

*--> Begin Insert >001<
  wd_comp_controller->mo_message_manager->display_messages( ).
  wd_comp_controller->mo_message_manager->reset( ).
*--> End Insert >001<

ENDMETHOD.

endclass.
 