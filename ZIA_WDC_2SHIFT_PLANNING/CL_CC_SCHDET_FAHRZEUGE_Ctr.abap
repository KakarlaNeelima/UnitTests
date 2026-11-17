class CL_CC_SCHDET_FAHRZEUGE_Ctr implementation.
 
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
  wd_this->mc_popup_add_fahrzeuge = `ADD_FAHRZEUGE`.
  wd_this->init_controllers( ).  ">001< +
ENDMETHOD.

METHOD check_add_fahrzeuge .
  DATA(lt_fztype_count) = VALUE wd_this->elements_fahrzeug_type_count( ).
  wd_context->get_child_node( name = wd_this->wdctx_fahrzeug_type_count
           )->get_static_attributes_table( IMPORTING table = lt_fztype_count ).
  DELETE lt_fztype_count WHERE fz_count IS INITIAL.

  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_arbeitsstelle
                                                                    dref = REF #( wd_comp_controller->mo_curr_arbstelle ) )
                                                                  ( name = zif_ia_2_validator=>mc_param_fahrzeug_type_count
                                                                    dref = REF #( lt_fztype_count ) )
                                                       ) ).

  TRY .
      zcl_ia_2lib_validation_a=>add_fahrzeuge_to_arbeitsstelle( lo_parameters ).

      z_add_fahrzeuge( io_arbeitsstelle = wd_comp_controller->mo_curr_arbstelle
                       it_fztype_count  = lt_fztype_count ).

    CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      DATA(lv_message) = lx_validation_error->get_text( ).
      DATA(lt_message) = VALUE string_table( ( lv_message ) ).
      APPEND LINES OF lx_validation_error->gt_text_info TO lt_message.
      APPEND cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ADD_VEHICLES_TO_WORKPLACE_ANYWAY` ) TO lt_message.

      wd_comp_controller->open_popup_message_with_params( iv_popup_id     = wd_this->mc_popup_add_fahrzeuge
                                                          io_parameters   = lo_parameters
                                                          iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ADD_VEHICLES_CONFIRM` )
                                                          iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                                          iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ADD_ANYWAY` )
                                                          it_text         = lt_message ).
    ##NEEDED   ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_check). "#EC EMPTY_CATCH
  ENDTRY.

ENDMETHOD.

METHOD get_dd_tags_fahrzeug .
  DATA li_dd_flavor    TYPE REF TO zif_ia_2dd_flavor.
  DATA(lo_arbstelle)   = wd_comp_controller->mo_curr_arbstelle.
  DATA(lo_fahrzeuge)   = lo_arbstelle->get_fahrzeuge( ).
  DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

  WHILE li_fahrzeuge_i->has_next( ).
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).
    APPEND VALUE #( zugangsart = COND #( WHEN lo_fahrzeug->is_basis_fz_pneu( ) THEN zcl_ia_2utilities2=>mc_zugangsart_strasse
                                         ELSE zcl_ia_2utilities2=>mc_zugangsart_schiene )
                     zid_fzg   = lo_fahrzeug->get_id( )
                   ) TO rt_tags.
  ENDWHILE.

  "Set source tags
  LOOP AT rt_tags ASSIGNING FIELD-SYMBOL(<ls_dd_source>).
    li_dd_flavor = zcl_ia_2utils_wd_a=>get_flavor_move_fahrzeug( <ls_dd_source>-zid_fzg ).
    <ls_dd_source>-drag_tags = li_dd_flavor->gv_string.
  ENDLOOP.

  "Set target tags
  LOOP AT rt_tags ASSIGNING <ls_dd_source>.
    "Tag for Material Table
    <ls_dd_source>-drop_tags = zif_ia_2_wd_mat_table=>mc_dd_flavor_move.

    "... other tags (concatenate with space)

  ENDLOOP.

ENDMETHOD.

METHOD get_fahrzeug_from_ctx_el .
  DATA(ls_fahrzeug) = VALUE wd_this->element_fahrzeug( ).


  io_element->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).
  ro_instance = ls_fahrzeug-object.

ENDMETHOD.

METHOD get_orientation_from_element .
  TRY .
      DATA(ls_orientation) = VALUE wd_this->element_orientierung_dd( ).

      DATA(li_orientation_elem) = io_fahrzeug_elem->get_child_node( name = wd_this->wdctx_orientierung_dd ).
      li_orientation_elem->get_static_attributes( EXPORTING index             = iv_orient_index
                                                  IMPORTING static_attributes = ls_orientation ).

      rv_value = ls_orientation-orientierung.

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD get_reihung_free .
  wd_context->get_child_node( name = wd_this->wdctx_reihung_free )->get_static_attributes_table( IMPORTING table = rt_value ).

ENDMETHOD.

METHOD get_reihung_from_element .
  TRY .
      DATA(ls_reihung) = VALUE wd_this->element_reihung_dd( ).

      DATA(li_reihung_elem) = io_fahrzeug_elem->get_child_node( name = wd_this->wdctx_reihung_dd ).
      li_reihung_elem->get_static_attributes( EXPORTING index             = iv_reihung_index
                                              IMPORTING static_attributes = ls_reihung ).

      rv_value = ls_reihung-nummerierung.

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD init_controllers .
  wd_this->mo_schdet_mat_table = wd_this->get_cc_schdet_mat_table_ctr( ).
ENDMETHOD.

METHOD invalidate_fahrzeug .
  TRY .
      wd_context->get_child_node( wd_this->wdctx_fahrzeug )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD invalidate_reihung_free .

  TRY .
      wd_context->get_child_node( wd_this->wdctx_reihung_free )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD move_material_to_fahrzeug .

  DATA(lt_mat_table) = wd_this->mo_schdet_mat_table->get_data_from_selection( ).
  DATA(lo_fahrzeug)  = wd_this->get_fahrzeug_from_ctx_el( io_element = io_fzg_element ).
  DATA(lt_matfzg)    = wd_this->mo_schdet_mat_table->convert_mat_to_matfzg( it_mat_table = lt_mat_table io_fahrzeug = lo_fahrzeug ).

  LOOP AT lt_matfzg ASSIGNING FIELD-SYMBOL(<ls_matfzg>).
    lo_fahrzeug->add_material( is_data = <ls_matfzg> ).
  ENDLOOP.

  wd_this->mo_schdet_mat_table->invalidate_mat_fzg( ).
  wd_this->mo_schdet_mat_table->invalidate_mat_table_data( ).

ENDMETHOD.

METHOD set_orientation_of_fahrzeug .
  CONSTANTS lc_orient_src_manual   TYPE zia_2_orientierung_src VALUE 'M'.  ">001< (+)
  CONSTANTS lc_orient_src_not_spec TYPE zia_2_orientierung_src VALUE ''.   ">001< (+)

  DATA(ls_fahrzeug) = VALUE wd_this->element_fahrzeug( ).
  DATA(lv_orientierung_src) = VALUE zia_2_orientierung_src( ).

  DATA(lv_orient) = get_orientation_from_element( io_fahrzeug_elem = io_fahrzeug_elem
                                                  iv_orient_index  = iv_orient_index ).

  io_fahrzeug_elem->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).

  ls_fahrzeug-object->set_orientierung( lv_orient ).

  lv_orientierung_src = COND #( WHEN lv_orient IS NOT INITIAL THEN lc_orient_src_manual ELSE lc_orient_src_not_spec ).  ">001< (+)
  ls_fahrzeug-object->set_orientierung_src( lv_orientierung_src  ).                                                     ">001< (+)

  ls_fahrzeug-object->save( ).

  wd_this->invalidate_fahrzeug( ).

  wd_this->fire_orientation_changed_evt( EXPORTING io_fahrzeug = ls_fahrzeug-object iv_orient = lv_orient ).

ENDMETHOD.

METHOD set_reihung_to_fahrzeug .
  DATA(ls_fahrzeug) = VALUE wd_this->element_fahrzeug( ).

  DATA(lv_reihung) = get_reihung_from_element( io_fahrzeug_elem = io_fahrzeug_elem
                                               iv_reihung_index = iv_reihung_index ).

  io_fahrzeug_elem->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).

  ls_fahrzeug-object->set_reihung( lv_reihung ).
  ls_fahrzeug-object->save( ).

  wd_this->invalidate_fahrzeug( ).

  wd_this->fire_reihung_changed_evt( io_fahrzeug = ls_fahrzeug-object ).

ENDMETHOD.

METHOD supply_fahrzeuge .
  DATA lv_convert  TYPE p.
  DATA lv_as_ktext TYPE char3. ">002< +

  DATA(lo_arbstelle) = wd_comp_controller->mo_curr_arbstelle.
  DATA(lt_dd_tags)   = wd_this->get_dd_tags_fahrzeug( lo_arbstelle  ). ">001< +
  DATA(lo_fahrzeuge) = lo_arbstelle->get_fahrzeuge( ).
  DATA(lo_schicht)   = lo_arbstelle->get_schicht( ).          ">002< +

  DATA(li_fahrzeuge_i) = lo_fahrzeuge->get_values_iterator( ).

  DATA(lt_fahrzeuge) = VALUE wd_this->elements_fahrzeug( ).

  WHILE li_fahrzeuge_i->has_next( ).
    DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).
    CHECK NOT lo_fahrzeug->is_basis_fz_pneu( ).
    DATA(lv_fzgid) = lo_fahrzeug->get_id( ).         ">001< +
    APPEND VALUE #( object = lo_fahrzeug ) TO lt_fahrzeuge ASSIGNING FIELD-SYMBOL(<ls_fahrzeug>).

    DATA(lv_anz_ek) = VALUE i( ).
    DATA(lv_sum_ek) = VALUE i( ).
    DATA(lv_sum_belegte_sitzplatz) = VALUE i( ).

    DATA(li_sitzplatz_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
    WHILE li_sitzplatz_i->has_next( ).
      DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplatz_i->get_next( ) ).

      lv_sum_belegte_sitzplatz = COND #( WHEN lo_sitzplatz->is_frei( ) THEN lv_sum_belegte_sitzplatz ELSE lv_sum_belegte_sitzplatz + 1 ).

      DATA(li_einzelkapas_i) = lo_sitzplatz->get_einzelkapas_o( )->get_values_iterator( ).
      WHILE li_einzelkapas_i->has_next( ).
        DATA(lo_einzelkapa) = CAST zcl_ia_2indiv_capcity( li_einzelkapas_i->get_next( ) ).
        lv_anz_ek = lv_anz_ek + 1.
        lv_sum_ek = lv_sum_ek + lo_einzelkapa->get_data( )-zdauer.
      ENDWHILE.
    ENDWHILE.

    lv_convert = lv_anz_ek.
    DATA(lv_anzahl) = CONV string( lv_convert ).

    lv_convert = lv_sum_ek.
    DATA(lv_dauer)  = CONV string( lv_convert ).

    DATA(lv_ek_text) = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/EK_AND_TOTAL_DURATION' ).
    CONCATENATE lv_anzahl lv_ek_text lv_dauer 'Min' INTO DATA(lv_text_tooltip).

    zcl_ia_2utilities2=>get_mime_pfad_by_fztyp( EXPORTING iv_fztype       = lo_fahrzeug->get_fahrzeugtyp( )-zid_fztyp
                                                          iv_orientierung = lo_fahrzeug->get_orientierung( )
                                                IMPORTING ev_mime_pfad    = DATA(lv_mime_pfad) ).

    CONCATENATE zcl_ia_2utilities2=>mc_mime_pfad_images lv_mime_pfad INTO <ls_fahrzeug>-fz_img_source.

    lv_sum_ek = lv_sum_ek * '0.25'  ##LITERAL.

    <ls_fahrzeug>-arbstelle = lo_arbstelle->get_text_id( zcl_ia_2utilities2=>mc_zugangsart_schiene ).
    <ls_fahrzeug>-fahrzeug = lo_fahrzeug->get_kurztext( ).
    <ls_fahrzeug>-ek_anzahl = lv_sum_belegte_sitzplatz."lv_anz_ek.
    <ls_fahrzeug>-ek_img_source = '{ZIA_WDC_2SHIFT_PLANNING}/GREY.png'.
    <ls_fahrzeug>-ek_img_length = lv_sum_ek.
    <ls_fahrzeug>-tooltip = lv_text_tooltip.
    <ls_fahrzeug>-etcs = lo_fahrzeug->get_etcs( ).
    <ls_fahrzeug>-fz_id = lo_fahrzeug->get_id( ).
    <ls_fahrzeug>-sortierung = lo_fahrzeug->get_reihung( ).

    <ls_fahrzeug>-fz_bez = |{ <ls_fahrzeug>-arbstelle }.{ <ls_fahrzeug>-sortierung }|.

    IF <ls_fahrzeug>-sortierung IS INITIAL.
      <ls_fahrzeug>-sortierung = 99.
    ENDIF.

    SHIFT <ls_fahrzeug>-arbstelle LEFT DELETING LEADING '0'.
    SHIFT <ls_fahrzeug>-ek_anzahl LEFT DELETING LEADING '0'.
    SHIFT <ls_fahrzeug>-fz_id LEFT DELETING LEADING '0'.

    ">001< + begin
    <ls_fahrzeug>-drag_tags = VALUE #( lt_dd_tags[ zid_fzg = lv_fzgid ]-drag_tags OPTIONAL ).
    <ls_fahrzeug>-drop_tags = VALUE #( lt_dd_tags[ zid_fzg = lv_fzgid ]-drop_tags OPTIONAL ).
    ">001< + end
    ">002< + begin
    IF lo_schicht->is_entsorgung_schicht( )   OR
       lo_schicht->is_keine_farhrt_schicht( ).
      IF lo_fahrzeug->get_ref_fzg_id( ) IS NOT INITIAL.
        DATA(lo_ref_schicht) = NEW zcl_ia_2workshift( lo_fahrzeug->get_ref_schicht_id( ) ).
        IF lo_ref_schicht IS BOUND.
          DATA(ls_ref_schicht) = lo_ref_schicht->get_data( ).
          DATA(lo_ref_fzg) = lo_ref_schicht->get_fahrzeug_by_id( lo_fahrzeug->get_ref_fzg_id( ) ).
          IF lo_ref_fzg IS BOUND.
            lv_as_ktext = lo_ref_fzg->get_arbeitsstelle( )->get_kurztext( iv_zgart_txt = abap_false ).
            <ls_fahrzeug>-quelle = |{ ls_ref_schicht-start_datum DATE = USER }-{ ls_ref_schicht-start_zeit TIME = ISO } | &
                                   |{ ls_ref_schicht-end_datum   DATE = USER }-{ ls_ref_schicht-end_zeit   TIME = ISO } | &
                                   |{ lv_as_ktext }|.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    <ls_fahrzeug>-referenziert = COND #( WHEN lo_fahrzeug->is_referenced( ) THEN abap_true ELSE abap_false ).
    ">002< + end


  ENDWHILE.

  SORT lt_fahrzeuge BY sortierung.

  node->bind_table( new_items            = lt_fahrzeuge
                    set_initial_elements = abap_true ).

  " !!! Invalidate context of node REIHUNG_FREE *AFTER* context of all nodes FAHRZEUG has been built.
  wd_this->invalidate_reihung_free( ).

ENDMETHOD.

METHOD supply_orientation_dd .

  DATA(ls_fahrzeug)  = VALUE wd_this->element_fahrzeug( ).
  DATA(lt_orient_dd) = VALUE wd_this->elements_orientierung_dd( ( orientierung = '' )
                                                                ( orientierung = 'N' )
                                                                ( orientierung = 'S' )
                                                              ).

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).
  DATA(lv_orient) = ls_fahrzeug-object->get_orientierung( ).

  node->bind_table( new_items            = lt_orient_dd
                    set_initial_elements = abap_true ).

  READ TABLE lt_orient_dd TRANSPORTING NO FIELDS WITH KEY orientierung = lv_orient.
  DATA(lv_index) = sy-tabix.
  IF lv_index > 0.
    node->set_lead_selection_index( index = lv_index ).
  ENDIF.

ENDMETHOD.

METHOD supply_reihung_dd .

  DATA(ls_fahrzeug)   = VALUE wd_this->element_fahrzeug( ).
  DATA(lt_reihung_dd) = VALUE wd_this->elements_reihung_dd( ).

  DATA(lt_reihung_free) = wd_this->get_reihung_free( ).

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).
  DATA(lv_reihung) = ls_fahrzeug-object->get_reihung( ).
  IF lv_reihung IS NOT INITIAL.
    APPEND VALUE #( nummerierung = lv_reihung ) TO lt_reihung_dd.
  ENDIF.
  APPEND VALUE #( nummerierung = '' ) TO lt_reihung_dd.

  APPEND LINES OF lt_reihung_free TO lt_reihung_dd.

  node->bind_table( new_items            = lt_reihung_dd
                    set_initial_elements = abap_true ).
  node->set_lead_selection_index( index = 1 ).

ENDMETHOD.

METHOD toggle_etcs .
  io_fahrzeug->set_etcs( iv_checkbox ).
  io_fahrzeug->save( ).

  wd_this->invalidate_fahrzeug( ).
ENDMETHOD.

METHOD z_add_fahrzeuge .

  LOOP AT it_fztype_count REFERENCE INTO DATA(ld_fztype_count).
    DO ld_fztype_count->fz_count TIMES.
      TRY .
          DATA(lo_fahrzeug) = zcl_ia_2rules=>get_fahrzeug( iv_fztyp         = ld_fztype_count->zid_fztyp
                                                             io_arbeitsstelle = io_arbeitsstelle
                                                             iv_ignore_errors = abap_true ).

          io_arbeitsstelle->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).
          io_arbeitsstelle->save( ).

          lo_fahrzeug->lock( ).

        ##NEEDED       ##NO_HANDLER       CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        ##NEEDED    ##NO_HANDLER       CATCH cx_no_check.
      ##NEEDED     ENDTRY.
    ENDDO.
  ENDLOOP.

  wd_comp_controller->invctx_sitzplatz( ).
  wd_comp_controller->invctx_fahrzeug( ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_add_fahrzeuge_confirmed .
  CHECK iv_popup_id = wd_this->mc_popup_add_fahrzeuge.

  DATA(lt_fztype_count) = VALUE wd_this->elements_fahrzeug_type_count( ).

  DATA(lo_arbeitsstelle) = CAST zcl_ia_2wrkplace( io_parameters->get_object( zif_ia_2_validator=>mc_param_arbeitsstelle ) ).
  io_parameters->get_table( EXPORTING iv_name = zif_ia_2_validator=>mc_param_fahrzeug_type_count
                            IMPORTING et_any  = lt_fztype_count ).

  z_add_fahrzeuge( io_arbeitsstelle = lo_arbeitsstelle
                   it_fztype_count  = lt_fztype_count ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_mat_table_data . "#EC NEEDED
ENDMETHOD.

METHOD supply_mat_table_ui . "#EC NEEDED
ENDMETHOD.

METHOD supply_reihung_free .
  DATA lt_reihung TYPE RANGE OF zia_2_reihung.

  DATA(li_fahrzeug_node) = wd_context->get_child_node( name = wd_this->wdctx_fahrzeug ).
  DATA(lt_fahrzeuge_elem) = li_fahrzeug_node->get_elements( ).

  DATA(lt_reihung_free) = VALUE wd_this->elements_reihung_free( ).

  " 1. build:
  LOOP AT lt_fahrzeuge_elem REFERENCE INTO DATA(ld_fahrzeug_elem).
    " 1a. list of *ALL* Reihungen
    APPEND VALUE #( nummerierung = CONV numc2( sy-tabix ) ) TO lt_reihung_free.
    " 1b. RANGE of used Reihungen
    DATA(ls_fahrzeug) = VALUE wd_this->element_fahrzeug( ).
    ld_fahrzeug_elem->*->get_static_attributes( IMPORTING static_attributes = ls_fahrzeug ).
    APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_fahrzeug-object->get_reihung( ) ) TO lt_reihung.
  ENDLOOP.

  " 2. delete Reihungen currently used by a Fahrzeug
  DELETE lt_reihung_free WHERE nummerierung IN lt_reihung.

  node->bind_table( new_items = lt_reihung_free ).

ENDMETHOD.

endclass.
 