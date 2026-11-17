class CL_V_OSN_TUNNEL_OSS_Ctr implementation.
 
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
  wd_this->mo_cc_shichtplan    = wd_this->get_cc_shichtplan_ctr( ).
  wd_this->mo_cc_main_schtab   = wd_this->get_cc_main_schtab_ctr( ).
  wd_this->mo_cc_schdet_tunnel = wd_this->get_cc_schdet_tunnel_ctr( ).

ENDMETHOD.

METHOD wddomodifyview .
  wd_context->get_child_node( name = wd_this->wdctx_met )->invalidate( ).
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

method GET_SCHICHT_FROM_CONTEXT .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = `OBJECT`
                                                                              IMPORTING value = ro_schicht ).
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionopen_parameters .
  DATA lo_schicht TYPE REF TO zcl_ia_2workshift.
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = `OBJECT`
                                                                                     IMPORTING value = lo_schicht ).
  wd_this->mo_cc_shichtplan->open_schicht_parameters( lo_schicht ).
ENDMETHOD.

METHOD onactionprocess_event .
  wd_comp_controller->z_pe_osn_tunnel_oss( io_event = wdevent ).
ENDMETHOD.

METHOD onactionreset_schicht .
  DATA lo_schicht TYPE REF TO zcl_ia_2workshift.

  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = `OBJECT`
                                                                              IMPORTING value = lo_schicht ).

  wd_this->mo_cc_shichtplan->open_reset_schicht( lo_schicht ).
ENDMETHOD.

METHOD onactionselect_arbst .
  wd_comp_controller->z_pe_osn_tunnel_oss( io_event = wdevent ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

method SUPPLY_JL_VALUE_SUGGESTIONS . "#EC NEEDED
endmethod.

METHOD supply_met .
  CONSTANTS lc_eiz_sed TYPE zia_2_id_eiz VALUE 10.
  CONSTANTS lc_eiz_fad TYPE zia_2_id_eiz VALUE 20.

  DATA(ls_met)                 = VALUE wd_this->element_met( ).
  DATA(ls_schichtdetails)      = VALUE wd_this->element_schichtdetails( ).
  DATA(lv_zugeornet_txt)       = VALUE string( ).
  DATA(lv_nicht_zugeornet_txt) = VALUE string( ).

  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  DATA(lo_schicht) = wd_this->mo_cc_schdet_tunnel->get_curr_schicht( ).


  IF ls_schichtdetails-is_met_20_sedrun_active = abap_true OR
     ls_schichtdetails-is_met_40_faido_active  = abap_true.
    DATA(lv_as_name) = ls_schichtdetails-object->get_met_as_name( ).
  ENDIF.

  lv_zugeornet_txt        = |{ cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MET_ASSOCIATED_WITH' ) } | & |{ lv_as_name }|.
  lv_nicht_zugeornet_txt  = |{ cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MET_NOT_ASSIGNED' ) }|.
  ls_met-btn_met_sed_text = COND #( WHEN ls_schichtdetails-is_met_20_sedrun_active = abap_true THEN lv_zugeornet_txt ELSE lv_nicht_zugeornet_txt ).
  ls_met-btn_met_fad_text = COND #( WHEN ls_schichtdetails-is_met_40_faido_active  = abap_true THEN lv_zugeornet_txt ELSE lv_nicht_zugeornet_txt ).

  DATA(ls_met_sed) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lc_eiz_sed ).
  DATA(ls_met_fad) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lc_eiz_fad ).
  IF ls_met_sed-zid_met IS INITIAL AND
     ls_met_fad-zid_met IS INITIAL.
    ls_met-btn_met_fad_enabled = abap_false.
    ls_met-btn_met_sed_enabled = abap_false.
  ELSE.
    ls_met-btn_met_sed_enabled = abap_true.
    ls_met-btn_met_fad_enabled = abap_true.
  ENDIF.


  node->bind_structure(
    new_item             =  ls_met
    set_initial_elements = abap_true ).
*
ENDMETHOD.

endclass.
 