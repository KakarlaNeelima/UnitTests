class CL_CC_UEBERSICHT_Ctr implementation.
 
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
  " Initialize the custom controller for the main schedule table
  wd_this->mo_cc_main_schtab = wd_this->get_cc_main_schtab_ctr( ).

  " Set the constant for opening the popup related to 'Arbeitsstelle' (workplace)
  wd_this->mc_popup_arbstelle_open = `ARBEITSSTELLE_OFFNEN`.

  " Set the constant for the popup related to searching the order number (Auftragsnummer)
  wd_this->mc_popup_auftrag_suchen = `AUFTRAGSNUMMER_SUCHEN`.

  " Set the field name for the shift ID (Schicht ID) to a constant value
  wd_this->mc_field_schicht_id = 'SCHICHT_ID'.

ENDMETHOD.

METHOD check_auftrag_before_add .
  DATA(lv_last_perimeter) = wd_this->get_last_perimeter( ).

  DATA(lv_message) = ``.
  DATA(lt_messages) = VALUE stringtab( ).
*
  IF is_auftrag-zschicht IS NOT INITIAL.
*    " Auftrag already assigned to Schicht
    DATA(lv_aufnr) = CONV symsgv( |{ is_auftrag-aufnr ALPHA = OUT }| ).
    DATA(lv_schicht_date) = wd_this->get_schicht_date( is_auftrag-zschicht ).
    DATA(lv_arbstl) = wd_this->get_arbstelle_id( iv_aufnr = is_auftrag-aufnr ).
    MESSAGE i083(zia_2_real) WITH is_auftrag-ktext lv_aufnr lv_schicht_date lv_arbstl INTO lv_message.
    APPEND lv_message TO lt_messages.
    DATA(lo_parameters) = NEW zcl_ia_2parameters_generic( VALUE #( ( name = wd_this->mc_field_schicht_id dref = REF #( is_auftrag-zschicht ) ) ) ).
    wd_comp_controller->open_popup_message_with_params( EXPORTING iv_popup_id     = wd_this->mc_popup_arbstelle_open
                                                                  io_parameters   = lo_parameters
                                                                  iv_message_type = if_wd_window=>co_msg_type_information
                                                                  it_text         = lt_messages[]
                                                                  iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SEARCH_ORDER_NUMBER' )
                                                                  iv_button_kind  = if_wd_window=>co_buttons_okcancel
                                                                  iv_btn1_text    = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/OPEN_JOB_POSITION' ) ).
    RETURN.
  ELSE.

    IF is_auftrag-aufnr IS INITIAL.
*      " Auftrag not found
      MESSAGE e082(zia_2_real) WITH iv_aufnr INTO lv_message.
      APPEND lv_message TO lt_messages.
    ELSEIF is_auftrag-zzperi <> lv_last_perimeter.
*      " Auftrag is not for selected perimeter
      MESSAGE e902(zia_2_real) WITH is_auftrag-aufnr lv_last_perimeter INTO lv_message.
      APPEND lv_message TO lt_messages.
      lv_message = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/PLEASE_CHANGE_PLANNING_PERIMETER' ).
      APPEND lv_message TO lt_messages.
    ENDIF.
*
    IF lt_messages[] IS NOT INITIAL.
      wd_comp_controller->open_popup_message_with_params( EXPORTING it_text         = lt_messages[]
                                                                    iv_button_kind  = if_wd_window=>co_buttons_ok
                                                                    iv_message_type = if_wd_window=>co_msg_type_error
                                                                    iv_popup_id     = wd_this->mc_popup_auftrag_suchen
                                                                    iv_window_title = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SEARCH_ORDER_NUMBER' ) ).
      RETURN.
    ENDIF.

  ENDIF.
  rv_value = abap_true.
ENDMETHOD.

METHOD fill_aks_atg_ort.
  CONSTANTS: lc_classtype_zia    TYPE klassenart VALUE 'ZIA' ##NEEDED,
             lc_char_aks_atg_ort TYPE string      VALUE 'ZIA_5_AKS_ATG_ORT'.

  TYPES: BEGIN OF ts_objek,
           objek TYPE cuobn,
           aufnr TYPE aufnr,
         END OF  ts_objek.
  TYPES: BEGIN OF ts_objnum,
           objnum TYPE cuobn,
           objek  TYPE cuobn,
         END OF ts_objnum.

  DATA lt_objek  TYPE STANDARD TABLE OF ts_objek  WITH DEFAULT KEY .
  DATA lt_objnum TYPE STANDARD TABLE OF ts_objnum WITH DEFAULT KEY.
  DATA lv_atinn TYPE atinn.

  " Check if input table ct_auftraege is not empty
  IF ct_auftraege IS NOT INITIAL.
    " Select functional locations (tplnr_int) linked to orders (aufnr)
**    SELECT aufnr, tplnr_int
**      FROM viaufkst_iflos
**      INTO TABLE @DATA(lt_iflos)
**      FOR ALL ENTRIES IN @ct_auftraege
**      WHERE aufnr = @ct_auftraege-aufnr.
    DATA(lt_iflos) = wd_assist->get_pm_order_status( it_auftrage = ct_auftraege ).
    " If no records found, exit the method early
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDIF.

  " Sort the functional locations by order number
  SORT lt_iflos BY aufnr.
  " Remove duplicate entries by aufnr
  DELETE ADJACENT DUPLICATES FROM lt_iflos COMPARING aufnr.

  " Create internal table lt_objek from lt_iflos with objek = tplnr_int and aufnr
  lt_objek = VALUE #( FOR <ls_iflos> IN lt_iflos ( objek = <ls_iflos>-tplnr_int aufnr = <ls_iflos>-aufnr ) ).

  " If there are objects found, proceed
  IF lt_objek IS NOT INITIAL.
    " Select classification object assignments from INOB table
*    SELECT cuobj, objek
*      FROM inob
*      INTO TABLE @DATA(lt_inob)
*      FOR ALL ENTRIES IN @lt_objek
*      WHERE objek = @lt_objek-objek
*        AND klart = @lc_classtype_zia
*        AND obtab = @lc_objecttable.
    DATA(lt_inob) = wd_assist->get_inob_data( it_objek = lt_objek ).
  ENDIF.

  " If classification assignments were found
  IF lt_inob IS NOT INITIAL.
    " Convert characteristic name to internal ATINN format
    CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
      EXPORTING
        input  = lc_char_aks_atg_ort
      IMPORTING
        output = lv_atinn.

    " Map classification objects to objnum and objek for lookup
    lt_objnum = VALUE #( FOR <ls_inob_objek> IN lt_inob ( objnum = <ls_inob_objek>-cuobj objek = <ls_inob_objek>-objek ) ).

    " Select characteristic values (atwrt) for objects from AUSP table
*    SELECT objek, atwrt
*      FROM ausp
*      INTO TABLE @DATA(lt_ausp)
*      FOR ALL ENTRIES IN @lt_objnum
*      WHERE objek = @lt_objnum-objnum
*        AND atinn = @lv_atinn
*        AND klart = @lc_classtype_zia.

    DATA(lt_ausp) = wd_assist->get_ausp_data( it_objnum = lt_objnum iv_atinn = lv_atinn ).

  ENDIF.

  " Loop over characteristic values to assign them back to corresponding orders
  LOOP AT lt_ausp ASSIGNING FIELD-SYMBOL(<ls_ausp>).
    " Find objnum entry matching ausp.objek
    ASSIGN lt_objnum[ objnum = <ls_ausp>-objek ] TO FIELD-SYMBOL(<ls_objnum>).
    CHECK sy-subrc = 0.

    " Find objek entry matching objnum.objek
    ASSIGN lt_objek[ objek = <ls_objnum>-objek ] TO FIELD-SYMBOL(<ls_objek>).
    CHECK sy-subrc = 0.

    " Find order in ct_auftraege matching objek.aufnr
    ASSIGN ct_auftraege[ aufnr = <ls_objek>-aufnr ] TO FIELD-SYMBOL(<ls_auftraege>).
    CHECK sy-subrc = 0.

    " Assign the characteristic value (atwrt) to the aks_atg_ort field of the order
    <ls_auftraege>-aks_atg_ort = <ls_ausp>-atwrt.
  ENDLOOP.

ENDMETHOD.

METHOD fill_funcloc_descr .
  " EXIT early IF there are no orders to PROCESS
  CHECK ct_auftraege IS NOT INITIAL.
  " Loop through all orders and update the PLTXT field
  LOOP AT ct_auftraege ASSIGNING FIELD-SYMBOL(<ls_ord>).
    " Read functional location description for the current TPLNR
    " and store it in the PLTXT field
    <ls_ord>-pltxt = wd_assist->get_func_loc_descr(
                        iv_tplnr = <ls_ord>-tplnr ).
  ENDLOOP.
ENDMETHOD.

METHOD fill_zest.

  " Exit if input is empty
  CHECK ct_auftraege IS NOT INITIAL.

  DATA: lt_aufk_ext_sp TYPE eaml_t_lfe_data,
        lv_calc_date   TYPE dats.

  " Calculate date 30 days from today
  lv_calc_date = sy-datum + 30.

  TYPES: BEGIN OF ts_tabkey,
           tabkey TYPE eaml_d_lfe_data-tabkey,
         END OF ts_tabkey.

  DATA: lt_tabkey TYPE STANDARD TABLE OF ts_tabkey WITH EMPTY KEY,
        ls_tabkey TYPE ts_tabkey.
  DATA lv_maintordovrlprocsubphase TYPE eam_ostat_sphase.

  LOOP AT ct_auftraege INTO DATA(ls_auftrag).
    CLEAR ls_tabkey.
    " Convert aufnr to tabkey type (ensures same type/length)
    ls_tabkey-tabkey = CONV #( ls_auftrag-aufnr ).
    APPEND ls_tabkey TO lt_tabkey.
  ENDLOOP.

  IF lt_tabkey IS NOT INITIAL.
**    SELECT tabkey, z_section
**      FROM eaml_d_lfe_data
**      INTO CORRESPONDING FIELDS OF TABLE @lt_aufk_ext_sp
**      FOR ALL ENTRIES IN @lt_tabkey
**      WHERE tabkey = @lt_tabkey-tabkey.
    lt_aufk_ext_sp =  wd_assist->get_blocking_section( it_aufnr_key = lt_tabkey  ).
  ENDIF.

  " Enrich each order
  LOOP AT ct_auftraege ASSIGNING FIELD-SYMBOL(<ls_auftrag>).

    " Optional: Assign blocking sections
    <ls_auftrag>-zzest = zcl_ia_2order=>get_assigned_sperrabs(
                           it_data = lt_aufk_ext_sp
                           iv_aufnr = <ls_auftrag>-aufnr ).

    " Map zid_eiz to zeiz
    CASE <ls_auftrag>-zid_eiz.
      WHEN 10. <ls_auftrag>-zeiz = 'GBTN'.
      WHEN 20. <ls_auftrag>-zeiz = 'GBTS'.
    ENDCASE.

    " Set status icon and tooltip based on gltrp date
    IF <ls_auftrag>-gltrp > lv_calc_date.
      <ls_auftrag>-status_icon = 'ICON_GREEN_LIGHT'.
      <ls_auftrag>-status_tooltip = cl_wd_utilities=>get_otr_text_by_alias(
                                        'ZIA_2GBT_PG2/JOBPOOL_STATUS_OK' ).
    ELSEIF <ls_auftrag>-gltrp > sy-datum.
      <ls_auftrag>-status_icon = 'ICON_YELLOW_LIGHT'.
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = 'ZIA_2_REAL'
          msgnr               = '008'
          msgv1               = <ls_auftrag>-aufnr
        IMPORTING
          message_text_output = <ls_auftrag>-status_tooltip.
    ELSE.
      <ls_auftrag>-status_icon = 'ICON_RED_LIGHT'.
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = 'ZIA_2_REAL'
          msgnr               = '009'
          msgv1               = <ls_auftrag>-aufnr
        IMPORTING
          message_text_output = <ls_auftrag>-status_tooltip.
    ENDIF.
    lv_maintordovrlprocsubphase = <ls_auftrag>-maintordovrlprocsubphase.
    DATA(lv_subphase) =  wd_assist->get_results( iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
    <ls_auftrag>-eamovrlprocsubphasedesc  = lv_subphase.

  ENDLOOP.

ENDMETHOD.

METHOD get_arbstelle_id .
  DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = iv_aufnr ).
  DATA(ls_auftrag) = lo_auftrag->get_data( ).

  DATA(lo_arbstelle) = zcl_ia_2wrkplace=>get_instance( iv_schicht_id = ls_auftrag-zschicht
                                                       iv_arbstle_id = ls_auftrag-zarbstl ).

  DATA(lv_zugangsart) = COND #( WHEN ls_auftrag-zzzugangsart IS NOT INITIAL THEN ls_auftrag-zzzugangsart ELSE zcl_ia_2utilities=>mc_zugangsart_schiene ).

  rv_value = lo_arbstelle->get_text_id( iv_zugangsart = lv_zugangsart ).
  CHECK rv_value IS INITIAL.

  rv_value = lo_arbstelle->get_text_id( iv_zugangsart = zcl_ia_2utilities=>mc_zugangsart_strasse ).
ENDMETHOD.

METHOD get_clauses_for_aufnr .

 " Build the WHERE clause dynamically using the provided order number (AUFNR)
  " The clause is formatted as a string and placed into a string table
  " Result: et_where = VALUE #( ( 'aufnr EQ '12345678'' ) )
  et_where = VALUE #( ( |aufnr EQ '{ iv_aufnr }'| ) ).

  " Set the ORDER BY clause to sort by AUFNR
  ev_order = 'aufnr'.

ENDMETHOD.

METHOD get_clauses_for_selpar .
  " Declare a table to hold conditions in HR-like structure (field, operator, low value)
  DATA lt_cond TYPE STANDARD TABLE OF hrcond.

  " Initialize a string table for interval-related SQL conditions
  DATA(lt_intervall_condition) = VALUE stringtab( ( |AND| ) ). " Start with 'AND' to concatenate later

  " Loop through selected interval types from the selection parameters
  LOOP AT is_sel_par-intervalarten ASSIGNING FIELD-SYMBOL(<lv_intervalart>).

    " Build a condition for each interval type: ZINTERVALL = <value>
    APPEND VALUE #( field = 'ZINTERVALL'
                    opera = 'EQ'
                    low   = <lv_intervalart>
                  ) TO lt_cond.

  ENDLOOP.

  " If any interval conditions were built
  IF lt_cond IS NOT INITIAL.

    " Prepare a temporary string table to hold the WHERE clause from the function module
    DATA(lt_calc_intervall_condition) = VALUE stringtab( ).

    " Use SAP standard FM to build a valid dynamic WHERE clause based on the condition table
    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable      = 'ZIA_2ORDER'                  " Target table
      TABLES
        condtab      = lt_cond                        " Input conditions (field/operator/value)
        where_clause = lt_calc_intervall_condition.   " Output: dynamic SQL WHERE clauses as strings

    " Append the dynamically built conditions to the interval condition table
    APPEND LINES OF lt_calc_intervall_condition TO lt_intervall_condition.

  ELSE.
    " No intervals: clear the condition list
    CLEAR: lt_intervall_condition.
  ENDIF.

  " Build the base WHERE clause using perimeter and check that zschicht is empty
  et_where = VALUE #(
    ( |zzperi EQ '{ is_sel_par-perimeter }' AND zschicht EQ ''| )
  ).

  " Define complex dynamic date conditions as a string table
  DATA(lt_date_condition) = VALUE stringtab( ( | AND ( ( gstrp LE '{ is_sel_par-firstselecteddate }' AND ( gltrp GE '{ is_sel_par-firstselecteddate }' AND gltrp LE '{ is_sel_par-lastselecteddate }' ) ) OR ( gstrp LE '{
      is_sel_par-firstselecteddate }' AND gltrp GE '{ is_sel_par-lastselecteddate }' ) OR ( ( gstrp GE '{ is_sel_par-firstselecteddate }' AND gstrp LE '{ is_sel_par-lastselecteddate }' ) AND gltrp GE '{
      is_sel_par-lastselecteddate }' ) )| ) ).

  " If interval conditions exist, append them to the final WHERE clause
  IF lt_intervall_condition[] IS NOT INITIAL.
    APPEND LINES OF lt_intervall_condition TO et_where.
  ENDIF.

  " If filtering by date is enabled, append date conditions to the WHERE clause
  IF is_sel_par-by_datum = abap_true.
    APPEND LINES OF lt_date_condition TO et_where.
  ENDIF.

  " Determine the ORDER BY clause based on selection type:
  " If the user selected "END DATE" (based on OTR text), sort by gltrp and gsuzp ascending
  " Otherwise, sort by priority and time
  ev_order = COND #(
    WHEN is_sel_par-selection = cl_wd_utilities=>get_otr_text_by_alias('ZIA_2GBT_PG2/ENDDATE')
    THEN 'gltrp ASCENDING, gsuzp ASCENDING'
    ELSE 'zpprio ASCENDING, gsuzp ASCENDING'
  ).

ENDMETHOD.

METHOD get_last_perimeter .
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator )->get_attribute( EXPORTING name = 'PERIMETER' IMPORTING value = rv_value ).
ENDMETHOD.

METHOD get_schicht_date .
  CHECK iv_schicht IS NOT INITIAL.

  DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = iv_schicht ).
  DATA(ls_schicht) = lo_schicht->get_data( ).

  WRITE ls_schicht-start_datum TO rv_value.
  CONDENSE rv_value.
ENDMETHOD.

METHOD get_schicht_object .

  ro_schicht = wd_this->mo_cc_main_schtab->get_schicht_object( iv_schicht = iv_schicht ).
  CHECK ro_schicht IS NOT BOUND.

  ro_schicht = NEW zcl_ia_2workshift( iv_zschicht = iv_schicht ).
ENDMETHOD.

METHOD search_aufnr_in_jobpool .
  DATA(lt_auftrag_alv) = wd_this->select_auftraege( is_sel_par = VALUE #( aufnr = iv_aufnr ) ).

  READ TABLE lt_auftrag_alv INTO DATA(ls_auftrag_alv) INDEX 1.
  CHECK wd_this->check_auftrag_before_add( iv_aufnr = iv_aufnr is_auftrag = ls_auftrag_alv ).

  DATA(lt_auftraege_alv) = VALUE wd_this->elements_auftraege_alv( ).
  DATA(li_node_alv) = wd_context->get_child_node( name = wd_this->wdctx_auftraege
                               )->get_child_node( name = wd_this->wdctx_auftraege_alv ).
  li_node_alv->get_static_attributes_table( IMPORTING table = lt_auftraege_alv ).

  DELETE lt_auftraege_alv WHERE aufnr = ls_auftrag_alv-aufnr.
  INSERT ls_auftrag_alv INTO lt_auftraege_alv INDEX 1.

  li_node_alv->bind_table( EXPORTING new_items            = lt_auftraege_alv[]
                                     set_initial_elements = abap_true ).
ENDMETHOD.

METHOD select_auftraege .
  " Initialize an internal table to hold dynamic WHERE conditions
  DATA(lt_where_condition) = VALUE stringtab( ).

  " Initialize a string to hold dynamic ORDER BY clause
  DATA(lv_order_by) = VALUE string( ).

  " Check if a specific order number (AUFNR) is provided in the selection parameters
  IF is_sel_par-aufnr IS NOT INITIAL.

    " Build WHERE and ORDER BY clauses specifically for the given AUFNR
    get_clauses_for_aufnr(
      EXPORTING  iv_aufnr = is_sel_par-aufnr
      IMPORTING  et_where = lt_where_condition
                 ev_order = lv_order_by
    ).

  ELSE.

    " Build generic WHERE and ORDER BY clauses based on the full selection parameters
    get_clauses_for_selpar(
      EXPORTING  is_sel_par = is_sel_par
      IMPORTING  et_where   = lt_where_condition
                 ev_order   = lv_order_by
    ).

  ENDIF.

  " Perform a SELECT using the dynamically built WHERE and ORDER BY clauses
*  SELECT * FROM zia_2order INTO CORRESPONDING FIELDS OF TABLE @rt_auftraege
*    WHERE (lt_where_condition)
*    ORDER BY (lv_order_by).

  DATA(lt_order) = wd_assist->get_order_data( it_where_condition = lt_where_condition iv_order_by = lv_order_by ).
  MOVE-CORRESPONDING lt_order TO rt_auftraege.
  " Enrich the result set with additional data: fill ZEST-related fields
  wd_this->fill_zest( CHANGING ct_auftraege = rt_auftraege ).

  " Further enrich result set with AKS, ATG, and ORT data
  wd_this->fill_aks_atg_ort( CHANGING ct_auftraege = rt_auftraege ).

  wd_this->fill_funcloc_descr( CHANGING ct_auftraege = rt_auftraege ).

ENDMETHOD.

METHOD SUPPLY_AUFTRAEGE_ALV .
  " Initialize selection parameter structure for job orders
  DATA(ls_sel_par) = VALUE zia_2_order_sel_par_s( ).

  " Initialize structures to hold context data for date navigator
  DATA(ls_date_nav) = VALUE wd_this->element_date_navigator( ).
  DATA(ls_date_navigator) = VALUE wd_this->element_date_navigator_gbt( ).

  " Read static attributes of the top-level date navigator context node
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator
           )->get_static_attributes( IMPORTING static_attributes = ls_date_nav ).

  " Read static attributes of the subnode representing the last clicked calendar
  wd_context->get_child_node( name = wd_this->wdctx_date_navigator
           )->get_child_node( name = ls_date_nav-last_klicked_calender
           )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_date_navigator ).

  " Initialize structures for jobpool date and selection context nodes
  DATA(ls_jobpool_datum) = VALUE wd_this->element_jobpool_datum( ).
  DATA(ls_jobpool_selection) = VALUE wd_this->element_jobpool_selection( ).

  " Read jobpool date from the context node under auftraege
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_jobpool_datum
           )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_jobpool_datum ).

  " Read jobpool selection from the context node under auftraege
  wd_context->get_child_node( name = wd_this->wdctx_auftraege
           )->get_child_node( name = wd_this->wdctx_jobpool_selection
           )->get_static_attributes( IMPORTING static_attributes = ls_jobpool_selection ).

  " Loop through all selected 'intervallarten' elements and collect them
  LOOP AT wd_context->get_child_node( name = wd_this->wdctx_auftraege
                   )->get_child_node( name = wd_this->wdctx_intervallarten
                   )->get_selected_elements(  ) ASSIGNING FIELD-SYMBOL(<li_element>).

    " Temporary structure to hold individual 'intervallarten' attributes
    DATA(ls_intervallarten) = VALUE wd_this->element_intervallarten( ).

    " Read static attributes for each selected intervallart
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_intervallarten ).

    " Append intervallart to the list in selection parameters
    APPEND ls_intervallarten-intervallarten TO ls_sel_par-intervalarten.
  ENDLOOP.

  " Transfer remaining values into the selection structure
  ls_sel_par-perimeter = ls_date_nav-perimeter.
  ls_sel_par-firstselecteddate = ls_date_navigator-firstselecteddate.
  ls_sel_par-lastselecteddate  = ls_date_navigator-lastselecteddate.
  ls_sel_par-by_datum          = ls_jobpool_datum-by_datum.
  ls_sel_par-selection         = ls_jobpool_selection-selection.

  " Call a method to fetch job orders based on the collected selection parameters
  DATA(lt_auftraege_alv) = wd_this->select_auftraege( is_sel_par = ls_sel_par ).

  " Bind the result list to the context node (ALV or table UI element)
  node->bind_table( new_items            = lt_auftraege_alv
                    set_initial_elements = abap_true ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_arbeitsstelle_open .
  CHECK iv_popup_id = wd_this->mc_popup_arbstelle_open.

  DATA(lv_schicht_id) = CONV zia_2_workshift( io_parameters->get_string( iv_name = wd_this->mc_field_schicht_id ) ).

  DATA(lo_schicht) = wd_this->get_schicht_object( iv_schicht = lv_schicht_id ).

  wd_comp_controller->open_schicht_tab( io_schicht = lo_schicht ).
ENDMETHOD.

endclass.
 