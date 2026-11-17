*"* use this source file for your ABAP unit test classes
CLASS lcl_ia_2context_helper DEFINITION DEFERRED.
CLASS zcl_ia_2context_helper DEFINITION LOCAL FRIENDS lcl_ia_2context_helper.

CLASS lcl_ia_2context_helper DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_constants_atnam FOR TESTING RAISING cx_static_check,
      test_constants_wdctx_public FOR TESTING RAISING cx_static_check,
      test_constants_wdctx_private FOR TESTING RAISING cx_static_check,
      test_get_unique_collection FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_ia_2context_helper IMPLEMENTATION.

  METHOD test_constants_atnam.
    "Test that attribute name constants are defined correctly
    DATA lv_aufnr TYPE string.
    DATA lv_auswahl TYPE string.
    DATA lv_img_vis TYPE string.
    DATA lv_img_vis_copy TYPE string.
    DATA lv_object TYPE string.

    lv_aufnr = zcl_ia_2context_helper=>mc_atnam_aufnr.
    lv_auswahl = zcl_ia_2context_helper=>mc_atnam_auswahl.
    lv_img_vis = zcl_ia_2context_helper=>mc_atnam_img_for_visualization.
    lv_img_vis_copy = zcl_ia_2context_helper=>mc_atnam_img_for_visualiz_copy.
    lv_object = zcl_ia_2context_helper=>mc_atnam_object.

    cl_abap_unit_assert=>assert_equals(
      act = lv_aufnr
      exp = 'AUFNR'
      msg = 'MC_ATNAM_AUFNR should be AUFNR'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_auswahl
      exp = 'AUSWAHL'
      msg = 'MC_ATNAM_AUSWAHL should be AUSWAHL'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_img_vis
      exp = 'IMAGE_FOR_VISUALIZATION'
      msg = 'MC_ATNAM_IMG_FOR_VISUALIZATION should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_img_vis_copy
      exp = 'IMAGE_FOR_VISUALIZATION_COPY'
      msg = 'MC_ATNAM_IMG_FOR_VISUALIZ_COPY should match'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_object
      exp = 'OBJECT'
      msg = 'MC_ATNAM_OBJECT should be OBJECT'
    ).
  ENDMETHOD.

  METHOD test_constants_wdctx_public.
    "Test that public Web Dynpro context constants are defined
    DATA lv_einzelkapas TYPE string.
    DATA lv_sitzplatz TYPE string.

    lv_einzelkapas = zcl_ia_2context_helper=>mc_wdctx_einzelkapas.
    lv_sitzplatz = zcl_ia_2context_helper=>mc_wdctx_sitzplatz.

    cl_abap_unit_assert=>assert_equals(
      act = lv_einzelkapas
      exp = 'EINZELKAPAS'
      msg = 'MC_WDCTX_EINZELKAPAS should be EINZELKAPAS'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_sitzplatz
      exp = 'SITZPLATZ'
      msg = 'MC_WDCTX_SITZPLATZ should be SITZPLATZ'
    ).
  ENDMETHOD.

  METHOD test_constants_wdctx_private.
    "Test that private Web Dynpro context constants are defined
    DATA lv_arbst_osn TYPE string.
    DATA lv_arbst_oss TYPE string.
    DATA lv_arbst_tunnel TYPE string.
    DATA lv_btg_osn TYPE string.
    DATA lv_jobpool TYPE string.

    lv_arbst_osn = zcl_ia_2context_helper=>mc_wdctx_arbst_osn.
    lv_arbst_oss = zcl_ia_2context_helper=>mc_wdctx_arbst_oss.
    lv_arbst_tunnel = zcl_ia_2context_helper=>mc_wdctx_arbst_tunnel.
    lv_btg_osn = zcl_ia_2context_helper=>mc_wdctx_btg_osn.
    lv_jobpool = zcl_ia_2context_helper=>mc_wdctx_jobpool.

    cl_abap_unit_assert=>assert_equals(
      act = lv_arbst_osn
      exp = 'ARBST_OSN'
      msg = 'MC_WDCTX_ARBST_OSN should be ARBST_OSN'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_arbst_oss
      exp = 'ARBST_OSS'
      msg = 'MC_WDCTX_ARBST_OSS should be ARBST_OSS'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_arbst_tunnel
      exp = 'ARBST_TUNNEL'
      msg = 'MC_WDCTX_ARBST_TUNNEL should be ARBST_TUNNEL'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_btg_osn
      exp = 'BTG_OSN'
      msg = 'MC_WDCTX_BTG_OSN should be BTG_OSN'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_jobpool
      exp = 'JOBPOOL'
      msg = 'MC_WDCTX_JOBPOOL should be JOBPOOL'
    ).
  ENDMETHOD.

  METHOD test_get_unique_collection.
    "Test GET_UNIQUE_COLLECTION with empty table
    DATA lt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.
    DATA li_collection TYPE REF TO if_object_collection.

    li_collection = zcl_ia_2context_helper=>get_unique_collection(
      it_objects = lt_objects
    ).

    cl_abap_unit_assert=>assert_bound(
      act = li_collection
      msg = 'Collection should be bound even with empty input'
    ).
  ENDMETHOD.

ENDCLASS.
