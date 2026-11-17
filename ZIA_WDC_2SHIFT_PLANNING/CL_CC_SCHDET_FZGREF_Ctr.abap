class CL_CC_SCHDET_FZGREF_Ctr implementation.
 
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

METHOD add_message .
  DATA(lt_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).
*  DATA(ls_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).

  DATA(lv_msgid) = COND #( WHEN iv_msgid IS NOT INITIAL THEN iv_msgid ELSE sy-msgid ).
  DATA(lv_msgty) = COND #( WHEN iv_msgty IS NOT INITIAL THEN iv_msgty ELSE sy-msgty ).
  DATA(lv_msgno) = COND #( WHEN iv_msgno IS NOT INITIAL THEN iv_msgno ELSE sy-msgno ).
  DATA(lv_msgv1) = COND #( WHEN iv_msgv1 IS NOT INITIAL THEN iv_msgv1 ELSE sy-msgv1 ).
  DATA(lv_msgv2) = COND #( WHEN iv_msgv2 IS NOT INITIAL THEN iv_msgv2 ELSE sy-msgv2 ).
  DATA(lv_msgv3) = COND #( WHEN iv_msgv3 IS NOT INITIAL THEN iv_msgv3 ELSE sy-msgv3 ).
  DATA(lv_msgv4) = COND #( WHEN iv_msgv4 IS NOT INITIAL THEN iv_msgv4 ELSE sy-msgv4 ).

  IF lv_msgid IS INITIAL OR
     lv_msgno IS INITIAL OR
     lv_msgty IS INITIAL.
    RETURN.
  ENDIF.

  MESSAGE ID lv_msgid TYPE lv_msgty NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO DATA(lv_message).
  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).
  APPEND VALUE #( msgty = lv_msgty msg = lv_message ) TO lt_msg.
  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_msg )->bind_table( new_items = lt_msg set_initial_elements = abap_true ).

ENDMETHOD.

METHOD check_as_structure .
  DATA(lt_ver_schicht_as_ktext) = VALUE string_t( ).
  DATA(lv_ver_schicht_as_num)   = VALUE int2( ).
  DATA(lt_schicht_as_ktext)     = VALUE string_t( ).
  DATA(lv_schicht_as_num)       = VALUE int2( ).
  DATA lo_arbstl                TYPE REF TO zcl_ia_2wrkplace.
  DATA(lv_msg)                 = VALUE string( ) ##NEEDED.


  "Collect the AS names and AS number of the Versorgung Schicht
  DATA(li_arbstl_i) = wd_this->mo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
  WHILE li_arbstl_i->has_next( ).
    lo_arbstl ?= li_arbstl_i->get_next( ).
    CHECK lo_arbstl->is_schiene( ).  ">002< +
    DATA(lv_ktext) = lo_arbstl->get_kurztext( iv_zgart_txt = abap_false ).
    APPEND lv_ktext TO lt_ver_schicht_as_ktext.
    lv_ver_schicht_as_num = lv_ver_schicht_as_num + 1.
  ENDWHILE.

  "Get Keine Logistik Schichten of Versorgung Schicht (current schicht)
  DATA(lt_klog_schichten) = wd_this->mo_schicht->get_keine_logistik_schichten( ).
  IF lt_klog_schichten IS INITIAL.
    MESSAGE e056(zia_2_real) INTO lv_msg.
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.

  "Compare the AS structure of Versorgung Schicht with the AS structure of Keine Log. Schichts
  LOOP AT lt_klog_schichten ASSIGNING FIELD-SYMBOL(<ls_klog_schichten>).
    CLEAR: lt_schicht_as_ktext, lv_schicht_as_num.
    li_arbstl_i = <ls_klog_schichten>-o_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE li_arbstl_i->has_next( ).
      lo_arbstl ?= li_arbstl_i->get_next( ).
      CHECK lo_arbstl->is_schiene( ).   ">002< +
      lv_ktext = lo_arbstl->get_kurztext( iv_zgart_txt = abap_false ).
      APPEND lv_ktext TO lt_schicht_as_ktext.
      lv_schicht_as_num = lv_schicht_as_num + 1.
    ENDWHILE.

    "Check the AS number
    IF lv_ver_schicht_as_num <> lv_schicht_as_num.
      MESSAGE e056(zia_2_real) INTO lv_msg.
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.

    "Check the AS names
    LOOP AT lt_ver_schicht_as_ktext ASSIGNING FIELD-SYMBOL(<lv_ver_schicht_as_ktext>). "#EC CI_NESTED
      CHECK NOT line_exists( lt_schicht_as_ktext[ table_line = <lv_ver_schicht_as_ktext> ] ).
      MESSAGE e056(zia_2_real) INTO lv_msg.
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD check_before_popup .
  DATA(lt_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).

  rv_value = abap_true.
  wd_comp_controller->mo_message_manager->reset( ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_msg )->bind_table( new_items = lt_msg set_initial_elements = abap_true ).

  IF wd_this->get_edit_mode( ) = abap_false.
    RETURN.
  ENDIF.

  "Check the structure of AS
  TRY.
      wd_this->check_as_structure( ).
    CATCH zcx_ia_2failure.
      wd_comp_controller->mo_message_manager->add_sys_message( ).
      rv_value = abap_false.
  ENDTRY.

  "Check schicht status for all schichts (V+K+E)
  TRY.
      wd_this->check_schicht_status( ).
    CATCH zcx_ia_2failure.
      wd_comp_controller->mo_message_manager->add_sys_message( ).
      rv_value = abap_false.
  ENDTRY.

  "Check if Versorgung Schicht has Fahzrzeuge
  TRY.
      wd_this->check_fahzrzeuge_src( ).
    CATCH zcx_ia_2failure.
      wd_comp_controller->mo_message_manager->add_sys_message( ).
      rv_value = abap_false.
  ENDTRY.

  TRY.
      wd_this->check_fzg_structure( ).
    ##NO_HANDLER   CATCH zcx_ia_2failure.
      "do nothing - it's only warning
  ENDTRY.

  IF rv_value = abap_false.
    wd_comp_controller->mo_message_manager->display_messages( ).
  ENDIF.

