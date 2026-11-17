class CL_CC_SHICHTPLAN_Ctr implementation.
 
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

METHOD wddoinit .
  wd_this->mc_popup_reset_schicht = `POPUP_RESET_SCHICHT`.
  wd_this->mc_param_schicht = `SCHICHT`.

  wd_this->init_user_statuses( ).
ENDMETHOD.

METHOD adjust_schichtplan_sta .
  DATA(ls_schicht) = VALUE zia_2wrkshifts( ).

  IF is_schicht IS NOT INITIAL.
    ls_schicht = CORRESPONDING #( is_schicht ).
  ELSEIF iv_schicht IS NOT INITIAL.
**    SELECT SINGLE * INTO CORRESPONDING FIELDS OF @ls_schicht FROM viqmel WHERE qmnum = @iv_schicht.
    ls_schicht = wd_assist->get_shift( iv_qmnum = iv_schicht ).
  ENDIF.

  IF ls_schicht-zschicht IS NOT INITIAL.
    MOVE-CORRESPONDING ls_schicht TO cs_schichtplan.
  ENDIF.
  CHECK cs_schichtplan-zschicht IS NOT INITIAL.

  cs_schichtplan-beschr = |{ zcl_ia_2utilities=>get_dats_as_formated_string( ls_schicht-start_datum ) } / {
                           ls_schicht-start_zeit(2) }:{ ls_schicht-start_zeit+2(2) } - { ls_schicht-end_zeit(2) }:{ ls_schicht-end_zeit+2(2) }|.

  cs_schichtplan-show_edit_btn = abap_true.

  READ TABLE it_tabs_schichten WITH KEY zschicht = cs_schichtplan-zschicht ASSIGNING FIELD-SYMBOL(<ls_tabs_schichten>).
  cs_schichtplan-object = COND #( WHEN <ls_tabs_schichten> IS ASSIGNED
                                  THEN <ls_tabs_schichten>-object
                                  ELSE COND #( WHEN cs_schichtplan-object IS NOT BOUND
                                               THEN NEW zcl_ia_2workshift( iv_zschicht = cs_schichtplan-zschicht )
                                               ELSE cs_schichtplan-object )
                                ).


  cs_schichtplan-edit_mode      = abap_false.
  cs_schichtplan-notes_visibile = abap_false.
  cs_schichtplan-design         = 00.
  cs_schichtplan-show_edit_btn  = abap_true.

  cs_schichtplan-tooltip = |ID: { cs_schichtplan-zschicht ALPHA = OUT }|. "+>001<

  DATA(lv_supply_type) = cs_schichtplan-object->get_parameter( )->get_data( )-supply_type.
  IF lv_supply_type IS NOT INITIAL.
    DATA(lv_supply_type_txt) = COND #( WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung
                                THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_VERSORGUNGSSCHICHT' )
                                WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung
                                THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_ENTSORGUNG' )
                                WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt
                                THEN cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/NO_RIDE' ) ).
*                                  ELSE cl_wd_utilities=>get_otr_text_by_alias( 'ZIA_2GBT_PG2/AS_KEINE_LOGISTIKSCHICHT' ) ).
    IF lv_supply_type_txt IS NOT INITIAL.
      cs_schichtplan-tooltip = |{ cs_schichtplan-tooltip } / { lv_supply_type } ({ lv_supply_type_txt })|.
    ENDIF.
  ENDIF.

DATA(lv_status) = cs_schichtplan-object->get_status( ).
IF lv_status = zif_ia_2_wrkshft_status=>mc_interval_provided OR
   lv_status = zif_ia_2_wrkshft_status=>mc_plannig_started   OR
   lv_status = zif_ia_2_wrkshft_status=>mc_disposition_released.
  IF cs_schichtplan-object->is_locked( ).
    cs_schichtplan-edit_mode      = abap_true.
    cs_schichtplan-notes_visibile = abap_true.
    cs_schichtplan-design         = 01.
  ENDIF.
