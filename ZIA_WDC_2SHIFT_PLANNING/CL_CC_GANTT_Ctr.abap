class CL_CC_GANTT_Ctr implementation.
 
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

METHOD create_url .
  CONSTANTS lc_system_dtg TYPE string VALUE 'sapdtg00'.
  CONSTANTS lc_system_dig TYPE string VALUE 'sapdig00'.
  CONSTANTS lc_system_dpg TYPE string VALUE 'sapdpg00'.
  CONSTANTS lc_port_app   TYPE string VALUE '.sbb.ch:44300/sap/bc/ui5_ui5/sap/zui_io_5rlgantt/index.html?sap-client=101&'.
  CONSTANTS lc_lang_def   TYPE string VALUE 'DE' ##NEEDED.

  DATA(ls_fileter)    = VALUE wd_this->element_gantt_filter_gbt( ).
  DATA(ls_datenav)    = VALUE wd_this->element_date_navigator_gbt( ).
  DATA(lv_interval)   = VALUE string( ).
  DATA(lv_start_date) = VALUE string( ).
  DATA(lv_end_date)   = VALUE string( ).
  DATA(lv_lang)       = VALUE string( ).

  DATA(lv_system) = COND #( WHEN sy-sysid = 'T04' THEN lc_system_dtg
                            WHEN sy-sysid = 'Q04' THEN lc_system_dig
                            WHEN sy-sysid = 'P04' THEN lc_system_dpg ).


  wd_this->get_context_node( iv_perim = iv_perim iv_filter = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_fileter ).
  wd_this->get_context_node( iv_perim = iv_perim iv_date_nav = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_datenav ).

  lv_interval = COND #( WHEN ls_fileter-ri = abap_true THEN 'RI' ).
  lv_interval = COND #( WHEN ls_fileter-ji = abap_true THEN |{ lv_interval }| & |,| & |JI| ELSE lv_interval ).
  lv_interval = COND #( WHEN ls_fileter-li = abap_true THEN |{ lv_interval }| & |,| & |LI| ELSE lv_interval ).
  lv_interval = COND #( WHEN ls_fileter-ti = abap_true THEN |{ lv_interval }| & |,| & |TI| ELSE lv_interval ).
  lv_interval = COND #( WHEN ls_fileter-ts = abap_true THEN |{ lv_interval }| & |,| & |TS| ELSE lv_interval ).

  lv_start_date = |{ ls_datenav-firstselecteddate DATE = ISO }|.
  lv_end_date   = |{ ls_datenav-lastselecteddate  DATE = ISO }|.


  rv_url =  |https://|           &
            |{ lv_system }|      &
            |{ lc_port_app }|    &
            |sap-language=|      & |{ lv_lang }|       & |#?| &
            |Perimeter=|         & |{ iv_perim }|      & |&|  &
            |IntervalType=|      & |{ lv_interval }|   & |&|  &
            |RangeStart=|        & |{ lv_start_date }| & |&|  &
            |RangeEnd=|          & |{ lv_end_date }|   & |&|  &
            |WebDynproSessionID=| & |{ wd_this->get_session_id( ) }|.

ENDMETHOD.

METHOD exc_on_date_selected .

  wd_this->get_context_node( iv_perim = iv_perim iv_markings = abap_true )->invalidate( ).
  wd_this->get_context_node( iv_perim = iv_perim iv_schichten = abap_true )->invalidate( ).
  wd_this->get_context_node( iv_perim = iv_perim iv_url = abap_true )->invalidate( ).
ENDMETHOD.

METHOD exc_on_filter .
  DATA(lt_schichten) = VALUE wd_this->elements_schichten_gbt( ).

  wd_this->get_context_node( iv_perim = iv_perim iv_schichten = abap_true )->get_static_attributes_table( IMPORTING table = lt_schichten ).

  CASE iv_perim.
    WHEN zif_ia_2_constant=>mc_perim-cbt.
      wd_this->filter_schichten_cbt( CHANGING ct_data = lt_schichten ).
    WHEN zif_ia_2_constant=>mc_perim-gbt.
      wd_this->filter_schichten_gbt( CHANGING ct_data = lt_schichten ).
  ENDCASE.


  wd_this->get_context_node( iv_perim = iv_perim iv_schichten = abap_true )->bind_table( EXPORTING new_items = lt_schichten set_initial_elements = abap_true ).
  wd_this->get_context_node( iv_perim = iv_perim iv_url = abap_true )->invalidate( ).
  wd_comp_controller->mo_personalization_ctr->save_new( ).