ENDMETHOD.

METHOD check_fahzrzeuge_src .
  DATA lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator.

  lo_fahrzeuge_i ?=  wd_this->mo_schicht->get_fahrzeuge( )->get_values_iterator( ).
  WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
    CHECK lo_fahrzeug IS BOUND.
    CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).
    DATA(lv_exist) = abap_true.
    EXIT.
  ENDWHILE.

  IF lv_exist = abap_false.
    ##NEEDED   MESSAGE e052(zia_2_real) INTO DATA(lv_msg).
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.


ENDMETHOD.

METHOD check_fzg_structure .
  DATA(lt_fzg_count_v) = VALUE zif_ia_2_types=>tt_as_fztyp_count( ).
  DATA(lt_fzg_surplus) = VALUE zif_ia_2_types=>tt_schicht_obj_matrix( ).
  DATA lo_fahrzeuge_i  TYPE REF TO cl_object_collection_iterator.
  DATA lo_fahrzeug     TYPE REF TO zcl_ia_2vehicle.

  DATA(lv_as_ktext)      = VALUE char3( ).
  DATA(lv_fztyp)         = VALUE zia_2_id_fztyp( ).

  "Count Fahrzeuge in Versorgung Schicht
  lo_fahrzeuge_i ?= wd_this->mo_schicht->get_fahrzeuge( )->get_values_iterator( ).
  WHILE lo_fahrzeuge_i->has_next( ).
    lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
    CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).
    lv_as_ktext = lo_fahrzeug->get_arbeitsstelle( )->get_kurztext( iv_zgart_txt = abap_false ).
    lv_fztyp    = lo_fahrzeug->get_data( )-zid_fztyp.
    ASSIGN lt_fzg_count_v[ as_ktxt = lv_as_ktext fztyp = lv_fztyp ] TO FIELD-SYMBOL(<ls_fzg_count_v>).
    IF sy-subrc = 0.
      <ls_fzg_count_v>-number = <ls_fzg_count_v>-number + 1.
      CONTINUE.
    ENDIF.
    APPEND VALUE #( as_ktxt = lv_as_ktext fztyp = lv_fztyp number = 1 ) TO lt_fzg_count_v.
  ENDWHILE.

  "Get keine logistic Schichts
  DATA(lt_schichten) = wd_this->mo_schicht->get_keine_logistik_schichten(  ).
  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schichten>).
    DATA(lt_fzg_count_v_tmp) = lt_fzg_count_v.
    lo_fahrzeuge_i ?= <ls_schichten>-o_schicht->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ).
      DATA(lv_number) = VALUE int2( ).
      lo_fahrzeug ?= lo_fahrzeuge_i->get_next( ).
      CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).
      lv_as_ktext  = lo_fahrzeug->get_arbeitsstelle( )->get_kurztext( iv_zgart_txt = abap_false ).
      lv_fztyp     = lo_fahrzeug->get_data( )-zid_fztyp.
      ASSIGN lt_fzg_count_v_tmp[  as_ktxt = lv_as_ktext fztyp = lv_fztyp ] TO <ls_fzg_count_v>.
      IF sy-subrc = 0.
        lv_number = <ls_fzg_count_v>-number.
        <ls_fzg_count_v>-number = <ls_fzg_count_v>-number - 1.
      ENDIF.
      IF lv_number <= 0.
        APPEND INITIAL LINE TO lt_fzg_surplus ASSIGNING FIELD-SYMBOL(<ls_fzg_surplus>).
        <ls_fzg_surplus>-supply_type = <ls_schichten>-supply_type.
        <ls_fzg_surplus>-fahrzg_ktxt = lo_fahrzeug->get_bezeichnung( ).
        <ls_fzg_surplus>-o_schicht   = <ls_schichten>-o_schicht.
      ENDIF.
    ENDWHILE.
  ENDLOOP.

  "Add message to log
  LOOP AT lt_fzg_surplus ASSIGNING <ls_fzg_surplus>.
    CASE <ls_fzg_surplus>-supply_type.
      WHEN zif_ia_2_constant=>mc_supply_type-entsorgung.
        ##NEEDED       MESSAGE w053(zia_2_real) WITH <ls_fzg_surplus>-fahrzg_ktxt |{ <ls_fzg_surplus>-o_schicht->get_id( ) ALPHA = OUT }| INTO DATA(lv_msg) .
        wd_this->add_message( ).
      WHEN zif_ia_2_constant=>mc_supply_type-keine_fahrt.
        MESSAGE w058(zia_2_real) WITH <ls_fzg_surplus>-fahrzg_ktxt |{ <ls_fzg_surplus>-o_schicht->get_id( ) ALPHA = OUT }| INTO lv_msg.
        wd_this->add_message( ).
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

  "Final message
  IF lt_fzg_surplus IS NOT INITIAL.
    MESSAGE e055(zia_2_real) INTO lv_msg.
    wd_this->add_message( ).
  ENDIF.