ELSE.
  cs_schichtplan-show_edit_btn  = abap_false.
ENDIF.

* Check edit authority for Erhaltungsplaner
DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
IF ls_auth_erhaltungsplaner-auth_erhaltungsplaner IS INITIAL.
  cs_schichtplan-show_edit_btn = abap_false.
ENDIF.
***
*** >002<  ### End ###
***

cs_schichtplan-style_schichtp_status = wd_this->get_schichtplan_status_icon( cs_schichtplan-zstatus ). "+>001<

" Beschreibung der Schicht zusätzlich Intervallart und Sperrabschnitt.
cs_schichtplan-beschr_2 = cs_schichtplan-object->get_bezeichnung_schicht( ).

"Tooltip für Schichtparameter, sind Schichtparameter definiert oder werden Standardparameter verwendet?
cs_schichtplan-params_tooltip = COND #( WHEN cs_schichtplan-object->has_schicht_parameter( ) EQ abap_true
                                        THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFTPARAMETER'  language = sy-langu  )
                                        ELSE cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFTPARAMETER' language = sy-langu ) ).

IF cs_schichtplan-object->get_notes( ) IS NOT INITIAL. "Bemerkungen vorhanden.
  cs_schichtplan-notes_icon     = '~Icon/PlaintextFile'.
  cs_schichtplan-notes_tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS_EXIST' ).
  cs_schichtplan-notes_visibile = abap_true.
*    cs_schichtplan-notes_visibile = COND #( WHEN cs_schichtplan-edit_mode EQ abap_true THEN abap_true ELSE abap_false ).
*    cs_schichtplan-notes_visibile = COND #( WHEN cs_schichtplan-edit_mode EQ abap_true OR sy-subrc = 0 THEN abap_true ELSE abap_false ).
ELSE.
  cs_schichtplan-notes_icon    = '~Icon/NewItem'.
  cs_schichtplan-notes_tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS_CREATE' ).
ENDIF.
ENDMETHOD.

METHOD change_auftrag_status .
  CHECK io_arbeitsstelle IS BOUND.

  DATA(lv_schicht_status) = io_arbeitsstelle->get_schicht( )->get_data( )-zstatus.

  CASE lv_schicht_status.
    WHEN zif_ia_2_wrkshft_status=>mc_disposition_released.
      wd_this->change_auftrag_status_s20( io_arbeitsstelle = io_arbeitsstelle
                                          io_auftrag       = io_auftrag ).

    WHEN OTHERS.
      RETURN.
  ENDCASE.

ENDMETHOD.

METHOD change_auftrag_status_s20 .
  CHECK io_arbeitsstelle IS BOUND.
  CHECK io_auftrag IS BOUND.

  DATA(lo_auftraege) = NEW cl_object_map( ).
  lo_auftraege->put( key = io_auftrag->get_id( ) value = io_auftrag ).

  zcl_ia_2order_utils=>change_user_status( io_auftraege   = lo_auftraege
                                                io_schicht     = io_arbeitsstelle->get_schicht( )
                                                iv_status      =  'PL2'
                                                iv_arbzeit_upd = abap_false
                                              ).
  io_auftrag->set_arbstl_arbeitszeit( io_arbstl  = io_arbeitsstelle
                                      iv_save_db = abap_true ).
ENDMETHOD.

METHOD exc_on_filter .
  wd_this->invalidate_schichtplan( ).
  wd_this->invalidate_auftraege_alv( ).
  wd_comp_controller->mo_personalization_ctr->save_new( ).
ENDMETHOD.

METHOD filter_schichtplan .
  DATA(ls_filter) = VALUE wd_this->element_schichtplan_filters( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtplan_filters )->get_static_attributes( IMPORTING static_attributes = ls_filter ).

  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    DATA(lt_sp_schicht)  = <ls_data>-object->get_sp_schicht( ).
    <ls_data>-is_visible = abap_false.

    IF ls_filter-ri = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-ri ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF ls_filter-ji = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-ji ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF ls_filter-li = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-li ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF ls_filter-ti = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-ti ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF ls_filter-ts = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-ts ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.
  ENDLOOP.

  DELETE ct_data WHERE is_visible = abap_false.
