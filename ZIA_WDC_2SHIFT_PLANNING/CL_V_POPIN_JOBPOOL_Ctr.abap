class CL_V_POPIN_JOBPOOL_Ctr implementation.
 
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

  wd_this->mo_cc_schdet_jobpool = wd_this->get_cc_schdet_jobpool_ctr( ).

ENDMETHOD.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionauftrag_einplanen .
  " Define fixed phases for maintenance
  DATA lv_maintordovrlprocphase TYPE eam_ostat_phase." VALUE '06'.
  DATA lv_maintordovrlprocphase_05 TYPE eam_ostat_phase VALUE '05'.
  DATA lv_maintordovrlprocphase_06 TYPE eam_ostat_phase VALUE '06'.
  DATA lv_maintordovrlprocsubphase_60 TYPE eam_ostat_sphase VALUE '0060'.
  DATA lv_maintordovrlprocsubphase_55 TYPE eam_ostat_sphase VALUE '0055'.
  DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase.
  IF  wd_comp_controller->mo_message_manager->has_errors( ) .
    wd_comp_controller->mo_message_manager->display_messages( iv_filter_msg_type = 'E' ).
  ELSE.
    " get order
    DATA(lv_aufnr) = wd_this->mo_cc_schdet_jobpool->get_aufnr_from_popin( ).

    wd_comp_controller->remove_manual_signals( )."+>001<

    IF wd_this->mo_cc_schdet_jobpool->add_selected_auftrags( lv_aufnr ).
      wd_comp_controller->popin_aufnr_release( ).
      wd_this->mo_cc_schdet_jobpool->popin_collapsed( ).
    ENDIF.
    " getting instance of the ZCL_IA_2WORKSHIFT
    DATA(lo_shift) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
    " getting shift data
    DATA(ls_shift) = lo_shift->get_data( ).
    wd_comp_controller->mo_curr_arbstelle->get_schicht( )->reload( ).
    " change the userstatus based on the Notification Priority
    lo_shift->change_userstatus_by_prio( EXPORTING iv_qmnum = CONV zia_2_workshift( ls_shift-zschicht )
                                                  iv_order = lv_aufnr ).
    CASE ls_shift-zstatus.
      WHEN zcl_ia_2workshift=>mc_prio_1.
        lv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase_55.
        lv_maintordovrlprocphase = lv_maintordovrlprocphase_05.
      WHEN zcl_ia_2workshift=>mc_prio_2.
        lv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase_60.
        lv_maintordovrlprocphase = lv_maintordovrlprocphase_06.
      WHEN OTHERS.
    ENDCASE.
    zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = lv_aufnr
                                        iv_maintordovrlprocphase = lv_maintordovrlprocphase
                                        iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
  ENDIF.
ENDMETHOD.

METHOD onactionauftrag_entfernen .

  DATA(lv_aufnr) = wd_this->mo_cc_schdet_jobpool->get_aufnr_from_popin( ).

  wd_comp_controller->mo_curr_arbstelle->remove_vorschau( ).

  IF wd_this->mo_cc_schdet_jobpool->remove_auftrag( lv_aufnr ).
    wd_comp_controller->popin_aufnr_release( ).
    wd_this->mo_cc_schdet_jobpool->popin_collapsed( ).
  ENDIF.
ENDMETHOD.

method ONACTIONAUFTRAG_PRUEFEN . "#EC NEEDED
endmethod.

METHOD onactionpopup_auft_einplanen .
  CONSTANTS: lc_otr_window_title      TYPE string VALUE 'ZIA_2GBT_PG2/MANUAL_SIGNAL_SEGMENTS',
             lc_otr_ja                TYPE string VALUE 'ZIA_2GBT_PG2/YES',
             lc_otr_nein              TYPE string VALUE 'ZIA_2GBT_PG2/NO',
             lc_action_auft_einplanen TYPE string VALUE 'AUFTRAG_EINPLANEN'.

  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true AND  "For Testing
     wd_comp_controller->mo_curr_arbstelle IS BOUND AND
     wd_comp_controller->mo_curr_arbstelle->contains_manual_signals( ).

    MESSAGE i064(zia_2_real) INTO DATA(lv_message_1).
    MESSAGE i065(zia_2_real) INTO DATA(lv_message_2).
    MESSAGE i066(zia_2_real) INTO DATA(lv_message_3).

    DATA(lv_message) = |{ lv_message_1 }{ lv_message_2 }|.

    DATA(lt_text) = VALUE string_table( ( lv_message ) ( lv_message_3 ) ).

    wd_comp_controller->open_popup_message( io_view_object  = wd_this->wd_get_api( )
                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_window_title   )
                                          it_text         = lt_text
                                          iv_btn1_action  = lc_action_auft_einplanen
                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_ja )
                                          iv_btn1_type    = if_wd_window=>co_button_ok
                                          iv_btn2_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = lc_otr_nein )
                                          iv_btn2_type    = if_wd_window=>co_button_no
                                          iv_close_button = abap_true
                                          ).

  ELSE.

    wd_this->onactionauftrag_einplanen( wdevent ).

  ENDIF.
ENDMETHOD.

method ONACTIONPROCESS_EVENT . "#EC NEEDED
endmethod.

method ONACTIONREMOVE_VON_JOBPOOL . "#EC NEEDED
endmethod.

endclass.
 