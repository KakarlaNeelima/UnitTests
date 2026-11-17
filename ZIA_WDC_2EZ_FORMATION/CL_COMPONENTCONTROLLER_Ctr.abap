class CL_COMPONENTCONTROLLER_Ctr implementation.
 
*=======================
method 
Constructor. "#EC NEEDED
*=======================
" Do NOT modify the Constructor, any changes will not be saved !
 
  Me->Wd_This =    Wd_This.
  Me->Wd_Context = Wd_Context.
  Me->Wd_Assist =    Wd_Assist.
endmethod.
 
* +-------------------------------------------------------------------+
* |  general methods                                                  |
* +-------------------------------------------------------------------+

method WDDOAPPLICATIONSTATECHANGE . "#EC NEEDED
endmethod.

method WDDOBEFORENAVIGATION . "#EC NEEDED
endmethod.

method WDDOEXIT . "#EC NEEDED
endmethod.

METHOD wddoinit .
  wd_this->go_message_manager = zcl_ia_2message_manager=>get_instance( ).
ENDMETHOD.

method WDDOPOSTPROCESSING . "#EC NEEDED
endmethod.

METHOD add_maintenance_train .
*  CONSTANTS lc_maint_train TYPE string VALUE '34999'.


  DATA(lv_supply_type) = io_schicht->get_parameter( )->get_data( )-supply_type.
  IF lv_supply_type <> zif_ia_2_constant=>mc_supply_type-versorgung AND
     lv_supply_type <> zif_ia_2_constant=>mc_supply_type-entsorgung.
    RETURN.
  ENDIF.

ENDMETHOD.

METHOD after_arbstelle_checkbox .

  DATA(lv_richtung) = VALUE if_componentcontroller=>element_ez_formation-richtung( ).
  ii_parent_element->get_attribute( EXPORTING name  = 'RICHTUNG'
                                    IMPORTING value = lv_richtung ).
  CHECK lv_richtung = zif_ia_2_tracks=>mc_richtung_einfahrt.

  ii_parent_element->set_attribute( name = 'TRENNUNG_VISIBLE' value = iv_trennung_visible ).

ENDMETHOD.

METHOD check_before_save .
  ##NEEDED DATA lv_msg TYPE string.
  ##NEEDED DATA lv_error TYPE abap_bool.  ">004< +
  DATA:
    BEGIN OF ls_richtung_active,
      e TYPE zia_2_ez_aktiv,
      a TYPE zia_2_ez_aktiv,
    END   OF ls_richtung_active.
  FIELD-SYMBOLS <lv_richtung_active> TYPE zia_2_ez_aktiv.

  " wd_this->check_manual_trassen( ). "+>001< >004< (-)

  DATA(lt_check_data) = wd_this->get_check_data( ).

  SORT lt_check_data BY zid_eiz  ASCENDING
                        zarbstl  ASCENDING
                        richtung DESCENDING
                        ez_aktiv DESCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_check_data COMPARING zid_eiz zarbstl richtung.

  LOOP AT lt_check_data ASSIGNING FIELD-SYMBOL(<ls_check_data>).
    AT NEW zarbstl.
      CLEAR ls_richtung_active.
    ENDAT.
    AT NEW richtung.
      UNASSIGN <lv_richtung_active>.
      ASSIGN COMPONENT <ls_check_data>-richtung OF STRUCTURE ls_richtung_active TO <lv_richtung_active>.
    ENDAT.

    IF <lv_richtung_active> IS ASSIGNED.
      <lv_richtung_active> = <ls_check_data>-ez_aktiv.
    ENDIF.

    AT END OF zarbstl.
      IF ls_richtung_active IS NOT INITIAL.
        IF ls_richtung_active-e IS INITIAL.
          IF NOT wd_this->go_schicht->is_entsorgung_schicht( ).
            MESSAGE e168(zia_2_mmt) WITH <ls_check_data>-ktext INTO lv_msg.
            wd_this->report_message( ).
            lv_error = abap_true.
            "wd_this->go_message_manager->add_sys_message( ).
          ENDIF.
        ENDIF.
        IF ls_richtung_active-a IS INITIAL.
          IF NOT wd_this->go_schicht->is_versorgung_schicht( ).
            MESSAGE e367(zia_2_real) WITH <ls_check_data>-ktext INTO lv_msg.
            wd_this->report_message( ).
            lv_error = abap_true.
            "wd_this->go_message_manager->add_sys_message( ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDAT.
  ENDLOOP.

*  IF lv_error = abap_true.
*    RAISE EXCEPTION TYPE zcx_ia_2failure.
*  ENDIF.


ENDMETHOD.

METHOD check_input .

  CASE iv_fldname.
    WHEN 'ZUGNUMMER'.
      wd_this->check_input_zugnummer( io_ctx_el ).
    WHEN 'FAHRZEIT'.
      wd_this->check_input_fahrzeit( io_ctx_el ).
    WHEN OTHERS.
      RETURN.
  ENDCASE.

ENDMETHOD.

METHOD check_input_arbstl .
  DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
  DATA(ls_arbstelle)    = VALUE wd_this->element_arbstellen_schiene( ).
  DATA(lv_one_selected) = VALUE abap_bool( ).


  io_ctx_el->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).
  IF ls_ez_formation-manually_created = abap_true.
    DATA(li_arbst_node) = io_ctx_el->get_child_node( name = wd_this->wdctx_arbstellen_schiene ).
    DATA(lt_arbst_elems) = li_arbst_node->get_elements( ).
    LOOP AT lt_arbst_elems ASSIGNING FIELD-SYMBOL(<li_arbst_elem>).
      <li_arbst_elem>->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).
      CHECK ls_arbstelle-checkbox   = abap_true
         OR ls_arbstelle-is_enabled = abap_false.
      lv_one_selected = abap_true.
      EXIT.
    ENDLOOP.
    IF lv_one_selected = abap_false.
      "If not at least one Arbeitstelle was selected
      ##NEEDED     MESSAGE e047(zia_2_real) INTO DATA(lv_message).
      wd_this->report_message( ).
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD check_input_fahrzeit .
  DATA(ls_data)         = VALUE zia_2_ez_form_wd_s( ).
  DATA(lv_reserve_sec)  = VALUE int4( ).

  io_ctx_el->get_static_attributes( IMPORTING static_attributes = ls_data ).
  ##NEEDED DATA(lt_ctx_els) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_elements( ).
  DATA(ls_schicht) =  wd_this->go_schicht->get_data( ).

  "Check if fahrzeit is provided
  IF ls_data-manually_created = abap_true.
    IF ls_data-fahrtzeit IS INITIAL.
      ##NEEDED     MESSAGE e078(zia_2_real) INTO DATA(lv_message).
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

  "Check Fahrzeit format
  IF ls_data-manually_created = abap_true.
    CALL FUNCTION 'TIME_CHECK_PLAUSIBILITY'
      EXPORTING
        time                      = ls_data-fahrtzeit
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.
    IF sy-subrc <> 0.
      MESSAGE e079(zia_2_real) INTO lv_message.
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

  "Check reserve time
  IF ls_data-manually_created = abap_true.
    DATA(lv_time_reserve) = wd_this->go_schicht->get_parameter( )->get_data( )-time_reserve.
    IF lv_time_reserve IS NOT INITIAL.
      lv_reserve_sec = lv_time_reserve * 60.
      CONVERT DATE ls_schicht-start_datum TIME ls_schicht-start_zeit INTO TIME STAMP DATA(lv_tstmp_sch) TIME ZONE sy-zonlo.
      CONVERT DATE ls_schicht-start_datum TIME ls_data-fahrtzeit     INTO TIME STAMP DATA(lv_tstmp_ez)  TIME ZONE sy-zonlo.
      IF ls_data-richtung = zif_ia_2_constant=>mc_richtung-einfahrt.
        IF ls_data-zeit_am_start_tag = abap_true.
          TRY.
              DATA(lv_tstmp_rsv) = cl_abap_tstmp=>subtractsecs( tstmp = lv_tstmp_sch secs = lv_reserve_sec ).
              IF cl_abap_tstmp=>compare( tstmp1 = lv_tstmp_ez tstmp2 = lv_tstmp_rsv ) < 0.
                MESSAGE e080(zia_2_real) INTO lv_message.
                RAISE EXCEPTION TYPE zcx_ia_2failure.
              ENDIF.
            CATCH cx_parameter_invalid_range
                  cx_parameter_invalid_type.
              RETURN.
          ENDTRY.
        ENDIF.
      ENDIF.
      IF ls_data-richtung = zif_ia_2_constant=>mc_richtung-ausfahrt.
        TRY.
            lv_tstmp_rsv = cl_abap_tstmp=>add( tstmp = lv_tstmp_sch secs = lv_reserve_sec ).
            DATA(lv_diff_result) = cl_abap_tstmp=>compare( tstmp1 = lv_tstmp_ez tstmp2 = lv_tstmp_rsv ).
            IF ls_data-zeit_am_start_tag = abap_false AND
               lv_diff_result > 0.
              MESSAGE e080(zia_2_real) INTO lv_message.
              RAISE EXCEPTION TYPE zcx_ia_2failure.
            ENDIF.
          CATCH cx_parameter_invalid_range
                cx_parameter_invalid_type.
            RETURN.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD check_input_zugnummer .
  DATA(lv_zugnummer_min) = VALUE i( ).               ">001< +
  DATA(lv_zugnummer_max) = VALUE i( ).               ">001< +


  DATA(ls_data)      = VALUE zia_2_ez_form_wd_s( ).
  ##NEEDED DATA(ls_data_tmp)  = VALUE zia_2_ez_form_wd_s( ).
  DATA(lv_zugnummer) = VALUE string( ).

  DATA(lo_2param) = NEW zcl_se_2parameters( ).      ">001< +
  io_ctx_el->get_static_attributes( IMPORTING static_attributes = ls_data ).
  ##NEEDED DATA(lt_ctx_els) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_elements( ).

  lv_zugnummer = ls_data-zugnummer.
  CONDENSE lv_zugnummer NO-GAPS.

  "Check if zugnummer is provided
  IF ls_data-manually_created = abap_true.
    IF lv_zugnummer IS INITIAL.
      ##NEEDED     MESSAGE e077(zia_2_real) INTO DATA(lv_message). ##NEEDED
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

  "Check if Zugnummer value is a numeric value
  IF ls_data-zugnummer IS NOT INITIAL.
