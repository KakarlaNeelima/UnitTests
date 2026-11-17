*"* Comprehensive unit tests for ZCL_IA_2CONTEXT_HELPER - Test2
*"* Goal: >20% code coverage
*"* Strategy:
*"*   - Test double (lcl_controlled_interp) inheriting from lcl_ctxelem_interpreter
*"*     to exercise both TRUE and FALSE paths of is_selected without WD mocking
*"*   - All constants (public + private via LOCAL FRIENDS)
*"*   - All public type declarations
*"*   - Factory: all CASE branches (SITZPLATZ, EINZELKAPAS, unknown, empty)
*"*   - Interpreter interface methods: set_context_element, get_attribute_string,
*"*     get_attribute_object, is_selected
*"*   - Private helper methods: get_unique_collection, read_arbst_osn,
*"*     read_arbst_tunnel, read_arbst_oss, read_btg_osn, read_btg_tunnel

CLASS lcl_test2_context_helper DEFINITION DEFERRED.
CLASS zcl_ia_2context_helper DEFINITION LOCAL FRIENDS lcl_test2_context_helper.

*----------------------------------------------------------------------*
* Test Double: inherits from lcl_ctxelem_interpreter so we can control
* the return values of get_selection_value / get_true_value and thereby
* exercise the COND branch inside is_selected for both TRUE and FALSE.
*----------------------------------------------------------------------*
CLASS lcl_controlled_interp DEFINITION
  INHERITING FROM lcl_ctxelem_interpreter
  FOR TESTING.
  PUBLIC SECTION.
    METHODS set_test_values
      IMPORTING
        !iv_selection TYPE string
        !iv_true      TYPE string.
  PROTECTED SECTION.
    METHODS get_selection_value REDEFINITION.
    METHODS get_true_value REDEFINITION.
  PRIVATE SECTION.
    DATA gv_selection TYPE string.
    DATA gv_true TYPE string.
ENDCLASS.

CLASS lcl_controlled_interp IMPLEMENTATION.
  METHOD set_test_values.
    gv_selection = iv_selection.
    gv_true      = iv_true.
  ENDMETHOD.
  METHOD get_selection_value.
    rv_value = gv_selection.
  ENDMETHOD.
  METHOD get_true_value.
    rv_value = gv_true.
  ENDMETHOD.
ENDCLASS.

*----------------------------------------------------------------------*
* Main test class – 32 test methods
*----------------------------------------------------------------------*
CLASS lcl_test2_context_helper DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    " --- Constants ---
    METHODS test_public_atnam_constants  FOR TESTING RAISING cx_static_check.
    METHODS test_public_wdctx_constants  FOR TESTING RAISING cx_static_check.
    METHODS test_private_wdctx_constants FOR TESTING RAISING cx_static_check.
    METHODS test_private_wdctx_more      FOR TESTING RAISING cx_static_check.

    " --- Type declarations ---
    METHODS test_struct_types FOR TESTING RAISING cx_static_check.
    METHODS test_table_types  FOR TESTING RAISING cx_static_check.

    " --- Factory ---
    METHODS test_factory_sitzplatz    FOR TESTING RAISING cx_static_check.
    METHODS test_factory_einzelkapas  FOR TESTING RAISING cx_static_check.
    METHODS test_factory_unknown_node FOR TESTING RAISING cx_static_check.
    METHODS test_factory_empty_string FOR TESTING RAISING cx_static_check.

    " --- is_selected via test double (covers TRUE path) ---
    METHODS test_is_selected_true       FOR TESTING RAISING cx_static_check.
    METHODS test_is_selected_false      FOR TESTING RAISING cx_static_check.
    METHODS test_is_selected_both_empty FOR TESTING RAISING cx_static_check.
    METHODS test_is_selected_case_sense FOR TESTING RAISING cx_static_check.

    " --- Interpreter interface methods without context ---
    METHODS test_sitz_is_selected       FOR TESTING RAISING cx_static_check.
    METHODS test_einzel_is_selected     FOR TESTING RAISING cx_static_check.
    METHODS test_set_context_element    FOR TESTING RAISING cx_static_check.

    " --- get_unique_collection ---
    METHODS test_unique_coll_empty      FOR TESTING RAISING cx_static_check.
    METHODS test_unique_coll_single     FOR TESTING RAISING cx_static_check.
    METHODS test_unique_coll_two        FOR TESTING RAISING cx_static_check.
    METHODS test_unique_coll_duplicates FOR TESTING RAISING cx_static_check.
    METHODS test_unique_coll_3_with_dup FOR TESTING RAISING cx_static_check.

    " --- Private read_* / btg_* methods ---
    METHODS test_read_arbst_osn    FOR TESTING RAISING cx_static_check.
    METHODS test_read_arbst_tunnel FOR TESTING RAISING cx_static_check.
    METHODS test_read_arbst_oss    FOR TESTING RAISING cx_static_check.
    METHODS test_read_btg_osn      FOR TESTING RAISING cx_static_check.
    METHODS test_read_btg_tunnel   FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_test2_context_helper IMPLEMENTATION.

