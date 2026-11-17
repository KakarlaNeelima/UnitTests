class CL_CC_SCHDET_MAIN_Ctr implementation.
 
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
  wd_this->create_custom_styles( ).
ENDMETHOD.

METHOD create_custom_styles .
  DATA(lt_lta_versorgungsschicht_prop) = VALUE if_wd_custom_style=>t_style_properties( ).

  DATA(li_custom_style_manager) = wd_comp_controller->wd_get_api( )->get_application( )->get_custom_style_manager( ).
*****************************************************************************************************************************************
  "LTA_VERSORGUNG_SCHICHT: Link To Action Style Used in V_SCHICHTDETAILS->LTA_VERSORGUNG_SCHICHT
  lt_lta_versorgungsschicht_prop  = VALUE #( ( name = `fontSize` value = `16px` ) ( name = 'fontStyle' value = 'italic' ) ).
  DATA(li_lta_versorgungsschicht) = li_custom_style_manager->create_custom_style(
                                      style_class_name = 'SchDet_Lta_Versorgungsschicht'
                                      library_name     = 'STANDARD'
                                      element_type     = 'LINK_TO_ACTION'
                                      style_properties = lt_lta_versorgungsschicht_prop  ).
  li_custom_style_manager->add_custom_style( li_lta_versorgungsschicht ).
*****************************************************************************************************************************************

  "Others ...

ENDMETHOD.