ENDMETHOD.

METHOD get_schichtplan_status_icon .
  rv_icon = SWITCH string( iv_status
                      WHEN zif_ia_2_wrkshft_status=>mc_interval_provided
                        THEN zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_inter_vorg   "Purple
                      WHEN zif_ia_2_wrkshft_status=>mc_plannig_started
                        THEN zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_plan_gest    "Peach
                      WHEN zif_ia_2_wrkshft_status=>mc_disposition_released
                        THEN zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_dispo_frei   "Blue
                      WHEN zif_ia_2_wrkshft_status=>mc_shift_released
                        THEN zif_ia_2_wd_constant=>mc_style_class_name-markings_rbimg_freigeben ). "Green
ENDMETHOD.

METHOD init_user_statuses .
*  wd_this->gv_status_antl = 'antl'.

  wd_this->gt_status_range_erp = VALUE #(
*                                          ( sign = 'I' option = 'EQ' low = 'maok' )
                                          ( sign = 'I' option = 'EQ' low = 'REAL' ) ).
ENDMETHOD.

METHOD invalidate_auftraege_alv .
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
         )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
ENDMETHOD.

METHOD invalidate_date_navigator .
  DATA(lv_perimeter) = VALUE wd_this->element_date_navigator-perimeter( ).

  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_attribute( EXPORTING name = `PERIMETER` IMPORTING value = lv_perimeter ).

  CASE lv_perimeter.
    WHEN 'GBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator
               )->get_child_node( name = wd_this->wdctx_date_navigator_gbt
               )->get_child_node( name = wd_this->wdctx_markings_gbt )->invalidate( ).
    WHEN 'CBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator
               )->get_child_node( name = wd_this->wdctx_date_navigator_cbt
               )->get_child_node( name = wd_this->wdctx_markings_cbt )->invalidate( ).
  ENDCASE.
ENDMETHOD.

METHOD invalidate_schichtplan .

  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->invalidate( ).

ENDMETHOD.

METHOD invctx_arbst_of_schicht_ls .

  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_lead_selection(
         )->get_child_node( name = wd_this->wdctx_arbstellen )->invalidate( ).
ENDMETHOD.