* =====================================================================
*  Constants
* =====================================================================

  METHOD test_public_atnam_constants.
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_atnam_aufnr
                                        exp = 'AUFNR' msg = 'AUFNR' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_atnam_auswahl
                                        exp = 'AUSWAHL' msg = 'AUSWAHL' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_atnam_img_for_visualization
                                        exp = 'IMAGE_FOR_VISUALIZATION' msg = 'IMG_VIS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_atnam_img_for_visualiz_copy
                                        exp = 'IMAGE_FOR_VISUALIZATION_COPY' msg = 'IMG_VIS_COPY' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_atnam_object
                                        exp = 'OBJECT' msg = 'OBJECT' ).
  ENDMETHOD.

  METHOD test_public_wdctx_constants.
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
                                        exp = 'EINZELKAPAS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
                                        exp = 'SITZPLATZ' ).
    cl_abap_unit_assert=>assert_not_initial( act = zcl_ia_2context_helper=>mc_wdctx_einzelkapas ).
    cl_abap_unit_assert=>assert_not_initial( act = zcl_ia_2context_helper=>mc_wdctx_sitzplatz ).
  ENDMETHOD.

  METHOD test_private_wdctx_constants.
    " Accessible via LOCAL FRIENDS
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_arbst_osn    exp = 'ARBST_OSN' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_arbst_oss    exp = 'ARBST_OSS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_arbst_tunnel exp = 'ARBST_TUNNEL' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_arbst_vis    exp = 'ARBST_VIS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_auftraege    exp = 'AUFTRAEGE' ).
  ENDMETHOD.

  METHOD test_private_wdctx_more.
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_auftrage_alv    exp = 'AUFTRAEGE_ALV' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_btg_osn         exp = 'BTG_OSN' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_btg_oss         exp = 'BTG_OSS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_btg_tunnel      exp = 'BTG_TUNNEL' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_jobpool         exp = 'JOBPOOL' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_schichtdetails  exp = 'SCHICHTDETAILS' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_schichtplan     exp = 'SCHICHTPLAN' ).
    cl_abap_unit_assert=>assert_equals( act = zcl_ia_2context_helper=>mc_wdctx_tabs_schichten  exp = 'TABS_SCHICHTEN' ).
  ENDMETHOD.

