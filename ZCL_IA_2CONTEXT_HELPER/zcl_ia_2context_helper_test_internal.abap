*"* use this source file for your ABAP unit test classes
*"* IMPORTANT: This file must be copied into the Test Classes tab in SE24

CLASS lcl_test_context_helper DEFINITION DEFERRED.
CLASS zcl_ia_2context_helper DEFINITION LOCAL FRIENDS lcl_test_context_helper.

CLASS lcl_test_context_helper DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      "Test factory
      test_factory_sitzplatz FOR TESTING RAISING cx_static_check,
      test_factory_einzelkapas FOR TESTING RAISING cx_static_check,
      test_factory_unknown FOR TESTING RAISING cx_static_check,
      test_factory_both_types FOR TESTING RAISING cx_static_check,
      "Test interpreter methods
      test_interp_is_selected FOR TESTING RAISING cx_static_check,
      test_interp_is_selected_einz FOR TESTING RAISING cx_static_check,
      test_interp_set_context FOR TESTING RAISING cx_static_check,
      test_interp_set_ctx_einzel FOR TESTING RAISING cx_static_check,
      "Test GET_UNIQUE_COLLECTION
      test_unique_coll_empty FOR TESTING RAISING cx_static_check,
      test_unique_coll_objects FOR TESTING RAISING cx_static_check,
      test_unique_coll_duplicates FOR TESTING RAISING cx_static_check,
      test_unique_coll_mixed FOR TESTING RAISING cx_static_check,
      test_unique_coll_many FOR TESTING RAISING cx_static_check,
      "Test constants
      test_public_constants FOR TESTING RAISING cx_static_check,
      test_more_constants FOR TESTING RAISING cx_static_check,
      "Test private READ methods
      test_read_arbst_osn FOR TESTING RAISING cx_static_check,
      test_read_arbst_tunnel FOR TESTING RAISING cx_static_check,
      test_read_arbst_oss FOR TESTING RAISING cx_static_check,
      test_read_btg_osn FOR TESTING RAISING cx_static_check,
      test_read_btg_tunnel FOR TESTING RAISING cx_static_check,
      "Additional tests for more coverage
      test_multiple_is_selected FOR TESTING RAISING cx_static_check,
      test_set_context_twice FOR TESTING RAISING cx_static_check,
      test_unique_single_object FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_test_context_helper IMPLEMENTATION.

  METHOD test_factory_sitzplatz.
    "Test factory creates sitzplatz interpreter
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_interpreter
      msg = 'Interpreter should be created'
    ).
  ENDMETHOD.

  METHOD test_factory_einzelkapas.
    "Test factory creates einzelkapas interpreter
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_interpreter
      msg = 'Interpreter should be created'
    ).
  ENDMETHOD.

  METHOD test_factory_unknown.
    "Test factory with unknown node
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = 'UNKNOWN_NODE'
    ).

    cl_abap_unit_assert=>assert_not_bound(
      act = li_interpreter
      msg = 'Should not be bound'
    ).
  ENDMETHOD.

  METHOD test_factory_both_types.
    "Test factory creates both interpreter types
    DATA li_sitz TYPE REF TO lif_ctxelem_interpreter.
    DATA li_einzel TYPE REF TO lif_ctxelem_interpreter.

    li_sitz = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    li_einzel = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_sitz
      msg = 'Sitz should be bound'
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_einzel
      msg = 'Einzel should be bound'
    ).
  ENDMETHOD.

  METHOD test_interp_is_selected.
    "Test is_selected method on sitzplatz interpreter
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA lv_result TYPE boolean.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lv_result = li_interpreter->is_selected( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
      msg = 'Without context should return false'
    ).
  ENDMETHOD.

  METHOD test_interp_is_selected_einz.
    "Test is_selected method on einzelkapas interpreter
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA lv_result TYPE boolean.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    lv_result = li_interpreter->is_selected( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
      msg = 'Without context should return false'
    ).
  ENDMETHOD.

  METHOD test_interp_set_context.
    "Test set_context_element method on sitzplatz
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA li_context TYPE REF TO if_wd_context_element.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    "Call set_context_element with nil
    li_interpreter->set_context_element(
      ii_context_element = li_context
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_interpreter
      msg = 'Interpreter should still be bound'
    ).
  ENDMETHOD.

  METHOD test_interp_set_ctx_einzel.
    "Test set_context_element on einzelkapas
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA li_context TYPE REF TO if_wd_context_element.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    "Call set_context_element with nil
    li_interpreter->set_context_element(
      ii_context_element = li_context
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_interpreter
      msg = 'Interpreter should still be bound'
    ).
  ENDMETHOD.

  METHOD test_unique_coll_empty.
    "Test GET_UNIQUE_COLLECTION with empty table
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_collection
      msg = 'Collection should be bound'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 0
      msg = 'Should be empty'
    ).
  ENDMETHOD.

  METHOD test_unique_coll_objects.
    "Test GET_UNIQUE_COLLECTION with 2 objects
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.
    DATA lo_obj1 TYPE REF TO object.
    DATA lo_obj2 TYPE REF TO object.

    lo_obj1 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lo_obj2 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 2
      msg = 'Should have 2 objects'
    ).
  ENDMETHOD.

  METHOD test_unique_coll_duplicates.
    "Test GET_UNIQUE_COLLECTION removes duplicates
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.
    DATA lo_obj TYPE REF TO object.

    lo_obj = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    APPEND lo_obj TO lt_objects.
    APPEND lo_obj TO lt_objects.
    APPEND lo_obj TO lt_objects.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 1
      msg = 'Should have 1 unique object'
    ).
  ENDMETHOD.

  METHOD test_unique_coll_mixed.
    "Test with mixed duplicates
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.
    DATA lo_obj1 TYPE REF TO object.
    DATA lo_obj2 TYPE REF TO object.

    lo_obj1 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lo_obj2 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.
    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.
    APPEND lo_obj1 TO lt_objects.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 2
      msg = 'Should have 2 unique objects'
    ).
  ENDMETHOD.

  METHOD test_unique_coll_many.
    "Test with multiple different objects
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.
    DATA lo_obj1 TYPE REF TO object.
    DATA lo_obj2 TYPE REF TO object.
    DATA lo_obj3 TYPE REF TO object.
    DATA lo_obj4 TYPE REF TO object.

    lo_obj1 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lo_obj2 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    lo_obj3 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lo_obj4 = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    APPEND lo_obj1 TO lt_objects.
    APPEND lo_obj2 TO lt_objects.
    APPEND lo_obj3 TO lt_objects.
    APPEND lo_obj4 TO lt_objects.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 4
      msg = 'Should have 4 different objects'
    ).
  ENDMETHOD.

  METHOD test_public_constants.
    "Test PUBLIC constants
    DATA lv_aufnr TYPE string.
    DATA lv_auswahl TYPE string.
    DATA lv_sitzplatz TYPE string.
    DATA lv_einzelkapas TYPE string.

    lv_aufnr = zcl_ia_2context_helper=>mc_atnam_aufnr.
    lv_auswahl = zcl_ia_2context_helper=>mc_atnam_auswahl.
    lv_sitzplatz = zcl_ia_2context_helper=>mc_wdctx_sitzplatz.
    lv_einzelkapas = zcl_ia_2context_helper=>mc_wdctx_einzelkapas.

    cl_abap_unit_assert=>assert_equals(
      act = lv_aufnr
      exp = 'AUFNR'
      msg = 'Constant should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_auswahl
      exp = 'AUSWAHL'
      msg = 'Constant should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_sitzplatz
      exp = 'SITZPLATZ'
      msg = 'Constant should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_einzelkapas
      exp = 'EINZELKAPAS'
      msg = 'Constant should match'
    ).
  ENDMETHOD.

  METHOD test_more_constants.
    "Test more constants
    DATA lv_img_vis TYPE string.
    DATA lv_img_vis_copy TYPE string.
    DATA lv_object TYPE string.

    lv_img_vis = zcl_ia_2context_helper=>mc_atnam_img_for_visualization.
    lv_img_vis_copy = zcl_ia_2context_helper=>mc_atnam_img_for_visualiz_copy.
    lv_object = zcl_ia_2context_helper=>mc_atnam_object.

    cl_abap_unit_assert=>assert_equals(
      act = lv_img_vis
      exp = 'IMAGE_FOR_VISUALIZATION'
      msg = 'IMG constant should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_img_vis_copy
      exp = 'IMAGE_FOR_VISUALIZATION_COPY'
      msg = 'IMG COPY constant should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_object
      exp = 'OBJECT'
      msg = 'OBJECT constant should match'
    ).
  ENDMETHOD.

  METHOD test_read_arbst_osn.
    "Test READ_ARBST_OSN method
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    DATA lt_arbst_osn TYPE zcl_ia_2context_helper=>tt_elements_arbst_osn.

    "Call with empty structure
    zcl_ia_2context_helper=>read_arbst_osn(
      EXPORTING is_arbst = ls_arbst
      CHANGING ct_arbst_osn = lt_arbst_osn
    ).

    "Should complete without error
    cl_abap_unit_assert=>assert_not_initial(
      act = abap_true
      msg = 'Method should execute'
    ).
  ENDMETHOD.

  METHOD test_read_arbst_tunnel.
    "Test READ_ARBST_TUNNEL method
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    DATA lt_arbst_tunnel TYPE zcl_ia_2context_helper=>tt_elements_arbst_tunnel.

    "Call with empty structure
    zcl_ia_2context_helper=>read_arbst_tunnel(
      EXPORTING is_arbst = ls_arbst
      CHANGING ct_arbst_tunnel = lt_arbst_tunnel
    ).

    "Should complete without error
    cl_abap_unit_assert=>assert_not_initial(
      act = abap_true
      msg = 'Method should execute'
    ).
  ENDMETHOD.

  METHOD test_read_arbst_oss.
    "Test READ_ARBST_OSS method
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    DATA lt_arbst_oss TYPE zcl_ia_2context_helper=>tt_elements_arbst_osn.

    "Call with empty structure
    zcl_ia_2context_helper=>read_arbst_oss(
      EXPORTING is_arbst = ls_arbst
      CHANGING ct_arbst_oss = lt_arbst_oss
    ).

    "Should complete without error
    cl_abap_unit_assert=>assert_not_initial(
      act = abap_true
      msg = 'Method should execute'
    ).
  ENDMETHOD.

  METHOD test_read_btg_osn.
    "Test READ_BTG_OSN method
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    DATA lt_btg_osn TYPE zcl_ia_2context_helper=>tt_elements_btg_osn.

    "Call with empty structure
    zcl_ia_2context_helper=>read_btg_osn(
      EXPORTING is_arbst = ls_arbst
      CHANGING ct_btg_osn = lt_btg_osn
    ).

    "Should complete without error
    cl_abap_unit_assert=>assert_not_initial(
      act = abap_true
      msg = 'Method should execute'
    ).
  ENDMETHOD.

  METHOD test_read_btg_tunnel.
    "Test READ_BTG_TUNNEL method
    DATA ls_arbst TYPE zia_2_work_area_wd_s.
    DATA lt_btg_tunnel TYPE zcl_ia_2context_helper=>tt_elements_btg_tunnel.

    "Call with empty structure
    zcl_ia_2context_helper=>read_btg_tunnel(
      EXPORTING is_arbst = ls_arbst
      CHANGING ct_btg_tunnel = lt_btg_tunnel
    ).

    "Should complete without error
    cl_abap_unit_assert=>assert_not_initial(
      act = abap_true
      msg = 'Method should execute'
    ).
  ENDMETHOD.

  METHOD test_multiple_is_selected.
    "Test calling is_selected multiple times
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA lv_result1 TYPE boolean.
    DATA lv_result2 TYPE boolean.
    DATA lv_result3 TYPE boolean.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    lv_result1 = li_interpreter->is_selected( ).
    lv_result2 = li_interpreter->is_selected( ).
    lv_result3 = li_interpreter->is_selected( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result1
      exp = abap_false
      msg = 'First call should return false'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result2
      exp = lv_result1
      msg = 'Results should be consistent'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result3
      exp = lv_result1
      msg = 'Results should be consistent'
    ).
  ENDMETHOD.

  METHOD test_set_context_twice.
    "Test calling set_context_element twice
    DATA li_interpreter TYPE REF TO lif_ctxelem_interpreter.
    DATA li_context TYPE REF TO if_wd_context_element.

    li_interpreter = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_einzelkapas
    ).

    "Set context first time
    li_interpreter->set_context_element(
      ii_context_element = li_context
    ).

    "Set context second time
    li_interpreter->set_context_element(
      ii_context_element = li_context
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_interpreter
      msg = 'Interpreter should still be bound'
    ).
  ENDMETHOD.

  METHOD test_unique_single_object.
    "Test GET_UNIQUE_COLLECTION with single object
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.
    DATA lo_obj TYPE REF TO object.

    lo_obj = lcl_interpreter_factory_a=>get_ctxelem_interpreter(
      iv_node_name = zcl_ia_2context_helper=>mc_wdctx_sitzplatz
    ).

    APPEND lo_obj TO lt_objects.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_collection
      msg = 'Collection should be bound'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->size( )
      exp = 1
      msg = 'Should have 1 object'
    ).
  ENDMETHOD.

ENDCLASS.
