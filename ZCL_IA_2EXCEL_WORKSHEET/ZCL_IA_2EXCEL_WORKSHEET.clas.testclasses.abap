CLASS lcl_ia_2excel_worksheet DEFINITION DEFERRED.
CLASS zcl_ia_2excel_worksheet DEFINITION LOCAL FRIENDS lcl_ia_2excel_worksheet.

CLASS lcl_ia_2excel_worksheet DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA go_cut TYPE REF TO zcl_ia_2excel_worksheet.
    CONSTANTS gc_guid TYPE x LENGTH 16 VALUE '00112233445566778899AABBCCDDEEFF'.

    METHODS:
      setup,
      test_constructor         FOR TESTING,
      test_get_guid            FOR TESTING,
      test_get_title_plain     FOR TESTING,
      test_get_title_escaped   FOR TESTING,
      test_get_row_dimensions  FOR TESTING.

ENDCLASS.

CLASS lcl_ia_2excel_worksheet IMPLEMENTATION.

  METHOD setup.
    go_cut = NEW zcl_ia_2excel_worksheet( ).

    go_cut->gv_guid = gc_guid.
    go_cut->gv_title = 'Sheet & <Test>'.

    INSERT VALUE #( row = 10 ) INTO TABLE go_cut->gt_row_dimensions.
    INSERT VALUE #( row = 20 ) INTO TABLE go_cut->gt_row_dimensions.
  ENDMETHOD.

  METHOD test_constructor.
    cl_abap_unit_assert=>assert_bound(
      act = go_cut
      msg = 'Constructor should create a worksheet instance' ).
  ENDMETHOD.

  METHOD test_get_guid.
    DATA(lv_guid) = go_cut->get_guid( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_guid
      exp = go_cut->gv_guid
      msg = 'GET_GUID should return internal GUID' ).
  ENDMETHOD.

  METHOD test_get_title_plain.
    DATA(lv_title) = go_cut->get_title( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_title
      exp = go_cut->gv_title
      msg = 'GET_TITLE without escaping should return raw title' ).
  ENDMETHOD.

  METHOD test_get_title_escaped.
    DATA(lv_title_escaped) = go_cut->get_title( iv_escaped = abap_true ).
    DATA(lv_expected) = zcl_excel_common=>escape_string( go_cut->gv_title ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_title_escaped
      exp = lv_expected
      msg = 'GET_TITLE with escaping should return escaped title' ).
  ENDMETHOD.

  METHOD test_get_row_dimensions.
    DATA(lt_row_dimensions) = go_cut->get_row_dimensions( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_row_dimensions )
      exp = 2
      msg = 'GET_ROW_DIMENSIONS should return all configured rows' ).

    DELETE lt_row_dimensions WHERE row = 10.

    cl_abap_unit_assert=>assert_equals(
      act = lines( go_cut->gt_row_dimensions )
      exp = 2
      msg = 'Returned table changes must not alter internal state' ).
  ENDMETHOD.

ENDCLASS.
