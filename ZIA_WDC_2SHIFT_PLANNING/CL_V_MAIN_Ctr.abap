class CL_V_MAIN_Ctr implementation.
 
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

METHOD wddoafteraction . "#EC NEEDED
*  wd_this->fire_show_cockpit_plg( ).
ENDMETHOD.

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
  DATA: li_element TYPE REF TO if_wd_context_element. "+>001<

  wd_this->mo_cc_main_schtab = wd_this->get_cc_main_schtab_ctr( ).
  wd_this->mo_cc_gantt       = wd_this->get_cc_gantt_ctr( ).         ">002< (+)


  li_element = wd_context->get_element( ).
  li_element->set_attribute( name = 'SYSTEM_ID'
                             value = |System: { sy-sysid }| ).
ENDMETHOD.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD notify_dispo_on_exit .
  TRY .
      DATA(li_dispo_interface_ctr) = wd_this->wd_cpifc_dispo_cockpit( ).
      li_dispo_interface_ctr->exit_cockpit( ).

    ##NO_HANDLER   CATCH cx_no_check INTO DATA(lx_error) ##NEEDED.
  ENDTRY.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionclose_tab_schicht .
  DATA(ls_tabs_schichten) = VALUE wd_this->element_tabs_schichten( ).            ">001< (+)


  wdevent->get_context_element( name = 'CONTEXT_ELEMENT' )->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).
  IF ls_tabs_schichten-is_gantt_tab = abap_true.
    wd_this->mo_cc_main_schtab->close_tab_gantt( iv_perim = ls_tabs_schichten-gantt_perim ).
    wd_this->fire_show_cockpit_plg( ).
  ELSE.
    DATA(lo_schicht) = wd_comp_controller->get_schicht_from_event( wdevent ).
    wd_this->mo_cc_main_schtab->close_tab_schicht( lo_schicht ).
    wd_this->fire_show_cockpit_plg( ).
  ENDIF.
ENDMETHOD.

method ONACTIONPROCESS_EVENT .
  wd_comp_controller->z_pe_main( io_event = wdevent ).
endmethod.

METHOD onactionshow_details .
  DATA(ls_tabs_schichten) = VALUE wd_this->element_tabs_schichten( ).    ">001< (+)


  DATA(li_element) =  wdevent->get_context_element( EXPORTING name = 'CONTEXT_ELEMENT' ).   ">001< (+) start
  li_element->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).
  IF ls_tabs_schichten-is_gantt_tab = abap_true.
    CASE ls_tabs_schichten-gantt_perim.
      WHEN zif_ia_2_constant=>mc_perim-cbt.
        wd_this->fire_show_gantt_cbt_plg( ).
      WHEN zif_ia_2_constant=>mc_perim-gbt.
        wd_this->fire_show_gantt_gbt_plg( ).
    ENDCASE.
  ELSE.                                                                                     ">001< (+) end
    wd_comp_controller->z_pe_main( io_event = wdevent ).
    wd_this->fire_show_detail_plg( ).
  ENDIF.
ENDMETHOD.

METHOD onactionshow_dispo_cockpit .
  wd_this->fire_show_dispo_cockpit_plg( ).
ENDMETHOD.

METHOD onactionshow_ti_planung .
  wd_this->fire_show_ti_plaung_plg( ).
ENDMETHOD.

METHOD onactionshow_uebersicht .

  wd_this->notify_dispo_on_exit( ).

  wd_comp_controller->z_pe_main( io_event = wdevent ).
  wd_this->fire_show_cockpit_plg( ).
ENDMETHOD.

endclass.
 