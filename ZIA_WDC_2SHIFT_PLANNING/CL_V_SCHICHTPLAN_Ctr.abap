class CL_V_SCHICHTPLAN_Ctr implementation.
 
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
  wd_this->mo_cc_shichtplan = wd_this->get_cc_shichtplan_ctr( ).
ENDMETHOD.

METHOD wddomodifyview .
  DATA: lo_page_header TYPE REF TO cl_wd_page_header,
        ls_date_nav    TYPE wd_this->element_date_navigator.

  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  lo_page_header ?= view->get_element( id = 'PH_SCHICHTPLAN' ).
  lo_page_header->set_title( value = |{ cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIIFT_PLAN' ) } - { ls_date_nav-perimeter }| ).

  wd_this->create_custom_styles( ).
ENDMETHOD.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

METHOD create_custom_styles .
  CONSTANTS: lc_lib_name_standard TYPE wdy_md_ui_element_library  VALUE 'STANDARD',
             lc_elem_type_button  TYPE wdy_md_ui_element_def_name VALUE 'BUTTON',
             lc_name_bg_color     TYPE string                     VALUE 'backgroundColor',
*             lc_value_rgb_purple  TYPE string                     VALUE   'rgb(220, 208, 255)',
*             lc_value_rgb_peach   TYPE string                     VALUE  'rgb(248, 229, 200)',
*             lc_value_rgb_blue    TYPE string                     VALUE   'rgb( 166, 229, 244)',
*             lc_value_rgb_green   TYPE string                     VALUE  'rgb(152, 251, 152)'.
             lc_value_rgb_purple  TYPE string                     VALUE   'rgb(160, 160, 160)',
             lc_value_rgb_peach   TYPE string                     VALUE   'rgb(255, 128, 0)',
             lc_value_rgb_blue    TYPE string                     VALUE   'rgb(0, 102, 204)',
             lc_value_rgb_green   TYPE string                     VALUE   'rgb(0,  255, 0)'.

  DATA(lt_style_prop) = VALUE if_wd_custom_style=>t_style_properties( ).

  DATA(li_custom_style_manager) = wd_comp_controller->wd_get_api( )->get_application( )->get_custom_style_manager( ).

**** start - Schicht Radiobutton BUTTON

  CLEAR lt_style_prop.
  lt_style_prop = VALUE #( ( name = lc_name_bg_color  value = lc_value_rgb_purple ) ).
  li_custom_style_manager->add_custom_style( li_custom_style_manager->create_custom_style( style_class_name = zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_inter_vorg
                                                                                           library_name     = lc_lib_name_standard
                                                                                           element_type     = lc_elem_type_button
                                                                                           style_properties = lt_style_prop )  ).

  lt_style_prop = VALUE #( ( name = lc_name_bg_color  value = lc_value_rgb_peach  ) ).
  li_custom_style_manager->add_custom_style( li_custom_style_manager->create_custom_style( style_class_name = zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_plan_gest
                                                                                           library_name     = lc_lib_name_standard
                                                                                           element_type     = lc_elem_type_button
                                                                                           style_properties = lt_style_prop ) ).

  CLEAR lt_style_prop.
  lt_style_prop = VALUE #( ( name = lc_name_bg_color  value = lc_value_rgb_blue ) ).
  li_custom_style_manager->add_custom_style( li_custom_style_manager->create_custom_style( style_class_name = zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_dispo_frei
                                                                                           library_name     = lc_lib_name_standard
                                                                                           element_type     = lc_elem_type_button
                                                                                           style_properties = lt_style_prop )  ).

  CLEAR lt_style_prop.
  lt_style_prop = VALUE #( ( name = lc_name_bg_color  value = lc_value_rgb_green ) ).
  li_custom_style_manager->add_custom_style( li_custom_style_manager->create_custom_style( style_class_name = zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_freigeben
                                                                                           library_name     = lc_lib_name_standard
                                                                                           element_type     = lc_elem_type_button
                                                                                           style_properties = lt_style_prop )  ).
**** end - Schicht Radiobutton BUTTON
ENDMETHOD.

METHOD get_schicht_from_event .

  DATA(ls_schichtplan) = VALUE wd_this->element_schichtplan( ).

  DATA(li_element) = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
  li_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).

  ro_schicht = ls_schichtplan-object.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD event_open_tab_schicht .
  wd_this->fire_to_details_plg( ).
ENDMETHOD.

METHOD onactionopen_parameters .
  DATA(ls_schichtplan) = VALUE wd_this->element_schichtplan( ).

  DATA(li_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  li_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).

  wd_this->mo_cc_shichtplan->open_schicht_parameters( ls_schichtplan-object ).

  ls_schichtplan-params_tooltip = COND #( WHEN ls_schichtplan-object->has_schicht_parameter( ) EQ abap_true
                                          THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIIFT_PARAMETERS' language = sy-langu  )
                                          ELSE cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIIFT_PARAMETERS' language = sy-langu ) ).

  li_element->set_static_attributes( static_attributes = ls_schichtplan ).
ENDMETHOD.

METHOD onactionprocess_event .
  wd_comp_controller->z_pe_schichtplan( io_event = wdevent ).
ENDMETHOD.

METHOD onactionreset_schicht .
  DATA(lo_schicht) = wd_this->get_schicht_from_event( wdevent ).

  wd_this->mo_cc_shichtplan->open_reset_schicht( lo_schicht ).
ENDMETHOD.

METHOD onactionswitch_edit_mode .
  DATA(li_context_element) = wdevent->get_context_element( name = 'CONTEXT_ELEMENT' ).
  wd_this->mo_cc_shichtplan->set_schicht_editmode( ii_context_element = li_context_element ).

ENDMETHOD.

endclass.
 