*    IF NOT lv_zugnummer CO '0123456789'.
    IF lv_zugnummer CN '0123456789'.
      MESSAGE e074(zia_2_real) WITH ls_data-zugnummer INTO lv_message.
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

  ">001< (-) begin
  "Check if zugnummer is unique
*  LOOP AT lt_ctx_els ASSIGNING FIELD-SYMBOL(<lo_ctx_el>).
*    CHECK io_ctx_el <> <lo_ctx_el>.
*    CHECK ls_data-zugnummer IS NOT INITIAL.
*    <lo_ctx_el>->get_static_attributes( IMPORTING static_attributes = ls_data_tmp ).
*    CHECK ls_data-zugnummer = ls_data_tmp-zugnummer.
*    CHECK ls_data-richtung  = ls_data_tmp-richtung.
*    MESSAGE e075(zio_5_real) WITH ls_data-zugnummer INTO lv_message.
*    RAISE EXCEPTION TYPE zcx_io_5_fehler.
*  ENDLOOP.
  ">001< (-) end

  "Check the zugnummer range
  lv_zugnummer_min = lo_2param->read( EXPORTING iv_application = 'ZIA_2_REAL' iv_name = 'TRASSE_ZUGNRVON' ).    ">001< +
  lv_zugnummer_max = lo_2param->read( EXPORTING iv_application = 'ZIA_2_REAL' iv_name = 'TRASSE_ZUGNRBIS' ).    ">001< +
  IF ls_data-manually_created = abap_true.
    IF ls_data-zugnummer < lv_zugnummer_min OR     ">001< mod
       ls_data-zugnummer > lv_zugnummer_max.       ">001< mod
      MESSAGE e076(zia_2_real) WITH ls_data-zugnummer lv_zugnummer_min lv_zugnummer_max INTO lv_message.
      RAISE EXCEPTION TYPE zcx_ia_2failure.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD check_manual_trassen .

  DATA: lv_one_selected TYPE boolean.

  DATA(lt_ezform_elems) = wd_context->get_child_node( name = if_componentcontroller=>wdctx_ez_formation )->get_elements( ).

  DATA(lv_valid_char) = |{ sy-abcde }0123456789|.
  LOOP AT lt_ezform_elems ASSIGNING FIELD-SYMBOL(<li_ezform_elem>).

    DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
    <li_ezform_elem>->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

    CHECK ls_ez_formation-manually_created EQ abap_true. "Manually created

    IF ls_ez_formation-zugnummer CO lv_valid_char AND
       ls_ez_formation-zugnummer IS NOT INITIAL.
      DATA(lv_valid_zug) = abap_true.
    ELSE.
      lv_valid_zug = abap_false.
    ENDIF.

    IF lv_valid_zug EQ abap_false. "Contains special characters or is blank
      "If not numeric, trigger error message
      wd_this->go_message_manager->add_bapiret( VALUE bapiret2( id     = zcl_ia_2message_manager=>mv_msgid_zia_2_real
                                                                number = 46
                                                                type   = if_xo_const_message=>error )     ).

    ENDIF.

    DATA(li_arbst_node) = <li_ezform_elem>->get_child_node( name = if_componentcontroller=>wdctx_arbstellen_schiene ).
    DATA(lt_arbst_elems) = li_arbst_node->get_elements( ).

    CHECK: lines( lt_arbst_elems ) NE 0.

    lv_one_selected = abap_false. "Default

    LOOP AT lt_arbst_elems ASSIGNING FIELD-SYMBOL(<li_arbst_elem>). "#EC CI_NESTED

      DATA(ls_arbstelle) = VALUE if_componentcontroller=>element_arbstellen_schiene( ).
      <li_arbst_elem>->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).

      IF ls_arbstelle-checkbox EQ abap_true OR
        ls_arbstelle-is_enabled EQ abap_false. "Checkbox disabled
        "At least one selected
        lv_one_selected = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_one_selected = abap_false.
      "If not at least one Arbeitstelle was selected
      wd_this->go_message_manager->add_bapiret( VALUE bapiret2( id     = zcl_ia_2message_manager=>mv_msgid_zia_2_real
                                                                number = 47
                                                                type   = if_xo_const_message=>error )     ).
    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD check_on_save .
  DATA(lt_ctx_els) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_elements( ).

  IF wd_this->go_msg_wd_manager IS BOUND.
    wd_this->go_msg_wd_manager->clear_messages( ).
  ENDIF.

  LOOP AT lt_ctx_els ASSIGNING FIELD-SYMBOL(<li_ctx_el>).
    TRY.
        "Check Fahrzeit
        wd_this->check_input( io_ctx_el = <li_ctx_el> iv_fldname = 'ZUGNUMMER' ).
      CATCH zcx_ia_2failure.
        wd_this->report_message( io_ctx_el = <li_ctx_el> iv_attr_name = 'ZUGNUMMER' ).
        RAISE EXCEPTION TYPE zcx_ia_2failure." EXPORTING go_ctx_el = <li_ctx_el>.
    ENDTRY.

    TRY.
        "Check Fahrzeit
        wd_this->check_input( io_ctx_el = <li_ctx_el> iv_fldname = 'FAHRZEIT' ).
      CATCH zcx_ia_2failure.
        wd_this->report_message( io_ctx_el = <li_ctx_el> iv_attr_name = 'FAHRZEIT' ).
        RAISE EXCEPTION TYPE zcx_ia_2failure." EXPORTING go_ctx_el = <li_ctx_el>.
    ENDTRY.
  ENDLOOP.

ENDMETHOD.

METHOD cleanup_manual_trassen .
  DATA(lt_ez_form) = VALUE wd_this->elements_ez_formation( ).

  "Delete removed manual trassen
  DATA(li_node_form) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation ).
  li_node_form->get_static_attributes_table( IMPORTING table = lt_ez_form ).

  wd_this->go_schicht->reload( ).
  DATA(ls_schicht) =  wd_this->go_schicht->get_data( ).
  DATA(lt_trassen_db) = wd_this->go_schicht->get_trassen( ).
  DELETE lt_trassen_db WHERE data_origin NE zif_ia_2_constant=>mc_data_origin-manual.

  LOOP AT lt_trassen_db INTO DATA(ls_trassen_db).

    IF NOT line_exists( lt_ez_form[ richtung  = ls_trassen_db-richtung
                                    zugnummer = ls_trassen_db-zugnummer ] ).

      DATA(lv_success) = wd_assist->delete_tracks( iv_peri = ls_schicht-zzperi
                                                   iv_end_datum = ls_schicht-end_datum
                                                   iv_start_datum = ls_schicht-start_datum
                                                   iv_zugnummer = ls_trassen_db-zugnummer
                                                   iv_richtung = ls_trassen_db-richtung ).
      IF lv_success = abap_true.
        IF iv_commit = abap_true.
          wd_assist->run_commmit( ).
        ENDIF.
      ELSE.
        wd_assist->rollbackwork( ).
      ENDIF.