METHOD open_reset_schicht .
  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = `SCHICHT`
                                                                   dref = REF #( io_schicht ) )
                                                               ) ).

  DATA(lt_message) = VALUE string_table( ( cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/SCHICHT_RESET` ) ) ).

  wd_comp_controller->open_popup_message_with_params( iv_popup_id     = wd_this->mc_popup_reset_schicht
                                                      io_parameters   = lo_parameters
                                                      iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/SHIFT_RESET` )
                                                      iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                                      iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/RESET` )
                                                      it_text         = lt_message ).
ENDMETHOD.

METHOD open_schicht_parameters .
  DATA(ls_interface_to_param) = VALUE wd_this->element_interface_to_param( object = io_schicht ).

  ls_interface_to_param-schicht_id = ls_interface_to_param-object->get_id( ). "ls_schichtplan-zschicht.
  ls_interface_to_param-zzperi = ls_interface_to_param-object->get_data( )-zzperi. "ls_schichtplan-zzperi.
  ls_interface_to_param-read_only = COND #( WHEN ls_interface_to_param-object->is_locked( )
                                            THEN abap_false ELSE abap_true ).
*  ls_interface_to_param-read_only = COND #( WHEN ls_interface_to_param-object->is_locked( )
*                                          THEN abap_true ELSE abap_false ).
  ls_interface_to_param-shift_read_only = abap_true. "dürfen nie bei Schichtparameter geändert werden nur bei Standard
*  ls_interface_to_param-show_standard = abap_false.
  ls_interface_to_param-show_standard = abap_true.
  ls_interface_to_param-btn_read_only = COND #( WHEN ls_interface_to_param-read_only EQ abap_false
                                                THEN abap_true ELSE abap_false ).

  DATA(lv_has_sp_ts) = io_schicht->has_sp_ts( ).
  ls_interface_to_param-is_sp_ts_only = COND #( WHEN ls_interface_to_param-show_standard EQ abap_true
                                                THEN lv_has_sp_ts ELSE abap_false ).

  wd_context->get_child_node( name = wd_this->wdctx_interface_to_param
           )->get_element( )->set_static_attributes( static_attributes = ls_interface_to_param ).

  IF NOT wd_this->wd_cpuse_parameter( )->has_active_component( ).
    wd_this->wd_cpuse_parameter( )->create_component( ).
  ENDIF.

  IF ls_interface_to_param-read_only = abap_false. " Schichtparameter in Bearbeitungsmodus, müssen gelockt werden
    TRY.
        ls_interface_to_param-object->get_parameter( )->lock( ).
      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        wd_comp_controller->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
        wd_comp_controller->mo_message_manager->reset( ).
    ENDTRY.
  ENDIF.

  wd_comp_controller->wd_get_api( )->get_window_manager( )->create_window_for_cmp_usage( interface_view_name  = 'W_MAIN'
                                                                                         component_usage_name = 'PARAMETER'
                                                                                         title                = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFTPARAMETER' ) )->open( ).
ENDMETHOD.

METHOD reset_schicht .
  io_schicht->reset( ).

  wd_this->fire_schicht_reset_evt( io_schicht->get_id( ) ).

  wd_this->invalidate_date_navigator( ).
  wd_this->invalidate_schichtplan( ).
  wd_this->invalidate_auftraege_alv( ).
ENDMETHOD.

METHOD set_editmode_in_schichtplan .
  DATA(ls_schichtplan) = VALUE wd_this->element_schichtplan( ).

  DATA(lt_elements) = wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_elements( ).

  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
    IF ls_schichtplan-object->get_id( ) = iv_schicht_id.
      ls_schichtplan-edit_mode = iv_is_editable.

      IF iv_is_editable EQ abap_false.
        ls_schichtplan-notes_visibile = COND #( WHEN ls_schichtplan-object->get_notes( ) IS INITIAL THEN abap_false ELSE abap_true ).
      ENDIF.

      <li_element>->set_static_attributes( static_attributes = ls_schichtplan ).
    ENDIF.
  ENDLOOP.
ENDMETHOD.

METHOD set_schichtplan_lead_sel .

  DATA(lv_schicht) = VALUE zia_2_shiftplan_wd_s-zschicht( ).

  DATA(lv_index) = CONV i( -1 ).

  DATA(li_node) = wd_context->get_child_node( name = wd_this->wdctx_schichtplan ).
  DATA(lt_elemnts) = li_node->get_elements( ).

  LOOP AT lt_elemnts ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->get_attribute( EXPORTING name  = 'ZSCHICHT'
                                 IMPORTING value = lv_schicht ).
    CHECK lv_schicht = iv_schicht.
    lv_index = <li_element>->get_index( ).
  ENDLOOP.

  li_node->set_lead_selection_index( lv_index ).
ENDMETHOD.

METHOD set_schicht_editmode .
  wd_comp_controller->mo_ui_element_properties->reload( ).

  DATA(ls_schichtplan) = VALUE wd_this->element_schichtplan( ).
  ii_context_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).

  wd_comp_controller->mo_message_manager->reset( ).

  CASE ls_schichtplan-edit_mode.
    WHEN abap_false.
      TRY .
          zcl_ia_2context_helper=>unlock_previous_schicht( ii_context = wd_context ).
          zcl_ia_2context_helper=>unlock_prev_schicht_in_tab( ii_context = wd_context ).
          ls_schichtplan-object->lock( ).
          ls_schichtplan-object->lock_sub_objects( iv_check = abap_false ).

          wd_this->set_tabs_schichten_lead_sel( ls_schichtplan-object ).
          wd_this->set_schichtplan_lead_sel( ls_schichtplan-zschicht ).
          wd_comp_controller->reload_schicht( ls_schichtplan-object ).
          wd_this->invctx_arbst_of_schicht_ls( ).
          wd_this->invalidate_auftraege_alv( ).

          ls_schichtplan-edit_mode = abap_true.
          ls_schichtplan-notes_visibile = abap_true.
*          ls_schichtplan-notes_visibile = abap_false.
          ls_schichtplan-design = 01.

          wd_comp_controller->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
          wd_comp_controller->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).

        CATCH zcx_ia_2failure INTO DATA(lx_fehler).
          ls_schichtplan-object->unlock( ).
          ls_schichtplan-object->unlock_sub_objects( ).
          wd_comp_controller->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
          wd_comp_controller->mo_message_manager->reset( ).
      ENDTRY.

    WHEN abap_true.
      ls_schichtplan-object->unlock( ).
      ls_schichtplan-object->unlock_sub_objects( ).
      ls_schichtplan-edit_mode = abap_false.
      ls_schichtplan-notes_visibile = COND #( WHEN ls_schichtplan-object->get_notes( ) IS INITIAL THEN abap_false ELSE abap_true ).
      ls_schichtplan-design = 00.

*      SELECT SINGLE zarbstl
*     FROM zia_2sf_wa
*     INTO @DATA(lv_arbstl)
*     WHERE zschicht = @ls_schichtplan-zschicht.
      DATA(lv_arbstl) = wd_assist->get_workcenter( iv_shift = ls_schichtplan-zschicht ).

      IF lv_arbstl IS INITIAL.
        ls_schichtplan-zstatus = '0'.
        ls_schichtplan-style_schichtp_status = 'Markings_RbImg_Inter_vorg'.
      ELSE.
        ls_schichtplan-zstatus = '1'.
        ls_schichtplan-style_schichtp_status = 'Markings_RbImg_Plan_gest'.
      ENDIF.




      wd_comp_controller->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
      wd_comp_controller->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
*    wd_this->invalidate_schichtplan( ).
  ENDCASE.

  ii_context_element->set_static_attributes( static_attributes = ls_schichtplan ).

  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
           )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
           )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->set_static_attributes( static_attributes = ls_schichtplan ).

ENDMETHOD.

METHOD set_tabs_schichten_lead_sel .
  DATA(lt_tabs_schichten) = VALUE wd_this->elements_tabs_schichten( ).
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_static_attributes_table( IMPORTING table = lt_tabs_schichten ).

  READ TABLE lt_tabs_schichten WITH KEY object = io_schicht TRANSPORTING NO FIELDS.
  DATA(lv_index) = COND i( WHEN syst-subrc EQ 0 THEN syst-tabix ELSE -1 ).

  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->set_lead_selection_index( index = lv_index ).

ENDMETHOD.

METHOD supply_schichtplan .
  DATA(lt_schichten) = VALUE zia_2wrkshifts_t( ).

  "Aktiven Kalender und Datumsauswahl
  DATA(ls_date_nav) = VALUE wd_this->element_date_navigator( ).
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
  DATA(ls_date_navigator) = VALUE wd_this->element_date_navigator_gbt( ).
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = ls_date_nav-last_klicked_calender )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_navigator ).

*  SELECT * FROM ZIA_2WRKSHIFTS
*    INTO CORRESPONDING FIELDS OF TABLE @lt_schichten
*    WHERE zzperi = @ls_date_nav-perimeter
*      AND start_datum BETWEEN @ls_date_navigator-firstselecteddate AND @ls_date_navigator-lastselecteddate.

    DATA(lt_shift) = wd_assist->get_notif_data( iv_peri = ls_date_nav-perimeter
                                                iv_start_selected_date = ls_date_navigator-firstselecteddate
                                                iv_last_selected_date = ls_date_navigator-lastselecteddate ).

  IF lt_shift IS NOT INITIAL.
    lt_schichten =  VALUE #( FOR <ls_shift> IN lt_shift
                          ( zschicht =  <ls_shift>-qmnum
                            zzperi = <ls_shift>-qmcod
                            start_datum = <ls_shift>-strmn
                            start_zeit = <ls_shift>-strur
                            end_datum = <ls_shift>-ltrmn
                            zstatus =  <ls_shift>-priok
                            end_zeit =  <ls_shift>-ltrur )

     ).
  ENDIF.
  "Schicht als TAB schon vorhanden, wenn ja wird das Schicht Object daraus gelesen, sonst neuerstellt
  DATA(lt_tabs_schichten) = VALUE wd_this->elements_tabs_schichten( ).
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_static_attributes_table( IMPORTING table = lt_tabs_schichten ).

  DATA(lt_schichtplan) = VALUE wd_this->elements_schichtplan( ).
  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schicht>).
    APPEND INITIAL LINE TO lt_schichtplan ASSIGNING FIELD-SYMBOL(<ls_schicht_plan_entry>).

    wd_this->adjust_schichtplan_sta( EXPORTING is_schicht        = <ls_schicht>
                                               it_tabs_schichten = lt_tabs_schichten
                                     CHANGING  cs_schichtplan    = <ls_schicht_plan_entry> ).

  ENDLOOP.

  wd_this->filter_schichtplan( CHANGING ct_data = lt_schichtplan ).     ">001< (+)

*--> Begin Insert >001<
  SORT lt_schichtplan BY start_datum
                         start_zeit.
*--> End Insert >001<

  node->bind_table( new_items            = lt_schichtplan
                    set_initial_elements = abap_true ).
ENDMETHOD.

METHOD validate_add_auftrag .
  CHECK io_arbeitsstelle IS BOUND.

  DATA(lv_schicht_status) = io_arbeitsstelle->get_schicht( )->get_data( )-zstatus.

  CASE lv_schicht_status.
    WHEN zif_ia_2_wrkshft_status=>mc_disposition_released.
      wd_this->validate_auftrag_status_s20( iv_aufnr ).

    WHEN OTHERS.
      RETURN.
  ENDCASE.
ENDMETHOD.

METHOD validate_auftrag_status_s20 .
  CHECK iv_aufnr IS NOT INITIAL.

  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_aufnr              dref = REF #( iv_aufnr ) )
                                                                  ( name = zif_ia_2_validator=>mc_param_schicht_status     dref = REF #( zif_ia_2_wrkshft_status=>mc_disposition_released  ) )
                                                                  ( name = zif_ia_2_validator=>mc_param_obj_status_str_rng dref = REF #( wd_this->gt_status_range_erp ) )
                                                                ) ).

  zcl_ia_2lib_validation_a=>change_auftrag_jp_status( lo_parameters ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_reset_schicht_confirmed .
  CHECK iv_popup_id = wd_this->mc_popup_reset_schicht.

  DATA(lo_schicht) = CAST zcl_ia_2workshift( io_parameters->get_object( wd_this->mc_param_schicht ) ).

  wd_this->reset_schicht( io_schicht = lo_schicht ).

  wd_this->fire_schicht_reset_evt( lo_schicht->get_id( ) ).
ENDMETHOD.

METHOD on_schicht_tab_deleted .
  wd_this->set_editmode_in_schichtplan( iv_schicht_id = iv_schicht_id ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

method SUPPLY_ARBSTELLEN . "#EC NEEDED
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
*  DATA ls_parent_attributes TYPE wd_this->element_schichtplan.
*  parent_element->get_static_attributes(
*    IMPORTING
*      static_attributes = ls_parent_attributes ).

*
** data declaration
*  DATA lt_arbstellen TYPE wd_this->Elements_arbstellen.
*  DATA ls_arbstellen LIKE LINE OF lt_arbstellen.
** @TODO compute values
** e.g. call a data providing FuBa
*
** bind all the elements
*  node->bind_table(
*    new_items            =  lt_arbstellen
*    set_initial_elements = abap_true ).
*
endmethod.

endclass.
 