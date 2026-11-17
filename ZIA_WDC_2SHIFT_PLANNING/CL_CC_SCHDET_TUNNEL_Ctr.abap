class CL_CC_SCHDET_TUNNEL_Ctr implementation.
 
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

METHOD wddoexit . "#EC NEEDED
ENDMETHOD.

METHOD wddoinit . "#EC NEEDED
ENDMETHOD.

METHOD get_curr_schicht .
  DATA(ls_tab_schichten) = VALUE wd_this->element_tabs_schichten( ).
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).
  ro_schicht = ls_tab_schichten-object.
ENDMETHOD.

METHOD lock_fahrzeuge .
  IF io_fahrzeuge IS NOT BOUND.
    DATA(lo_fahrzeuge) = wd_this->get_curr_schicht( )->get_fahrzeuge( ).
  ELSE.
    lo_fahrzeuge = io_fahrzeuge.
  ENDIF.

  DATA(lo_fahrzeuge_i) = CAST cl_object_collection_iterator( lo_fahrzeuge->get_values_iterator( ) ).
  lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).
  WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
    TRY.
        IF iv_met_only IS NOT INITIAL.
          CHECK lo_fahrzeug->get_fahrzeugtyp( )-zmet = abap_true.
        ENDIF.
        lo_fahrzeug->lock( ).
      CATCH zcx_ia_2failure INTO DATA(lx_exc).
        wd_comp_controller->mo_message_manager->display_exception( lx_exc ).
    ENDTRY.
  ENDWHILE.

ENDMETHOD.

METHOD on_save_popup_met .
  CONSTANTS lc_met_sedrun     TYPE zia_2_id_eiz VALUE 10.
  CONSTANTS lc_met_faido      TYPE zia_2_id_eiz VALUE 20.
  CONSTANTS lc_met_prefix_n   TYPE zia_2_met_as_name_prefix VALUE 'N'.
  CONSTANTS lc_met_prefix_s   TYPE zia_2_met_as_name_prefix VALUE 'S'.

  DATA(lt_popup_met) = VALUE wd_this->elements_popup_met_as_sel( ).


  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->get_static_attributes_table( IMPORTING table = lt_popup_met ).
  DATA(lo_schicht) = wd_this->get_curr_schicht( ).

  IF lt_popup_met IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lv_eiz) = COND zia_2_id_eiz( WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed THEN lc_met_sedrun
                                  WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad THEN lc_met_faido ).

  wd_this->remove_met( ).

  ASSIGN lt_popup_met[ met_selected = abap_true ] TO FIELD-SYMBOL(<ls_popup_met>).
  IF sy-subrc = 0.
    DATA(ls_met) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lv_eiz ).
    <ls_popup_met>-zobject->set_met( iv_id_met = ls_met-zid_met ).
    DATA(lv_as_prefix) = COND #( WHEN <ls_popup_met>-zobject->get_data( )-zid_eiz = lc_met_sedrun THEN lc_met_prefix_n
                                 WHEN <ls_popup_met>-zobject->get_data( )-zid_eiz = lc_met_faido  THEN lc_met_prefix_s ).
    <ls_popup_met>-zobject->set_met_as_name_prefix( lv_as_prefix ).
    <ls_popup_met>-zobject->save( ).
    lo_schicht->set_tremola_calculated( abap_false ).
    lo_schicht->save( ).
    lo_schicht->reload( ).
    wd_this->lock_fahrzeuge( iv_met_only = abap_true ).
    wd_this->mo_popup_met_as_sel->close( ).
    wd_comp_controller->mo_curr_arbstelle = lo_schicht->get_arbeitsstelle_by_id( <ls_popup_met>-zobject->get_id( ) ).
  ENDIF.

  lo_schicht->save( ).
  lo_schicht->reload( ).
  wd_comp_controller->invctx_schichtdetails( ).
  wd_this->mo_popup_met_as_sel->close( ).

ENDMETHOD.

METHOD remove_met .
  CONSTANTS lc_met_as_prefix_init TYPE zia_2_met_as_name_prefix VALUE ''.

  DATA(lo_schicht) = wd_this->get_curr_schicht( ).

  DATA(lo_arbeitsstelle_i) = CAST cl_object_collection_iterator(  lo_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).
  WHILE lo_arbeitsstelle_i->has_next( ) = abap_true.

    DATA(lo_arbeitsstelle) = CAST zcl_ia_2wrkplace( lo_arbeitsstelle_i->get_next( ) ).
    CHECK lo_arbeitsstelle->has_met( ) = abap_true.
    lo_arbeitsstelle->remove_met( ).
    lo_arbeitsstelle->set_met_as_name_prefix( iv_prefix = lc_met_as_prefix_init ). ">001<  (+)

  ENDWHILE.

  wd_comp_controller->mo_curr_arbstelle = lo_schicht->get_first_arbeitsstelle( ).

