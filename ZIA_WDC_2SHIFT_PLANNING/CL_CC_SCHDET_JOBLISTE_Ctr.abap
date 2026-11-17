class CL_CC_SCHDET_JOBLISTE_Ctr implementation.
 
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
  wd_this->mo_cc_schdet_arbst   = wd_this->get_cc_schdet_arbst_ctr( ).
ENDMETHOD.

METHOD export_to_xls .

  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).

  DATA(lt_jobliste) = VALUE wd_this->elements_jobliste( ).

  wd_context->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste ).

  DATA(lt_jobliste_excel) = CORRESPONDING zia_2jobliste_excel_t( lt_jobliste ).

  DATA(lv_filename) = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/JOBLIST').

  DATA(lv_intervallart) = COND #( WHEN lo_schicht->is_joker( )
                                  THEN cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/JOKER_INTERVAL')
                                  ELSE cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/STANDARD_INTERVAL') ).

  DATA(lv_zugangsart_text) = ``.
  DATA(lv_zugangsart) = CONV zia_2_zugangsart( '' ).
  IF wd_comp_controller->mo_curr_arbstelle->is_pneu( ).
    lv_zugangsart_text = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/TIRE').
    lv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_strasse.
  ELSE.
    IF wd_comp_controller->mo_curr_arbstelle->is_schiene( ).
      lv_zugangsart_text = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/RAIL').
      lv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_schiene.
    ENDIF.
  ENDIF.

  DATA(lv_kurztext) = wd_comp_controller->mo_curr_arbstelle->get_text_id( lv_zugangsart ).

  CONCATENATE lv_filename lv_intervallart lv_zugangsart_text '-'  lv_kurztext INTO lv_filename SEPARATED BY space.

  REPLACE ALL OCCURRENCES OF '/' IN lv_filename WITH space.

  DATA(lv_sheet_name) = lv_filename.

  "Excel Sheet erzeugen
  DATA(lo_excel) = NEW zcl_excel( ).

  "Worksheet anlegen
  DATA(lo_worksheet) = lo_excel->get_active_worksheet( ).

  lo_worksheet->set_title( ip_title = CONV #( lv_sheet_name ) ).

  "Tabelleneigenschaften setzen
  DATA(ls_table_settings) = VALUE zexcel_s_table_settings( table_style       = 'TableStyleMedium17'
                                                           show_row_stripes  = abap_true
                                                           nofilters         = abap_true
                                                           top_left_column   = 'B'
                                                           top_left_row      = '3'
                                                         ).
  "Binding
  lo_worksheet->bind_table( ip_table          = lt_jobliste_excel
                            is_table_settings = ls_table_settings ).

  "Ersten 3 Zeilen fixieren
  lo_worksheet->freeze_panes( ip_num_rows = 3 ).

  "Überschrift
  lo_worksheet->set_cell( ip_row = 2 ip_column = 'B'
  ip_value = lv_filename ).

  " Output erzeugen
  DATA(lo_writer) = NEW zcl_excel_writer_2007( ).
  DATA(lv_xdata) = lo_writer->zif_excel_writer~write_file( lo_excel ).

  " Rückgabe
  CONCATENATE lv_filename '.xlsx' INTO lv_filename.

  wdr_task=>client_window->client->attach_file_to_response( i_filename  = lv_filename
                                                            i_content   = lv_xdata
                                                            i_mime_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ).

ENDMETHOD.

METHOD fire_auftrag_selected .

  wd_this->fire_auftrag_selected_evt( iv_aufnr = iv_aufnr iv_expanded = iv_expanded ).
ENDMETHOD.

METHOD invalidate_context .
  wd_context->get_child_node( name = wd_this->wdctx_jobliste )->invalidate( ).
  wd_this->invalidate_popin( ).
ENDMETHOD.

METHOD invalidate_popin .
  wd_context->get_child_node( name = wd_this->wdctx_table_popin_jobliste )->invalidate( ).
  wd_context->get_child_node( name = wd_this->wdctx_table_popin_jobliste
           )->get_child_node( name = wd_this->wdctx_jl_popin_detail )->invalidate( ).
ENDMETHOD.

METHOD invalidate_popin_detail .
  wd_context->get_child_node( name = wd_this->wdctx_table_popin_jobliste
         )->get_child_node( name = wd_this->wdctx_jl_popin_detail )->invalidate( ).
ENDMETHOD.

METHOD on_view_event .

  DATA(lv_event_name) = io_event->get_name( ).

  CASE lv_event_name.
    WHEN 'ON_TOGGLE'.
      DATA(lv_id) = io_event->get_string( 'ID' ).

      CASE lv_id.
        WHEN 'POPIN_JOBLISTE'. wd_this->z_toggle_popin_jobliste( io_event ).
      ENDCASE.

  ENDCASE.
ENDMETHOD.

METHOD remove_auftrag .

  DATA(lt_jobliste) = VALUE wd_this->elements_jobliste( ).
  " Define fixed phases for maintenance
  DATA lv_maintordovrlprocphase TYPE eam_ostat_phase VALUE '05'.
  DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase VALUE '0055'.

  wd_context->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste ).

  READ TABLE lt_jobliste WITH KEY table_popin = 'TABLEPOPIN_JL' ASSIGNING FIELD-SYMBOL(<ls_jobliste>).
  CHECK <ls_jobliste> IS ASSIGNED.

  TRY .
      DATA(lo_auftrag) = wd_comp_controller->mo_curr_arbstelle->get_auftrag( EXPORTING iv_key = <ls_jobliste>-aufnr ).

      wd_comp_controller->mo_curr_arbstelle->reload( ). "+>001<  "Make sure to get updated Fahrzeug values
      wd_comp_controller->mo_curr_arbstelle->check_lock_orders(
        EXPORTING
          io_object  = lo_auftrag                 " GBT/CBT: Class for the assignment
        IMPORTING
          et_bapiret = DATA(lt_bapiret)                 " Return Parameter
      ).
      IF lt_bapiret IS INITIAL.
        wd_comp_controller->mo_curr_arbstelle->remove_auftrag_o( io_object = lo_auftrag ).
      ELSE.
        RAISE EXCEPTION TYPE zcx_ia_2failure
          EXPORTING
            gt_bapiret = lt_bapiret.
      ENDIF.
      "
      DATA(ls_data) = lo_auftrag->get_data( ).
      DATA(lo_curr_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
      IF ls_data IS NOT INITIAL.
        lo_curr_schicht->deactivate_user_status( iv_qmnum = CONV zia_2_workshift( wd_comp_controller->mo_curr_arbstelle->gs_arbeitsstelle-zschicht )
                    iv_order = ls_data-aufnr ).
        " Updating Phase
        zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = ls_data-aufnr
                                                   iv_maintordovrlprocphase = lv_maintordovrlprocphase
                                                   iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).

      ENDIF.




      wd_comp_controller->mo_curr_arbstelle->refresh_ausdehung( ).

