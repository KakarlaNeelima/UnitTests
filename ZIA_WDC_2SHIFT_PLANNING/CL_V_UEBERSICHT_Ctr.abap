class CL_V_UEBERSICHT_Ctr implementation.
 
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
  wd_this->mo_cc_uebersicht = wd_this->get_cc_uebersicht_ctr( ).

  wd_comp_controller->render_alv_auftraege( ).
ENDMETHOD.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

method ALV_ON_CELL_ACTION .
    IF r_param->column EQ 'AUFNR' OR r_param->column EQ 'ZZEST'.

    wd_comp_controller->z_pe_uebersicht( io_event = wdevent ).

  ENDIF.
endmethod.

METHOD alv_on_function .
  DATA: ls_auftrag     TYPE wd_this->element_auftraege_alv ##NEEDED.

  CASE r_param->id.

    WHEN: 'BTN_REM_AUF'.
      "Selektiertes Element suchen
      DATA(li_lead_selection) = wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->get_lead_selection( ).

      IF li_lead_selection IS NOT INITIAL.
        li_lead_selection->get_static_attributes( IMPORTING static_attributes = ls_auftrag ).
        wd_comp_controller->z_pe_uebersicht( io_event = wdevent ).

      ENDIF.

    WHEN: 'BTN_AKT_JOBPOOL'.
      wd_comp_controller->z_pe_uebersicht( io_event = wdevent ).
    WHEN: 'BTN_ARBST_ANLEGEN'.
      wd_comp_controller->z_pe_uebersicht( io_event = wdevent ).
  ENDCASE.
ENDMETHOD.

method HANDLEUEBERSICHT_IN . "#EC NEEDED
endmethod.

METHOD onactiongenerate_scripts .
  wd_comp_controller->z_pe_schichtdetails( io_event = wdevent ).
ENDMETHOD.

METHOD onactionprocess_event .
  wd_comp_controller->z_pe_uebersicht( io_event = wdevent ).
ENDMETHOD.

METHOD onactionsearch_aufnr .
  DATA(lv_search_aufnr) = CONV aufnr( '' ).
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_jobpool_suche
           )->get_attribute( EXPORTING name = 'AUFNR' IMPORTING value = lv_search_aufnr ).

  wd_this->mo_cc_uebersicht->search_aufnr_in_jobpool( iv_aufnr = lv_search_aufnr ).

ENDMETHOD.

METHOD on_open_tab_gantt .
  CASE iv_perim.
    WHEN zif_ia_2_constant=>mc_perim-cbt.
      wd_this->fire_to_gantt_cbt_plg( ).
    WHEN zif_ia_2_constant=>mc_perim-gbt.
      wd_this->fire_to_gantt_gbt_plg( ).
  ENDCASE.
ENDMETHOD.

endclass.
 