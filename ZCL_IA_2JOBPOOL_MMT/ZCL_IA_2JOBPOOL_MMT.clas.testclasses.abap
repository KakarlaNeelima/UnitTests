CLASS lcl_jobpool_mmt DEFINITION DEFERRED.
CLASS zcl_ia_2jobpool_mmt DEFINITION LOCAL FRIENDS lcl_jobpool_mmt.

CLASS lcl_jobpool_mmt DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA go_cut TYPE REF TO zcl_ia_2jobpool_mmt.
    METHODS:
      setup,
      test_get_instance FOR TESTING RAISING cx_static_check,
      test_main FOR TESTING RAISING cx_static_check,
      test_check_no_orders FOR TESTING RAISING cx_static_check,
      test_check_with_matfzg FOR TESTING RAISING cx_static_check,
      test_check_no_matfzg FOR TESTING RAISING cx_static_check,
      test_check_exist_no_auftr FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_jobpool_mmt IMPLEMENTATION.

  METHOD setup.
    go_cut = NEW zcl_ia_2jobpool_mmt( ).
  ENDMETHOD.

  METHOD test_get_instance.
    DATA(lo_instance) = zcl_ia_2jobpool_mmt=>get_instance( ).

    cl_abap_unit_assert=>assert_bound(
      act = lo_instance
      msg = 'GET_INSTANCE should return a bound instance' ).
  ENDMETHOD.

  METHOD test_main.
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    DATA(lv_raised) = abap_false.

    TRY.
        go_cut->main( io_schicht = lo_schicht ).
      CATCH zcx_ia_2failure.
        lv_raised = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_false(
      act = lv_raised
      msg = 'MAIN should not raise an exception' ).
  ENDMETHOD.

  METHOD test_check_no_orders.
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    DATA(lv_raised) = abap_false.

    TRY.
        go_cut->check_mat_fzg_assignment(
          io_schicht    = lo_schicht
          it_map_matfzg = VALUE #( ) ).
      CATCH zcx_ia_2failure.
        lv_raised = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_false(
      act = lv_raised
      msg = 'Should not raise exception when no orders exist' ).
  ENDMETHOD.

  METHOD test_check_with_matfzg.
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    DATA(lt_matfzg) = VALUE zia_2map_matfzg_t(
      ( rsnum = '0000000001' rspos = '0001' ) ).
    DATA(lv_raised) = abap_false.

    TRY.
        go_cut->check_mat_fzg_assignment(
          io_schicht    = lo_schicht
          it_map_matfzg = lt_matfzg ).
      CATCH zcx_ia_2failure.
        lv_raised = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_false(
      act = lv_raised
      msg = 'Should not raise exception with explicit matfzg and no orders' ).
  ENDMETHOD.

  METHOD test_check_no_matfzg.
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    DATA(lv_raised) = abap_false.

    TRY.
        go_cut->check_mat_fzg_assignment(
          io_schicht = lo_schicht ).
      CATCH zcx_ia_2failure.
        lv_raised = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_false(
      act = lv_raised
      msg = 'Should not raise exception with no matfzg and no orders' ).
  ENDMETHOD.

  METHOD test_check_exist_no_auftr.
    DATA(lo_schicht) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    DATA(lo_msg) = zcl_ia_2message_manager=>get_instance( ).
    DATA(lv_raised) = abap_false.

    TRY.
        go_cut->check_existence_schicht_auftr(
          EXPORTING io_shift = lo_schicht
          CHANGING  co_msg   = lo_msg ).
      CATCH zcx_ia_2failure.
        lv_raised = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_false(
      act = lv_raised
      msg = 'Should not raise exception when no schicht auftrags exist' ).
  ENDMETHOD.

ENDCLASS.