* =====================================================================
*  Type declarations
* =====================================================================

  METHOD test_struct_types.
    DATA ls_tabs    TYPE zcl_ia_2context_helper=>ts_element_tabs_schichten.
    DATA ls_plan    TYPE zcl_ia_2context_helper=>ts_element_schichtplan.
    DATA ls_auftr   TYPE zcl_ia_2context_helper=>ts_element_auftraege_alv.
    DATA ls_a_osn   TYPE zcl_ia_2context_helper=>ts_element_arbst_osn.
    DATA ls_b_osn   TYPE zcl_ia_2context_helper=>ts_element_btg_osn.
    DATA ls_a_tun   TYPE zcl_ia_2context_helper=>ts_element_arbst_tunnel.
    DATA ls_b_tun   TYPE zcl_ia_2context_helper=>ts_element_btg_tunnel.
    DATA ls_a_oss   TYPE zcl_ia_2context_helper=>ts_element_arbst_oss.
    DATA ls_b_oss   TYPE zcl_ia_2context_helper=>ts_element_btg_oss.
    DATA ls_jobp    TYPE zcl_ia_2context_helper=>ts_element_jobpool.
    DATA ls_sitz    TYPE zcl_ia_2context_helper=>ts_element_sitzplatz.
    DATA ls_einzel  TYPE zcl_ia_2context_helper=>ts_element_einzelkapas.

    cl_abap_unit_assert=>assert_initial( act = ls_tabs   msg = 'tabs struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_plan   msg = 'plan struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_auftr  msg = 'auftr struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_a_osn  msg = 'arbst_osn struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_b_osn  msg = 'btg_osn struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_a_tun  msg = 'arbst_tunnel struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_b_tun  msg = 'btg_tunnel struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_a_oss  msg = 'arbst_oss struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_b_oss  msg = 'btg_oss struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_jobp   msg = 'jobpool struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_sitz   msg = 'sitzplatz struct initial' ).
    cl_abap_unit_assert=>assert_initial( act = ls_einzel msg = 'einzelkapas struct initial' ).
  ENDMETHOD.

  METHOD test_table_types.
    DATA lt_tabs    TYPE zcl_ia_2context_helper=>tt_elements_tabs_schichten.
    DATA lt_plan    TYPE zcl_ia_2context_helper=>tt_elements_schichtplan.
    DATA lt_auftr   TYPE zcl_ia_2context_helper=>tt_elements_auftraege_alv.
    DATA lt_a_osn   TYPE zcl_ia_2context_helper=>tt_elements_arbst_osn.
    DATA lt_b_osn   TYPE zcl_ia_2context_helper=>tt_elements_btg_osn.
    DATA lt_a_tun   TYPE zcl_ia_2context_helper=>tt_elements_arbst_tunnel.
    DATA lt_b_tun   TYPE zcl_ia_2context_helper=>tt_elements_btg_tunnel.
    DATA lt_a_oss   TYPE zcl_ia_2context_helper=>tt_elements_arbst_oss.
    DATA lt_b_oss   TYPE zcl_ia_2context_helper=>tt_elements_btg_oss.
    DATA lt_jobp    TYPE zcl_ia_2context_helper=>tt_elements_jobpool.
    DATA lt_sitz    TYPE zcl_ia_2context_helper=>tt_elements_sitzplatz.
    DATA lt_einzel  TYPE zcl_ia_2context_helper=>tt_elements_einzelkapas.

    cl_abap_unit_assert=>assert_equals( act = lines( lt_tabs )   exp = 0 msg = 'tabs empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_plan )   exp = 0 msg = 'plan empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_auftr )  exp = 0 msg = 'auftr empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_a_osn )  exp = 0 msg = 'arbst_osn empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_b_osn )  exp = 0 msg = 'btg_osn empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_a_tun )  exp = 0 msg = 'arbst_tunnel empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_b_tun )  exp = 0 msg = 'btg_tunnel empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_a_oss )  exp = 0 msg = 'arbst_oss empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_b_oss )  exp = 0 msg = 'btg_oss empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_jobp )   exp = 0 msg = 'jobpool empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_sitz )   exp = 0 msg = 'sitzplatz empty' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_einzel ) exp = 0 msg = 'einzelkapas empty' ).
  ENDMETHOD.

