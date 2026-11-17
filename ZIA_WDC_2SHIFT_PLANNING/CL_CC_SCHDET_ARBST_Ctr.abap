class CL_CC_SCHDET_ARBST_Ctr implementation.
 
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

  wd_this->mc_popup_delete_arbstelle = `POPUP_DELETE_ARBEITSSTELLE`.
ENDMETHOD.

METHOD delete_curr_arbstelle .
  DATA lv_order TYPE aufnr.
  " Define fixed phases for maintenance
  DATA lv_maintordovrlprocphase TYPE eam_ostat_phase VALUE '05'.
  DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase VALUE '0055'.
  CHECK wd_comp_controller->mo_curr_arbstelle IS BOUND.

  DATA(lo_curr_arbstelle) = wd_comp_controller->mo_curr_arbstelle.
  wd_comp_controller->mo_message_manager->reset( ).

  TRY .
      DATA(lo_curr_schicht) = lo_curr_arbstelle->get_schicht( ).

      IF lo_curr_arbstelle->exists( ).
        DATA(lv_arbstelle_kurztext) = lo_curr_arbstelle->get_kurztext( ).

        lo_curr_arbstelle->unlock_sub_objects( ).
        lo_curr_arbstelle->unlock( ).
        DATA(lo_orders) =  lo_curr_arbstelle->get_auftraege( ).
        READ TABLE lo_orders->map INDEX 1 INTO DATA(ls_entry).

        IF sy-subrc = 0 AND ls_entry-key IS NOT INITIAL.
          lv_order = ls_entry-key.
          lo_curr_schicht->deactivate_user_status( iv_qmnum = CONV zia_2_workshift( lo_curr_arbstelle->gs_arbeitsstelle-zschicht )
                      iv_order = lv_order ).
********          " Updating Phase
          zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = lv_order
                                                     iv_maintordovrlprocphase = lv_maintordovrlprocphase
                                                     iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).

        ENDIF.

        TRY.
            zcl_ia_2order_utils=>reset_orsc_status( io_auftraege = lo_orders ).
          ##NO_HANDLER CATCH zcx_ia_2failure." INTO DATA(lx_orsc_error).
        ENDTRY.

        lo_curr_schicht->remove_arbeitsstelle( io_object = lo_curr_arbstelle ).
        ##NEEDED       MESSAGE s122(zia_2_real) WITH lv_arbstelle_kurztext INTO DATA(lv_msg).
        wd_comp_controller->mo_message_manager->add_message( iv_msgno = sy-msgno ).
        wd_comp_controller->mo_message_manager->display_messages( ).

        lo_curr_schicht->save( ).
        lo_curr_schicht->reload( ). "+>001<

      ELSE.
        lo_curr_schicht->remove_arbeitsstelle( io_object = lo_curr_arbstelle ).

      ENDIF.

      wd_comp_controller->mo_curr_arbstelle = lo_curr_schicht->get_first_arbeitsstelle( ).

    CATCH zcx_ia_2failure INTO DATA(lx_error).
      wd_comp_controller->mo_message_manager->display_exception( lx_error ).
      RETURN.
  ENDTRY.

  wd_comp_controller->invctx_schichtdetails( ).
  wd_comp_controller->invctx_schichtplan( ).
  wd_comp_controller->invctx_auftraege_alv( ).

  wd_this->fire_arbstelle_deleted_evt( ).
ENDMETHOD.

METHOD invalidate_context .

  wd_this->invalidate_ui_arbeitsstelle( ).
  wd_this->invalidate_ui_schicht( ).
ENDMETHOD.

METHOD invalidate_ui_arbeitsstelle .

  TRY .
      wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
               )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle
               )->invalidate( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD invalidate_ui_schicht .
  TRY .
      wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
               )->get_child_node( name = wd_this->wdctx_ui_schicht
               )->invalidate( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD reload_schichtdetails .

  TRY .
      DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
      wd_comp_controller->reload_schicht( lo_schicht ).
      wd_comp_controller->invctx_schichtdetails( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD switch_arbeitsstelle_edit .
  DATA ls_ui_arbeitsstelle TYPE wd_this->element_ui_arbeitsstelle.
  DATA(lv_edit_mode)       = VALUE wdy_boolean( ).  ">001< +

  DATA(lo_curr_arbstelle) = wd_comp_controller->mo_curr_arbstelle.

  TRY .
      wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
               )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle
               )->get_static_attributes( IMPORTING static_attributes = ls_ui_arbeitsstelle ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

  CASE ls_ui_arbeitsstelle-ena_btn_as_edit.
    WHEN abap_false.
      TRY .
          IF NOT lo_curr_arbstelle->exists( ).
            wd_this->delete_curr_arbstelle( ).
          ENDIF.
          lo_curr_arbstelle->lock( iv_check = abap_false ).
          lo_curr_arbstelle->lock_sub_objects( iv_check = abap_false ).
          wd_comp_controller->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
          wd_this->reload_schichtdetails( ).
          lv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled. ">001< +
        ##NO_HANDLER      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
          wd_comp_controller->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
          wd_comp_controller->mo_message_manager->reset( ).
        ##NO_HANDLER       CATCH cx_sy_ref_is_initial INTO DATA(lx_init_ref) ##NEEDED.
      ENDTRY.

    WHEN abap_true.
      lo_curr_arbstelle->unlock( ).
      lo_curr_arbstelle->unlock_sub_objects( ).
      wd_comp_controller->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
      lv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled.  ">001< +
  ENDCASE.

*  wd_comp_controller->mo_ui_element_properties->set_ui_arbstelle_visible( io_arbeitsstelle = lo_curr_arbstelle ).
  wd_this->invalidate_ui_arbeitsstelle( ).
  wd_comp_controller->fire_on_btn_edit_evt( iv_mode = lv_edit_mode ). ">001< +
ENDMETHOD.

endclass.
 