ENDMETHOD.

METHOD set_met .
  DATA lt_filter_as TYPE HASHED TABLE OF zif_ia_2_met=>tv_mark_nas WITH UNIQUE KEY table_line.


  DATA(lo_schicht) = wd_this->get_curr_schicht( ).
  DATA(ls_met)     = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = iv_eiz ).

  IF ls_met IS INITIAL.  "Only sperrabschnitt W or E are valid
    RETURN.
  ENDIF.

  DATA(lt_nearest_as) = zcl_ia_2met=>zif_ia_2_met~get_nearest_as( EXPORTING io_schicht = lo_schicht  iv_eiz = iv_eiz ).

  IF line_exists( lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]  ).
    DATA(lo_as) = lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]-object.
    lo_as->set_met( iv_id_met = ls_met-zid_met ).
    lo_as->save( ).
  ELSE.
    lt_filter_as = VALUE #( ( zif_ia_2_met=>mc_mark_nas-low ) ( zif_ia_2_met=>mc_mark_nas-high ) ).
    wd_this->mt_nearest_as = FILTER #( lt_nearest_as IN lt_filter_as WHERE mark = table_line ).
    wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->invalidate( ).
    wd_this->show_popup_met_as_sel( ).
  ENDIF.

ENDMETHOD.

METHOD show_popup_met_as_sel .
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).       ">001< +
  DATA(ls_button)         = VALUE wdr_popup_button_definition( ).           ">001< +
  DATA(ls_met_popup_vis)  = VALUE wd_this->element_popup_met_as_sel_vis( ). ">001< +


  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->get_static_attributes( IMPORTING static_attributes = ls_met_popup_vis ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ). ">001< +

  DATA(li_window_manager) = wd_comp_controller->wd_get_api( )->get_window_manager( ).
  DATA(lt_buttons) = li_window_manager->get_buttons_close( ).

  ">001< + start
  IF ls_schichtdetails-edit_mode = abap_true AND
     ls_met_popup_vis-enabled     = abap_true.
    ls_button = VALUE #(  button     = 99
                          text       =  cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SECURE' )
                          action     = VALUE wdr_popup_button_action( action_name = 'SAVE_POPUP_MET' )
                          is_enabled = abap_true ).
    INSERT ls_button INTO lt_buttons INDEX 1.
  ENDIF.


**

  wd_this->mo_popup_met_as_sel = li_window_manager->create_and_open_popup( "#EC RECEIVING_USAGE
    EXPORTING
      window_name          = 'W_POPUP_MET_AS_SEL'
      title                = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SELECT_JOB_POSITION' )
      message_type         = if_wd_window=>co_msg_type_none
      message_display_mode = if_wd_window=>co_msg_display_mode_selected
      buttons              = lt_buttons ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_add_met_to_as .
  CONSTANTS lc_icon_delete  TYPE string     VALUE '~Icon/Delete'.                ">001< +
  CONSTANTS lc_icon_ad_tech TYPE string     VALUE '~Icon/AdaptationTechnical'.   ">001< +
  CONSTANTS lc_icon_done    TYPE string     VALUE '~Icon/Done'.                  ">001< +

  DATA(ls_neares_as) = VALUE wd_this->element_popup_met_as_sel( ).
  DATA(lt_popup_met) = VALUE wd_this->elements_popup_met_as_sel( ).              ">001< +
  DATA(lv_selected)  = VALUE abap_bool( ).                                       ">001< +

  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->get_static_attributes_table( IMPORTING table = lt_popup_met ). ">001< +

  DATA(lo_schicht) = wd_this->get_curr_schicht( ).
  io_event->get_context_element( name = 'CONTEXT_ELEMENT' )->get_static_attributes( IMPORTING static_attributes = ls_neares_as ).
  DATA(ls_met) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = ls_neares_as-zobject->get_data( )-zid_eiz ) ##NEEDED.

  ">001< (+) start
  LOOP AT lt_popup_met ASSIGNING FIELD-SYMBOL(<ls_popup_met>).
    IF <ls_popup_met>-zobject->get_id( ) = ls_neares_as-zobject->get_id( ).
      lv_selected = SWITCH #( ls_neares_as-met_selected WHEN abap_false THEN abap_true ELSE abap_false ).
      <ls_popup_met>-icon_met_add    = COND #( WHEN lv_selected = abap_true THEN lc_icon_delete ELSE lc_icon_ad_tech ).
      <ls_popup_met>-icon_met_status = COND #( WHEN lv_selected = abap_true THEN lc_icon_done   ELSE abap_false ).
      <ls_popup_met>-met_selected    = lv_selected.
    ELSE.
      <ls_popup_met>-icon_met_add    = lc_icon_ad_tech.
      <ls_popup_met>-icon_met_status = abap_false.
      <ls_popup_met>-met_selected    = abap_false.
    ENDIF.
  ENDLOOP.

  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->bind_table(    ">001< (+)
    EXPORTING new_items = lt_popup_met set_initial_elements = abap_true ).             ">001< (+)