ENDMETHOD.

METHOD check_schicht_status .
  DATA(lv_status) = VALUE zia_2_wrkshftstatus( ).

  DATA(lv_statust_s00_txt) =  cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/INTERVAL_PLANNED' ).
  DATA(lv_statust_s30_txt) =  cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFT_RELEASED' ).

  "Check status of Versorgungsschicht
  lv_status = wd_this->mo_schicht->get_status( ).
  IF lv_status = zif_ia_2_wrkshft_status=>mc_interval_provided OR
     lv_status = zif_ia_2_wrkshft_status=>mc_shift_released.
    ##NEEDED   MESSAGE e057(zia_2_real) INTO DATA(lv_msg) WITH lv_statust_s00_txt lv_statust_s30_txt.
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.

  "Check status of keine Logistik schichts
  DATA(lt_kl_schichts) = wd_this->mo_schicht->get_keine_logistik_schichten( ).
  LOOP AT lt_kl_schichts ASSIGNING FIELD-SYMBOL(<ls_kl_schicht>).
    lv_status = <ls_kl_schicht>-o_schicht->get_status( ).
    CHECK lv_status = zif_ia_2_wrkshft_status=>mc_interval_provided
       OR lv_status = zif_ia_2_wrkshft_status=>mc_shift_released.
    MESSAGE e057(zia_2_real) INTO lv_msg WITH lv_statust_s00_txt lv_statust_s30_txt.
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDLOOP.

ENDMETHOD.

METHOD copy_fahrzeuge .
  "Check status of keine Logistik schichts
  DATA(lt_kl_schichts) = wd_this->mo_schicht->get_keine_logistik_schichten( ).
  LOOP AT lt_kl_schichts ASSIGNING FIELD-SYMBOL(<ls_kl_schicht>).
    <ls_kl_schicht>-o_schicht->copy_versorgung_fahrzeuge( ).
  ENDLOOP.

