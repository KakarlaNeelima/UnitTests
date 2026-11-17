class CL_V_GANTT_GBT_Ctr implementation.
 
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

method WDDOINIT .
  wd_this->mo_cc_gantt = wd_this->get_cc_gantt_ctr( ).
endmethod.

METHOD wddomodifyview .
  "Set page title
  wd_this->set_title( io_view = view ).

  IF first_time = abap_true.
    wd_this->init_gantt_web_socket( view ).
  ENDIF.
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD init_gantt_web_socket .
  DATA lo_html_island TYPE REF TO cl_wd_html_island.


  lo_html_island ?= io_view->get_element( `HTML_ISLAND_GANTT` ).
  lo_html_island->add_script_call( cl_wd_html_script_call=>new_call( )->variable( `MySocket` )->function( `init` )->add_callback_api( )  ).

ENDMETHOD.

METHOD set_title .
  CONSTANTS lc_page_title TYPE string VALUE 'Gantt GBT'.

  DATA lo_page_header TYPE REF TO cl_wd_page_header.
  DATA ls_date_nav    TYPE wd_this->element_date_navigator_gbt ##NEEDED.


  wd_context->get_child_node( name = wd_this->wdctx_date_navigator_gbt )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  lo_page_header ?= io_view->get_element( id = 'PH_GANTT_GBT' ).
  lo_page_header->set_title( value = lc_page_title ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

method HANDLEIN_FROM_MAIN . "#EC NEEDED
endmethod.

method HANDLEIN_FROM_UEBERSICHT . "#EC NEEDED
endmethod.

METHOD onactionon_message .
  wd_this->mo_cc_gantt->open_tab_for_selected_schicht( iv_data = data ).
ENDMETHOD.

METHOD onactionprocess_event .
  CASE wdevent->get_name( ).

    WHEN 'ON_DAY_SELECT'   OR
         'ON_MONTH_SELECT' OR
         'ON_WEEK_SELECT'  OR
         'ON_START_DATE_CHANGED'.
      wd_this->mo_cc_gantt->exc_on_date_selected( iv_perim = zif_ia_2_constant=>mc_perim-gbt ).

    WHEN 'ON_TOGGLE'.
      CASE wdevent->get_string( EXPORTING name = 'ID').

        WHEN 'CKB_RI' OR
             'CKB_JI' OR
             'CKB_TS' OR
             'CKB_LI' OR
             'CKB_TI'.
          wd_this->mo_cc_gantt->exc_on_filter( io_event = wdevent iv_perim = zif_ia_2_constant=>mc_perim-gbt ).

      ENDCASE.
  ENDCASE.
ENDMETHOD.

endclass.
 