ENDMETHOD.

METHOD filter_schichten_cbt .
  DATA(ls_filter) = VALUE wd_this->element_gantt_filter_gbt( ).


  wd_this->get_context_node( iv_perim = zif_ia_2_constant=>mc_perim-cbt iv_filter = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_filter ).

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

    IF ls_filter-ts = abap_true.
      IF line_exists( lt_sp_schicht[ zintervallart = zif_ia_2_constant=>mc_intervallart-ts ] ).
        <ls_data>-is_visible = abap_true.
        CONTINUE.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMETHOD.

METHOD filter_schichten_gbt .
  DATA(ls_filter) = VALUE wd_this->element_gantt_filter_gbt( ).


  wd_this->get_context_node( iv_perim = zif_ia_2_constant=>mc_perim-gbt iv_filter = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_filter ).

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
ENDMETHOD.

METHOD get_context_node .
  DATA li_node TYPE REF TO if_wd_context_node.


  DATA(lt_nodes) = wd_context->get_child_nodes( ).

  IF iv_date_nav = abap_true.
    li_node = VALUE #( lt_nodes[ name = wd_this->wdctx_date_navigator ]-node OPTIONAL ).
    ri_node = COND  #( WHEN iv_perim = zif_ia_2_constant=>mc_perim-gbt
                       THEN li_node->get_child_node( name = wd_this->wdctx_date_navigator_gbt )
                       ELSE li_node->get_child_node( name = wd_this->wdctx_date_navigator_cbt ) ).
  ENDIF.

  IF iv_markings = abap_true.
    li_node = VALUE #( lt_nodes[ name = wd_this->wdctx_date_navigator ]-node OPTIONAL ).
    ri_node = COND  #( WHEN iv_perim = zif_ia_2_constant=>mc_perim-gbt
                       THEN li_node->get_child_node( name = wd_this->wdctx_date_navigator_gbt )->get_child_node( name = wd_this->wdctx_markings_gbt )
                       ELSE li_node->get_child_node( name = wd_this->wdctx_date_navigator_cbt )->get_child_node( name = wd_this->wdctx_markings_cbt ) ).
  ENDIF.

  IF iv_schichten = abap_true.
    ri_node = COND  #( WHEN iv_perim = zif_ia_2_constant=>mc_perim-gbt
                       THEN wd_context->get_child_node( name = wd_this->wdctx_schichten_gbt )
                       ELSE wd_context->get_child_node( name = wd_this->wdctx_schichten_cbt ) ).
  ENDIF.


  IF iv_filter = abap_true.
    ri_node = COND  #( WHEN iv_perim = zif_ia_2_constant=>mc_perim-gbt
                       THEN wd_context->get_child_node( name = wd_this->wdctx_gantt_filter_gbt )
                       ELSE wd_context->get_child_node( name = wd_this->wdctx_gantt_filter_cbt  ) ).

  ENDIF.

  IF iv_url = abap_true.
    li_node = VALUE #( lt_nodes[ name = wd_this->wdctx_url ]-node OPTIONAL ).
    ri_node = COND  #( WHEN iv_perim = zif_ia_2_constant=>mc_perim-gbt
                       THEN li_node->get_child_node( name = wd_this->wdctx_url_gbt )
                       ELSE li_node->get_child_node( name = wd_this->wdctx_url_cbt ) ).
  ENDIF.
ENDMETHOD.

METHOD get_marking_category .
  CASE iv_status.
    WHEN zif_ia_2_wrkshft_status=>mc_initial.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-color_white.

    WHEN zif_ia_2_wrkshft_status=>mc_interval_provided.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_metal.

    WHEN zif_ia_2_wrkshft_status=>mc_plannig_started.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-criticalvalue_medium.

    WHEN zif_ia_2_wrkshft_status=>mc_disposition_released.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_aqua.

    WHEN zif_ia_2_wrkshft_status=>mc_shift_released.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-goodvalue_light.

    WHEN zif_ia_2_wrkshft_status=>mc_multiple_shifts.
      rv_category = cl_wd_date_nav_marking=>e_day_semantics-calendar_rose.
  ENDCASE.

ENDMETHOD.