ENDMETHOD.

METHOD get_edit_mode .
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ). ">
  rv_value = ls_schichtdetails-edit_mode.

ENDMETHOD.

METHOD get_referenced_status .
  rv_data = wd_this->mv_referenced.
ENDMETHOD.

METHOD on_save .
  TRY.
      wd_this->copy_fahrzeuge( ).
      wd_this->set_referenced_status( abap_true ).
    CATCH zcx_ia_2failure.
      wd_this->set_referenced_status( abap_false ).
  ENDTRY.

  wd_this->mo_popup_fzg_ref->close( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_fahrzeug )->invalidate( ).

ENDMETHOD.

METHOD on_toggle_src .
  RETURN. "Not needed now
ENDMETHOD.

METHOD process_event_src .
  CASE io_event->get_name( ).

    WHEN 'ON_TOGGLE'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'TREE_BY_KEY_TBL_SRC'.
          wd_this->on_toggle_src( io_event ).
      ENDCASE.

  ENDCASE.

ENDMETHOD.

METHOD report_message .
  DATA li_api_controller  TYPE REF TO if_wd_controller.
  DATA(lt_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).
*  DATA(ls_msg) = VALUE wd_this->elements_popup_fzgref_msg( ).

  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_msg )->get_static_attributes_table( IMPORTING table = lt_msg ).



  li_api_controller          ?= wd_this->wd_get_api( ).
  wd_this->mo_message_menager = li_api_controller->get_message_manager( ).

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

METHOD set_popup_ui .
  DATA(ls_popup_ui) = VALUE wd_this->element_popup_fzgref_ui( ).

  ls_popup_ui-ena_save = abap_true.
  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_ui )->bind_structure( EXPORTING new_item = ls_popup_ui ).

ENDMETHOD.

METHOD set_referenced_status .

  wd_this->mv_referenced = iv_data.
ENDMETHOD.

METHOD set_ref_column_src .
  CONSTANTS lc_icon_done         TYPE string VALUE '~Icon/Done'.
  CONSTANTS lc_icon_disconnected TYPE string VALUE '~Icon/Disconnected'.


  "First set value on fahrzeug level
  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>) WHERE level = 3.
    CHECK <ls_data>-o_fahrzg IS BOUND.
    <ls_data>-is_referenced = COND #( WHEN <ls_data>-o_fahrzg->is_referenced( ) THEN abap_true ELSE abap_false ).
    <ls_data>-fzg_ref_icon  = COND #( WHEN <ls_data>-o_fahrzg->is_referenced( ) THEN lc_icon_done ELSE lc_icon_disconnected ).
  ENDLOOP.

  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_1>) WHERE level = 1.
    <ls_data_1>-is_referenced = abap_true.
    <ls_data_1>-fzg_ref_icon    = lc_icon_done.
    LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_2>) WHERE parent_path = <ls_data_1>-path. "#EC CI_NESTED "#EC CI_STDSEQ
      <ls_data_2>-is_referenced = abap_true.
      <ls_data_2>-fzg_ref_icon  = lc_icon_done.
      LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_3>) WHERE parent_path = <ls_data_2>-path. "#EC CI_NESTED "#EC CI_STDSEQ
        CHECK <ls_data_3>-is_referenced = abap_false.
        <ls_data_1>-is_referenced = abap_false.
        <ls_data_1>-fzg_ref_icon  = lc_icon_disconnected.
        <ls_data_2>-is_referenced = abap_false.
        <ls_data_2>-fzg_ref_icon  = lc_icon_disconnected.
        EXIT.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD show_popup .
  CONSTANTS lc_button_close_id TYPE wdr_popup_button VALUE 5.
  DATA(ls_popup_ui) = VALUE wd_this->element_popup_fzgref_ui( ).
  DATA(ls_button)   = VALUE wdr_popup_button_definition( ).

  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_ui )->get_static_attributes( IMPORTING static_attributes = ls_popup_ui ).

  DATA(li_window_manager) = wd_comp_controller->wd_get_api( )->get_window_manager( ).
  DATA(lt_buttons)        = li_window_manager->get_buttons_close( ).

  ASSIGN lt_buttons[ button = lc_button_close_id ] TO FIELD-SYMBOL(<ls_button_close>).
  IF sy-subrc = 0.
    <ls_button_close>-text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/CANCEL' ).
  ENDIF.

  ls_button = VALUE #(  button     = 99
                        text       =  cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SAVE_AND_CLOSE' )
                        action     = VALUE wdr_popup_button_action( action_name = 'SAVE' )
                        is_enabled = ls_popup_ui-ena_save ).
  INSERT ls_button INTO lt_buttons INDEX 1.

  wd_this->mo_popup_fzg_ref = li_window_manager->create_and_open_popup(
   EXPORTING
     window_name          = 'W_POPUP_FZGREF'
     title                = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/POPUP_TITLE_VEHICLE_REF' )
     message_type         = if_wd_window=>co_msg_type_none
     message_display_mode = if_wd_window=>co_msg_display_mode_selected
     buttons              = lt_buttons ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_btn_fzg_ref .
  DATA lo_schicht TYPE REF TO zcl_ia_2workshift.

  IF wd_comp_controller->mo_curr_arbstelle IS NOT BOUND.
    RETURN.
  ENDIF.

  "Popup is displayed only for the Versorgung schicht
  lo_schicht = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
  IF NOT lo_schicht->is_versorgung_schicht( ) AND
     NOT lo_schicht->has_versorgung_schicht( ).
    RETURN.
  ENDIF.

  IF NOT lo_schicht->is_versorgung_schicht( ).
    wd_this->mo_schicht = lo_schicht->get_versorgung_schicht( ).
  ELSE.
    wd_this->mo_schicht = lo_schicht.
  ENDIF.

  IF abap_false = wd_this->check_before_popup( ).
    RETURN.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_src )->invalidate( ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_fzgref_trg )->invalidate( ).

  "Set popup UI
  wd_this->set_popup_ui( ).

  "Display popup
  wd_this->show_popup( ).

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