ENDMETHOD.

METHOD on_btn_met_fad .
  CONSTANTS lc_eiz_fad TYPE zia_2_id_eiz VALUE 20.

  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  DATA(ls_met_popup_vis)  = VALUE wd_this->element_popup_met_as_sel_vis( ).
  DATA(lv_eiz)            = VALUE zia_2_id_eiz( ) ##NEEDED.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->get_static_attributes( IMPORTING static_attributes = ls_met_popup_vis ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->invalidate( ).

  DATA(lo_schicht)  = wd_this->get_curr_schicht( ).
  DATA(lv_met_type) = lo_schicht->get_met_type( ).

  ls_met_popup_vis-popup_desc = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MET_AS_SEL_TITLE_FAD' ).

  IF ls_schichtdetails-edit_mode = abap_true.
    ls_met_popup_vis-enabled = abap_true.
    IF lv_met_type IS NOT INITIAL.
      ls_met_popup_vis-enabled = COND #( WHEN lv_met_type <> zif_ia_2_met=>mc_met_type-fad THEN abap_false ELSE ls_met_popup_vis-enabled ).
    ENDIF.
  ELSE.
    ls_met_popup_vis-enabled = abap_false.
  ENDIF.

  "Arbeitsstelle Buttons - set default values
  ls_met_popup_vis-enabled_btn_create_as_n = COND #( WHEN ls_schichtdetails-edit_mode = abap_true THEN abap_true ELSE abap_false ).
  ls_met_popup_vis-enabled_btn_create_as_s = COND #( WHEN ls_schichtdetails-edit_mode = abap_true THEN abap_true ELSE abap_false ).

  "Get nearest AS
  DATA(lt_nearest_as) = zcl_ia_2met=>zif_ia_2_met~get_nearest_as_all( EXPORTING io_schicht = lo_schicht iv_eiz = lc_eiz_fad ).

  "Arbeitsstelle S Button
  IF line_exists( lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]  ).
    ls_met_popup_vis-enabled_btn_create_as_n = abap_false.
    ls_met_popup_vis-enabled_btn_create_as_s = abap_false.
  ENDIF.

  "Arbeitsstelle S Button
  DATA(ls_nearest_as_low)  = VALUE #( lt_nearest_as[ mark = zif_ia_2_met=>mc_mark_nas-low ]  OPTIONAL ).

  "The "N" AS cannot be cretaed as MET Fad. if "S" AS is to the left of MET Fad.
  IF ls_nearest_as_low IS NOT INITIAL.
    IF ls_nearest_as_low-object->get_data( )-zid_eiz  = lc_eiz_fad.
      ls_met_popup_vis-enabled_btn_create_as_n = abap_false.
    ENDIF.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->set_static_attributes( EXPORTING static_attributes = ls_met_popup_vis ).
  wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad.
  wd_this->show_popup_met_as_sel( ).

ENDMETHOD.

METHOD on_btn_met_sed .
  CONSTANTS lc_eiz_sed TYPE zia_2_id_eiz VALUE 10.

  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  DATA(ls_met_popup_vis)  = VALUE wd_this->element_popup_met_as_sel_vis( ).
  DATA(lv_eiz)            = VALUE zia_2_id_eiz( ) ##NEEDED.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->get_static_attributes( IMPORTING static_attributes = ls_met_popup_vis ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->invalidate( ).


  DATA(lo_schicht)  = wd_this->get_curr_schicht( ).
  DATA(lv_met_type) = lo_schicht->get_met_type( ).
