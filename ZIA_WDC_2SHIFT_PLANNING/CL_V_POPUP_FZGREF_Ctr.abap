class CL_V_POPUP_FZGREF_Ctr implementation.
 
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

  IF wd_this->mo_cc_schdet_fzgref->get_referenced_status( ).
    MESSAGE s022(zia_2_real) INTO DATA(lv_message).
    wd_this->mo_message_menager->report_success( message_text = lv_message ).
  ENDIF.
ENDMETHOD.

METHOD wddoinit .
  wd_this->mo_cc_schdet_fzgref = wd_this->get_cc_schdet_fzgref_ctr( ).
  wd_this->subscribe_buttons( ).
ENDMETHOD.

METHOD wddomodifyview .
  wd_this->report_message( ).
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD report_message .
  DATA li_api_controller  TYPE REF TO if_wd_controller.
  DATA(lt_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).
*  DATA(ls_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).

  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).

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

METHOD subscribe_buttons .
  wd_this->mo_cc_schdet_fzgref->mo_popup_fzg_ref->subscribe_to_button_event(
    EXPORTING
      action_name =  'SAVE'
      action_view =  wd_this->wd_get_api( )
      button      =  99
      button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SAVE_AND_CLOSE' ) ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

method ONACTIONON_TABLE_SRC .
   wd_this->mo_cc_schdet_fzgref->process_event_src( wdevent ).
endmethod.

method ONACTIONSAVE .
   wd_this->mo_cc_schdet_fzgref->on_save( ).
endmethod.

endclass.
 