METHOD supply_popup_fzgref_src_tbl .
  DATA(lt_data)        = VALUE wd_this->elements_popup_fzgref_src_tbl( ).
  DATA lo_arbstl_i     TYPE REF TO cl_object_collection_iterator.
  DATA lo_fahzrg_i     TYPE REF TO cl_object_collection_iterator.
  DATA lo_arbstl       TYPE REF TO zcl_ia_2wrkplace.
  DATA lo_fahrzg       TYPE REF TO zcl_ia_2vehicle.
  DATA lt_fahrzg       TYPE STANDARD TABLE OF zia_2_vhref_vehicle_s WITH DEFAULT KEY.
  DATA(lv_parent_path) = VALUE string( ) ##NEEDED.
  DATA lv_as_ktext     TYPE char3.
  DATA lt_sp_details TYPE zia_2sp_detials_wd_t.

  IF wd_this->mo_schicht IS NOT BOUND.
    node->bind_table( new_items = lt_data ).
    RETURN.
  ENDIF.
*----------------------------------------------------------------------------------------------------------
  "LEVEL 1 - Schicht
  APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_sch>).
  DATA(ls_schicht)          = wd_this->mo_schicht->get_data( ).
  <ls_data_sch>-level           = 1.
  <ls_data_sch>-path            = |/{ ls_schicht-zschicht ALPHA = IN }|.
  <ls_data_sch>-o_schicht       = wd_this->mo_schicht.
  <ls_data_sch>-bezeichnung     = |{ zcl_ia_2utilities=>get_dats_as_formated_string( ls_schicht-start_datum ) } / {
                                  ls_schicht-start_zeit(2) }:{ ls_schicht-start_zeit+2(2) } - { ls_schicht-end_zeit(2) }:{ ls_schicht-end_zeit+2(2) }|.
  <ls_data_sch>-bezeichnung     = |{ <ls_data_sch>-bezeichnung } | & |{ wd_this->mo_schicht->get_bezeichnung_schicht( ) }|.
  <ls_data_sch>-supply_type     = wd_this->mo_schicht->get_parameter( )->get_data( )-supply_type.
  <ls_data_sch>-supply_type_dsc = |{ <ls_data_sch>-supply_type }-{ cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SUPPLY' ) }|.

*----------------------------------------------------------------------------------------------------------
  "LEVEL 2 - Arbeitstelle
  lo_arbstl_i ?= wd_this->mo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
  WHILE lo_arbstl_i->has_next( ).
    CLEAR: lt_fahrzg.

    lo_arbstl ?= lo_arbstl_i->get_next( ).
    APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_as>).
    <ls_data_as>-level        = 2.
    lv_as_ktext               = lo_arbstl->get_kurztext( ).
    <ls_data_as>-path         = |{ <ls_data_sch>-path }/{ lv_as_ktext }|.
    <ls_data_as>-parent_path  = <ls_data_sch>-path.
    lo_arbstl->get_sp_details_wd( CHANGING ct_sp_details = lt_sp_details ).
    DATA(ls_sp_details) = VALUE #( lt_sp_details[ 1 ] OPTIONAL ).
    <ls_data_as>-bezeichnung  = |{ lv_as_ktext }: { ls_sp_details-datum DATE = USER } { ls_sp_details-sp_zeiten } { ls_sp_details-sp_kilometer } { ls_sp_details-sp_sigabs_ehb }|.
    <ls_data_as>-o_schicht    = wd_this->mo_schicht.
    <ls_data_as>-o_arbstl     = lo_arbstl.