*
  ls_met_popup_vis-popup_desc = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MET_AS_SEL_TITLE_SED' ).
*
  IF ls_schichtdetails-edit_mode = abap_true.
    ls_met_popup_vis-enabled = abap_true.
    IF lv_met_type IS NOT INITIAL.
      ls_met_popup_vis-enabled = COND #( WHEN lv_met_type <> zif_ia_2_met=>mc_met_type-sed THEN abap_false ELSE ls_met_popup_vis-enabled ).
    ENDIF.
  ELSE.
    ls_met_popup_vis-enabled = abap_false.
  ENDIF.
*
*  "Arbeitsstelle Buttons - set default values
  ls_met_popup_vis-enabled_btn_create_as_n = COND #( WHEN ls_schichtdetails-edit_mode = abap_true THEN abap_true ELSE abap_false ).
  ls_met_popup_vis-enabled_btn_create_as_s = COND #( WHEN ls_schichtdetails-edit_mode = abap_true THEN abap_true ELSE abap_false ).
*
*  "Get nearest AS
  DATA(lt_nearest_as) = zcl_ia_2met=>zif_ia_2_met~get_nearest_as_all( EXPORTING io_schicht = lo_schicht iv_eiz = lc_eiz_sed ).
*
*  "Arbeitsstelle N/S Buttons
  IF line_exists( lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]  ).
    ls_met_popup_vis-enabled_btn_create_as_n = abap_false.
    ls_met_popup_vis-enabled_btn_create_as_s = abap_false.
  ENDIF.
*
*  "Arbeitsstelle S Button
  DATA(ls_nearest_as_high) = VALUE #( lt_nearest_as[ mark = zif_ia_2_met=>mc_mark_nas-high ] OPTIONAL ).
*
*  "The "S" AS cannot be cretaed as MET Sed. if "N" AS is to the right of MET Sed.
  IF ls_nearest_as_high IS NOT INITIAL.
    IF ls_nearest_as_high-object->get_data( )-zid_eiz = lc_eiz_sed.
      ls_met_popup_vis-enabled_btn_create_as_s = abap_false.
    ENDIF.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel_vis )->set_static_attributes( EXPORTING static_attributes = ls_met_popup_vis ).
  wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed.
  wd_this->show_popup_met_as_sel( ).

ENDMETHOD.

METHOD on_met_create_as .
  DATA(lo_schicht) = wd_this->get_curr_schicht( ).
  DATA(lv_eiz) = COND zia_2_id_eiz( WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed THEN 10
                                  WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad THEN 20 ).

  DATA(ls_met) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lv_eiz ).
  DATA(lo_as)  = zcl_ia_2met=>zif_ia_2_met~create_as( io_schicht = lo_schicht  iv_id_met = ls_met-zid_met ).

  IF lo_as IS NOT BOUND.
    RETURN.
  ENDIF.
*
  lo_as->set_met( iv_id_met = ls_met-zid_met ).
  lo_schicht->add_arbeitsstelle( lo_as ).
  lo_schicht->save( ).
  lo_schicht->reload( ).
*
  wd_this->lock_fahrzeuge( ).
  wd_this->mo_popup_met_as_sel->close( ).
  wd_comp_controller->mo_curr_arbstelle = lo_as.
  wd_comp_controller->invctx_schichtdetails( ).

ENDMETHOD.

METHOD on_met_create_as_n .
  CONSTANTS lc_met_sedrun    TYPE zia_2_id_eiz VALUE 10.
  CONSTANTS lc_met_faido     TYPE zia_2_id_eiz VALUE 20.
  CONSTANTS lc_met_as_prefix TYPE zia_2_met_as_name_prefix VALUE 'N'.

  DATA(lo_schicht) = wd_this->get_curr_schicht( ).
  DATA(lv_eiz)     = COND zia_2_id_eiz( WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed THEN lc_met_sedrun
                                      WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad THEN lc_met_faido ).
  DATA(ls_met)     = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lv_eiz ).
  DATA(lo_as)      = zcl_ia_2met=>zif_ia_2_met~create_as( io_schicht = lo_schicht  iv_id_met = ls_met-zid_met iv_id_eiz = lc_met_sedrun ).

  IF lo_as IS NOT BOUND.
    RETURN.
  ENDIF.

  lo_as->set_met( iv_id_met = ls_met-zid_met ).
  lo_as->set_met_as_name_prefix( iv_prefix = lc_met_as_prefix ).
  lo_schicht->add_arbeitsstelle( lo_as ).
  lo_schicht->save( ).
  lo_schicht->reload( ).

  wd_this->lock_fahrzeuge( ).
  wd_this->mo_popup_met_as_sel->close( ).
  wd_comp_controller->mo_curr_arbstelle = lo_as.
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->invalidate( ).
  wd_comp_controller->invctx_schichtdetails( ).

