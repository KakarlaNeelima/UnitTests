class CL_V_POPUP_MET_AS_SEL_Ctr implementation.
 
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
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  DATA(ls_met_popup_vis)  = VALUE wd_this->element_popup_met_as_sel_vis( ).
  ##NEEDED DATA(ls_popup_met_as)   = VALUE wd_this->element_popup_met_as_sel( ).

  wd_this->mo_cc_schdet_tunnel = wd_this->get_cc_schdet_tunnel_ctr( ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->get_static_attributes( IMPORTING static_attributes = ls_popup_met_as ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).                                      ">001< +
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->get_static_attributes( IMPORTING static_attributes = ls_met_popup_vis ).

  IF ls_schichtdetails-edit_mode = abap_true AND
    " ls_popup_met_as-enabled     = abap_true.
    ls_met_popup_vis-enabled  = abap_true.
    wd_this->mo_cc_schdet_tunnel->mo_popup_met_as_sel->subscribe_to_button_event(
      EXPORTING
        action_name =  'SAVE_POPUP_MET'
        action_view =  wd_this->wd_get_api( )
        button      =  99
        button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SECURE' ) ).
  ENDIF.

ENDMETHOD.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactioncancel_action . "#EC NEEDED
ENDMETHOD.

METHOD onactionprocess_event .

  wd_comp_controller->z_pe_osn_tunnel_oss( wdevent ).

ENDMETHOD.

METHOD onactionsave_popup_met .
  wd_this->mo_cc_schdet_tunnel->on_save_popup_met( ).
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
 