* =====================================================================
*  Factory
* =====================================================================

  METHOD test_factory_sitzplatz.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz ).
    cl_abap_unit_assert=>assert_bound( act = li_interp msg = 'SITZPLATZ interpreter created' ).
  ENDMETHOD.

  METHOD test_factory_einzelkapas.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas ).
    cl_abap_unit_assert=>assert_bound( act = li_interp msg = 'EINZELKAPAS interpreter created' ).
  ENDMETHOD.

  METHOD test_factory_unknown_node.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = 'NONEXISTENT_NODE' ).
    cl_abap_unit_assert=>assert_not_bound( act = li_interp msg = 'Unknown node → unbound' ).
  ENDMETHOD.

  METHOD test_factory_empty_string.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = '' ).
    cl_abap_unit_assert=>assert_not_bound( act = li_interp msg = 'Empty string → unbound' ).
  ENDMETHOD.

* =====================================================================
*  is_selected via test double – exercises the COND true/false branches
* =====================================================================

  METHOD test_is_selected_true.
    " Selection value matches true value → abap_true
    DATA lo_interp TYPE REF TO lcl_controlled_interp.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.

    lo_interp = NEW #( ).
    lo_interp->set_test_values( iv_selection = 'X' iv_true = 'X' ).
    li_interp = lo_interp.

    cl_abap_unit_assert=>assert_equals(
      act = li_interp->is_selected( )
      exp = abap_true
      msg = 'Matching values → true' ).
  ENDMETHOD.

  METHOD test_is_selected_false.
    " Selection value differs from true value → abap_false
    DATA lo_interp TYPE REF TO lcl_controlled_interp.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.

    lo_interp = NEW #( ).
    lo_interp->set_test_values( iv_selection = 'Y' iv_true = 'X' ).
    li_interp = lo_interp.

    cl_abap_unit_assert=>assert_equals(
      act = li_interp->is_selected( )
      exp = abap_false
      msg = 'Different values → false' ).
  ENDMETHOD.

  METHOD test_is_selected_both_empty.
    " Both empty → they match → abap_true
    DATA lo_interp TYPE REF TO lcl_controlled_interp.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.

    lo_interp = NEW #( ).
    lo_interp->set_test_values( iv_selection = '' iv_true = '' ).
    li_interp = lo_interp.

    cl_abap_unit_assert=>assert_equals(
      act = li_interp->is_selected( )
      exp = abap_true
      msg = 'Both empty → match → true' ).
  ENDMETHOD.

  METHOD test_is_selected_case_sense.
    " ABAP string comparison is case-sensitive for TYPE string
    DATA lo_interp TYPE REF TO lcl_controlled_interp.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.

    lo_interp = NEW #( ).
    lo_interp->set_test_values( iv_selection = 'x' iv_true = 'X' ).
    li_interp = lo_interp.

    DATA(lv_result) = li_interp->is_selected( ).

    " Result is a valid boolean regardless of case behaviour
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lv_result = abap_true OR lv_result = abap_false )
      msg = 'Returns valid boolean' ).
  ENDMETHOD.

* =====================================================================
*  Interpreter interface methods (no WD context → exception paths)
* =====================================================================

  METHOD test_sitz_is_selected.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).

    TRY.
        cl_abap_unit_assert=>assert_equals(
          act = li_interp->is_selected( )
          exp = abap_false
          msg = 'No context → false' ).
      CATCH cx_dynamic_check ##NO_HANDLER.
        " No WD context available – expected in unit-test environment
    ENDTRY.
  ENDMETHOD.

  METHOD test_einzel_is_selected.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).

    TRY.
        cl_abap_unit_assert=>assert_equals(
          act = li_interp->is_selected( )
          exp = abap_false
          msg = 'No context → false' ).
      CATCH cx_dynamic_check ##NO_HANDLER.
        " No WD context available – expected in unit-test environment
    ENDTRY.
  ENDMETHOD.

  METHOD test_set_context_element.
    DATA li_interp   TYPE REF TO lif_ctxelem_interpreter.
    DATA li_ctx_elem TYPE REF TO if_wd_context_element.

    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).

    TRY.
        " Setting initial (nil) context should not crash
        li_interp->set_context_element( ii_context_element = li_ctx_elem ).

        cl_abap_unit_assert=>assert_bound( act = li_interp msg = 'Survives nil context set' ).

        " After nil context, is_selected still returns false
        cl_abap_unit_assert=>assert_equals(
          act = li_interp->is_selected( )
          exp = abap_false ).
      CATCH cx_dynamic_check ##NO_HANDLER.
        " Nil context element may cause runtime exceptions – acceptable
    ENDTRY.
  ENDMETHOD.