*      DELETE FROM zia_2sf_ez_form                   "#EC CI_IMUD_NESTED
*        WHERE zschicht    = @ls_schicht-zschicht
*          AND zugnummer   = @ls_trassen_db-zugnummer
*          AND richtung    = @ls_trassen_db-richtung
*          AND data_origin = @zif_ia_2_constant=>mc_data_origin-manual.
      DATA(lv_result) = wd_assist->delete_train_maintdata( iv_shift     = ls_schicht-zschicht
                                                           iv_zugnummer = ls_trassen_db-zugnummer
                                                           iv_richtung  = ls_trassen_db-richtung ).

      IF lv_result IS NOT INITIAL.
        IF iv_commit = abap_true.
*          COMMIT WORK AND WAIT.
          wd_assist->run_commmit( ).
        ENDIF.
      ELSE.
*        ROLLBACK WORK.
        wd_assist->rollbackwork( ).
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMETHOD.

METHOD close .
  wd_this->close_window( ).
ENDMETHOD.

METHOD close_window .
  wd_this->gi_window->close( ).

  wd_this->fire_closed_evt( ).
ENDMETHOD.

METHOD create_and_open_window .
  DATA(li_window_manager) = wd_this->wd_get_api( )->get_window_manager( ).

  DATA(lv_window_name) = wd_this->get_window_name( ).
  DATA(lv_button_kind) = wd_this->get_window_button_kind( ).

  wd_this->gi_window = li_window_manager->create_window( window_name       = lv_window_name
                                                         title             = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/ZUGFORMATION` )
                                                         close_button      = abap_false
                                                         button_kind       = lv_button_kind
                                                         close_in_any_case = abap_false ).
*                                                         is_resizable      = abap_true ).

  wd_this->gi_window->open( ).

ENDMETHOD.

METHOD delete_ez_form .

  wd_this->go_schicht->delete_ez_form( ).
ENDMETHOD.

METHOD filter_ez_formation .
  IF wd_this->go_schicht->is_versorgung_schicht( ).
    DELETE ct_data WHERE richtung = zif_ia_2_constant=>mc_richtung-ausfahrt.
  ENDIF.

  "Delete Richtung = Einfhart for Entsorgung Schicht
  IF wd_this->go_schicht->is_entsorgung_schicht( ).
    DELETE ct_data WHERE richtung = zif_ia_2_constant=>mc_richtung-einfahrt.
  ENDIF.

ENDMETHOD.

METHOD get_arbeitsstellen_for_switch .
  DATA(lt_ezform_elems) = wd_context->get_child_node( name = if_componentcontroller=>wdctx_ez_formation )->get_elements( ).

  LOOP AT lt_ezform_elems ASSIGNING FIELD-SYMBOL(<li_ezform_elem>).

    DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
    <li_ezform_elem>->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

    DATA(li_arbst_node) = <li_ezform_elem>->get_child_node( name = if_componentcontroller=>wdctx_arbstellen_schiene ).
    DATA(lt_arbst_elems) = li_arbst_node->get_elements( ).

    LOOP AT lt_arbst_elems ASSIGNING FIELD-SYMBOL(<li_arbst_elem>). "#EC CI_NESTED

      DATA(ls_arbstelle) = VALUE if_componentcontroller=>element_arbstellen_schiene( ).
      <li_arbst_elem>->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).
      CHECK ls_arbstelle-is_visible = abap_true.

      APPEND VALUE #( zugnummer          = ls_ez_formation-zugnummer
                      zarbstl            = ls_arbstelle-zarbstl
                      elem_arbeitsstelle = <li_arbst_elem>
                      elem_ez_form       = <li_ezform_elem>
                    ) TO rt_arbeitsstellen.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.

METHOD get_check_data .
  DATA(lt_ezform_elems) = wd_context->get_child_node( name = if_componentcontroller=>wdctx_ez_formation )->get_elements( ).

  LOOP AT lt_ezform_elems ASSIGNING FIELD-SYMBOL(<li_ezform_elem>).

    DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
    <li_ezform_elem>->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

    DATA(li_arbst_node) = <li_ezform_elem>->get_child_node( name = if_componentcontroller=>wdctx_arbstellen_schiene ).
    DATA(lt_arbst_elems) = li_arbst_node->get_elements( ).

    LOOP AT lt_arbst_elems ASSIGNING FIELD-SYMBOL(<li_arbst_elem>). "#EC CI_NESTED

      DATA(ls_arbstelle) = VALUE if_componentcontroller=>element_arbstellen_schiene( ).
      <li_arbst_elem>->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).

      APPEND INITIAL LINE TO rt_check_data ASSIGNING FIELD-SYMBOL(<ls_check_data>).
      <ls_check_data>-zid_eiz  = ls_ez_formation-zid_eiz.
      <ls_check_data>-zarbstl  = ls_arbstelle-zarbstl.
      <ls_check_data>-richtung = ls_ez_formation-richtung.
      <ls_check_data>-ez_aktiv = ls_arbstelle-checkbox.
      <ls_check_data>-ktext    = ls_arbstelle-ktext.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.

METHOD get_comp_popup_trennung .
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_trennung( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  ri_component = wd_this->wd_cpifc_popup_trennung( ).

ENDMETHOD.

METHOD get_data_for_save .
  DATA(li_node_form) = wd_context->get_child_node( name = wd_this->wdctx_ez_formation ).
  DATA(lt_elems_form) = li_node_form->get_elements( ).

  LOOP AT lt_elems_form ASSIGNING FIELD-SYMBOL(<li_elem_form>).
    DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
    <li_elem_form>->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

    DATA(li_node_arbst) = <li_elem_form>->get_child_node( name = wd_this->wdctx_arbstellen_schiene ).
    DATA(lt_arbst) = VALUE wd_this->elements_arbstellen_schiene( ).
    li_node_arbst->get_static_attributes_table( IMPORTING table = lt_arbst ).

    LOOP AT lt_arbst ASSIGNING FIELD-SYMBOL(<ls_arbst>) WHERE is_visible = abap_true. "#EC CI_NESTED

      APPEND VALUE #( zschicht    = ls_ez_formation-zschicht
                      zugnummer   = ls_ez_formation-zugnummer
                      zarbstl     = <ls_arbst>-zarbstl
                      zid_eiz     = ls_ez_formation-zid_eiz
                      richtung    = ls_ez_formation-richtung
                      data_origin = <ls_arbst>-data_origin
                      ez_aktiv    = <ls_arbst>-checkbox
                      has_changed = boolc(  <ls_arbst>-has_changed = abap_true AND <ls_arbst>-checkbox <> <ls_arbst>-checkbox_orig )
                     " has_changed = boolc( ls_ez_formation-has_changed = abap_true AND <ls_arbst>-checkbox = abap_true ) "<--- SAPCBT-914 (-)
                    ) TO rt_ez_form.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD get_edit_mode .
  rv_data = wd_this->gv_edit_mode.
ENDMETHOD.

METHOD get_ez_form_key_from_elem .
  DATA(ls_arbstelle) = VALUE wd_this->element_arbstellen_schiene( ).
  ii_element->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).

  DATA(ls_ez_form) = VALUE wd_this->element_ez_formation( ).
  DATA(li_parent_elem) = ii_element->get_node( )->get_parent_element( ).
  li_parent_elem->get_static_attributes( IMPORTING static_attributes = ls_ez_form ).

  rs_key = VALUE #( zschicht  = ls_ez_form-zschicht
                    zugnummer = ls_ez_form-zugnummer
                    zarbstl   = ls_arbstelle-zarbstl
                    zid_eiz   = ls_ez_form-zid_eiz
                    richtung  = ls_ez_form-richtung
                  ).

ENDMETHOD.

METHOD get_man_trassen_for_save_aus .
  DATA(lt_ez_form)     = VALUE wd_this->elements_ez_formation( ).
  DATA(lv_zug_counter) = VALUE i( ).
  DATA(lv_time_in_sec) = VALUE i( ).
  DATA(lv_tstmp_new)   = VALUE timestamp( ).

  wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_static_attributes_table( IMPORTING table = lt_ez_form ).
  DATA(ls_schicht) = wd_this->go_schicht->get_data( ).

  LOOP AT lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form>) WHERE manually_created = abap_true.
    CHECK <ls_ez_form>-richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt.
    "We only process those that do not yet exist in the database
    CHECK <ls_ez_form>-existing_in_db = abap_false.
    "Get reference trassen
    DATA(lt_trassen_ref) = get_man_trassen_reference(
      iv_date     = ls_schicht-start_datum
      iv_sp       = wd_this->go_schicht->get_rj_est( )
      iv_eiz      = <ls_ez_form>-zid_eiz
      iv_richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt ).

    SORT lt_trassen_ref BY reihenfolge.                "#EC CI_SORTLOOP
    LOOP AT lt_trassen_ref ASSIGNING FIELD-SYMBOL(<ls_trassen_ref>). "#EC CI_NESTED
      DATA(lv_tabix) = sy-tabix.
      DATA(ls_data) =  VALUE zia_2_tracks_db_s( ).
      ls_data                   = CORRESPONDING #( <ls_trassen_ref> ).
      ls_data-gueltig_von       = ls_schicht-start_datum.
      ls_data-gueltig_bis       = ls_schicht-end_datum.
      ls_data-zugnummer         = <ls_ez_form>-zugnummer.
      ls_data-sperrabschnitt    = <ls_trassen_ref>-sperrabschnitt.
      ls_data-data_origin       = zif_ia_2_constant=>mc_data_origin-manual.
      ls_data-zeit_am_start_tag = <ls_ez_form>-zeit_am_start_tag.

      CLEAR: ls_data-zab, ls_data-zan.

      "Set Zug letter
      DATA(lv_zug) = VALUE #( rt_data[ zugnummer = <ls_ez_form>-zugnummer richtung = ls_data-richtung ]-zug OPTIONAL ).
      IF lv_zug IS INITIAL.
        ls_data-zug    = sy-abcde+lv_zug_counter(1).
        lv_zug_counter = lv_zug_counter + 1.
      ELSE.
        ls_data-zug = lv_zug.
      ENDIF.

      DATA(lv_mod_eiz) = COND #( WHEN <ls_ez_form>-zid_eiz = 10 THEN 2 ELSE 1 ).
      DATA(lv_time_in_sec_total) = VALUE i( ).
      LOOP AT lt_trassen_ref ASSIGNING FIELD-SYMBOL(<ls_trassen_ref_sec>). "#EC CI_NESTED
        CHECK sy-tabix  >= lv_tabix.
        "Set Abfahrt/Ankunft Zeit (Richtung = E)  (MOD - 1 = Ankunft; MOD - 0 = Abfahrt )
        DATA(lv_mod) = sy-tabix MOD lv_mod_eiz.
        lv_time_in_sec = COND #( WHEN lv_mod = 1 THEN <ls_trassen_ref_sec>-zan ELSE <ls_trassen_ref_sec>-zab ).
        lv_time_in_sec_total = lv_time_in_sec_total + lv_time_in_sec.
      ENDLOOP.

      "We are not interested in the date but in the time, hence the sy-datum (dummy value just to get timestamp)
      CONVERT DATE sy-datum TIME <ls_ez_form>-fahrtzeit INTO TIME STAMP DATA(lv_tstmp) TIME ZONE sy-zonlo.

      TRY.
          "Substract eference trassen time from the ez form time
          lv_tstmp_new = cl_abap_tstmp=>subtractsecs( tstmp = lv_tstmp secs = lv_time_in_sec_total  ).
          "Extract time from the new timestamp
          cl_abap_tstmp=>systemtstmp_utc2syst( EXPORTING utc_tstmp = lv_tstmp_new IMPORTING syst_time = DATA(lv_time_new) ).
        CATCH cx_parameter_invalid_range
              cx_parameter_invalid_type.
          ASSERT 1 = 1.
      ENDTRY.

      lv_mod = lv_tabix MOD 2.
      IF <ls_ez_form>-zid_eiz = 10.
        ls_data-zan = COND #( WHEN lv_mod =  1 THEN lv_time_new ELSE ls_data-zan ).
        ls_data-zab = COND #( WHEN lv_mod <> 1 THEN lv_time_new ELSE ls_data-zab ).
      ELSE.
        ls_data-zan = COND #( WHEN lv_mod <> 1 THEN lv_time_new ELSE ls_data-zan ).
        ls_data-zab = COND #( WHEN lv_mod =  1 THEN lv_time_new ELSE ls_data-zab ).
      ENDIF.
      APPEND ls_data TO rt_data.
    ENDLOOP.
  ENDLOOP.

  SORT rt_data BY zugnummer reihenfolge.

ENDMETHOD.

METHOD get_man_trassen_for_save_ein .
  DATA(lt_ez_form)     = VALUE wd_this->elements_ez_formation( ).
  DATA(lv_zug_counter) = VALUE i( ).
  DATA(lv_time_in_sec) = VALUE i( ).
  DATA(lv_tstmp_new)   = VALUE timestamp( ).

  wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->get_static_attributes_table( IMPORTING table = lt_ez_form ).
  DATA(ls_schicht) = wd_this->go_schicht->get_data( ).

  LOOP AT lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form>) WHERE manually_created = abap_true.
    CHECK <ls_ez_form>-richtung = zif_ia_2_tracks=>mc_richtung_einfahrt.
    "We only process those that do not yet exist in the database
    CHECK <ls_ez_form>-existing_in_db = abap_false.
    "Get reference trassen
    DATA(lt_trassen_ref) = get_man_trassen_reference(
      iv_date     = ls_schicht-start_datum
      iv_sp       = wd_this->go_schicht->get_rj_est( )
      iv_eiz      = <ls_ez_form>-zid_eiz
      iv_richtung = zif_ia_2_tracks=>mc_richtung_einfahrt ).

    DATA(lv_time_in_sec_total) = VALUE i( ).
    LOOP AT lt_trassen_ref ASSIGNING FIELD-SYMBOL(<ls_trassen_ref>). "#EC CI_NESTED
      DATA(lv_tabix) = sy-tabix.
      DATA(ls_data) = VALUE zia_2_tracks_db_s( ).
      ls_data                   = CORRESPONDING #( <ls_trassen_ref> ).
      ls_data-gueltig_von       = ls_schicht-start_datum.
      ls_data-gueltig_bis       = ls_schicht-end_datum.
      ls_data-zugnummer         = <ls_ez_form>-zugnummer.
      ls_data-sperrabschnitt    = <ls_trassen_ref>-sperrabschnitt.
      ls_data-data_origin       = zif_ia_2_constant=>mc_data_origin-manual.
      ls_data-zeit_am_start_tag = <ls_ez_form>-zeit_am_start_tag.
      CLEAR: ls_data-zug.

      "Set Zug letter
      DATA(lv_zug) = VALUE #( rt_data[ zugnummer = <ls_ez_form>-zugnummer richtung = ls_data-richtung ]-zug OPTIONAL ).
      IF lv_zug IS INITIAL.
        ls_data-zug    = sy-abcde+lv_zug_counter(1).
        lv_zug_counter = lv_zug_counter + 1.
      ELSE.
        ls_data-zug = lv_zug.
      ENDIF.

      "Set Abfahrt/Ankunft Zeit (Richtung = E)  (MOD - 1 = Abfahrt; MOD - 0 = Ankunft)
      DATA(lv_mod) = lv_tabix MOD 2.
      "Convert time to seconds
      lv_time_in_sec = COND #( WHEN lv_mod = 1 THEN <ls_trassen_ref>-zab ELSE <ls_trassen_ref>-zan ).
      lv_time_in_sec_total = lv_time_in_sec_total + lv_time_in_sec.
      "We are not interested in the date but in the time, hence the sy-datum (dummy value just to get timestamp)
      CONVERT DATE sy-datum TIME <ls_ez_form>-fahrtzeit INTO TIME STAMP DATA(lv_tstmp) TIME ZONE sy-zonlo.

      TRY.
          "Add time from the reference trassen
          lv_tstmp_new = cl_abap_tstmp=>add( EXPORTING tstmp = lv_tstmp secs = lv_time_in_sec_total ).
          "Extract time from the new timestamp
          cl_abap_tstmp=>systemtstmp_utc2syst( EXPORTING utc_tstmp = lv_tstmp_new IMPORTING syst_time = DATA(lv_time_new) ).
        CATCH cx_parameter_invalid_range
              cx_parameter_invalid_type.
          ASSERT 1 = 1.
      ENDTRY.

      IF lv_mod =  1.
        ls_data-zab = lv_time_new.
      ELSE.
        ls_data-zan = lv_time_new.
        IF ls_schicht-zzperi EQ 'CBT'.
          cl_abap_tstmp=>systemtstmp_utc2syst( EXPORTING utc_tstmp = lv_tstmp_new IMPORTING syst_date = DATA(lv_date_new) ).
          IF ls_schicht-start_datum <> lv_date_new.
            CLEAR ls_data-zeit_am_start_tag.
          ENDIF.
        ENDIF.
      ENDIF.

      APPEND ls_data TO rt_data.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD get_man_trassen_reference .
  DATA lt_zugnummer_rng TYPE RANGE OF zia_2_zugnummer.
  DATA(lv_eiz_sign)  = VALUE char1( ).
  DATA(lv_perim)     = VALUE char3( ).

  "Build "Vorlage" Zug pattern
  lv_eiz_sign  = COND #( WHEN iv_eiz = zif_ia_2_constant=>mc_eizid_gbtn THEN 'N'
                        WHEN iv_eiz = zif_ia_2_constant=>mc_eizid_gbts THEN 'S' ).
  lv_perim = wd_this->go_schicht->get_data( )-zzperi.
  APPEND VALUE #( sign   = 'I'
                  option = 'CP'
                  low    = |{ lv_perim }{ lv_eiz_sign }*| ) TO lt_zugnummer_rng.

*  SELECT *
*    FROM zia_2tracks
*    INTO CORRESPONDING FIELDS OF TABLE @rt_data
*    WHERE gueltig_von    <= @iv_date
*      AND gueltig_bis    >= @iv_date
*      AND sperrabschnitt  = @iv_sp
*      AND richtung        = @iv_richtung
*      AND data_origin     = @iv_data_origin
*      AND trasse_aktiv    = @abap_true
*      AND zugnummer      IN @lt_zugnummer_rng.
  rt_Data = wd_assist->get_tracks( iv_date          = iv_date
                        iv_sp            = iv_sp
                        iv_richtung      = iv_richtung
                        iv_data_origin   = iv_data_origin
                        it_zugnummer_rng = lt_zugnummer_rng ).

  IF rt_data IS INITIAL.
    ##NEEDED   MESSAGE e081(zia_2_real) INTO DATA(lv_message).
    wd_this->report_message( ).
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.

ENDMETHOD.

METHOD get_schicht .
  ro_instance = wd_this->go_schicht.
ENDMETHOD.

METHOD get_validity_dates .

  DATA(ls_schicht) = wd_this->go_schicht->get_data( ).

  ev_valid_from = ls_schicht-start_datum.
  ev_valid_to   = ls_schicht-end_datum.
ENDMETHOD.

METHOD get_window_button_kind .
  rv_value = SWITCH #( wd_this->gv_perimeter
                     WHEN 'CBT' THEN if_wd_window=>co_buttons_okcancel
                     WHEN 'GBT' THEN if_wd_window=>co_buttons_yesnocancel
                   ).
ENDMETHOD.

METHOD get_window_name .
  rv_value = |W_{ wd_this->gv_perimeter }|.
ENDMETHOD.

METHOD invalidate_context .
  wd_context->get_child_node( name = wd_this->wdctx_ez_formation )->invalidate( ).
ENDMETHOD.

METHOD is_tremola_active .

  TRY .
      rv_value = wd_this->go_schicht->is_tremola_active( ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD open .
  wd_this->set_test_mode( ).

  wd_this->reset_schicht( io_schicht ).
  IF wd_this->get_edit_mode( ) IS NOT INITIAL.      ">001< +
    wd_this->tremola_calc_and_save( ).
    wd_this->save_tremola_ez_form( iv_called_from = 'POPUP_INIT' ).  " (+) 914
  ENDIF.                                   ">001< +

  wd_this->create_and_open_window( ).
ENDMETHOD.

METHOD open_popup_message_with_params.
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_to_confirm( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  DATA(li_popup_to_confirm) = wd_this->wd_cpifc_popup_to_confirm( ).

  li_popup_to_confirm->open( io_parameters   = io_parameters
                           iv_popup_id     = iv_popup_id
                           iv_window_title = iv_window_title
                           it_text         = it_text
                           iv_button_kind  = iv_button_kind
                           iv_btn1_text    = iv_btn1_text
                           iv_btn2_text    = iv_btn2_text
                           iv_btn3_text    = iv_btn3_text
                           iv_close_button = iv_close_button
                           iv_message_type = iv_message_type ).

ENDMETHOD.

METHOD open_popup_trennung .

  wd_this->save_data( ).
  CHECK NOT wd_this->go_message_manager->has_errors( ).

  DATA(li_popup_trennung) = wd_this->get_comp_popup_trennung( ).
  li_popup_trennung->open( io_schicht          = wd_this->go_schicht
                           is_ez_form_trennung = is_ez_form_trennung ).

ENDMETHOD.

METHOD report_message .
  DATA li_api_controller  TYPE REF TO if_wd_controller.

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

  li_api_controller          ?= wd_this->wd_get_api( ).
  IF wd_this->go_msg_wd_manager IS NOT BOUND.
    wd_this->go_msg_wd_manager = li_api_controller->get_message_manager( ).
  ENDIF.
  wd_this->go_msg_wd_manager->clear_messages( ).

  MESSAGE ID lv_msgid TYPE lv_msgty NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO DATA(lv_message).

  DATA(lv_msg_type) = COND #( WHEN lv_msgty = 'S' THEN if_wd_message_manager=>co_type_standard
                              WHEN lv_msgty = 'I' THEN if_wd_message_manager=>co_type_info
                              WHEN lv_msgty = 'W' THEN if_wd_message_manager=>co_type_warning
                              WHEN lv_msgty = 'E' THEN if_wd_message_manager=>co_type_error ).

  IF iv_attr_name IS NOT INITIAL AND
     io_ctx_el    IS BOUND.
    wd_this->go_msg_wd_manager->report_attribute_message(
      attribute_name = iv_attr_name
      message_type   = lv_msg_type
      message_text   = lv_message
      element        = io_ctx_el ).
  ELSE.
    wd_this->go_msg_wd_manager->report_message(
      message_text = lv_message
      message_type = lv_msg_type ).
  ENDIF.

ENDMETHOD.

METHOD reset_schicht .

  DATA(lv_reset) = CONV wdy_boolean( boolc( io_schicht IS NOT BOUND ) ).

  DATA(lo_schicht) = COND #( WHEN io_schicht IS BOUND THEN io_schicht ELSE wd_this->go_schicht ).
  ASSERT FIELDS wd_this->gv_perimeter CONDITION lo_schicht IS BOUND.

  wd_this->set_schicht( io_schicht = lo_schicht
                        iv_reset   = lv_reset ).

  wd_this->invalidate_context( ).

ENDMETHOD.

METHOD save .
  TRY.
      wd_this->save_data( ).
      wd_this->close_window( ).
    ##NO_HANDLER   CATCH zcx_ia_2failure.
  ENDTRY.

ENDMETHOD.

METHOD save_data .
  wd_this->go_message_manager->reset( ).

  wd_this->check_before_save( ).
  IF wd_this->go_message_manager->has_errors( ).
    "wd_this->go_message_manager->display_messages( ).   ">001< (-)
    "RETURN.                                             ">001< (-)
    RAISE EXCEPTION TYPE zcx_ia_2failure.
  ENDIF.

  CASE wd_this->gv_perimeter.
    WHEN 'CBT'.
      wd_this->z_save_cbt( ).
    WHEN 'GBT'.
      wd_this->z_save_gbt( ).
  ENDCASE.

  wd_this->go_schicht->reload( ).

ENDMETHOD.

METHOD save_ez_form .

  DATA(lt_ez_form) = wd_this->get_data_for_save( ).
  wd_this->go_schicht->save_ez_form( EXPORTING it_ez_form = lt_ez_form ).

ENDMETHOD.

METHOD save_manual_trassen.
  DATA(lt_trassen) = VALUE zia_2tracks_db_t( ).

  "Get manual trassen for save - Einfahrt
  DATA(lt_trassen_ein) = wd_this->get_man_trassen_for_save_ein( ).
  "Get manual trassen for save - Einfahrt
  DATA(lt_trassen_aus) = wd_this->get_man_trassen_for_save_aus( ).
  DATA lo_assist TYPE REF TO zcl_ia_2lofpm_clh_wd_assist.
  lo_assist = NEW #( ).

  APPEND LINES OF lt_trassen_ein TO lt_trassen.
  APPEND LINES OF lt_trassen_aus TO lt_trassen.
  SORT lt_trassen.
  DELETE ADJACENT DUPLICATES FROM lt_trassen COMPARING ALL FIELDS.

  IF lt_trassen IS NOT INITIAL.
*    INSERT zia_2tracks FROM TABLE lt_trassen.
    DATA(lv_success) = wd_assist->insert_tracks( it_tracks = lt_trassen ).
    IF lv_success = abap_true.
      IF iv_commit = abap_true.
*        COMMIT WORK AND WAIT.
        lo_assist->run_commit( ).
      ENDIF.
    ENDIF.
  ENDIF.

  "Cleanup manual trassen
  wd_this->cleanup_manual_trassen( iv_commit ).

ENDMETHOD.

METHOD save_tremola_ez_form.
  DATA(lt_ez_form_db) = VALUE zia_2_ez_frm_t( ).


  wd_this->invalidate_context( ).

  DATA(lt_ezform_elems) = wd_context->get_child_node( name = if_componentcontroller=>wdctx_ez_formation )->get_elements( ).
  LOOP AT lt_ezform_elems ASSIGNING FIELD-SYMBOL(<li_ezform_elem>).

    DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
    <li_ezform_elem>->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).
    DATA(li_arbst_node) = <li_ezform_elem>->get_child_node( name = if_componentcontroller=>wdctx_arbstellen_schiene ).

    DATA(lt_arbst_elems) = li_arbst_node->get_elements( ).
    DATA(ls_arbstelle) = VALUE if_componentcontroller=>element_arbstellen_schiene( ).

    LOOP AT lt_arbst_elems ASSIGNING FIELD-SYMBOL(<li_arbst_elem>). "#EC CI_NESTED
      <li_arbst_elem>->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).
      IF ls_arbstelle-data_origin EQ zif_ia_2_constant=>mc_data_origin-tremola "Change >001<
          AND ls_arbstelle-checkbox = abap_true.
        APPEND INITIAL LINE TO lt_ez_form_db ASSIGNING FIELD-SYMBOL(<ls_ez_form_db>).
        <ls_ez_form_db>-zschicht    = ls_ez_formation-zschicht.
        <ls_ez_form_db>-zid_eiz     = ls_ez_formation-zid_eiz.
        <ls_ez_form_db>-zugnummer   = ls_ez_formation-zugnummer.
        <ls_ez_form_db>-richtung    = ls_ez_formation-richtung.
        <ls_ez_form_db>-ez_aktiv    = ls_arbstelle-checkbox.
        <ls_ez_form_db>-data_origin = ls_arbstelle-data_origin.
        <ls_ez_form_db>-zarbstl     = ls_arbstelle-zarbstl.
        <ls_ez_form_db>-has_changed = abap_true.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  IF lt_ez_form_db IS NOT INITIAL.
    wd_this->go_schicht->save_ez_form( EXPORTING it_ez_form = lt_ez_form_db iv_called_from = iv_called_from ). ">002< MOD
  ENDIF.

ENDMETHOD.

METHOD select_ez_form.
  DATA lt_zug_id_rng TYPE RANGE OF zia_2_zug_id.
  DATA lt_arbstl_rng TYPE RANGE OF zia_2_id_arbstl.

  lt_zug_id_rng = COND #( WHEN iv_zug_id IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_zug_id ) ) ELSE lt_zug_id_rng ).
  lt_arbstl_rng = COND #( WHEN iv_zug_id IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_arbstl ) ) ELSE lt_arbstl_rng ).


  DATA(lv_zschicht) = wd_this->go_schicht->get_id( ).

**  SELECT *
**    FROM zia_2sf_ez_form
**    INTO CORRESPONDING FIELDS OF TABLE @rt_data
**    WHERE zschicht  =  @lv_zschicht
**      AND zugnummer IN @lt_zug_id_rng
**      AND zarbstl   IN @lt_arbstl_rng.

  rt_data = wd_assist->get_train_maint_data( iv_shift = lv_zschicht it_arbstl_rng = lt_arbstl_rng it_zug_id_rng = lt_zug_id_rng  ).
ENDMETHOD.

METHOD set_checkbox_changed .

  DATA(ls_arbstelle) = VALUE wd_this->element_arbstellen_schiene( ).

  ii_element->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).

  DATA(lv_has_changed) = COND #( WHEN ls_arbstelle-checkbox <> ls_arbstelle-checkbox_orig THEN abap_true ELSE abap_false ).

  wd_this->set_has_changed( ii_element = ii_element iv_value = lv_has_changed ).

ENDMETHOD.

METHOD set_has_changed .

  ii_element->set_attribute( name = 'HAS_CHANGED' value = iv_value ).

ENDMETHOD.

METHOD set_schicht .

  wd_this->go_schicht = io_schicht.
  wd_this->set_tremola( iv_reset = iv_reset ).

  wd_this->gv_perimeter = wd_this->go_schicht->get_data( )-zzperi.

  wd_this->gv_edit_mode = wd_this->go_schicht->is_locked( ).
  wd_this->gv_edit_mode = COND #( WHEN wd_this->go_schicht->get_status( ) = zif_ia_2_wrkshft_status=>mc_shift_released
                                  THEN abap_false
                                  ELSE wd_this->gv_edit_mode ).

ENDMETHOD.

METHOD set_test_mode .

  GET PARAMETER ID 'ZIO_5TEST' FIELD DATA(lv_test).
  wd_this->gv_testmode = boolc( lv_test IS NOT INITIAL ).

ENDMETHOD.

METHOD set_tremola .

  CLEAR wd_this->go_tremola.

  CHECK wd_this->is_tremola_active( ).

  wd_this->go_tremola = zcl_ia_2tremola=>get_instance( io_schicht   = wd_this->go_schicht
                                                        iv_new       = iv_reset ).


ENDMETHOD.

METHOD subscribe_to_button_event .

  DATA(lv_button) = VALUE wdr_popup_button( ).
  DATA(lv_button_text) = ``.

  CASE iv_action.
    WHEN `BTN_SAVE`.
      lv_button      = iv_button.
      lv_button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/AENDERUNGEN_SPEICHERN_UND_SCHLIESSEN` ).

    WHEN `BTN_RESET`.
      lv_button      = iv_button.
      lv_button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/AENDERUNGEN_ZURUECKSETZEN` ).

    WHEN `BTN_CLOSE`.
      lv_button      = if_wd_window=>co_button_cancel.
      lv_button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = `ZIA_2GBT_PG2/SCHLIESSEN` ).

  ENDCASE.

  wd_this->gi_window->subscribe_to_button_event( button      = lv_button
                                                 button_text = lv_button_text
                                                 action_view = ii_view_controller
                                                 action_name = iv_action
                                               ).

ENDMETHOD.

METHOD switch_arbstelle_checkbox .

  DATA(ls_ez_form_key) = wd_this->get_ez_form_key_from_elem( ii_element = ii_element ).

  DATA(lt_arbeitsstellen) = wd_this->get_arbeitsstellen_for_switch( ).

  SORT lt_arbeitsstellen BY zugnummer zarbstl.

  LOOP AT lt_arbeitsstellen ASSIGNING FIELD-SYMBOL(<ls_arbeitsstelle>).

    AT NEW zugnummer.
      DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).
      <ls_arbeitsstelle>-elem_ez_form->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).
      DATA(lv_checkbox) = abap_false.
      DATA(lv_has_changed) = abap_false.
      DATA(lv_is_mnl_chng) = abap_false.    " (+) 914
    ENDAT.

    DATA(ls_arbstelle) = VALUE if_componentcontroller=>element_arbstellen_schiene( ).
    <ls_arbeitsstelle>-elem_arbeitsstelle->get_static_attributes( IMPORTING static_attributes = ls_arbstelle ).

    IF    ls_ez_form_key-zschicht  =  ls_ez_formation-zschicht
      AND ls_ez_form_key-zid_eiz   =  ls_ez_formation-zid_eiz
      AND ls_ez_form_key-richtung  =  ls_ez_formation-richtung
      AND ls_ez_form_key-zarbstl   =  ls_arbstelle-zarbstl
      AND ls_ez_form_key-zugnummer <> ls_ez_formation-zugnummer.

      IF ls_arbstelle-checkbox = abap_true.
        ls_arbstelle-checkbox = abap_false.
        <ls_arbeitsstelle>-elem_arbeitsstelle->set_attribute( name = 'CHECKBOX' value = ls_arbstelle-checkbox ).
        ls_arbstelle-has_changed = COND #( WHEN ls_arbstelle-checkbox <> ls_arbstelle-checkbox_orig THEN abap_true ELSE abap_false ).
      ENDIF.

      wd_this->set_checkbox_changed( ii_element = <ls_arbeitsstelle>-elem_arbeitsstelle ).

    ENDIF.

    lv_checkbox = COND #( WHEN ls_arbstelle-checkbox = abap_true THEN abap_true ELSE lv_checkbox ).
    lv_has_changed = COND #( WHEN ls_arbstelle-has_changed = abap_true THEN abap_true
                             ELSE lv_has_changed ).

    lv_is_mnl_chng = COND #( WHEN ls_arbstelle-data_origin <> zif_ia_2_constant=>mc_data_origin-tremola  AND ls_arbstelle-checkbox = abap_true   "Change >002<         "914 (+) start
                             THEN abap_true
                             ELSE lv_is_mnl_chng ).

    IF ( ls_arbstelle-data_origin = zif_ia_2_constant=>mc_data_origin-tremola AND ls_arbstelle-checkbox = abap_false ) OR  "Tremola checkbox removed "Change >002<
         lv_is_mnl_chng  = abap_true .                                                       "Manual change still exists for frzg line
      lv_has_changed = abap_true.
    ENDIF.                                                                                                                    "914 (+) start

    AT END OF zugnummer.
      wd_this->after_arbstelle_checkbox( ii_parent_element   = <ls_arbeitsstelle>-elem_ez_form
                                         iv_trennung_visible = lv_checkbox ).
      wd_this->set_has_changed( ii_element = <ls_arbeitsstelle>-elem_ez_form iv_value = lv_has_changed ).
    ENDAT.

  ENDLOOP.

ENDMETHOD.

METHOD tremola_calc_and_save .
  CHECK wd_this->is_tremola_active( ).

  wd_this->go_message_manager->reset( ).

  DATA(lt_bapiret) = wd_this->go_tremola->calculate_and_save( iv_testmode = wd_this->gv_testmode ).
  wd_this->go_message_manager->add_bapiret_t( it_table = lt_bapiret ).
  et_bapiret = lt_bapiret. ">001< +

ENDMETHOD.

method Z_SAVE_CBT .

  wd_this->save_manual_trassen( ).  ">001< +
  wd_this->save_ez_form( ).

ENDMETHOD.

METHOD z_save_gbt .

  wd_this->save_manual_trassen( ). "+>001<

  wd_this->save_ez_form( ).

ENDMETHOD.

METHOD z_supply_ez_form_gbt .

  IF wd_this->go_schicht->is_tremola_active( ) AND
     wd_this->go_schicht->get_status( ) < zif_ia_2_wrkshft_status=>mc_shift_released.

    rt_ez_formations = wd_this->z_supply_ez_form_tremola( node             = node
                                                          parent_element   = parent_element ).
  ELSE.
    rt_ez_formations = wd_this->z_supply_ez_form_real( node             = node
                                                       parent_element   = parent_element ).
  ENDIF.

ENDMETHOD.

METHOD z_supply_ez_form_real .

  DATA(lv_schich_id) = wd_this->go_schicht->get_id( ).

  DATA(lt_trassen) = wd_this->go_schicht->get_trassen( ).

  SORT lt_trassen BY zid_eiz     ASCENDING
                     richtung    DESCENDING
                     data_origin ASCENDING  "+>001<
                     zugnummer   ASCENDING.

  DELETE lt_trassen WHERE data_origin = zif_ia_2_constant=>mc_data_origin-vorlage.  ">003< (+)

  LOOP AT lt_trassen ASSIGNING FIELD-SYMBOL(<ls_trasse>).
    AT NEW richtung.
      DATA(lv_show_seperator) = abap_true.
    ENDAT.

    APPEND INITIAL LINE TO rt_ez_formations ASSIGNING FIELD-SYMBOL(<ls_ez_formation>).
    <ls_ez_formation> = CORRESPONDING #( <ls_trasse> ).
    <ls_ez_formation>-zschicht = lv_schich_id.

    <ls_ez_formation>-eiz_ktxt = zcl_ia_2betriebspunk=>get_eiz_ort( iv_value = <ls_ez_formation>-zid_eiz ).

    <ls_ez_formation>-zid_eiz  = <ls_trasse>-zid_eiz.   ">003<  +

    <ls_ez_formation>-einfahrt = boolc( <ls_ez_formation>-richtung = zif_ia_2_tracks=>mc_richtung_einfahrt ).
    <ls_ez_formation>-ausfahrt = boolc( <ls_ez_formation>-richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt ).

    <ls_ez_formation>-fahrtzeit = SWITCH #( <ls_ez_formation>-richtung
                                            WHEN zif_ia_2_tracks=>mc_richtung_einfahrt THEN <ls_trasse>-zab
                                            WHEN zif_ia_2_tracks=>mc_richtung_ausfahrt THEN <ls_trasse>-zan
                                          ).

    <ls_ez_formation>-show_seperator = lv_show_seperator.
    CLEAR lv_show_seperator.

*--> Begin Insert >001<
    AT END OF richtung.
      IF wd_this->gv_edit_mode = abap_true.
        <ls_ez_formation>-show_add_btn = abap_true.
      ENDIF.
    ENDAT.

    "Default
    <ls_ez_formation>-existing_in_db = abap_true.
    <ls_ez_formation>-display_only   = abap_true. "Only false for manually created in session
    <ls_ez_formation>-ena_zeit_am_starttag = abap_false.  " >002< (+)

    IF <ls_trasse>-data_origin EQ zif_ia_2_constant=>mc_data_origin-manual.
      <ls_ez_formation>-manually_created = abap_true.
      IF wd_this->gv_edit_mode = abap_true.
        "Only show remove button in edit mode
        <ls_ez_formation>-show_remove_btn = abap_true.
        <ls_ez_formation>-ena_zeit_am_starttag = abap_true.  " >002< (+)
      ENDIF.
    ENDIF.
*--> End Insert >001<

  ENDLOOP.

*--> Begin Insert >001<
  IF rt_ez_formations IS INITIAL.
    "No entries found in DB, add blank line
    APPEND INITIAL LINE TO rt_ez_formations ASSIGNING <ls_ez_formation>.

    "Default
    <ls_ez_formation>-existing_in_db = abap_true.
    <ls_ez_formation>-display_only   = abap_true. "Only false for manually created in session
    <ls_ez_formation>-ena_zeit_am_starttag = abap_false.  " >002< (+)

    IF wd_this->gv_edit_mode = abap_true.
      <ls_ez_formation>-show_add_btn = abap_true.
    ENDIF.
  ENDIF.
*--> End Insert >001<
ENDMETHOD.

METHOD z_supply_ez_form_tremola .
  FIELD-SYMBOLS: <ls_ez_form_last> TYPE LINE OF zia_2ez_form_wd_t. "Change >001<

  wd_this->go_message_manager->display_messages( ).

  DATA(lv_schich_id) = wd_this->go_schicht->get_id( ).

  wd_this->go_tremola->get_ez_form( IMPORTING et_ez_form = DATA(lt_ez_form) ).

  SORT lt_ez_form BY zschicht ASCENDING
                     zid_eiz  ASCENDING
                     richtung DESCENDING
                     zugnummer ASCENDING.

  DELETE ADJACENT DUPLICATES FROM lt_ez_form COMPARING zschicht zid_eiz richtung zugnummer
                                                       data_origin. ">004< (+)

  LOOP AT lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form>).
    APPEND INITIAL LINE TO rt_ez_formations ASSIGNING FIELD-SYMBOL(<ls_ez_formation>).

    <ls_ez_formation> = CORRESPONDING #( <ls_ez_form> ).
    <ls_ez_formation>-zschicht = lv_schich_id.

    <ls_ez_formation>-eiz_ktxt = zcl_ia_2betriebspunk=>get_eiz_ort( iv_value = <ls_ez_formation>-zid_eiz ).
    <ls_ez_formation>-zid_eiz  = <ls_ez_form>-zid_eiz.   ">003<  +

    <ls_ez_formation>-einfahrt = boolc( <ls_ez_formation>-richtung = zif_ia_2_tracks=>mc_richtung_einfahrt ).
    <ls_ez_formation>-ausfahrt = boolc( <ls_ez_formation>-richtung = zif_ia_2_tracks=>mc_richtung_ausfahrt ).

*--> Begin Change >001<
    IF <ls_ez_form_last>-richtung IS ASSIGNED AND
      <ls_ez_form>-richtung NE <ls_ez_form_last>-richtung.
*--> End Change >001<
      <ls_ez_formation>-show_seperator = abap_true.
*--> Begin Insert >001<
      IF wd_this->gv_edit_mode = abap_true.
        <ls_ez_form_last>-show_add_btn = abap_true.
      ENDIF.
*--> End Insert >001<
    ENDIF.

*--> Begin Insert >001<
    "Default
    <ls_ez_formation>-existing_in_db = abap_true.
    <ls_ez_formation>-display_only   = abap_true. "Only false for manually created in session
    <ls_ez_formation>-ena_zeit_am_starttag = abap_false. ">002< (+)

    IF <ls_ez_form>-manually_created = abap_true." OR
      " <ls_ez_form>-data_origin      = zif_io_5_constant=>mc_data_origin-manual.   " >003<  +
      <ls_ez_formation>-manually_created = abap_true.
      IF wd_this->gv_edit_mode = abap_true.
        "Only show remove button in edit mode
        <ls_ez_formation>-show_remove_btn      = abap_true.
        <ls_ez_formation>-ena_zeit_am_starttag = abap_true. ">002< (+)
      ENDIF.
    ENDIF.
*--> End Insert >001<

    ASSIGN <ls_ez_formation> TO <ls_ez_form_last>. "Change >001<
  ENDLOOP.

*--> Begin Insert >001<
  IF <ls_ez_formation> IS ASSIGNED AND "Last row
     wd_this->gv_edit_mode = abap_true.
    <ls_ez_formation>-show_add_btn = abap_true.

    UNASSIGN: <ls_ez_formation>,
              <ls_ez_form_last>.
  ENDIF.

  IF rt_ez_formations IS INITIAL.
    "No entries found in DB, add blank line
    APPEND INITIAL LINE TO rt_ez_formations ASSIGNING <ls_ez_formation>.

    "Default
    <ls_ez_formation>-existing_in_db = abap_true.
    <ls_ez_formation>-display_only   = abap_true. "Only false for manually created in session
    <ls_ez_formation>-ena_zeit_am_starttag = abap_false. ">002< (+)

    IF wd_this->gv_edit_mode = abap_true.
      <ls_ez_formation>-show_add_btn = abap_true.
    ENDIF.
  ENDIF.
*--> End Insert >001<

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_arbstellen_schiene .
  DATA(ls_ez_formation) = VALUE wd_this->element_ez_formation( ).

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_ez_formation ).

  DATA(lt_ez_form) = wd_this->go_schicht->get_ez_form( iv_eiz_id    = ls_ez_formation-zid_eiz
                                                       iv_zugnummer = ls_ez_formation-zugnummer
                                                       iv_richtung  = ls_ez_formation-richtung ).

  DATA(lt_ez_form_db) = wd_this->select_ez_form( ).

  DATA(lt_arbstellen) = VALUE wd_this->elements_arbstellen_schiene( ).

  DATA(li_arbstelle_i) = wd_this->go_schicht->get_arbeitsstellen( )->get_values_iterator( ).

  DATA(lv_checkbox) = abap_false.

  WHILE li_arbstelle_i->has_next( ).
    DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbstelle_i->get_next( ) ).
    CHECK NOT lo_arbstelle->is_pneu( ).

    DATA(ls_arbstelle) = lo_arbstelle->get_data( ).

    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstelle>).

    <ls_arbstelle>-zarbstl = lo_arbstelle->get_id( ).
    <ls_arbstelle>-ktext = lo_arbstelle->get_text_id( zcl_ia_2utilities2=>mc_zugangsart_schiene ).

    <ls_arbstelle>-is_visible = boolc( ls_ez_formation-zid_eiz = ls_arbstelle-zid_eiz ).
    <ls_arbstelle>-is_enabled = boolc( <ls_arbstelle>-is_visible = abap_true AND wd_this->gv_edit_mode = abap_true AND ls_ez_formation-deactivated = abap_false ).

    ">003< + begin
    IF wd_this->go_schicht->is_versorgung_schicht( ) AND wd_this->gv_edit_mode = abap_true.
      "Versorgung (=V) muss nur die nur Einfahrt Nord und Süd gepflegt werden
      <ls_arbstelle>-is_enabled = COND #( WHEN ls_ez_formation-einfahrt = abap_true THEN abap_true ELSE abap_false ).
    ELSEIF wd_this->go_schicht->is_entsorgung_schicht( ) AND wd_this->gv_edit_mode = abap_true.
      "Entsorgung (=E) muss nur die nur Ausfahrt Nord und Süd  gepflegt werden
      <ls_arbstelle>-is_enabled = COND #( WHEN ls_ez_formation-ausfahrt = abap_true THEN abap_true ELSE abap_false ).
    ENDIF.
    ">003< + end

    READ TABLE lt_ez_form ASSIGNING FIELD-SYMBOL(<ls_ez_form>) WITH KEY zarbstl = <ls_arbstelle>-zarbstl.
    IF sy-subrc = 0.

*--> Begin Insert >002<
      DATA(lv_data_origin) = COND zia_2_data_origin( WHEN ls_ez_formation-manually_created = abap_true
                                                      THEN zif_ia_2_constant=>mc_data_origin-manual
                                                     ELSE zif_ia_2_constant=>mc_data_origin-real ).
*--> End Insert >002<

      " <ls_arbstelle>-checkbox = <ls_ez_form>-ez_aktiv.                                           "914 (-)
      ASSIGN lt_ez_form_db[ zarbstl     = <ls_arbstelle>-zarbstl         "Check manuall change     "914 (+) start
                            zid_eiz     = ls_ez_formation-zid_eiz
                            richtung    = ls_ez_formation-richtung
                            data_origin = lv_data_origin ] TO FIELD-SYMBOL(<ls_ez_form_manuall>). "Change >002<
      IF sy-subrc = 0 AND
         <ls_ez_form_manuall>-data_origin NE zif_ia_2_constant=>mc_data_origin-tremola. "+>002<
        IF <ls_ez_form_manuall>-zugnummer = ls_ez_formation-zugnummer.    "Manuall change detected
          <ls_arbstelle>-checkbox = <ls_ez_form_manuall>-ez_aktiv.
        ENDIF.
        ls_ez_formation-has_changed = abap_true.
      ELSEIF ls_ez_formation-zugnummer = <ls_ez_form>-zugnummer. "Change >002<
        <ls_arbstelle>-checkbox = <ls_ez_form>-ez_aktiv.
      ENDIF.                                                                                        "914 (+) end

      <ls_arbstelle>-data_origin = <ls_ez_form>-data_origin.
    ENDIF.
    <ls_arbstelle>-checkbox_orig = <ls_arbstelle>-checkbox.
*--> Begin Insert >002<
    IF  "<ls_arbstelle>-data_origin IS INITIAL AND
       ls_ez_formation-manually_created = abap_true. "manually created in current session
      <ls_arbstelle>-data_origin = zif_ia_2_constant=>mc_data_origin-manual.
    ENDIF.
*--> End Insert >002<

    CHECK <ls_arbstelle>-checkbox = abap_true.

    lv_checkbox = abap_true.

  ENDWHILE.



  parent_element->set_static_attributes( EXPORTING static_attributes = ls_ez_formation ).



  IF lt_arbstellen[] IS INITIAL.
    APPEND INITIAL LINE TO lt_arbstellen.
  ENDIF.

  SORT lt_arbstellen BY ktext.

  node->bind_table( new_items            = lt_arbstellen
                    set_initial_elements = abap_true ).

  wd_this->after_arbstelle_checkbox( ii_parent_element   = parent_element
                                     iv_trennung_visible = lv_checkbox ).

ENDMETHOD.

METHOD supply_ez_formation .
  DATA(lt_ez_formations) = VALUE wd_this->elements_ez_formation( ).

  CASE wd_this->gv_perimeter.
    WHEN 'CBT'.
      lt_ez_formations = z_supply_ez_form_real( node           = node
                                                parent_element = parent_element ).
    WHEN 'GBT'.
      lt_ez_formations = z_supply_ez_form_gbt( node           = node
                                               parent_element = parent_element ).
  ENDCASE.

  IF lt_ez_formations IS INITIAL.
    APPEND INITIAL LINE TO lt_ez_formations.
  ENDIF.

  wd_this->filter_ez_formation( CHANGING ct_data = lt_ez_formations ). ">001< + begin
  IF lt_ez_formations IS INITIAL.
    RETURN.
  ENDIF.                                                               ">001< + end

  node->bind_table( new_items            = lt_ez_formations
                    set_initial_elements = abap_true ).

ENDMETHOD.

endclass.
 