METHOD get_session_id .
  DATA(lv_session_id) = VALUE char32( ).


  CALL FUNCTION 'TH_GET_SESSION_ID'
    IMPORTING
      session_id = lv_session_id.

  rv_data = lv_session_id.

ENDMETHOD.

METHOD open_tab_for_selected_schicht .
  DATA(lt_data)       = VALUE stringtab( ).
  DATA(lv_schicht)    = VALUE zia_2_workshift( ).
  DATA(lv_session_id) = VALUE char32( ).

  SPLIT iv_data AT '/' INTO TABLE lt_data.
  lv_schicht    = |{ VALUE #( lt_data[ 1 ] OPTIONAL ) ALPHA = IN }|.
  lv_session_id = |{ VALUE #( lt_data[ 2 ] OPTIONAL ) ALPHA = IN }|.

  "Check session id
  IF lv_session_id <> wd_this->get_session_id( ).
    RETURN.
  ENDIF.

  DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = lv_schicht ).
  IF lo_schicht IS NOT BOUND.
    RETURN.
  ENDIF.

  IF lo_schicht->is_empty( ).
    RETURN.
  ENDIF.

  "Open Schicht tab
  TRY.
      zcl_ia_2context_helper=>add_schicht_tab(
        EXPORTING
          io_schicht = lo_schicht
        CHANGING
          ci_context = wd_context ).
      wd_comp_controller->mo_curr_arbstelle = lo_schicht->get_first_arbeitsstelle( ).
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.
ENDMETHOD.

METHOD read_schichten .

*
*  SELECT zschicht
*    FROM zia_2wrkshifts
*    INTO TABLE @DATA(lt_schichten)
*    WHERE zzperi = @iv_perim
*      AND start_datum BETWEEN @iv_start_date AND @iv_end_date.
*  IF sy-subrc <> 0.
*    RETURN.
*  ENDIF.
*
**  SELECT qmnum
**    FROM qmel
**    INTO TABLE @DATA(lt_schichten)
**    WHERE qmcod = @iv_perim
**      AND strmn BETWEEN @iv_start_date AND @iv_end_date.
  DATA(lt_schichten) = wd_assist->get_workshift( iv_start_date = iv_start_date
                                                 iv_end_date = iv_end_date
                                                 iv_perim = iv_perim ).
  IF lt_schichten IS INITIAL.
    RETURN.
  ENDIF.

  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schichten>).
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = CONV #( <ls_schichten>-qmnum ) ).
    APPEND VALUE #( object      = lo_schicht
                    is_visible  = abap_true
                    start_datum = lo_schicht->get_data( )-start_datum
                    end_datum   = lo_schicht->get_data( )-end_datum
                    id          = lo_schicht->get_id( )  ) TO rt_data.
  ENDLOOP.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_button_gantt .
  DATA(ls_date_nav_old) = VALUE wd_this->element_date_navigator_gbt( ).
  DATA(ls_date_nav_new) = VALUE wd_this->element_date_navigator_gbt( ).


  ls_date_nav_new  = CORRESPONDING #( is_data ).

  DATA(li_date_nav_nd) = wd_this->get_context_node( iv_perim = is_data-perimeter iv_date_nav = abap_true ).
  li_date_nav_nd->get_static_attributes( IMPORTING static_attributes = ls_date_nav_old ).
  li_date_nav_nd->set_static_attributes( EXPORTING static_attributes = ls_date_nav_new ).

  "Check if calendar date range has been changed or is initial - invalidate only markings
  IF ls_date_nav_old-startswith <> ls_date_nav_new-startswith.
    wd_this->get_context_node( iv_perim = is_data-perimeter iv_markings = abap_true )->invalidate( ).
  ENDIF.

  "Check if the date selection has been changed - invalidate only Schichten (better performance)
  IF ls_date_nav_old-firstselecteddate <> ls_date_nav_new-firstselecteddate OR
     ls_date_nav_old-lastselecteddate  <> ls_date_nav_new-lastselecteddate.
    wd_this->get_context_node( iv_perim = is_data-perimeter iv_schichten = abap_true )->invalidate( ).
  ENDIF.

  wd_this->get_context_node( iv_perim = is_data-perimeter iv_url = abap_true )->invalidate( ).

  zcl_ia_2context_helper=>add_gantt_tab( iv_perim = is_data-perimeter ii_context = wd_context ).
  wd_this->fire_open_tab_gantt_evt( iv_perim = is_data-perimeter ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

METHOD supply_legend .
  DATA(lt_legend) = VALUE wd_this->elements_legend( ).


  APPEND VALUE #( category  = get_marking_category( iv_status = zif_ia_2_wrkshft_status=>mc_interval_provided )
                  tooltip   = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/INTERVAL_SCHEDULED' )
                 ) TO lt_legend.

  APPEND VALUE #( category = get_marking_category( iv_status = zif_ia_2_wrkshft_status=>mc_plannig_started )
                  tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/PLANNING_STARTED' )
                 ) TO lt_legend.

  APPEND VALUE #( category = get_marking_category( iv_status = zif_ia_2_wrkshft_status=>mc_disposition_released )
                  tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/RELEASE_DISPO' )
                 ) TO lt_legend.

  APPEND VALUE #( category = get_marking_category( iv_status = zif_ia_2_wrkshft_status=>mc_shift_released )
                  tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SHIFT_RELEASED' )
                ) TO lt_legend.

  APPEND VALUE #( category = get_marking_category( iv_status = zif_ia_2_wrkshft_status=>mc_multiple_shifts )
                  tooltip  = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/MULTIPLE_LAYERS' )
                 ) TO lt_legend.

  node->bind_table( new_items = lt_legend set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_markings_cbt .
  DATA(lt_markings)  = VALUE wd_this->elements_markings_cbt( ).
  DATA(ls_date_nav)  = VALUE wd_this->element_date_navigator_cbt( ).
  DATA lt_schichten    TYPE STANDARD TABLE OF zia_2_gantt_schichten_s WITH NON-UNIQUE SORTED KEY start_datum COMPONENTS start_datum.


  parent_element->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  "Get date interval
  zcl_ia_2utilities=>get_date_interval(
    EXPORTING
      iv_startdatum        = ls_date_nav-startswith
    IMPORTING
      ev_lastselecteddate  = DATA(lv_end_date) ).

  "Read Schichten
  lt_schichten = wd_this->read_schichten(
    EXPORTING
      iv_perim      = zif_ia_2_constant=>mc_perim-cbt
      iv_start_date = ls_date_nav-startswith
      iv_end_date   = lv_end_date ).


  DATA(lv_date) = ls_date_nav-startswith.
  WHILE lv_date <= lv_end_date.

    APPEND VALUE #( date     = lv_date
                    category = cl_wd_date_nav_marking=>e_day_semantics-color_white ) TO lt_markings ASSIGNING FIELD-SYMBOL(<ls_marking>).

    ASSIGN lt_schichten[ KEY start_datum start_datum = lv_date ] TO FIELD-SYMBOL(<ls_schichten>).
    IF sy-subrc = 0.
      DATA(lt_schichten_day) = FILTER #( lt_schichten USING KEY start_datum WHERE start_datum = lv_date ).
      DATA(lv_status)        = COND #( WHEN lines( lt_schichten_day ) > 1 THEN zif_ia_2_wrkshft_status=>mc_multiple_shifts ELSE <ls_schichten>-object->get_status( ) ).
      <ls_marking>-category  = wd_this->get_marking_category( lv_status ).
    ENDIF.

    lv_date = lv_date + 1.
  ENDWHILE.

  node->bind_table( new_items = lt_markings set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_markings_gbt .
  DATA(lt_markings)  = VALUE wd_this->elements_markings_gbt( ).
  DATA(ls_date_nav)  = VALUE wd_this->element_date_navigator_gbt( ).
  DATA lt_schichten    TYPE STANDARD TABLE OF zia_2_gantt_schichten_s WITH NON-UNIQUE SORTED KEY start_datum COMPONENTS start_datum.


  parent_element->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  "Get date interval
  zcl_ia_2utilities=>get_date_interval(
    EXPORTING
      iv_startdatum        = ls_date_nav-startswith
    IMPORTING
      ev_lastselecteddate  = DATA(lv_end_date) ).

  "Read Schichten
  lt_schichten = wd_this->read_schichten(
    EXPORTING
      iv_perim      = zif_ia_2_constant=>mc_perim-gbt
      iv_start_date = ls_date_nav-startswith
      iv_end_date   = lv_end_date ).


  DATA(lv_date) = ls_date_nav-startswith.
  WHILE lv_date <= lv_end_date.

    APPEND VALUE #( date     = lv_date
                    category = cl_wd_date_nav_marking=>e_day_semantics-color_white ) TO lt_markings ASSIGNING FIELD-SYMBOL(<ls_marking>).

    ASSIGN lt_schichten[ KEY start_datum start_datum = lv_date ] TO FIELD-SYMBOL(<ls_schichten>).
    IF sy-subrc = 0.
      DATA(lt_schichten_day) = FILTER #( lt_schichten USING KEY start_datum WHERE start_datum = lv_date ).
      DATA(lv_status)        = COND #( WHEN lines( lt_schichten_day ) > 1 THEN zif_ia_2_wrkshft_status=>mc_multiple_shifts ELSE <ls_schichten>-object->get_status( ) ).
      <ls_marking>-category  = wd_this->get_marking_category( lv_status ).
    ENDIF.

    lv_date = lv_date + 1.
  ENDWHILE.

  node->bind_table( new_items = lt_markings set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_schichten_cbt .
  DATA(lt_schichten_cbt) = VALUE wd_this->elements_schichten_cbt( ).
  DATA(ls_date_nav)      = VALUE wd_this->element_date_navigator_cbt( ).


  wd_this->get_context_node( iv_perim = zif_ia_2_constant=>mc_perim-cbt iv_date_nav = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  "Read Schichten
  DATA(lt_schichten) = wd_this->read_schichten(
    EXPORTING
      iv_perim      = zif_ia_2_constant=>mc_perim-cbt
      iv_start_date = ls_date_nav-firstselecteddate
      iv_end_date   = ls_date_nav-lastselecteddate ).

  "Filter Schichten
  wd_this->filter_schichten_cbt( CHANGING ct_data = lt_schichten ).

  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schichten>).
    APPEND VALUE #( is_visible  = <ls_schichten>-is_visible
                    object      = <ls_schichten>-object
                    start_datum = <ls_schichten>-object->get_data( )-start_datum
                    end_datum   = <ls_schichten>-object->get_data( )-end_datum
                    id          = |{ <ls_schichten>-object->get_id( ) ALPHA = OUT }|
                    ) TO lt_schichten_cbt.
  ENDLOOP.

  node->bind_table( new_items = lt_schichten_cbt set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_schichten_gbt .
  DATA(lt_schichten_gbt) = VALUE wd_this->elements_schichten_gbt( ).
  DATA(ls_date_nav)      = VALUE wd_this->element_date_navigator_gbt( ).


  wd_this->get_context_node( iv_perim = zif_ia_2_constant=>mc_perim-gbt iv_date_nav = abap_true )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  "Read Schichten
  DATA(lt_schichten) = wd_this->read_schichten(
    EXPORTING
      iv_perim      = zif_ia_2_constant=>mc_perim-gbt
      iv_start_date = ls_date_nav-firstselecteddate
      iv_end_date   = ls_date_nav-lastselecteddate ).

  "Filter Schichten
  wd_this->filter_schichten_gbt( CHANGING ct_data = lt_schichten ).

  LOOP AT lt_schichten ASSIGNING FIELD-SYMBOL(<ls_schichten>).
    APPEND VALUE #( is_visible  = <ls_schichten>-is_visible
                    object      = <ls_schichten>-object
                    start_datum = <ls_schichten>-object->get_data( )-start_datum
                    end_datum   = <ls_schichten>-object->get_data( )-end_datum
                    id          = |{ <ls_schichten>-object->get_id( ) ALPHA = OUT }|
                    ) TO lt_schichten_gbt.
  ENDLOOP.

  node->bind_table( new_items = lt_schichten_gbt set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_url_cbt .
  DATA(ls_url)       = VALUE wd_this->element_url_cbt( ).


  ls_url-url = wd_this->create_url( iv_perim = zif_ia_2_constant=>mc_perim-cbt ).
  node->bind_element( EXPORTING new_item = ls_url set_initial_elements = abap_true ).
ENDMETHOD.

METHOD supply_url_gbt .
*----------------------------------------------------------------------*
  DATA(ls_url) = VALUE wd_this->element_url_gbt( ).


  ls_url-url = wd_this->create_url( iv_perim = zif_ia_2_constant=>mc_perim-gbt ).
  node->bind_element( EXPORTING new_item = ls_url set_initial_elements = abap_true ).
ENDMETHOD.

endclass.
 