ENDMETHOD.

METHOD on_met_create_as_s .
  CONSTANTS lc_met_sedrun    TYPE zia_2_id_eiz VALUE 10.
  CONSTANTS lc_met_faido     TYPE zia_2_id_eiz VALUE 20.
  CONSTANTS lc_met_as_prefix TYPE zia_2_met_as_name_prefix VALUE 'S'.

  DATA(lo_schicht) = wd_this->get_curr_schicht( ).
  DATA(lv_eiz)     = COND zia_2_id_eiz( WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed THEN lc_met_sedrun
                                      WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad THEN lc_met_faido ).
  DATA(ls_met)     = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lv_eiz ).
  DATA(lo_as)      = zcl_ia_2met=>zif_ia_2_met~create_as( io_schicht = lo_schicht  iv_id_met = ls_met-zid_met iv_id_eiz = lc_met_faido ).

  IF lo_as IS NOT BOUND.
    RETURN.
  ENDIF.

  lo_as->set_met( iv_id_met = ls_met-zid_met ).
  lo_as->set_met_as_name_prefix( iv_prefix = lc_met_as_prefix ).
  lo_schicht->add_arbeitsstelle( lo_as ).
  lo_schicht->save( ).
  lo_schicht->reload( ).

  wd_this->lock_fahrzeuge( ).
  wd_this->mo_popup_met_as_sel->close( ).
  wd_comp_controller->mo_curr_arbstelle = lo_as.
  wd_context->get_child_node( name = wd_this->wdctx_popup_met_as_sel )->invalidate( ).
  wd_comp_controller->invctx_schichtdetails( ).

ENDMETHOD.

METHOD on_select_ckb_met_fad .
  CONSTANTS lc_eiz TYPE zia_2_id_eiz VALUE '20'.
  DATA(ls_schicht_det) = VALUE wd_this->element_schichtdetails( ).


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schicht_det ).
  wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad.

  IF ls_schicht_det-is_met_40_faido_active = abap_true.
    wd_this->set_met( lc_eiz ).
  ELSE.
    wd_this->remove_met( ).
  ENDIF.

  wd_this->lock_fahrzeuge( iv_met_only = abap_true ).
  wd_this->get_curr_schicht( )->set_tremola_calculated( abap_false ).
  wd_this->get_curr_schicht( )->save( ).

  wd_comp_controller->invctx_schichtdetails( ).

ENDMETHOD.