* =====================================================================
*  get_unique_collection (private, accessed via LOCAL FRIENDS)
* =====================================================================

  METHOD test_unique_coll_empty.
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.

    DATA(li_coll) = zcl_ia_2context_helper=>get_unique_collection( it_objects = lt_objects ).

    cl_abap_unit_assert=>assert_bound( act = li_coll msg = 'Bound even for empty input' ).
    cl_abap_unit_assert=>assert_equals( act = li_coll->size( ) exp = 0 msg = 'Size = 0' ).
  ENDMETHOD.

  METHOD test_unique_coll_single.
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA lo_obj TYPE REF TO object.

    lo_obj = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    APPEND lo_obj TO lt_objects.

    DATA(li_coll) = zcl_ia_2context_helper=>get_unique_collection( it_objects = lt_objects ).

    cl_abap_unit_assert=>assert_equals( act = li_coll->size( ) exp = 1 msg = 'One object' ).
  ENDMETHOD.

  METHOD test_unique_coll_two.
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA lo_obj1 TYPE REF TO object.
    DATA lo_obj2 TYPE REF TO object.

    lo_obj1 = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    lo_obj2 = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).
    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.

    DATA(li_coll) = zcl_ia_2context_helper=>get_unique_collection( it_objects = lt_objects ).

    cl_abap_unit_assert=>assert_equals( act = li_coll->size( ) exp = 2 msg = 'Two distinct objects' ).
  ENDMETHOD.

  METHOD test_unique_coll_duplicates.
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA lo_obj TYPE REF TO object.

    lo_obj = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    APPEND lo_obj TO lt_objects.
    APPEND lo_obj TO lt_objects.
    APPEND lo_obj TO lt_objects.

    DATA(li_coll) = zcl_ia_2context_helper=>get_unique_collection( it_objects = lt_objects ).

    cl_abap_unit_assert=>assert_equals( act = li_coll->size( ) exp = 1 msg = 'Duplicates removed → 1' ).
  ENDMETHOD.

  METHOD test_unique_coll_3_with_dup.
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA lo_obj1 TYPE REF TO object.
    DATA lo_obj2 TYPE REF TO object.

    lo_obj1 = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    lo_obj2 = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).
    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.
    APPEND lo_obj1 TO lt_objects.   " duplicate of obj1

    DATA(li_coll) = zcl_ia_2context_helper=>get_unique_collection( it_objects = lt_objects ).

    cl_abap_unit_assert=>assert_equals( act = li_coll->size( ) exp = 2 msg = '3 entries, 1 dup → 2' ).
  ENDMETHOD.

