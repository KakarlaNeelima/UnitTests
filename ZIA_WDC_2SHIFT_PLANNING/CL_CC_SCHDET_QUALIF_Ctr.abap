class CL_CC_SCHDET_QUALIF_Ctr implementation.
 
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

  wd_this->mc_popup_move_einzelkapa = `POPUP_MOVE_EINZELKAPA`.
  wd_this->mc_sitzplatze_collection = `SITZPLATZE_COLLECTION`.

  wd_this->mc_atnam_aufnr                 = `AUFNR`.
  wd_this->mc_atnam_image_for_visual      = `IMAGE_FOR_VISUALIZATION`.
  wd_this->mc_atnam_image_for_visual_copy = `IMAGE_FOR_VISUALIZATION_COPY`.

ENDMETHOD.

METHOD get_comp_popup_qualification .
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_qualification( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  ri_component = wd_this->wd_cpifc_popup_qualification( ).

ENDMETHOD.

METHOD get_current_perimeter .
  TRY .
      DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).
      rv_value = lo_schicht->get_data( )-zzperi.

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD get_dd_tags_qualif .
  FIELD-SYMBOLS <ls_dd_source> LIKE LINE OF rt_tags.
  FIELD-SYMBOLS <ls_dd_target> LIKE LINE OF rt_tags.
  DATA li_dd_flavor TYPE REF TO zif_ia_2dd_flavor.

  DATA(lo_fahrzeuge)   = io_arbstelle->get_fahrzeuge( ).
  DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

  WHILE li_fahrzeuge_i->has_next( ).
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).

    INSERT VALUE #( zugangsart = COND #( WHEN lo_fahrzeug->is_basis_fz_pneu( )
                                         THEN zcl_ia_2utilities2=>mc_zugangsart_strasse
                                         ELSE zcl_ia_2utilities2=>mc_zugangsart_schiene )
                    zid_fzg    = lo_fahrzeug->get_id( )
                  ) INTO TABLE rt_tags.

  ENDWHILE.

  LOOP AT rt_tags ASSIGNING <ls_dd_source>.
    li_dd_flavor = zcl_ia_2utils_wd_a=>get_flavor_move_qualif( <ls_dd_source>-zid_fzg ).
    <ls_dd_source>-drag_qualif_tags = li_dd_flavor->gv_string.
  ENDLOOP.

  LOOP AT rt_tags ASSIGNING <ls_dd_source>.
    LOOP AT rt_tags ASSIGNING <ls_dd_target> USING KEY dd_eval "#EC CI_NESTED
        WHERE zugangsart = <ls_dd_source>-zugangsart.
      CHECK <ls_dd_target>-zid_fzg <> <ls_dd_source>-zid_fzg.