METHOD on_select_ckb_met_sed .
  CONSTANTS lc_eiz TYPE zia_2_id_eiz VALUE '10'.
  DATA(ls_schicht_det) = VALUE wd_this->element_schichtdetails( ).


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schicht_det ).
  wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed.

  IF ls_schicht_det-is_met_20_sedrun_active = abap_true.
    wd_this->set_met( lc_eiz ).
  ELSE.
    wd_this->remove_met( ).
  ENDIF.

  wd_this->lock_fahrzeuge( iv_met_only = abap_true ).
  wd_this->get_curr_schicht( )->set_tremola_calculated( abap_false ).
  wd_this->get_curr_schicht( )->save( ).

  wd_comp_controller->mo_curr_arbstelle =  wd_this->get_curr_schicht( )->get_arbeitsstelle_by_id( wd_comp_controller->mo_curr_arbstelle->get_id( ) ).
  wd_comp_controller->invctx_schichtdetails( ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_popup_met_as_sel .
  CONSTANTS lc_met_sedrun   TYPE zia_2_id_eiz VALUE 10.   ">001< +
  CONSTANTS lc_met_faido    TYPE zia_2_id_eiz VALUE 20.   ">001< +
  CONSTANTS lc_icon_delete  TYPE string     VALUE '~Icon/Delete'.
  CONSTANTS lc_icon_ad_tech TYPE string     VALUE '~Icon/AdaptationTechnical'.
  CONSTANTS lc_icon_done    TYPE string     VALUE '~Icon/Done'.

  DATA(lt_met_as_sel)     = VALUE wd_this->elements_popup_met_as_sel( ).
  DATA(lt_nearest_as_tmp) = VALUE zif_ia_2_met=>tt_nearest_as( )  ##NEEDED.                              ">001< +
  DATA lt_filter_as TYPE HASHED TABLE OF zif_ia_2_met=>tv_mark_nas WITH UNIQUE KEY table_line.  ">001< +


  CLEAR wd_this->mt_nearest_as.  ">001< +
  DATA(lo_schicht) = wd_this->get_curr_schicht( ).

*  >001< begin +
  DATA(lv_eiz) = COND zia_2_id_eiz( WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-sed THEN lc_met_sedrun
                                  WHEN wd_this->mv_selected_met = zif_ia_2_met=>mc_met_type-fad THEN lc_met_faido ).

  DATA(lt_nearest_as) = zcl_ia_2met=>zif_ia_2_met~get_nearest_as_all( EXPORTING io_schicht = lo_schicht  iv_eiz = lv_eiz ).
  lt_filter_as        = VALUE #( ( zif_ia_2_met=>mc_mark_nas-low ) ( zif_ia_2_met=>mc_mark_nas-high ) ).
  IF line_exists( lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]  ).
    ASSIGN lt_nearest_as[ KEY mark mark = zif_ia_2_met=>mc_mark_nas-central ] TO FIELD-SYMBOL(<ls_nearest_as_central>).
    APPEND <ls_nearest_as_central> TO wd_this->mt_nearest_as.
  ELSEIF NOT line_exists( lt_nearest_as[ KEY mark COMPONENTS mark = zif_ia_2_met=>mc_mark_nas-central ]  ).
    lt_nearest_as_tmp = FILTER #( lt_nearest_as IN lt_filter_as WHERE mark = table_line ).
    APPEND LINES OF lt_nearest_as TO wd_this->mt_nearest_as.
  ENDIF.
*  >001< end +


  LOOP AT wd_this->mt_nearest_as ASSIGNING FIELD-SYMBOL(<ls_nearest_as>) WHERE mark IS NOT INITIAL.

    DATA(ls_met) = zcl_ia_2met=>zif_ia_2_met~get_met( iv_est = lo_schicht->get_rj_est( ) iv_eiz = lv_eiz ).  ">001< (+)

    APPEND VALUE #( zobject = <ls_nearest_as>-object ) TO lt_met_as_sel ASSIGNING FIELD-SYMBOL(<ls_met_as_sel>).
    <ls_met_as_sel>-zarbstl = <ls_met_as_sel>-zobject->get_kurztext( abap_false ).

    ">001< begin +
    <ls_met_as_sel>-icon_met_add    = COND #( WHEN <ls_met_as_sel>-zobject->has_met( ) THEN lc_icon_delete ELSE lc_icon_ad_tech ).
    <ls_met_as_sel>-icon_met_status = COND #( WHEN <ls_met_as_sel>-zobject->has_met( ) THEN lc_icon_done ).
    <ls_met_as_sel>-met_selected    = COND #( WHEN <ls_met_as_sel>-zobject->has_met( ) THEN abap_true ELSE abap_false ).
    <ls_met_as_sel>-mark            = <ls_nearest_as>-mark.
    <ls_met_as_sel>-id_eiz          = <ls_nearest_as>-object->get_data( )-zid_eiz.
    ">001< end +

    CASE <ls_nearest_as>-mark.
      WHEN zif_ia_2_met=>mc_mark_nas-low.
        <ls_met_as_sel>-zdistanz = abs( ls_met-zkm - <ls_nearest_as>-object->get_data( )-zkmax ).
        <ls_met_as_sel>-zseite = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/NORTH' ).
      WHEN zif_ia_2_met=>mc_mark_nas-high.
        <ls_met_as_sel>-zdistanz = abs( ls_met-zkm - <ls_nearest_as>-object->get_data( )-zkmin ).
        <ls_met_as_sel>-zseite = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SOUTH' ).
      WHEN OTHERS.
        CONTINUE.
    ENDCASE.
  ENDLOOP.

  node->bind_table( new_items = lt_met_as_sel  set_initial_elements = abap_true ).

ENDMETHOD.

endclass.
 