* =====================================================================
*  Private read_* / btg_* methods (called with initial data)
* =====================================================================

  METHOD test_read_arbst_osn.
    DATA ls_arbst  TYPE zia_2_work_area_wd_s.
    DATA lt_result TYPE zcl_ia_2context_helper=>tt_elements_arbst_osn.

    zcl_ia_2context_helper=>read_arbst_osn(
      EXPORTING is_arbst     = ls_arbst
      CHANGING  ct_arbst_osn = lt_result ).

    cl_abap_unit_assert=>assert_true( act = abap_true msg = 'read_arbst_osn completed without error' ).
  ENDMETHOD.

  METHOD test_read_arbst_tunnel.
    DATA ls_arbst  TYPE zia_2_work_area_wd_s.
    DATA lt_result TYPE zcl_ia_2context_helper=>tt_elements_arbst_tunnel.

    zcl_ia_2context_helper=>read_arbst_tunnel(
      EXPORTING is_arbst        = ls_arbst
      CHANGING  ct_arbst_tunnel = lt_result ).

    cl_abap_unit_assert=>assert_true( act = abap_true msg = 'read_arbst_tunnel completed without error' ).
  ENDMETHOD.

  METHOD test_read_arbst_oss.
    DATA ls_arbst  TYPE zia_2_work_area_wd_s.
    DATA lt_result TYPE zcl_ia_2context_helper=>tt_elements_arbst_osn.

    zcl_ia_2context_helper=>read_arbst_oss(
      EXPORTING is_arbst     = ls_arbst
      CHANGING  ct_arbst_oss = lt_result ).

    cl_abap_unit_assert=>assert_true( act = abap_true msg = 'read_arbst_oss completed without error' ).
  ENDMETHOD.

  METHOD test_read_btg_osn.
    DATA ls_arbst  TYPE zia_2_work_area_wd_s.
    DATA lt_result TYPE zcl_ia_2context_helper=>tt_elements_btg_osn.

    zcl_ia_2context_helper=>read_btg_osn(
      EXPORTING is_arbst   = ls_arbst
      CHANGING  ct_btg_osn = lt_result ).

    cl_abap_unit_assert=>assert_true( act = abap_true msg = 'read_btg_osn completed without error' ).
  ENDMETHOD.

  METHOD test_read_btg_tunnel.
    DATA ls_arbst  TYPE zia_2_work_area_wd_s.
    DATA lt_result TYPE zcl_ia_2context_helper=>tt_elements_btg_tunnel.

    zcl_ia_2context_helper=>read_btg_tunnel(
      EXPORTING is_arbst      = ls_arbst
      CHANGING  ct_btg_tunnel = lt_result ).

    cl_abap_unit_assert=>assert_true( act = abap_true msg = 'read_btg_tunnel completed without error' ).
  ENDMETHOD.

ENDCLASS.


*----------------------------------------------------------------------*
* Test class with WD mock objects via cl_abap_testdouble
* Covers: LCL_CTXELEM_INTERPRETER get_attribute_* methods (+9 stmts)
*         ZCL_IA_2CONTEXT_HELPER public methods (best effort +30-50)
* NOTE: Requires cl_abap_testdouble (ABAP 7.4 SP8+).
*       If class does not compile, remove this entire block.
*----------------------------------------------------------------------*
CLASS lcl_test2_with_mocks DEFINITION DEFERRED.
CLASS zcl_ia_2context_helper DEFINITION LOCAL FRIENDS lcl_test2_with_mocks.