*----------------------------------------------------------------------------------------------------------
    "LEVEL 3 - Fahrzeuge
    lo_fahzrg_i ?= lo_arbstl->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahzrg_i->has_next( ).
      "DATA(lv_index_fzg) = sy-index.
      lo_fahrzg ?= lo_fahzrg_i->get_next( ).
      CHECK NOT lo_fahrzg->is_basis_fz_pneu( ).
      APPEND VALUE #( ) TO lt_fahrzg ASSIGNING FIELD-SYMBOL(<ls_fahrzg>).
      <ls_fahrzg>-fzg_txt = COND #( WHEN lo_fahrzg->get_reihung( ) IS NOT INITIAL THEN |{ lv_as_ktext }.{ lo_fahrzg->get_reihung( ) }| ELSE lv_as_ktext ).
      <ls_fahrzg>-o_fahrzeug = lo_fahrzg.
    ENDWHILE.

    IF lt_fahrzg IS NOT INITIAL.
      SORT lt_fahrzg BY fzg_txt.
      LOOP AT lt_fahrzg ASSIGNING <ls_fahrzg>.
        APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_fzg>).
        <ls_data_fzg>-level         = 3.
        <ls_data_fzg>-path          = |{ <ls_data_as>-path }/{ <ls_fahrzg>-o_fahrzeug->get_id( ) }|.
        <ls_data_fzg>-parent_path   = <ls_data_as>-path.
        <ls_data_fzg>-is_leaf       = abap_true.
        <ls_data_fzg>-bezeichnung   = |{ <ls_fahrzg>-fzg_txt } - { <ls_fahrzg>-o_fahrzeug->get_kurztext( ) }|.
        <ls_data_fzg>-o_fahrzg      = <ls_fahrzg>-o_fahrzeug.
      ENDLOOP.
    ENDIF.
  ENDWHILE.

  "Set referenced column
  wd_this->set_ref_column_src( CHANGING ct_data = lt_data ).

  node->bind_table( new_items = lt_data set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_popup_fzgref_trg_tbl .
  DATA(lt_data)        = VALUE wd_this->elements_popup_fzgref_trg_tbl( ).
  DATA lo_arbstl_i     TYPE REF TO cl_object_collection_iterator.
  DATA lo_fahzrg_i     TYPE REF TO cl_object_collection_iterator.
  DATA lo_arbstl       TYPE REF TO zcl_ia_2wrkplace.
  DATA lo_fahrzg       TYPE REF TO zcl_ia_2vehicle.
  DATA lt_fahrzg       TYPE STANDARD TABLE OF zia_2_vhref_vehicle_s WITH DEFAULT KEY.
  DATA lv_as_ktext     TYPE char3.
  DATA lt_sp_details TYPE zia_2sp_detials_wd_t.


  IF wd_this->mo_schicht IS NOT BOUND.
    node->bind_table( new_items = lt_data ).
    RETURN.
  ENDIF.

  DATA(lt_schichten) = wd_this->mo_schicht->get_keine_logistik_schichten(  ).

  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schichten>).