*--> Begin Insert >001<
      IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true AND
        wd_comp_controller->mo_curr_arbstelle->is_fzg_km_sa_trennung_valid( ) EQ abap_false.
        MESSAGE w071(zia_2_real) INTO DATA(lv_msg) ##NEEDED.
        wd_comp_controller->mo_message_manager->add_sys_message( ).
      ENDIF.

      wd_comp_controller->mo_curr_arbstelle->save( ).
      wd_comp_controller->mo_curr_arbstelle->get_schicht( )->reload( ).
*--> End Insert >001<

      wd_comp_controller->mo_curr_arbstelle->get_schicht( )->save( ).
      wd_comp_controller->mo_curr_arbstelle->reload( ). "+>001< "To reload AS Header text correctly
      DATA(lv_arbstelle) = wd_comp_controller->mo_curr_arbstelle->get_kurztext( ).
      MESSAGE s069(zia_2_mmt) WITH <ls_jobliste>-aufnr lv_arbstelle INTO lv_msg. "Change >001<
      wd_comp_controller->mo_message_manager->add_sys_message( ).

      wd_comp_controller->invctx_schichtdetails( ).
      wd_comp_controller->invctx_details( ).
      wd_comp_controller->invctx_sitzplatz( ).
      wd_comp_controller->invctx_fahrzeug( ).
      wd_comp_controller->invctx_jobliste( ).
      wd_comp_controller->invctx_jobpool( ).
      wd_comp_controller->invctx_as_filter( ).

    CATCH zcx_ia_2failure INTO DATA(lx_error).
      wd_comp_controller->mo_message_manager->add_bapiret_t( it_table = lx_error->gt_bapiret ).
  ENDTRY.

  IF wd_comp_controller->is_curr_arbstelle_empty( ).
    wd_this->mo_cc_schdet_arbst->delete_curr_arbstelle( ).
  ENDIF.
ENDMETHOD.

METHOD z_toggle_popin_jobliste .

  DATA(li_element)     = io_event->get_context_element( `CONTEXT_ELEMENT` ).
  DATA(lv_new_index)   = li_element->get_index( ).
  DATA(lv_is_expanded) = io_event->get_string( `EXPANDED` ).

  IF lv_is_expanded = abap_true.
    DATA(lt_jobliste) = VALUE wd_this->elements_jobliste( ).
    wd_context->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste ).
    LOOP AT lt_jobliste ASSIGNING FIELD-SYMBOL(<ls_jobliste>) WHERE table_popin <> ''.
      IF syst-tabix <> lv_new_index.
        <ls_jobliste>-table_popin = ''.
      ENDIF.
    ENDLOOP.
    wd_context->get_child_node( name = wd_this->wdctx_jobliste )->bind_table( EXPORTING new_items = lt_jobliste ).
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_jobliste )->set_lead_selection_index( index = lv_new_index ).

  DATA(ls_jobliste) = VALUE wd_this->element_jobliste( ).
  wd_context->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes( IMPORTING static_attributes = ls_jobliste ).

  wd_this->invalidate_popin_detail( ).
  wd_this->fire_auftrag_selected( iv_aufnr = ls_jobliste-aufnr iv_expanded = CONV #( lv_is_expanded ) ).

ENDMETHOD.

endclass.
 