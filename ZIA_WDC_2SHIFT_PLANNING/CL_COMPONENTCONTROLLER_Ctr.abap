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
*  " Initialize custom controllers (e.g., for personalization, message handling, etc.)
*  wd_this->init_cust_controllers( ).
*
*  "*******************
*  "* Message Manager Initialisierung (Message Manager Initialization)
*  "***************
*  " Get an instance of the message manager and set it up
*  wd_this->mo_message_manager = zcl_ia_2message_manager=>get_instance( ).
*
*  " Link the Web Dynpro message manager to the message manager
*  wd_this->mo_message_manager->set_wd_message_manager( ii_message_manager =  wd_this->wd_get_api( )->get_message_manager( ) ).
*
*  " Set the Web Dynpro context for the message manager
*  wd_this->mo_message_manager->set_wd_context( ii_context = wd_context ).
*
*  " Set the Web Dynpro component controller for the message manager
*  wd_this->mo_message_manager->set_wd_comp_controller( ii_comp_controller = wd_this->wd_get_api( ) ).
*
*  "*******************
*
*  " Check if the personalization controller has not been instantiated
*  IF wd_this->mo_personalization_ctr IS NOT BOUND.
*    " Instantiate the personalization API if needed
*    DATA(lo_api_personal) = CAST if_wd_component( wd_this->wd_get_api( ) ).
*    wd_this->mo_personalization_ctr = lo_api_personal->get_personalization_manager( ).
*  ENDIF.
*
*
*  " Create an object for UI element properties for later use
*  wd_this->mo_ui_element_properties = NEW zcl_ia_2ui_element_properties( ).
*
*  "*******************
*  "* Jobpool Datum Handling
*  "***************
*  " Declare a variable to store job pool date attributes
*  DATA: ls_jobpool_datum TYPE wd_this->element_jobpool_datum.
*
*  " Retrieve static attributes of the job pool date element and store them in ls_jobpool_datum
*  wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_jobpool_datum )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_jobpool_datum ).
*
*  " Set a specific flag (e.g., by_datum) to true
*  ls_jobpool_datum-by_datum = abap_true.
*
*  " Update the job pool date element with the new static attributes
*  wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_jobpool_datum )->get_element( )->set_static_attributes( static_attributes = ls_jobpool_datum ).
*
*  "*******************
*  "* Custom Styling for Multipane UI Element
*  "***************
*  " Get the custom style manager for the application
*  DATA(li_custom_style_manager) = wd_this->wd_get_api( )->get_application( )->get_custom_style_manager( ).
*
*  " Define style properties for the custom style (background color)
*  DATA lt_mp_style_prop TYPE if_wd_custom_style=>t_style_properties.
*  lt_mp_style_prop = VALUE #( ( name = 'backgroundColor' value = 'rgb(204, 204, 204)' ) ).
*
*  " Create a custom style for the 'multipane' container
*  DATA(lo_mp_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myPneuFzg'
*                                                                         library_name     = 'STANDARD'
*                                                                         element_type     = 'TRANSPARENT_CONTAINER'
*                                                                         style_properties = lt_mp_style_prop ).
*
*  " Add the custom style to the custom style manager
*  li_custom_style_manager->add_custom_style( lo_mp_custom_style ).
*
*  "*******************
*  "* Custom Styling for Arbeitsstellendetails (Workplace Details)
*  "***************
*  " Define style properties for workplace details text view (font size)
*  DATA lt_as_style_prop TYPE if_wd_custom_style=>t_style_properties.
*  lt_as_style_prop = VALUE #( ( name = 'fontSize' value = '14px' ) ).
*
*  " Create a custom style for the text view related to workplace details
*  DATA(lo_as_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myASDetails'
*                                                                           library_name     = 'STANDARD'
*                                                                           element_type     = 'TEXT_VIEW'
*                                                                           style_properties = lt_as_style_prop ).
*
*  " Add the custom style to the custom style manager
*  li_custom_style_manager->add_custom_style( lo_as_custom_style ).
*
*  " Define another custom style for links in workplace details (font size)
*  DATA lo_as_lta_style_prop TYPE if_wd_custom_style=>t_style_properties.
*  lo_as_lta_style_prop = VALUE #( ( name = 'fontSize' value = '14px' ) ).
*
*  " Create a custom style for the 'Link to Action' element in workplace details
*  DATA(li_as_lta_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myASDetails_lta'
*                                                                               library_name     = 'STANDARD'
*                                                                               element_type     = 'LINK_TO_ACTION'
*                                                                               style_properties = lo_as_lta_style_prop ).
*
*  " Add the custom style to the custom style manager
*  li_custom_style_manager->add_custom_style( li_as_lta_custom_style ).
*
*  "*******************
*  "* Progress Window Initialization
*  "***************
*  " Get the component usage for the progress window
*  DATA lo_cmp_usage TYPE REF TO if_wd_component_usage.
*  lo_cmp_usage =   wd_this->wd_cpuse_pi_window( ).
*
*  " Check if the progress window component is not yet created, and create it if needed
*  IF lo_cmp_usage->has_active_component( ) IS INITIAL.
*    lo_cmp_usage->create_component( ).
*  ENDIF.
*
*  " Get the interface controller for the progress window model
*  DATA lo_interfacecontroller TYPE REF TO ziwci_ia_wdc_2pi_window.
*  lo_interfacecontroller =   wd_this->wd_cpifc_pi_window( ).
*
*  " Get the model for the progress window interface controller
*  wd_this->mo_pi_assist = lo_interfacecontroller->get_model( ).
*
*  "*******************
*  "*>002<  ### Start ###
*  "*** Authorization Check for Erhaltungsplaner (Maintenance Planner)
*  "*******************
*  " Retrieve and store authorization data for Erhaltungsplaner
*  DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
*  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
*
*  " Perform authorization check for Erhaltungsplaner and update the authorization status
*  ls_auth_erhaltungsplaner-auth_erhaltungsplaner = wd_this->check_auth_erhaltungsplaner( ).
*
*  " Set the updated authorization data back into the context
*  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->set_static_attributes( static_attributes = ls_auth_erhaltungsplaner ).

  wd_this->init_cust_controllers( ).

  "*******************
  "* Message Manager Initialisierung
  "***************
  wd_this->mo_message_manager = zcl_ia_2message_manager=>get_instance( ).
  wd_this->mo_message_manager->set_wd_message_manager( ii_message_manager =  wd_this->wd_get_api( )->get_message_manager( ) ).
  wd_this->mo_message_manager->set_wd_context( ii_context = wd_context ).
  wd_this->mo_message_manager->set_wd_comp_controller( ii_comp_controller = wd_this->wd_get_api( ) ).

  ">001< begin (+)
  IF wd_this->mo_personalization_ctr IS NOT BOUND.
    DATA(li_api_personal) = CAST if_wd_component( wd_this->wd_get_api( ) ).
    wd_this->mo_personalization_ctr = li_api_personal->get_personalization_manager( ).
  ENDIF.
  ">001< end (+)

  wd_this->mo_ui_element_properties = NEW zcl_ia_2ui_element_properties( ).

  DATA: ls_jobpool_datum TYPE wd_this->element_jobpool_datum.
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_jobpool_datum )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_jobpool_datum ).

  ls_jobpool_datum-by_datum = abap_true.

  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_jobpool_datum )->get_element( )->set_static_attributes( static_attributes = ls_jobpool_datum ).

  "*******************
  "* Multipane CustomStyle
  "***************

  DATA(li_custom_style_manager) = wd_this->wd_get_api( )->get_application( )->get_custom_style_manager( ).
  DATA lt_mp_style_prop TYPE if_wd_custom_style=>t_style_properties.
  lt_mp_style_prop = VALUE #(
                               ( name = 'backgroundColor' value = 'rgb(204, 204, 204)' ) ).


  DATA(li_mp_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myPneuFzg'
                                                                           library_name     = 'STANDARD'
                                                                           element_type     = 'TRANSPARENT_CONTAINER'
                                                                           style_properties = lt_mp_style_prop ).
  li_custom_style_manager->add_custom_style( li_mp_custom_style ).

  "*******************
  "* Arbeitsstellendetails - Signalabschnitte/Kilometer und co
  "***************
  DATA lt_as_style_prop TYPE if_wd_custom_style=>t_style_properties.
  lt_as_style_prop = VALUE #( ( name = 'fontSize' value = '14px' ) ).

  DATA(li_as_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myASDetails'
                                                                           library_name     = 'STANDARD'
                                                                           element_type     = 'TEXT_VIEW'
                                                                           style_properties = lt_as_style_prop ).
  li_custom_style_manager->add_custom_style( li_as_custom_style ).

  DATA lt_as_lta_style_prop TYPE if_wd_custom_style=>t_style_properties.
  lt_as_lta_style_prop = VALUE #( ( name = 'fontSize' value = '14px' ) ).

  DATA(li_as_lta_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = 'myASDetails_lta'
                                                                           library_name     = 'STANDARD'
                                                                           element_type     = 'LINK_TO_ACTION'
                                                                           style_properties = lt_as_lta_style_prop ).
  li_custom_style_manager->add_custom_style( li_as_lta_custom_style ).

  " check box
  DATA lt_btn_style_properties TYPE if_wd_custom_style=>t_style_properties.
*  DATA(li_custom_style_manager) = wd_comp_controller->wd_get_api( )->get_application( )->get_custom_style_manager( ).
  lt_btn_style_properties = VALUE #(
                                     ( name = `fontColor` value = `WHITE` ) ).
  DATA(li_btn_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = `myStyleClass`
                                                                            library_name     = 'STANDARD'
*                                                                            element_type     = 'BUTTON'
                                                                            element_type     = 'CHECKBOX'
                                                                            style_properties = lt_btn_style_properties ).
  li_custom_style_manager->add_custom_style( li_btn_custom_style ).

  " road_map
  DATA lt_road_style_properties TYPE if_wd_custom_style=>t_style_properties.
*  DATA(li_custom_style_manager) = wd_comp_controller->wd_get_api( )->get_application( )->get_custom_style_manager( ).
  lt_road_style_properties = VALUE #(
                                     ( name = `fontColor` value = `WHITE` )
                                     ( name = 'backgroundColor' value = 'BLUE' ) ).
  DATA(li_road_custom_style) = li_custom_style_manager->create_custom_style( style_class_name = `myStyleClass1`
                                                                            library_name     = 'STANDARD'
*                                                                            element_type     = 'BUTTON'
                                                                            element_type     = 'ROAD_MAP'
                                                                            style_properties = lt_road_style_properties ).
  li_custom_style_manager->add_custom_style( li_road_custom_style ).

*



  "*******************
  "* ProgressWindow
  "***************
  DATA li_cmp_usage TYPE REF TO if_wd_component_usage.
  li_cmp_usage =   wd_this->wd_cpuse_pi_window( ).

  IF li_cmp_usage->has_active_component( ) IS INITIAL.
    li_cmp_usage->create_component( ).
  ENDIF.

  DATA li_interfacecontroller TYPE REF TO ziwci_ia_wdc_2pi_window.
  li_interfacecontroller =   wd_this->wd_cpifc_pi_window( ).
  wd_this->mo_pi_assist = li_interfacecontroller->get_model( ).

***
*** >002<  ### Start ###
***
* Check edit authority for Erhaltungsplaner
  DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
  ls_auth_erhaltungsplaner-auth_erhaltungsplaner = wd_this->check_auth_erhaltungsplaner( ).
  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->set_static_attributes( static_attributes = ls_auth_erhaltungsplaner ).
***
*** >002<  ### End ###
***


ENDMETHOD.

method WDDOPOSTPROCESSING . "#EC NEEDED
endmethod.

METHOD arbst_anlegen .
  " Declaration
  DATA(lv_aufnr) = VALUE aufnr( ).
  DATA: lv_id_btg TYPE zia_2_id_btg.
  ##NEEDED DATA: lo_arbstellen_abh TYPE REF TO cl_object_map.

  " "Check if order selected"
  IF wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->get_lead_selection( ) IS INITIAL.
    RETURN.
  ENDIF.
  " "Is editable?"
  TRY.
      DATA(lo_schicht) = zcl_ia_2context_helper=>get_editable_schicht( ii_context = wd_context ).
    CATCH zcx_ia_2failure INTO DATA(lx_exception).
      wd_this->mo_message_manager->add_bapiret_t( it_table = lx_exception->get_bapiret( ) ).
      wd_this->mo_message_manager->display_messages( ).
      wd_this->mo_message_manager->reset( ).
      RETURN.
  ENDTRY.

  "Create order object"
  DATA(lo_auftrag) = zcl_ia_2context_helper=>get_selected_auftrag_as_obj( ii_context = wd_context ).

  "Are the blocking sections planned for the shift?"
  TRY.
      lo_auftrag->check_avaiable_sp_schicht( io_schicht = lo_schicht ).
    CATCH zcx_ia_2failure INTO lx_exception.
      wd_this->mo_message_manager->add_bapiret_t( it_table = lx_exception->get_bapiret( ) ).
      wd_this->mo_message_manager->display_messages( ).
      wd_this->mo_message_manager->reset( ).
      RETURN.
  ENDTRY.

  """
  TRY.
      " lock
      lo_auftrag->lock( ).
      " reload
      lo_auftrag->reload( ).

      IF lo_auftrag->get_data( )-zschicht IS NOT INITIAL.
        RETURN.
      ENDIF.
      " excepton
    CATCH zcx_ia_2failure INTO lx_exception.
      wd_this->mo_message_manager->add_bapiret_t( it_table = lx_exception->get_bapiret( ) ).
      wd_this->mo_message_manager->display_messages( ).
      wd_this->mo_message_manager->reset( ).
      RETURN.
  ENDTRY.

  "*******************
  "* Check if the selected order is in a BTG.
  "***************

  IF lo_auftrag->is_in_btg( IMPORTING ev_id_btg = lv_id_btg ) EQ abap_true.
    """
    TRY .
        DATA(lo_arbst_btg) = lo_schicht->get_arbst_by_id_btg( iv_id_btg = lv_id_btg ).

        IF lo_arbst_btg IS NOT INITIAL.
          wd_this->mo_message_manager->add_message( EXPORTING iv_msgno = 141        ""There is already a job in the company building &1."
                                                              iv_msgty = 'E'
                                                              iv_msgv1 = lv_id_btg ).
          wd_this->mo_message_manager->display_messages( ).
          wd_this->mo_message_manager->reset( ).
          RETURN.
        ENDIF.

      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        wd_this->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
        wd_this->mo_message_manager->reset( ).
    ENDTRY.
  ENDIF.

  ##NEEDED DATA(lt_arbstl_alt) = lo_schicht->get_arbeitsstellen( )->map.

  """" create work area
  DATA(lo_arbstelle) = lo_schicht->create_arbeitsstelle( EXPORTING io_auftrag        = lo_auftrag
                                                             iv_ignore_errors  = iv_ignore_warnings
                                                             iv_auto_planning  = abap_false
                                                   IMPORTING eo_arbstellen_abh = lo_arbstellen_abh ).

  lo_auftrag->unlock( ).

  lo_schicht->add_arbeitsstelle( io_arbstelle = lo_arbstelle ).
  lv_aufnr = lo_auftrag->get_data( )-aufnr.

  TRY.
      wd_this->mo_cc_schichtplan->validate_add_auftrag( io_arbeitsstelle = lo_arbstelle
                                                  iv_aufnr         = lv_aufnr ).
    ##NO_HANDLER  CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      wd_this->mo_message_manager->add_bapiret_t( lx_validation_error->gt_bapiret ).
      wd_this->mo_message_manager->display_messages( ).
      RETURN.
    ##NEEDED   ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_validation). "#EC EMPTY_CATCH
  ENDTRY.

  TRY.
      wd_this->mo_cc_schichtplan->change_auftrag_status( io_arbeitsstelle = lo_arbstelle
                                                   io_auftrag       = lo_auftrag ).
    CATCH zcx_ia_2failure INTO DATA(lx_status_error).
      wd_this->mo_message_manager->add_bapiret_t( lx_status_error->gt_bapiret ).
      wd_this->mo_message_manager->display_messages( ).
      RETURN.
  ENDTRY.


  lo_schicht->save( ).
  lo_schicht->reload( ).

  IF lo_arbstelle IS BOUND.
    DATA(ls_shift_data) = lo_schicht->get_data( ).
      IF ls_shift_data-zstatus LE 1.
      " change priority of the notification
      lo_schicht->get_workarea( EXPORTING iv_shift = lo_arbstelle->gs_arbeitsstelle-zschicht  ).
    ENDIF.
    " change priority of the notification
*    lo_schicht->get_workarea( EXPORTING iv_shift = lo_arbstelle->gs_arbeitsstelle-zschicht  ).
    " change user status of the order
    lo_schicht->change_userstatus_by_prio( EXPORTING iv_qmnum = lo_arbstelle->gs_arbeitsstelle-zschicht
                                                     iv_order = lv_aufnr ).
  ENDIF.


  " Erfolgsmeldung ausgeben
  IF lo_arbstelle IS NOT INITIAL.
    wd_this->mo_message_manager->add_message( EXPORTING iv_msgid = 'ZIA_2_REAL' iv_msgno = '331' iv_msgty = 'S'  iv_msgv1 = lo_auftrag->get_data( )-aufnr iv_msgv2 = lo_arbstelle->get_kurztext( ) ).
  ENDIF.



  wd_this->mo_message_manager->display_messages( ).
  wd_this->mo_message_manager->reset( ).


*  wd_this->mo_cc_schichtplan->invalidate_schichtplan( ).

*  "Arbeitsstellen neue aufbauen
  wd_context->get_child_node( name = wd_this->wdctx_schichtplan  )->get_lead_selection(
     )->get_child_node( name = wd_this->wdctx_arbstellen )->invalidate( ).

  wd_context->get_child_node( name = wd_this->wdctx_auftraege
     )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).

  wd_context->get_child_node( name = wd_this->wdctx_auftraege
     )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).

*
  DATA: ls_date_nav TYPE wd_this->element_date_navigator.
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
  CASE ls_date_nav-perimeter.
    WHEN 'GBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_gbt )->get_child_node( name = wd_this->wdctx_markings_gbt )->invalidate( ).
    WHEN 'CBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_cbt )->get_child_node( name = wd_this->wdctx_markings_cbt )->invalidate( ).
  ENDCASE.

ENDMETHOD.

METHOD btn_handler_popup .

  DATA: ls_sp_details  TYPE wd_this->element_sp_details. "+>003<
  DATA: lt_sp_ehb_user TYPE wd_this->elements_sp_ehb_filtered,
        ls_sp_ehb_user LIKE LINE OF lt_sp_ehb_user,
        ls_signlausr   TYPE zia_2sf_sc_usr.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
   )->get_child_node( name = wd_this->wdctx_details
   )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered )->get_static_attributes_table( IMPORTING table = lt_sp_ehb_user ).

  DATA(lt_sp_shicht) = wd_this->mo_curr_arbstelle->get_schicht( )->get_sp_schicht( ).
  DATA(ls_sp_shicht) = VALUE #( lt_sp_shicht[ 1 ] OPTIONAL ).

*--> Begin Insert >002<
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true. "temp while testing.

    wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
          )->get_child_node( name = wd_this->wdctx_details
          )->get_child_node( name = wd_this->wdctx_sp_details
          )->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).

    ls_sp_shicht = VALUE #( lt_sp_shicht[ sperras_id = ls_sp_details-sperras_id ] OPTIONAL ).
  ENDIF.
*--> End Insert >002<
  CASE iv_button.
    WHEN 'NORTH_ADD'.
      DATA(ls_line) = VALUE #( lt_sp_ehb_user[ 1 ] OPTIONAL ).
      wd_this->mv_current_action_buttons = 'N'.
    WHEN 'NORTH_SUB'.
      ls_line = VALUE #( lt_sp_ehb_user[ 1 ] OPTIONAL ).
      wd_this->mv_current_action_buttons = 'N'.
    WHEN 'SOUTH_ADD'.
      DATA(lv_offset) = lines( lt_sp_ehb_user ).
      ls_line = VALUE #( lt_sp_ehb_user[ lv_offset ] OPTIONAL ).
      wd_this->mv_current_action_buttons = 'S'.
    WHEN 'SOUTH_SUB'.
      lv_offset = lines( lt_sp_ehb_user ).
      ls_line = VALUE #( lt_sp_ehb_user[ lv_offset ] OPTIONAL ).
      wd_this->mv_current_action_buttons = 'S'.
  ENDCASE.


**  SELECT SINGLE * FROM zia_2sc_seq INTO @DATA(ls_sa_abfolge)
**    WHERE sperrabschnitt = @ls_line-zest AND
**    signalabschnitt = @ls_line-zsa.
  DATA(ls_sa_abfolge) = wd_assist->get_signalsections( iv_zest = ls_line-zest iv_zsa = ls_line-zsa ).

  CASE wd_this->mv_current_action_buttons.
    WHEN 'N'.
*      SELECT SINGLE * FROM zia_2sc INTO @DATA(ls_sa)
*        WHERE zsa = @ls_sa_abfolge-n_signalabschnitt
*        AND zest = @ls_sa_abfolge-n_sperrabschnitt.
      DATA(ls_sa) =  wd_assist->get_signals( iv_zsa = ls_sa_abfolge-n_signalabschnitt iv_zest = ls_sa_abfolge-n_sperrabschnitt  ).

      ls_sp_ehb_user-zest = ls_sa_abfolge-n_sperrabschnitt.
      ls_sp_ehb_user-zsa = ls_sa_abfolge-n_signalabschnitt.
      ls_sp_ehb_user-km_von = ls_sa-km_von.
      ls_sp_ehb_user-km_bis = ls_sa-km_bis.
      ls_sp_ehb_user-zehb = ls_sa-zehb.
      ls_sp_ehb_user-sp_filter = ls_line-sp_filter.

      MOVE-CORRESPONDING ls_sp_ehb_user TO ls_signlausr.
*      ls_signlausr-zarbstl = wd_this->mo_curr_arbstelle->ms_arbeitsstelle-zarbstl.
      ls_signlausr-sperras_id = ls_sp_shicht-sperras_id.
      ls_signlausr-zschicht = ls_sp_shicht-zschicht.

      IF iv_button = 'NORTH_ADD'.
        INSERT wd_this->mv_current_action_buttons INTO wd_this->gt_popup_action_tracer[] INDEX 1.
        INSERT ls_signlausr INTO wd_this->gt_popup_user_added_signals INDEX 1.
        INSERT ls_sp_ehb_user INTO lt_sp_ehb_user[] INDEX 1.
      ELSEIF iv_button = 'NORTH_SUB'.
        DELETE wd_this->gt_popup_action_tracer[] INDEX 1.
        DELETE wd_this->gt_popup_user_added_signals[] INDEX 1.
        IF sy-subrc = 0.
          DELETE lt_sp_ehb_user[] INDEX 1.
        ENDIF.
      ENDIF.

    WHEN 'S'.
*      SELECT SINGLE * FROM zia_2sc INTO @ls_sa
*        WHERE zsa = @ls_sa_abfolge-s_signalabschnitt
*        AND zest = @ls_sa_abfolge-s_sperrabschnitt.
      ls_sa =  wd_assist->get_signals( iv_zsa = ls_sa_abfolge-s_signalabschnitt iv_zest = ls_sa_abfolge-s_sperrabschnitt  ).

      ls_sp_ehb_user-zest = ls_sa_abfolge-s_sperrabschnitt.
      ls_sp_ehb_user-zsa = ls_sa_abfolge-s_signalabschnitt.
      ls_sp_ehb_user-km_von = ls_sa-km_von.
      ls_sp_ehb_user-km_bis = ls_sa-km_bis.
      ls_sp_ehb_user-zehb = ls_sa-zehb.
      ls_sp_ehb_user-sp_filter = ls_line-sp_filter.

      MOVE-CORRESPONDING ls_sp_ehb_user TO ls_signlausr.
*      ls_signlausr-zarbstl = wd_this->mo_curr_arbstelle->ms_arbeitsstelle-zarbstl.
      ls_signlausr-sperras_id = ls_sp_shicht-sperras_id.
      ls_signlausr-zschicht = ls_sp_shicht-zschicht.


      IF iv_button = 'SOUTH_ADD'.
        APPEND ls_sp_ehb_user TO lt_sp_ehb_user[].
        APPEND wd_this->mv_current_action_buttons TO wd_this->gt_popup_action_tracer[].
        APPEND ls_signlausr TO wd_this->gt_popup_user_added_signals[].
      ELSEIF iv_button = 'SOUTH_SUB'.
*        DESCRIBE TABLE  wd_this->gt_popup_action_tracer[] LINES DATA(lv_last_action).
        DATA(lv_last_action) = lines( wd_this->gt_popup_action_tracer[] ).
        DELETE wd_this->gt_popup_action_tracer[] INDEX lv_last_action.
*        DESCRIBE TABLE wd_this->gt_popup_user_added_signals[] LINES DATA(lv_last_added).
        DATA(lv_last_added) = lines( wd_this->gt_popup_user_added_signals[] ).
        DELETE wd_this->gt_popup_user_added_signals[] INDEX lv_last_added.
        IF sy-subrc = 0.
          DELETE lt_sp_ehb_user INDEX lv_offset.
        ENDIF.
      ENDIF.
  ENDCASE.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
   )->get_child_node( name = wd_this->wdctx_details
   )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered )->bind_table( new_items = lt_sp_ehb_user set_initial_elements = abap_true ).

  CLEAR : ls_signlausr, lt_sp_ehb_user[], ls_line, ls_sa_abfolge, ls_sa, ls_sp_ehb_user, lv_last_added, lv_last_action, lv_offset.
ENDMETHOD.

METHOD check_auth_erhaltungsplaner .

  AUTHORITY-CHECK OBJECT 'ZIA_2PLAN' ID 'ZIA_2ACTVT' FIELD '02'.
  IF sy-subrc = 0.
    rv_authority = abap_true.
  ENDIF.
ENDMETHOD.

METHOD check_shift_release.

  DATA lt_bapiret TYPE bapiret2_t.

  rv_has_error = abap_false.
  wd_this->mo_message_manager->reset( ).
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  DATA(lv_status) = zif_ia_2_wrkshft_status=>mc_check_shift_release.

  DATA(lo_parameters) = NEW zcl_ia_2parameters_generic(
  VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht        dref = REF #( ls_schichtdetails-object ) )
           ( name = zif_ia_2_validator=>mc_param_schicht_status dref = REF #( lv_status ) )
         ) ).

  TRY.
      zcl_ia_2lib_validation_a=>check_shift_release( lo_parameters ).
    ##NO_HANDLER   CATCH zcx_ia_2validation_error INTO DATA(lx_validation_error).
      APPEND LINES OF lx_validation_error->gt_bapiret TO lt_bapiret.
    ##NO_HANDLER   CATCH zcx_ia_2static_check INTO DATA(lx_static_validation)  ##NEEDED. "#EC EMPTY_CATCH
  ENDTRY.

  TRY.
      DATA(lo_jobpool_mmt) = zcl_ia_2jobpool_mmt=>get_instance( ).
      lo_jobpool_mmt->check_mat_fzg_assignment( io_schicht = ls_schichtdetails-object ).
    CATCH zcx_ia_2failure INTO DATA(lx_status_error).
      APPEND LINES OF lx_status_error->gt_bapiret TO lt_bapiret.
  ENDTRY.

  TRY.
      lo_jobpool_mmt->check_existence_schicht_auftr( EXPORTING io_shift = ls_schichtdetails-object CHANGING co_msg = wd_this->mo_message_manager ).
    CATCH zcx_ia_2failure INTO lx_status_error.
      APPEND LINES OF lx_status_error->gt_bapiret TO lt_bapiret.
  ENDTRY.

  TRY.
      DATA(lo_2param) = NEW zcl_se_2parameters( ).
      DATA(lv_check_active) = lo_2param->read( EXPORTING iv_application = 'ZIA_2_REAL' iv_name = 'CHECK_SR_AP' ).
      IF lv_check_active IS NOT INITIAL.
        lo_jobpool_mmt->check_serviceprodukt( EXPORTING io_shift = ls_schichtdetails-object CHANGING co_msg = wd_this->mo_message_manager ).
      ENDIF.
    CATCH zcx_ia_2failure INTO lx_status_error.
      APPEND LINES OF lx_status_error->gt_bapiret TO lt_bapiret.
  ENDTRY.

  TRY.
      lo_jobpool_mmt->check_mrcpntlocplnt( EXPORTING io_shift = ls_schichtdetails-object ).
    CATCH zcx_ia_2failure INTO lx_status_error.
      APPEND LINES OF lx_status_error->gt_bapiret TO lt_bapiret.
  ENDTRY.

  TRY.
      lo_jobpool_mmt->check_matnr_plant( EXPORTING io_shift = ls_schichtdetails-object ).
    CATCH zcx_ia_2failure INTO lx_status_error.
      APPEND LINES OF lx_status_error->gt_bapiret TO lt_bapiret.
  ENDTRY.

  IF lt_bapiret IS NOT INITIAL.
    DELETE lt_bapiret WHERE number = 550.
    MESSAGE e550(zia_2_real) INTO DATA(lv_message).
    INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message ) INTO lt_bapiret INDEX 1.
    wd_this->mo_message_manager->add_bapiret_t( lt_bapiret ).
    wd_this->mo_message_manager->display_messages( ).
    rv_has_error = abap_true.
  ENDIF.

ENDMETHOD.

METHOD config_alv_auftraege .
  DATA lt_columns         TYPE salv_wd_t_column_ref.
  ##NEEDED DATA lt_fields          TYPE salv_wd_t_field_ref.
  DATA li_column_settings TYPE REF TO if_salv_wd_column_settings.
  DATA lo_column_header   TYPE REF TO cl_salv_wd_column_header.
  DATA lo_lta             TYPE REF TO cl_salv_wd_uie_link_to_action.
  DATA lo_lta_status      TYPE REF TO cl_salv_wd_uie_link_to_action.
  DATA lo_button          TYPE REF TO cl_salv_wd_uie_button.

  FIELD-SYMBOLS: <ls_column> LIKE LINE OF lt_columns,
                 <lo_column> TYPE REF TO cl_salv_wd_column.

*--------------------------------------------------------------------------------------
* Column Settings
*--------------------------------------------------------------------------------------

  li_column_settings ?= io_alv_model.
  lt_columns = li_column_settings->get_columns( ).


  LOOP AT lt_columns ASSIGNING  <ls_column>.
    ASSIGN <ls_column>-r_column TO <lo_column>.

    IF <lo_column>->get_id( ) = 'AUFNR'.

      lo_lta = NEW #( ).
      lo_lta->set_text_fieldname( <ls_column>-id ).
      <lo_column>->set_cell_editor( lo_lta ).

    ELSEIF <lo_column>->get_id( ) = 'STATUS_ICON'.

      lo_column_header = <lo_column>->get_header( ).
      lo_column_header->set_ddic_binding_field( if_salv_wd_c_column_settings=>ddic_bind_none ).
      lo_column_header->set_text( '' ).

      lo_lta_status = NEW #( ).
      lo_lta_status->set_image_source_fieldname( 'STATUS_ICON' ).
      lo_lta_status->set_tooltip_fieldname( 'STATUS_TOOLTIP' ).
      <lo_column>->set_cell_editor( lo_lta_status ).

    ELSEIF <lo_column>->get_id( ) = 'EINPL_BUTTON'.

      lo_button = NEW #( ).
      lo_button->set_text( value = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SCHEDULE_ORDER' ) ).
      <lo_column>->set_cell_editor( lo_button ).

      lo_button->set_visible_fieldname( 'SHOW_BUTTON' ).

    ELSEIF <lo_column>->get_id( ) = 'ZZEST'.

      <lo_column>->r_header->set_text( cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/LOCKOUT_SECTIONS' ) ).
      <lo_column>->r_header->set_prop_ddic_binding_field( EXPORTING value = if_salv_wd_c_ddic_binding=>ddic_bind_none ).

      DATA(lo_lta_zzest) = NEW cl_salv_wd_uie_link_to_action( ).
      lo_lta_zzest->set_text_fieldname( <ls_column>-id ).
      <lo_column>->set_cell_editor( lo_lta_zzest ).

    ENDIF.
  ENDLOOP.

***************************************************************************************
** SET TOOLBAR ELEMENTS
***************************************************************************************

  DATA: lo_rem_button          TYPE REF TO cl_salv_wd_fe_button,
        lo_rem_funct           TYPE REF TO cl_salv_wd_function,
        lo_akt_button          TYPE REF TO cl_salv_wd_fe_button,
        lo_akt_funct           TYPE REF TO cl_salv_wd_function,
        lo_create_arbst_button TYPE REF TO cl_salv_wd_fe_button,
        lo_create_arbst_funct  TYPE REF TO cl_salv_wd_function.

  " ALV Toolbar button erzeugen und Funktion erstellen
  lo_rem_button = NEW cl_salv_wd_fe_button( ).
  lo_rem_button->set_text( value = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REMOVE_FROM_JOB_POOL' ) ).
  lo_rem_funct = io_alv_model->if_salv_wd_function_settings~create_function( id = 'BTN_REM_AUF' ).
  lo_rem_funct->set_editor( value = lo_rem_button ).
***
*** >001<  ### Start ###
***
* Check edit authority for Erhaltungsplaner
  DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
  IF ls_auth_erhaltungsplaner-auth_erhaltungsplaner IS INITIAL.
    lo_rem_funct->set_visible( cl_wd_table_column=>e_visible-none ).
  ENDIF.
***
*** >001<  ### End ###
***

  lo_akt_button = NEW cl_salv_wd_fe_button( ).
  lo_akt_button->set_text( value = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/REFRESH_JOBPOOL' ) ).
  lo_akt_funct = io_alv_model->if_salv_wd_function_settings~create_function( id = 'BTN_AKT_JOBPOOL' ).
  lo_akt_funct->set_editor( value = lo_akt_button ).

  lo_create_arbst_button = NEW cl_salv_wd_fe_button( ).
  lo_create_arbst_button->set_text( value = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/CREATE_WORKPLACE' ) ).
  lo_create_arbst_funct = io_alv_model->if_salv_wd_function_settings~create_function( id = 'BTN_ARBST_ANLEGEN' ).
  lo_create_arbst_funct->set_editor( value = lo_create_arbst_button ).


*--------------------------------------------------------------------------------------
* Field Settings
*--------------------------------------------------------------------------------------

*  li_field_settings ?= io_alv_model.
*  lt_fields = li_field_settings->get_fields( ).
*
*  LOOP AT lt_fields ASSIGNING  <ls_fields>.
*    ASSIGN <ls_fields>-r_field TO <lr_fields>.
*
*    <lr_fields>->if_salv_wd_filter~delete_filter_rules( ).
*    <lr_fields>->if_salv_wd_sort~delete_sort_rule( ).
*
*  ENDLOOP.

*--------------------------------------------------------------------------------------
* ALV Settings
*--------------------------------------------------------------------------------------

  "Header Line ausblenden
*  io_alv_model->if_salv_wd_std_functions~set_view_list_allowed( value = abap_false ).
*  io_alv_model->if_salv_wd_std_functions~set_export_allowed( value = abap_false ).
  io_alv_model->if_salv_wd_std_functions~set_pdf_allowed( value = abap_false ).
*  io_alv_model->if_salv_wd_std_functions~set_dialog_settings_allowed( value = abap_false ).

  "Tabelleneigenschaften
  io_alv_model->if_salv_wd_table_settings~set_width( value = '100%' ).
  io_alv_model->if_salv_wd_table_settings~set_visible_row_count( value = 20 ).

  io_alv_model->if_salv_wd_table_settings~set_cell_action_event_enabled( EXPORTING value = abap_true ).

ENDMETHOD.

METHOD curr_shift_set_status .
  CHECK iv_status <> zif_ia_2_wrkshft_status=>mc_initial.

  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  ls_schichtdetails-object->set_status( iv_status ).
  ls_schichtdetails-object->save( ).

  " Invalidate relevant context nodes
  DATA(li_context_node) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails ).
  li_context_node->invalidate( ).
  li_context_node = wd_this->get_date_markings_wdctx( ls_schichtdetails-zzperi ).
  li_context_node->invalidate( ).
  wd_this->invctx_ui_schicht( ).

ENDMETHOD.

METHOD drehbuch_gen_do_work .
  CHECK wd_this->mi_db_generator IS BOUND.

  wd_this->mo_pi_assist->set_status_comp( wd_this->mi_db_generator->get_status_text( ) ).
  wd_this->mo_pi_assist->set_progress_msg( wd_this->mi_db_generator->get_msg_text( ) ).
  wd_this->mo_pi_assist->set_percent_comp( wd_this->mo_pi_assist->get_percent_comp( ) + wd_this->mi_db_generator->get_step_size( ) ).
  wd_this->mi_db_generator->do_work( ).

ENDMETHOD.

METHOD drehbuch_gen_finish .
  CHECK wd_this->mi_db_generator IS BOUND.

  wd_this->mo_zip = wd_this->mi_db_generator->get_zip_file( ).

  wd_this->gv_db_gen_action_start = abap_false.
  wd_this->mo_progress_window->close( ).

ENDMETHOD.

METHOD exc_on_as_filter .

  wd_this->filter_as_jobliste( ).        "Filter AS Joblist
  wd_this->filter_as_fahrzeuge( ).       "Filter Fahrzeugelist
  wd_this->filter_as_qualifikationen( ). "Filter Qualifikationenlist
ENDMETHOD.

METHOD exc_on_chng_schicht_status .

  DATA(lv_status) = wd_this->get_string_from_curr_event( 'STEP' ).
  wd_this->set_current_event( ).
  CHECK lv_status <>  zif_ia_2_wrkshft_status=>mc_initial.

  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  wd_this->fire_chng_schicht_status_evt( io_schicht = ls_schichtdetails-object iv_status = CONV #( lv_status ) ).

ENDMETHOD.

METHOD filter_as_fahrzeuge .
  DATA ls_as_filter  TYPE wd_this->element_as_filter.
  DATA lt_fahrzeuge  TYPE wd_this->elements_fahrzeug.


  "Refresh the fahrzeuge context before filtering
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_fahrzeug )->invalidate( ).

  "Get filter context data
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
    name = wd_this->wdctx_as_filter )->get_static_attributes( IMPORTING static_attributes = ls_as_filter ).


  IF ls_as_filter-ckb_checked_schiene = abap_false.

    "Set new context data - empty table
    wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
      name = wd_this->wdctx_fahrzeug )->bind_table( new_items = lt_fahrzeuge set_initial_elements = abap_true ).

  ENDIF.

ENDMETHOD.

METHOD filter_as_jobliste.
  DATA lt_jobliste_old  TYPE wd_this->elements_jobliste.
  DATA lt_jobliste_new  TYPE wd_this->elements_jobliste.
  DATA ls_as_filter     TYPE wd_this->element_as_filter.


  "Refresh the joblist's context before filtering
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_jobliste )->invalidate( ).

  "Get joblist context data
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
    name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste_old ).

  "Get filter context data
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
    name = wd_this->wdctx_as_filter )->get_static_attributes( IMPORTING static_attributes = ls_as_filter ).

  LOOP AT lt_jobliste_old ASSIGNING FIELD-SYMBOL(<ls_jobliste_old>) WHERE object IS BOUND.

    DATA(lv_intervall)  = <ls_jobliste_old>-object->get_data( )-zintervall.
    DATA(lv_zugangsart) = <ls_jobliste_old>-object->get_data( )-zzzugangsart.

    DATA(lv_is_valid_zintervall) = COND #( WHEN ls_as_filter-ckb_checked_ri = abap_true AND lv_intervall = 'JI' THEN abap_true
   WHEN ls_as_filter-ckb_checked_ri = abap_true AND lv_intervall = 'RI' THEN abap_true

                                           WHEN ls_as_filter-ckb_checked_ts = abap_true AND lv_intervall = 'TS' THEN abap_true
                                           WHEN ls_as_filter-ckb_checked_li = abap_true AND lv_intervall = 'LI' THEN abap_true ">001< +
                                           ELSE abap_false ).

    DATA(lv_is_valid_zugangsart) = COND #( WHEN ls_as_filter-ckb_checked_schiene = abap_true AND lv_zugangsart = '1' THEN abap_true
                                           WHEN ls_as_filter-ckb_checked_strasse = abap_true AND lv_zugangsart = '2' THEN abap_true
                                           ELSE abap_false ).

    IF lv_is_valid_zintervall = abap_true AND
       lv_is_valid_zugangsart = abap_true.

      APPEND <ls_jobliste_old> TO lt_jobliste_new.

    ENDIF.

  ENDLOOP.

  "Set new context data
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_jobliste )->bind_table(
    new_items = lt_jobliste_new set_initial_elements = abap_true ).

ENDMETHOD.

METHOD filter_as_qualifikationen .
  DATA lt_sitzplatz         TYPE wd_this->elements_sitzplatz.
  DATA lt_sitzplatz_new     TYPE wd_this->elements_sitzplatz.
  DATA lt_einzelkapas       TYPE wd_this->elements_einzelkapas.
  DATA lt_einzelkapas_new   TYPE wd_this->elements_einzelkapas.
  DATA ls_as_filter         TYPE wd_this->element_as_filter.


  DATA(li_sitzplatz_ctx) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_sitzplatz ).
  DATA(li_as_filter_ctx) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_as_filter ).

  IF wd_this->mo_curr_arbstelle IS NOT BOUND.
    li_sitzplatz_ctx->bind_table( new_items = lt_sitzplatz_new set_initial_elements = abap_true ).
    RETURN.
  ENDIF.

  li_sitzplatz_ctx->invalidate( ).                                                         "Invalidate sitzplatz context data
  li_sitzplatz_ctx->get_static_attributes_table( IMPORTING table = lt_sitzplatz ).         "Get sitzplatz context data
  li_as_filter_ctx->get_static_attributes( IMPORTING static_attributes = ls_as_filter ).   "Get filtes data

  "Filter Sitzplatze
  LOOP AT lt_sitzplatz ASSIGNING FIELD-SYMBOL(<ls_sitzplatz>) WHERE object IS BOUND.
    IF <ls_sitzplatz>-object->is_frei( ) = abap_true.       "Free Sitzplatze should be always displayed
      APPEND <ls_sitzplatz> TO lt_sitzplatz_new.
      CONTINUE.
    ENDIF.

    DATA(lo_fahzeuge) = <ls_sitzplatz>-object->get_fahrzeug( ).
    CHECK lo_fahzeuge IS BOUND.
    IF lo_fahzeuge->is_basis_fz_pneu( ) = abap_false AND    "Strassenfahrzeug and Checkbox Strasse = X
       ls_as_filter-ckb_enabled_schiene = abap_true  AND
       ls_as_filter-ckb_checked_schiene = abap_false.
      CONTINUE.
    ENDIF.

    IF lo_fahzeuge->is_basis_fz_pneu( ) = abap_true AND    "Schienefahrzeug and Checkbox Schiene = X
       ls_as_filter-ckb_enabled_strasse = abap_true AND
       ls_as_filter-ckb_checked_strasse = abap_false.
      CONTINUE.
    ENDIF.
    APPEND <ls_sitzplatz> TO lt_sitzplatz_new.
  ENDLOOP.

  li_sitzplatz_ctx->bind_table( new_items = lt_sitzplatz_new set_initial_elements = abap_true ). "Bind new sitzplatz context data
  li_sitzplatz_ctx->get_child_node( name = wd_this->wdctx_einzelkapas )->invalidate( ).          "Invalidate einkapas for a new sitzplatz context

  "Filter Einzelkapazitäten
  LOOP AT li_sitzplatz_ctx->get_elements( ) ASSIGNING FIELD-SYMBOL(<li_sitzplatz_el>).
    CLEAR lt_einzelkapas_new.
    DATA(li_einzelkapas_ctx) = <li_sitzplatz_el>->get_child_node( name = wd_this->wdctx_einzelkapas ).
    li_einzelkapas_ctx->get_static_attributes_table( IMPORTING table = lt_einzelkapas ).

    LOOP AT lt_einzelkapas ASSIGNING FIELD-SYMBOL(<ls_einzelkapas>) WHERE object IS BOUND. "#EC CI_NESTED "#EC CI_STDSEQ
      DATA(lo_auftrag) = <ls_einzelkapas>-object->get_auftrag( ).
      CHECK lo_auftrag IS BOUND.
      DATA(lv_intervall)  = lo_auftrag->get_data( )-zintervall.

      IF ls_as_filter-ckb_checked_ri = abap_true AND
         lv_intervall = 'RI'.
        APPEND <ls_einzelkapas> TO lt_einzelkapas_new.
        CONTINUE.
      ENDIF.

      IF ls_as_filter-ckb_checked_ts = abap_true AND
         lv_intervall = 'TS'.
        APPEND <ls_einzelkapas> TO lt_einzelkapas_new.
        CONTINUE.
      ENDIF.
    ENDLOOP.
    li_einzelkapas_ctx->bind_table( EXPORTING new_items = lt_einzelkapas_new set_initial_elements = abap_true ).
  ENDLOOP.

ENDMETHOD.

METHOD get_button_reiloscope .

  rv_value = cl_wd_utilities=>get_otr_text_by_alias( `ZIA_2GBT_PG2/BUTTON_REILOSCOPE` ).

  CHECK io_schicht IS BOUND.

  rv_value = |{ io_schicht->get_data( )-zzperi } { rv_value }|.

ENDMETHOD.

METHOD get_categ_for_marking .
  DATA: lv_prev_status TYPE zia_2_shift_status.

*  SELECT zschicht, priok
*    FROM zia_2wrkshifts
*    INTO TABLE @DATA(lt_schicht)
*    WHERE zzperi      = @iv_perimeter
*      AND start_datum = @iv_date.

**  SELECT qmnum, priok
**      FROM qmel
**      INTO TABLE @DATA(lt_schicht)
**      WHERE qmcod      = @iv_perimeter
**        AND strmn = @iv_date AND phase <> '5'.

  DATA(lt_schicht) = wd_assist->get_qmel_data( iv_perimeter = iv_perimeter iv_date = iv_date ).


*  IF sy-subrc <> 0.
  IF lt_schicht IS INITIAL.
    rv_category = wd_this->get_categ_for_schstatus(  zif_ia_2_wrkshft_status=>mc_initial   ).
  ELSE.

    IF lines( lt_schicht ) > 1.

      CLEAR: lv_prev_status.
      DATA(lv_same_status) = abap_true.

      LOOP AT lt_schicht ASSIGNING FIELD-SYMBOL(<ls_schicht>).
        IF sy-tabix NE 1 AND
           <ls_schicht>-priok NE lv_prev_status .
          lv_same_status = abap_false.
        ENDIF.
        lv_prev_status = <ls_schicht>-priok.
      ENDLOOP.
      IF lv_same_status = abap_true AND
        ( lv_prev_status EQ zif_ia_2_wrkshft_status=>mc_disposition_released OR
          lv_prev_status EQ zif_ia_2_wrkshft_status=>mc_shift_released ).
        rv_category = get_categ_for_schstatus(
    CONV #( <ls_schicht>-priok  )
).
      ELSE.
        rv_category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_multiple_shifts ).
      ENDIF.

    ELSE.

      DATA(ls_schicht) = lt_schicht[ 1 ].
      rv_category = get_categ_for_schstatus(
     CONV #( ls_schicht-priok )
 ).
    ENDIF.
  ENDIF.
ENDMETHOD.

METHOD get_categ_for_schstatus .
*  DATA: lv_value_rgb_purple TYPE string                     VALUE   'rgb(102, 0, 204)',
*        lv_value_rgb_peach  TYPE string                     VALUE   'rgb(255, 0, 0)',
*        lv_value_rgb_blue   TYPE string                     VALUE   'rgb(0, 158, 255)',
*        lv_value_rgb_green  TYPE string                     VALUE   'rgb(0,  255, 0)',
*        lv_value_rgb_pink   TYPE string                     VALUE  'rgb( 255, 0, 255)'.
  CASE iv_status.
    WHEN zif_ia_2_wrkshft_status=>mc_initial.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-color_white.

    WHEN zif_ia_2_wrkshft_status=>mc_interval_provided.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_metal.

    WHEN zif_ia_2_wrkshft_status=>mc_plannig_started.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-criticalvalue_medium."calendar_peach.

    WHEN zif_ia_2_wrkshft_status=>mc_disposition_released.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_aqua."key_medium.


    WHEN zif_ia_2_wrkshft_status=>mc_shift_released.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-goodvalue_light."goodvalue_light.


    WHEN zif_ia_2_wrkshft_status=>mc_multiple_shifts.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_rose."calendar_yellow.

  ENDCASE.

ENDMETHOD.

METHOD get_comp_popup_to_confirm .
  DATA(li_component_usage) = wd_this->wd_cpuse_popup_to_confirm( ).

  IF NOT li_component_usage->has_active_component( ).
    li_component_usage->create_component( ).
  ENDIF.

  ri_instance = wd_this->wd_cpifc_popup_to_confirm( ).
ENDMETHOD.

METHOD get_date_markings_wdctx .
  CASE iv_perimeter.
    WHEN 'GBT'.
      ri_context_node = wd_context->get_child_node( wd_this->wdctx_date_navigator )->get_child_node( wd_this->wdctx_date_navigator_gbt )->get_child_node( wd_this->wdctx_markings_gbt ).
    WHEN 'CBT'.
      ri_context_node = wd_context->get_child_node( wd_this->wdctx_date_navigator )->get_child_node( wd_this->wdctx_date_navigator_cbt )->get_child_node( wd_this->wdctx_markings_cbt ).
  ENDCASE.
ENDMETHOD.

METHOD get_schdet_edit_mode .

  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
  rv_data = ls_schichtdetails-edit_mode.
ENDMETHOD.

METHOD get_schicht_from_event .
  DATA(ls_tabs_schichten) = VALUE wd_this->element_tabs_schichten( ).

  DATA(li_ctx_element) = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
  li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).

  ro_schicht = ls_tabs_schichten-object.
ENDMETHOD.

METHOD get_string_from_curr_event .
  CHECK wd_this->mo_curr_event IS BOUND.

  rv_value = wd_this->mo_curr_event->get_string( iv_name ).
ENDMETHOD.

METHOD init_cust_controllers .

  wd_this->mo_cc_uebersicht       = wd_this->get_cc_uebersicht_ctr( ).
  wd_this->mo_cc_schichtplan      = wd_this->get_cc_shichtplan_ctr( ).
  wd_this->mo_cc_gantt            = wd_this->get_cc_gantt_ctr( ).
  wd_this->mo_cc_main_schtab      = wd_this->get_cc_main_schtab_ctr( ).

   wd_this->mo_cc_main_schtab      = wd_this->get_cc_main_schtab_ctr( ).
  wd_this->mo_cc_schdet_fzeuge    = wd_this->get_cc_schdet_fahrzeuge_ctr( ).
  wd_this->mo_cc_schdet_qualif    = wd_this->get_cc_schdet_qualif_ctr( ).
  wd_this->mo_cc_schdet_main      = wd_this->get_cc_schdet_main_ctr( ).
  wd_this->mo_cc_schdet_jobpool   = wd_this->get_cc_schdet_jobpool_ctr( ).
  wd_this->mo_cc_schichtplan      = wd_this->get_cc_shichtplan_ctr( ).
  wd_this->mo_cc_uebersicht       = wd_this->get_cc_uebersicht_ctr( ).
  wd_this->mo_cc_schdet_tunnel    = wd_this->get_cc_schdet_tunnel_ctr( ).
  wd_this->mo_cc_gantt            = wd_this->get_cc_gantt_ctr( ).                ">001< +
  wd_this->mo_cc_schdet_mat_table = wd_this->get_cc_schdet_mat_table_ctr( ).     ">002< +
  wd_this->mo_cc_schdet_fzgref    = wd_this->get_cc_schdet_fzgref_ctr( ).

ENDMETHOD.

METHOD invctx_arbst_vis .

  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_arbst_vis )->invalidate( ).

ENDMETHOD.

METHOD invctx_as_filter .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_as_filter )->invalidate( ).

ENDMETHOD.

METHOD invctx_auftraege_alv .
  wd_context->get_child_node( wd_this->wdctx_auftraege )->get_child_node( wd_this->wdctx_auftraege_alv )->invalidate( ).

ENDMETHOD.

METHOD invctx_details .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_details )->invalidate( ).

ENDMETHOD.

METHOD invctx_fahrzeug .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_fahrzeug )->invalidate( ).

ENDMETHOD.

METHOD invctx_jobliste .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_jobliste )->invalidate( ).

ENDMETHOD.

METHOD invctx_jobpool .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_jobpool )->invalidate( ).

ENDMETHOD.

METHOD invctx_schichtdetails .
  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->invalidate( ).

ENDMETHOD.

method INVCTX_SCHICHTPLAN .
   wd_context->get_child_node( wd_this->wdctx_schichtplan )->invalidate( ).
endmethod.

METHOD invctx_sitzplatz .

  wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_sitzplatz )->invalidate( ).

ENDMETHOD.

METHOD invctx_ui_schicht .
  wd_context->get_child_node( wd_this->wdctx_ui_visibility )->get_child_node( wd_this->wdctx_ui_schicht )->invalidate( ).

ENDMETHOD.

METHOD is_curr_arbstelle_empty .

  TRY .
      rv_value = wd_this->mo_curr_arbstelle->is_empty( ).

    CATCH cx_sy_ref_is_initial.
      rv_value = abap_true.
  ENDTRY.
ENDMETHOD.

METHOD open_popup_message .
  DATA(li_api) = wd_this->wd_get_api( ).
  DATA(li_window_manager) = li_api->get_window_manager( ).

  DATA(li_popup_window) = li_window_manager->create_popup_to_confirm( button_kind  = iv_button_kind
                                                                      message_type = iv_message_type
                                                                      window_title = iv_window_title
                                                                      text         = it_text
                                                                      close_button = iv_close_button
                                                                      window_height = iv_height       ">001<  +
                                                                      window_width  = iv_width        ">001<  +
                                                                    ).

  DATA(li_view_controller) = zcl_ia_2utils_wd_a=>get_view_controller( io_view_object ).

  IF iv_btn1_type IS NOT INITIAL AND iv_btn1_action IS NOT INITIAL AND iv_btn1_text IS NOT INITIAL.
    li_popup_window->subscribe_to_button_event( button      = iv_btn1_type
                                                button_text = iv_btn1_text
                                                action_name = iv_btn1_action
                                                action_view = li_view_controller
                                              ).
  ENDIF.

  IF iv_btn2_type IS NOT INITIAL AND iv_btn2_action IS NOT INITIAL AND iv_btn2_text IS NOT INITIAL.
    li_popup_window->subscribe_to_button_event( button      = iv_btn2_type
                                                button_text = iv_btn2_text
                                                action_name = iv_btn2_action
                                                action_view = li_view_controller
                                              ).
  ENDIF.

  IF iv_btn3_type IS NOT INITIAL AND iv_btn3_action IS NOT INITIAL AND iv_btn3_text IS NOT INITIAL.
    li_popup_window->subscribe_to_button_event( button      = iv_btn3_type
                                                button_text = iv_btn3_text
                                                action_name = iv_btn3_action
                                                action_view = li_view_controller
                                              ).
  ENDIF.

  li_popup_window->open( ).

ENDMETHOD.

METHOD open_popup_message_with_params .
  DATA(li_popup_to_confirm) = wd_this->get_comp_popup_to_confirm( ).

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

METHOD open_pop_up .
  DATA: li_popup      TYPE REF TO if_wd_window,
        li_comp_api   TYPE REF TO if_wd_component,
        li_window_man TYPE REF TO if_wd_window_manager.

  " Window Manager Instanz
  li_comp_api  = wd_this->wd_get_api( ).
  li_window_man = li_comp_api->get_window_manager( ).

  li_popup = li_window_man->create_popup_to_confirm(
             text                 = it_text
             button_kind          = if_wd_window=>co_buttons_ok
             close_button         = abap_false
             window_title         = iv_window_title
         ).

  li_popup->subscribe_to_button_event( EXPORTING
    button = if_wd_window=>co_button_ok
    button_text  = iv_btn_text
    action_name  = iv_btn_action
    action_view  = wd_this->mo_view_schichtdetails
  ).

  li_popup->open( ).
ENDMETHOD.

METHOD open_progress_window .
  DATA:  ls_sp_details TYPE wd_this->element_sp_details.



* Find out Schichtdaten
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_details
           )->get_child_node( name = wd_this->wdctx_sp_details ).
  wd_context->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).

*  DATA(lo_node_sp_details) = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
*                                         )->get_child_node( name = wd_this->wdctx_details
*                                         )->get_child_node( name = wd_this->wdctx_sp_details ).

*  IF lo_node_sp_details IS BOUND AND lo_node_sp_details->get_element_count( ) > 0.
*    lo_node_sp_details->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).
*  ENDIF.

*  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
*            )->get_child_node( name = wd_this->wdctx_details
*            )->get_child_node( name = wd_this->wdctx_sp_details
*            )->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).


  CLEAR wd_this->mi_db_generator.

  DATA(lo_log) = zcl_ia_2log=>get_instance( ).

  CALL METHOD lo_log->add_info
    EXPORTING
      iv_text       = |{ 'Start script generation:' }{ ls_sp_details-start_datum }{ ls_sp_details-start_zeit(4) }|
      iv_sub_object = zcl_ia_2log=>mc_sub_object_drehbuch.

  DATA li_api_componentcontroller TYPE REF TO if_wd_component.
  li_api_componentcontroller = wd_this->wd_get_api( ).

  DATA li_window_manager    TYPE REF TO if_wd_window_manager.
  li_window_manager    = li_api_componentcontroller->get_window_manager( ).

  wd_this->mo_progress_window = li_window_manager->create_window_for_cmp_usage(
    interface_view_name  = 'W_MAIN'
    component_usage_name = 'PI_WINDOW'
    title                = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SCRPT_GENERATON' )
  ).

  wd_this->gv_db_gen_action_start = abap_true.
  wd_this->mo_progress_window->open( ).
ENDMETHOD.

METHOD open_schicht_parameters .

  DATA(ls_interface_to_param) = VALUE wd_this->element_interface_to_param( object = io_schicht ).

  ls_interface_to_param-schicht_id = ls_interface_to_param-object->get_id( ). "ls_schichtplan-zschicht.
  ls_interface_to_param-zzperi = ls_interface_to_param-object->get_data( )-zzperi. "ls_schichtplan-zzperi.
  ls_interface_to_param-read_only = COND #( WHEN ls_interface_to_param-object->is_locked( )
                                            THEN abap_false ELSE abap_true ).
  ls_interface_to_param-shift_read_only = abap_true. "dürfen nie bei Schichtparameter geändert werden nur bei Standard
  ls_interface_to_param-show_standard = abap_false.

  wd_context->get_child_node( name = wd_this->wdctx_interface_to_param
           )->get_element( )->set_static_attributes( static_attributes = ls_interface_to_param ).

  IF NOT wd_this->wd_cpuse_parameter( )->has_active_component( ).
    wd_this->wd_cpuse_parameter( )->create_component( ).
  ENDIF.

  IF ls_interface_to_param-read_only = abap_false. " Schichtparameter in Bearbeitungsmodus, müssen gelockt werden
    TRY.
        ls_interface_to_param-object->get_parameter( )->lock( ).
      CATCH zcx_ia_2failure INTO DATA(lx_fehler).
        wd_this->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
        wd_this->mo_message_manager->reset( ).
    ENDTRY.
  ENDIF.

  wd_this->wd_get_api( )->get_window_manager( )->create_window_for_cmp_usage( interface_view_name  = 'W_MAIN'
                                                                              component_usage_name = 'PARAMETER'
                                                                              title                = 'Schichtparameter' )->open( ).

ENDMETHOD.

METHOD open_schicht_tab .
  CHECK io_schicht IS BOUND.

  wd_this->reload_schicht( io_schicht ). " reload on navigation to Schichtdetails

  IF io_schicht->is_planned( ).

    "Entsperre die vorherige Schicht falls es sicht nicht um das Element handelt, welches im EditMode steht.
    DATA(lt_schichtplan) = VALUE wd_this->elements_schichtplan( ).
    wd_context->get_child_node( name = wd_this->wdctx_schichtplan  )->get_static_attributes_table( IMPORTING table = lt_schichtplan ).
    READ TABLE lt_schichtplan WITH KEY object = io_schicht edit_mode = 'X' TRANSPORTING NO FIELDS.
    IF syst-subrc NE 0.
      zcl_ia_2context_helper=>unlock_previous_schicht( ii_context = wd_context ).
      wd_this->mo_ui_element_properties->reload( ).
    ENDIF.

    zcl_ia_2context_helper=>add_schicht_tab( EXPORTING io_schicht = io_schicht
                                              CHANGING  ci_context = wd_context ).

    "UI-Visibility gemäss Objekt übernhemen.
    DATA(lv_vis_mode_as_edit) = COND #( WHEN io_schicht->is_locked( ) THEN zcl_ia_2ui_element_properties=>mc_is_not_visible ELSE zcl_ia_2ui_element_properties=>mc_is_visible ).
    wd_this->mo_ui_element_properties->set_vis_btn_as_edit( iv_data = lv_vis_mode_as_edit ).

    wd_this->mo_cc_schichtplan->set_tabs_schichten_lead_sel( io_schicht ).

    "Erste Arbeitsstelle auswählen
    wd_this->mo_curr_arbstelle = zcl_ia_2context_helper=>mark_first_arbst( EXPORTING ii_context = wd_context ).

    wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->invalidate( ).

    IF wd_this->mo_curr_arbstelle IS BOUND.
      wd_this->mo_ui_element_properties->set_vis_sp_details( iv_data = COND #( WHEN wd_this->mo_curr_arbstelle->is_btg( ) EQ abap_true THEN abap_false ELSE abap_true ) ).
    ENDIF.
    wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).

    "Hier wir das neue Tab geöffnet oder zu dem schon geöffnetem Tab navigiert
    wd_this->fire_open_tab_schicht_evt( ).

  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
           )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
ENDMETHOD.

METHOD open_window_in_popup .
  DATA(li_controller_api) = wd_this->wd_get_api( ).
  DATA(li_window_manager) = li_controller_api->get_window_manager( ).
  DATA(lt_buttons) = li_window_manager->get_buttons_okcancel( ).
  MODIFY lt_buttons FROM VALUE #( do_close = 'X' ) TRANSPORTING do_close WHERE do_close IS INITIAL.

*  wd_this->mo_current_popup
  DATA(li_popup) = li_window_manager->create_and_open_popup( window_name          = iv_window_name
                                                             title                = iv_title
                                                             message_type         = if_wd_window=>co_msg_type_none
                                                             message_display_mode = if_wd_window=>co_msg_display_mode_selected
                                                             buttons              = lt_buttons ).

*  wd_this->mo_current_popup
  li_popup->subscribe_to_button_event( button      = if_wd_window=>co_button_ok
                                       button_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIO_3/HINZUFUEGEN' )
                                       action_view = io_view_controller
                                       action_name = iv_action_name ).
ENDMETHOD.

METHOD popin_aufnr_create .

  wd_this->mo_jobpool_popin_aufnr = NEW #( iv_aufnr = iv_aufnr ).
ENDMETHOD.

METHOD popin_aufnr_get .
  CHECK wd_this->mo_jobpool_popin_aufnr IS BOUND.

  rv_value = wd_this->mo_jobpool_popin_aufnr->get_data( )-aufnr.

ENDMETHOD.

METHOD popin_aufnr_release .
  CHECK wd_this->mo_jobpool_popin_aufnr IS BOUND.

  wd_this->mo_jobpool_popin_aufnr->unlock( ).
  CLEAR wd_this->mo_jobpool_popin_aufnr.
ENDMETHOD.

METHOD reload_schicht .
  CHECK io_schicht IS BOUND.

  " 1. find ID of the current Arbeitsstelle
  TRY .
      DATA(lv_curr_arbstelle) = wd_this->mo_curr_arbstelle->get_id( ).
      IF NOT wd_this->mo_curr_arbstelle->exists( ).
        " the Arbeitsstelle does NOT exist anymore => it can't be the current one
        CLEAR lv_curr_arbstelle.
      ENDIF.
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

  " 2. reload the Schicht
  "    !!! it creates new instances of ALL its Arbeitsstellen !!!
  io_schicht->reload( ).

  " 3. set instance of the current Arbeitsstelle
  IF lv_curr_arbstelle IS INITIAL.
    " if there was no current Arbeitsstelle, take the first one
    wd_this->mo_curr_arbstelle = io_schicht->get_first_arbeitsstelle( ).
  ELSE.
    " there must be the instance with THE SAME ID as it was before !!!
    DATA(lo_arbstelle) = io_schicht->get_arbeitsstelle_by_id( lv_curr_arbstelle ).
    IF lo_arbstelle IS BOUND.
      wd_this->mo_curr_arbstelle = lo_arbstelle.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD remove_manual_signals .
  IF zcl_ia_2_sp_kilometer=>is_manual_signal_refactor_on( ) EQ abap_true.

    wd_this->mo_curr_arbstelle->refresh_manual_signals( ).

    DATA(lo_schicht) = wd_this->mo_curr_arbstelle->get_schicht( ).
    lo_schicht->reload( ).
    lo_schicht->save( ).
    lo_schicht->reload( ).

  ENDIF.
ENDMETHOD.

METHOD render_alv_auftraege .
**************************************************************************************
* DATA-Definition
**************************************************************************************
  DATA: lo_alv_model              TYPE REF TO cl_salv_wd_config_table,
        li_ref_interfacecontroller TYPE REF TO iwci_salv_wd_table,
        li_ref_cmp_usage           TYPE REF TO if_wd_component_usage.

**************************************************************************************
* CREATE ALV
**************************************************************************************
  li_ref_cmp_usage = wd_this->wd_cpuse_alv_auftraege( ).

  IF li_ref_cmp_usage->has_active_component( ) IS INITIAL.
    li_ref_cmp_usage->create_component( ).
  ENDIF.

  li_ref_interfacecontroller = wd_this->wd_cpifc_alv_auftraege( ).
  lo_alv_model = li_ref_interfacecontroller->get_model( ).

**************************************************************************************
* START DEFAULT ALV RENDERINMG
**************************************************************************************
  wd_this->config_alv_auftraege( io_alv_model = lo_alv_model ).
ENDMETHOD.

METHOD reset_schicht .
  io_schicht->reset( ).

  DATA(ls_date_nav) = VALUE wd_this->element_date_navigator( ).
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
  CASE ls_date_nav-perimeter.
    WHEN 'GBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator
               )->get_child_node( name = wd_this->wdctx_date_navigator_gbt
               )->get_child_node( name = wd_this->wdctx_markings_gbt )->invalidate( ).
    WHEN 'CBT'.
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator
               )->get_child_node( name = wd_this->wdctx_date_navigator_cbt
               )->get_child_node( name = wd_this->wdctx_markings_cbt )->invalidate( ).
  ENDCASE.

  IF io_context_element IS BOUND.
    io_context_element->get_child_node( name = wd_this->wdctx_arbstellen )->invalidate( ).
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).

ENDMETHOD.

METHOD save_shift_release .

  CLEAR rt_return.
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  DATA : lo_arbstelle_i TYPE REF TO cl_object_collection_iterator,
         lo_schicht     TYPE REF TO zcl_ia_2workshift,
 ##NEEDED        lo_shift       TYPE REF TO zcl_ia_2wrkplace.

  TYPES : BEGIN OF ts_bucket_response_early,
            mapped   TYPE RESPONSE FOR MAPPED   EARLY r_maintplanningbuckettp_2,
            failed   TYPE RESPONSE FOR FAILED   EARLY r_maintplanningbuckettp_2,
            reported TYPE RESPONSE FOR REPORTED EARLY r_maintplanningbuckettp_2,
          END OF ts_bucket_response_early,

          BEGIN OF ts_workarea_tot,
            zschicht        TYPE zia_2_workshift,
            fahrzeug_kosten TYPE zia_2_vh_cost,
          END OF ts_workarea_tot,

          BEGIN OF ts_wa_ord_tot,
            zschicht      TYPE char12, "ZIA_2_WORKSHIFT,
            wa_id         TYPE char12, "ZIA_2_ID_AS,
            wa_ord        TYPE aufnr,
            wa_count      TYPE i,
            wa_percentage TYPE zia_2_percent, "ZIA_2_AUSLASTUNG,
          END OF ts_wa_ord_tot,

          BEGIN OF ts_wa_details,
            wa_id TYPE char12,
            text  TYPE string,
          END OF ts_wa_details,


          BEGIN OF ts_admin_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            order    TYPE aufnr,
            n004_ord TYPE aufnr,
          END OF ts_admin_tot,

          BEGIN OF ts_n004_wbs,
            order   TYPE aufnr,
            zarbstl TYPE zia_2_id_wrkplace,
            wbs     TYPE ps_posid,
          END OF ts_n004_wbs,

          BEGIN OF ts_order_comp,
            aufnr       TYPE aufnr,
            start_datum TYPE zia_2_pm_ordgstrp,
            start_zeit  TYPE zia_2_co_gsuzp,
            reserv_no   TYPE rsnum,
            res_item    TYPE rspos,
            fzg_belad   TYPE char6,
          END OF ts_order_comp,

          BEGIN OF ts_wa_qual_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            wa_count TYPE i,
          END OF ts_wa_qual_tot,


          BEGIN OF ts_pb_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            wa_count TYPE i,
          END OF ts_pb_tot,

          BEGIN OF ts_total_count,
            admin_order TYPE aufnr,
            percentage  TYPE zia_2_percent,
          END OF ts_total_count,


          BEGIN OF ts_total_qual,
            admin_order TYPE aufnr,
            qual        TYPE i,
          END OF ts_total_qual,

          BEGIN OF ts_ord_qual_tot,
            wa_id    TYPE char12, "ZIA_2_ID_AS,
            n004_ord TYPE aufnr,
            qual     TYPE i,
          END OF ts_ord_qual_tot,

          BEGIN OF ts_zia_2sf_veh_seat,
            zid_fzg_platz TYPE zia_2_id_vehicle_slot,
            uname         TYPE uname,
          END OF ts_zia_2sf_veh_seat ,

          BEGIN OF ts_qual_original,
            order TYPE aufnr,
            qual  TYPE zia_2sf_veh_seat,
          END OF ts_qual_original,

          BEGIN OF ts_qual_tff,
            wa_id TYPE char12,
            qual  TYPE zia_2sf_veh_seat,
          END OF ts_qual_tff,

          BEGIN OF ts_order_revi,
            pb   TYPE eam_plngbktlabel,
            revi TYPE revni,
          END OF ts_order_revi,

          ts_action_create_bucket TYPE STRUCTURE FOR ACTION IMPORT zir_cds_c_1planningbucket\\zzplngbktadditionalactions~createbucket.






  DATA: lt_create_bucket               TYPE TABLE FOR CREATE r_maintplanningbuckettp_2,
        lt_create_scope                TYPE TABLE FOR CREATE r_maintplanningbuckettp_2\\maintplngbucketscopenametp\_maintplanningbucketscopetp,
 ##NEEDED       ls_bucket_commit_failed        TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
 ##NEEDED       ls_bucket_commit_reported      TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
 ##NEEDED       ls_admin_order_commit_failed   TYPE RESPONSE FOR FAILED LATE r_maintenanceordertp,
 ##NEEDED       ls_admin_order_commit_reported TYPE RESPONSE FOR REPORTED LATE r_maintenanceordertp,
        ls_action_information TYPE ts_action_create_bucket,
 ##NEEDED       ls_result_parameter TYPE zir_cds_d_1pbactcreatepres,
  ##NEEDED       ls_commit_failed           TYPE RESPONSE FOR FAILED   LATE r_maintplanningbuckettp_2,
  ##NEEDED       ls_commit_reported         TYPE RESPONSE FOR REPORTED LATE r_maintplanningbuckettp_2,
  ls_bucket_response         TYPE ts_bucket_response_early,
  ls_bucket_response1        TYPE ts_bucket_response_early,
  lv_planbucktdesc           TYPE eam_plngbktdesc,
  lv_planbucktdesc_n4           TYPE eam_plngbktdesc,
 ##NEEDED lv_date                    TYPE char10,
  lv_shorttext               TYPE auftext,
  lv_startdatetime           TYPE char15, "EAM_PLNGBKTSTARTDATETIME,
  lv_enddatetime             TYPE char15, "EAM_PLNGBKTENDDATETIME,
  lv_maintplanningbucketuuid TYPE sysuuid_x,
  lv_shift_aufnr             TYPE aufnr,
  lv_tot_qual                TYPE i,
  ##NEEDED       lv_qual_per                TYPE zia_2_percent,
  lt_methods                 TYPE bapi_alm_order_method_t,
  lt_header                  TYPE bapi_alm_order_headers_i_t,
  lt_operation               TYPE TABLE OF bapi_alm_order_operation,
  lt_operation_up TYPE bapi_alm_order_operation_ut,
  ##NEEDED       ls_header_up               TYPE bapi_alm_order_headers_up,
  lt_header_up               TYPE TABLE OF bapi_alm_order_headers_up,
  lt_return                  TYPE bapiret2_t,
  lv_objectkey               TYPE bapi_alm_order_method-objectkey,
  lv_objectkeyo               TYPE bapi_alm_order_method-objectkey,
  lv_tot_admin_order         TYPE i,
  lv_activity TYPE vornr,
  lv_refnum TYPE i,
  lv_n003_qual TYPE i,
  lv_tot_wa TYPE i,
  lv_steus TYPE zia_2mo_fld_value,
  lv_use04 TYPE zia_2mo_fld_value,
  lv_usr04 TYPE zia_2mo_fld_value,
 ##NEEDED ls_return1 TYPE bapiret2,
 ##NEEDED lv_maintenanceevent  TYPE revni,
 ##NEEDED lv_maintenanceplanningplant  TYPE iwerk,
 ##NEEDED lv_maintplngbucketlabel  TYPE eam_plngbktlabel,
 ##NEEDED lv_startdatetime2  TYPE eam_plngbktstartdatetime,
 ##NEEDED lv_enddatetime2  TYPE eam_plngbktenddatetime,
 ##NEEDED lv_maintenanceplanningbucket  TYPE eam_plngbckt_objnr,
          lv_len TYPE i,
          lv_uname TYPE co_pernr,
 ##NEEDED lt_arbstl_obj  TYPE STANDARD TABLE OF REF TO zcl_ia_2wrkplace,
 ##NEEDED lt_components_all TYPE bapi_alm_order_component_et.




*GET PLANNED ORDER DETAILS
  ##NEEDED DATA: lo_auftraege_i      TYPE REF TO cl_object_collection_iterator,
         ls_order            TYPE zia_2order,
         ls_order1            TYPE zia_2order,
         lo_einzelkapa       TYPE REF TO zcl_ia_2indiv_capcity,
         lo_einzelkapas_i    TYPE REF TO cl_object_collection_iterator,
         lt_zia_2sf_veh_seat TYPE STANDARD TABLE OF ts_zia_2sf_veh_seat,
         lt_zia_2sf_veh_seat_all TYPE STANDARD TABLE OF ts_zia_2sf_veh_seat,
         lt_order            TYPE STANDARD TABLE OF zia_2order,
         lt_order_original   TYPE STANDARD TABLE OF zia_2order,
         ls_order_original   TYPE zia_2order,
         lt_order_n004       TYPE STANDARD TABLE OF zia_2order,
         ls_qual             TYPE zia_2sf_veh_seat,
  ##NEEDED       lt_qual             TYPE STANDARD TABLE OF zia_2sf_veh_seat,
         lt_qual_base        TYPE STANDARD TABLE OF zia_2sf_veh_seat,
          lt_qual_original   TYPE STANDARD TABLE OF ts_qual_original,
          ls_qual_original   TYPE ts_qual_original,
          ls_qual_tff   TYPE ts_qual_tff,
          lt_qual_tff   TYPE STANDARD TABLE OF ts_qual_tff,
  ##NEEDED       lt_qual_new         TYPE STANDARD TABLE OF zia_2sf_veh_seat,
  ##NEEDED       lt_qual_n004        TYPE STANDARD TABLE OF zia_2sf_veh_seat,
         lt_zia_2order_cap_total TYPE STANDARD TABLE OF zia_2order_cap,
         ls_zia_2order_cap_total TYPE zia_2order_cap,
         ls_zia_2sf_orderstr TYPE zia_2sf_orderstr,
         lt_zia_2sf_orderstr TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstro TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstrn TYPE STANDARD TABLE OF zia_2sf_orderstr,
         ls_zia_2sf_orderstrn TYPE zia_2sf_orderstr,
         lt_zia_2sf_orderstrl TYPE STANDARD TABLE OF zia_2sf_orderstr,
         lt_zia_2sf_orderstc TYPE STANDARD TABLE OF zia_2sf_orderstr,
         ls_zia_2sf_veh_cost TYPE zia_2sf_veh_cost,
         lt_zia_2sf_veh_cost TYPE STANDARD TABLE OF zia_2sf_veh_cost,
         lt_zia_2sf_veh_costn TYPE STANDARD TABLE OF zia_2sf_veh_cost,
         lt_wa_details TYPE STANDARD TABLE OF ts_wa_details,
         ls_wa_details TYPE ts_wa_details,
         ls_workarea_tot     TYPE ts_workarea_tot,
         lt_workarea_tot     TYPE STANDARD TABLE OF ts_workarea_tot,
         ls_pb_tot TYPE ts_pb_tot,
         lt_pb_tot TYPE STANDARD TABLE OF ts_pb_tot,
         ls_wa_ord_tot       TYPE ts_wa_ord_tot,
         lt_wa_ord_tot       TYPE STANDARD TABLE OF ts_wa_ord_tot,
         ls_admin_tot TYPE ts_admin_tot,
         lt_admin_tot TYPE STANDARD TABLE OF ts_admin_tot,
         ls_wa_qual_tot TYPE ts_wa_qual_tot,
         lt_wa_qual_tot TYPE STANDARD TABLE OF ts_wa_qual_tot,
         lt_wa_ord_tot_n4       TYPE STANDARD TABLE OF ts_wa_ord_tot,
         ls_wa_ord_tot_n41       TYPE ts_wa_ord_tot,
         ls_wa_ord_tot_n42       TYPE ts_wa_ord_tot,
         ls_ord_qual_tot TYPE ts_ord_qual_tot,
         lt_ord_qual_tot TYPE STANDARD TABLE OF ts_ord_qual_tot,
         ls_ord_qual_o TYPE ts_ord_qual_tot,
         lt_ord_qual_o TYPE STANDARD TABLE OF ts_ord_qual_tot,
         lt_ord_qual TYPE STANDARD TABLE OF ts_ord_qual_tot,
 ##NEEDED        ls_total_labor      TYPE ts_total_count,
 ##NEEDED        lt_total_labor      TYPE STANDARD TABLE OF ts_total_count,
 ##NEEDED        ls_total_veh        TYPE ts_total_count,
 ##NEEDED        lt_total_veh        TYPE STANDARD TABLE OF ts_total_count,
 ##NEEDED        lt_total_vehc       TYPE STANDARD TABLE OF ts_total_count,
         ls_data TYPE bapi_alm_order_srule,
         lt_data TYPE STANDARD TABLE OF bapi_alm_order_srule,
         ls_total_qual TYPE ts_total_qual,
         lt_total_qual TYPE STANDARD TABLE OF ts_total_qual,

        ls_srule_up TYPE bapi_alm_order_srule_up,
        lt_srule_up TYPE STANDARD  TABLE OF bapi_alm_order_srule_up,
        ls_n004_wbs TYPE ts_n004_wbs,
        ls_n004_wbs_o TYPE ts_n004_wbs,
        lt_n004_wbs_o TYPE STANDARD TABLE OF ts_n004_wbs,
        lt_n004_wbs TYPE STANDARD TABLE OF ts_n004_wbs,
        lv_er_ir TYPE char2,
        lv_last TYPE char1,
        lv_revision TYPE revni,
        lt_order_revi TYPE STANDARD TABLE OF ts_order_revi,
        ls_order_revi TYPE ts_order_revi,
        lv_zdlz TYPE zia_2_proc_time,
        lt_order_comp TYPE STANDARD TABLE OF ts_order_comp,
        ls_order_comp TYPE ts_order_comp,
        lt_zia_2plperim TYPE STANDARD TABLE OF zia_2plperim,
        ls_zia_2plperim TYPE zia_2plperim,
        lv_txt1 TYPE char20,
        lv_txt2 TYPE char20,
        lv_li TYPE char2,
        lt_methods_so TYPE TABLE OF bapi_alm_order_method,
        ls_method_so  TYPE bapi_alm_order_method,
        lt_return_so  TYPE TABLE OF bapiret2,
  ##NEEDED       ls_return_so  TYPE bapiret2,
  ##NEEDED       lv_aufnr_so   TYPE aufk-aufnr, "VALUE '000001234567'. " Replace with your order number
        lt_dd TYPE STANDARD TABLE OF dd07v,
        ls_dd TYPE dd07v.

*        Getting Domain Values for text in planning bucket decription.
  CALL FUNCTION 'DD_DOMVALUES_GET'  "#EC CI_SUBRC
    EXPORTING
      domname        = 'ZIA_2_ACCESSTYP'
      text           = 'X'
      langu          = sy-langu
*     BYPASS_BUFFER  = ' '
*         IMPORTING
*     RC             =
    TABLES
      dd07v_tab      = lt_dd
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.



  DATA(lt_data_mat)       = VALUE wd_this->elements_mat_table_data( ).
  DATA ls_data_mat LIKE LINE OF lt_data_mat.
  DATA :              lo_fahrzeuge_i TYPE REF TO cl_object_collection_iterator.

  CONSTANTS : lc_planning    TYPE arbpl VALUE 'MIXCEN',
              lc_work_center TYPE eam_plngbckt_scopename VALUE 'ARBPL'.


  wd_assist->populate_veh_typ_and_cost_blck( IMPORTING et_zia_2veh_typ_rat = DATA(lt_zia_2veh_typ_rat)
                                                       et_zia_2cost_blck = DATA(lt_zia_2cost_blck)
                                                       et_zia_2veh_typ_sp = DATA(lt_zia_2veh_typ_sp)
                                                       ev_steus = lv_steus
                                                       ev_use04 = lv_use04
                                                       ev_usr04 = lv_usr04 ).


*GET WORKAREA DETAILS.
  lo_schicht = ls_schichtdetails-object.

  lo_arbstelle_i ?=  lo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    DATA(lo_arbstelle)  = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).
    DATA(lv_workarea_id) = lo_arbstelle->get_id( ).
    DATA(lv_workarea_text) = lo_arbstelle->get_kurztext( ).

*    Getting materials assigned to vehicles per workarea.
*    APPEND lo_arbstelle to lt_arbstl_obj  .
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_arb( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).
    "Append Level #2: Auftrag
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_auf( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).
    "Append Level #3: Material
    wd_this->mo_cc_schdet_mat_table->append_table_lvl_mat( EXPORTING io_arbstl = lo_arbstelle CHANGING ct_data = lt_data_mat ).

* Keeping only relevant data.
    LOOP AT lt_data_mat INTO ls_data_mat WHERE level NE 'LEVEL_3'.
      DELETE TABLE lt_data_mat FROM ls_data_mat.
      CLEAR ls_data_mat.
    ENDLOOP.

*    DATA(LS_WORKAREA_ORDERS) = LO_ARBSTELLE->GET_AUFTRAEGE( ).
    DATA(lo_wa_orders) = lo_arbstelle->get_auftraege( ).
    DATA(lo_wa_order_coll) = CAST cl_object_collection_iterator( lo_wa_orders->get_values_iterator( ) ).

    CLEAR lt_order."IF ONLY WORK AREA ORDERS ARE NEEDED
    WHILE lo_wa_order_coll->has_next( ) = abap_true.
      DATA(lo_wa_order) = CAST zcl_ia_2order( lo_wa_order_coll->get_next( ) ).
      APPEND lo_wa_order->get_data( ) TO lt_order.

    ENDWHILE.

* collecting work area id and description.
    ls_wa_details-wa_id = lv_workarea_id.
    ls_wa_details-text = lv_workarea_text.
    APPEND ls_wa_details TO lt_wa_details.
    CLEAR ls_wa_details.

*    get individual capacities per order per workarea.
    IF lt_order IS NOT INITIAL.
      wd_assist->populate_zia_2order_cap( EXPORTING it_orders = lt_order
                                          IMPORTING et_zia_2order_cap = DATA(lt_zia_2order_cap)
                                                    et_zia_2sf_veh_seat = lt_zia_2sf_veh_seat ).

      APPEND LINES OF lt_zia_2order_cap TO lt_zia_2order_cap_total.

      IF lt_zia_2sf_veh_seat_all[] IS INITIAL.

        APPEND LINES OF lt_zia_2sf_veh_seat TO lt_zia_2sf_veh_seat_all.
      ENDIF.
    ENDIF.

    LOOP AT lt_order INTO ls_order.
      APPEND ls_order TO lt_order_original.
      CLEAR ls_order.
    ENDLOOP.

*    move N004 orders to new table.
    LOOP AT lt_order INTO ls_order WHERE auart = 'N004'.
*      IF ls_order-auart = 'N004'.
      APPEND ls_order TO lt_order_n004.
      DELETE TABLE lt_order FROM ls_order." aufnr = ls_order-aufnr.
*      LOOP AT lt_zia_2order_cap INTO ls_zia_2order_cap WHERE aufnr = ls_order-aufnr.
*        ls_qualn = ls_zia_2order_cap .
*        ls_qualn-OBJID = ls_zia_2order_cap .
*
*      ENDLOOP.
*      ENDIF.
      CLEAR ls_order.
    ENDLOOP.



    " QUALIFICATION PER WORKPLACE (BOOLEAN)
    DATA(lo_fahrzeuge) = lo_arbstelle->get_fahrzeuge( ).
    lo_fahrzeuge_i ?= lo_fahrzeuge->get_values_iterator( ).

    CLEAR : lt_qual, lv_tot_qual, lt_wa_ord_tot."ONLY IF THE QALIFICATIONS PER WORK AREA
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
      DATA(li_sitzplaetze_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
      WHILE li_sitzplaetze_i->has_next( ) = abap_true.
        CLEAR ls_qual.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplaetze_i->get_next( ) ).
        DATA(lv_auslastung) = lo_sitzplatz->get_auslastung( ).
        ##NEEDED       DATA(lv_dlz_max) = lo_sitzplatz->get_dlz_max( ).
        ##NEEDED       DATA(lv_dlz) = lo_sitzplatz->get_dlz( ).
        IF lo_sitzplatz->has_quali( ) = abap_true.
*          APPEND LO_SITZPLATZ->GET_DATA( ) TO LT_QUAL.
          ls_qual = lo_sitzplatz->get_data( ).
          " temporary populating this field with workcenter text.
          ls_qual-personalmodul = lo_sitzplatz->get_quali_ktext( ).

          ls_qual-gsmr = lo_fahrzeug->get_bezeichnung( ).

*          APPEND ls_qual TO lt_qual.

          APPEND ls_qual TO lt_qual_base. "the base quality table with unique ID.

          IF ls_qual-personalmodul CS 'TFF'.
            ls_qual_tff-wa_id = lv_workarea_id.
            ls_qual_tff-qual = ls_qual.
            APPEND ls_qual_tff TO lt_qual_tff.
            CLEAR ls_qual_tff.
          ENDIF.

        ENDIF.
*        lo_einzelkapas_i ?= lo_sitzplatz->get_einzelkapas_o( )->get_values_iterator( ).
*        WHILE lo_einzelkapas_i->has_next( ) = abap_true.
*          lo_einzelkapa ?= lo_einzelkapas_i->get_next( ).
*          DATA(lv_qual_order) = lo_einzelkapa->get_auftrag( )->get_id( ).
*        ENDWHILE.
*        Replacing read statement with Loop " T04K948750
*        READ TABLE lt_zia_2order_cap INTO DATA(ls_zia_2order_cap)
*                                     WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
        LOOP AT  lt_zia_2order_cap INTO DATA(ls_zia_2order_cap)
                             WHERE zid_fzg_platz = ls_qual-zid_fzg_platz.
*          creating a new table with total qualitites.
*          APPEND ls_qual TO lt_qual_original.
          ls_qual_original-order = ls_zia_2order_cap-aufnr.
          ls_qual_original-qual = ls_qual.
          APPEND ls_qual_original TO lt_qual_original.

*         collecting quality per workarea per order
          ls_ord_qual_o-wa_id = lv_workarea_id.
          ls_ord_qual_o-n004_ord = ls_zia_2order_cap-aufnr.
          ls_ord_qual_o-qual = 1.
          COLLECT ls_ord_qual_o INTO lt_ord_qual_o.        "#EC COLLECT
          CLEAR ls_ord_qual_o.

*          segregating the duration .
          ls_qual-zdlz = ls_zia_2order_cap-zdauer.

*          IF sy-subrc = 0.
          DATA(lv_qual_order) = ls_zia_2order_cap-aufnr.
*          ENDIF.

          READ TABLE lt_order INTO ls_order WITH KEY aufnr = lv_qual_order.
          IF sy-subrc = 0 AND ls_order-auart NE 'N004' AND ls_qual IS NOT INITIAL.
            IF ls_order-zzzugangsart NE '2'.
              APPEND ls_qual TO lt_qual.
              lv_n003_qual = lv_n003_qual + 1.

*          collecting quality per workarea or per N004 order
              ls_ord_qual_tot-wa_id = lv_workarea_id.
*            ls_ord_qual_tot-n004_ord
              ls_ord_qual_tot-qual = 1.
              COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot. "#EC COLLECT
              CLEAR ls_ord_qual_tot.
            ENDIF.
            IF ls_order-zzzugangsart EQ '2'.
              APPEND ls_qual TO lt_qual_n004.
              ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
              ls_wa_ord_tot-wa_id = lv_workarea_id.
              ls_wa_ord_tot-wa_ord = lv_qual_order.
              ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

              COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot_n4. "#EC COLLECT
              CLEAR ls_wa_ord_tot.


*          collecting quality per workarea or per N004 order
              ls_ord_qual_tot-wa_id = lv_workarea_id.
              ls_ord_qual_tot-n004_ord = lv_qual_order.
              ls_ord_qual_tot-qual = 1.

              COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot. "#EC COLLECT
              CLEAR ls_ord_qual_tot.

            ENDIF.
          ENDIF.

          READ TABLE lt_order_n004 INTO ls_order WITH KEY aufnr = lv_qual_order.
          IF sy-subrc = 0 AND ls_qual IS NOT INITIAL.
            APPEND ls_qual TO lt_qual_n004.
            ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
            ls_wa_ord_tot-wa_id = lv_workarea_id.
            ls_wa_ord_tot-wa_ord = lv_qual_order.
            ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

            COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot_n4.   "#EC COLLECT
            CLEAR ls_wa_ord_tot.


*          collecting quality per workarea or per N004 order
            ls_ord_qual_tot-wa_id = lv_workarea_id.
            ls_ord_qual_tot-n004_ord = lv_qual_order.
            ls_ord_qual_tot-qual = 1.

            COLLECT ls_ord_qual_tot INTO lt_ord_qual_tot.  "#EC COLLECT
            CLEAR ls_ord_qual_tot.

          ENDIF.

*        POPOULATE PERSON PER ORDER TABLE.
          IF lv_auslastung IS NOT INITIAL.
            ls_wa_ord_tot-zschicht = ls_schichtdetails-zschicht.
            ls_wa_ord_tot-wa_id = lv_workarea_id.
            ls_wa_ord_tot-wa_ord = lv_qual_order.
            ls_wa_ord_tot-wa_count = 1.
*          ls_wa_ord_tot-wa_percentage = lv_auslastung.

            COLLECT ls_wa_ord_tot INTO lt_wa_ord_tot.      "#EC COLLECT
            lv_tot_qual = lv_tot_qual + 1.

*the below count is used to segregte total count per work area.
            ls_wa_qual_tot-wa_id = lv_workarea_id.
            ls_wa_qual_tot-wa_count = 1.
            COLLECT ls_wa_qual_tot INTO lt_wa_qual_tot.    "#EC COLLECT

            CLEAR : ls_wa_qual_tot, ls_wa_ord_tot.
          ENDIF.
          CLEAR lv_qual_order.

        ENDLOOP.
      ENDWHILE.
    ENDWHILE.

*collecting the duration for each same person
    CLEAR : ls_qual, lt_qual_new.
    LOOP AT lt_qual INTO ls_qual.
      COLLECT ls_qual INTO lt_qual_new.                    "#EC COLLECT
      CLEAR ls_qual.
    ENDLOOP.
    lt_qual[] = lt_qual_new[].

*        POPOULATE percentage PER ORDER .
    LOOP AT lt_wa_ord_tot INTO ls_wa_ord_tot.
      ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / lv_tot_qual ) * 100.
*      lv_qual_per = ls_wa_ord_tot-wa_count / lv_tot_qual .
*      ls_wa_ord_tot-wa_percentage = lv_qual_per * 100.
      MODIFY lt_wa_ord_tot FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
      CLEAR ls_wa_ord_tot.

    ENDLOOP.


    LOOP AT lt_wa_ord_tot_n4 INTO ls_wa_ord_tot.
      READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_wa_ord_tot-wa_id.
      IF sy-subrc = 0.
*      ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / lv_tot_qual ) * 100.
        ls_wa_ord_tot-wa_percentage = ( ls_wa_ord_tot-wa_count / ls_wa_qual_tot-wa_count ) * 100.

        MODIFY lt_wa_ord_tot_n4 FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
        CLEAR ls_wa_ord_tot.
      ENDIF.
*      lv_qual_per = ls_wa_ord_tot-wa_count / lv_tot_qual .
*      ls_wa_ord_tot-wa_percentage = lv_qual_per * 100.
*      MODIFY lt_wa_ord_tot_n4 FROM  ls_wa_ord_tot TRANSPORTING wa_percentage.
*      CLEAR ls_wa_ord_tot.

    ENDLOOP.



*deleting orders with similar access type.
    SORT lt_order BY zzzugangsart.
    DELETE ADJACENT DUPLICATES FROM lt_order COMPARING zzzugangsart.

    READ TABLE lt_order INTO ls_order WITH KEY zzzugangsart = '2'.
    IF sy-subrc = 0.
      APPEND ls_order TO lt_order_n004.

      DELETE TABLE lt_order FROM ls_order.
      CLEAR ls_order.
    ENDIF.

    IF lv_workarea_text IS INITIAL.
      lv_workarea_text = 'XXX'.
    ENDIF.

*    CONCATENATE 'REAL_'
*                ls_schichtdetails-zzperi
*                '_'
*                ls_schichtdetails-zschicht
*                '_'
*                lv_workarea_text(3)
*           INTO lv_planbucktdesc.

*    CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
*                ls_schichtdetails-start_datum+4(2) '.'
*                ls_schichtdetails-start_datum(4) '_'
*                ls_schichtdetails-zzperi '_'
*                lv_workarea_text '_'
*                'ER_'
*                ls_order-zzzugangsart
*                INTO lv_planbucktdesc.
*    READ TABLE lt_order INTO ls_order INDEX 1.
*    IF  sy-subrc  = 0.
*
    READ TABLE lt_dd INTO ls_dd WITH KEY domvalue_l = ls_order-zzzugangsart.
    IF sy-subrc NE 0.
      CLEAR ls_dd.
    ENDIF.

*
*    ENDIF.
"$$
"$$

    IF lv_workarea_text CA '-'.
      CLEAR : lv_txt1, lv_txt2.
      SPLIT lv_workarea_text AT '-' INTO lv_txt1 lv_txt2.
      lv_workarea_text = lv_txt1 .
    ENDIF.
    CLEAR : lv_planbucktdesc.

    CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
                ls_schichtdetails-start_datum+4(2) '.'
                ls_schichtdetails-start_datum(4) '_'
                ls_schichtdetails-start_zeit(2) '.'
                ls_schichtdetails-start_zeit+2(2) '_'
*                ls_schichtdetails-start_zeit+4(2) '_'
                ls_schichtdetails-zzperi '_'
*                ls_dd-ddtext '_'
                lv_workarea_text '_'
*                ls_wa_details-text '_'
                'ER'
                INTO lv_planbucktdesc.


    CONCATENATE ls_schichtdetails-start_datum
                ls_schichtdetails-start_zeit
           INTO lv_startdatetime.

    CONCATENATE ls_schichtdetails-end_datum
                ls_schichtdetails-end_zeit
           INTO lv_enddatetime.


*    SELECT SINGLE AUFNR
*      FROM QMEL
*      INTO LV_SHIFT_AUFNR
*      WHERE QMNUM =  LS_SCHICHTDETAILS-ZSCHICHT.
*
*    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
*      INTO @DATA(LS_AUFK)
*      FROM AUFK
*     WHERE AUFNR = @LV_SHIFT_AUFNR.

    wd_assist->populate_shift_order_details( EXPORTING iv_schicht     = ls_schichtdetails-zschicht
                                             IMPORTING ev_shift_aufnr = lv_shift_aufnr
                                                       es_aufk        = DATA(ls_aufk) ).


*    ##WARN_OK   SELECT SINGLE workcenterinternalid
*         FROM i_workcenter
*           INTO @DATA(lv_workcenterinternalid)
*             WHERE workcenter EQ @zif_ir_1pb_c=>mc_main_work_center-planning
*             AND   plant      EQ @ls_action_information-%param-planningplant.

    wd_assist->populate_workcenterinternalid( EXPORTING iv_workcenter = 'MIXCEN'"zif_ir_1pb_c=>mc_main_work_center-planning
                                                        iv_plant = ls_action_information-%param-planningplant
                                              IMPORTING ev_workcenterinternalid = DATA(lv_workcenterinternalid) ).


    IF lt_order IS NOT INITIAL. "checking if any non N004 orders exists
*      IF sy-uname = 'E564128'.
*
*        wd_assist->create_plng_bukt_maint_ord( EXPORTING is_aufk = ls_aufk
*                                                              iv_workcenterinternalid = lv_workcenterinternalid
*                                                              iv_planbucktdesc = lv_planbucktdesc
*                                                              iv_startdatetime = lv_startdatetime
*                                                              iv_enddatetime = lv_enddatetime
*                                                              it_qual = lt_qual
*                                                              iv_steus = lv_steus
*                                                   IMPORTING ev_bucket_cid = DATA(lv_bucket_cid1)
*                                                             ev_tot_admin_order = lv_tot_admin_order
*                                                             es_return = ls_return1
*                                                             es_result_maintenanceevent = lv_maintenanceevent
*                                                             es_result_maintenanceplanningp = lv_maintenanceplanningplant
*                                                             es_result_maintplngbucketlabel = lv_maintplngbucketlabel
*                                                             es_result_maintplanningbuckets = lv_startdatetime2
*                                                             es_result_maintplanningbuckete = lv_enddatetime2
*                                                             es_result_maintenanceplanningb = lv_maintenanceplanningbucket ).
*
*      ENDIF.

*    DATA(LS_ACTION_INFORMATION) = ME->GET_ACTION_INFORMATION( ).
      DATA(lv_bucket_cid)         = xco_cp=>uuid( )->value. "commented on 20.04 by E564128

      " WITH THE INSTALLATION OF NOTE 3671143 IS IT REQUIRED TO CREATE THE PLANNING BUCKET IN A DRAFT MODE TO ENSURE THE DEFAULT SCOPE ARE CREATED. THUS WE MUST CREATE THE PLANNING BUCKET IN DRAFT MODE.
      lt_create_bucket = VALUE #( ( %cid                                    = lv_bucket_cid
                                    %is_draft                               = if_abap_behv=>mk-on
                                    maintplanningbucketdescription          = lv_planbucktdesc "'TEST DESC'"LS_ACTION_INFORMATION-%PARAM-BUCKETDESCRIPTION
                                    nrofmaintplngbucketsinadvance           = 1
                                    maintplngbucketgenerationdate           = sy-datum
                                    maintplanningbuckettype                 = 'STO'"zif_ir_1pb_c=>mc_pb_type-event_based_maintenance
                                    maintenanceplanningplant                = ls_aufk-werks "'8331'"LS_ACTION_INFORMATION-%PARAM-PLANNINGPLANT
                                    maintenanceplant                        = ' ' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEPLANT
                                    maintplngbucketstartdatetime            = lv_startdatetime "'20260316110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-STARTDATEANDTIME
                                    maintplngbucketenddatetime              = lv_enddatetime "'20260318110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-ENDDATEANDTIME
                                    maintplngbucketrecurrencetype           = if_eam_mtplngbkt_const=>maintplngbcktrecurrencetype-once
                                    maintplngbcktrcrrcinterval              = 1
                                    maintenanceeventtype                    = 'NA' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE
                                    mainworkcenter                          = lc_planning
                                    adminvordworkcenterinternal             = lv_workcenterinternalid
                                    zir_1pb_veh_type_mpb                    = ' ' "LS_ACTION_INFORMATION-%PARAM-VEHICLETYPE
                                    zir_1pb_rfs_mpb                         = ' ' "LS_ACTION_INFORMATION-%PARAM-REASONFORSTAY
                                    %control-maintplanningbucketdescription = if_abap_behv=>mk-on
                                    %control-nrofmaintplngbucketsinadvance  = if_abap_behv=>mk-on
                                    %control-maintplngbucketgenerationdate  = if_abap_behv=>mk-on
                                    %control-maintplanningbuckettype        = if_abap_behv=>mk-on
                                    %control-maintenanceplanningplant       = if_abap_behv=>mk-on
                                    %control-maintenanceplant               = if_abap_behv=>mk-on
                                    %control-maintplngbucketstartdatetime   = if_abap_behv=>mk-on
                                    %control-maintplngbucketenddatetime     = if_abap_behv=>mk-on
                                    %control-maintplngbucketrecurrencetype  = if_abap_behv=>mk-on
                                    %control-maintplngbcktrcrrcinterval     = if_abap_behv=>mk-on
                                    %control-maintenanceeventtype           = if_abap_behv=>mk-on
                                    %control-mainworkcenter                 = if_abap_behv=>mk-on
                                    %control-adminvordworkcenterinternal    = if_abap_behv=>mk-on
                                    %control-zir_1pb_veh_type_mpb           = if_abap_behv=>mk-on
                                    %control-zir_1pb_rfs_mpb                = if_abap_behv=>mk-on ) ).


      lt_create_scope = VALUE #( ( %cid_ref                       = lv_bucket_cid"ls_action_information-%cid
                                   %is_draft                      = if_abap_behv=>mk-on
                                   maintplngbcktscprangefieldname = lc_work_center
                            %target  = VALUE  #( ( %cid                              = xco_cp=>uuid( )->value
                                                   %is_draft                         = if_abap_behv=>mk-on
                                                   maintplngbucketscopergsg          = 'I'
                                                   maintplngbucketscopergop          = 'EQ'
                                                   maintplngbucketscopergfr          = lc_planning
                                                   mainworkcenter                    = lc_planning
                                                   workcenterinternalid              = lv_workcenterinternalid
                                                   mainworkcenterplant               = ls_action_information-%param-planningplant
                                                   maintenanceplanningplant          = ls_action_information-%param-planningplant
                                                   maintenanceplant                  = ls_action_information-%param-maintenanceplant
                                                   %control-maintplngbucketscopergsg = if_abap_behv=>mk-on
                                                   %control-maintplngbucketscopergop = if_abap_behv=>mk-on
                                                   %control-maintplngbucketscopergfr = if_abap_behv=>mk-on
                                                   %control-mainworkcenter           = if_abap_behv=>mk-on
                                                   %control-workcenterinternalid     = if_abap_behv=>mk-on
                                                   %control-mainworkcenterplant      = if_abap_behv=>mk-on
                                                   %control-maintenanceplanningplant = if_abap_behv=>mk-on
                                                   %control-maintenanceplant         = if_abap_behv=>mk-on ) ) ) ).

*    MODIFY ENTITIES OF r_maintplanningbuckettp_2
*      ENTITY maintplanningbuckettp
*       CREATE FROM lt_create_bucket
*    MAPPED   ls_bucket_response-mapped
*    FAILED   ls_bucket_response-failed
*    REPORTED ls_bucket_response-reported.
      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
         CREATE FROM lt_create_bucket
        ENTITY maintplngbucketscopenametp
         CREATE BY \_maintplanningbucketscopetp
          FROM lt_create_scope
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.


      ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped>) ELSE UNASSIGN.
      IF <ls_mapped> IS ASSIGNED.
        lv_maintplanningbucketuuid = <ls_mapped>-maintplanningbucketuuid.
      ENDIF.

      IF <ls_mapped>                                     IS NOT ASSIGNED
      OR ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
      OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*    OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.


      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE prepare
            FROM VALUE #( ( %key-maintplanningbucketuuid = <ls_mapped>-maintplanningbucketuuid ) )
          MAPPED   ls_bucket_response-mapped
          FAILED   ls_bucket_response-failed
          REPORTED ls_bucket_response-reported.

      ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped1>) ELSE UNASSIGN.


      IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
         OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE activate
              FROM VALUE #( ( %cid                         = lv_bucket_cid
*                          %KEY-MAINTPLANNINGBUCKETUUID = <LS_MAPPED1>-MAINTPLANNINGBUCKETUUID  ) )
                              %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.

      IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
         OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
*       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = zif_ir_1pb_c=>mc_message_type-error ] ).
*      ROLLBACK ENTITIES.
        wd_assist->rollback_entities( ).
*      ME->SET_BUCKET_RESPONSE( LS_BUCKET_RESPONSE ).
        RETURN.
      ENDIF.

*    COMMIT ENTITIES
*      RESPONSE OF R_MAINTPLANNINGBUCKETTP_2
*        FAILED   LS_COMMIT_FAILED
*        REPORTED LS_COMMIT_REPORTED.

      wd_assist->commit_pb( ).

*****************  CREATE MAINTENANCE EVENT.
*    DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~createmaintenanceevent.
      DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~edit.

      ##NEEDED   DATA(lv_is_draft)           = if_abap_behv=>mk-on.



*    DATA(LV_BUCKET_UUID) = ME->GET_BUCKET_UUID( ).

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE edit
           AUTO FILL CID
            WITH VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response1-mapped
        FAILED   ls_bucket_response1-failed
        REPORTED ls_bucket_response1-reported.


      ##PRIMKEY[ENTITY]
      ASSIGN ls_bucket_response1-mapped-maintplanningbuckettp[ %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ] TO FIELD-SYMBOL(<ls_bucket>).
      IF <ls_bucket> IS ASSIGNED.

        lt_create_maintenance_event = VALUE #( ( %cid                   = lv_bucket_cid "uncommented by e564128 on 20.04.26
                                                 %key                        = <ls_bucket>-%key "<LS_MAPPED>-%KEY
                                                 %param = 'N' "uncommented by e564128 on 20.04.26
                                                 ) ). "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE ) ).

        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
*          """"" EXECUTE createmaintenanceevent
            EXECUTE edit
              FROM lt_create_maintenance_event
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.



        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE prepare
              FROM VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
            MAPPED   ls_bucket_response-mapped
            FAILED   ls_bucket_response-failed
            REPORTED ls_bucket_response-reported.


        MODIFY ENTITIES OF r_maintplanningbuckettp_2
          ENTITY maintplanningbuckettp
            EXECUTE activate
              FROM VALUE #( ( %cid                         = lv_bucket_cid
                              %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.


*      COMMIT ENTITIES.
        wd_assist->commit_entities( ).


*get the total number of planning buckets.
        ls_pb_tot-wa_id = lv_workarea_id.
        ls_pb_tot-wa_count = 1.
        COLLECT ls_pb_tot INTO lt_pb_tot.                  "#EC COLLECT

        READ ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
      ALL FIELDS WITH
*    FIELDS ( MAINTPLANNINGBUCKET ) " SPECIFY FIELDS TO READ
*    VALUE #( ( %KEY-MAINTPLANNINGBUCKETUUID = '123' ) )
        VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      RESULT DATA(lt_result)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

        DATA ls_result LIKE LINE OF lt_result.

        READ TABLE lt_result INTO ls_result WITH KEY maintplanningbucketuuid = lv_maintplanningbucketuuid.

**LS_RESULT-MAINTENANCEPLANNINGBUCKET
*LS_RESULT-MAINTPLANNINGBUCKETENDDATE

*CREATE MAINTENANCE ORDER.

        CLEAR: lt_methods,
               lt_header,
               lt_operation,
               ls_header_up,
               lt_header_up,
               lt_return,
               lv_objectkey.


        lv_objectkey = '%00000000001'.
        FREE lt_methods.

*   METHODS - ANLEGEN
        APPEND VALUE #(
          refnumber  = 1
          objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
          method     = if_eams_bo_const=>gc_bapi_ord_method-create
          objectkey  = lv_objectkey
        ) TO lt_methods.


*   POPULATE THE HEADER TABLE
        CLEAR : lv_date, lv_shorttext.
        CONCATENATE ls_schichtdetails-start_datum+6(2)
                    ls_schichtdetails-start_datum+4(2)
                    ls_schichtdetails-start_datum(4)
        INTO lv_date
        SEPARATED BY '.'.

*        CONCATENATE lv_date
*                    lv_workarea_text(3)
*                    ls_order-zzperi
*                    ls_order-zdidok
*                    ls_order-zlage
*        INTO lv_shorttext
*        SEPARATED BY '_'.

        lv_shorttext = lv_planbucktdesc." the description has to be same.

        APPEND VALUE #(
          orderid     = lv_objectkey
          order_type  = ls_aufk-auart    "'N007'
          pmacttype   = 'NAA'
          revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
          maintplant  = ls_result-maintenanceplanningplant
          planplant   = ls_result-maintenanceplanningplant
          plant       = ls_result-maintenanceplanningplant
          mn_wk_ctr   = 'CH'
*          short_text  = ls_result-maintplngbucketlabel
          short_text  = lv_shorttext
*          start_date  = ls_result-maintplanningbucketstartdate     "SEE START DATE FROM WORK AREA
          start_date  = ls_schichtdetails-start_datum     "SEE START DATE FROM Shift details
*          finish_date = ls_result-maintplanningbucketenddate     "SEE ENDDATE WORK AREA
          finish_date = ls_schichtdetails-end_datum     "SEE ENDDATE from shift details
        ) TO lt_header.


        APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up>).
        IF <ls_orderheader_up> IS ASSIGNED.
          <ls_orderheader_up>-orderid    = lv_objectkey.
          <ls_orderheader_up>-maintplant = abap_true.
          <ls_orderheader_up>-plant      = abap_true.
        ENDIF.
        UNASSIGN <ls_orderheader_up>.

*        adding TFF details in qualifications table.
        LOOP AT lt_qual_tff INTO ls_qual_tff WHERE wa_id = lv_workarea_id.
          APPEND ls_qual_tff-qual TO lt_qual.
          CLEAR ls_qual_tff .
        ENDLOOP.

        CLEAR : ls_qual, lv_activity,lv_objectkeyo, lv_refnum.
        LOOP AT lt_qual INTO ls_qual.


          READ TABLE lt_zia_2sf_veh_seat_all INTO DATA(ls_zia_2sf_veh_seat)
                                         WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
          IF sy-subrc = 0 AND ls_zia_2sf_veh_seat-uname IS NOT INITIAL  AND ls_zia_2sf_veh_seat-uname(3) NE 'EXT'.
            lv_len = strlen( ls_zia_2sf_veh_seat-uname ).
            lv_len = lv_len - 1.
            lv_uname = ls_zia_2sf_veh_seat-uname+1(lv_len).
          ELSE.
            CLEAR lv_uname.
            IF ls_qual-personalmodul = 'ER-TFF' AND ls_qual-uname IS NOT INITIAL.
              lv_len = strlen( ls_qual-uname ).
              lv_len = lv_len - 1.
              lv_uname = ls_qual-uname+1(lv_len).
            ENDIF.
          ENDIF.

          lv_refnum = lv_refnum + 1.
          lv_activity = lv_activity + 10.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_activity
            IMPORTING
              output = lv_activity.

          CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
          APPEND VALUE #(
            refnumber  = lv_refnum
            objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
            method     = if_eams_bo_const=>gc_bapi_ord_method-create
            objectkey  = lv_objectkeyo
          ) TO lt_methods.

          APPEND VALUE #(
            activity    = lv_activity   "'0010'
            control_key = lv_steus "'PM01'
            work_cntr   = ls_qual-personalmodul    "'CH'
            plant       = ls_result-maintenanceplanningplant
            description = lv_shorttext"ls_result-maintplngbucketlabel
            field_key = 'N_DIENS'
            duration_normal = ls_qual-zdlz
            pers_no = lv_uname
            usr04 = lv_usr04
            use04 = lv_use04
            constraint_type_start = '1'
            constraint_type_finish = '1'
            start_cons = ls_schichtdetails-start_datum
            strttimcon = ls_schichtdetails-start_zeit
            fin_constr = ls_schichtdetails-end_datum
            fintimcons = ls_schichtdetails-end_zeit
          ) TO lt_operation.

        ENDLOOP.

        "Fill update structure of operation
        lt_operation_up = VALUE #( ( activity = abap_true
                                     control_key = abap_true
                                     work_cntr = abap_true
                                     plant = abap_true
*                                   standard_text_key = abap_true
                                     description = abap_true
                                     field_key = abap_true
                                     duration_normal = abap_true
                                     pers_no = abap_true
                                     usr04 = abap_true
                                     use04 = abap_true
                                     constraint_type_start = abap_true
                                     constraint_type_finish = abap_true
                                     start_cons = abap_true
                                     strttimcon = abap_true
                                     fin_constr = abap_true
                                     fintimcons = abap_true
*                                   calc_key = abap_true
*                                   currency = abap_true
                                      ) ).

*  _METHODS - SAVE
        APPEND VALUE #(
          refnumber  = 1
          objecttype = space
          method     = if_eams_bo_const=>gc_bapi_ord_method-save
          objectkey  = lv_objectkey
        ) TO lt_methods.

*   CALL THE BAPI
        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
          TABLES
            it_methods      = lt_methods
            it_header       = lt_header
            it_header_up    = lt_header_up
            it_operation    = lt_operation
            it_operation_up = lt_operation_up
            return          = lt_return.

*   RÜCKGABEVERARBEITUNG
        IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          READ TABLE lt_return WITH KEY id = 'IWO_BAPI2' number = '112' INTO DATA(ls_return).

          IF sy-subrc = 0.
*      RV_NUMBER = LS_RETURN-MESSAGE_V2.   " WEGEN FÜHRENDEN NULLEN
            lv_tot_admin_order  = lv_tot_admin_order + 1.
            CLEAR sy-subrc.

*            capture all admin orders created.
            ls_admin_tot-wa_id = lv_workarea_id."LS_ORDER-ZARBSTL
            ls_admin_tot-order = ls_return-message_v2.
            APPEND ls_admin_tot TO lt_admin_tot.
            CLEAR ls_admin_tot.
          ENDIF.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

*          populate total quantity per admin order.
          ls_total_qual-admin_order = ls_return-message_v2.
          ls_total_qual-qual = lv_n003_qual.
          APPEND ls_total_qual TO lt_total_qual.
          CLEAR ls_total_qual.

          ls_admin_tot-order = ls_return-message_v2.

*Updating revision number in Admin order.
*          CLEAR ls_order1.
*          ls_order1-aufnr = ls_admin_tot-order.
*          ls_order1-auart = ls_aufk-auart.
*          wd_assist->update_revision_number( EXPORTING is_order = ls_order1
*                                                         iv_revision = ls_result-maintenanceevent ).

*shifted at the end inside loop of lt_zia_2sf_orderstr internal table.
****Updating revision number in planned orders.
***          LOOP AT lt_order INTO ls_order.
***
***            wd_assist->update_revision_number( EXPORTING is_order = ls_order
***                                                           iv_revision = ls_result-maintenanceevent ).
***          ENDLOOP.




*Call program ZIA_20001_M1
*          WAIT UP TO 2 seconds.
*shifted at the end inside loop of lt_zia_2sf_orderstr internal table.
***          wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).
***
***          wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_admin_tot-order
***                                                            iv_phase = '07'
***                                                            iv_subphase = '0065' ).
          CLEAR ls_admin_tot-order.

        ENDIF.
      ENDIF.
*      Adding Planning Bucket details
      ls_order_revi-pb = ls_result-maintenanceplanningbucket.
      ls_order_revi-revi = ls_result-maintenanceevent.
      APPEND ls_order_revi TO lt_order_revi.
      CLEAR ls_order_revi.


    ENDIF. "checking if any non N004 orders exists
*GET VEHICLE DETAILS.

    lo_fahrzeuge_i     ?=  lo_arbstelle->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
*        CHECK ABAP_FALSE  = LO_FAHRZEUG->IS_BASIS_FZ_PNEU( ).       "CHECK ONLY SCHIENE
      IF lv_workarea_text CS 'RAIL' OR lv_workarea_text CS 'SCHIENE' OR lv_workarea_text CS 'ROTAIA' .
***
*      DATA(LS_VEHICLE_DATA) = LO_ARBSTELLE->GET_DATA( ).
        DATA(ls_vehicle_data) = lo_fahrzeug->get_data( ).
*      DATA(LS_VEHICLE_TYPE) = LO_ARBSTELLE->GET_ID( ).
        DATA(lv_vehicle_type) = lo_fahrzeug->get_id( ) ##NEEDED.




*      POPULATE TABLE ZIA_2SF_VEH_COST
        ls_zia_2sf_veh_cost-mandt = sy-mandt. "MANDT
        ls_zia_2sf_veh_cost-zschicht = ls_schichtdetails-zschicht. "SHIFT ID
        ls_zia_2sf_veh_cost-schicht_auftrag = lv_shift_aufnr. "SHIFT ORDER
        ls_zia_2sf_veh_cost-arbeitstellen_id = lv_workarea_id. "WORK AREA ID
        ls_zia_2sf_veh_cost-etap_aufnr = ls_return-message_v2. "STAGE ORDER
        ls_zia_2sf_veh_cost-zid_fzg = ls_vehicle_data-zid_fzg. "VEHICLE ID
        ls_zia_2sf_veh_cost-zid_fztyp = ls_vehicle_data-zid_fztyp. "  ID FOR THE VEHICLE TYPE

        READ TABLE lt_zia_2veh_typ_rat INTO DATA(ls_zia_2veh_typ_rat)
                      WITH KEY zid_fztyp = ls_vehicle_data-zid_fztyp.
        IF sy-subrc = 0.
          ls_zia_2sf_veh_cost-fahrzeug_kosten = ls_zia_2veh_typ_rat-zfahrzeugtarif."VEHICLE COSTS

        ENDIF.
        ##NEEDED         READ TABLE lt_zia_2veh_typ_sp INTO DATA(ls_zia_2veh_typ_sp)
                               WITH KEY zzperi = ls_schichtdetails-zzperi
                                        zid_fztyp = ls_zia_2sf_veh_cost-zid_fztyp.
        IF sy-subrc = 0.
          IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
            ls_zia_2sf_veh_cost-er_ir = 'ER'. "ER/ IR default for now.
          ENDIF.

          IF ls_order-auart = 'N004' .
            ls_zia_2sf_veh_cost-er_ir = 'IR'. "ER/ IR
          ENDIF.
          READ TABLE lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck1)
                    WITH KEY jahr = sy-datum(4)
                             perimeter = ls_schichtdetails-zzperi.
*                               kategorie = 'Vehicles'.
          IF sy-subrc = 0.

            ls_zia_2sf_veh_cost-spez_fzg_kstenblck = ls_zia_2cost_blck1-aufnr.

          ENDIF.
        ENDIF.

        APPEND ls_zia_2sf_veh_cost TO lt_zia_2sf_veh_cost.

        MOVE-CORRESPONDING ls_zia_2sf_veh_cost TO ls_workarea_tot.
        COLLECT ls_workarea_tot INTO lt_workarea_tot.      "#EC COLLECT


        CLEAR: ls_zia_2sf_veh_cost, ls_workarea_tot.

      ENDIF.

***
    ENDWHILE.

*        POPOULATE ZIA_2SF_ORDERSTR INCLUING THE PLANNED ORDERS.
*    IF lt_order IS NOT INITIAL.

    LOOP AT lt_order INTO ls_order.

      ls_zia_2sf_orderstr-mandt = sy-mandt."MANDT
      ls_zia_2sf_orderstr-zschicht = ls_schichtdetails-zschicht."LS_ORDER-ZSCHICHT. "SHIFT ID
      ls_zia_2sf_orderstr-schicht_auftrag = lv_shift_aufnr."LS_ORDER-AUFNR. "SHIFT ORDER
      ls_zia_2sf_orderstr-arbeitstellen_id = lv_workarea_id."LS_ORDER-ZARBSTL. "WORK AREA ID
      ls_zia_2sf_orderstr-maintplngbucketlabel = ls_result-maintenanceplanningbucket."lv_planbucktdesc. "MAINTENANCE PLANNING BUCKET LABEL.
      ls_zia_2sf_orderstr-etap_aufnr = ls_return-message_v2. " STAGE ORDER ( ADMIN ORDER )
      ls_zia_2sf_orderstr-aufnr = ls_order-aufnr. "PLANNED ORDERS

      IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
        ls_zia_2sf_orderstr-er_ir = 'ER'. "ER/ IR
      ENDIF.

      IF ls_order-auart = 'N004' .
        ls_zia_2sf_orderstr-er_ir = 'IR'. "ER/ IR
      ENDIF.
      LOOP AT lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck) "#EC CI_NESTED "#EC CI_STDSEQ
                  WHERE jahr = sy-datum(4)
                    AND perimeter = ls_order-zzperi.
        TRANSLATE ls_zia_2cost_blck TO UPPER CASE.  "#EC DEPRECATED_KEY
        IF ls_zia_2cost_blck-kategorie = 'PERSONAL'.
          ls_zia_2sf_orderstr-kostenblock = ls_zia_2cost_blck-aufnr. " COST BLOCK PERSONAL
        ENDIF.
        IF ls_zia_2cost_blck-kategorie = 'VEHICLES'.
          ls_zia_2sf_orderstr-kostenblock_vehicle = ls_zia_2cost_blck-aufnr. " COST BLOCK PERSONAL
        ENDIF.

      ENDLOOP.

*      ##WARN_OK           READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot "#EC CI_STDSEQ
      ##WARN_OK           READ TABLE lt_ord_qual_o INTO ls_ord_qual_o "#EC CI_STDSEQ
          WITH KEY "zschicht = ls_zia_2sf_orderstr-zschicht
                   wa_id = ls_zia_2sf_orderstr-arbeitstellen_id
                   n004_ord = ls_zia_2sf_orderstr-aufnr.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-anzahl_qual = ls_ord_qual_o-qual.
*          ls_zia_2sf_orderstr-percentage =  ls_wa_ord_tot-wa_percentage.
        ##WARN_OK         READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
        IF sy-subrc = 0.
          ls_zia_2sf_orderstr-percentage = ( ls_zia_2sf_orderstr-anzahl_qual / ls_wa_qual_tot-wa_count ) * 100 .
        ENDIF.
      ENDIF.
      ls_zia_2sf_orderstr-accesstype = ls_order-zzzugangsart. " access type.
*  LS_ZIA_2SF_ORDERSTR- = LS_ORDER-. "
      APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstr.
      CLEAR : ls_zia_2sf_orderstr .", ls_order.

*populate revision number using maintenace event.

*Get Order details

      IF ls_order = '1'.

        wd_assist->populate_revision_number( EXPORTING is_order = ls_order
                                                       iv_revision = ls_result-maintenanceevent ).

      ENDIF.

*CHANGE MAINTENANCE ORDER.

      CLEAR: lt_methods,
             lt_header,
             lt_operation,
             ls_header_up,
             lt_header_up,
             lt_return,
             lv_objectkey.


      lv_objectkey = ls_order-aufnr.
      FREE lt_methods.

*   METHODS - ANLEGEN
      APPEND VALUE #(
        refnumber  = 1
        objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
        method     = if_eams_bo_const=>gc_bapi_ord_method-change
        objectkey  = lv_objectkey
      ) TO lt_methods.

*   VORGANG HINZUFÜGEN
*            APPEND VALUE #(
*              refnumber  = 1
*              objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
*              method     = if_eams_bo_const=>gc_bapi_ord_method-change
*              objectkey  = lv_objectkey
*            ) TO lt_methods.
*   POPULATE THE HEADER TABLE
      APPEND VALUE #(
        orderid     = lv_objectkey
        order_type  = ls_order-auart
        revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
      ) TO lt_header.


      APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up1>).
      IF <ls_orderheader_up1> IS ASSIGNED.
        <ls_orderheader_up1>-orderid    = lv_objectkey.
        <ls_orderheader_up1>-revision = abap_true.
*              <ls_orderheader_up1>-plant      = abap_true.
      ENDIF.
      UNASSIGN <ls_orderheader_up1>.


*  _METHODS - SAVE
      APPEND VALUE #(
        refnumber  = 1
        objecttype = space
        method     = if_eams_bo_const=>gc_bapi_ord_method-save
        objectkey  = lv_objectkey
      ) TO lt_methods.

*   CALL THE BAPI
      CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
        TABLES
          it_methods   = lt_methods
          it_header    = lt_header
          it_header_up = lt_header_up
*         it_operation = lt_operation
          return       = lt_return.
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.

    ENDLOOP.



  ENDWHILE.

*          POPOULATE % VALUE IN THE TABLE LT_ZIA_2SF_VEH_COST
*  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
*    READ TABLE lt_workarea_tot INTO ls_workarea_tot      "#EC CI_STDSEQ
*            WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
**                     SCHICHT_AUFTRAG = LS_ZIA_2SF_VEH_COST-SCHICHT_AUFTRAG
**                     ARBEITSTELLEN_ID = LS_ZIA_2SF_VEH_COST-ARBEITSTELLEN_ID
**                     ETAP_AUFNR = LS_ZIA_2SF_VEH_COST-ETAP_AUFNR.
*    IF sy-subrc = 0.
*      ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten ) * 100.
*    ENDIF.
*    MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
*    CLEAR : ls_zia_2sf_veh_cost, ls_workarea_tot.
*  ENDLOOP.

*  MODIFY zia_2sf_veh_cost FROM TABLE lt_zia_2sf_veh_cost.
*  MODIFY zia_2sf_orderstr FROM TABLE lt_zia_2sf_orderstr.

*shifting at the end. 12/05/2026.
*  wd_assist->modify_settlement_tables( EXPORTING it_zia_2sf_orderstr = lt_zia_2sf_orderstr
*                                                 it_zia_2sf_veh_cost = lt_zia_2sf_veh_cost ).


*deleteing orders with same WBS.
  DATA : ls_header1 TYPE bapi_alm_order_header_e,
         lt_srules1 TYPE STANDARD TABLE OF bapi_alm_order_srule_e,
         ls_srules1 TYPE bapi_alm_order_srule_e,
         lt_ret     TYPE STANDARD TABLE OF bapiret2.

  LOOP AT lt_order_n004 INTO ls_order.
    ls_n004_wbs-order = ls_order-aufnr.
    ls_n004_wbs-zarbstl = ls_order-zarbstl.

    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number    = ls_order-aufnr
      IMPORTING
        es_header = ls_header1
      TABLES
        et_srules = lt_srules1
        return    = lt_ret.

    IF ls_header1-order_type = 'N004'.
      READ TABLE lt_srules1 INTO ls_srules1 INDEX 1.
      IF sy-subrc = 0.
        ls_n004_wbs-wbs = ls_srules1-wbs_element.
      ELSE.
        ls_n004_wbs-wbs = ls_order-aufnr."this is done so that n003 orders of access type 2 are not deleted.
      ENDIF.
    ENDIF.
    APPEND ls_n004_wbs TO lt_n004_wbs.
    CLEAR : ls_order, ls_n004_wbs.
  ENDLOOP.
  lt_n004_wbs_o[] = lt_n004_wbs[]. " just keeping this table to use it for reading later.
  SORT lt_n004_wbs BY wbs.
  DELETE ADJACENT DUPLICATES FROM lt_n004_wbs COMPARING zarbstl wbs.


  LOOP AT lt_order_n004 INTO ls_order.

    READ TABLE lt_n004_wbs INTO ls_n004_wbs WITH KEY order = ls_order-aufnr.
    IF sy-subrc NE 0.
      CONTINUE. " here it will skip the below code if the record is not found.
    ENDIF.
    ##WARN_OK
    READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order-zarbstl.

*    CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
*                ls_schichtdetails-start_datum+4(2) '.'
*                ls_schichtdetails-start_datum(4) '_'
*                ls_schichtdetails-zzperi '_'
*                ls_wa_details-text '_'
*                'IR_'
*                ls_order-zzzugangsart '_'
*                ls_n004_wbs-wbs
*                INTO lv_planbucktdesc_n4.

    READ TABLE lt_dd INTO ls_dd WITH KEY domvalue_l = ls_order-zzzugangsart.
    IF sy-subrc NE 0.
      CLEAR ls_dd.
    ENDIF.


    READ TABLE lt_qual_original INTO ls_qual_original WITH KEY order = ls_order-aufnr.
    IF ls_qual_original-qual-gsmr CA '.'.
      CLEAR : lv_txt1, lv_txt2.
      SPLIT ls_qual_original-qual-gsmr  AT '.' INTO lv_txt1 lv_txt2.
      ls_qual_original-qual-gsmr  = lv_txt1 .
    ENDIF.


    CLEAR : lv_planbucktdesc.
    IF ls_wa_details-text CA '-'.
      CLEAR : lv_txt1, lv_txt2.
      SPLIT ls_wa_details-text AT '-' INTO lv_txt1 lv_txt2.
      ls_wa_details-text = lv_txt1 .
    ENDIF.


    IF ls_order-auart NE 'N004'.

      CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
                  ls_schichtdetails-start_datum+4(2) '.'
                  ls_schichtdetails-start_datum(4) '_'
                  ls_schichtdetails-start_zeit(2) '.'
                  ls_schichtdetails-start_zeit+2(2) '_'
*                  ls_schichtdetails-start_zeit+4(2) '_'
                  ls_schichtdetails-zzperi '_'
                  ls_qual_original-qual-gsmr '('
                  ls_dd-ddtext ')_'
*                  ls_wa_details-text '_'
                  'ER'
                  INTO lv_planbucktdesc_n4.

    ELSE.

      CONCATENATE ls_schichtdetails-start_datum+6(2) '.'
                  ls_schichtdetails-start_datum+4(2) '.'
                  ls_schichtdetails-start_datum(4) '_'
                  ls_schichtdetails-start_zeit(2) '.'
                  ls_schichtdetails-start_zeit+2(2) '_'
*                  ls_schichtdetails-start_zeit+4(2) '_'
                  ls_schichtdetails-zzperi '_'
                  ls_qual_original-qual-gsmr '('
                  ls_dd-ddtext ')_'
*                  ls_wa_details-text '_'
                  'IR'
                  INTO lv_planbucktdesc_n4.

    ENDIF.

*    DATA(lv_bucket_cid)         = xco_cp=>uuid( )->value.
    lv_bucket_cid         = xco_cp=>uuid( )->value.
    lt_create_bucket = VALUE #( ( %cid                                    = lv_bucket_cid
                                 %is_draft                               = if_abap_behv=>mk-on
                                 maintplanningbucketdescription          = lv_planbucktdesc_n4 "'TEST DESC'"LS_ACTION_INFORMATION-%PARAM-BUCKETDESCRIPTION
                                 nrofmaintplngbucketsinadvance           = 1
                                 maintplngbucketgenerationdate           = sy-datum
                                 maintplanningbuckettype                 = 'STO'"zif_ir_1pb_c=>mc_pb_type-event_based_maintenance
                                 maintenanceplanningplant                = ls_aufk-werks "'8331'"LS_ACTION_INFORMATION-%PARAM-PLANNINGPLANT
                                 maintenanceplant                        = ' ' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEPLANT
                                 maintplngbucketstartdatetime            = lv_startdatetime "'20260316110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-STARTDATEANDTIME
                                 maintplngbucketenddatetime              = lv_enddatetime "'20260318110056' "SY-DATUM "LS_ACTION_INFORMATION-%PARAM-ENDDATEANDTIME
                                 maintplngbucketrecurrencetype           = if_eam_mtplngbkt_const=>maintplngbcktrecurrencetype-once
                                 maintplngbcktrcrrcinterval              = 1
                                 maintenanceeventtype                    = 'NA' "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE
                                 mainworkcenter                          = lc_planning
                                 adminvordworkcenterinternal             = lv_workcenterinternalid
                                 zir_1pb_veh_type_mpb                    = ' ' "LS_ACTION_INFORMATION-%PARAM-VEHICLETYPE
                                 zir_1pb_rfs_mpb                         = ' ' "LS_ACTION_INFORMATION-%PARAM-REASONFORSTAY
                                 %control-maintplanningbucketdescription = if_abap_behv=>mk-on
                                 %control-nrofmaintplngbucketsinadvance  = if_abap_behv=>mk-on
                                 %control-maintplngbucketgenerationdate  = if_abap_behv=>mk-on
                                 %control-maintplanningbuckettype        = if_abap_behv=>mk-on
                                 %control-maintenanceplanningplant       = if_abap_behv=>mk-on
                                 %control-maintenanceplant               = if_abap_behv=>mk-on
                                 %control-maintplngbucketstartdatetime   = if_abap_behv=>mk-on
                                 %control-maintplngbucketenddatetime     = if_abap_behv=>mk-on
                                 %control-maintplngbucketrecurrencetype  = if_abap_behv=>mk-on
                                 %control-maintplngbcktrcrrcinterval     = if_abap_behv=>mk-on
                                 %control-maintenanceeventtype           = if_abap_behv=>mk-on
                                 %control-mainworkcenter                 = if_abap_behv=>mk-on
                                 %control-adminvordworkcenterinternal    = if_abap_behv=>mk-on
                                 %control-zir_1pb_veh_type_mpb           = if_abap_behv=>mk-on
                                 %control-zir_1pb_rfs_mpb                = if_abap_behv=>mk-on ) ).


    lt_create_scope = VALUE #( ( %cid_ref                       = lv_bucket_cid"ls_action_information-%cid
                                 %is_draft                      = if_abap_behv=>mk-on
                                 maintplngbcktscprangefieldname = lc_work_center
                          %target  = VALUE  #( ( %cid                              = xco_cp=>uuid( )->value
                                                 %is_draft                         = if_abap_behv=>mk-on
                                                 maintplngbucketscopergsg          = 'I'
                                                 maintplngbucketscopergop          = 'EQ'
                                                 maintplngbucketscopergfr          = lc_planning
                                                 mainworkcenter                    = lc_planning
                                                 workcenterinternalid              = lv_workcenterinternalid
                                                 mainworkcenterplant               = ls_action_information-%param-planningplant
                                                 maintenanceplanningplant          = ls_action_information-%param-planningplant
                                                 maintenanceplant                  = ls_action_information-%param-maintenanceplant
                                                 %control-maintplngbucketscopergsg = if_abap_behv=>mk-on
                                                 %control-maintplngbucketscopergop = if_abap_behv=>mk-on
                                                 %control-maintplngbucketscopergfr = if_abap_behv=>mk-on
                                                 %control-mainworkcenter           = if_abap_behv=>mk-on
                                                 %control-workcenterinternalid     = if_abap_behv=>mk-on
                                                 %control-mainworkcenterplant      = if_abap_behv=>mk-on
                                                 %control-maintenanceplanningplant = if_abap_behv=>mk-on
                                                 %control-maintenanceplant         = if_abap_behv=>mk-on ) ) ) ).

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
       CREATE FROM lt_create_bucket
      ENTITY maintplngbucketscopenametp
       CREATE BY \_maintplanningbucketscopetp
        FROM lt_create_scope
    MAPPED   ls_bucket_response-mapped
    FAILED   ls_bucket_response-failed
    REPORTED ls_bucket_response-reported.


    ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped_n4>) ELSE UNASSIGN.
    IF <ls_mapped_n4> IS ASSIGNED.
      lv_maintplanningbucketuuid = <ls_mapped_n4>-maintplanningbucketuuid.
    ENDIF.

    IF <ls_mapped_n4>                                     IS NOT ASSIGNED
    OR ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
    OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.


    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
        EXECUTE prepare
          FROM VALUE #( ( %key-maintplanningbucketuuid = <ls_mapped_n4>-maintplanningbucketuuid ) )
        MAPPED   ls_bucket_response-mapped
        FAILED   ls_bucket_response-failed
        REPORTED ls_bucket_response-reported.

    ASSIGN ls_bucket_response-mapped-maintplanningbuckettp[ 1 ] TO FIELD-SYMBOL(<ls_mapped1_n4>) ELSE UNASSIGN.


    IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE activate
            FROM VALUE #( ( %cid                         = lv_bucket_cid
                            %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.

    IF ls_bucket_response-failed-maintplanningbuckettp IS NOT INITIAL
       OR line_exists( ls_bucket_response-reported-maintplanningbuckettp[ %msg->if_t100_dyn_msg~msgty = 'E' ] ).
      wd_assist->rollback_entities( ).
      RETURN.
    ENDIF.

    wd_assist->commit_pb( ).


*get the total number of planning buckets.
    ls_pb_tot-wa_id = ls_order-zarbstl.
    ls_pb_tot-wa_count = 1.
    COLLECT ls_pb_tot INTO lt_pb_tot.                      "#EC COLLECT

*****************  CREATE MAINTENANCE EVENT.
*    DATA lt_create_maintenance_event TYPE TABLE FOR ACTION IMPORT r_maintplanningbuckettp_2\\maintplanningbuckettp~edit.
*    ##NEEDED   DATA(lv_is_draft)           = if_abap_behv=>mk-on.

    MODIFY ENTITIES OF r_maintplanningbuckettp_2
      ENTITY maintplanningbuckettp
        EXECUTE edit
         AUTO FILL CID
          WITH VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response1-mapped
      FAILED   ls_bucket_response1-failed
      REPORTED ls_bucket_response1-reported.

    ##PRIMKEY[ENTITY]
    ASSIGN ls_bucket_response1-mapped-maintplanningbuckettp[ %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ] TO FIELD-SYMBOL(<ls_bucket_n4>).
    IF <ls_bucket_n4> IS ASSIGNED.

      lt_create_maintenance_event = VALUE #( ( %cid                   = lv_bucket_cid "uncommented by e564128 on 20.04.26
                                               %key                        = <ls_bucket_n4>-%key "<LS_MAPPED>-%KEY
                                               %param = 'N' "uncommented by e564128 on 20.04.26
                                               ) ). "LS_ACTION_INFORMATION-%PARAM-MAINTENANCEEVENTTYPE ) ).

      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
*          """"" EXECUTE createmaintenanceevent
          EXECUTE edit
            FROM lt_create_maintenance_event
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.



      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE prepare
            FROM VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
          MAPPED   ls_bucket_response-mapped
          FAILED   ls_bucket_response-failed
          REPORTED ls_bucket_response-reported.


      MODIFY ENTITIES OF r_maintplanningbuckettp_2
        ENTITY maintplanningbuckettp
          EXECUTE activate
            FROM VALUE #( ( %cid                         = lv_bucket_cid
                            %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
      MAPPED   ls_bucket_response-mapped
      FAILED   ls_bucket_response-failed
      REPORTED ls_bucket_response-reported.


*      COMMIT ENTITIES.
      wd_assist->commit_entities( ).

      READ ENTITIES OF r_maintplanningbuckettp_2
    ENTITY maintplanningbuckettp
    ALL FIELDS WITH
      VALUE #( ( %key-maintplanningbucketuuid = lv_maintplanningbucketuuid ) )
    RESULT DATA(lt_result_n4)
    FAILED DATA(ls_failed_n4)
    REPORTED DATA(ls_reported_n4).

*      DATA ls_result LIKE LINE OF lt_result.

      READ TABLE lt_result_n4 INTO ls_result WITH KEY maintplanningbucketuuid = lv_maintplanningbucketuuid.

*CREATE MAINTENANCE ORDER.

      CLEAR: lt_methods,
             lt_header,
             lt_operation,
             ls_header_up,
             lt_header_up,
             lt_return,
             lv_objectkey.


      lv_objectkey = '%00000000001'.
      FREE lt_methods.

*   METHODS - ANLEGEN
      APPEND VALUE #(
        refnumber  = 1
        objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-header
        method     = if_eams_bo_const=>gc_bapi_ord_method-create
        objectkey  = lv_objectkey
      ) TO lt_methods.


*   POPULATE THE HEADER TABLE
      CLEAR : lv_date, lv_shorttext.
      CONCATENATE ls_schichtdetails-start_datum+6(2)
                  ls_schichtdetails-start_datum+4(2)
                  ls_schichtdetails-start_datum(4)
      INTO lv_date
      SEPARATED BY '.'.

*      CONCATENATE lv_date
*                  lv_workarea_text(3)
*                  ls_order-zzperi
*                  ls_order-zdidok
*                  ls_order-zlage
*      INTO lv_shorttext
*      SEPARATED BY '_'.


      lv_shorttext = lv_planbucktdesc_n4." the description has to be same.

      APPEND VALUE #(
        orderid     = lv_objectkey
        order_type  = ls_aufk-auart    "'N007'
        pmacttype   = 'NAA'
        revision    = ls_result-maintenanceevent  "SEE PLANNING BUCKET
        maintplant  = ls_result-maintenanceplanningplant
        planplant   = ls_result-maintenanceplanningplant
        plant       = ls_result-maintenanceplanningplant
        mn_wk_ctr   = 'CH'
*        short_text  = ls_result-maintplngbucketlabel
        short_text  = lv_shorttext
*          start_date  = ls_result-maintplanningbucketstartdate     "SEE START DATE FROM WORK AREA
          start_date  = ls_schichtdetails-start_datum     "SEE START DATE FROM Shift details
*          finish_date = ls_result-maintplanningbucketenddate     "SEE ENDDATE WORK AREA
          finish_date = ls_schichtdetails-end_datum     "SEE ENDDATE from shift details
      ) TO lt_header.


      APPEND INITIAL LINE TO lt_header_up[] ASSIGNING FIELD-SYMBOL(<ls_orderheader_up_n4>).
      IF <ls_orderheader_up_n4> IS ASSIGNED.
        <ls_orderheader_up_n4>-orderid    = lv_objectkey.
        <ls_orderheader_up_n4>-maintplant = abap_true.
        <ls_orderheader_up_n4>-plant      = abap_true.
      ENDIF.
      UNASSIGN <ls_orderheader_up_n4>.

      CLEAR : ls_qual, lv_activity,lv_objectkeyo, lv_refnum.
*      LOOP AT lt_qual_n004 INTO ls_qual.                 "#EC CI_NESTED
*      LOOP AT lt_qual_original INTO ls_qual_original WHERE order = ls_order-aufnr. "#EC CI_NESTED "New for all entries in qualities table.
      LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_order-aufnr. "#EC CI_NESTED "New for all entries in qualities table.
*        ls_qual = ls_qual_original-qual.
*        The below check is done to ensure that only this particular orders qualities are added.
*        READ TABLE lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
*        IF ls_zia_2order_cap_total-aufnr = ls_order-aufnr.
*        LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE zid_fzg_platz = ls_qual-zid_fzg_platz
*                                                                       AND aufnr = ls_order-aufnr.

*      Below code is written to get the total duration per employee
        IF ls_order-auart = 'N003'.
          CLEAR : ls_wa_ord_tot_n41,ls_wa_ord_tot_n42, lv_zdlz.
          LOOP AT lt_order_original INTO ls_order_original WHERE auart = ls_order-auart
                                                             AND zzzugangsart = ls_order-zzzugangsart. "#EC CI_NESTED
            READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot_n41 WITH KEY wa_ord = ls_order_original-aufnr.

            LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_order_original-aufnr
                                                                           AND zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz. "#EC CI_NESTED
              READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot_n42 WITH KEY wa_ord = ls_zia_2order_cap_total-aufnr.

              IF ls_wa_ord_tot_n41-wa_id = ls_wa_ord_tot_n42-wa_id. "this is to check if the workareas are same.
                lv_zdlz = lv_zdlz + ls_zia_2order_cap_total-zdauer.
                READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.
              ENDIF.

            ENDLOOP.

          ENDLOOP.
        ELSE.
*          The below code is written to get the multiple quantities on same wbs in same workarea.

          CLEAR : lv_zdlz.
          READ TABLE lt_n004_wbs_o INTO ls_n004_wbs WITH KEY order = ls_order-aufnr.
          IF sy-subrc = 0 AND ls_n004_wbs-wbs IS NOT INITIAL.
            LOOP AT lt_n004_wbs_o INTO ls_n004_wbs_o WHERE zarbstl = ls_n004_wbs-zarbstl AND wbs = ls_n004_wbs-wbs. "#EC CI_NESTED
              LOOP AT lt_zia_2order_cap_total INTO ls_zia_2order_cap_total WHERE aufnr = ls_n004_wbs_o-order
                                                                     AND zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz. "#EC CI_NESTED
                lv_zdlz = lv_zdlz + ls_zia_2order_cap_total-zdauer.
                READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.


              ENDLOOP.
            ENDLOOP.
          ENDIF.

*          if the quantity is not filled in above logic, then the below is triggered.
          IF lv_zdlz IS INITIAL.
            lv_zdlz = ls_zia_2order_cap_total-zdauer.
            READ TABLE lt_qual_base INTO ls_qual WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.

          ENDIF.


        ENDIF.





        READ TABLE lt_zia_2sf_veh_seat_all INTO ls_zia_2sf_veh_seat
*                                       WITH KEY zid_fzg_platz = ls_qual-zid_fzg_platz.
                                       WITH KEY zid_fzg_platz = ls_zia_2order_cap_total-zid_fzg_platz.
        IF sy-subrc = 0 AND ls_zia_2sf_veh_seat-uname IS NOT INITIAL  AND ls_zia_2sf_veh_seat-uname(3) NE 'EXT'.
          lv_len = strlen( ls_zia_2sf_veh_seat-uname ).
          lv_len = lv_len - 1.
          lv_uname = ls_zia_2sf_veh_seat-uname+1(lv_len).
        ELSE.
          CLEAR lv_uname.
        ENDIF.

        lv_refnum = lv_refnum + 1.
        lv_activity = lv_activity + 10.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_activity
          IMPORTING
            output = lv_activity.

        CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
        APPEND VALUE #(
          refnumber  = lv_refnum
          objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
          method     = if_eams_bo_const=>gc_bapi_ord_method-create
          objectkey  = lv_objectkeyo
        ) TO lt_methods.

        APPEND VALUE #(
          activity    = lv_activity   "'0010'
          control_key = lv_steus "'PM01'
          work_cntr   = ls_qual-personalmodul    "'CH'
          plant       = ls_result-maintenanceplanningplant
          description = lv_shorttext"ls_result-maintplngbucketlabel
          field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
          duration_normal = lv_zdlz
          pers_no = lv_uname
          usr04 = lv_usr04
          use04 = lv_use04
          constraint_type_start = '1'
          constraint_type_finish = '1'
          start_cons = ls_schichtdetails-start_datum
          strttimcon = ls_schichtdetails-start_zeit
          fin_constr = ls_schichtdetails-end_datum
          fintimcons = ls_schichtdetails-end_zeit
        ) TO lt_operation.

*        ENDIF.

*        ENDLOOP.
      ENDLOOP.

*      Adding TFF values to qualifications.
* avoiding TFF values for access type 2.
      IF ls_order-zzzugangsart NE 2.

        LOOP AT lt_qual_tff INTO ls_qual_tff WHERE wa_id = ls_order-zarbstl. "#EC CI_NESTED
          IF ls_qual_tff-qual-uname IS NOT INITIAL.

            lv_len = strlen( ls_qual_tff-qual-uname ).
            lv_len = lv_len - 1.
            lv_uname = ls_qual_tff-qual-uname+1(lv_len).

          ENDIF.
          lv_refnum = lv_refnum + 1.
          lv_activity = lv_activity + 10.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_activity
            IMPORTING
              output = lv_activity.

          CONCATENATE lv_objectkey lv_activity INTO lv_objectkeyo.

*   VORGANG HINZUFÜGEN
          APPEND VALUE #(
            refnumber  = lv_refnum
            objecttype = if_eams_bo_const=>gc_bapi_ord_obj_type-operation
            method     = if_eams_bo_const=>gc_bapi_ord_method-create
            objectkey  = lv_objectkeyo
          ) TO lt_methods.

          APPEND VALUE #(
            activity    = lv_activity   "'0010'
            control_key = lv_steus "'PM01'
            work_cntr   = ls_qual_tff-qual-personalmodul    "'CH'
            plant       = ls_result-maintenanceplanningplant
            description = lv_shorttext"ls_result-maintplngbucketlabel
            field_key = 'N_DIENS'
*          duration_normal = ls_qual-zdlz
            duration_normal = '0'"lv_zdlz
            pers_no = lv_uname
            usr04 = lv_usr04
            use04 = lv_use04
            constraint_type_start = '1'
            constraint_type_finish = '1'
            start_cons = ls_schichtdetails-start_datum
            strttimcon = ls_schichtdetails-start_zeit
            fin_constr = ls_schichtdetails-end_datum
            fintimcons = ls_schichtdetails-end_zeit
          ) TO lt_operation.

        ENDLOOP.

      ENDIF.
      "Fill update structure of operation
      lt_operation_up = VALUE #( ( activity = abap_true
                                   control_key = abap_true
                                   work_cntr = abap_true
                                   plant = abap_true
*                                   standard_text_key = abap_true
                                   description = abap_true
                                   field_key = abap_true
                                   duration_normal = abap_true
                                   pers_no = abap_true
                                   usr04 = abap_true
                                   use04 = abap_true
                                   constraint_type_start = abap_true
                                   constraint_type_finish = abap_true
                                   start_cons = abap_true
                                   strttimcon = abap_true
                                   fin_constr = abap_true
                                   fintimcons = abap_true
*                                   calc_key = abap_true
*                                   currency = abap_true
                                    ) ).

*  _METHODS - SAVE
      APPEND VALUE #(
        refnumber  = 1
        objecttype = space
        method     = if_eams_bo_const=>gc_bapi_ord_method-save
        objectkey  = lv_objectkey
      ) TO lt_methods.

*   CALL THE BAPI
      CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
        TABLES
          it_methods      = lt_methods
          it_header       = lt_header
          it_header_up    = lt_header_up
          it_operation    = lt_operation
          it_operation_up = lt_operation_up
          return          = lt_return.

*   RÜCKGABEVERARBEITUNG
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        READ TABLE lt_return WITH KEY id = 'IWO_BAPI2' number = '112' INTO ls_return.

        IF sy-subrc = 0.
*      RV_NUMBER = LS_RETURN-MESSAGE_V2.   " WEGEN FÜHRENDEN NULLEN
          lv_tot_admin_order  = lv_tot_admin_order + 1.
          CLEAR sy-subrc.

*            capture all admin orders created.
          ls_admin_tot-wa_id = ls_order-zarbstl."lv_workarea_id."
          ls_admin_tot-order = ls_return-message_v2.
          ls_admin_tot-n004_ord = ls_order-aufnr.
          APPEND ls_admin_tot TO lt_admin_tot.
          CLEAR ls_admin_tot.
          READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot WITH KEY wa_ord = ls_order-aufnr.
          IF sy-subrc = 0.

*          populate total quantity per admin order.
            ls_total_qual-admin_order = ls_return-message_v2.
            ls_total_qual-qual = ls_wa_ord_tot-wa_count.
            APPEND ls_total_qual TO lt_total_qual.
            CLEAR ls_total_qual.

          ENDIF.
        ENDIF.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        ls_total_qual-admin_order = ls_return-message_v2.

*Updating revision number in Admin order.
*        CLEAR ls_order1.
*        ls_order1-aufnr = ls_total_qual-admin_order.
*        ls_order1-auart = ls_aufk-auart.
*        wd_assist->update_revision_number( EXPORTING is_order = ls_order1
*                                                       iv_revision = ls_result-maintenanceevent ).

*Updating revision number in planned orders.
*shifted at the end inside loop of lt_zia_2sf_orderstr internal table.
***        wd_assist->update_revision_number( EXPORTING is_order = ls_order
***                                                       iv_revision = ls_result-maintenanceevent ).
***
***
****        Call program ZIA_20001_M1
***
***
***
***        wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).
***
***        wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_total_qual-admin_order
***                                                          iv_phase = '07'
***                                                          iv_subphase = '0065' ).
        CLEAR ls_total_qual-admin_order.
      ENDIF.
    ENDIF.



    ls_zia_2sf_orderstr-mandt = sy-mandt."MANDT
    ls_zia_2sf_orderstr-zschicht = ls_schichtdetails-zschicht."LS_ORDER-ZSCHICHT. "SHIFT ID
    ls_zia_2sf_orderstr-schicht_auftrag = lv_shift_aufnr."LS_ORDER-AUFNR. "SHIFT ORDER
    ls_zia_2sf_orderstr-arbeitstellen_id = ls_order-zarbstl. "WORK AREA ID
    ls_zia_2sf_orderstr-maintplngbucketlabel = ls_result-maintenanceplanningbucket."lv_planbucktdesc. "MAINTENANCE PLANNING BUCKET LABEL.
    ls_zia_2sf_orderstr-etap_aufnr = ls_return-message_v2. " STAGE ORDER ( ADMIN ORDER )
    ls_zia_2sf_orderstr-aufnr = ls_order-aufnr. "PLANNED ORDERS

    IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
      ls_zia_2sf_orderstr-er_ir = 'ER'. "ER/ IR
    ENDIF.

    IF ls_order-auart = 'N004' .
      ls_zia_2sf_orderstr-er_ir = 'IR'. "ER/ IR
    ENDIF.
    LOOP AT lt_zia_2cost_blck INTO DATA(ls_zia_2cost_blck2) "#EC CI_NESTED "#EC CI_STDSEQ
                WHERE jahr = sy-datum(4)
                  AND perimeter = ls_order-zzperi.
      TRANSLATE ls_zia_2cost_blck2 TO UPPER CASE.   "#EC DEPRECATED_KEY
      IF ls_zia_2cost_blck2-kategorie = 'PERSONAL'.
        ls_zia_2sf_orderstr-kostenblock = ls_zia_2cost_blck2-aufnr. " COST BLOCK PERSONAL
      ENDIF.
      IF ls_zia_2cost_blck2-kategorie = 'VEHICLES'.
        ls_zia_2sf_orderstr-kostenblock_vehicle = ls_zia_2cost_blck2-aufnr. " COST BLOCK PERSONAL
      ENDIF.

    ENDLOOP.

*    ##WARN_OK           READ TABLE lt_wa_ord_tot INTO ls_wa_ord_tot "#EC CI_STDSEQ
    ##WARN_OK           READ TABLE lt_wa_ord_tot_n4 INTO ls_wa_ord_tot "#EC CI_STDSEQ
        WITH KEY zschicht = ls_zia_2sf_orderstr-zschicht
                 wa_id = ls_zia_2sf_orderstr-arbeitstellen_id
                 wa_ord = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-anzahl_qual = ls_wa_ord_tot-wa_count.
*      ls_zia_2sf_orderstr-percentage =  ls_wa_ord_tot-wa_percentage.
      ##WARN_OK     READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-percentage = ( ls_zia_2sf_orderstr-anzahl_qual / ls_wa_qual_tot-wa_count ) * 100 .
      ENDIF.
    ENDIF.
    ls_zia_2sf_orderstr-accesstype = ls_order-zzzugangsart. " access type.
    READ TABLE lt_n004_wbs_o INTO ls_n004_wbs WITH KEY order = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-wbs = ls_n004_wbs-wbs.
    ENDIF.
*  LS_ZIA_2SF_ORDERSTR- = LS_ORDER-. "
    APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstr.
    CLEAR : ls_zia_2sf_orderstr .", ls_order.

*populate revision number using maintenace event.

*Get Order details

*        IF ls_order = '1'.
*Shifted the below code before calling program ZIA_20001_M1
*    wd_assist->populate_revision_number( EXPORTING is_order = ls_order
*                                                   iv_revision = ls_result-maintenanceevent ).


*Call program ZIA_20001_M1
*    wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_result-maintenanceevent ).


*add vehicle details for N004 orders.
    LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost
                              WHERE arbeitstellen_id = ls_order-zarbstl. "#EC CI_NESTED

      ##WARN_OK     READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order-zarbstl. ##WARN_OK
      IF ls_wa_details-text CS 'RAIL' OR ls_wa_details-text CS 'SCHIENE' OR ls_wa_details-text CS 'ROTAIA' .

        ls_zia_2sf_veh_cost-etap_aufnr = ls_return-message_v2.
        ls_zia_2sf_veh_cost-er_ir = 'IR'.
*      READ TABLE lt_workarea_tot INTO ls_workarea_tot    "#EC CI_STDSEQ
*          WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
*      IF sy-subrc = 0.
*        ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten ) * 100.
*      ENDIF.
        APPEND ls_zia_2sf_veh_cost TO lt_zia_2sf_veh_costn.
        CLEAR ls_zia_2sf_veh_cost.

      ENDIF.
    ENDLOOP.


*      Adding Planning Bucket details
    ls_order_revi-pb = ls_result-maintenanceplanningbucket.
    ls_order_revi-revi = ls_result-maintenanceevent.
    APPEND ls_order_revi TO lt_order_revi.
    CLEAR ls_order_revi.


*        ENDIF.
  ENDLOOP.

*  *  Modifying z tables.
  APPEND LINES OF lt_zia_2sf_veh_costn TO lt_zia_2sf_veh_cost.

*deleting records where admin order is not created.
  DELETE lt_zia_2sf_veh_cost WHERE etap_aufnr IS INITIAL.

*  populating data for settlement rule per shift order.
  CLEAR : lv_qual_per, lv_n003_qual.

*  populating total orders table.
*  lt_zia_2sf_orderstc[] = lt_zia_2sf_orderstr[].
*  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstc COMPARING etap_aufnr.
*  LOOP AT lt_zia_2sf_orderstc INTO ls_zia_2sf_orderstr.
*
*    AT LAST.
*      ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*      ls_total_labor-percentage = 100 - lv_qual_per.
*      DATA(lv_last) = 'X'.
*    ENDAT.
*    IF lv_last = 'X'.
*      ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*    ENDIF.
*    IF lv_last IS INITIAL.
*      AT NEW etap_aufnr.
*
*        ls_total_labor-admin_order = ls_zia_2sf_orderstr-etap_aufnr.
*        ls_total_labor-percentage   = ( 1 / lv_tot_admin_order ) * 100.
*        lv_qual_per = lv_qual_per + ls_total_labor-percentage.
*      ENDAT.
*    ENDIF.
*
*
*    APPEND ls_total_labor TO lt_total_labor.
*
*  ENDLOOP.
* New calculation for total labor
*  DESCRIBE TABLE lt_wa_qual_tot LINES DATA(lv_tot_wa).

  lv_tot_wa = lines( lt_wa_qual_tot ).
*  commented below loop on 20.07.26, moved this table to last.
*  new calculation for total labor
*  LOOP AT lt_total_qual INTO ls_total_qual.
*
*    AT LAST.
*      ls_total_labor-admin_order = ls_total_qual-admin_order.
*      ls_total_labor-percentage = 100 - lv_qual_per.
*      DATA(lv_last) = 'X'.
*    ENDAT.
*    IF lv_last = 'X'.
*      ls_total_labor-admin_order = ls_total_qual-admin_order.
*    ENDIF.
*    IF lv_last IS INITIAL.
*      CLEAR lv_n003_qual.
*      lv_n003_qual = ls_total_qual-qual. " temporaty use of variable.
*      AT NEW admin_order.
*
*        ls_total_labor-admin_order = ls_total_qual-admin_order.
*        ls_total_labor-percentage   = ( lv_n003_qual / lv_tot_qual ) * 100.
*        lv_qual_per = lv_qual_per + ls_total_labor-percentage.
*      ENDAT.
*    ENDIF.
*
*
*    APPEND ls_total_labor TO lt_total_labor.
*
*  ENDLOOP.

* populating total vehicle and special product table.
  CLEAR : lv_qual_per, lv_last.

  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
    AT LAST.
      lv_last = 'X'.
    ENDAT.
*    at new etap_aufnr.
    IF ls_zia_2sf_veh_cost-spez_fzg_kstenblck IS INITIAL.

      ls_total_veh-admin_order = ls_zia_2sf_veh_cost-etap_aufnr.

    ELSE.
      ls_total_veh-admin_order = ls_zia_2sf_veh_cost-spez_fzg_kstenblck.
    ENDIF.
*    ls_total_veh-percentage = ls_zia_2sf_veh_cost-prozent.

    IF lv_last = 'X'.
      ls_total_veh-percentage = 100 - lv_qual_per.
      IF ls_total_veh-percentage = 0.
        ls_total_veh-percentage = 100.
      ENDIF.
    ELSE.
      ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
      IF sy-subrc = 0.
        READ TABLE lt_workarea_tot INTO ls_workarea_tot  "#EC CI_STDSEQ
           WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
        IF sy-subrc = 0.
          ls_total_veh-percentage = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
          lv_qual_per = lv_qual_per + ls_total_veh-percentage.
        ENDIF.

      ENDIF.
    ENDIF.

*    COLLECT ls_total_veh INTO lt_total_veh.                "#EC COLLECT
    APPEND ls_total_veh TO lt_total_veh.

    COLLECT ls_total_veh INTO lt_total_vehc.               "#EC COLLECT
    CLEAR ls_total_veh.


  ENDLOOP.



  CLEAR : lv_qual_per, lv_last.

  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.

    AT LAST.
      ls_zia_2sf_veh_cost-prozent = 100 - lv_qual_per.
      lv_last = 'X'.
      IF ls_zia_2sf_veh_cost-prozent = 0.
        ls_zia_2sf_veh_cost-prozent = 100.
      ENDIF.

      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
      CLEAR ls_zia_2sf_veh_cost.
    ENDAT.
    IF lv_last IS INITIAL.

      ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
      IF sy-subrc = 0.
        READ TABLE lt_workarea_tot INTO ls_workarea_tot  "#EC CI_STDSEQ
           WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
        IF sy-subrc = 0.
          ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
          lv_qual_per = lv_qual_per + ls_zia_2sf_veh_cost-prozent.
        ENDIF.

      ENDIF.
      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
      CLEAR ls_zia_2sf_veh_cost.

    ENDIF.

  ENDLOOP.

*  LOOP AT lt_zia_2sf_veh_cost INTO ls_zia_2sf_veh_cost.
*    ##WARN_OK   READ TABLE lt_pb_tot INTO ls_pb_tot WITH KEY wa_id = ls_zia_2sf_veh_cost-arbeitstellen_id. ##WARN_OK
*    IF sy-subrc = 0.
*      READ TABLE lt_workarea_tot INTO ls_workarea_tot    "#EC CI_STDSEQ
*         WITH KEY zschicht = ls_zia_2sf_veh_cost-zschicht.
*      IF sy-subrc = 0.
*        ls_zia_2sf_veh_cost-prozent = ( ls_zia_2sf_veh_cost-fahrzeug_kosten / ls_workarea_tot-fahrzeug_kosten / ls_pb_tot-wa_count ) * 100.
*      ENDIF.
*      MODIFY lt_zia_2sf_veh_cost FROM ls_zia_2sf_veh_cost TRANSPORTING prozent.
*      CLEAR ls_zia_2sf_veh_cost.
*
*    ENDIF.
*
*  ENDLOOP.lt_ord_qual.
*adding the missing planned orders in the orderstr table.
  LOOP AT lt_order_original INTO ls_order.


    READ TABLE lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr WITH KEY aufnr = ls_order-aufnr.
    IF sy-subrc NE 0.
      IF ls_order-auart = 'N001' OR ls_order-auart = 'N003' .
        lv_er_ir = 'ER'. "ER/ IR
      ENDIF.
      IF ls_order-auart = 'N004' .
        lv_er_ir = 'IR'. "ER/ IR
      ENDIF.

      READ TABLE lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr WITH KEY arbeitstellen_id = ls_order-zarbstl
                                                                       er_ir = lv_er_ir
                                                                       accesstype = ls_order-zzzugangsart.
      IF sy-subrc = 0.

*        CLEAR : ls_header1, lt_ret.
*
*        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
*          EXPORTING
*            number    = ls_zia_2sf_orderstr-aufnr
*          IMPORTING
*            es_header = ls_header1
*          TABLES
*            return    = lt_ret.

        ls_zia_2sf_orderstr-aufnr = ls_order-aufnr.

        READ TABLE lt_ord_qual_o INTO ls_ord_qual_o WITH KEY wa_id = ls_order-zarbstl ##WARN_OK
                                                             n004_ord = ls_order-aufnr.
        IF sy-subrc = 0.
          ls_zia_2sf_orderstr-anzahl_qual = ls_ord_qual_o-qual.
        ENDIF.


        APPEND ls_zia_2sf_orderstr TO lt_zia_2sf_orderstrn.
        CLEAR ls_zia_2sf_orderstr.



*moved this before calling program zia_20001_m1
*        wd_assist->update_revision_number( EXPORTING is_order = ls_order
*                                                       iv_revision = ls_header1-revision ).


      ENDIF.

    ENDIF.
  ENDLOOP.

  APPEND LINES OF lt_zia_2sf_orderstrn TO lt_zia_2sf_orderstr. " adding missing orders here.


  DATA: lt_order_data    TYPE eams_t_bo_ord_header,
        ls_order_data     TYPE eams_s_bo_ord_header,
        lv_objnr         TYPE jsto-objnr,
        lv_txt04         TYPE tj02t-txt04,
        lv_status_number TYPE jest-stat.


  LOOP AT lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr.

    CLEAR : ls_header1, lt_ret, lt_order_data, ls_order_data, lv_objnr, lv_txt04,lv_status_number, ls_order,ls_order_revi.

    READ TABLE lt_order_revi INTO ls_order_revi
        WITH KEY pb = ls_zia_2sf_orderstr-maintplngbucketlabel.
    IF sy-subrc = 0.
      ls_zia_2sf_orderstr-revision = ls_order_revi-revi.
    ENDIF.

*Updating revision number in planned orders.

    ls_order-aufnr = ls_zia_2sf_orderstr-aufnr.

    READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_order-auart = ls_order_original-auart.
    ENDIF.
*shifted at the end inside loop of lt_zia_2sf_orderstr internal table.
***    wd_assist->update_revision_number( EXPORTING is_order = ls_order
***                                           iv_revision = ls_zia_2sf_orderstr-revision ).

    READ TABLE lt_ord_qual_o INTO ls_ord_qual_o WITH KEY n004_ord = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ##WARN_OK     READ TABLE lt_wa_qual_tot INTO ls_wa_qual_tot WITH KEY wa_id = ls_zia_2sf_orderstr-arbeitstellen_id.
      IF sy-subrc = 0.
        ls_zia_2sf_orderstr-percentage = ( 100 / lv_tot_wa ) * ( ls_ord_qual_o-qual / ls_wa_qual_tot-wa_count ).

        MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING revision percentage .

      ENDIF.

    ELSE.
      MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING revision.
    ENDIF.


    "fetch Maintenance Order Details
    ##NEEDED
    cl_eams_bo_order=>s_get_instance( )->get_order_header(
      EXPORTING
*        it_node_id     =  VALUE #( ( eams_aufnr = mv_number ) )                 "Business Object Order - Identification
        it_node_id     =  VALUE #( ( eams_aufnr = ls_order-aufnr ) )                 "Business Object Order - Identification
      IMPORTING
        et_node_data   =  lt_order_data                                         "Business Object Order - Header Data
        et_node_id_rel =  DATA(lt_node_id_rel1)                                 "Relationship between index of source and target node ID
        et_messages    =  DATA(lt_message) ).                                   "Message

    CHECK lt_order_data IS NOT INITIAL.
    ls_order_data = VALUE #( lt_order_data[ eams_aufnr = ls_order-aufnr ] ).


    lv_objnr = ls_order_data-object_no.
*            deactivate PL2 if it exists.
    IF ls_order_data-userstatus CS 'PL2'.

      lv_txt04 = 'PL2'.

      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
        EXPORTING
          language           = sy-langu
          mode               = 'E'
          objnr              = lv_objnr
          txt04              = lv_txt04
        IMPORTING
          status_number      = lv_status_number
        EXCEPTIONS
          insufficient_input = 1
          not_found          = 2
          object_not_found   = 3
          wrong_mode         = 4
          OTHERS             = 5.

      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
        EXPORTING
          objnr       = lv_objnr
          user_status = lv_status_number
          set_inact   = 'X'.


    ENDIF.

*            set PL3 status.


*to set the status as PL3.
    CLEAR : lv_status_number.
    lv_txt04 = 'PL3'.

    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
      EXPORTING
        language           = sy-langu
        mode               = 'E'
        objnr              = lv_objnr
        txt04              = lv_txt04
      IMPORTING
        status_number      = lv_status_number
      EXCEPTIONS
        insufficient_input = 1
        not_found          = 2
        object_not_found   = 3
        wrong_mode         = 4
        OTHERS             = 5.

    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
      EXPORTING
        objnr       = lv_objnr
        user_status = lv_status_number
        set_inact   = ' '.

    " Updating Phase
*shifted at the end inside loop of lt_zia_2sf_orderstr internal table.
***    zcl_ia_2utilities=>update_maint_ord_phase( iv_aufnr = ls_order-aufnr
***                                               iv_maintordovrlprocphase = '07'"lv_maintordovrlprocphase
****                                                   iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
***                                               iv_maintordovrlprocsubphase = '0065' ).




  ENDLOOP.


*  Updating operations in exisiting admin orders of pending planned orders.
  LOOP AT lt_zia_2sf_orderstrn INTO ls_zia_2sf_orderstrn.

*    need to neglect N003 orders as the qualities are already considered.
    READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_zia_2sf_orderstrn-aufnr.
    IF sy-subrc = 0 AND ls_order_original-auart = 'N003'.
*      RETURN.
      CONTINUE.
    ENDIF.

    CLEAR : ls_qual, lt_qual.

    LOOP AT lt_qual_original INTO ls_qual_original WHERE order = ls_zia_2sf_orderstrn-aufnr. "#EC CI_NESTED
      ls_qual = ls_qual_original-qual.
      APPEND ls_qual TO lt_qual.
      CLEAR ls_qual.
    ENDLOOP.

    wd_assist->update_opr_in_admin_orders( EXPORTING iv_admin_aufnr = ls_zia_2sf_orderstrn-etap_aufnr
                                                      it_qual = lt_qual
                                                      is_schichtdetails = ls_schichtdetails
                                                      iv_maintenanceplanningplant = ls_result-maintenanceplanningplant
                                                      iv_shorttext = lv_shorttext
                                                      iv_steus = lv_steus
                                                      iv_use04 = lv_use04
                                                      iv_usr04 = lv_usr04 ).


  ENDLOOP.

*  updating revision numbers in all admin order and planned orders.

*updating revision number in planned orders.
  lt_zia_2sf_orderstro[] = lt_zia_2sf_orderstr[].
  SORT lt_zia_2sf_orderstro BY aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstro COMPARING aufnr.

  LOOP AT lt_zia_2sf_orderstro INTO ls_zia_2sf_orderstr.
    CLEAR ls_order.

    ls_order-aufnr = ls_zia_2sf_orderstr-aufnr.

    READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_zia_2sf_orderstr-aufnr.
    IF sy-subrc = 0.
      ls_order-auart = ls_order_original-auart.
    ENDIF.

    wd_assist->update_revision_number( EXPORTING is_order = ls_order
                                                         iv_revision = ls_zia_2sf_orderstr-revision ).

  ENDLOOP.


*updating revision number in admin orders.
  lt_zia_2sf_orderstro[] = lt_zia_2sf_orderstr[].
  SORT lt_zia_2sf_orderstro BY etap_aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstro COMPARING etap_aufnr.
  LOOP AT lt_zia_2sf_orderstro INTO ls_zia_2sf_orderstr.

    CLEAR ls_order.

    ls_order-aufnr = ls_zia_2sf_orderstr-etap_aufnr.

    READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_zia_2sf_orderstr-etap_aufnr.
    IF sy-subrc = 0.
      ls_order-auart = ls_order_original-auart.
    ENDIF.

    wd_assist->update_revision_number( EXPORTING is_order = ls_order
                                                         iv_revision = ls_zia_2sf_orderstr-revision ).

  ENDLOOP.

*  execute revision number program.
  lt_zia_2sf_orderstro[] = lt_zia_2sf_orderstr[].
  SORT lt_zia_2sf_orderstro BY revision.
  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstro COMPARING revision.

  LOOP AT lt_zia_2sf_orderstro INTO ls_zia_2sf_orderstr.

    wd_assist->call_program_zia_20001_m1( EXPORTING iv_revision = ls_zia_2sf_orderstr-revision ).

  ENDLOOP.

*updating phase in planned orders.
  lt_zia_2sf_orderstro[] = lt_zia_2sf_orderstr[].
  SORT lt_zia_2sf_orderstro BY aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstro COMPARING aufnr.

  LOOP AT lt_zia_2sf_orderstro INTO ls_zia_2sf_orderstr.

* Releasing order
    CLEAR :lt_methods_so, ls_method_so, lt_return_so , ls_return_so, lv_aufnr_so.

* 1. Define the method to release the order header
    ls_method_so-refnumber = '1'.
    ls_method_so-objecttype = 'HEADER'.
    ls_method_so-method     = 'RELEASE'.
    ls_method_so-objectkey  = ls_zia_2sf_orderstr-aufnr.
    APPEND ls_method_so TO lt_methods_so.

* 2. Define the save method
    CLEAR ls_method_so.
    ls_method_so-refnumber = '1'.
    ls_method_so-objecttype = ''.
    ls_method_so-method     = 'SAVE'.
    ls_method_so-objectkey  = ls_zia_2sf_orderstr-aufnr.
    APPEND ls_method_so TO lt_methods_so.

* 3. Call the BAPI to process the release and save
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods = lt_methods_so
        return     = lt_return_so.

* 4. Check for errors and commit
    READ TABLE lt_return_so INTO ls_return_so WITH KEY type = 'E'.
    IF sy-subrc NE 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ENDIF.

****      resetting ready for scheduling order status.
    cl_eams_bo_order=>s_get_instance( )->if_eams_bo_order~reset_ready_for_scheduling(
      EXPORTING
        it_ord_id       = VALUE #( ( eams_aufnr = ls_zia_2sf_orderstr-aufnr ) )
      IMPORTING
  ##NEEDED  et_message      = DATA(lt_messager)
  ##NEEDED  et_index_failed = DATA(lt_index_failed) ).

    wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_zia_2sf_orderstr-aufnr
                                                      iv_phase = '07'
                                                      iv_subphase = '0065' ).

  ENDLOOP.


*updating phase in admin orders.
  lt_zia_2sf_orderstro[] = lt_zia_2sf_orderstr[].
  SORT lt_zia_2sf_orderstro BY etap_aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_zia_2sf_orderstro COMPARING etap_aufnr.
  LOOP AT lt_zia_2sf_orderstro INTO ls_zia_2sf_orderstr.


* Releasing order
    CLEAR :lt_methods_so, ls_method_so, lt_return_so , ls_return_so, lv_aufnr_so.

* 1. Define the method to release the order header
    ls_method_so-refnumber = '1'.
    ls_method_so-objecttype = 'HEADER'.
    ls_method_so-method     = 'RELEASE'.
    ls_method_so-objectkey  = ls_zia_2sf_orderstr-etap_aufnr.
    APPEND ls_method_so TO lt_methods_so.

* 2. Define the save method
    CLEAR ls_method_so.
    ls_method_so-refnumber = '1'.
    ls_method_so-objecttype = ''.
    ls_method_so-method     = 'SAVE'.
    ls_method_so-objectkey  = ls_zia_2sf_orderstr-etap_aufnr.
    APPEND ls_method_so TO lt_methods_so.

* 3. Call the BAPI to process the release and save
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods = lt_methods_so
        return     = lt_return_so.

* 4. Check for errors and commit
    READ TABLE lt_return_so INTO ls_return_so WITH KEY type = 'E'.
    IF sy-subrc NE 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ENDIF.

****      resetting ready for scheduling order status.
    cl_eams_bo_order=>s_get_instance( )->if_eams_bo_order~reset_ready_for_scheduling(
      EXPORTING
        it_ord_id       = VALUE #( ( eams_aufnr = ls_zia_2sf_orderstr-etap_aufnr ) )
      IMPORTING
  ##NEEDED  et_message      = lt_messager
  ##NEEDED  et_index_failed = lt_index_failed ).


    wd_assist->update_order_phase_subphase( EXPORTING iv_order = ls_zia_2sf_orderstr-etap_aufnr
                                                               iv_phase = '07'
                                                               iv_subphase = '0065' ).

  ENDLOOP.





  CLEAR : lv_qual_per, lv_last.
  LOOP AT lt_zia_2sf_orderstr INTO ls_zia_2sf_orderstr.
    DATA(ls_zia_2sf_orderstrl) = ls_zia_2sf_orderstr.
*    AT END OF arbeitstellen_id.
*      ls_zia_2sf_orderstrl-percentage = 100 - lv_qual_per.
*
*      IF ls_zia_2sf_orderstrl-percentage = 0.
*        ls_zia_2sf_orderstrl-percentage = 100.
*      ENDIF.
*      lv_last = 'X'.
**      MODIFY lt_zia_2sf_orderstr FROM ls_zia_2sf_orderstr TRANSPORTING percentage.
**      CLEAR : ls_zia_2sf_orderstr, lv_qual_per, lv_last.
**      CONTINUE.
*    ENDAT.
    AT LAST.
      ls_zia_2sf_orderstrl-percentage = 100 - lv_qual_per.
      lv_last = 'X'.
    ENDAT.
    IF lv_last = 'X'.

      APPEND ls_zia_2sf_orderstrl TO lt_zia_2sf_orderstrl .

      ls_total_labor-percentage = ls_zia_2sf_orderstrl-percentage.
      ls_total_labor-admin_order = ls_zia_2sf_orderstrl-etap_aufnr.
      COLLECT ls_total_labor INTO lt_total_labor.          "#EC COLLECT
      CLEAR ls_total_labor .
      CLEAR : ls_zia_2sf_orderstr, lv_qual_per, lv_last, ls_zia_2sf_orderstrl.
      CONTINUE.
    ENDIF.

    IF lv_last IS INITIAL.
      lv_qual_per = lv_qual_per + ls_zia_2sf_orderstr-percentage.

    ENDIF.

    APPEND ls_zia_2sf_orderstrl TO lt_zia_2sf_orderstrl .

    ls_total_labor-percentage = ls_zia_2sf_orderstrl-percentage.
    ls_total_labor-admin_order = ls_zia_2sf_orderstrl-etap_aufnr.
    COLLECT ls_total_labor INTO lt_total_labor.            "#EC COLLECT
    CLEAR ls_total_labor .


  ENDLOOP.

  lt_zia_2sf_orderstr[] = lt_zia_2sf_orderstrl[].


*  Populating Setllement rule table

*  BAPI_ALM_ORDER_SRULE
  CLEAR : lv_tot_qual, ls_total_labor.

  LOOP AT lt_total_labor INTO ls_total_labor.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_total_labor-admin_order
      IMPORTING
        output = ls_total_labor-admin_order.


    lv_tot_qual = lv_tot_qual + 1.
    APPEND VALUE #( objnr      = lv_shift_aufnr "Shift Order
                    lfdnr      = lv_tot_qual
                    settl_type = 'PER'"lc_settl_type
                    source     = 'L_3'"mc_src_per              "+>001<
                    orderid    = ls_total_labor-admin_order
                    percentage = ls_total_labor-percentage )
                    TO lt_data.

  ENDLOOP.


  LOOP AT lt_total_vehc INTO ls_total_veh.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_total_veh-admin_order
      IMPORTING
        output = ls_total_veh-admin_order.


    lv_tot_qual = lv_tot_qual + 1.
    APPEND VALUE #( objnr      = lv_shift_aufnr "Shift Order
                    lfdnr      = lv_tot_qual
                    settl_type = 'PER'"lc_settl_type
                    source     = 'I_2'"mc_src_fzg              "+>001<
                    orderid    = ls_total_veh-admin_order
                    percentage = ls_total_veh-percentage )
                    TO lt_data.

  ENDLOOP.

  CLEAR ls_data.

  DATA(lt_methods1) = VALUE  bapi_alm_order_method_t( ).
  DATA(lt_return1)  = VALUE  bapiret2_t( ).


  LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
*      DATA(lv_tabix) = sy-tabix.
    APPEND VALUE #( refnumber  = <ls_data>-lfdnr
                    objecttype = 'SRULE'
                    method     = 'CREATE'
*                    method     = 'CHANGE'
                    objectkey  = lv_shift_aufnr ) TO lt_methods1.

    APPEND VALUE #( refnumber = <ls_data>-lfdnr
                    method    = 'SAVE'
                    objectkey  = lv_shift_aufnr ) TO lt_methods1.

    ls_srule_up-equiv_number = 'X'.
    APPEND ls_srule_up TO lt_srule_up.
  ENDLOOP.

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods1
*     it_header  = lt_header
*     it_header_up = lt_header_up
      it_srule   = lt_data
*     it_srule_up = lt_srule_up
      return     = lt_return1.

  IF NOT line_exists( lt_return1[ type = 'E' ] ) AND
     NOT line_exists( lt_return1[ type = 'A' ] ) AND
     NOT line_exists( lt_return1[ type = 'X' ] ).
*       iv_test_run = abap_false.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*    IF lt_return1 IS NOT INITIAL.                  "#EC EMPTY_IF_BRANCH
**        RAISE EXCEPTION TYPE zcx_io_5_fehler EXPORTING bapiret = lt_return.
*    ENDIF.
  ENDIF.

  wd_assist->modify_settlement_tables( EXPORTING it_zia_2sf_orderstr = lt_zia_2sf_orderstr
                                                 it_zia_2sf_veh_cost = lt_zia_2sf_veh_cost ).




*Updating componenets of orders with materials.
  LOOP AT lt_data_mat INTO ls_data_mat .
    CLEAR : lv_txt1, lv_txt2.

    ls_order_comp-aufnr = ls_data_mat-aufnr.
    ls_order_comp-start_datum = ls_schichtdetails-start_datum.
    ls_order_comp-start_zeit = ls_schichtdetails-start_zeit.
    ls_order_comp-reserv_no = ls_data_mat-rsnum.
    ls_order_comp-res_item = ls_data_mat-rspos.
    ls_order_comp-fzg_belad = ls_data_mat-fzg_belad.
    IF ls_order_comp-fzg_belad IS INITIAL.
      READ TABLE lt_order_original INTO ls_order_original WITH KEY aufnr = ls_order_comp-aufnr.
      IF sy-subrc = 0.
        ##WARN_OK   READ TABLE lt_wa_details INTO ls_wa_details WITH KEY wa_id = ls_order_original-zarbstl.
        IF sy-subrc = 0.
*            SPLIT ls_wa_details-text AT ls_zia_2plperim-zarbstbez INTO lv_txt1 lv_txt2.
          IF ls_wa_details-text CA '-'.
            SPLIT ls_wa_details-text AT '-' INTO lv_txt1 lv_txt2.
            SPLIT lv_txt2 AT '(' INTO lv_txt1 lv_txt2.
          ELSE.
            SPLIT ls_wa_details-text AT '(' INTO lv_txt1 lv_txt2.
          ENDIF.
          IF lv_txt1 IS NOT INITIAL.
            ls_order_comp-fzg_belad = lv_txt1.
            CONDENSE ls_order_comp-fzg_belad.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    APPEND ls_order_comp TO lt_order_comp.
    CLEAR ls_order_comp.

  ENDLOOP.

  IF ls_schichtdetails-beschr_2 CS 'LI'.
    lv_li = 'LI'.
  ELSE.
    CLEAR lv_li.
  ENDIF.
  wd_assist->update_components( EXPORTING it_orders = lt_order_comp
                                          iv_li = lv_li ).



* Add TFF operations per empty shift.

  LOOP AT lt_wa_details INTO ls_wa_details.
*  to check if there are no orders in the shift.
    ##WARN_OK
    READ TABLE lt_order_original INTO ls_order_original WITH KEY zarbstl = ls_wa_details-wa_id.
    IF sy-subrc NE 0.

* Deleting qualification which are already updated.
      DELETE lt_qual_tff WHERE wa_id NE ls_wa_details-wa_id.

      wd_assist->update_tff_in_shift_order( EXPORTING iv_shift_aufnr = lv_shift_aufnr
                                                      it_qual_tff = lt_qual_tff
                                                      is_schichtdetails = ls_schichtdetails
                                                      iv_maintenanceplanningplant = ls_result-maintenanceplanningplant
                                                      iv_shorttext = lv_shorttext
                                                      iv_steus = lv_steus
                                                      iv_use04 = lv_use04
                                                      iv_usr04 = lv_usr04 ).


    ENDIF.

  ENDLOOP.

* Releasing Shift order
  CLEAR :lt_methods_so, ls_method_so, lt_return_so , ls_return_so, lv_aufnr_so.

* 1. Define the method to release the order header
  ls_method_so-refnumber = '1'.
  ls_method_so-objecttype = 'HEADER'.
  ls_method_so-method     = 'RELEASE'.
  ls_method_so-objectkey  = lv_shift_aufnr.
  APPEND ls_method_so TO lt_methods_so.

* 2. Define the save method
  CLEAR ls_method_so.
  ls_method_so-refnumber = '1'.
  ls_method_so-objecttype = ''.
  ls_method_so-method     = 'SAVE'.
  ls_method_so-objectkey  = lv_shift_aufnr.
  APPEND ls_method_so TO lt_methods_so.

* 3. Call the BAPI to process the release and save
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods_so
      return     = lt_return_so.

* 4. Check for errors and commit
  READ TABLE lt_return_so INTO ls_return_so WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

*    changing status of shift admin order.
  wd_assist->update_order_phase_subphase( EXPORTING iv_order = lv_shift_aufnr
                                                              iv_phase = '07'
                                                              iv_subphase = '0065' ).


  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.


*Update priority in Notification

  IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CLEAR lt_return.
*          LS_SCHICHTDETAILS-ZSCHICHT
    DATA : lv_notif    TYPE bapi2080_nothdre-notif_no,
           ls_headern  TYPE bapi2080_nothdri,
           ls_headernx TYPE bapi2080_nothdri_x.
    lv_notif = ls_schichtdetails-zschicht.
    ls_headern-priority = 3.
    ls_headernx-priority = 'X'.

    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
      EXPORTING
        number        = lv_notif
        notifheader   = ls_headern
        notifheader_x = ls_headernx
      TABLES
        return        = lt_return.
    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CLEAR lt_return.
      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number = lv_notif
        TABLES
          return = lt_return.
      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      ENDIF.
    ENDIF.
  ENDIF.


ENDMETHOD.

METHOD set_current_event .
  IF io_event IS BOUND.
    wd_this->mo_curr_event = zcl_ia_2utils_wd_a=>copy_wd_event( io_event ).
  ELSE.
    CLEAR wd_this->mo_curr_event.
  ENDIF.
ENDMETHOD.

METHOD set_schicht_no_edit_after_frgb .

  DATA: ls_schichtdetails TYPE wd_this->element_schichtdetails,
        lt_schichtplan    TYPE wd_this->elements_schichtplan.


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

  ls_schichtdetails-object->unlock( ).
  ls_schichtdetails-edit_mode = abap_false.
  ls_schichtdetails-design = 00.
  ls_schichtdetails-notes_visibile = COND #( WHEN ls_schichtdetails-object->get_notes( ) IS INITIAL THEN abap_false ELSE abap_true ).
  ls_schichtdetails-object->unlock_sub_objects( ).

  wd_this->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
  wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
  wd_this->mo_ui_element_properties->set_vis_btn_as_edit( iv_data = zcl_ia_2ui_element_properties=>mc_is_visible ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_static_attributes_table( IMPORTING table = lt_schichtplan ).

  READ TABLE lt_schichtplan ASSIGNING FIELD-SYMBOL(<ls_schichtplan>)
                            WITH KEY object = ls_schichtdetails-object.

  IF sy-subrc = 0.

    <ls_schichtplan>-show_edit_btn = ls_schichtdetails-show_edit_btn.
    <ls_schichtplan>-design        = ls_schichtdetails-design.
    <ls_schichtplan>-edit_mode     = ls_schichtdetails-edit_mode.

    wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->bind_table( set_initial_elements = abap_true new_items = lt_schichtplan ).

  ENDIF.

  wd_context->get_child_node( name =  wd_this->wdctx_schichtdetails )->set_static_attributes( static_attributes = ls_schichtdetails ).

  IF ls_schichtdetails-object->is_locked( ).
    wd_this->invctx_schichtdetails( ).
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
  wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).

ENDMETHOD.

METHOD set_ui_schicht_status .
  DATA lo_schicht TYPE REF TO zcl_ia_2workshift.

  TRY .
      wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = 'OBJECT'
                                                                                  IMPORTING value = lo_schicht ).
      DATA(lv_edit_mode)   = lo_schicht->is_locked( ).
      DATA(lv_curr_status) = lo_schicht->get_status( ).
      wd_this->mo_ui_element_properties->set_ena_rmp_for_status( iv_edit_mode   = lv_edit_mode
                                                                 iv_curr_status = lv_curr_status ).


    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.
ENDMETHOD.

METHOD z_pe_main .
  DATA: ls_tabs_schichten TYPE wd_this->element_tabs_schichten.
  ##NEEDED DATA(lv_test) = io_event->get_name( ).

  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

      WHEN 'ON_ACTION':.

      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID' ).
        WHEN 'BTN_PLANUNGSCOCKPIT'.
          wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->invalidate( ).

        WHEN 'BTN_TAB'.
          DATA(li_ctx_element) = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).

          wd_this->reload_schicht( ls_tabs_schichten-object ). " reload Schicht on navigation

          wd_this->popin_aufnr_release( ).

          "Es reicht aus über den Index zu prüfen
          IF wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_lead_selection_index( ) <> li_ctx_element->get_index( ).
            zcl_ia_2context_helper=>unlock_prev_schicht_in_tab( ii_context = wd_context ).
            wd_this->mo_ui_element_properties->reload( ).
          ENDIF.

          wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->set_lead_selection_index( index = li_ctx_element->get_index( ) ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->invalidate( ).

          wd_this->mo_curr_arbstelle =  zcl_ia_2context_helper=>mark_first_arbst( EXPORTING ii_context = wd_context ).


          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility
                   )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
          wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).

          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).

          IF wd_this->mo_curr_arbstelle IS BOUND.
            wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->set_attribute(
                                        name = 'AS_HEADER_TEXT' value = wd_this->mo_curr_arbstelle->get_wd_header_text( )  ).
            wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_child_node( wd_this->wdctx_sitzplatz )->invalidate( ).
          ENDIF.
        WHEN 'BTN_CLOSE'.
          li_ctx_element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).

          ls_tabs_schichten-object->unlock( ).


          zcl_ia_2context_helper=>set_editmode_in_schichtplan( EXPORTING ii_context     = wd_context
                                                                         io_schicht     = ls_tabs_schichten-object
                                                                         iv_is_editable = abap_false ).

          zcl_ia_2context_helper=>del_schicht_tab( EXPORTING ii_context = wd_context
                                                             io_schicht = ls_tabs_schichten-object ).


          wd_this->popin_aufnr_release( ).

      ENDCASE.

  ENDCASE.
ENDMETHOD.

METHOD z_pe_osn_tunnel_oss .
  ##NEEDED DATA(lv_test) = io_event->get_name( ).
  DATA: ls_arbst          TYPE wd_this->element_arbst_tunnel,
        ls_schichtdetails TYPE wd_this->element_schichtdetails,
        lt_schichtplan    TYPE wd_this->elements_schichtplan,
        lo_schicht        TYPE REF TO zcl_ia_2workshift.

  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

    WHEN 'ON_ACTION'.
      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID' ).
          "Arbeitsstelle wurde selektiert
        WHEN 'LTO_ARBSTELLE' OR 'LTO_ARBSTELLE_OSN' OR 'LTO_ARBSTELLE_OSS' OR 'LTA_BTG_OSN' OR 'LTA_BTG_TUNNEL' OR 'LTA_BTG_OSS'.
          "Toggel Edit Mode => Sperren entsperren und so weiter
          DATA(li_ctx_element) = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_arbst ).

          "haben wir auch eine Arbeitsstelle angeklickt oder etwas anderes?
          IF ls_arbst-is_as = abap_false. RETURN. ENDIF.

          wd_this->mo_curr_arbstelle->remove_vorschau( ).

          "Wenn die Schicht gesperrt ist, dann sollen die Sperren nicht aufgehoben werden bei der Arbeitsstellennavigation
          IF NOT wd_this->mo_curr_arbstelle->get_schicht( )->is_locked( ).
            wd_this->mo_curr_arbstelle->unlock( ).
            wd_this->mo_curr_arbstelle->unlock_sub_objects( ).
          ENDIF.

          wd_this->mo_curr_arbstelle = ls_arbst-object.

          zcl_ia_2context_helper=>set_arbst_as_selected( EXPORTING is_arbst = ls_arbst ii_context = wd_context ).

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_fahrzeug )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_sitzplatz )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_jobpool )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_jobliste )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_details )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node(
                                      name = wd_this->wdctx_filter )->invalidate( ).

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_child_node( name = wd_this->wdctx_as_filter )->invalidate( ).
          "Anzeigefelder für AS ermitteln
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).
          IF ls_schichtdetails-object->is_locked( ) EQ abap_true.
            wd_this->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
            wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
          ELSE.
            wd_this->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
            wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
          ENDIF.
*          wd_this->mo_ui_element_properties->set_ui_arbstelle_visible( io_arbeitsstelle = wd_this->mo_curr_arbstelle  ).

          wd_this->mo_ui_element_properties->set_vis_sp_details( iv_data = COND #( WHEN wd_this->mo_curr_arbstelle->is_btg( ) EQ abap_true THEN abap_false ELSE abap_true ) ).

          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->set_attribute( name = 'AS_HEADER_TEXT' value = wd_this->mo_curr_arbstelle->get_wd_header_text( ) ).

          wd_this->fire_on_select_arbst_evt( ).  ">002< +

        WHEN 'BTN_EDIT'.

          "Toggel Edit Mode => Sperren entsperren und so weiter

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

          IF ls_schichtdetails-object->is_locked( ) EQ abap_false.
            TRY .
                wd_this->reload_schicht( ls_schichtdetails-object ). " reload Schich on edit switch
                wd_this->mo_curr_arbstelle->unlock( ).
                wd_this->mo_curr_arbstelle->unlock_sub_objects( ).
                ls_schichtdetails-object->lock( ).
                ls_schichtdetails-edit_mode = abap_true.
                ls_schichtdetails-design = 01.
                ls_schichtdetails-notes_visibile = abap_true.
                ls_schichtdetails-object->lock_sub_objects( iv_check = abap_false ).
                wd_this->mo_ui_element_properties->set_dsg_btn_edit( zcl_ia_2ui_element_properties=>mc_is_active ).
                wd_this->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
                wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
                wd_this->mo_ui_element_properties->set_vis_btn_as_edit( iv_data = zcl_ia_2ui_element_properties=>mc_is_not_visible ).

              CATCH zcx_ia_2failure INTO DATA(lx_fehler).
                ls_schichtdetails-object->unlock( ).
                ls_schichtdetails-object->unlock_sub_objects( ).
                wd_this->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
                wd_this->mo_message_manager->reset( ).
            ENDTRY.
          ELSE.
            ls_schichtdetails-object->unlock( ).
            ls_schichtdetails-edit_mode = abap_false.
            ls_schichtdetails-design = 00.
            ls_schichtdetails-notes_visibile = COND #( WHEN ls_schichtdetails-object->get_notes( ) IS INITIAL THEN abap_false ELSE abap_true ).
            ls_schichtdetails-object->unlock_sub_objects( ).
**            wd_this->mo_ui_element_properties->set_dsg_btn_edit( zcl_ia_2ui_element_properties=>mc_is_inactive  ).
            wd_this->mo_ui_element_properties->set_ui_schicht_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
            wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
            wd_this->mo_ui_element_properties->set_vis_btn_as_edit( iv_data = zcl_ia_2ui_element_properties=>mc_is_visible ).
          ENDIF.

          wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_static_attributes_table( IMPORTING table = lt_schichtplan ).
          READ TABLE lt_schichtplan ASSIGNING FIELD-SYMBOL(<ls_schichtplan>) WITH KEY object = ls_schichtdetails-object.
          IF sy-subrc = 0.
            <ls_schichtplan>-show_edit_btn = ls_schichtdetails-show_edit_btn.
            <ls_schichtplan>-design        = ls_schichtdetails-design.
            <ls_schichtplan>-edit_mode     = ls_schichtdetails-edit_mode.
            wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->bind_table( set_initial_elements = abap_true new_items = lt_schichtplan ).
          ENDIF.

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->set_static_attributes( static_attributes = ls_schichtdetails ).
*          wd_this->mo_ui_element_properties->set_ui_arbstelle_visible( io_arbeitsstelle = wd_this->mo_curr_arbstelle  ).
          IF ls_schichtdetails-object->is_locked( ).
            wd_this->invctx_schichtdetails( ).
          ENDIF.
          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_schicht )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).
          wd_this->fire_on_btn_edit_evt( iv_mode = ls_schichtdetails-edit_mode ).  ">002<  +
        WHEN 'LTA_BEMERKUNGEN'.
          wd_this->gv_notes_popup_from_schicht_dt = abap_true. ">004<  +
          wd_context->get_child_node( name = wd_this->wdctx_popup_bemerkung )->invalidate( ).
          wd_this->wd_get_api( )->get_window_manager( )->create_and_open_popup( window_name = 'W_POPUP_BEMERKUNG'
                                                                                title       = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS' )
                                                                                buttons     = wd_this->wd_get_api( )->get_window_manager( )->get_buttons_close( ) ).
        WHEN 'LTA_PARAMS'.

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = `OBJECT`
                                                                                             IMPORTING value = lo_schicht ).
          wd_this->open_schicht_parameters( lo_schicht ).

        WHEN 'LTA_ADD_MET'.

          wd_this->fire_add_met_to_as_evt( io_event ).

        WHEN 'BTN_MET_CREATE_AS'.

          wd_this->fire_met_create_as_evt( ).

          ">001< begin +
        WHEN 'BTN_MET_CREATE_AS_N'.
          wd_this->fire_met_create_as_n_evt( ).
        WHEN 'BTN_MET_CREATE_AS_S'.
          wd_this->fire_met_create_as_s_evt( ).

        WHEN 'BTN_MET_SED'.
          wd_this->fire_on_btn_met_sed_evt( ).

        WHEN 'BTN_MET_FAD'.
          wd_this->fire_on_btn_met_fad_evt( ).
          ">001< end +

        WHEN 'LTA_SCHICHT_SP'.
          wd_this->fire_show_popup_gen_table_evt( wd_this->mo_curr_arbstelle->get_schicht( ) ).

        WHEN 'LTA_FZGREF'.                     ">003< +
          wd_this->fire_on_btn_fzg_ref_evt( ). ">003< +
        WHEN OTHERS.

      ENDCASE.

    WHEN 'ON_TOGGLE'.

      CASE io_event->get_string( EXPORTING name = 'ID' ).
        WHEN 'CKB_MET_FAD'.
          wd_this->fire_select_ckb_met_fad_evt( ).

        WHEN 'CKB_MET_SED'.
          wd_this->fire_select_ckb_met_sed_evt( ).

      ENDCASE.
    WHEN OTHERS.
  ENDCASE.


ENDMETHOD.

METHOD z_pe_popin_jobliste .
  "zcl_ia_2utilities=>break_point( ).
  ##NEEDED DATA(lv_test) = io_event->get_name( ).
  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

    WHEN 'ON_ACTION'.

      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

        WHEN 'BTN_AUSPLANEN'.

          DATA: lo_auftrag  TYPE REF TO zcl_ia_2order,
                lt_jobliste TYPE wd_this->elements_jobliste.

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste ).

          READ TABLE lt_jobliste WITH KEY table_popin = 'TABLEPOPIN_JL' ASSIGNING FIELD-SYMBOL(<ls_jobliste>).

          CHECK <ls_jobliste> IS ASSIGNED.

          TRY .
              lo_auftrag = wd_this->mo_curr_arbstelle->get_auftrag( EXPORTING iv_key = <ls_jobliste>-aufnr ).

              wd_this->mo_curr_arbstelle->remove_auftrag_o( io_object = lo_auftrag ).

              wd_this->mo_curr_arbstelle->refresh_ausdehung( ).

              wd_this->mo_curr_arbstelle->get_schicht( )->save( ).

              wd_this->mo_message_manager->reset( ).
              wd_this->mo_message_manager->add_message( EXPORTING iv_msgid = 'ZIA_2_MMT'     " Nachrichtenidentifikation
                                                                  iv_msgno = '069'    " Nummer der System-Nachricht
                                                                  iv_msgty = 'S'    " SAP-Nachrichtentyp
                                                                  iv_msgv1 = lo_auftrag->get_data( )-aufnr
                                                                  iv_msgv2 = wd_this->mo_curr_arbstelle->get_kurztext( ) ).


              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_details )->invalidate( ).
              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_sitzplatz )->invalidate( ).
              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_fahrzeug )->invalidate( ).
              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_jobliste )->invalidate( ).
              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_jobpool )->invalidate( ).
              wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                       )->get_child_node( name = wd_this->wdctx_as_filter )->invalidate( ).

            CATCH zcx_ia_2failure INTO DATA(lx_err).
              wd_this->mo_message_manager->reset( ).
              wd_this->mo_message_manager->add_bapiret_t( it_table = lx_err->gt_bapiret ).
          ENDTRY.

          "Message ausgeben
          wd_this->mo_message_manager->display_messages( ).

          wd_this->mo_jobliste_filter_handle->apply_filter( ).

      ENDCASE.
  ENDCASE.

ENDMETHOD.

METHOD z_pe_popin_jobpool .
  "zcl_ia_2utilities=>break_point( ).
  ##NEEDED DATA(lv_test) = io_event->get_name( ).
  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

    WHEN 'ON_ACTION'.

      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID').

        ##NEEDED       WHEN 'BTN_AUFTRAG_EINPLANEN'.

        ##NEEDED       WHEN 'BTN_AUS_JOBPOOL_ENTFERNEN'.

      ENDCASE.
  ENDCASE.

ENDMETHOD.

METHOD z_pe_schichtdetails .
  DATA: ls_schichtdetails   TYPE wd_this->element_schichtdetails,
        ls_ui_arbeitsstelle TYPE wd_this->element_ui_arbeitsstelle ##NEEDED,
        ls_popup_gen_table  TYPE wd_this->element_popup_gen_table,
 ##NEEDED       ls_sp_details       TYPE wd_this->element_sp_details,
        ls_sitzplatz        TYPE zia_2_visquali_wd_s,
        li_window_manager   TYPE REF TO if_wd_window_manager,             ">001< ins
        li_api_component    TYPE REF TO if_wd_component.                  ">001< ins

  ##NEEDED DATA(lv_test) = io_event->get_name( ).
  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

    WHEN 'ON_ACTION'.
      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

        WHEN 'BTN_EDIT'.
          "Toggel Edit Mode => Sperren entsperren und so weiter
          DATA(li_ctx_element) = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_schichtdetails ).

          CASE ls_schichtdetails-edit_mode.
            WHEN abap_false.
              TRY .

                  zcl_ia_2context_helper=>unlock_previous_schicht( ii_context = wd_context ).
                  ls_schichtdetails-object->lock( ).
                  ls_schichtdetails-object->lock_sub_objects( iv_check = abap_false ).
                  ls_schichtdetails-edit_mode = abap_true.
                  ls_schichtdetails-design = 01.
                  wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_enabled ).
                CATCH zcx_ia_2failure INTO DATA(lx_fehler).
                  ls_schichtdetails-object->unlock( ).
                  ls_schichtdetails-object->unlock_sub_objects( ).
                  wd_this->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
                  wd_this->mo_message_manager->reset( ).
              ENDTRY.
            WHEN abap_true.
              ls_schichtdetails-object->unlock( ).
              ls_schichtdetails-object->unlock_sub_objects( ).
              ls_schichtdetails-edit_mode = abap_false.
              ls_schichtdetails-design = 00.
              wd_this->mo_ui_element_properties->set_ui_arbstelle_edit_mode( iv_edit_mode = zcl_ia_2ui_element_properties=>mc_is_not_enabled ).
          ENDCASE.

          li_ctx_element->set_static_attributes( static_attributes = ls_schichtdetails ).
          " ist auf der Arbeitsstelle der Button bearbeiten aktiv?
          "-------------------------------------
          " Test bearbeiten der Arbeitsstelle UI
          wd_context->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->get_static_attributes( IMPORTING static_attributes = ls_ui_arbeitsstelle ).
          wd_this->mo_ui_element_properties->set_ena_btn_as_edit( EXPORTING iv_data = abap_true ).
*          wd_this->mo_ui_element_properties->set_ui_arbstelle_visible( io_arbeitsstelle = wd_this->mo_curr_arbstelle  )."Arlene
          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->invalidate( ).
*       WHEN 'BTN_AS_EDIT'. " moved to CC_SCHDET_ARBST

        WHEN 'LTA_SP_ZEITEN'.
          "*******************
          "* Arbeitsstellendetails => Sperrabschnitte Kilometer und Zeiten
          "***************
          "ContextElement
          li_ctx_element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).

          "POPUP bei zusammengefassten Sperrabschnitten

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_details
                   )->get_child_node( name = wd_this->wdctx_sp_details )->set_lead_selection_index( index = li_ctx_element->get_index( ) ).

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_details
                   )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered )->invalidate( ).

          ls_popup_gen_table-title =  cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SIGNAL_SECTIONS_MAINTENANCE_AREAS' ). "Change >003<

          ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                                                               )->get_child_node( name = wd_this->wdctx_details
*                                                               )->get_child_node( name = wd_this->wdctx_sp_details
                                                               )->get_child_node( name = wd_this->wdctx_sp_ehb_filtered ).

          wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->set_static_attributes( static_attributes = ls_popup_gen_table ).

          li_api_component = wd_this->wd_get_api( ).                                            ">001< ins begin
          li_window_manager  = li_api_component->get_window_manager( ).
          wd_this->mo_current_popup = li_window_manager->create_window(
            window_name  = 'W_POPUP_GEN_TABLE'
            title        = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SIGNAL_SECTIONS_MAINTENANCE_AREAS' )  "Change >003<
            close_button = abap_false
            button_kind  = if_wd_window=>co_buttons_none ).


          wd_this->mo_current_popup->open( ).                                                   ">001< ins end

        WHEN 'BTN_FILTER'.
          DATA: lv_sichtbarkeit TYPE wdy_boolean ##NEEDED.

          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->get_attribute( EXPORTING name  = 'VIS_TCO_FILTER_DISTANZ' IMPORTING value = lv_sichtbarkeit ).
          "temporär wird Distanzfilter immer angezeigt

          wd_context->get_child_node( name = wd_this->wdctx_ui_visibility )->get_child_node( name = wd_this->wdctx_ui_arbeitsstelle )->set_attribute( EXPORTING value = abap_true name  = 'VIS_TCO_FILTER_DISTANZ' ).

          " Distanzwert initial befüllen
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_filter
                   )->get_child_node( name = wd_this->wdctx_jp_value_filter
                   )->get_child_node( name = wd_this->wdctx_jp_filter_icon )->set_attribute( EXPORTING value = 0 name  = 'DISTANZ_SUED' ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_filter
                   )->get_child_node( name = wd_this->wdctx_jp_value_filter
                   )->get_child_node( name = wd_this->wdctx_jp_filter_icon )->set_attribute( EXPORTING value = 0 name  = 'DISTANZ_NORD' ).


        WHEN 'LTA_AUFTRAG_JOBPOOL' OR 'LTA_AUFTRAG_JOBLISTE'.

          DATA: ls_auftrag TYPE zia_2_jobpool_wd_s.

          io_event->get_context_element( name = 'CONTEXT_ELEMENT'
                                                )->get_static_attributes( IMPORTING static_attributes = ls_auftrag ).

          wd_assist->webgui_simple_call_transaction( EXPORTING iv_tcode    = 'IW33'
                                                               iv_okcode   = '/0'
                                                               iv_parnam   = 'CAUFVD-AUFNR'
                                                               iv_parval   = CONV string( ls_auftrag-aufnr )
                                                               ii_comp_api = wd_this->wd_get_api( ) ).
        WHEN 'BTN_DREHBUECHER'.
          " Fehlerüberprüfungen z.B. SC ausgewählt, CPM
          " Bei GBT Tunnel Tremola-Berechnung
          wd_this->open_progress_window( ).

        WHEN 'BTN_SCRIPTS'.   " ths should be removed after form testing
          wd_this->open_progress_window( ).


        WHEN 'BTN_PO_DATEN'.

          DATA(lo_personenortung)  = NEW zcl_ia_2person_location( io_schicht = wd_this->mo_curr_arbstelle->get_schicht( ) ).
          lo_personenortung->invoke_webservice( CHANGING co_message_manager = wd_this->mo_message_manager ).
          wd_this->mo_message_manager->reset( ).
          " Prepare BAPIRET2 structure with message details
          DATA(ls_bapiret) = VALUE bapiret2(
*            id         = 'ZIA_2_REAL'
*            number     = iv_msgno
            type       = sy-msgty
            message_v1 = sy-msgv1
*            message_v2 = sy-msgv2
*            message_v3 = sy-msgv3
*            message_v4 = sy-msgv4
             ).

*          ls_bapiret-message = |{ sy-msgv1 }: { sy-msgv2 }{ sy-msgv3 }{ sy-msgv4 }|.
          ls_bapiret-message = |{ sy-msgv1 }: { lo_personenortung->gs_output-error }|.
          wd_this->mo_message_manager->add_bapiret( is_bapiret = ls_bapiret ).
          wd_this->mo_message_manager->display_messages( ).

        WHEN 'BTN_PO_LOG_DATEN'.
          "*******************
          "* Arbeitsstellendetails => Sperrabschnitte Kilometer und Zeiten
          "***************

          wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                   )->get_child_node( name = wd_this->wdctx_log_po_data )->invalidate( ).

          ls_popup_gen_table-title = 'PO LogDaten'.
          ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
                                                                                         )->get_child_node( name = wd_this->wdctx_log_po_data ).

          wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->set_static_attributes( static_attributes = ls_popup_gen_table ).

          wd_this->wd_get_api( )->get_window_manager( )->create_and_open_popup( window_name = 'W_POPUP_GEN_TABLE'
                                                                                buttons     = wd_this->wd_get_api( )->get_window_manager( )->get_buttons_close( ) ).

        WHEN 'LTA_VERSORGUNG_SCHICHT'.       ">001< + begin
          IF wd_this->mo_curr_arbstelle IS BOUND.
            wd_this->fire_on_lta_vers_schicht_evt( io_schicht = wd_this->mo_curr_arbstelle->get_schicht( ) ).
          ENDIF.                             ">001< + end

        WHEN 'BTN_MAT_TABLE_COLLAPSE'.              ">002< +
          wd_this->fire_on_mat_tab_collapse_evt( ). ">002< +
        WHEN 'BTN_MAT_TABLE_EXPAND'.                ">004< +
          wd_this->fire_on_mat_tab_expand_evt( ).   ">004< +
      ENDCASE.


    WHEN 'ON_TOGGLE'.
      CASE io_event->get_string( EXPORTING name = 'ID' ).
        WHEN 'CKB_CPM'.
          " hole Informationen über geklicktes element
          DATA(li_checked_element) =  io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).

          li_checked_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).
          ls_sitzplatz-object->set_cpm( iv_boolean = ls_sitzplatz-cpm ).
          ls_sitzplatz-object->save( ).

        WHEN 'CKB_SC'.
          " hole Informationen über geklicktes element
          li_checked_element =  io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).

          li_checked_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).
          ls_sitzplatz-object->set_sc( iv_boolean = ls_sitzplatz-sc ).
          ls_sitzplatz-object->save( ).

        WHEN 'CKB_THF'.
          " hole Informationen über geklicktes element
          li_checked_element =  io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).

          li_checked_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).
          ls_sitzplatz-object->set_thf( iv_boolean = ls_sitzplatz-thf ).
          ls_sitzplatz-object->save( ).

        WHEN 'CKB_BG'.
          " hole Informationen über geklicktes element
          li_checked_element =  io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).

          li_checked_element->get_static_attributes( IMPORTING static_attributes = ls_sitzplatz ).
          ls_sitzplatz-object->set_bg( iv_boolean = ls_sitzplatz-bg ).
          ls_sitzplatz-object->save( ).


        WHEN 'CKB_AS_FILTER_RJ'      OR
             'CKB_AS_FILTER_TS'      OR
             'CKB_AS_FILTER_LI'      OR  ">001< +
             'CKB_AS_FILTER_SCHIENE' OR
             'CKB_AS_FILTER_STRASSE'.

          wd_this->exc_on_as_filter( io_event ).

      ENDCASE.

    WHEN 'ON_SELECT'.
      CASE io_event->get_string( EXPORTING name = 'ID').

        WHEN 'RM_STATUS'.

          wd_this->exc_on_chng_schicht_status( ).

        WHEN OTHERS.

      ENDCASE.

    WHEN OTHERS.

  ENDCASE.
ENDMETHOD.

METHOD z_pe_schichtplan .
  DATA: ls_schichtplan     TYPE wd_this->element_schichtplan,
        ls_popup_gen_table TYPE wd_this->element_popup_gen_table.
  DATA li_ctx_element TYPE REF TO if_wd_context_element.


  ##NEEDED DATA(lv_test) = io_event->get_name( ).
  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

    WHEN 'ON_ACTION'.
      CASE wd_this->mo_event->get_string( EXPORTING name = 'ID').

        WHEN 'LTA_SCHICHT'.
          "Schicht als TAB hinzufügen
          li_ctx_element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).

          wd_this->open_schicht_tab( io_schicht = ls_schichtplan-object ).

        WHEN 'LTA_SCHICHT_SP'.
          "Popup W_POPUP_GEN_TABLE wird aufgerufen um alle Sperrabschnitte und Intervallarten der Schicht anzuzeigen---------------------
          wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->set_lead_selection( element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ) ).

          ls_popup_gen_table-node_to_schow_as_table = io_event->get_context_element( name = 'CONTEXT_ELEMENT' )->get_child_node( name = wd_this->wdctx_sp_intvart ).
          ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_this->wdctx_schichtplan
                                                                                         )->get_child_node( name = wd_this->wdctx_sp_intvart ).
          ls_popup_gen_table-title = 'Blocked Sections'.

          wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->set_static_attributes( static_attributes = ls_popup_gen_table ).

          wd_this->wd_get_api( )->get_window_manager( )->create_and_open_popup( window_name = 'W_POPUP_GEN_TABLE'
                                                                                buttons     = wd_this->wd_get_api( )->get_window_manager( )->get_buttons_close( ) ).


        WHEN 'LTA_START'.
          li_ctx_element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          li_ctx_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
          ls_schichtplan-object->start_auto_planning( iv_perimeter = ls_schichtplan-zzperi ).
          li_ctx_element->get_child_node( name = wd_this->wdctx_arbstellen )->invalidate( ).
          wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
          wd_this->mo_message_manager->reset( ).
          "display_messages( ).

        WHEN 'LTA_BEMERKUNGEN'.
          wd_this->gv_notes_popup_from_schicht_dt = abap_false. ">001<  +
          li_ctx_element = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
          wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->set_lead_selection_index( index = li_ctx_element->get_index( ) ).
          wd_context->get_child_node( name = wd_this->wdctx_popup_bemerkung )->invalidate( ).

          wd_this->wd_get_api( )->get_window_manager( )->create_and_open_popup( window_name = 'W_POPUP_BEMERKUNG'
                                                                                title       = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS' )
                                                                                buttons     = wd_this->wd_get_api( )->get_window_manager( )->get_buttons_close( ) ).

      ENDCASE.

    WHEN  'ON_TOGGLE'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'CKB_RI' OR
             'CKB_JI' OR
             'CKB_TS' OR
             'CKB_LI' OR
             'CKB_TI'.
          wd_this->mo_cc_schichtplan->exc_on_filter( ).
      ENDCASE.

    WHEN OTHERS.

  ENDCASE.
ENDMETHOD.

METHOD z_pe_uebersicht .
  DATA: ls_date_nav           TYPE wd_this->element_date_navigator,
        ls_date_navigator     TYPE wd_this->element_date_navigator_gbt,
        ls_interface_to_param TYPE wd_this->element_interface_to_param,
        ls_date_nav_perim     TYPE zia_2_date_nav_perim_s.

  wd_this->mo_event = io_event.
  wd_this->mv_current_action_event = wd_this->mo_event->get_string( EXPORTING name = 'ID' ).

  CASE wd_this->mo_event->get_name( ).

      "*******************
      "* DateNavigation
      " ***************
    WHEN 'ON_DAY_SELECT' OR 'ON_MONTH_SELECT' OR 'ON_WEEK_SELECT'.
      zcl_ia_2context_helper=>unlock_previous_schicht( ii_context = wd_context ).
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
      ls_date_nav-last_klicked_calender = io_event->get_string( EXPORTING name = 'ID' ).
      ls_date_nav-perimeter = ls_date_nav-last_klicked_calender+15(3).
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->set_static_attributes( ls_date_nav ).
*      ToDo Context Invalidierung

*      Jobpool mittels selektiertem Kalnder neu filtern
      wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
      wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->invalidate( ).


    WHEN 'ON_START_DATE_CHANGED'.
      zcl_ia_2context_helper=>unlock_previous_schicht( ii_context = wd_context ).
      wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
      ls_date_nav-last_klicked_calender = io_event->get_string( EXPORTING name = 'ID' ).
      ls_date_nav-perimeter = ls_date_nav-last_klicked_calender+15(3).

      CASE ls_date_nav-perimeter.
        WHEN 'GBT'.
          wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_gbt )->get_child_node( name = wd_this->wdctx_markings_gbt )->invalidate( ).
        WHEN 'CBT'.
          wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_cbt )->get_child_node( name = wd_this->wdctx_markings_cbt )->invalidate( ).
      ENDCASE.

    WHEN 'ON_ACTION'.

      CASE io_event->get_string( EXPORTING name = 'ID').

        WHEN 'LTA_STD_PARAMETER'.

          wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
          CLEAR: ls_interface_to_param-schicht_id, ls_interface_to_param-object.
          ls_interface_to_param-zzperi = ls_date_nav-perimeter.
          ls_interface_to_param-show_standard = abap_false.

          wd_context->get_child_node( name = wd_this->wdctx_interface_to_param )->get_element( )->set_static_attributes( static_attributes = ls_interface_to_param ).

          IF wd_this->wd_cpuse_parameter( )->has_active_component( ) IS INITIAL. wd_this->wd_cpuse_parameter( )->create_component( ). ENDIF.
*          Standardparameter sperren
          DATA(lo_schichtparameter) = NEW zcl_ia_2parameter( iv_perimeter = CONV zia_2_perimeters( ls_date_nav-perimeter ) ).
          TRY.
              lo_schichtparameter->lock_std( iv_perimeter = CONV zia_2_perimeters( ls_date_nav-perimeter ) ).
              wd_this->wd_get_api( )->get_window_manager( )->create_window_for_cmp_usage( interface_view_name  = 'W_MAIN'
                                                                            component_usage_name = 'PARAMETER'
                                                                            title                = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/STANDARDPARAMETER'  ) )->open( ).
            CATCH zcx_ia_2failure INTO DATA(lx_fehler).
              wd_this->mo_message_manager->display_exception( ix_fehler = lx_fehler ).
              wd_this->mo_message_manager->reset( ).

          ENDTRY.

        WHEN 'BTC_REFRESH_JOBPOOL'.

          wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
          zcl_ia_2order=>priorisiere_auftraege( iv_perimeter = CONV zia_2_perimeters( ls_date_nav-perimeter ) ).
          wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).


        WHEN 'BTN_GANTT'.
          wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
          CASE ls_date_nav-perimeter.
            WHEN 'GBT'.
              wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_gbt )->get_static_attributes(  IMPORTING static_attributes = ls_date_navigator ).
            WHEN 'CBT'.
              wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_child_node( name = wd_this->wdctx_date_navigator_cbt )->get_static_attributes(  IMPORTING static_attributes = ls_date_navigator ).
          ENDCASE.
          ls_date_nav_perim           = CORRESPONDING #( ls_date_navigator ).
          ls_date_nav_perim-perimeter = ls_date_nav-perimeter.
          wd_this->fire_on_btn_gantt_evt( EXPORTING is_data = ls_date_nav_perim ).

      ENDCASE.

    WHEN 'ON_TOGGLE'.

      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'CB_BY_DATUM'.
          wd_context->get_child_node( name = wd_this->wdctx_auftraege
                   )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
        WHEN 'CBG_INTERVALLE'.
          wd_context->get_child_node( name = wd_this->wdctx_auftraege
                   )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
      ENDCASE.

    WHEN 'ON_SELECT'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'RB_SELECTION'.
          wd_context->get_child_node( name = wd_this->wdctx_auftraege
                  )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).
      ENDCASE.

      "*******************
      "* ALV Funktion / Cell Actions
      "***************
    WHEN 'ON_FUNCTION'.

      DATA lo_alv_table_fct TYPE REF TO cl_salv_wd_table_function.
      lo_alv_table_fct ?= io_event->get_object( name = 'R_PARAM' ).

      CASE lo_alv_table_fct->if_salv_wd_table_event~cmp_usage_name.
        WHEN 'ALV_AUFTRAEGE'.

          CASE lo_alv_table_fct->if_salv_wd_table_function~id.
            WHEN 'BTN_REM_AUF'.
              DATA: ls_auftrag     TYPE wd_this->element_auftraege_alv.

              "Selektiertes Element suchen
              DATA(li_lead_selection) = wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->get_lead_selection( ).

              IF li_lead_selection IS NOT INITIAL.
                li_lead_selection->get_static_attributes( IMPORTING static_attributes = ls_auftrag ).

                TRY .
                    zcl_ia_2order=>remove_from_jobpool( EXPORTING iv_aufnr           = ls_auftrag-aufnr
                                                                  iv_objnr           = ls_auftrag-objnr
                                                                  io_message_manager = wd_this->mo_message_manager
                                                                 ).
                    wd_this->mo_message_manager->add_message( EXPORTING iv_msgid = 'ZIA_2_REAL' iv_msgno = '020' iv_msgty = 'S' iv_msgv1 = ls_auftrag-aufnr ).
                    wd_this->mo_message_manager->display_messages( ).
                    wd_this->mo_message_manager->reset( ).
                    "Jobpool
                    wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).

                  CATCH zcx_ia_2failure INTO lx_fehler.    "
                    wd_this->mo_message_manager->add_bapiret_t( it_table = lx_fehler->get_bapiret( ) ).
                    wd_this->mo_message_manager->display_messages( ).
                    wd_this->mo_message_manager->reset( ).

                ENDTRY.

              ENDIF.

            WHEN 'BTN_AKT_JOBPOOL'.  "ALV Jobpool => Button Jobpool aktualisieren
              wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).
              zcl_ia_2order=>priorisiere_auftraege( iv_perimeter = CONV zia_2_perimeters( ls_date_nav-perimeter ) ).
              wd_context->get_child_node( name = wd_this->wdctx_auftraege )->get_child_node( name = wd_this->wdctx_auftraege_alv )->invalidate( ).

            WHEN: 'BTN_ARBST_ANLEGEN'.  "ALV Jobpool => Button Arbeitsstelle anlegen

              wd_this->arbst_anlegen( ).


          ENDCASE.

      ENDCASE.


    WHEN 'ON_CELL_ACTION'.

      "*******************
      "* HTML GUI IW33 Auftragsanzeige
      "***************
      DATA lo_alv_cell_act TYPE REF TO cl_salv_wd_table_cell_action.
      lo_alv_cell_act ?= io_event->get_object( name = 'R_PARAM' ).

      CASE lo_alv_cell_act->if_salv_wd_table_cell_action~column.
        WHEN 'AUFNR'.
          ASSIGN lo_alv_cell_act->if_salv_wd_table_cell_action~value->* TO FIELD-SYMBOL(<lv_value>).

          wd_assist->webgui_simple_call_transaction( EXPORTING iv_tcode    = 'IW33'
                                                               iv_okcode   = '/0'
                                                               iv_parnam   = 'CAUFVD-AUFNR'
                                                               iv_parval   = CONV string( <lv_value> )
                                                               ii_comp_api = wd_this->wd_get_api( ) ).
        WHEN 'ZZEST'.
*          "*******************
*          "* Für einen Auftrag aus dem Jobpool will ich die Sperrabschnitte anzeigen
*          "***************
          wd_context->get_child_node( name = wd_this->wdctx_auftraege
                   )->get_child_node( name = wd_this->wdctx_signalabschnitte
                   )->invalidate( ).

          wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_auftraege_alv
           )->set_lead_selection_index( index = lo_alv_cell_act->if_salv_wd_table_cell_action~index ).

          DATA: ls_popup_gen_table       TYPE wd_this->element_popup_gen_table.
          ls_popup_gen_table-title = 'Signal sections for order'.
          ls_popup_gen_table-node_to_schow_as_table = wd_context->get_child_node( name = wd_this->wdctx_auftraege
                                                               )->get_child_node( name = wd_this->wdctx_signalabschnitte
                                                               ).
*
          wd_context->get_child_node( name = wd_this->wdctx_popup_gen_table )->set_static_attributes( static_attributes = ls_popup_gen_table ).

          wd_this->wd_get_api( )->get_window_manager( )->create_and_open_popup( window_name = 'W_POPUP_GEN_TABLE'
                                                                                buttons     = wd_this->wd_get_api( )->get_window_manager( )->get_buttons_close( ) ).



      ENDCASE.
  ENDCASE.

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD catch_timed_trigger .

  TRY .
      DATA(lo_schicht) = wd_this->mo_curr_arbstelle->get_schicht( ).
    CATCH cx_sy_ref_is_initial.
      RETURN.
  ENDTRY.

  IF wd_this->mi_db_generator IS INITIAL.
    TRY.
        wd_this->mi_db_generator = zcl_ia_2db_factory_a=>get_generator( io_schicht = lo_schicht ).

      CATCH zcx_ia_2failure INTO DATA(lx_error).
        wd_this->mo_message_manager->reset( ).
        wd_this->mo_message_manager->add_bapiret_t( it_table = lx_error->gt_bapiret ).
        wd_this->mo_message_manager->display_messages( ).
        wd_this->gv_db_gen_action_start = abap_true.
        CLEAR: wd_this->mi_db_generator.
        wd_this->mo_progress_window->close( ).
        RETURN.

    ENDTRY.
  ENDIF.

  IF wd_this->mi_db_generator->is_done( ).
    wd_this->drehbuch_gen_finish( ).

  ELSE.
    wd_this->drehbuch_gen_do_work( ).

  ENDIF.
ENDMETHOD.

METHOD catch_window_close .

  DATA:  lt_text TYPE string_table.


  wd_this->open_pop_up(
    EXPORTING
      it_text         = lt_text
      iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SCRIPTS_GENERATED_SUCCESSFULLY' )
      iv_btn_action   = 'GET_ZIP_AS_RESPONSE'
      iv_btn_text     = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/OK_BUTTON' )
  ).


ENDMETHOD.

 METHOD on_dispo_changed.
   DATA(lt_tab_schichten) = VALUE wd_this->elements_tabs_schichten( ).
   DATA lo_arbstelle_i      TYPE REF TO cl_object_collection_iterator.
   DATA lo_arbstelle        TYPE REF TO zcl_ia_2wrkplace.


   wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_static_attributes_table( IMPORTING table = lt_tab_schichten ).

   IF io_schicht IS BOUND.            "reload entire schicht
     TRY.
         DATA(lo_schicht) = lt_tab_schichten[ zschicht = io_schicht->get_data( )-zschicht ]-object ##WARN_OK.
         wd_this->reload_schicht( lo_schicht ).
         RETURN.
       CATCH cx_sy_itab_line_not_found.
         RETURN.
     ENDTRY.
   ENDIF.


   IF io_arbstl IS BOUND.              "reload only arbeitsstelle - better for a performance
     LOOP AT lt_tab_schichten ASSIGNING FIELD-SYMBOL(<ls_tab_schichten>).
       lo_arbstelle_i  = CAST #( <ls_tab_schichten>-object->get_arbeitsstellen( )->get_values_iterator( ) ).
       WHILE lo_arbstelle_i->has_next( ) = abap_true.
         lo_arbstelle = CAST #( lo_arbstelle_i->get_next( ) ).
         CHECK io_arbstl->get_data( )-zarbstl = lo_arbstelle->get_data( )-zarbstl.
         lo_arbstelle->reload( ).
         DATA(lv_reloaded) = abap_true.
       ENDWHILE.
       CHECK lv_reloaded = abap_true.
       EXIT.
     ENDLOOP.
   ENDIF.

 ENDMETHOD.

METHOD on_dispo_lta_rbt_schicht .
  IF io_schicht IS NOT BOUND.
    RETURN.
  ENDIF.

  "Open Schicht tab
  TRY.
      zcl_ia_2context_helper=>add_schicht_tab(
        EXPORTING
          io_schicht = io_schicht
        CHANGING
          ci_context = wd_context ).
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.

ENDMETHOD.

METHOD on_schicht_tab_deleted .
  wd_this->popin_aufnr_release( ).
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_arbstellen .
  DATA: lt_arbstellen    TYPE wd_this->elements_arbstellen,
        ls_schichtplan   TYPE wd_this->element_schichtplan,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
        lt_arbstellen_wd TYPE zia_2_work_area_wd_t,
 ##NEEDED       lv_id_btg        TYPE zia_2_id_btg.

  DATA: lv_last_line    TYPE i VALUE 700.

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
  lo_arbstelle_i ?= ls_schichtplan-object->get_arbeitsstellen( )->get_values_iterator( ).

**  SELECT DISTINCT zid_btg, zindex,    zzperi
**    FROM zia_2building
**    INTO TABLE @DATA(lt_gebaeude).

  DATA(lt_gebaeude) = wd_assist->get_buildings( ) ##NEEDED.

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).
    APPEND INITIAL LINE TO lt_arbstellen_wd ASSIGNING FIELD-SYMBOL(<ls_arbstellen_wd>).
    ##NEEDED   DATA(lv_perim) = lo_arbstelle->get_schicht( )->get_data( )-zzperi.
    <ls_arbstellen_wd>-color = lo_arbstelle->get_color( ).
    ##NEEDED   <ls_arbstellen_wd>-zkmin = lo_arbstelle->get_data( )-zkmin.
    <ls_arbstellen_wd>-zkmax = lo_arbstelle->get_data( )-zkmax.

    IF lo_arbstelle->is_btg( IMPORTING ev_id_btg  = lv_id_btg ) = abap_true.
      DATA(ls_gebaeude) = VALUE #( lt_gebaeude[ zid_btg = lv_id_btg zzperi = lv_perim  ] OPTIONAL ).
*      DATA(lv_zktext) = COND #( WHEN syst-langu = 'I' THEN ls_gebaeude-zindex ELSE ls_gebaeude-zindex ).
      DATA(lv_zktext) =  ls_gebaeude-zktext.
      <ls_arbstellen_wd>-tooltip = | Workarea { lo_arbstelle->get_kurztext( ) }, { lv_zktext }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.
*      <ls_arbstellen_wd>-tooltip = | Workarea { lo_arbstelle->get_kurztext( ) }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.
      CONTINUE.
    ENDIF.

    <ls_arbstellen_wd>-tooltip = | Workarea { lo_arbstelle->get_kurztext( ) }, Kilometer { <ls_arbstellen_wd>-zkmin } bis { <ls_arbstellen_wd>-zkmax }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.
  ENDWHILE.

**************************************************************************************************************
* Visualisierung
**************************************************************************************************************
  LOOP AT lt_arbstellen_wd ASSIGNING <ls_arbstellen_wd>.
    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstellen>).
    " Strich
    <ls_arbstellen>-length = 10.
    <ls_arbstellen>-color = 'grey.png'.
    <ls_arbstellen>-height = 1.

    " Arbeitsstelle
    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING <ls_arbstellen>.
    MOVE-CORRESPONDING <ls_arbstellen_wd> TO <ls_arbstellen>.
    <ls_arbstellen>-length = 10.
    <ls_arbstellen>-height = 10.

    lv_last_line = lv_last_line - 30.

    AT LAST.
      " Strich
      APPEND INITIAL LINE TO lt_arbstellen ASSIGNING <ls_arbstellen>.
      <ls_arbstellen>-length = lv_last_line.
      <ls_arbstellen>-color = 'grey.png'.
      <ls_arbstellen>-height = 1.

    ENDAT.
  ENDLOOP.


  node->bind_table( new_items            = lt_arbstellen
                    set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_arbst_osn .
  DATA: lt_arbst_osn     TYPE wd_this->elements_arbst_osn,
        lt_arbstellen    TYPE wd_this->elements_arbst_osn,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace.

*  APPEND INITIAL LINE TO lt_arbst_osn ASSIGNING FIELD-SYMBOL(<ls_arbst_osn>).
  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).


  "*******************
  "* Begin Hole passende Arbeitsstellen
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    "Muss neuimplementiert werden
    CHECK lo_arbstelle->is_in_os_nord( ) EQ abap_true.
    CHECK lo_arbstelle->is_btg( ) EQ abap_false.  "=> Mal als Test, sodass ich die BTG Arbeitsstelle nicht als OS ARBST Visualisiere

    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstellen>).

    MOVE-CORRESPONDING lo_arbstelle->get_data( ) TO <ls_arbstellen>.
    <ls_arbstellen>-object = lo_arbstelle.

  ENDWHILE.

  DATA(lv_counter) = lines( lt_arbstellen ).
*  DESCRIBE TABLE lt_arbstellen LINES DATA(lv_counter).

  IF lv_counter NE 0.
    LOOP AT lt_arbstellen ASSIGNING <ls_arbstellen>.
      APPEND INITIAL LINE TO lt_arbst_osn ASSIGNING FIELD-SYMBOL(<ls_arbst_osn>).
      " Strich
      <ls_arbst_osn>-length = 4.
      <ls_arbst_osn>-color = 'grey.png'.
      <ls_arbst_osn>-height = 1.
      <ls_arbst_osn>-is_visible = abap_true.

      " Arbeitsstelle
      APPEND INITIAL LINE TO lt_arbst_osn ASSIGNING <ls_arbst_osn>.
      MOVE-CORRESPONDING <ls_arbstellen> TO <ls_arbst_osn>.
      <ls_arbst_osn>-length = 10.
      <ls_arbst_osn>-height = 10.
*      <ls_arbst_osn>-color = 'grey.png'.
      <ls_arbst_osn>-color = <ls_arbstellen>-object->get_color( ).

      <ls_arbst_osn>-is_visible = abap_true.
      <ls_arbst_osn>-is_as = abap_true.
      "<ls_arbst_osn>-tooltip = <ls_arbstellen>-object->get_kurztext( ).  ">001< (-)
      <ls_arbst_osn>-tooltip = | Arbeitsstelle { <ls_arbstellen>-object->get_kurztext( ) }, Kilometer { <ls_arbstellen>-zkmin } bis { <ls_arbstellen>-zkmax }, Id { <ls_arbstellen>-object->get_id( ) ALPHA = OUT }|. ">001< (+)

      AT LAST.
        " Strich
        APPEND INITIAL LINE TO lt_arbst_osn ASSIGNING <ls_arbst_osn>.
        <ls_arbst_osn>-length = 304 - 30 * lv_counter.
        <ls_arbst_osn>-color = 'grey.png'.
        <ls_arbst_osn>-height = 1.
        <ls_arbst_osn>-is_visible = abap_true.
      ENDAT.
    ENDLOOP.
  ELSE.
    " Strich
    APPEND INITIAL LINE TO lt_arbst_osn ASSIGNING <ls_arbst_osn>.
    <ls_arbst_osn>-length = 304.
    <ls_arbst_osn>-color = 'grey.png'.
    <ls_arbst_osn>-height = 1.
    <ls_arbst_osn>-is_visible = abap_true.
  ENDIF.

  node->bind_table( new_items            = lt_arbst_osn
                    set_initial_elements = abap_true ).

  READ TABLE lt_arbst_osn WITH KEY is_as = abap_true TRANSPORTING NO FIELDS.
  IF syst-subrc = 0.
    node->set_lead_selection_index( index = 2 ).
  ENDIF.
ENDMETHOD.

METHOD supply_arbst_oss .
  DATA: lt_arbst_oss     TYPE wd_this->elements_arbst_oss,
        lt_arbstellen    TYPE wd_this->elements_arbst_oss,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace.

*  APPEND INITIAL LINE TO lt_arbst_oss ASSIGNING FIELD-SYMBOL(<ls_arbst_oss>).
  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).


  "*******************
  "* Begin Hole passende Arbeitsstellen
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    CHECK lo_arbstelle->is_in_os_sued( ).

    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstellen>).
    MOVE-CORRESPONDING lo_arbstelle->get_data( ) TO <ls_arbstellen>.
    <ls_arbstellen>-object = lo_arbstelle.


  ENDWHILE.

  DATA(lv_counter) = lines( lt_arbstellen ).
*   DESCRIBE TABLE lt_arbstellen LINES DATA(lv_counter).

  IF lv_counter NE 0.
    LOOP AT lt_arbstellen ASSIGNING <ls_arbstellen>.
      APPEND INITIAL LINE TO lt_arbst_oss ASSIGNING FIELD-SYMBOL(<ls_arbst_oss>).
      " Strich
      <ls_arbst_oss>-length = 4.
      <ls_arbst_oss>-color = 'grey.png'.
      <ls_arbst_oss>-height = 1.
      <ls_arbst_oss>-is_visible = abap_true.

      " Arbeitsstelle
      APPEND INITIAL LINE TO lt_arbst_oss ASSIGNING <ls_arbst_oss>.
      MOVE-CORRESPONDING <ls_arbstellen> TO <ls_arbst_oss>.
      <ls_arbst_oss>-length = 10.
      <ls_arbst_oss>-height = 10.
      <ls_arbst_oss>-color = <ls_arbstellen>-object->get_color( ).
*      <ls_arbst_oss>-color = 'grey.png'.
      <ls_arbst_oss>-is_visible = abap_true.
      <ls_arbst_oss>-is_as = abap_true.
      "<ls_arbst_oss>-tooltip = <ls_arbstellen>-object->get_kurztext( ). ">001< (-)
      <ls_arbst_oss>-tooltip = | Arbeitsstelle { <ls_arbstellen>-object->get_kurztext( ) }, Kilometer { <ls_arbstellen>-zkmin } bis { <ls_arbstellen>-zkmax }, Id { <ls_arbstellen>-object->get_id( ) ALPHA = OUT }|. ">001< (+)


      AT LAST.
        " Strich
        APPEND INITIAL LINE TO lt_arbst_oss ASSIGNING <ls_arbst_oss>.
        <ls_arbst_oss>-length = 304 - 30 * lv_counter.
        <ls_arbst_oss>-color = 'grey.png'.
        <ls_arbst_oss>-height = 1.
        <ls_arbst_oss>-is_visible = abap_true.
      ENDAT.
    ENDLOOP.
  ELSE.
    " Strich
    APPEND INITIAL LINE TO lt_arbst_oss ASSIGNING <ls_arbst_oss>.
    <ls_arbst_oss>-length = 304.
    <ls_arbst_oss>-color = 'grey.png'.
    <ls_arbst_oss>-height = 1.
    <ls_arbst_oss>-is_visible = abap_true.
  ENDIF.

  node->bind_table( new_items            = lt_arbst_oss
                    set_initial_elements = abap_true ).

  READ TABLE lt_arbst_oss WITH KEY is_as = abap_true TRANSPORTING NO FIELDS.
  IF syst-subrc = 0.
    node->set_lead_selection_index( index = 2 ).
  ENDIF.

ENDMETHOD.

METHOD supply_arbst_tunnel .
  DATA: lt_arbst_tunnel  TYPE wd_this->elements_arbst_tunnel,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
        lt_arbstellen    TYPE wd_this->elements_arbst_tunnel.

  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).

  "*******************
  "* Hier werden jetzt die Arbeitsstellen aufbereitet
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).
  zcl_ia_2utilities=>break_point( ).
  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    CHECK lo_arbstelle->is_in_tunnel( ) EQ abap_true.
    CHECK lo_arbstelle->is_btg( ) EQ abap_false.

    APPEND INITIAL LINE TO lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstellen>).
    MOVE-CORRESPONDING lo_arbstelle->get_data( ) TO <ls_arbstellen>.
    <ls_arbstellen>-object = lo_arbstelle.

  ENDWHILE.

  "*******************
  "* Begin BoxIndex ermitteln
  "***************
  DATA(lv_perim) = lo_arbstelle->get_schicht( )->get_data( )-zzperi.

  CASE lv_perim .
    WHEN 'GBT'.
      LOOP AT lt_arbstellen ASSIGNING FIELD-SYMBOL(<ls_arbstelle>).
*--> Begin Change >002<
        IF lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w  OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w1 OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w2 OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w3.
*--> End Change >002<

*          DATA(lv_calc_zkmin) = COND #( WHEN <ls_arbstelle>-zkmin < '199.801' THEN '199.801' ELSE <ls_arbstelle>-zkmin ).
*          DATA(lv_calc_zkmax) = COND #( WHEN <ls_arbstelle>-zkmax > '256.817' THEN '256.817' ELSE <ls_arbstelle>-zkmax ).
*          "<ls_arbstelle>-box_index = ( ( ( <ls_arbstelle>-zkmax + <ls_arbstelle>-zkmin ) / 2 ) - '199.801' ) / '2.591'.
*          DATA(lv_position) = ( ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '199.801' ).
*          <ls_arbstelle>-box_index = COND #( WHEN lv_position < 0 THEN 1 ELSE lv_position  / '2.591' ).

***          DATA(lv_calc_zkmin) = COND #( WHEN <ls_arbstelle>-zkmin < '199.801' ##LITERAL
***                                          THEN '199.801' ##LITERAL
***                                          ELSE <ls_arbstelle>-zkmin ).
          DATA(lv_calc_zkmin) = COND #( WHEN <ls_arbstelle>-zkmin < CONV zia_2_km_von( '199.801' )  ##LITERAL
                                          THEN CONV zia_2_km( '199.801' )  ##LITERAL
                                          ELSE <ls_arbstelle>-zkmin ).
***          DATA(lv_calc_zkmax) = COND #( WHEN <ls_arbstelle>-zkmax > '256.817' ##LITERAL
***                                          THEN '256.817' ##LITERAL
***                                          ELSE <ls_arbstelle>-zkmax ).
          DATA(lv_calc_zkmax) = COND #( WHEN <ls_arbstelle>-zkmax > CONV zia_2_km_bis( '256.817' ) ##LITERAL
                                           THEN CONV zia_2_km( '256.817' ) ##LITERAL
                                           ELSE <ls_arbstelle>-zkmax ).
          ##LITERAL         DATA(lv_position) = ( ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '199.801' ).
          ##LITERAL         <ls_arbstelle>-box_index = COND #( WHEN lv_position < 0 THEN 1 ELSE lv_position  / '2.591' ).

          ">001<  begin
          DATA(lt_map_sp) = <ls_arbstelle>-object->get_map_sp_as( ).
          LOOP AT lt_map_sp ASSIGNING FIELD-SYMBOL(<ls_map_sp>) WHERE sperrabschnitt CS 'S'. "#EC CI_NESTED "#EC CI_STDSEQ
            <ls_arbstelle>-is_as_portal_ws = abap_true.
            EXIT.
          ENDLOOP.
          ">001<  end

        ELSE.
          lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin < '99.728'  ##LITERAL
                                    THEN '99.728' ##LITERAL
                                    ELSE <ls_arbstelle>-zkmin ).
          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax > '156.831'   ##LITERAL
                                    THEN '156.831'  ##LITERAL
                                    ELSE <ls_arbstelle>-zkmax ).
*          <ls_arbstelle>-box_index  = ( ( ( ( <ls_arbstelle>-zkmax + <ls_arbstelle>-zkmin ) / 2 ) - '99.728' ) / '2.591' ) .
          ##LITERAL         lv_position = ( ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '99.728' ).
          ##LITERAL         <ls_arbstelle>-box_index  = COND #( WHEN lv_position < 0 THEN 1 ELSE lv_position  / '2.591' ).
        ENDIF.
      ENDLOOP.

    WHEN 'CBT'.
      LOOP AT lt_arbstellen ASSIGNING <ls_arbstelle>.
*--> Begin Change >002<
        IF lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w  OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w1 OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w2 OR
           lo_arbstelle->get_schicht( )->get_rj_est( ) = zif_ia_2_constant=>mc_sperrabs-w3.
*--> End Change >002<
*          lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin < CONV zia_2_km( '327.49' ) THEN CONV zia_2_km( '327.49' ) ELSE <ls_arbstelle>-zkmin ).
          ##LITERAL         lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin <  '327.49' THEN  '327.49' ELSE <ls_arbstelle>-zkmin ).
*          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax > CONV zia_2_km( '342.8' ) THEN CONV zia_2_km( '342.8' ) ELSE <ls_arbstelle>-zkmax ).
          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax >  '342.8' ##LITERAL
                                    THEN  '342.8' ##LITERAL
                                    ELSE <ls_arbstelle>-zkmax ).
          lv_position = (
                          ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '327.49'  ##LITERAL
                        ).
          <ls_arbstelle>-box_index  = COND #( WHEN lv_position < 0
                                              THEN 1
                                              ELSE lv_position  / '0.701' ##LITERAL
                                             ).
        ELSE.
*          lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin < CONV zia_2_km( '227.51' ) THEN CONV zia_2_km( '227.51' ) ELSE <ls_arbstelle>-zkmin ).
*          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax > CONV zia_2_km( '242.95' ) THEN CONV zia_2_km( '242.95' ) ELSE <ls_arbstelle>-zkmax ).
*          lv_position = ( ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '227.51' ).
*          <ls_arbstelle>-box_index = COND #( WHEN lv_position < 0 THEN 1 ELSE lv_position  / '0.701' ).
          lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin < CONV zia_2_km( '227.51' ) THEN CONV zia_2_km( '227.51' ) ELSE <ls_arbstelle>-zkmin ).
          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax > CONV zia_2_km( '242.95' ) THEN CONV zia_2_km( '242.95' ) ELSE <ls_arbstelle>-zkmax ).
*          <ls_arbstelle>-box_index  = ( ( ( ( <ls_arbstelle>-zkmax + <ls_arbstelle>-zkmin ) / 2 ) -  CONV zio_km( '227.51' ) ) / '0.701' ).
          lv_calc_zkmin = COND #( WHEN <ls_arbstelle>-zkmin <  '227.51' ##LITERAL
                                    THEN  '227.51' ##LITERAL
                                    ELSE <ls_arbstelle>-zkmin ).
          lv_calc_zkmax = COND #( WHEN <ls_arbstelle>-zkmax >  '242.95' ##LITERAL
                                    THEN  '242.95' ##LITERAL
                                    ELSE <ls_arbstelle>-zkmax ).
          ##LITERAL         lv_position = ( ( ( lv_calc_zkmax + lv_calc_zkmin ) / 2 ) - '227.51' ).
          ##LITERAL         <ls_arbstelle>-box_index = COND #( WHEN lv_position < 0 THEN 1 ELSE lv_position  / '0.701' ).
        ENDIF.
      ENDLOOP.

  ENDCASE.


  SORT lt_arbstellen BY zkmin ASCENDING.

  DATA(lv_counter) = lines( lt_arbstellen ).
*  DESCRIBE TABLE lt_arbstellen LINES DATA(lv_counter).

  IF lv_counter NE 0.
    CLEAR: lv_counter.
    DATA(lv_loop_counter) = 0.
    DATA(lv_rest_laenge) = 0.

    LOOP AT lt_arbstellen ASSIGNING <ls_arbstellen>.

      IF <ls_arbstellen>-is_as_portal_ws = abap_false. ">001< (+)

        "zwischen dem Loopcounter und dem Boxindex kommt ein Strich
        APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING FIELD-SYMBOL(<ls_arbst_tunnel>).
        " Strich
        <ls_arbst_tunnel>-length = 4 + 30 * ( <ls_arbstellen>-box_index - lv_loop_counter ).  "
        <ls_arbst_tunnel>-color = 'grey.png'.

        <ls_arbst_tunnel>-height = 1.
        <ls_arbst_tunnel>-is_visible = abap_true.

        lv_rest_laenge = lv_rest_laenge + <ls_arbst_tunnel>-length + 8.

        " Arbeitsstelle
        APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING <ls_arbst_tunnel>.
        <ls_arbstellen>-length = 10.
        lv_rest_laenge = lv_rest_laenge + 10 + 8.

****      <ls_arbstellen>-tooltip = | Arbeitsstelle { <ls_arbstellen>-object->get_kurztext( ) }, Kilometer { <ls_arbstellen>-zkmin - 100 } bis { <ls_arbstellen>-zkmax - 100 }, (Auslastung: { <ls_arbstellen>-object->get_auslastung( ) }%) |.
**** Es gehl noch die Auslastung
        "<ls_arbstellen>-tooltip = | Arbeitsstelle { <ls_arbstellen>-object->get_kurztext( ) }, Kilometer { <ls_arbstellen>-zkmin } bis { <ls_arbstellen>-zkmax }, (Auslastung: xxx%) |.  ">003< (-)
        <ls_arbstellen>-tooltip = | Arbeitsstelle { <ls_arbstellen>-object->get_kurztext( ) }, Kilometer { <ls_arbstellen>-zkmin } bis { <ls_arbstellen>-zkmax }, Id { <ls_arbstellen>-object->get_id( ) ALPHA = OUT }|.  ">003< (+)
        <ls_arbstellen>-height = 10.

        <ls_arbstellen>-is_visible = abap_true.
        <ls_arbstellen>-is_as = abap_true.

        lv_counter = lv_counter + 1.
        lv_loop_counter = <ls_arbstellen>-box_index + 1.

****************      TODO Farbzuweiseung
        <ls_arbstellen>-color = <ls_arbstellen>-object->get_color( ).
*      <ls_arbstellen>-color = 'grey.png'.

        "zuweisen der Arbeitsstelle an die Ausgabetabelle
        <ls_arbst_tunnel> = <ls_arbstellen>.
      ENDIF. ">001< (+)

      AT LAST.
        IF NOT line_exists( lt_arbstellen[ is_as_portal_ws = abap_true ] ).  ">001< (+)
          " Strich
          APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING <ls_arbst_tunnel>.
          <ls_arbst_tunnel>-length = 664 - lv_rest_laenge.
          <ls_arbst_tunnel>-color = 'grey.png'.
          <ls_arbst_tunnel>-height = 1.
          <ls_arbst_tunnel>-is_visible = abap_true.
        ELSE.  ">001< (+) begin

          " Strich
          APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING <ls_arbst_tunnel>.
          <ls_arbst_tunnel>-length = 664 - ( lv_rest_laenge - 10 ).
          <ls_arbst_tunnel>-color = 'grey.png'.
          <ls_arbst_tunnel>-height = 1.
          <ls_arbst_tunnel>-is_visible = abap_true.

          "As - Portal
          ASSIGN lt_arbstellen[ is_as_portal_ws = abap_true ] TO FIELD-SYMBOL(<ls_arbstelle_portal>).
          APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING <ls_arbst_tunnel>.
          <ls_arbstelle_portal>-length  = 10.
          <ls_arbstelle_portal>-height  = 10.
          <ls_arbstelle_portal>-tooltip = | Arbeitsstelle { <ls_arbstelle_portal>-object->get_kurztext( ) }, Kilometer { <ls_arbstelle_portal>-zkmin } bis { <ls_arbstelle_portal>-zkmax }, (Auslastung: xxx%) |.  ">003< (-)
          <ls_arbstelle_portal>-tooltip = | Arbeitsstelle { <ls_arbstelle_portal>-object->get_kurztext( ) }, Kilometer { <ls_arbstelle_portal>-zkmin } bis { <ls_arbstelle_portal>-zkmax }, Id { <ls_arbstellen>-object->get_id( ) ALPHA = OUT }|.  ">003< (+)
          <ls_arbstelle_portal>-is_visible = abap_true.
          <ls_arbstelle_portal>-is_as      = abap_true.
          <ls_arbstelle_portal>-color      = <ls_arbstelle_portal>-object->get_color( ).
          <ls_arbst_tunnel> = <ls_arbstelle_portal>.
        ENDIF. ">001< (+) end

      ENDAT.
    ENDLOOP.
  ELSE.
    " Strich
    APPEND INITIAL LINE TO lt_arbst_tunnel ASSIGNING <ls_arbst_tunnel>.
    <ls_arbst_tunnel>-length = 664.
    <ls_arbst_tunnel>-color = 'grey.png'.
    <ls_arbst_tunnel>-height = 1.
    <ls_arbst_tunnel>-is_visible = abap_true.
  ENDIF.

  node->bind_table( new_items            = lt_arbst_tunnel
                    set_initial_elements = abap_true ).

  READ TABLE lt_arbst_tunnel WITH KEY is_as = abap_true TRANSPORTING NO FIELDS.
  IF syst-subrc = 0.
    node->set_lead_selection_index( index = 2 ).
  ENDIF.
ENDMETHOD.

METHOD supply_as_filter .
  DATA ls_as_filter     TYPE wd_this->element_as_filter.
  ##NEEDED DATA lt_einzelkapas   TYPE wd_this->elements_einzelkapas.
  DATA lt_sitzplatz     TYPE wd_this->elements_sitzplatz.
  DATA lt_fahrzeuge     TYPE TABLE OF zia_2veh_typ WITH DEFAULT KEY.
  DATA lt_auftrage      TYPE TABLE OF zia_2order WITH DEFAULT KEY.
  DATA lo_einzelkapas_i TYPE REF TO cl_object_collection_iterator.
  DATA lo_einzelkapa    TYPE REF TO zcl_ia_2indiv_capcity.


  IF wd_this->mo_curr_arbstelle IS NOT BOUND.
    node->bind_structure( new_item = ls_as_filter  set_initial_elements = abap_true ).
    RETURN.
  ENDIF.

  TRY .
      DATA(li_sitzplatz_ctx) = parent_element->get_child_node( name = wd_this->wdctx_sitzplatz ).
      li_sitzplatz_ctx->get_child_node( name = wd_this->wdctx_einzelkapas )->invalidate( ).
      li_sitzplatz_ctx->get_child_node( name = wd_this->wdctx_einzelkapas )->get_static_attributes_table( IMPORTING table = lt_einzelkapas ).
      li_sitzplatz_ctx->get_static_attributes_table( IMPORTING table = lt_sitzplatz ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

  "Collect Fahrzeuge and Auftrage data
  LOOP AT lt_sitzplatz ASSIGNING FIELD-SYMBOL(<ls_sitzplatz>) WHERE object IS BOUND.

    DATA(lo_fahrzeug) = <ls_sitzplatz>-object->get_fahrzeug( ).
    APPEND lo_fahrzeug->get_fahrzeugtyp( ) TO lt_fahrzeuge.

    lo_einzelkapas_i ?= <ls_sitzplatz>-object->get_einzelkapas_o( )->get_values_iterator( ).
    WHILE lo_einzelkapas_i->has_next( ) = abap_true.

      lo_einzelkapa ?=  lo_einzelkapas_i->get_next( ).
      DATA(lo_auftrag) = lo_einzelkapa->get_auftrag( ).
      APPEND lo_auftrag->get_data( ) TO lt_auftrage.

    ENDWHILE.

  ENDLOOP.

  "Get AS mapping data
  DATA(lt_map_sp_as) = wd_this->mo_curr_arbstelle->get_map_sp_as( ).
  DATA(lt_jobliste) = wd_this->mo_curr_arbstelle->get_auftraege_wd( ).

  IF line_exists( lt_map_sp_as[ zintervallart = 'RI' ] ) OR   "RJ/JI
     line_exists( lt_jobliste[ zintervall = 'RI'     ] ) OR
     line_exists( lt_auftrage[ zintervall = 'RI'     ] ).

    ls_as_filter-ckb_enabled_ri = abap_true.
    ls_as_filter-ckb_checked_ri = abap_true.
  ENDIF.

  IF line_exists( lt_map_sp_as[ zintervallart = 'JI' ] ) OR   "RJ/JI
    line_exists( lt_jobliste[ zintervall = 'JI'     ] ) OR
    line_exists( lt_auftrage[ zintervall = 'JI'     ] ).

    ls_as_filter-ckb_enabled_ji = abap_true.
    ls_as_filter-ckb_checked_ji = abap_true.
  ENDIF.

  IF line_exists( lt_map_sp_as[ zintervallart = 'TS' ] ) OR      "TS
     line_exists( lt_jobliste[ zintervall = 'TS'     ] ) OR
     line_exists( lt_auftrage[ zintervall = 'TS'     ] ).

    ls_as_filter-ckb_enabled_ts = abap_true.
    ls_as_filter-ckb_checked_ts = abap_true.
  ENDIF.

  ">001< + begin
  IF line_exists( lt_map_sp_as[ zintervallart = zif_ia_2_constant=>mc_intervallart-li ] ) OR
     line_exists( lt_jobliste[ zintervall = zif_ia_2_constant=>mc_intervallart-li ] ).
    ls_as_filter-ckb_enabled_li = abap_true.
    ls_as_filter-ckb_checked_li = abap_true.
  ENDIF.
  ">001< + end

  IF line_exists( lt_map_sp_as[ zugangsart = '1'  ] ) OR         "Schiene
     line_exists( lt_jobliste[ zzzugangsart = '1' ] ) OR
     line_exists( lt_fahrzeuge[ zbasisfzg_pneu = abap_false ] ).

    ls_as_filter-ckb_enabled_schiene = abap_true.
    ls_as_filter-ckb_checked_schiene = abap_true.
  ENDIF.

  IF line_exists( lt_map_sp_as[ zugangsart = '2'  ] ) OR          "Strasse
     line_exists( lt_jobliste[ zzzugangsart = '2' ] ) OR
     line_exists( lt_fahrzeuge[ zbasisfzg_pneu = abap_true ] ).

    ls_as_filter-ckb_enabled_strasse = abap_true.
    ls_as_filter-ckb_checked_strasse = abap_true.
  ENDIF.

  "bind a single element
  node->bind_structure( new_item = ls_as_filter  set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_auftraege_alv .

  wd_this->mo_cc_uebersicht->supply_auftraege_alv( node           = node
                                                   parent_element = parent_element ).
ENDMETHOD.

METHOD supply_bemerkung .

  DATA: ls_popup_bemerkung TYPE wd_this->element_popup_bemerkung,
        ls_schichtplan     TYPE wd_this->element_schichtplan.
  DATA: lv_uname TYPE syst_uname.

  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
  DATA(li_tab_schichten_node) = wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten ).
  DATA(ls_tab_schichten)  = VALUE wd_this->element_tabs_schichten( ).
  IF wd_this->gv_notes_popup_from_schicht_dt IS NOT INITIAL.
    IF li_tab_schichten_node IS BOUND.
      DATA(li_schicht_tab_elem) = li_tab_schichten_node->get_lead_selection( ).
      IF li_schicht_tab_elem IS BOUND.
        li_schicht_tab_elem->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).
        IF ls_tab_schichten-object IS BOUND.
          ls_schichtplan-object = ls_tab_schichten-object.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  DATA(lt_current_bemerkungen) = ls_schichtplan-object->get_notes( ).
  ls_popup_bemerkung-show_current = COND #( WHEN lt_current_bemerkungen IS INITIAL THEN abap_false ELSE abap_true ).
  ls_popup_bemerkung-show_new = ls_schichtplan-edit_mode.

  READ TABLE lt_current_bemerkungen ASSIGNING FIELD-SYMBOL(<ls_current_bemerkungen>) WITH KEY uname = lv_uname.

  IF sy-subrc EQ 0. "Es sind bereits Bemerkungen von dieser Person vorhanden
*    ls_popup_bemerkung-new_bemerkung = <ls_current_bemerkungen>-bemerkung.
    ls_popup_bemerkung-btn_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/UPDATE_COMMENTS' ).
  ELSE.
    CLEAR ls_popup_bemerkung-new_bemerkung.
    ls_popup_bemerkung-btn_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SAVE' ).
  ENDIF.

  node->bind_structure( new_item              = ls_popup_bemerkung
                         set_initial_elements = abap_true ).

  node->get_child_node( name = wd_this->wdctx_current_bemerkungen )->bind_table( new_items            = lt_current_bemerkungen
                                                                                 set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_btg_osn .
  DATA: lt_btg_osn       TYPE wd_this->elements_btg_osn,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
        lv_id_btg        TYPE zia_2_id_btg.

  "*******************
  "* Init Multipane => all HIDE
  "***************
  DO 7 TIMES.
    APPEND INITIAL LINE TO lt_btg_osn ASSIGNING FIELD-SYMBOL(<ls_btg_osn>).
    <ls_btg_osn>-height = 0.  "0
    <ls_btg_osn>-length = 36.  "28
    <ls_btg_osn>-tooltip = ''.
    <ls_btg_osn>-is_as = ''.
    <ls_btg_osn>-zid_btg = '    '.
    <ls_btg_osn>-color = 'purple.png'.
  ENDDO.

  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).

  DATA(lv_perim) = ls_tab_schichten-object->get_data( )-zzperi.

*  SELECT DISTINCT zid_btg, zindex, zktext_de, zktext_it
*    FROM zia_2building
*    INTO TABLE @DATA(lt_osn)
*    WHERE zzperi = @lv_perim
*      AND ort = 'OSN'.

  DATA(lt_osn) = wd_assist->get_buildings( iv_peri = lv_perim ).


  "*******************
  "* Begin Hole passende Arbeitsstellen
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    IF lo_arbstelle->is_btg( IMPORTING ev_id_btg  = lv_id_btg ) EQ abap_true.

      READ TABLE lt_osn WITH KEY zid_btg = lv_id_btg ASSIGNING FIELD-SYMBOL(<ls_osn>).
      IF syst-subrc = 0.
        lt_btg_osn[ <ls_osn>-zindex ]-height = 10.
        lt_btg_osn[ <ls_osn>-zindex ]-length = 10.
        lt_btg_osn[ <ls_osn>-zindex ]-zid_btg = <ls_osn>-zid_btg.
        "lt_btg_osn[ <ls_osn>-zindex ]-tooltip = COND #( WHEN syst-langu = 'I' THEN <ls_osn>-zktext_it ELSE <ls_osn>-zktext_de ). ">001< (-)
*        DATA(lv_zktext) = COND #( WHEN syst-langu = 'I' THEN <ls_osn>-zktext_it ELSE <ls_osn>-zktext_de ). ">001< (+)
*        lt_btg_osn[ <ls_osn>-zindex ]-tooltip = | Arbeitsstelle { lo_arbstelle->get_kurztext( ) }, { lv_zktext }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.  ">001< (+)
        lt_btg_osn[ <ls_osn>-zindex ]-is_as = 'X'.
        lt_btg_osn[ <ls_osn>-zindex ]-color = lo_arbstelle->get_color( ).
        lt_btg_osn[ <ls_osn>-zindex ]-object = lo_arbstelle.
        lt_btg_osn[ <ls_osn>-zindex ]-zarbstl = lo_arbstelle->get_data( )-zarbstl.
      ENDIF.
    ENDIF.
  ENDWHILE.


  node->bind_table( new_items            = lt_btg_osn
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_btg_oss .
  DATA: lt_btg_oss       TYPE wd_this->elements_btg_oss,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
        lv_id_btg        TYPE zia_2_id_btg.

  "*******************
  "* Init Multipane => all HIDE
  "***************
  DO 7 TIMES.
    APPEND INITIAL LINE TO lt_btg_oss ASSIGNING FIELD-SYMBOL(<ls_btg_oss>).
    <ls_btg_oss>-height = 0.  "0
    <ls_btg_oss>-length = 36.  "28
    <ls_btg_oss>-tooltip = ''.
    <ls_btg_oss>-is_as = ''.
    <ls_btg_oss>-zid_btg = '    '.
    <ls_btg_oss>-color = 'purple.png'.
  ENDDO.

**  SELECT DISTINCT zid_btg, zindex, zktext_de, zktext_it
**    FROM zia_2building
**    INTO TABLE @DATA(lt_oss)
**    WHERE zzperi = 'GBT'
**      AND ort = 'OSS'.
  DATA(lt_oss) = wd_assist->get_buildings_gbt(  ).

  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).


  "*******************
  "* Begin Hole passende Arbeitsstellen
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    IF lo_arbstelle->is_btg( IMPORTING ev_id_btg  = lv_id_btg ) EQ abap_true.

      READ TABLE lt_oss WITH KEY zid_btg = lv_id_btg ASSIGNING FIELD-SYMBOL(<ls_oss>).
      IF syst-subrc = 0.
        lt_btg_oss[ <ls_oss>-zindex ]-height = 10.
        lt_btg_oss[ <ls_oss>-zindex ]-length = 10.
        lt_btg_oss[ <ls_oss>-zindex ]-zid_btg = <ls_oss>-zid_btg.
        "lt_btg_oss[ <ls_oss>-zindex ]-tooltip = COND #( WHEN syst-langu = 'I' THEN <ls_oss>-zktext_it ELSE <ls_oss>-zktext_de ). ">001< (-)
        DATA(lv_zktext) =  <ls_oss>-zktext. ">001< (+)
        lt_btg_oss[ <ls_oss>-zindex ]-tooltip = | Arbeitsstelle { lo_arbstelle->get_kurztext( ) }, { lv_zktext }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.  ">001< (+)
**        lt_btg_oss[ <ls_oss>-zindex ]-tooltip = | Arbeitsstelle { lo_arbstelle->get_kurztext( ) }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.  ">001< (+)
        lt_btg_oss[ <ls_oss>-zindex ]-is_as = 'X'.
        lt_btg_oss[ <ls_oss>-zindex ]-color = lo_arbstelle->get_color( ).
        lt_btg_oss[ <ls_oss>-zindex ]-object = lo_arbstelle.
        lt_btg_oss[ <ls_oss>-zindex ]-zarbstl = lo_arbstelle->get_data( )-zarbstl.
      ENDIF.
    ENDIF.
  ENDWHILE.


  node->bind_table( new_items            = lt_btg_oss
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_btg_tunnel .
  DATA: lt_btg_tunnel    TYPE wd_this->elements_btg_tunnel,
        ls_tab_schichten TYPE wd_this->element_tabs_schichten,
        lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator,
        lo_arbstelle     TYPE REF TO zcl_ia_2wrkplace,
        lv_id_btg        TYPE zia_2_id_btg.

  "*******************
  "* Init Multipane => all HIDE
  "***************
  DO 15 TIMES.
    APPEND INITIAL LINE TO lt_btg_tunnel ASSIGNING FIELD-SYMBOL(<ls_btg_tunnel>).
    <ls_btg_tunnel>-height = 0.  "0
    <ls_btg_tunnel>-length = 36.  "28
    <ls_btg_tunnel>-tooltip = ''.
    <ls_btg_tunnel>-is_as = ''.
    <ls_btg_tunnel>-zid_btg = '    '.
    <ls_btg_tunnel>-color = 'purple.png'.
  ENDDO.

  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).

  DATA(lv_perim) = ls_tab_schichten-object->get_data( )-zzperi.

**  SELECT DISTINCT zid_btg, zindex, zktext_de, zktext_it
**    FROM zia_2building
**    INTO TABLE @DATA(lt_tunnel)
**    WHERE zzperi = @lv_perim
**      AND ort = 'TUNNEL'.
  DATA(lt_tunnel) =  wd_assist->get_buildings_tunnel( iv_peri = lv_perim ).

  "Aktuelle Schicht
  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten  )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).


  "*******************
  "* Begin Hole passende Arbeitsstellen
  "***************
  lo_arbstelle_i ?= ls_tab_schichten-object->get_arbeitsstellen( )->get_values_iterator( ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    lo_arbstelle ?= lo_arbstelle_i->get_next( ).

    IF lo_arbstelle->is_btg( IMPORTING ev_id_btg  = lv_id_btg ) EQ abap_true.

      READ TABLE lt_tunnel WITH KEY zid_btg = lv_id_btg ASSIGNING FIELD-SYMBOL(<ls_tunnel>).
      IF syst-subrc = 0.
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-height = 10.
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-length = 10.
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-zid_btg = <ls_tunnel>-zid_btg.
        "lt_btg_tunnel[ <ls_tunnel>-zindex ]-tooltip = COND #( WHEN syst-langu = 'I' THEN <ls_tunnel>-zktext_it ELSE <ls_tunnel>-zktext_de ).  ">001< (-)

*        DATA(lv_zktext) = COND #( WHEN syst-langu = 'I' THEN <ls_tunnel>-zktext_it ELSE <ls_tunnel>-zktext_de ). ">001< (+)
*        lt_btg_tunnel[ <ls_tunnel>-zindex ]-tooltip = | Arbeitsstelle { lo_arbstelle->get_kurztext( ) }, { lv_zktext }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.  ">001< (+)
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-tooltip = | Arbeitsstelle { lo_arbstelle->get_kurztext( ) }, Id { lo_arbstelle->get_id( ) ALPHA = OUT }|.  ">001< (+)
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-is_as = 'X'.
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-color = lo_arbstelle->get_color( ).
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-object = lo_arbstelle.
        lt_btg_tunnel[ <ls_tunnel>-zindex ]-zarbstl = lo_arbstelle->get_data( )-zarbstl.
      ENDIF.
    ENDIF.
  ENDWHILE.


  node->bind_table( new_items            = lt_btg_tunnel
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_date_navigator .
  DATA ls_date_navigator TYPE wd_this->element_date_navigator.

  ls_date_navigator-last_klicked_calender = 'DATE_NAVIGATOR_GBT'.
  ls_date_navigator-perimeter = 'GBT'.

  node->bind_structure( new_item             = ls_date_navigator
                        set_initial_elements = abap_true ).
ENDMETHOD.

method SUPPLY_DATE_NAVIGATOR_CBT .
  DATA ls_date_navigator_cbt TYPE wd_this->element_date_navigator_cbt.

  zcl_ia_2utilities=>get_date_interval( IMPORTING ev_firstselecteddate = ls_date_navigator_cbt-firstselecteddate
                                                   ev_startswith        = ls_date_navigator_cbt-startswith
                                                   ev_lastselecteddate  = ls_date_navigator_cbt-firstselecteddate ).

  ls_date_navigator_cbt-lastselecteddate = ls_date_navigator_cbt-firstselecteddate.

  node->bind_structure( new_item             = ls_date_navigator_cbt
                        set_initial_elements = abap_true ).
endmethod.

method SUPPLY_DATE_NAVIGATOR_GBT .

  DATA ls_date_navigator_gbt TYPE wd_this->element_date_navigator_gbt.

  zcl_ia_2utilities=>get_date_interval( IMPORTING ev_firstselecteddate = ls_date_navigator_gbt-firstselecteddate
                                                  ev_startswith        = ls_date_navigator_gbt-startswith
                                                  ev_lastselecteddate  = ls_date_navigator_gbt-firstselecteddate ).

  ls_date_navigator_gbt-lastselecteddate = ls_date_navigator_gbt-firstselecteddate.

  node->bind_structure( new_item             = ls_date_navigator_gbt
                        set_initial_elements = abap_true ).
endmethod.

METHOD supply_details .
  DATA: ls_details   TYPE wd_this->element_details,
 ##NEEDED       ls_arbstelle TYPE zia_2sf_wa.

  ls_arbstelle = wd_this->mo_curr_arbstelle->get_data( ).

  ls_details-fahrleitungsschaltung = 1.

  node->bind_structure( new_item             = ls_details
                        set_initial_elements = abap_true ).

  "*******************
  "* SP_DETAILS
  "***************
  DATA: lt_sp_ehb     TYPE wd_this->elements_sp_ehb,
        lt_sp_details TYPE wd_this->elements_sp_details.

  wd_this->mo_curr_arbstelle->get_sp_details_wd( IMPORTING et_sp_ehb     = lt_sp_ehb
                                                 CHANGING
                                                           ct_sp_details = lt_sp_details ).
  IF lt_sp_details IS NOT INITIAL.
    node->get_child_node( name = wd_this->wdctx_sp_details )->bind_table( EXPORTING new_items            = lt_sp_details
                                                                                    set_initial_elements = abap_true ).
  ENDIF.
  "* SP_EHB
  node->get_child_node( name = wd_this->wdctx_sp_ehb )->bind_table( EXPORTING new_items            = lt_sp_ehb
                                                                           set_initial_elements = abap_true ).


ENDMETHOD.

METHOD supply_einzelkapas .
  DATA: li_element   TYPE REF TO if_wd_context_element,
        lo_auftrag   TYPE REF TO zcl_ia_2order,
        lo_sitzplatz TYPE REF TO zcl_ia_2seat.

  DATA: lt_jobs          TYPE wd_this->elements_einzelkapas,
        ls_jobs          LIKE LINE OF lt_jobs,
        lv_skal_dauer    TYPE f,
        lv_convert       TYPE p,
        lv_auftrag_ktext TYPE string,
        lv_tooltip_text  TYPE string,
        lv_dauer         TYPE string,
        ls_auftrag       TYPE zia_2order.

  DATA: lt_jobliste TYPE wd_this->elements_jobliste,
        ls_jobliste TYPE wd_this->element_jobliste.


  DATA: lo_einzelkapas_i TYPE REF TO cl_object_collection_iterator,
        lo_einzelkapa    TYPE REF TO zcl_ia_2indiv_capcity,
        lv_min_text      TYPE string,
        lv_km_von        TYPE string,
        lv_km_bis        TYPE string,
        lv_km            TYPE string.

  DATA: lv_aufnr TYPE aufnr.

  " hole parent element
  li_element = node->get_parent_element( ).
  li_element->get_attribute( EXPORTING name = 'OBJECT' IMPORTING value = lo_sitzplatz ).

  lt_jobliste = wd_this->mo_curr_arbstelle->get_auftraege_wd( ).

  lv_aufnr = wd_this->popin_aufnr_get( ).

  DATA(li_dd_flavor) = zcl_ia_2utils_wd_a=>get_flavor_move_einzelkapa( lo_sitzplatz->get_fahrzeug( )->get_zugangsart( ) ).

  lo_einzelkapas_i ?= lo_sitzplatz->get_einzelkapas_o( )->get_values_iterator( ).

  WHILE lo_einzelkapas_i->has_next( ) = abap_true.
    lo_einzelkapa ?=  lo_einzelkapas_i->get_next( ).


    ls_jobs-object = lo_einzelkapa.

    LOOP AT lt_jobliste INTO ls_jobliste WHERE aufnr = lo_einzelkapa->get_data( )-aufnr.
    ENDLOOP.
    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    lo_auftrag = ls_jobliste-object.
    ls_auftrag = lo_auftrag->get_data( ).
    lv_auftrag_ktext = ls_auftrag-ktext.

    lv_convert = lo_einzelkapa->get_data( )-zdauer.
    lv_dauer = lv_convert.

    lv_km_von = ls_auftrag-zzkmvpl.
    lv_km_bis = ls_auftrag-zzkmbpl.
    CONCATENATE ',' 'KM' lv_km_von '-' lv_km_bis INTO lv_km SEPARATED BY space.

    lv_min_text = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MIN' ).
    CONCATENATE lv_auftrag_ktext ' (' lv_dauer lv_min_text lv_km INTO lv_tooltip_text.

    " Skalierung der Balkenlänge mit 50%
    lv_skal_dauer = lo_einzelkapa->get_data( )-zdauer * '0.25' ##LITERAL.

    ls_jobs-length_for_visualization = lv_skal_dauer.
    ls_jobs-job_id = lo_einzelkapa->get_data( )-zid_ek.

    IF lv_aufnr IS INITIAL OR lv_aufnr NE lo_einzelkapa->get_data( )-aufnr.
      ls_jobs-image_for_visualization = COND #( WHEN lo_auftrag->get_data( )-zintervall = 'TS'
                                                THEN zif_ia_2_wd_individual_capacit=>mc_image_total_sperrung
                                                ELSE zif_ia_2_wd_individual_capacit=>mc_image_normal ).
    ELSE.
      IF lo_einzelkapa->get_error_flag( ) EQ abap_true.
        ls_jobs-image_for_visualization = zif_ia_2_wd_individual_capacit=>mc_image_error.
      ELSE.
        ls_jobs-image_for_visualization = zif_ia_2_wd_individual_capacit=>mc_image_preview.
      ENDIF.
    ENDIF.

    ls_jobs-aufnr = lo_einzelkapa->get_data( )-aufnr.
    ls_jobs-tooltip = lv_tooltip_text.
    ls_jobs-tags = li_dd_flavor->gv_string.

    APPEND ls_jobs TO lt_jobs.
  ENDWHILE.

  node->bind_table( new_items            = lt_jobs
                    set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_fahrzeuge .
  wd_this->mo_cc_schdet_fzeuge->supply_fahrzeuge( node           = node
                                                parent_element = parent_element ).
ENDMETHOD.

METHOD supply_fz_typen_popup . "#EC NEEDED
ENDMETHOD.

METHOD supply_intervallarten .
  DATA: lt_intervallarten TYPE wd_this->elements_intervallarten.

  APPEND INITIAL LINE TO lt_intervallarten ASSIGNING FIELD-SYMBOL(<ls_intervallarten>).
  <ls_intervallarten>-kurztext = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/REGULAR_INTERVAL').
  <ls_intervallarten>-intervallarten = 'RI'.

  APPEND INITIAL LINE TO lt_intervallarten ASSIGNING <ls_intervallarten>.
  <ls_intervallarten>-kurztext = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/RULE_JOKER_INTERVAL').
  <ls_intervallarten>-intervallarten = 'JI'.

  APPEND INITIAL LINE TO lt_intervallarten ASSIGNING <ls_intervallarten>.
  <ls_intervallarten>-kurztext = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/TOTAL_CLOSURE').
  <ls_intervallarten>-intervallarten = 'TS'.

  APPEND INITIAL LINE TO lt_intervallarten ASSIGNING <ls_intervallarten>.
  <ls_intervallarten>-kurztext = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/LONG_INTERVAL').
  <ls_intervallarten>-intervallarten = zif_ia_2_constant=>mc_intervallart-li.

  node->bind_table( new_items            = lt_intervallarten
                    set_initial_elements = abap_true ).

  " Alle Checkboxen markieren
  LOOP AT node->get_elements( ) ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->set_selected( flag = abap_true ).
  ENDLOOP.
ENDMETHOD.

METHOD supply_jl_value_suggestions .
  DATA: lt_jobliste     TYPE wd_this->elements_jobliste,
        lt_aufnr        TYPE wd_this->elements_jl_aufnr,
        lt_auart        TYPE wd_this->elements_jl_auart,
        lt_zpprio       TYPE wd_this->elements_jl_zpprio,
        lt_ktext        TYPE wd_this->elements_jl_ktext,
        lt_gltrp        TYPE wd_this->elements_jl_gltrp,
        lt_zzkmvpl      TYPE wd_this->elements_jl_zzkmvpl,
        lt_zzkmbpl      TYPE wd_this->elements_jl_zzkmbpl,
        lt_zstdkz       TYPE wd_this->elements_jl_zstdkz,
        lt_zdidok       TYPE wd_this->elements_jl_zdidok,
        lt_zlage        TYPE wd_this->elements_jl_zlage,
        lt_zzzugangsart TYPE wd_this->elements_jl_zzzugangsart,
        lt_zintervall   TYPE wd_this->elements_jl_zintervall,
        lt_zzest        TYPE wd_this->elements_jl_zzest.

  FIELD-SYMBOLS: <ls_line> TYPE wd_this->element_jobliste.


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_jobliste
           )->get_static_attributes_table( IMPORTING table = lt_jobliste ).


  " Auftragsnummer mit Filtervorschlägen befüllen.
  LOOP AT lt_jobliste ASSIGNING <ls_line>.
    " Auftragsnummer mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_aufnr ASSIGNING FIELD-SYMBOL(<ls_aufnr>).
    <ls_aufnr>-aufnr = <ls_line>-aufnr.

    " Auftragsart mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_auart ASSIGNING FIELD-SYMBOL(<ls_auart>).
    <ls_auart>-auart = <ls_line>-auart.

    " Prio mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zpprio ASSIGNING FIELD-SYMBOL(<ls_zpprio>).
    <ls_zpprio>-zpprio = <ls_line>-zpprio.

    " Kurztext mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_ktext ASSIGNING FIELD-SYMBOL(<ls_ktext>).
    <ls_ktext>-ktext = <ls_line>-ktext.

    APPEND INITIAL LINE TO lt_gltrp ASSIGNING FIELD-SYMBOL(<ls_gltrp>).
    <ls_gltrp>-gltrp = zcl_ia_2utilities=>get_dats_as_formated_string( <ls_line>-gltrp ).

    APPEND INITIAL LINE TO lt_zzkmvpl ASSIGNING FIELD-SYMBOL(<ls_zzkmvpl>).
    <ls_zzkmvpl>-zzkmvpl = <ls_line>-zzkmvpl.

    APPEND INITIAL LINE TO lt_zzkmbpl ASSIGNING FIELD-SYMBOL(<ls_zzkmbpl>).
    <ls_zzkmbpl>-zzkmbpl = <ls_line>-zzkmbpl.

    APPEND INITIAL LINE TO lt_zstdkz ASSIGNING FIELD-SYMBOL(<ls_zstdkz>).
    <ls_zstdkz>-zstdkz = <ls_line>-zstdkz.

    " Didok mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zdidok ASSIGNING FIELD-SYMBOL(<ls_zdidok>).
    <ls_zdidok>-zdidok = <ls_line>-zdidok.

    " Lage mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zlage ASSIGNING FIELD-SYMBOL(<ls_zlage>).
    <ls_zlage>-zlage = <ls_line>-zlage.

    " Intervallart mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zintervall ASSIGNING FIELD-SYMBOL(<ls_zintervall>).
    <ls_zintervall>-zintervall = <ls_line>-zintervall.

    APPEND INITIAL LINE TO lt_zzest ASSIGNING FIELD-SYMBOL(<ls_zzest>).
    <ls_zzest>-zzest = <ls_line>-zzest.

    APPEND INITIAL LINE TO lt_zzzugangsart ASSIGNING FIELD-SYMBOL(<ls_zzzugangsart>).
    <ls_zzzugangsart>-zzzugangsart = <ls_line>-zzzugangsart.

  ENDLOOP.

  SORT lt_aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_aufnr.
  parent_element->get_child_node( name = wd_this->wdctx_jl_aufnr )->bind_table( EXPORTING new_items = lt_aufnr ).


  SORT lt_auart BY auart.
  DELETE ADJACENT DUPLICATES FROM lt_auart.
  parent_element->get_child_node( name = wd_this->wdctx_jl_auart )->bind_table( EXPORTING new_items = lt_auart
                                                                                set_initial_elements = abap_true ).

  SORT lt_zpprio BY zpprio.
  DELETE ADJACENT DUPLICATES FROM lt_zpprio.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zpprio )->bind_table( EXPORTING new_items = lt_zpprio ).

  SORT lt_ktext BY ktext.
  DELETE ADJACENT DUPLICATES FROM lt_ktext.
  parent_element->get_child_node( name = wd_this->wdctx_jl_ktext )->bind_table( EXPORTING new_items = lt_ktext ).

  SORT lt_gltrp BY gltrp.
  DELETE ADJACENT DUPLICATES FROM lt_gltrp.
  parent_element->get_child_node( name = wd_this->wdctx_jl_gltrp )->bind_table( EXPORTING new_items = lt_gltrp ).

  SORT lt_zzkmvpl BY zzkmvpl.
  DELETE ADJACENT DUPLICATES FROM lt_zzkmvpl.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zzkmvpl )->bind_table( EXPORTING new_items = lt_zzkmvpl ).

  SORT lt_zzkmbpl BY zzkmbpl.
  DELETE ADJACENT DUPLICATES FROM lt_zzkmbpl.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zzkmbpl )->bind_table( EXPORTING new_items = lt_zzkmbpl ).

  SORT lt_zdidok BY zdidok.
  DELETE ADJACENT DUPLICATES FROM lt_zdidok.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zdidok )->bind_table( EXPORTING new_items = lt_zdidok ).

  SORT lt_zstdkz BY zstdkz.
  DELETE ADJACENT DUPLICATES FROM lt_zstdkz.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zstdkz )->bind_table( EXPORTING new_items = lt_zstdkz ).

  SORT lt_zlage BY zlage.
  DELETE ADJACENT DUPLICATES FROM lt_zlage.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zlage )->bind_table( EXPORTING new_items = lt_zlage ).

  SORT lt_zintervall BY zintervall.
  DELETE ADJACENT DUPLICATES FROM lt_zintervall.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zintervall )->bind_table( EXPORTING new_items = lt_zintervall ).

  SORT lt_zzest BY zzest.
  DELETE ADJACENT DUPLICATES FROM lt_zzest.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zzest )->bind_table( EXPORTING new_items = lt_zzest ).

  SORT lt_zzzugangsart BY zzzugangsart.
  DELETE ADJACENT DUPLICATES FROM lt_zzzugangsart.
  parent_element->get_child_node( name = wd_this->wdctx_jl_zzzugangsart )->bind_table( EXPORTING new_items = lt_zzzugangsart ).

ENDMETHOD.

METHOD supply_jobliste.
  DATA: lt_jobliste    TYPE wd_this->elements_jobliste,
        lt_aufk_ext_sp TYPE eaml_t_lfe_data.

  TYPES: BEGIN OF ts_tabkey,
           tabkey TYPE eaml_d_lfe_data-tabkey,
         END OF ts_tabkey.

  DATA: lt_tabkey TYPE STANDARD TABLE OF ts_tabkey WITH EMPTY KEY,
        ls_tabkey TYPE ts_tabkey.

  IF wd_this->mo_curr_arbstelle IS NOT INITIAL.
    lt_jobliste = wd_this->mo_curr_arbstelle->get_auftraege_wd( ).
  ENDIF.

  LOOP AT lt_jobliste INTO DATA(ls_auftrag).
    CLEAR ls_tabkey.
    " Convert aufnr to tabkey type (ensures same type/length)
    ls_tabkey-tabkey = CONV #( ls_auftrag-aufnr ).
    APPEND ls_tabkey TO lt_tabkey.
  ENDLOOP.
  IF lt_jobliste IS NOT INITIAL.         "Performance - get at once
*    SELECT tabkey,z_section
*      FROM eaml_d_lfe_data
*      INTO CORRESPONDING FIELDS OF TABLE @lt_aufk_ext_sp
*      FOR ALL ENTRIES IN @lt_tabkey
*      WHERE tabkey = @lt_tabkey-tabkey.
    lt_aufk_ext_sp =  wd_assist->get_blocking_section( it_aufnr_key = lt_tabkey  ).
  ENDIF.

  LOOP AT lt_jobliste ASSIGNING FIELD-SYMBOL(<ls_jobliste>).

    CLEAR <ls_jobliste>-table_popin.
    <ls_jobliste>-zzest = zcl_ia_2order=>get_assigned_sperrabs( it_data = lt_aufk_ext_sp iv_aufnr = <ls_jobliste>-aufnr ).

  ENDLOOP.
  node->bind_table( new_items            = lt_jobliste
                      set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_jobliste_popin_details .

  DATA: lt_popin_detail TYPE wd_this->elements_jl_popin_detail,
        lt_fz_text      TYPE wd_this->elements_jl_fz_text,
        lo_auftrag      TYPE REF TO zcl_ia_2order,
        lo_einzelkapa   TYPE REF TO zcl_ia_2indiv_capcity,
        lt_jobliste     TYPE wd_this->elements_jobliste.

  ##NEEDED DATA(lo_assist) = NEW zcl_ia_2lofpm_clh_wd_assist( ).

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_jobliste )->get_static_attributes_table( IMPORTING table = lt_jobliste ).

  READ TABLE lt_jobliste WITH KEY table_popin = 'TABLEPOPIN_JL' ASSIGNING FIELD-SYMBOL(<ls_jobliste>).

  CHECK <ls_jobliste> IS ASSIGNED.

  lo_auftrag = wd_this->mo_curr_arbstelle->get_auftrag( iv_key = <ls_jobliste>-aufnr ).

  DATA(li_einzelkapas_i) = lo_auftrag->get_einzelkapas_o( )->get_values_iterator( ).

  WHILE li_einzelkapas_i->has_next( ) = abap_true.
    lo_einzelkapa ?=  li_einzelkapas_i->get_next( ).

    APPEND INITIAL LINE TO lt_popin_detail ASSIGNING FIELD-SYMBOL(<ls_popin_detail>).

    <ls_popin_detail>-dauer = lo_einzelkapa->get_data( )-zdauer.

    DATA(lv_zobjid) = lo_einzelkapa->get_data( )-zobjid.
    DATA(lv_zobjty) = lo_einzelkapa->get_data( )-zobjty.

**    SELECT SINGLE arbpl
**      FROM crhd
**      INTO @<ls_popin_detail>-qualifikation
**      WHERE objid = @lv_zobjid AND objty = @lv_zobjty.

    <ls_popin_detail>-qualifikation = wd_assist->get_qualifikation( iv_zobjid = lv_zobjid iv_zobjty = lv_zobjty ).

*deleting this table as it belongs to Real 1.0 - e564128 03.12.2025
*    SELECT SINGLE beschr FROM zia_2qualis_brf INTO @<ls_popin_detail>-quali_text WHERE objid = @lv_zobjid AND objty = @lv_zobjty.

  ENDWHILE.


  node->bind_table( new_items            = lt_popin_detail
                    set_initial_elements = abap_true ).

*  SELECT SINGLE zzperi, matnr FROM zia_2order INTO @DATA(ls_auftrag) WHERE aufnr = @<ls_jobliste>-aufnr.

  DATA(ls_auftrag) = wd_assist->get_auftrag( iv_aufnr = <ls_jobliste>-aufnr  ).

*  SELECT zid_fztyp FROM zia_2veh_typ_sp INTO TABLE @DATA(lt_map_sp_fztyp) WHERE zzperi = @ls_auftrag-zzperi AND matsv = @ls_auftrag-matnr.

  DATA(lt_map_sp_fztyp) = wd_assist->get_fz_typ_list( iv_peri = ls_auftrag-zzperi iv_matnr = ls_auftrag-matnr ).


  LOOP AT lt_map_sp_fztyp ASSIGNING FIELD-SYMBOL(<ls_map_sp_fztyp>).
**    SELECT SINGLE *
**      FROM zia_2veh_typ_t
**      INTO @DATA(ls_fztyp)
**      WHERE zid_fztyp = @<ls_map_sp_fztyp>-zid_fztyp.
    DATA(ls_fztyp) = wd_assist->get_veh_type( iv_id_fztyp = <ls_map_sp_fztyp>-zid_fztyp ).

    IF syst-subrc EQ 0.
      APPEND INITIAL LINE TO lt_fz_text ASSIGNING FIELD-SYMBOL(<ls_fz_text>).
      <ls_fz_text>-fahrzeug = ls_fztyp-zfztyp_txt.
    ENDIF.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_fz_text COMPARING fahrzeug.

  parent_element->get_child_node( name = wd_this->wdctx_jl_fz_text )->bind_table( new_items            = lt_fz_text
                                                                                  set_initial_elements = abap_true ).

  CLEAR: lo_auftrag, li_einzelkapas_i, lo_einzelkapa.

ENDMETHOD.

METHOD supply_jobpool .

  wd_this->mo_cc_schdet_jobpool->supply_jobpool( node           = node
                                                 parent_element = parent_element ).
ENDMETHOD.

METHOD supply_jobpool_popin_details .
  DATA: lt_popin_detail TYPE wd_this->elements_jp_popin_detail,
        lt_fz_text      TYPE wd_this->elements_jp_fz_text,
        lo_einzelkapa   TYPE REF TO zcl_ia_2indiv_capcity,
        lt_jobpool      TYPE wd_this->elements_jobpool.

  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_jobpool )->get_static_attributes_table( IMPORTING table = lt_jobpool ).

  READ TABLE lt_jobpool WITH KEY table_popin = 'TABLEPOPIN' ASSIGNING FIELD-SYMBOL(<ls_jobpool>).

  CHECK <ls_jobpool> IS ASSIGNED.

  DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = <ls_jobpool>-aufnr ).

  DATA(li_einzelkapas_i) = lo_auftrag->get_einzelkapas_o( )->get_values_iterator( ).

  WHILE li_einzelkapas_i->has_next( ) = abap_true.
    lo_einzelkapa ?=  li_einzelkapas_i->get_next( ).

    APPEND INITIAL LINE TO lt_popin_detail ASSIGNING FIELD-SYMBOL(<ls_popin_detail>).

    <ls_popin_detail>-dauer = lo_einzelkapa->get_data( )-zdauer.

    DATA(lv_zobjid) = lo_einzelkapa->get_data( )-zobjid.
    DATA(lv_zobjty) = lo_einzelkapa->get_data( )-zobjty.

**    SELECT SINGLE arbpl FROM crhd INTO @<ls_popin_detail>-qualifikation WHERE objid = @lv_zobjid AND objty = @lv_zobjty.

    <ls_popin_detail>-qualifikation =  wd_assist->get_workcenter( iv_zobjid = lv_zobjid iv_zobjty = lv_zobjty ).

*deleting this table as it belongs to Real 1.0 - e564128 03.12.2025
*    SELECT SINGLE beschr FROM zia_2qualis_brf INTO @<ls_popin_detail>-quali_text WHERE objid = @lv_zobjid AND objty = @lv_zobjty.

  ENDWHILE.


  node->bind_table( new_items            = lt_popin_detail
                    set_initial_elements = abap_true ).

  "*******************
**  SELECT SINGLE zzperi, matnr FROM zia_2order INTO @DATA(ls_auftrag) WHERE aufnr = @<ls_jobpool>-aufnr.
  DATA(ls_auftrag) = wd_assist->get_auftrag( iv_aufnr = <ls_jobpool>-aufnr ).

  DATA(lt_map_sp_fztyp) = wd_assist->get_fz_typ_list( iv_peri = ls_auftrag-zzperi iv_matnr = ls_auftrag-matnr ).

**  SELECT zid_fztyp FROM zia_2veh_typ_sp INTO TABLE @DATA(lt_map_sp_fztyp) WHERE zzperi = @ls_auftrag-zzperi AND matsv = @ls_auftrag-matnr.

  LOOP AT lt_map_sp_fztyp ASSIGNING FIELD-SYMBOL(<ls_map_sp_fztyp>).
**    SELECT SINGLE * FROM zia_2veh_typ_t INTO @DATA(ls_fztyp) WHERE zid_fztyp = @<ls_map_sp_fztyp>-zid_fztyp.
    DATA(ls_fztyp) = wd_assist->get_veh_type( iv_id_fztyp = <ls_map_sp_fztyp>-zid_fztyp ).
    IF syst-subrc EQ 0.
      APPEND INITIAL LINE TO lt_fz_text ASSIGNING FIELD-SYMBOL(<ls_fz_text>).
      <ls_fz_text>-fahrzeug = ls_fztyp-zfztyp_txt.
    ENDIF.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_fz_text COMPARING fahrzeug.

  parent_element->get_child_node( name = wd_this->wdctx_jp_fz_text )->bind_table( new_items            = lt_fz_text
                                                                                  set_initial_elements = abap_true ).

  CLEAR: lo_auftrag, li_einzelkapas_i, lo_einzelkapa.
ENDMETHOD.

METHOD supply_jobpool_selection .
  DATA lt_jobpool_selection TYPE wd_this->elements_jobpool_selection.

  APPEND INITIAL LINE TO lt_jobpool_selection ASSIGNING FIELD-SYMBOL(<ls_jobpool_selection>).
  <ls_jobpool_selection>-selection = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/PRIORITY'  ).

  APPEND INITIAL LINE TO lt_jobpool_selection ASSIGNING <ls_jobpool_selection>.
  <ls_jobpool_selection>-selection = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/ENDDATE' ).

  node->bind_table( new_items            = lt_jobpool_selection
                    set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_jp_filter_icon .
  DATA ls_jp_filter_icon TYPE wd_this->element_jp_filter_icon.
  ls_jp_filter_icon-os_included = COND #( WHEN ( wd_this->mo_curr_arbstelle->is_in_os_nord( ) OR
                                                 wd_this->mo_curr_arbstelle->is_in_os_sued( ) ) THEN abap_true ELSE abap_false ).

  node->bind_structure( new_item             =  ls_jp_filter_icon
                        set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_jp_value_suggestions .
  DATA: lt_jobpool      TYPE wd_this->elements_jobpool,
        lt_aufnr        TYPE wd_this->elements_jp_aufnr,
        lt_auart        TYPE wd_this->elements_jp_auart,
        lt_zpprio       TYPE wd_this->elements_jp_zpprio,
        lt_ktext        TYPE wd_this->elements_jp_ktext,
        lt_gltrp        TYPE wd_this->elements_jp_gltrp,
        lt_zzkmvpl      TYPE wd_this->elements_jp_zzkmvpl,
        lt_zzkmbpl      TYPE wd_this->elements_jp_zzkmbpl,
        lt_zstdkz       TYPE wd_this->elements_jp_zstdkz,
        lt_zdidok       TYPE wd_this->elements_jp_zdidok,
        lt_zlage        TYPE wd_this->elements_jp_zlage,
        lt_zzzugangsart TYPE wd_this->elements_jp_zzzugangsart,
        lt_zintervall   TYPE wd_this->elements_jp_zintervall,
        lt_zzest        TYPE wd_this->elements_jp_zzest.


  FIELD-SYMBOLS: <ls_line> TYPE wd_this->element_jobliste.


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails
           )->get_child_node( name = wd_this->wdctx_jobpool
           )->get_static_attributes_table( IMPORTING table = lt_jobpool ).


  " Auftragsnummer mit Filtervorschlägen befüllen.
  LOOP AT lt_jobpool ASSIGNING <ls_line>.
    " Auftragsnummer mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_aufnr ASSIGNING FIELD-SYMBOL(<ls_aufnr>).
    <ls_aufnr>-aufnr = <ls_line>-aufnr.

    " Auftragsart mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_auart ASSIGNING FIELD-SYMBOL(<ls_auart>).
    <ls_auart>-auart = <ls_line>-auart.

    " Prio mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zpprio ASSIGNING FIELD-SYMBOL(<ls_zpprio>).
    <ls_zpprio>-zpprio = <ls_line>-zpprio.

    " Kurztext mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_ktext ASSIGNING FIELD-SYMBOL(<ls_ktext>).
    <ls_ktext>-ktext = <ls_line>-ktext.

    APPEND INITIAL LINE TO lt_gltrp ASSIGNING FIELD-SYMBOL(<ls_gltrp>).
    <ls_gltrp>-gltrp = zcl_ia_2utilities=>get_dats_as_formated_string( <ls_line>-gltrp ).

    APPEND INITIAL LINE TO lt_zzkmvpl ASSIGNING FIELD-SYMBOL(<ls_zzkmvpl>).
    <ls_zzkmvpl>-zzkmvpl = <ls_line>-zzkmvpl.

    APPEND INITIAL LINE TO lt_zzkmbpl ASSIGNING FIELD-SYMBOL(<ls_zzkmbpl>).
    <ls_zzkmbpl>-zzkmbpl = <ls_line>-zzkmbpl.

    APPEND INITIAL LINE TO lt_zstdkz ASSIGNING FIELD-SYMBOL(<ls_zstdkz>).
    <ls_zstdkz>-zstdkz = <ls_line>-zstdkz.

    " Didok mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zdidok ASSIGNING FIELD-SYMBOL(<ls_zdidok>).
    <ls_zdidok>-zdidok = <ls_line>-zdidok.

    " Lage mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zlage ASSIGNING FIELD-SYMBOL(<ls_zlage>).
    <ls_zlage>-zlage = <ls_line>-zlage.

    " Intervallart mit Filtervorschlägen befüllen.
    APPEND INITIAL LINE TO lt_zintervall ASSIGNING FIELD-SYMBOL(<ls_zintervall>).
    <ls_zintervall>-zintervall = <ls_line>-zintervall.

    APPEND INITIAL LINE TO lt_zzest ASSIGNING FIELD-SYMBOL(<ls_zzest>).
    <ls_zzest>-zzest = <ls_line>-zzest.

    APPEND INITIAL LINE TO lt_zzzugangsart ASSIGNING FIELD-SYMBOL(<ls_zzzugangsart>).
    <ls_zzzugangsart>-zzzugangsart = <ls_line>-zzzugangsart.

  ENDLOOP.

  SORT lt_aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_aufnr.
  parent_element->get_child_node( name = wd_this->wdctx_jp_aufnr )->bind_table( EXPORTING new_items = lt_aufnr ).


  SORT lt_auart BY auart.
  DELETE ADJACENT DUPLICATES FROM lt_auart.
  parent_element->get_child_node( name = wd_this->wdctx_jp_auart )->bind_table( EXPORTING new_items = lt_auart
                                                                                set_initial_elements = abap_true ).

  SORT lt_zpprio BY zpprio.
  DELETE ADJACENT DUPLICATES FROM lt_zpprio.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zpprio )->bind_table( EXPORTING new_items = lt_zpprio ).

  SORT lt_ktext BY ktext.
  DELETE ADJACENT DUPLICATES FROM lt_ktext.
  parent_element->get_child_node( name = wd_this->wdctx_jp_ktext )->bind_table( EXPORTING new_items = lt_ktext ).

  SORT lt_gltrp BY gltrp.
  DELETE ADJACENT DUPLICATES FROM lt_gltrp.
  parent_element->get_child_node( name = wd_this->wdctx_jp_gltrp )->bind_table( EXPORTING new_items = lt_gltrp ).

  SORT lt_zzkmvpl BY zzkmvpl.
  DELETE ADJACENT DUPLICATES FROM lt_zzkmvpl.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zzkmvpl )->bind_table( EXPORTING new_items = lt_zzkmvpl ).

  SORT lt_zzkmbpl BY zzkmbpl.
  DELETE ADJACENT DUPLICATES FROM lt_zzkmbpl.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zzkmbpl )->bind_table( EXPORTING new_items = lt_zzkmbpl ).

  SORT lt_zdidok BY zdidok.
  DELETE ADJACENT DUPLICATES FROM lt_zdidok.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zdidok )->bind_table( EXPORTING new_items = lt_zdidok ).

  SORT lt_zstdkz BY zstdkz.
  DELETE ADJACENT DUPLICATES FROM lt_zstdkz.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zstdkz )->bind_table( EXPORTING new_items = lt_zstdkz ).

  SORT lt_zlage BY zlage.
  DELETE ADJACENT DUPLICATES FROM lt_zlage.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zlage )->bind_table( EXPORTING new_items = lt_zlage ).

  SORT lt_zintervall BY zintervall.
  DELETE ADJACENT DUPLICATES FROM lt_zintervall.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zintervall )->bind_table( EXPORTING new_items = lt_zintervall ).

  SORT lt_zzest BY zzest.
  DELETE ADJACENT DUPLICATES FROM lt_zzest.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zzest )->bind_table( EXPORTING new_items = lt_zzest ).

  SORT lt_zzzugangsart BY zzzugangsart.
  DELETE ADJACENT DUPLICATES FROM lt_zzzugangsart.
  parent_element->get_child_node( name = wd_this->wdctx_jp_zzzugangsart )->bind_table( EXPORTING new_items = lt_zzzugangsart ).

ENDMETHOD.

METHOD supply_legend_cbt .
  DATA: lt_legend_cbt TYPE wd_this->elements_legend_cbt.

  APPEND INITIAL LINE TO lt_legend_cbt ASSIGNING FIELD-SYMBOL(<ls_legend_cbt>).

  <ls_legend_cbt>-category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_interval_provided ).
  <ls_legend_cbt>-tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/INTERVAL_PLANNED' ).

  APPEND INITIAL LINE TO lt_legend_cbt ASSIGNING <ls_legend_cbt>.
  <ls_legend_cbt>-category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_plannig_started ).
  <ls_legend_cbt>-tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/PLANNING_STARTED' ).

  APPEND INITIAL LINE TO lt_legend_cbt ASSIGNING <ls_legend_cbt>.
  <ls_legend_cbt>-category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_disposition_released ).
  <ls_legend_cbt>-tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DISPOSITION_RELEASED' ).

  APPEND INITIAL LINE TO lt_legend_cbt ASSIGNING <ls_legend_cbt>.
  <ls_legend_cbt>-category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_shift_released ).
  <ls_legend_cbt>-tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFT_RELEASED' ).


  APPEND INITIAL LINE TO lt_legend_cbt ASSIGNING <ls_legend_cbt>.
  <ls_legend_cbt>-category = wd_this->get_categ_for_schstatus( zif_ia_2_wrkshft_status=>mc_multiple_shifts ).
  <ls_legend_cbt>-tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MULTIPLE_SHIFTS' ).


  node->bind_table( new_items            = lt_legend_cbt
                    set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_log_po_data .

  DATA: lt_log_po_data TYPE wd_this->elements_log_po_data.

  DATA(lv_schicht) = wd_this->mo_curr_arbstelle->get_schicht( )->get_data( )-zschicht.
  DATA(lv_peri) = wd_this->mo_curr_arbstelle->get_schicht( )->get_data( )-zzperi.

**  SELECT * FROM zia_2po_data INTO CORRESPONDING FIELDS OF TABLE @lt_log_po_data UP TO 100 ROWS
**    WHERE schicht = @lv_schicht
**      AND zzperi  = @lv_peri
**    ORDER BY request_date ASCENDING.
  lt_log_po_data = wd_assist->get_po_data( iv_peri = lv_peri iv_shift = lv_schicht ).

  node->bind_table(
    new_items            =  lt_log_po_data
    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_markings_cbt .

  DATA: ls_date_navigator TYPE wd_this->element_date_navigator_cbt,
        lt_markings_cbt   TYPE wd_this->elements_markings_cbt,
        ls_markings_cbt   TYPE wd_this->element_markings_cbt.

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_date_navigator ).

  zcl_ia_2utilities=>get_date_interval( EXPORTING iv_startdatum = ls_date_navigator-startswith
                                        IMPORTING ev_lastselecteddate = DATA(lv_end_datum) ).
  DATA(lv_date) = ls_date_navigator-startswith.

  WHILE lv_date <= lv_end_datum.
    "Setze Datum
    ls_markings_cbt-date = lv_date.

    " Setze Farbe
    ls_markings_cbt-category = get_categ_for_marking( iv_date      = lv_date
                                                      iv_perimeter = 'CBT' ).

    APPEND ls_markings_cbt TO lt_markings_cbt. CLEAR ls_markings_cbt.
    lv_date = lv_date + 1.
  ENDWHILE.

  node->bind_table( new_items            = lt_markings_cbt
                    set_initial_elements = abap_true ).
ENDMETHOD.

method SUPPLY_MARKINGS_GBT .

 DATA: ls_date_navigator TYPE wd_this->element_date_navigator_gbt,
        lt_markings_gbt   TYPE wd_this->elements_markings_gbt,
        ls_markings_gbt   TYPE wd_this->element_markings_gbt.

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_date_navigator ).

  zcl_ia_2utilities=>get_date_interval( EXPORTING iv_startdatum = ls_date_navigator-startswith
                                        IMPORTING ev_lastselecteddate = DATA(lv_end_datum) ).
  DATA(lv_date) = ls_date_navigator-startswith.

  WHILE lv_date <= lv_end_datum.
    "Setze Datum
    ls_markings_gbt-date = lv_date.

    " Setze Farbe
    ls_markings_gbt-category = get_categ_for_marking( iv_date      = lv_date
                                                      iv_perimeter = 'GBT' ).

    APPEND ls_markings_gbt TO lt_markings_gbt. CLEAR ls_markings_gbt.
    lv_date = lv_date + 1.
  ENDWHILE.

  node->bind_table( new_items            = lt_markings_gbt
                    set_initial_elements = abap_true ).
*
endmethod.

METHOD supply_mat_fzg .

  wd_this->mo_cc_schdet_mat_table->supply_mat_fzg( io_node = node io_parent_element = parent_element ).

ENDMETHOD.

METHOD supply_mat_table_data .

  wd_this->mo_cc_schdet_mat_table->supply_mat_table_data( io_node = node io_parent_element = parent_element ).

ENDMETHOD.

METHOD supply_mat_table_dd_fzg_pos .
  wd_this->mo_cc_schdet_mat_table->supply_mat_table_dd_fzg_pos( io_node = node io_parent_element = parent_element ).

ENDMETHOD.

METHOD supply_mat_table_ui .

  wd_this->mo_cc_schdet_mat_table->supply_mat_table_ui( io_node = node io_parent_element = parent_element ).

ENDMETHOD.

METHOD supply_orientierung_dd .

  wd_this->mo_cc_schdet_fzeuge->supply_orientation_dd( node           = node
                                                       parent_element = parent_element ).
ENDMETHOD.

METHOD supply_reihung_dd .
  wd_this->mo_cc_schdet_fzeuge->supply_reihung_dd( node           = node
                                                 parent_element = parent_element ).
ENDMETHOD.

METHOD supply_schichtdetails .
  DATA(ls_schichtdetails) = VALUE wd_this->element_schichtdetails( ).
  DATA(ls_tab_schichten)  = VALUE wd_this->element_tabs_schichten( ).
*  DATA(lt_schichtplan)    = VALUE wd_this->elements_schichtplan( ).



  DATA(li_tab_schichten_node) = wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten ).
  IF li_tab_schichten_node IS BOUND.
    DATA(li_schicht_tab_elem) = li_tab_schichten_node->get_lead_selection( ).
    CHECK li_schicht_tab_elem IS BOUND.
    li_schicht_tab_elem->get_static_attributes( IMPORTING static_attributes = ls_tab_schichten ).
  ENDIF.

  IF ls_tab_schichten-object IS BOUND.
    DATA(ls_schicht) = ls_tab_schichten-object->get_data( ).
    DATA(lv_status)  = ls_tab_schichten-object->get_status( ).
    ls_schichtdetails = CORRESPONDING #( ls_tab_schichten-object->get_data( ) ).
    ls_schichtdetails-zstatus = SWITCH #( ls_schichtdetails-zstatus
      WHEN zif_ia_2_wrkshft_status=>mc_plannig_started      THEN 'S10'
      WHEN zif_ia_2_wrkshft_status=>mc_disposition_released THEN 'S20'
      WHEN zif_ia_2_wrkshft_status=>mc_shift_released       THEN 'S30'
      ELSE ls_schichtdetails-zstatus  ).
    ls_schichtdetails-object            = ls_tab_schichten-object.
    ls_schichtdetails-show_edit_btn     = abap_true.
    ls_schichtdetails-show_edit_btn_as  = abap_true.
    IF lv_status = zif_ia_2_wrkshft_status=>mc_plannig_started   OR
       lv_status = zif_ia_2_wrkshft_status=>mc_disposition_released .
      ls_schichtdetails-design         = COND #( WHEN ls_tab_schichten-object->is_locked( ) THEN 01 ELSE 00 ).
      ls_schichtdetails-edit_mode      = COND #( WHEN ls_tab_schichten-object->is_locked( ) THEN abap_true ELSE abap_false ).
      ls_schichtdetails-notes_visibile = COND #( WHEN ls_tab_schichten-object->is_locked( ) THEN abap_true ELSE abap_false ).
    ELSE.
      ls_schichtdetails-design = 00.
      ls_schichtdetails-edit_mode        = abap_false.
      ls_schichtdetails-notes_visibile   = abap_false.
      ls_schichtdetails-show_edit_btn    = abap_false.
      ls_schichtdetails-show_edit_btn_as = abap_false.
    ENDIF.

***
*** >001<  ### Start ###
***
* Check edit authority for Erhaltungsplaner
    DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
    wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
    IF ls_auth_erhaltungsplaner-auth_erhaltungsplaner IS INITIAL.
      ls_schichtdetails-show_edit_btn = abap_false.
      ls_schichtdetails-show_edit_btn_as = abap_false.
    ENDIF.
***
*** >001<  ### End ###
***

    IF ls_schichtdetails-object->get_notes( ) IS NOT INITIAL.
      ls_schichtdetails-notes_icon     = '~Icon/PlaintextFile'.
      ls_schichtdetails-notes_tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS_EXIST' ).
      ##SUBRC_OK     ls_schichtdetails-notes_visibile = COND #( WHEN ls_schichtdetails-edit_mode EQ abap_true OR sy-subrc = 0 THEN abap_true ELSE abap_false ). ##SUBRC_OK
    ELSE.
      ls_schichtdetails-notes_icon = '~Icon/NewItem'.
      ls_schichtdetails-notes_tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS_CREATE' ).
    ENDIF.

    wd_this->mo_cc_schdet_jobpool->set_perimeter( ls_schichtdetails-zzperi ).

    DATA(lv_met_type) = ls_tab_schichten-object->get_met_type( ).
    ls_schichtdetails-is_met_20_sedrun_active = COND #( WHEN lv_met_type = zif_ia_2_met=>mc_met_type-sed THEN abap_true ).
    ls_schichtdetails-is_met_40_faido_active  = COND #( WHEN lv_met_type = zif_ia_2_met=>mc_met_type-fad THEN abap_true ).

    ls_schichtdetails-beschr =  |{ zcl_ia_2utilities=>get_dats_as_formated_string( ls_schicht-start_datum ) } / {
                                   ls_schicht-start_zeit(2) }:{ ls_schicht-start_zeit+2(2) } - { ls_schicht-end_zeit(2) }:{ ls_schicht-end_zeit+2(2) }|.
    ls_schichtdetails-beschr_2 = ls_tab_schichten-object->get_bezeichnung_schicht( ).
    ls_schichtdetails-beschr_tooltip = |ID: { ls_schicht-zschicht ALPHA = OUT }|.          ">003< (+)

  ENDIF.

  IF  wd_this->mo_curr_arbstelle IS BOUND.
    ls_schichtdetails-as_header_text = wd_this->mo_curr_arbstelle->get_wd_header_text( ).
  ENDIF.

  " UI Anzeige unterschiedlich für GBT und CBT (MET und OSS)
  wd_this->mo_ui_element_properties->set_ui_schicht_perimeter_mode( iv_perimeter      = ls_schichtdetails-object->get_data( )-zzperi
                                                                    iv_tremola_active = ls_schichtdetails-object->is_tremola_active( ) ).

  IF wd_this->mo_curr_arbstelle IS BOUND. ">002< +
    wd_this->mo_ui_element_properties->set_vis_sp_details( iv_data = COND #( WHEN wd_this->mo_curr_arbstelle->is_btg( ) EQ abap_true THEN abap_false ELSE abap_true ) ).
  ENDIF.                                  ">002< +
  ls_schichtdetails-button_reiloscope = wd_this->get_button_reiloscope( io_schicht = ls_schichtdetails-object ).

  node->bind_element( new_item = ls_schichtdetails  set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_schichtplan .
  wd_this->mo_cc_schichtplan->supply_schichtplan( node           = node
                                                parent_element = parent_element ).
ENDMETHOD.

METHOD supply_signalabschnitte.
  DATA: ls_auftraege_alv    TYPE wd_this->element_auftraege_alv,
        lt_signalabschnitte TYPE wd_this->elements_signalabschnitte,
        lt_zest_values      TYPE TABLE OF zia_2sc-zest,
 ##NEEDED       lv_need_e           TYPE abap_bool,
        lo_auftrag          TYPE REF TO zcl_ia_2order,
    ##NEEDED    lv_km_von           TYPE zia_2_km_von,
        lv_km_bis           TYPE ZIA_2_KM_bis,
        lv_perimter         TYPE zia_2_perimeters.

  " Get selected data from context
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_auftraege_alv
           )->get_lead_selection( )->get_static_attributes( IMPORTING static_attributes = ls_auftraege_alv ).

  " Create object to get additional data
  lo_auftrag = NEW zcl_ia_2order( iv_aufnr = ls_auftraege_alv-aufnr ).

  " Get dynamic values for km_von, km_bis, and perimter
  lv_km_von = lo_auftrag->get_data( )-zzkmvpl.
  lv_km_bis = lo_auftrag->get_data( )-zzkmbpl.
  lv_perimter = lo_auftrag->get_data( )-zzperi.
  DATA  lt_zest_eq TYPE RANGE OF zia_2sc-zest.
  " Get z_section data into lt_aufk_ext_sp
*  SELECT z_section
*    FROM eaml_d_lfe_data
*    INTO TABLE @DATA(lt_aufk_ext_sp)
*    WHERE tabkey EQ @ls_auftraege_alv-aufnr.

  DATA(lt_aufk_ext_sp) = wd_assist->select_block_section( iv_aufnr = ls_auftraege_alv-aufnr ).

  " Loop through lt_aufk_ext_sp and split z_section into lt_zest_values
  LOOP AT lt_aufk_ext_sp ASSIGNING FIELD-SYMBOL(<ls_sp>).

    " Split z_section string into internal table lt_zest_values
    SPLIT <ls_sp>-z_section AT ',' INTO TABLE lt_zest_values.

    LOOP AT lt_zest_values INTO DATA(lv_zest_value).     "#EC CI_NESTED
      CASE lv_zest_value(1).
*      CASE <ls_sp>-z_section(1).
        WHEN 'E' OR 'W'.
          APPEND VALUE #( sign = 'I'
                          option = 'EQ'
                          low = lv_zest_value ) TO lt_zest_eq.

        WHEN 'X'.
*          lv_need_e = abap_true.
          APPEND VALUE #( sign = 'I'
                                  option = 'EQ'
                                  low = 'X' ) TO lt_zest_eq.

        WHEN OTHERS.
          APPEND VALUE #( sign = 'I'
                          option = 'EQ'
                          low = lv_zest_value ) TO lt_zest_eq.
      ENDCASE.
    ENDLOOP.

  ENDLOOP.

  " SELECT records for matched zest values (E, W, X dynamic values)
  IF lt_zest_eq IS NOT INITIAL.
***    SELECT *
***      FROM zia_2sc
***      WHERE km_von <= @lv_km_bis
***        AND km_bis >= @lv_km_von
***        AND zzperi = @lv_perimter
***        AND zest IN @lt_zest_eq
***      INTO CORRESPONDING FIELDS OF TABLE @lt_signalabschnitte.
    DATA(lt_signal_data) = wd_assist->get_signal_sections( iv_km_bis = lv_km_bis
                                                          iv_km_von = lv_km_von
                                                          iv_perimter = lv_perimter
                                                          it_zest_eq = lt_zest_eq
                                                          iv_need_e = lv_need_e
                                                          iv_need_w = abap_true ).
    SORT lt_signal_data BY zsa ASCENDING.
    MOVE-CORRESPONDING lt_signal_data TO lt_signalabschnitte.
  ENDIF.

  " Handle special case for zest LIKE 'E%' (only if needed)
***  IF lv_need_e = abap_true.
***    SELECT *
***      FROM zia_2sc
***      WHERE km_von <= @lv_km_bis
***        AND km_bis >= @lv_km_von
***        AND zzperi = @lv_perimter
***        AND zest LIKE 'E%'
***      APPENDING CORRESPONDING FIELDS OF TABLE @lt_signalabschnitte.
***  ENDIF.
****
****  " Handle special case for zest LIKE 'W%' (only if needed)
***  IF lv_need_w = abap_true.
***    SELECT *
***      FROM zia_2sc
***      WHERE km_von_2 <= @lv_km_bis
***        AND km_bis_2 >= @lv_km_von
***        AND zzperi = @lv_perimter
***        AND zest LIKE 'W%'
***      APPENDING CORRESPONDING FIELDS OF TABLE @lt_signalabschnitte.
***  ENDIF.

  " Bind results to context node
  node->bind_table( EXPORTING new_items            = lt_signalabschnitte
                              set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_sitzplatz .
  wd_this->mo_cc_schdet_qualif->supply_sitzplatze( node           = node
                                                 parent_element = parent_element ).
ENDMETHOD.

METHOD supply_sp_ehb_filtered .
  DATA: lt_sp_ehb          TYPE wd_this->elements_sp_ehb,
        lt_sp_ehb_filtered TYPE wd_this->elements_sp_ehb_filtered,
        ls_sp_details      TYPE wd_this->element_sp_details.

  parent_element->get_child_node( name = wd_this->wdctx_sp_ehb )->get_static_attributes_table( IMPORTING table = lt_sp_ehb ).
  parent_element->get_child_node( name = wd_this->wdctx_sp_details )->get_static_attributes( IMPORTING static_attributes = ls_sp_details ).

  LOOP AT lt_sp_ehb ASSIGNING FIELD-SYMBOL(<ls_sp_ehb>).
    CHECK ls_sp_details-sp_filter CS <ls_sp_ehb>-sp_filter.
    APPEND INITIAL LINE TO lt_sp_ehb_filtered ASSIGNING FIELD-SYMBOL(<ls_sp_ehb_filtered>).
    MOVE-CORRESPONDING <ls_sp_ehb> TO <ls_sp_ehb_filtered>.
  ENDLOOP.

  node->bind_table( new_items            = lt_sp_ehb_filtered
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_sp_intvart .
  DATA: lt_sp_intvart  TYPE wd_this->elements_sp_intvart,
        ls_schichtplan TYPE wd_this->element_schichtplan,
        lt_sp_schicht  TYPE zia_2sp_schicht_t.

  parent_element->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
  lt_sp_schicht = ls_schichtplan-object->get_sp_schicht( ).

  LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>).
    APPEND INITIAL LINE TO lt_sp_intvart ASSIGNING FIELD-SYMBOL(<ls_sp_intvart_wd>).
    <ls_sp_intvart_wd>-sperrabschnitt = <ls_sp_schicht>-sperrabschnitt.
    <ls_sp_intvart_wd>-zintervallart = <ls_sp_schicht>-zintervallart.
  ENDLOOP.

  node->bind_table( new_items            = lt_sp_intvart
                   set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_sp_intvart_as .
  DATA: lt_sp_intvart_as TYPE wd_this->elements_sp_intvart_as,
        lt_sp_schicht    TYPE zia_2sp_schicht_t.

  lt_sp_schicht = wd_this->mo_curr_arbstelle->get_schicht( )->get_sp_schicht( ).

  LOOP AT lt_sp_schicht ASSIGNING FIELD-SYMBOL(<ls_sp_schicht>).
    APPEND INITIAL LINE TO lt_sp_intvart_as ASSIGNING FIELD-SYMBOL(<ls_sp_intvart_wd>).
    <ls_sp_intvart_wd>-sperrabschnitt = <ls_sp_schicht>-sperrabschnitt.
    <ls_sp_intvart_wd>-zintervallart = <ls_sp_schicht>-zintervallart.
  ENDLOOP.

  node->bind_table( new_items            = lt_sp_intvart_as
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_ubsng_osn .
  DATA lt_ubsng_osn TYPE wd_this->elements_ubsng_osn.

  APPEND INITIAL LINE TO lt_ubsng_osn ASSIGNING FIELD-SYMBOL(<ls_ubsng_osn>).
  <ls_ubsng_osn>-height = 0.
  <ls_ubsng_osn>-length = 0.

  node->bind_table( new_items            = lt_ubsng_osn
                    set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_ui_arbeitsstelle .
  IF wd_this->mo_ui_element_properties IS NOT INITIAL.
    DATA(ls_ui_arbeitsstelle) = wd_this->mo_ui_element_properties->get_ui_arbeitsstelle( ).
  ENDIF.

  IF wd_this->mo_curr_arbstelle IS BOUND.
    DATA(lo_schicht)            = wd_this->mo_curr_arbstelle->get_schicht( ).

*--- General UI settings
    ls_ui_arbeitsstelle-vis_direction_markr = COND #( WHEN lo_schicht->get_data( )-zzperi = zif_ia_2_constant=>mc_perim-gbt THEN abap_true ELSE abap_false ).

*--- UI Settings for Versorgung
    IF lo_schicht->is_versorgung_schicht( ).
      ls_ui_arbeitsstelle-vis_spalte_as_fzg_ref = abap_true.
    ENDIF.

*--- UI Settings for Keine Fahrt + Entssorgung Schichts
    DATA(lo_versorgung_schicht) = lo_schicht->get_versorgung_schicht( ).
    IF lo_versorgung_schicht IS BOUND.
*      DATA(lv_supply_type) = wd_this->mo_curr_arbstelle->get_schicht( )->get_parameter( )->get_data( )-supply_type.
*      IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung.
      IF  lo_schicht->get_parameter( )->get_data( )-supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt OR
      lo_schicht->get_parameter( )->get_data( )-supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung .
        ls_ui_arbeitsstelle-vis_lta_versorgung_schicht =  abap_true.      "Blue Link (navigation-new tab) to Vrsorgung Schicht
      ELSE.
        ls_ui_arbeitsstelle-vis_lta_versorgung_schicht = abap_false.      "Blue Link (navigation-new tab) to Vrsorgung Schicht
      ENDIF.
    ENDIF.
    IF lo_schicht->is_entsorgung_schicht( )  OR
       lo_schicht->is_keine_farhrt_schicht( ).
      ls_ui_arbeitsstelle-vis_spalte_as_fzg_quelle = abap_true.
      ls_ui_arbeitsstelle-rea_ckb_fz_ausw          = abap_true.
      ls_ui_arbeitsstelle-rea_dd_as_fz_reihung     = abap_true.
      ls_ui_arbeitsstelle-rea_ckb_as_fz_etcs       = abap_true.
      ls_ui_arbeitsstelle-rea_ckb_as_fz_orient     = abap_true.
      ls_ui_arbeitsstelle-ena_btn_as_fz_add        = abap_false.
      ls_ui_arbeitsstelle-ena_btn_as_fz_remove     = abap_false.
    ENDIF.

*--- UI Settings for Versorgung + Keine Fahrt + Entssorgung Schichts
    IF ls_ui_arbeitsstelle-ena_btn_fzg_ref = abap_true.                 "Button Fahrzeug Ref. (abpa_true = edit mode)
      "Show button only for Versorgung + Keine Fahrt + Entssorgung Schichts
      IF lo_schicht->is_versorgung_schicht( )  OR
         lo_schicht->is_entsorgung_schicht( )  OR
         lo_schicht->is_keine_farhrt_schicht( ).
        ls_ui_arbeitsstelle-ena_btn_fzg_ref = abap_true.
      ELSE.
        ls_ui_arbeitsstelle-ena_btn_fzg_ref = abap_false.
      ENDIF.
    ENDIF.
  ENDIF.


  node->bind_structure( new_item = ls_ui_arbeitsstelle  set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_ui_schicht .
  DATA: ls_ui_schicht TYPE zia_2_ui_shift_s.

  IF wd_this->mo_ui_element_properties IS NOT INITIAL.
    wd_this->set_ui_schicht_status( ).
    ls_ui_schicht = wd_this->mo_ui_element_properties->get_ui_schicht( ).
  ENDIF.

  DATA lo_schicht TYPE REF TO zcl_ia_2workshift.

  TRY .
      wd_context->get_child_node( wd_this->wdctx_schichtdetails )->get_attribute( EXPORTING name  = 'OBJECT'
                                                                                  IMPORTING value = lo_schicht ).

      ls_ui_schicht-ena_btn_po_daten = COND #( WHEN lo_schicht->get_status( ) = '3' THEN abap_true ELSE abap_false ).

    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

*** >001<  ### Start ###
* Check edit authority for Erhaltungsplaner
  DATA ls_auth_erhaltungsplaner TYPE wd_this->element_authorizations.
  wd_context->get_child_node( name = wd_this->wdctx_authorizations )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_auth_erhaltungsplaner ).
  IF ls_auth_erhaltungsplaner-auth_erhaltungsplaner IS INITIAL.
    ls_ui_schicht-ena_btn_po_daten = abap_false.
  ENDIF.
*** >001<  ### End ###

  ">002< + begin
  ls_ui_schicht-ena_btn_ez_formation_bestimmen = abap_true.
  IF lo_schicht IS BOUND.
    IF lo_schicht->is_keine_farhrt_schicht( ).
      ls_ui_schicht-ena_btn_ez_formation_bestimmen = abap_false.
      ls_ui_schicht-ena_btn_berechnung_tremola     = abap_false.
    ENDIF.
  ENDIF.
  ">002< + end

  node->bind_structure( new_item             =  ls_ui_schicht
                        set_initial_elements = abap_true ).

ENDMETHOD.

endclass.