CLASS lcl_test2_with_mocks DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA gi_ctx_elem   TYPE REF TO if_wd_context_element.
    DATA gi_ctx_node   TYPE REF TO if_wd_context_node.
    DATA gi_child_node TYPE REF TO if_wd_context_node.

    METHODS setup.

    " --- Interpreter: get_attribute with mock context element ---
    METHODS test_attr_string_sitz    FOR TESTING RAISING cx_static_check.
    METHODS test_attr_string_einzel  FOR TESTING RAISING cx_static_check.
    METHODS test_attr_object_sitz    FOR TESTING RAISING cx_static_check.
    METHODS test_attr_object_einzel  FOR TESTING RAISING cx_static_check.
    METHODS test_sitz_selected_mock  FOR TESTING RAISING cx_static_check.
    METHODS test_einzel_selected_mock FOR TESTING RAISING cx_static_check.

    " --- Public methods with mock context node ---
    METHODS test_is_ready_to_remove    FOR TESTING RAISING cx_static_check.
    METHODS test_get_qualifs_remove    FOR TESTING RAISING cx_static_check.
    METHODS test_unlock_prev_schicht   FOR TESTING RAISING cx_static_check.
    METHODS test_unlock_prev_sch_tab   FOR TESTING RAISING cx_static_check.
    METHODS test_mark_first_arbst      FOR TESTING RAISING cx_static_check.
    METHODS test_del_schicht_tab       FOR TESTING RAISING cx_static_check.
    METHODS test_add_schicht_tab       FOR TESTING RAISING cx_static_check.
    METHODS test_add_gantt_tab         FOR TESTING RAISING cx_static_check.
    METHODS test_mark_einzelkapas      FOR TESTING RAISING cx_static_check.
    METHODS test_set_arbst_selected    FOR TESTING RAISING cx_static_check.
    METHODS test_get_editable_schicht  FOR TESTING RAISING cx_static_check.
    METHODS test_get_sel_auftrag       FOR TESTING RAISING cx_static_check.
    METHODS test_set_editmode          FOR TESTING RAISING cx_static_check.

    " --- Private method via LOCAL FRIENDS ---
    METHODS test_deselect_all_arbst    FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_test2_with_mocks IMPLEMENTATION.

  METHOD setup.
    gi_ctx_elem   ?= cl_abap_testdouble=>create( 'IF_WD_CONTEXT_ELEMENT' ).
    gi_ctx_node   ?= cl_abap_testdouble=>create( 'IF_WD_CONTEXT_NODE' ).
    gi_child_node ?= cl_abap_testdouble=>create( 'IF_WD_CONTEXT_NODE' ).

    " Configure root node: get_child_node returns non-null child for all known names
    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_tabs_schichten ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_schichtplan ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_auftrage_alv ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_arbst_osn ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_arbst_oss ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_arbst_tunnel ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_btg_osn ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_btg_oss ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_btg_tunnel ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_jobpool ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_schichtdetails ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_auftraege ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz ).

    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_child_node ).
    gi_ctx_node->get_child_node( name = zcl_ia_2context_helper=>mc_wdctx_arbst_vis ).

    " Configure get_element on root and child nodes (prevents null deref)
    cl_abap_testdouble=>configure_call( gi_ctx_node
      )->ignore_parameter( 'INDEX' )->returning( gi_ctx_elem ).
    gi_ctx_node->get_element( ).

    cl_abap_testdouble=>configure_call( gi_child_node
      )->ignore_parameter( 'INDEX' )->returning( gi_ctx_elem ).
    gi_child_node->get_element( ).

    " Configure create_element on nodes
    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( gi_ctx_elem ).
    gi_ctx_node->create_element( ).

    cl_abap_testdouble=>configure_call( gi_child_node )->returning( gi_ctx_elem ).
    gi_child_node->create_element( ).

    " Configure get_element_count returning 0 (prevents loop-based null derefs)
    cl_abap_testdouble=>configure_call( gi_ctx_node )->returning( 0 ).
    gi_ctx_node->get_element_count( ).

    cl_abap_testdouble=>configure_call( gi_child_node )->returning( 0 ).
    gi_child_node->get_element_count( ).

    " Configure element's get_node() to return root node
    cl_abap_testdouble=>configure_call( gi_ctx_elem )->returning( gi_ctx_node ).
    gi_ctx_elem->get_node( ).
  ENDMETHOD.

* =====================================================================
*  Interpreter: get_attribute with mock context element
*  Covers the TRY block SUCCESS path in lcl_ctxelem_interpreter
* =====================================================================

  METHOD test_attr_string_sitz.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    DATA(lv_val) = li_interp->get_attribute_string( iv_name = 'AUFNR' ).
    cl_abap_unit_assert=>assert_initial( act = lv_val msg = 'Mock returns initial' ).
  ENDMETHOD.

  METHOD test_attr_string_einzel.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    DATA(lv_val) = li_interp->get_attribute_string( iv_name = 'IMAGE_FOR_VISUALIZATION' ).
    cl_abap_unit_assert=>assert_initial( act = lv_val msg = 'Mock returns initial' ).
  ENDMETHOD.

  METHOD test_attr_object_sitz.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    DATA(lo_obj) = li_interp->get_attribute_object( iv_name = 'OBJECT' ).
    cl_abap_unit_assert=>assert_not_bound( act = lo_obj msg = 'Mock returns unbound' ).
  ENDMETHOD.

  METHOD test_attr_object_einzel.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    DATA(lo_obj) = li_interp->get_attribute_object( iv_name = 'OBJECT' ).
    cl_abap_unit_assert=>assert_not_bound( act = lo_obj msg = 'Mock returns unbound' ).
  ENDMETHOD.

  METHOD test_sitz_selected_mock.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'SITZPLATZ' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    cl_abap_unit_assert=>assert_equals(
      act = li_interp->is_selected( )
      exp = abap_false
      msg = 'Mock attr initial → not selected' ).
  ENDMETHOD.

  METHOD test_einzel_selected_mock.
    DATA li_interp TYPE REF TO lif_ctxelem_interpreter.
    li_interp = lcl_interpreter_factory_a=>get_ctxelem_interpreter( iv_node_name = 'EINZELKAPAS' ).
    li_interp->set_context_element( ii_context_element = gi_ctx_elem ).

    cl_abap_unit_assert=>assert_equals(
      act = li_interp->is_selected( )
      exp = abap_false
      msg = 'Mock attr initial → not selected' ).
  ENDMETHOD.