*-----------------------------------------------------------------------------------------------------------------------------------
    "LEVEL 1 - Schicht
    DATA(lo_schicht) = <ls_schichten>-o_schicht.
    APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_sch>).
    DATA(ls_schicht)          = lo_schicht->get_data( ).

    <ls_data_sch>-level           = 1.
    <ls_data_sch>-path            = |/{ ls_schicht-zschicht ALPHA = IN }|.
    <ls_data_sch>-o_schicht       = wd_this->mo_schicht.
    <ls_data_sch>-bezeichnung     = |{ zcl_ia_2utilities=>get_dats_as_formated_string( ls_schicht-start_datum ) } / {
                                    ls_schicht-start_zeit(2) }:{ ls_schicht-start_zeit+2(2) } - { ls_schicht-end_zeit(2) }:{ ls_schicht-end_zeit+2(2) }|.
    <ls_data_sch>-bezeichnung     = |{ <ls_data_sch>-bezeichnung } | & |{ lo_schicht->get_bezeichnung_schicht( ) }|.
    <ls_data_sch>-supply_type     = lo_schicht->get_parameter( )->get_data( )-supply_type.
    <ls_data_sch>-supply_type_dsc = |{ <ls_data_sch>-supply_type }-{ COND #(
                                    WHEN <ls_data_sch>-supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt
                                    THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/NO_RIDE' )
                                    WHEN <ls_data_sch>-supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung
                                    THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DISPOSAL' ) )  }|.
*-----------------------------------------------------------------------------------------------------------------------------------
    "LEVEL 2 - Arbeitstelle
    lo_arbstl_i ?= lo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE lo_arbstl_i->has_next( ).
      CLEAR: lt_fahrzg.
      lo_arbstl ?= lo_arbstl_i->get_next( ).
      APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_as>).
      <ls_data_as>-level        = 2.
      lv_as_ktext               = lo_arbstl->get_kurztext( ).
      <ls_data_as>-path         = |{ <ls_data_sch>-path }/{ lv_as_ktext }|.
      <ls_data_as>-parent_path  = <ls_data_sch>-path.
      lo_arbstl->get_sp_details_wd( CHANGING ct_sp_details = lt_sp_details ).
      DATA(ls_sp_details) = VALUE #( lt_sp_details[ 1 ] OPTIONAL ).
      <ls_data_as>-bezeichnung  = |{ lv_as_ktext }: { ls_sp_details-datum DATE = USER } { ls_sp_details-sp_zeiten } { ls_sp_details-sp_kilometer } { ls_sp_details-sp_sigabs_ehb }|.
      <ls_data_as>-o_schicht    = lo_schicht.
      <ls_data_as>-o_arbstl     = lo_arbstl.
*-----------------------------------------------------------------------------------------------------------------------------------
      "LEVEL 3 - Fahrzeuge
      lo_fahzrg_i ?= lo_arbstl->get_fahrzeuge( )->get_values_iterator( ).
      WHILE lo_fahzrg_i->has_next( ).
        DATA(lv_index_fzg) = sy-index.
        lo_fahrzg ?= lo_fahzrg_i->get_next( ).
        CHECK NOT lo_fahrzg->is_basis_fz_pneu( ).
        APPEND VALUE #( ) TO lt_fahrzg ASSIGNING FIELD-SYMBOL(<ls_fahrzg>).
        <ls_fahrzg>-fzg_txt = COND #( WHEN lo_fahrzg->get_reihung( ) IS NOT INITIAL THEN |{ lv_as_ktext }.{ lo_fahrzg->get_reihung( ) }| ELSE lv_as_ktext ) .
        <ls_fahrzg>-o_fahrzeug = lo_fahrzg.
      ENDWHILE.

      IF lt_fahrzg IS NOT INITIAL.
        SORT lt_fahrzg BY fzg_txt.
        LOOP AT lt_fahrzg ASSIGNING <ls_fahrzg>.
          APPEND VALUE #( ) TO lt_data ASSIGNING FIELD-SYMBOL(<ls_data_fzg>).
          <ls_data_fzg>-level        = 3.
          <ls_data_fzg>-path         = |{ <ls_data_as>-path }/{ lv_index_fzg }|.
          <ls_data_fzg>-parent_path  = <ls_data_as>-path.
          <ls_data_fzg>-is_leaf      = abap_true.
          <ls_data_fzg>-bezeichnung = |{ <ls_fahrzg>-fzg_txt } - { <ls_fahrzg>-o_fahrzeug->get_kurztext( ) }|.
        ENDLOOP.
      ENDIF.

    ENDWHILE.
  ENDLOOP.

  node->bind_table( new_items = lt_data set_initial_elements = abap_true ).

ENDMETHOD.

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
 