METHOD display_status_error .
  wd_comp_controller->mo_message_manager->reset( ).

  IF ix_validator IS BOUND.
    IF ix_validator->gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_01 OR
       ix_validator->gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_02.
      wd_comp_controller->mo_message_manager->add_bapiret_t( ix_validator->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
    ELSE.
      DATA(lt_message) = VALUE string_table( ( ix_validator->get_text( ) ) ).
      wd_comp_controller->open_popup_message(
         io_view_object  = wd_this->wd_get_api( )
         it_text         = lt_message
         iv_message_type = if_wd_window=>co_msg_type_warning
         iv_button_kind  = if_wd_window=>co_buttons_ok
         iv_close_button = abap_false
         iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DANGER' ) ).
    ENDIF.
  ENDIF.

  IF ix_fehler IS BOUND.
    wd_comp_controller->mo_message_manager->add_bapiret_t( ix_fehler->gt_bapiret ).
    wd_comp_controller->mo_message_manager->display_messages( ).
  ENDIF.

ENDMETHOD.

METHOD get_comp_popup_fahrplan .
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_fahrplan( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  ri_component = wd_this->wd_cpifc_popup_fahrplan( ).

ENDMETHOD.

METHOD open_popup_fahrplan .
  DATA(li_popup_fahrplan) = wd_this->get_comp_popup_fahrplan( ).

  li_popup_fahrplan->open( io_schicht = io_schicht ).

ENDMETHOD.

METHOD set_schicht_status_s10 .
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  io_schicht->set_status( iv_status ).
  io_schicht->save( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->invalidate( ).
  DATA(li_context_node) =  wd_comp_controller->get_date_markings_wdctx( ls_schichtdetails-zzperi ).
  li_context_node->invalidate( ).
  wd_comp_controller->invctx_ui_schicht( ).
ENDMETHOD.

METHOD set_schicht_status_s20 .
  CONSTANTS lc_status_real   TYPE j_txt04  VALUE 'REAL'.
  DATA(lt_status_rng)      = VALUE zia_2string_range_t( ).

  lt_status_rng = VALUE #( BASE lt_status_rng ( sign = 'I' option = 'EQ' low = lc_status_real ) ).
  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht            dref = REF #( io_schicht ) )
                                                                 ( name = zif_ia_2_validator=>mc_param_schicht_status     dref = REF #( iv_status ) )
                                                                 ( name = zif_ia_2_validator=>mc_param_obj_status_str_rng dref = REF #( lt_status_rng ) )
  ) ).
  wd_comp_controller->mo_message_manager->reset( ).

  TRY.
      zcl_ia_2lib_validation_a=>change_schicht_status( lo_parameters ).
    CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_validation_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      RETURN.
    ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_check) ##NEEDED. "#EC EMPTY_CATCH
  ENDTRY.

  TRY.
      zcl_ia_2order_utils=>change_user_status(
        EXPORTING
          io_auftraege = io_schicht->get_auftraege( )
          io_schicht   = io_schicht
          iv_status    = 'PL2'
      ).
    CATCH zcx_ia_2failure INTO DATA(lx_status_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_status_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      RETURN.
*      RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDTRY.

  TRY.
      zcl_ia_2order_utils=>set_orsc_status( io_auftraege = io_schicht->get_auftraege( ) ).
    CATCH zcx_ia_2failure INTO DATA(lx_orsc_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_orsc_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      RETURN.
  ENDTRY.

  " Create Shift order
  TRY.
      zcl_ia_2order_utils=>create_shift_order(
        EXPORTING
          io_schicht = io_schicht
      ).
    CATCH zcx_ia_2failure INTO DATA(lx_order_error) ##NEEDED.
      wd_comp_controller->mo_message_manager->add_bapiret_t( lx_status_error->gt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDTRY.


  io_schicht->set_status( iv_status ).
  io_schicht->save( ).
  DATA(lt_bapiret) = io_schicht->save( ).

  IF line_exists( lt_bapiret[ type = 'E' ] ) OR line_exists( lt_bapiret[ type = 'A' ] ).
    wd_comp_controller->mo_message_manager->add_bapiret_t( lt_bapiret ).
    wd_comp_controller->mo_message_manager->display_messages( ).
  ELSE.
    CLEAR lt_bapiret.
    MESSAGE s571(zia_2_real) INTO DATA(lv_message).
    INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_bapiret INDEX 1.
    wd_comp_controller->mo_message_manager->add_bapiret_t( lt_bapiret ).
    wd_comp_controller->mo_message_manager->display_messages( ).
  ENDIF.

  MESSAGE s016(zia_2_real) WITH iv_status io_schicht->get_id( ) INTO DATA(lv_msg).
  zcl_ia_2log=>get_instance( )->add_info( iv_sub_object = zcl_ia_2log=>mc_sub_object_statuswechsel iv_text = CONV #( lv_msg ) ).

ENDMETHOD.

METHOD set_schicht_status_s30 .
  CONSTANTS lc_status_real     TYPE j_txt04  VALUE 'real'.
  CONSTANTS lc_status_antl_d   TYPE j_txt04  VALUE 'antl'.  ">001< mod
  CONSTANTS lc_status_antl_i   TYPE j_txt04  VALUE 'altl'.  ">001< +
  DATA(lv_status_antl) = VALUE j_txt04( ).                  ">001< +

  DATA(lv_has_error) = wd_comp_controller->check_shift_release( ).
  IF lv_has_error IS NOT INITIAL.
    RETURN.
  ELSE.
*  IF syst-uname = 'E564128' OR syst-uname = 'E541515' ##USER_OK.
    DATA(lt_bapiret) = wd_comp_controller->save_shift_release(  ).
    IF line_exists( lt_bapiret[ type = 'E' ] ) OR line_exists( lt_bapiret[ type = 'A' ] ).
      wd_comp_controller->mo_message_manager->add_bapiret_t( lt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
    ELSE.
      CLEAR lt_bapiret.
      MESSAGE s570(zia_2_real) INTO DATA(lv_message).
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_bapiret INDEX 1.
      wd_comp_controller->mo_message_manager->add_bapiret_t( lt_bapiret ).
      wd_comp_controller->mo_message_manager->display_messages( ).
      DATA(lt_event_parameters) = VALUE wdr_event_parameter_list( ( name = 'ID' value = NEW string( 'BTN_EDIT' ) ) ).
      DATA(lo_btn_edit_event) = NEW cl_wd_custom_event( name = 'ON_ACTION' parameters = lt_event_parameters ).
      wd_comp_controller->z_pe_osn_tunnel_oss( io_event = lo_btn_edit_event ).
      io_schicht->set_status( zif_ia_2_wrkshft_status=>mc_shift_released ).
      wd_comp_controller->invctx_schichtdetails( ).
    ENDIF.
*  ENDIF.
    RETURN.
  ENDIF.

  ">001< + begin
  lv_status_antl = lc_status_antl_d.
  lv_status_antl = COND #( WHEN sy-langu = 'I' THEN lc_status_antl_i
                           ELSE lv_status_antl ).
  ">001< + end

  DATA(lt_status_rng) = VALUE zia_2string_range_t( ).
  lt_status_rng = VALUE #( BASE lt_status_rng ( sign   = 'I'
                                                option = 'EQ'
                                                low    = lv_status_antl ) ).  ">001< mod

  lt_status_rng = VALUE #( BASE lt_status_rng ( sign   = 'I'
                                                option = 'EQ'
                                                low    = lc_status_real ) ).

  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht            dref = REF #( io_schicht ) )
                                                                  ( name = zif_ia_2_validator=>mc_param_schicht_status     dref = REF #( iv_status  ) )
                                                                  ( name = zif_ia_2_validator=>mc_param_obj_status_str_rng dref = REF #( lt_status_rng ) )  ) ).

  TRY.

      zcl_ia_2lib_validation_a=>change_schicht_status( lo_parameters ).

    CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      wd_this->display_status_error( ix_validator = lx_validation_error ).
      RETURN.
    ##NEEDED   ##NO_HANDLER  CATCH zcx_ia_2static_check INTO DATA(lx_static_check). "#EC EMPTY_CATCH

  ENDTRY.

  TRY .

      zcl_ia_2jobpool_mmt=>get_instance( )->main( io_schicht ).

    CATCH zcx_ia_2failure INTO DATA(lx_status_error).
      wd_this->display_status_error( ix_fehler = lx_status_error ).
      RETURN.

  ENDTRY.

  io_schicht->set_status( iv_status ).
  io_schicht->save( ).
  io_schicht->distribute_gsmr( ).

  wd_comp_controller->set_schicht_no_edit_after_frgb( ).

  DATA(lo_personenortung)  = NEW zcl_ia_2person_location( io_schicht = wd_comp_controller->mo_curr_arbstelle->get_schicht( ) ).

  lo_personenortung->invoke_webservice( CHANGING co_message_manager = wd_comp_controller->mo_message_manager ).

  MESSAGE s016(zia_2_real) WITH iv_status
                                io_schicht->get_id( )
                           INTO DATA(lv_msg).

  zcl_ia_2log=>get_instance( )->add_info( iv_sub_object = zcl_ia_2log=>mc_sub_object_statuswechsel
                                           iv_text       = CONV #( lv_msg ) ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_chng_schicht_status .
  DATA(ls_schichtdetails)  = VALUE wd_this->element_schichtdetails( ).
  DATA lv_status TYPE zia_2_wrkshftstatus.

  lv_status = COND #( WHEN iv_status = 'S10' THEN '1'
                      WHEN iv_status = 'S20' THEN '2'
                      WHEN iv_status = 'S30' THEN '3'  ).

  TRY.
      CASE lv_status.
        WHEN zif_ia_2_wrkshft_status=>mc_plannig_started.
          wd_this->set_schicht_status_s10( io_schicht = io_schicht iv_status = lv_status ).
        WHEN zif_ia_2_wrkshft_status=>mc_disposition_released.
          wd_this->set_schicht_status_s20( io_schicht = io_schicht iv_status = lv_status ).
        WHEN zif_ia_2_wrkshft_status=>mc_shift_released.
          wd_this->set_schicht_status_s30( io_schicht = io_schicht iv_status = lv_status ).
        WHEN OTHERS.
          RETURN.
      ENDCASE.
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->invalidate( ).
  DATA(li_context_node) =  wd_comp_controller->get_date_markings_wdctx( ls_schichtdetails-zzperi ).
  li_context_node->invalidate( ).
  wd_comp_controller->invctx_ui_schicht( ).
ENDMETHOD.

METHOD ON_LTA_VERSORGUNG_SCHICHT .
  IF io_schicht IS NOT BOUND.
    RETURN.
  ENDIF.

  "Check if schicht is not VersorgungsSchicht -  we open new tab only for Schicht with K or E
  IF io_schicht->get_parameter( )->get_data( )-supply_type = zif_ia_2_constant=>mc_supply_type-versorgung.
    RETURN.
  ENDIF.

  DATA(lo_schicht_versorgung) = io_schicht->get_versorgung_schicht( ).
  IF lo_schicht_versorgung IS NOT BOUND.
    RETURN.
  ENDIF.

  "Open Schicht tab
  TRY.
      zcl_ia_2context_helper=>add_schicht_tab(
        EXPORTING
          io_schicht = lo_schicht_versorgung
        CHANGING
          ci_context = wd_context ).
      wd_comp_controller->mo_curr_arbstelle = lo_schicht_versorgung->get_first_arbeitsstelle( ).
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.
ENDMETHOD.

METHOD on_show_popup_gen_table .
  ##NEEDED DATA(lt_schichtplan)     = VALUE wd_this->elements_schichtplan( ).
  ##NEEDED DATA(ls_popup_gen_table) = VALUE wd_this->element_popup_gen_table( ).


  ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_sp_intvart_as ).
  ls_popup_gen_table-title = 'Blocked Sections'.

  wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->set_static_attributes( static_attributes = ls_popup_gen_table ).

  wd_comp_controller->wd_get_api( )->get_window_manager( )->create_and_open_popup(
                                                              window_name = 'W_POPUP_GEN_TABLE'
                                                              buttons     = wd_comp_controller->wd_get_api( )->get_window_manager( )->get_buttons_close( )
                                                            ).

ENDMETHOD.

endclass.
 