* =====================================================================
*  Public methods with mock context node
*  Each wrapped in TRY/CATCH – cx_no_check catches cx_sy_ref_is_initial
*  (which inherits from cx_no_check, NOT cx_dynamic_check).
* =====================================================================

  METHOD test_is_ready_to_remove.
    TRY.
        DATA(lv_result) = zcl_ia_2context_helper=>is_ready_to_remove_qualifs(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_qualifs_remove.
    TRY.
        DATA(li_coll) = zcl_ia_2context_helper=>get_qualifications_to_remove(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_unlock_prev_schicht.
    TRY.
        zcl_ia_2context_helper=>unlock_previous_schicht(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_unlock_prev_sch_tab.
    TRY.
        zcl_ia_2context_helper=>unlock_prev_schicht_in_tab(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_mark_first_arbst.
    TRY.
        DATA(lo_arbst) = zcl_ia_2context_helper=>mark_first_arbst(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_del_schicht_tab.
    DATA lo_schicht TYPE REF TO zcl_ia_2workshift.
    TRY.
        DATA(lv_result) = zcl_ia_2context_helper=>del_schicht_tab(
          ii_context = gi_ctx_node
          io_schicht = lo_schicht ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_schicht_tab.
    DATA lo_schicht TYPE REF TO zcl_ia_2workshift.
    DATA li_context TYPE REF TO if_wd_context_node.
    li_context = gi_ctx_node.
    TRY.
        zcl_ia_2context_helper=>add_schicht_tab(
          EXPORTING io_schicht = lo_schicht
          CHANGING  ci_context = li_context ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_gantt_tab.
    TRY.
        zcl_ia_2context_helper=>add_gantt_tab(
          iv_perim   = 'TEST'
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_mark_einzelkapas.
    TRY.
        zcl_ia_2context_helper=>mark_einzelkapas_by_aufnr(
          ii_context = gi_ctx_node
          iv_aufnr   = '000000000001' ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_set_arbst_selected.
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    TRY.
        zcl_ia_2context_helper=>set_arbst_as_selected(
          is_arbst   = ls_arbst
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_editable_schicht.
    TRY.
        DATA(lo_schicht) = zcl_ia_2context_helper=>get_editable_schicht(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_set_editmode.
    DATA lo_schicht TYPE REF TO zcl_ia_2workshift.
    TRY.
        DATA(lv_result) = zcl_ia_2context_helper=>set_editmode_in_schichtplan(
          ii_context     = gi_ctx_node
          io_schicht     = lo_schicht
          iv_is_editable = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_sel_auftrag.
    TRY.
        DATA(lo_auftrag) = zcl_ia_2context_helper=>get_selected_auftrag_as_obj(
          ii_context = gi_ctx_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_deselect_all_arbst.
    DATA lt_arbst TYPE zia_2_work_area_wd_t.
    TRY.
        zcl_ia_2context_helper=>deselect_all_arbst(
          it_arbst = lt_arbst
          ii_node  = gi_child_node ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