*      CHECK <ls_dd_target>-zid_fzg = <ls_dd_source>-zid_fzg.
      <ls_dd_source>-drop_tags = |{ COND #( WHEN <ls_dd_source>-drop_tags IS INITIAL THEN `` ELSE |{ <ls_dd_source>-drop_tags } | ) }{ <ls_dd_target>-drag_qualif_tags }|.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD get_einzelkapa_for_id .
  DATA(lt_sitzplatz_elems) = wd_context->get_child_node( name = wd_this->wdctx_sitzplatz
                                     )->get_elements( ).

  LOOP AT lt_sitzplatz_elems ASSIGNING FIELD-SYMBOL(<li_elem_sitzplatz>).

    DATA(lt_einzelkapa_elems) = <li_elem_sitzplatz>->get_child_node( name = wd_this->wdctx_einzelkapas )->get_elements( ).

    LOOP AT lt_einzelkapa_elems ASSIGNING FIELD-SYMBOL(<li_elem_einzelkapa>). "#EC CI_NESTED
      DATA(ls_einzelkapa) = VALUE wd_this->element_einzelkapas( ).

      <li_elem_einzelkapa>->get_static_attributes( IMPORTING static_attributes = ls_einzelkapa ).
      CHECK ls_einzelkapa-job_id = iv_id.

      ro_instance = ls_einzelkapa-object.

    ENDLOOP.

  ENDLOOP.
ENDMETHOD.

METHOD get_selected_sitzplatze .
  DATA(lo_object_collection) = NEW cl_object_collection( ).

  DATA(ls_sitzplatz) = VALUE wd_this->element_sitzplatz( ).
  DATA(lv_occupied_selected) = abap_false.

  DATA(lt_elements) = wd_context->get_child_node( name = wd_this->wdctx_sitzplatz )->get_elements( ).
  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).
    CHECK ls_sitzplatz-auswahl = abap_true.
    lv_occupied_selected = abap_true.

    CHECK ls_sitzplatz-object->is_frei( ).
    lv_occupied_selected = abap_false.

    lo_object_collection->add( <li_element> ).
  ENDLOOP.

  IF lo_object_collection->is_empty( ).

    ##NEEDED   DATA(lv_msg) = ``.
    IF lv_occupied_selected = abap_true.
      MESSAGE e011(zia_2_real) INTO lv_msg.
    ELSE.
      MESSAGE e010(zia_2_real) INTO lv_msg.
    ENDIF.
    wd_comp_controller->mo_message_manager->add_message( iv_msgno = sy-msgno ).
    wd_comp_controller->mo_message_manager->display_messages( ).
    wd_comp_controller->mo_message_manager->reset( ).
    RETURN.

  ELSE.

    ri_parameters = NEW zcl_ia_2parameters_generic( VALUE zia_2parameters_t( ( name = wd_this->mc_sitzplatze_collection
                                                                                 dref = REF #( lo_object_collection ) ) ) ).

  ENDIF.

ENDMETHOD.

METHOD get_sitzplatz_from_ctx_elem .
  DATA(ls_sitzplatz) = VALUE wd_this->element_sitzplatz( ).
  io_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).

  ro_instance = ls_sitzplatz-object.
ENDMETHOD.

METHOD invalidate_context .
  wd_this->invalidate_sitzplatze( ).
  wd_this->invalidate_einzelkapas( ).

  TRY .
      wd_context->get_child_node( wd_this->wdctx_fahrzeug )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD invalidate_einzelkapas .
  TRY .
      wd_context->get_child_node( wd_this->wdctx_sitzplatz
               )->get_child_node( wd_this->wdctx_einzelkapas
               )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD invalidate_sitzplatze .
  TRY .
      wd_context->get_child_node( wd_this->wdctx_sitzplatz )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD move_einzelkapa_to_sitzplatz .
  TRY .
      DATA(lo_einzelkapa) = wd_this->get_einzelkapa_for_id( iv_einzelkapa_id ).
      DATA(lo_sitzplatz)  = wd_this->get_sitzplatz_from_ctx_elem( io_sitzplatz_element ).
      CHECK lo_einzelkapa IS BOUND
        AND lo_sitzplatz  IS BOUND.
      " Do not move Einzelkapa to its currently assigned Sitzplatz
      CHECK NOT lo_einzelkapa->is_assigned_to( lo_sitzplatz ).

      DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_einzelkapazitaet
                                                                        dref = REF #( lo_einzelkapa ) )
                                                                      ( name = zif_ia_2_validator=>mc_param_sitzplatz
                                                                        dref = REF #( lo_sitzplatz ) ) )
                                                           ).

      zcl_ia_2lib_validation_a=>move_einzelkapa_to_sitzplatz( ii_parameters = lo_parameters ).

      z_move_einkapa_to_splatz( io_einzelkapa = lo_einzelkapa
                                io_sitzplatz  = lo_sitzplatz ).

    CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      DATA(lv_message) = lx_validation_error->get_text( ).
      DATA(lt_message) = VALUE string_table( ( lv_message )
                                             ( cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ALLOCATE_CAPACITY_ANYWAY` ) )
                                           ).

      wd_comp_controller->open_popup_message_with_params( iv_popup_id     = wd_this->mc_popup_move_einzelkapa
                                                          io_parameters   = lo_parameters
                                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/CONFIRM_ASSIGNMENT` )
                                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ASSIGN_ANYWAY` )
                                                          it_text         = lt_message ).

    CATCH zcx_ia_2static_check INTO DATA(lx_static_check).
      wd_this->wd_get_api( )->get_message_manager( )->report_error_message(
        message_text = lx_static_check->get_text( ) ).

  ENDTRY.

ENDMETHOD.

METHOD move_qualif_to_sitzplatz .
  DATA(lo_source_sitzplatz) = wd_comp_controller->mo_curr_arbstelle->get_sitzplatz_by_id( iv_source_sitzplatz_id ).
  DATA(lo_target_sitzplatz) = wd_this->get_sitzplatz_from_ctx_elem( io_target_sitzplatz_elem ).

  wd_this->z_move_qualif_to_sitzplatz( io_source_sitzplatz = lo_source_sitzplatz
                              io_target_sitzplatz = lo_target_sitzplatz ).

  wd_this->invalidate_context( ).

ENDMETHOD.

METHOD open_popup_qualification .
  DATA(li_parameters) = wd_this->get_selected_sitzplatze( ).
  CHECK li_parameters IS BOUND.

  DATA(lv_perimeter)  = wd_this->get_current_perimeter( ).
  DATA(lo_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).

  DATA(li_popup_qualification) = wd_this->get_comp_popup_qualification( ).

  li_popup_qualification->open( ii_parameters = li_parameters
                                iv_perimeter  = lv_perimeter
                                io_schicht    = lo_schicht ).

ENDMETHOD.

METHOD supply_sitzplatze .
  CONSTANTS lc_max_frei_pneu TYPE int1 VALUE 3.
  DATA(lv_curr_frei_pneu)    = VALUE int1( ).


  DATA(lo_arbstelle)   = wd_comp_controller->mo_curr_arbstelle.
  DATA(lt_dd_tags)     = wd_this->get_dd_tags_qualif( lo_arbstelle ).
  DATA(lo_fahrzeuge)   = lo_arbstelle->get_fahrzeuge( ).
  DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).
  DATA(lt_vis_quali)   = VALUE wd_this->elements_sitzplatz( ).

  WHILE li_fahrzeuge_i->has_next( ).
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).

    DATA(lv_fzgid) = lo_fahrzeug->get_id( ).
    DATA(lv_zugangsart) = lo_fahrzeug->get_zugangsart( ).
    DATA(lv_arbstelle) = lo_arbstelle->get_text_id( lv_zugangsart ).

    DATA(lo_sitzplaetze) = lo_fahrzeug->get_sitzplaetze( ).
    DATA(li_sitzplaetze_i) = lo_sitzplaetze->get_values_iterator( ).

    ##NEEDED   DATA(lv_tff_flag) = abap_true.
    WHILE li_sitzplaetze_i->has_next( ).
      DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplaetze_i->get_next( ) ).

      IF lo_sitzplatz->get_fahrzeug( )->is_basis_fz_pneu( ) AND
         lo_sitzplatz->is_frei( ) = abap_true.
        lv_curr_frei_pneu = lv_curr_frei_pneu + 1.
        CHECK lv_curr_frei_pneu <= lc_max_frei_pneu.
      ENDIF.

      DATA(lv_auslastung) = |{ lo_sitzplatz->get_auslastung( ) ALPHA = OUT }|.
      CONDENSE lv_auslastung.
      lv_auslastung = |{ lv_auslastung }% ({ lo_sitzplatz->get_dlz( ) }/{ lo_sitzplatz->get_dlz_max( ) })|.

      DATA(ls_vis_quali) = VALUE wd_this->element_sitzplatz( ).

      ls_vis_quali-arbstelle = lv_arbstelle.
      ls_vis_quali-al         = lo_sitzplatz->is_al( ).
      ls_vis_quali-cpm        = lo_sitzplatz->is_cpm( ).
      ls_vis_quali-sc         = lo_sitzplatz->is_sc( ).
      ls_vis_quali-thf        = lo_sitzplatz->is_thf( ).
      ls_vis_quali-bg         = lo_sitzplatz->is_bg( ).
      ls_vis_quali-auslastung = lv_auslastung.
      ls_vis_quali-object     = lo_sitzplatz.
      ls_vis_quali-zplatz_nr  = lo_sitzplatz->get_id( ).
      ls_vis_quali-quali      = lo_sitzplatz->get_quali_ktext( ).
      ls_vis_quali-quali_txt  = lo_sitzplatz->get_quali_txt( ).

      IF lo_sitzplatz->get_data( )-nicht_belegt = abap_false.
        ls_vis_quali-nachname  = lo_sitzplatz->get_nachname( ).
        ls_vis_quali-name      = |{ lo_sitzplatz->get_nachname( ) }| & |, | & |{ lo_sitzplatz->get_vorname( ) }|.
        ls_vis_quali-name      = COND #( WHEN lo_sitzplatz->get_firma( ) IS NOT INITIAL THEN |{ ls_vis_quali-name }| & | ({ lo_sitzplatz->get_firma( ) })|
                                         ELSE ls_vis_quali-name ).
      ELSE.
        ls_vis_quali-nachname = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SEAT_NOT_OCCUPIED' ).
        ls_vis_quali-name     = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SEAT_NOT_OCCUPIED' ).
      ENDIF.

      ls_vis_quali-img_source  = COND #( WHEN lo_fahrzeug->is_basis_fz_pneu( ) THEN '~Icon/Tractor' ELSE '~Icon/Train' ).
      ls_vis_quali-style_class = COND #( WHEN lo_fahrzeug->is_basis_fz_pneu( ) THEN 'myPneuFzg' ELSE '' ).

      ls_vis_quali-fz_id = lv_fzgid.
      SHIFT ls_vis_quali-fz_id LEFT DELETING LEADING '0'.

      DATA(lv_reihung) = lo_fahrzeug->get_reihung( ).
      ls_vis_quali-fz_bez = lo_fahrzeug->get_bezeichnung( ).
      ls_vis_quali-fz_sort = |{ lv_zugangsart }{ ls_vis_quali-arbstelle }.{ COND #( WHEN lv_reihung IS NOT INITIAL THEN lv_reihung ELSE '99' ) }|.

      DATA(lv_repl) = zcl_ia_2utilities=>mc_intervart_sp_ts && '.'. "#EC TEXT_ASSEMBLY
      REPLACE ALL OCCURRENCES OF lv_repl IN ls_vis_quali-fz_bez WITH '.'. "#EC TEXT_ASSEMBLY

      IF   lo_sitzplatz->is_frei( )
        OR lo_sitzplatz->is_reserviert( ).
        ls_vis_quali-al_enabled  = abap_false.
        ls_vis_quali-cpm_enabled = abap_false.
        ls_vis_quali-sc_enabled  = abap_false.
        ls_vis_quali-thf_enabled = abap_false.
        ls_vis_quali-bg_enabled  = abap_false.
        ls_vis_quali-is_fz_dragpic_visible = abap_false.
      ELSE.
        IF lo_arbstelle->has_osx( ).
          ls_vis_quali-cpm_enabled = abap_false.
        ELSE.
          ls_vis_quali-cpm_enabled = abap_true.
        ENDIF.
        IF lo_arbstelle->is_btg( ).
          ls_vis_quali-cpm_enabled = abap_false.
        ENDIF.
        ls_vis_quali-al_enabled  = abap_true.
        ls_vis_quali-sc_enabled  = abap_true.
        ls_vis_quali-thf_enabled = abap_true.
        ls_vis_quali-bg_enabled  = abap_true.
        ls_vis_quali-is_fz_dragpic_visible = abap_true.
        ls_vis_quali-is_fz_dragpic_enabled = abap_true.
      ENDIF.

      IF lo_fahrzeug->is_basis_fz_pneu( ).
        ls_vis_quali-is_fz_dragpic_visible = abap_false.
        ls_vis_quali-is_fz_dragpic_enabled = abap_false.
      ENDIF.

      TRY.
          DATA(li_flavor_move_ek) = zcl_ia_2utils_wd_a=>get_flavor_move_einzelkapa( lv_zugangsart ).
          ls_vis_quali-drag_qualif_tags = lt_dd_tags[ zid_fzg = lv_fzgid ]-drag_qualif_tags.
          DATA(lv_drop_qualif_tags) = COND #( WHEN lo_sitzplatz->is_frei( )
                                              THEN |{ lt_dd_tags[ zid_fzg = lv_fzgid ]-drop_tags }|
                                              ELSE `` ).

          ls_vis_quali-drop_tags = |MOVE_JOB { lv_drop_qualif_tags } { li_flavor_move_ek->gv_string }|.

        ##NO_HANDLER     CATCH cx_no_check INTO DATA(lx_error_dd) ##NEEDED.
      ENDTRY.

      APPEND ls_vis_quali TO lt_vis_quali.

    ENDWHILE.
  ENDWHILE.

  SORT lt_vis_quali BY fz_sort ASCENDING zplatz_nr ASCENDING.

  node->bind_table( new_items            = lt_vis_quali
                    set_initial_elements = abap_true ).

  wd_this->invalidate_einzelkapas( ).

ENDMETHOD.

METHOD z_mark_einzelkapas_by_aufnr .
  DATA(lv_aufnr)       = VALUE aufnr( ).
  DATA(lv_img_current) = VALUE zia_2_image_for_visualization( ).
  DATA(lv_img_copy)    = VALUE zia_2_image_for_visualization( ).
  DATA(lt_einzelkapas) = VALUE wd_this->elements_einzelkapas( ) ##NEEDED.

  DATA(lv_image_sel) = zif_ia_2_wd_indiv_capacity=>mc_image_selected.

  TRY.
      DATA(lt_sitzplatz_elems) = wd_context->get_child_node( name = wd_this->wdctx_sitzplatz )->get_elements( ).

      LOOP AT lt_sitzplatz_elems ASSIGNING FIELD-SYMBOL(<li_elem_sitzplatz>).
        DATA(lt_einzelkapas_elems) = <li_elem_sitzplatz>->get_child_node( name = wd_this->wdctx_einzelkapas )->get_elements( ).

        LOOP AT lt_einzelkapas_elems ASSIGNING FIELD-SYMBOL(<li_elem_einzelkapas>). "#EC CI_NESTED
          <li_elem_einzelkapas>->get_attribute( EXPORTING name = wd_this->mc_atnam_aufnr IMPORTING value = lv_aufnr ).
          <li_elem_einzelkapas>->get_attribute( EXPORTING name = wd_this->mc_atnam_image_for_visual IMPORTING value = lv_img_current ).
          <li_elem_einzelkapas>->get_attribute( EXPORTING name = wd_this->mc_atnam_image_for_visual_copy IMPORTING value = lv_img_copy ).

          IF iv_expanded = abap_true AND lv_aufnr = iv_aufnr.
            <li_elem_einzelkapas>->set_attribute( name = wd_this->mc_atnam_image_for_visual value = lv_image_sel ).
            CHECK lv_img_current <> lv_image_sel.
            <li_elem_einzelkapas>->set_attribute( name = wd_this->mc_atnam_image_for_visual_copy value = lv_img_current ).
          ELSEIF lv_img_copy IS NOT INITIAL.
            <li_elem_einzelkapas>->set_attribute( name = wd_this->mc_atnam_image_for_visual value = lv_img_copy ).
            CLEAR lv_img_copy.
            <li_elem_einzelkapas>->set_attribute( name = wd_this->mc_atnam_image_for_visual_copy value = lv_img_copy ).
          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ##NO_HANDLER   CATCH cx_no_check INTO DATA(lx_error) ##NEEDED.

  ENDTRY.

ENDMETHOD.

METHOD z_move_einkapa_to_splatz .
  io_einzelkapa->assign_to_sitzplatz( io_sitzplatz ).

  wd_this->invalidate_context( ).

  wd_this->fire_einzelkapa_moved_evt( ).

ENDMETHOD.

METHOD z_move_qualif_to_sitzplatz .
  DATA(ls_source_sitzplatz) = io_source_sitzplatz->get_data( ).

  io_target_sitzplatz->set_qualifikation( iv_objty = ls_source_sitzplatz-zobjty
                                          iv_objid = ls_source_sitzplatz-zobjid ).

  z_move_sitzplatz_attribs( io_source_sitzplatz = io_source_sitzplatz
                            io_target_sitzplatz = io_target_sitzplatz ).

  DATA(li_einzelkapas_i) = io_source_sitzplatz->get_einzelkapas_o( )->get_values_iterator( ).
  WHILE li_einzelkapas_i->has_next( ).
    DATA(lo_einzelkapa) = CAST zcl_ia_2indiv_capcity( li_einzelkapas_i->get_next( ) ).
    TRY .
        io_source_sitzplatz->remove_einzelkapazitaet_o( io_einzelkapa = lo_einzelkapa ).
        io_target_sitzplatz->add_einzelkapazitaet_o( io_einzelkapa    = lo_einzelkapa
                                                     iv_ignore_errors = abap_true ).
      ##NO_HANDLER     CATCH zcx_ia_2failure INTO DATA(lx_error) ##NEEDED.
    ENDTRY.
  ENDWHILE.

  IF io_source_sitzplatz->get_einzelkapas_o( )->is_empty( ).
    io_source_sitzplatz->set_qualifikation( ).
  ENDIF.

  io_source_sitzplatz->save( ).
  io_target_sitzplatz->save( ).

ENDMETHOD.

METHOD z_move_sitzplatz_attribs .
  CHECK io_source_sitzplatz IS BOUND
     AND io_target_sitzplatz IS BOUND.

  DATA(ls_source_sitzplatz) = io_source_sitzplatz->get_data( ).

  IF   ls_source_sitzplatz-uname    IS NOT INITIAL
    OR ls_source_sitzplatz-nachname IS NOT INITIAL.

    " Set attributes from Source into Target
    io_target_sitzplatz->set_uname( ls_source_sitzplatz-uname ).
    io_target_sitzplatz->set_vorname( ls_source_sitzplatz-vorname ).
    io_target_sitzplatz->set_nachname( ls_source_sitzplatz-nachname ).
    io_target_sitzplatz->set_firma( ls_source_sitzplatz-firma ).
    io_target_sitzplatz->set_telefonnummer( ls_source_sitzplatz-telefonnummer ).
    io_target_sitzplatz->set_sprache( ls_source_sitzplatz-spras ).
    io_target_sitzplatz->set_al( ls_source_sitzplatz-is_al ).
    io_target_sitzplatz->set_changed_flag( abap_false ).
    io_target_sitzplatz->set_id_main( ls_source_sitzplatz-id_main ).


    " Clear attributes in Source
    io_source_sitzplatz->set_uname( '' ).
    io_source_sitzplatz->set_vorname( '' ).
    io_source_sitzplatz->set_nachname( '' ).
    io_source_sitzplatz->set_firma( '' ).
    io_source_sitzplatz->set_telefonnummer( '' ).
    io_source_sitzplatz->set_sprache( '' ).
    io_source_sitzplatz->set_al( abap_false ).

    DATA(lv_id_main_init) = VALUE sysuuid_x16( ).
    io_source_sitzplatz->set_id_main( lv_id_main_init  ).

  ENDIF.

  io_target_sitzplatz->set_nicht_belegt( ls_source_sitzplatz-nicht_belegt ).
  io_source_sitzplatz->set_nicht_belegt( abap_false ).

  IF io_source_sitzplatz->is_cpm( ).
    io_target_sitzplatz->set_cpm( abap_true ).
    io_source_sitzplatz->set_cpm( abap_false ).
  ENDIF.

  IF io_source_sitzplatz->is_sc( ).
    io_target_sitzplatz->set_sc( abap_true ).
    io_source_sitzplatz->set_sc( abap_false ).
  ENDIF.

  IF io_source_sitzplatz->is_thf( ).
    io_target_sitzplatz->set_thf( abap_true ).
    io_source_sitzplatz->set_thf( abap_false ).
  ENDIF.

  IF io_source_sitzplatz->is_bg( ).
    io_target_sitzplatz->set_bg( abap_true ).
    io_source_sitzplatz->set_bg( abap_false ).
  ENDIF.

  IF io_source_sitzplatz->is_reserviert( ).
    io_target_sitzplatz->set_reserviert( abap_true ).
  ENDIF.

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_auftrag_selected .
  wd_this->z_mark_einzelkapas_by_aufnr( iv_aufnr = iv_aufnr iv_expanded = iv_expanded ).
ENDMETHOD.

METHOD on_move_einzelkapa_confirmed .
  CHECK iv_popup_id = wd_this->mc_popup_move_einzelkapa.

  DATA(lo_einzelkapa) = CAST zcl_ia_2indiv_capcity( io_parameters->get_object( zif_ia_2_validator=>mc_param_einzelkapazitaet ) ).
  DATA(lo_sitzplatz)  = CAST zcl_ia_2seat( io_parameters->get_object( zif_ia_2_validator=>mc_param_sitzplatz ) ).

  z_move_einkapa_to_splatz( io_einzelkapa = lo_einzelkapa
                            io_sitzplatz  = lo_sitzplatz ).

ENDMETHOD.

METHOD on_qualification_selected .
  DATA lo_sitzplatz TYPE REF TO zcl_ia_2seat.

  CHECK is_qualification-zobjid IS NOT INITIAL.

  DATA(li_object_collection) = CAST if_object_collection( ii_parameters->get_object( wd_this->mc_sitzplatze_collection ) ).
  DATA(li_object_iterator)   = CAST if_object_collection_iterator( li_object_collection->get_iterator( ) ).

  WHILE li_object_iterator->has_next( ).
    TRY .
        DATA(li_element) = CAST if_wd_context_element( li_object_iterator->get_next( ) ).
        li_element->get_attribute( EXPORTING name  = `OBJECT`
                                   IMPORTING value = lo_sitzplatz ).
        lo_sitzplatz->set_qualifikation( iv_objty = is_qualification-zobjty
                                         iv_objid = is_qualification-zobjid ).
        lo_sitzplatz->save( ).
      ##NEEDED     ##NO_HANDLER     CATCH cx_no_check INTO DATA(lx_error).
    ENDTRY.
  ENDWHILE.

  wd_this->invalidate_sitzplatze( ).

ENDMETHOD.

METHOD ON_REIHUNG_CHANGED .
  wd_this->invalidate_context( ).
ENDMETHOD.

endclass.
 