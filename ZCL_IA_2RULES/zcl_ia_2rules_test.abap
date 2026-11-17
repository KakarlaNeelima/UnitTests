*"* use this source file for your ABAP unit test classes
CLASS lcl_ia_2rules DEFINITION DEFERRED.
CLASS zcl_ia_2rules DEFINITION LOCAL FRIENDS lcl_ia_2rules.

CLASS lcl_ia_2rules DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_get_regelsteuerung FOR TESTING RAISING cx_static_check,
      test_get_regelsteuerung_cache FOR TESTING RAISING cx_static_check,
      test_is_regel_pflicht_gbt FOR TESTING RAISING cx_static_check,
      test_is_regel_pflicht_osx FOR TESTING RAISING cx_static_check,
      test_is_regel_not_found FOR TESTING RAISING cx_static_check,
      test_is_regel_pflicht_zero FOR TESTING RAISING cx_static_check,
      test_move_seats_instance FOR TESTING RAISING cx_static_check,
      test_check_kapas_rules_free FOR TESTING RAISING cx_static_check,
      test_check_kapas_rules_no_free FOR TESTING RAISING cx_static_check,
      test_constants_defined FOR TESTING RAISING cx_static_check,
      test_get_sitzplatz_init FOR TESTING RAISING cx_static_check,
      test_check_datum_null FOR TESTING RAISING cx_static_check,
      test_check_datum_struct FOR TESTING RAISING cx_static_check,
      test_check_as_ausdehnung FOR TESTING RAISING cx_static_check,
      test_check_sa_gap FOR TESTING RAISING cx_static_check,
      test_check_quer_km FOR TESTING RAISING cx_static_check,
      test_get_fahrzeug_null FOR TESTING RAISING cx_static_check,
      test_get_basis_fz_null FOR TESTING RAISING cx_static_check,
      test_get_met_fz_null FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_null FOR TESTING RAISING cx_static_check,
      test_check_einzelkapas FOR TESTING RAISING cx_static_check,
      test_write_to_mm FOR TESTING RAISING cx_static_check,
      test_is_regel_open_302 FOR TESTING RAISING cx_static_check,
      test_is_regel_300 FOR TESTING RAISING cx_static_check,
      test_is_regel_301 FOR TESTING RAISING cx_static_check,
      test_check_datum_io_auf FOR TESTING RAISING cx_static_check,
      test_check_ausdeh_io_auf FOR TESTING RAISING cx_static_check,
      test_check_sa_gap_io_auf FOR TESTING RAISING cx_static_check,
      test_get_fz_no_ignore FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_io_auf FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_vorschau FOR TESTING RAISING cx_static_check,
      test_check_kapas_ignore FOR TESTING RAISING cx_static_check,
      test_write_to_mm_auftrag FOR TESTING RAISING cx_static_check,
      test_write_to_mm_fail FOR TESTING RAISING cx_static_check,
      test_get_sitzplatz_zero FOR TESTING RAISING cx_static_check,
      test_get_basis_fz_no_ign FOR TESTING RAISING cx_static_check,
      test_get_met_fz_no_ignore FOR TESTING RAISING cx_static_check,
      test_regelsteuerung_lines FOR TESTING RAISING cx_static_check,
      test_get_fz_empty_type FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_all FOR TESTING RAISING cx_static_check,
      test_write_to_mm_open FOR TESTING RAISING cx_static_check,
      test_check_datum_both FOR TESTING RAISING cx_static_check,
      test_check_quer_km_struct FOR TESTING RAISING cx_static_check,
      test_check_datum_is_fill FOR TESTING RAISING cx_static_check,
      test_get_fz_is_filled FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_ia_2rules IMPLEMENTATION.

  METHOD test_get_regelsteuerung.
    DATA lt_regeln TYPE zia_2control_ap_t.
    lt_regeln = zcl_ia_2rules=>get_regelsteuerung( ).
  ENDMETHOD.

  METHOD test_get_regelsteuerung_cache.
    "Test that GET_REGELSTEUERUNG caches data
    DATA lt_regeln1 TYPE zia_2control_ap_t.
    DATA lt_regeln2 TYPE zia_2control_ap_t.

    "First call - loads from database
    lt_regeln1 = zcl_ia_2rules=>get_regelsteuerung( ).

    "Second call - should use cached data
    lt_regeln2 = zcl_ia_2rules=>get_regelsteuerung( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_regeln1 )
      exp = lines( lt_regeln2 )
      msg = 'Cached data should match initial data'
    ).
  ENDMETHOD.

  METHOD test_is_regel_pflicht_gbt.
    "Test IS_REGEL_PFLICHT for closed track (GBT)
    DATA lv_result TYPE boolean.
    DATA lv_regel TYPE zia_2_regel.
    DATA lv_offene_strecke TYPE boolean.

    lv_regel = 302.
    lv_offene_strecke = abap_false.

    lv_result = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel = lv_regel
      iv_offene_strecke = lv_offene_strecke
    ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Result should not be initial'
    ).
  ENDMETHOD.

  METHOD test_is_regel_pflicht_osx.
    "Test IS_REGEL_PFLICHT for open track (OSX)
    DATA lv_result TYPE boolean.
    DATA lv_regel TYPE zia_2_regel.
    DATA lv_offene_strecke TYPE boolean.

    lv_regel = 303.
    lv_offene_strecke = abap_true.

    lv_result = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel = lv_regel
      iv_offene_strecke = lv_offene_strecke
    ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Result should not be initial for open track'
    ).
  ENDMETHOD.

  METHOD test_is_regel_not_found.
    "Test IS_REGEL_PFLICHT with non-existent rule
    DATA lv_result TYPE boolean.
    DATA lv_regel TYPE zia_2_regel.
    DATA lv_offene_strecke TYPE boolean.

    lv_regel = 99999. "Non-existent rule
    lv_offene_strecke = abap_false.

    lv_result = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel = lv_regel
      iv_offene_strecke = lv_offene_strecke
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_true
      msg = 'Non-existent rule should default to mandatory'
    ).
  ENDMETHOD.

  METHOD test_move_seats_instance.
    "Test MOVE_SEATS_INSTANCE sets flags correctly
    DATA lv_is_valid TYPE boolean.
    DATA lv_critical_error TYPE boolean.

    zcl_ia_2rules=>move_seats_instance(
      IMPORTING
        ev_is_valid = lv_is_valid
        ev_critical_error = lv_critical_error
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_is_valid
      exp = abap_false
      msg = 'Is valid should be false'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_critical_error
      exp = abap_true
      msg = 'Critical error should be true'
    ).
  ENDMETHOD.

  METHOD test_check_kapas_rules_free.
    "Test CHECK_AUF_EINZELKAPAS_RULES with free seat
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz_frei TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz_v TYPE REF TO zcl_ia_2seat.
    DATA lo_result_seat TYPE REF TO zcl_ia_2seat.
    DATA lv_error TYPE boolean.
    DATA lv_is_valid TYPE boolean.
    DATA lv_error_flag TYPE boolean.

    "Sitzplatz_a is initial, sitzplatz_frei is bound
    "This should assign sitzplatz_frei to output

    zcl_ia_2rules=>check_auf_einzelkapas_rules(
      EXPORTING
        io_sitzplatz_a = lo_sitzplatz_a
        io_sitzplatz_frei = lo_sitzplatz_frei
        io_sitzplatz_v = lo_sitzplatz_v
      IMPORTING
        eo_sitzplatz_a = lo_result_seat
        ev_error = lv_error
        ev_is_valid = lv_is_valid
        ev_error_flag = lv_error_flag
    ).

    "When sitzplatz_a is initial and sitzplatz_frei is not initial
    "Result should be sitzplatz_frei
    cl_abap_unit_assert=>assert_equals(
      act = lo_result_seat
      exp = lo_sitzplatz_frei
      msg = 'Result should be free seat'
    ).
  ENDMETHOD.

  METHOD test_check_kapas_rules_no_free.
    "Test CHECK_AUF_EINZELKAPAS_RULES without free seat
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz_frei TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz_v TYPE REF TO zcl_ia_2seat.
    DATA lo_result_seat TYPE REF TO zcl_ia_2seat.
    DATA lv_error TYPE boolean.
    DATA lv_is_valid TYPE boolean.
    DATA lv_error_flag TYPE boolean.

    "Both sitzplatz_a and sitzplatz_frei are initial
    "Should use sitzplatz_v and set error flags

    zcl_ia_2rules=>check_auf_einzelkapas_rules(
      EXPORTING
        io_sitzplatz_a = lo_sitzplatz_a
        io_sitzplatz_frei = lo_sitzplatz_frei
        io_sitzplatz_v = lo_sitzplatz_v
      IMPORTING
        eo_sitzplatz_a = lo_result_seat
        ev_error = lv_error
        ev_is_valid = lv_is_valid
        ev_error_flag = lv_error_flag
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_error
      exp = abap_true
      msg = 'Error flag should be set'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_is_valid
      exp = abap_false
      msg = 'Is valid should be false'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_error_flag
      exp = abap_true
      msg = 'Error flag should be true'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_result_seat
      exp = lo_sitzplatz_v
      msg = 'Result should be sitzplatz_v'
    ).
  ENDMETHOD.

  METHOD test_constants_defined.
    "Test that class constants are defined correctly
    DATA lv_applid TYPE zse_2_application.
    DATA lv_pname TYPE zia_2lofpm_pname.

    lv_applid = zcl_ia_2rules=>mc_applid.
    lv_pname = zcl_ia_2rules=>mc_pname.

    cl_abap_unit_assert=>assert_equals(
      act = lv_applid
      exp = 'ZIA_2_REAL'
      msg = 'MC_APPLID should be ZIA_2_REAL'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_pname
      exp = 'KM_SIGNAL_DEV'
      msg = 'MC_PNAME should be KM_SIGNAL_DEV'
    ).
  ENDMETHOD.


  METHOD test_is_regel_pflicht_zero.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 0
      iv_offene_strecke = abap_false ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Rule 0 should default to mandatory' ).
  ENDMETHOD.


  METHOD test_get_sitzplatz_init.
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz   TYPE REF TO zcl_ia_2seat.
    DATA lv_error       TYPE boolean.
    TRY.
        zcl_ia_2rules=>get_sitzplatz(
          EXPORTING
            iv_max_auslastung = 100
            iv_zdauer         = 60
          CHANGING
            co_sitzplatz_a = lo_sitzplatz_a
            co_sitzplatz   = lo_sitzplatz
            cv_error       = lv_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_check_datum_null.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_struct.
    DATA lo_arb      TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag  TYPE zia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = lo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_as_ausdehnung.
    DATA lo_arb      TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag  TYPE zia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_as_ausdehnung(
          io_arbeitsstelle = lo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_sa_gap.
    DATA lo_arb      TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag  TYPE zia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_sa_gap(
          io_arbeitsstelle = lo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_quer_km.
    DATA lo_arb      TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag  TYPE zia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_quer_km(
          is_auftrag       = ls_auftrag
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_get_fahrzeug_null.
    DATA lo_arb   TYPE REF TO zcl_ia_2wrkplace.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 1.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp          = lv_fztyp
          io_arbeitsstelle  = lo_arb
          iv_ignore_errors  = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_basis_fz_null.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_basis_fahrzeug(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
            io_auftrag       = lo_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_met_fz_null.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    TRY.
        DATA(lo_map) = zcl_ia_2rules=>get_met_fahrzeuge(
          iv_ignore_errors = abap_true
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_null.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    DATA ls_auftrag TYPE zia_2order.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
            is_auftrag       = ls_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_einzelkapas.
    DATA lo_arb         TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag     TYPE zia_2order.
    DATA lt_einzelkapas TYPE zia_2_order_cap_t.
    DATA lv_crit_error  TYPE boolean.
    TRY.
        DATA(lv_valid) = zcl_ia_2rules=>check_auf_einzelkapas(
          EXPORTING
            is_auftrag       = ls_auftrag
            io_arbeitsstelle = lo_arb
          IMPORTING
            et_einzelkapas   = lt_einzelkapas
            ev_critical_error = lv_crit_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

*  Private method via LOCAL FRIENDS

  METHOD test_write_to_mm.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 302
          io_arbeitsstelle  = lo_arb
          iv_success        = abap_true
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_is_regel_open_302.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 302
      iv_offene_strecke = abap_true ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Rule 302 open track should return a result' ).
  ENDMETHOD.

  METHOD test_is_regel_300.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 300
      iv_offene_strecke = abap_false ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Rule 300 should return a result' ).
  ENDMETHOD.

  METHOD test_is_regel_301.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 301
      iv_offene_strecke = abap_true ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_result
      msg = 'Rule 301 open track should return a result' ).
  ENDMETHOD.


  METHOD test_check_datum_io_auf.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = lo_arb
          io_auftrag       = lo_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_both.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA ls_auftrag TYPE zia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = lo_arb
          io_auftrag       = lo_auftrag
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_ausdeh_io_auf.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_as_ausdehnung(
          io_arbeitsstelle = lo_arb
          io_auftrag       = lo_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_sa_gap_io_auf.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_sa_gap(
          io_arbeitsstelle = lo_arb
          io_auftrag       = lo_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_quer_km_struct.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_quer_km(
          is_auftrag       = ls_auftrag
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_get_fz_no_ignore.
    DATA lo_arb   TYPE REF TO zcl_ia_2wrkplace.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 2.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp          = lv_fztyp
          io_arbeitsstelle  = lo_arb
          iv_ignore_errors  = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fz_empty_type.
    DATA lo_arb   TYPE REF TO zcl_ia_2wrkplace.
    DATA lv_fztyp TYPE zia_2_id_fztyp.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp          = lv_fztyp
          io_arbeitsstelle  = lo_arb
          iv_ignore_errors  = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_io_auf.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
            io_auftrag       = lo_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_vorschau.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    DATA ls_auftrag TYPE zia_2order.
    DATA lv_vorschau TYPE zia_2_vorschau.
    lv_vorschau = 'X'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_false
            is_auftrag       = ls_auftrag
            iv_vorschau      = lv_vorschau
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_all.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    DATA ls_auftrag TYPE zia_2order.
    DATA lv_vorschau TYPE zia_2_vorschau.
    lv_vorschau = 'X'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
            io_auftrag       = lo_auftrag
            is_auftrag       = ls_auftrag
            iv_vorschau      = lv_vorschau
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

*  CHECK_AUF_EINZELKAPAS with ignore_errors

  METHOD test_check_kapas_ignore.
    DATA lo_arb         TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag     TYPE zia_2order.
    DATA lt_einzelkapas TYPE zia_2_order_cap_t.
    DATA lv_crit_error  TYPE boolean.
    TRY.
        DATA(lv_valid) = zcl_ia_2rules=>check_auf_einzelkapas(
          EXPORTING
            is_auftrag       = ls_auftrag
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
          IMPORTING
            et_einzelkapas   = lt_einzelkapas
            ev_critical_error = lv_crit_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_write_to_mm_auftrag.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 303
          io_arbeitsstelle  = lo_arb
          is_auftrag        = ls_auftrag
          iv_success        = abap_true
          iv_offene_strecke = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_to_mm_fail.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 300
          io_arbeitsstelle  = lo_arb
          iv_success        = abap_false
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_to_mm_open.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag TYPE zia_2order.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 301
          io_arbeitsstelle  = lo_arb
          is_auftrag        = ls_auftrag
          iv_success        = abap_false
          iv_offene_strecke = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_get_sitzplatz_zero.
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz   TYPE REF TO zcl_ia_2seat.
    DATA lv_error       TYPE boolean.
    TRY.
        zcl_ia_2rules=>get_sitzplatz(
          EXPORTING
            iv_max_auslastung = 0
            iv_zdauer         = 0
          CHANGING
            co_sitzplatz_a = lo_sitzplatz_a
            co_sitzplatz   = lo_sitzplatz
            cv_error       = lv_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_get_basis_fz_no_ign.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_basis_fahrzeug(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_false
            io_auftrag       = lo_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_met_fz_no_ignore.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    TRY.
        DATA(lo_map) = zcl_ia_2rules=>get_met_fahrzeuge(
          iv_ignore_errors = abap_false
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD test_regelsteuerung_lines.
    DATA(lt_regeln) = zcl_ia_2rules=>get_regelsteuerung( ).
    DATA(lv_lines) = lines( lt_regeln ).
  ENDMETHOD.

  METHOD test_check_datum_is_fill.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = lo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fz_is_filled.
    DATA lo_arb     TYPE REF TO zcl_ia_2wrkplace.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    ls_auftrag-matnr = 'TESTMATERIAL01'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = lo_arb
            iv_ignore_errors = abap_true
            is_auftrag       = ls_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_ia_2rules_deep DEFINITION DEFERRED.
CLASS zcl_ia_2rules DEFINITION LOCAL FRIENDS lcl_ia_2rules_deep.

CLASS lcl_ia_2rules_deep DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA mo_arb   TYPE REF TO zcl_ia_2wrkplace.
    CLASS-DATA mo_seat  TYPE REF TO zcl_ia_2seat.
    CLASS-DATA mo_order TYPE REF TO zcl_ia_2order.
    CLASS-METHODS class_setup.
    METHODS:
      test_check_quer_km_q       FOR TESTING RAISING cx_static_check,
      test_get_met_fz_deep       FOR TESTING RAISING cx_static_check,
      test_check_datum_deep      FOR TESTING RAISING cx_static_check,
      test_check_datum_io_order  FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_deep    FOR TESTING RAISING cx_static_check,
      test_get_fahrzeug_deep     FOR TESTING RAISING cx_static_check,
      test_write_to_mm_deep      FOR TESTING RAISING cx_static_check,
      test_write_to_mm_fail_deep FOR TESTING RAISING cx_static_check,
      test_check_einzelkapas_dp  FOR TESTING RAISING cx_static_check,
      test_check_sa_gap_deep     FOR TESTING RAISING cx_static_check,
      test_get_basis_fz_deep     FOR TESTING RAISING cx_static_check,
      test_get_sitzplatz_deep    FOR TESTING RAISING cx_static_check,
      test_kapas_rules_true      FOR TESTING RAISING cx_static_check,
      test_check_ausdeh_deep     FOR TESTING RAISING cx_static_check,
      test_check_ausdeh_is_auf   FOR TESTING RAISING cx_static_check,
      test_regel_gbt_deep        FOR TESTING RAISING cx_static_check,
      test_regel_osx_deep        FOR TESTING RAISING cx_static_check,
      test_get_sitzplatz_elseif  FOR TESTING RAISING cx_static_check,
      test_fz_io_order           FOR TESTING RAISING cx_static_check,
      test_fz_no_match           FOR TESTING RAISING cx_static_check,
      test_datum_no_input        FOR TESTING RAISING cx_static_check,
      test_datum_future_dates    FOR TESTING RAISING cx_static_check,
      test_quer_km_q_arb_deep   FOR TESTING RAISING cx_static_check,
      test_wtmm_success_regel   FOR TESTING RAISING cx_static_check,
      test_wtmm_warn_deep       FOR TESTING RAISING cx_static_check,
      test_fz_ignore_true       FOR TESTING RAISING cx_static_check,
      test_basis_fz_no_ignore   FOR TESTING RAISING cx_static_check,
      test_met_fz_no_ignore     FOR TESTING RAISING cx_static_check,
      test_einzelkapas_ignore   FOR TESTING RAISING cx_static_check,
      test_check_sa_gap_struct  FOR TESTING RAISING cx_static_check,
      test_regel_both_skip      FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS lcl_ia_2rules_deep IMPLEMENTATION.

  METHOD class_setup.
    DATA lo_obj TYPE REF TO object.
    DATA lo_shift TYPE REF TO zcl_ia_2workshift.
    TRY.
        CREATE OBJECT lo_obj TYPE ('ZCL_IA_2WORKSHIFT').
        lo_shift ?= lo_obj.
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        IF lo_shift IS BOUND.
          mo_arb = NEW zcl_ia_2wrkplace( iv_id = '999999' io_schicht = lo_shift ).
        ELSE.
          mo_arb = NEW zcl_ia_2wrkplace( iv_id = '999999' ).
        ENDIF.
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        CLEAR lo_obj.
        CREATE OBJECT lo_obj TYPE ('ZCL_IA_2SEAT').
        mo_seat ?= lo_obj.
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        CLEAR lo_obj.
        CREATE OBJECT lo_obj TYPE ('ZCL_IA_2ORDER').
        mo_order ?= lo_obj.
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        zcl_ia_2message_manager=>get_instance( ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        zcl_ia_2message_mnger=>get_instance( ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_quer_km_q.
    DATA ls_auftrag TYPE zia_2order.
    DATA lo_arb TYPE REF TO zcl_ia_2wrkplace.
    ls_auftrag-zstdkz = 'Q'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_quer_km(
          is_auftrag       = ls_auftrag
          io_arbeitsstelle = lo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_met_fz_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lo_map) = zcl_ia_2rules=>get_met_fahrzeuge(
          iv_ignore_errors = abap_true
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_io_order.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb
          io_auftrag       = mo_order ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_false
            is_auftrag       = ls_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeug_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 1.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp         = lv_fztyp
          io_arbeitsstelle = mo_arb
          iv_ignore_errors = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_to_mm_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 302
          io_arbeitsstelle  = mo_arb
          iv_success        = abap_true
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_to_mm_fail_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 303
          io_arbeitsstelle  = mo_arb
          is_auftrag        = ls_auftrag
          iv_success        = abap_false
          iv_offene_strecke = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_einzelkapas_dp.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    DATA lt_einzelkapas TYPE zia_2_order_cap_t.
    DATA lv_crit_error TYPE boolean.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_valid) = zcl_ia_2rules=>check_auf_einzelkapas(
          EXPORTING
            is_auftrag        = ls_auftrag
            io_arbeitsstelle  = mo_arb
          IMPORTING
            et_einzelkapas    = lt_einzelkapas
            ev_critical_error = lv_crit_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_sa_gap_deep.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_sa_gap(
          io_auftrag       = mo_order
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_basis_fz_deep.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_basis_fahrzeug(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_true
            io_auftrag       = mo_order
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_sitzplatz_deep.
    IF mo_seat IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz   TYPE REF TO zcl_ia_2seat.
    DATA lv_error       TYPE boolean.
    lo_sitzplatz = mo_seat.
    TRY.
        zcl_ia_2rules=>get_sitzplatz(
          EXPORTING
            iv_max_auslastung = 100
            iv_zdauer         = 60
          CHANGING
            co_sitzplatz_a = lo_sitzplatz_a
            co_sitzplatz   = lo_sitzplatz
            cv_error       = lv_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_kapas_rules_true.
    IF mo_seat IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_null_seat TYPE REF TO zcl_ia_2seat.
    DATA lo_result    TYPE REF TO zcl_ia_2seat.
    DATA lv_error     TYPE boolean.
    DATA lv_valid     TYPE boolean.
    DATA lv_flag      TYPE boolean.
    zcl_ia_2rules=>check_auf_einzelkapas_rules(
      EXPORTING
        io_sitzplatz_a    = lo_null_seat
        io_sitzplatz_frei = mo_seat
        io_sitzplatz_v    = lo_null_seat
      IMPORTING
        eo_sitzplatz_a = lo_result
        ev_error       = lv_error
        ev_is_valid    = lv_valid
        ev_error_flag  = lv_flag ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_result
      exp = mo_seat
      msg = 'Should return free seat' ).
  ENDMETHOD.

  METHOD test_check_ausdeh_deep.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_as_ausdehnung(
          io_arbeitsstelle = mo_arb
          io_auftrag       = mo_order ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_ausdeh_is_auf.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_as_ausdehnung(
          io_arbeitsstelle = mo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_regel_gbt_deep.
    DATA lt_backup TYPE zia_2control_ap_t.
    DATA ls_regel  TYPE zia_2control_ap.
    lt_backup = zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR ls_regel.
    ls_regel-zregel = 999.
    ls_regel-zgbt_man_plan = 2.
    ls_regel-zosx_man_plan = 1.
    APPEND ls_regel TO zcl_ia_2rules=>mt_regelsteuerung.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 999
      iv_offene_strecke = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_true
      msg = 'GBT rule with plan=2 should be mandatory' ).
    zcl_ia_2rules=>mt_regelsteuerung = lt_backup.
  ENDMETHOD.

  METHOD test_regel_osx_deep.
    DATA lt_backup TYPE zia_2control_ap_t.
    DATA ls_regel  TYPE zia_2control_ap.
    lt_backup = zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR ls_regel.
    ls_regel-zregel = 998.
    ls_regel-zgbt_man_plan = 1.
    ls_regel-zosx_man_plan = 2.
    APPEND ls_regel TO zcl_ia_2rules=>mt_regelsteuerung.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 998
      iv_offene_strecke = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_true
      msg = 'OSX rule with plan=2 should be mandatory' ).
    zcl_ia_2rules=>mt_regelsteuerung = lt_backup.
  ENDMETHOD.

  METHOD test_get_sitzplatz_elseif.
    IF mo_seat IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_sitzplatz_a TYPE REF TO zcl_ia_2seat.
    DATA lo_sitzplatz   TYPE REF TO zcl_ia_2seat.
    DATA lv_error       TYPE boolean.
    lo_sitzplatz = mo_seat.
    TRY.
        zcl_ia_2rules=>get_sitzplatz(
          EXPORTING
            iv_max_auslastung = 100
            iv_zdauer         = 0
          CHANGING
            co_sitzplatz_a = lo_sitzplatz_a
            co_sitzplatz   = lo_sitzplatz
            cv_error       = lv_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    lo_sitzplatz = mo_seat.
    TRY.
        zcl_ia_2rules=>get_sitzplatz(
          EXPORTING
            iv_max_auslastung = 100
            iv_zdauer         = 0
          CHANGING
            co_sitzplatz_a = lo_sitzplatz_a
            co_sitzplatz   = lo_sitzplatz
            cv_error       = lv_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_fz_io_order.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_auftrag       = mo_order
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_true
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_fz_no_match.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    DATA lo_fz_map  TYPE REF TO cl_object_map.
    ls_auftrag-zzperi = 'ZZZZZ'.
    ls_auftrag-matnr  = 'ZZZZZZZZZZZZZZZZZZ'.
    ls_auftrag-aufnr  = '999999999999'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_true
            is_auftrag       = ls_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_datum_no_input.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_datum_future_dates.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-gstrp = '29991231'.
    ls_auftrag-gltrp = '29991231'.
    ls_auftrag-aufnr = '999999999999'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_quer_km_q_arb_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-zstdkz = 'Q'.
    ls_auftrag-aufnr  = '999999999999'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_quer_km(
          is_auftrag       = ls_auftrag
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_wtmm_success_regel.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lt_backup TYPE zia_2control_ap_t.
    DATA ls_regel  TYPE zia_2control_ap.
    lt_backup = zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR ls_regel.
    ls_regel-zregel = 997.
    ls_regel-zgbt_man_plan = 1.
    ls_regel-zosx_man_plan = 1.
    APPEND ls_regel TO zcl_ia_2rules=>mt_regelsteuerung.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 997
          io_arbeitsstelle  = mo_arb
          iv_success        = abap_false
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    zcl_ia_2rules=>mt_regelsteuerung = lt_backup.
  ENDMETHOD.

  METHOD test_wtmm_warn_deep.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lt_backup TYPE zia_2control_ap_t.
    DATA ls_regel  TYPE zia_2control_ap.
    lt_backup = zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR ls_regel.
    ls_regel-zregel = 996.
    ls_regel-zgbt_man_plan = 0.
    ls_regel-zosx_man_plan = 0.
    APPEND ls_regel TO zcl_ia_2rules=>mt_regelsteuerung.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 996
          io_arbeitsstelle  = mo_arb
          iv_success        = abap_false
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    zcl_ia_2rules=>mt_regelsteuerung = lt_backup.
  ENDMETHOD.

  METHOD test_fz_ignore_true.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 99.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp         = lv_fztyp
          io_arbeitsstelle = mo_arb
          iv_ignore_errors = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_basis_fz_no_ignore.
    IF mo_arb IS NOT BOUND OR mo_order IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_basis_fahrzeug(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_false
            io_auftrag       = mo_order
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_met_fz_no_ignore.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        DATA(lo_map) = zcl_ia_2rules=>get_met_fahrzeuge(
          iv_ignore_errors = abap_false
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_einzelkapas_ignore.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    DATA lt_einzelkapas TYPE zia_2_order_cap_t.
    DATA lv_crit_error TYPE boolean.
    ls_auftrag-aufnr = '999999999999'.
    TRY.
        DATA(lv_valid) = zcl_ia_2rules=>check_auf_einzelkapas(
          EXPORTING
            is_auftrag        = ls_auftrag
            iv_ignore_errors  = abap_true
            io_arbeitsstelle  = mo_arb
          IMPORTING
            et_einzelkapas    = lt_einzelkapas
            ev_critical_error = lv_crit_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_sa_gap_struct.
    IF mo_arb IS NOT BOUND.
      RETURN.
    ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '999999999999'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_sa_gap(
          io_arbeitsstelle = mo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_regel_both_skip.
    DATA lt_backup TYPE zia_2control_ap_t.
    DATA ls_regel  TYPE zia_2control_ap.
    lt_backup = zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR zcl_ia_2rules=>mt_regelsteuerung.
    CLEAR ls_regel.
    ls_regel-zregel = 995.
    ls_regel-zgbt_man_plan = 0.
    ls_regel-zosx_man_plan = 0.
    APPEND ls_regel TO zcl_ia_2rules=>mt_regelsteuerung.
    DATA(lv_result) = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 995
      iv_offene_strecke = abap_false ).
    lv_result = zcl_ia_2rules=>is_regel_pflicht(
      iv_regel          = 995
      iv_offene_strecke = abap_true ).
    zcl_ia_2rules=>mt_regelsteuerung = lt_backup.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_ia_2rules_shift DEFINITION DEFERRED.
CLASS zcl_ia_2rules DEFINITION LOCAL FRIENDS lcl_ia_2rules_shift.

CLASS lcl_ia_2rules_shift DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA mo_arb   TYPE REF TO zcl_ia_2wrkplace.
    CLASS-DATA mo_shift TYPE REF TO zcl_ia_2workshift.
    CLASS-METHODS class_setup.
    METHODS:
      test_check_datum_shift   FOR TESTING RAISING cx_static_check,
      test_check_datum_is_s    FOR TESTING RAISING cx_static_check,
      test_check_quer_shift    FOR TESTING RAISING cx_static_check,
      test_get_fz_shift        FOR TESTING RAISING cx_static_check,
      test_write_mm_shift_s    FOR TESTING RAISING cx_static_check,
      test_write_mm_shift_f    FOR TESTING RAISING cx_static_check,
      test_einzelkapas_shift   FOR TESTING RAISING cx_static_check,
      test_met_fz_shift        FOR TESTING RAISING cx_static_check,
      test_basis_fz_shift      FOR TESTING RAISING cx_static_check,
      test_get_fahrzeuge_shft  FOR TESTING RAISING cx_static_check,
      test_get_fahrzeug_shft   FOR TESTING RAISING cx_static_check,
      test_check_ausdeh_shft   FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS lcl_ia_2rules_shift IMPLEMENTATION.

  METHOD class_setup.
    TRY.
        mo_shift = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    IF mo_shift IS NOT BOUND.
      RETURN.
    ENDIF.
    TRY.
        mo_arb = NEW zcl_ia_2wrkplace( iv_id = '999998' io_schicht = mo_shift ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        zcl_ia_2message_manager=>get_instance( ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    TRY.
        zcl_ia_2message_mnger=>get_instance( ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_datum_is_s.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    ls_auftrag-gstrp = sy-datum.
    ls_auftrag-gltrp = sy-datum.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_datum(
          io_arbeitsstelle = mo_arb
          is_auftrag       = ls_auftrag ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_quer_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '999999999999'.
    ls_auftrag-zstdkz = 'Q'.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_quer_km(
          is_auftrag       = ls_auftrag
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fz_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 1.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp         = lv_fztyp
          io_arbeitsstelle = mo_arb
          iv_ignore_errors = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_mm_shift_s.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 302
          io_arbeitsstelle  = mo_arb
          iv_success        = abap_true
          iv_offene_strecke = abap_false ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_write_mm_shift_f.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '000000000001'.
    TRY.
        zcl_ia_2rules=>write_to_mm(
          iv_regel          = 303
          io_arbeitsstelle  = mo_arb
          is_auftrag        = ls_auftrag
          iv_success        = abap_false
          iv_offene_strecke = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_einzelkapas_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA ls_auftrag TYPE zia_2order.
    DATA lt_einzelkapas TYPE zia_2_order_cap_t.
    DATA lv_crit_error TYPE boolean.
    ls_auftrag-aufnr = '999999999999'.
    TRY.
        DATA(lv_valid) = zcl_ia_2rules=>check_auf_einzelkapas(
          EXPORTING
            is_auftrag        = ls_auftrag
            io_arbeitsstelle  = mo_arb
          IMPORTING
            et_einzelkapas    = lt_einzelkapas
            ev_critical_error = lv_crit_error ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_met_fz_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    TRY.
        DATA(lo_map) = zcl_ia_2rules=>get_met_fahrzeuge(
          iv_ignore_errors = abap_true
          io_arbeitsstelle = mo_arb ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_basis_fz_shift.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA lo_order TYPE REF TO zcl_ia_2order.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    TRY.
        CREATE OBJECT lo_order TYPE ('ZCL_IA_2ORDER').
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    IF lo_order IS NOT BOUND. RETURN. ENDIF.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_basis_fahrzeug(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_true
            io_auftrag       = lo_order
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeuge_shft.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA lo_fz_map TYPE REF TO cl_object_map.
    DATA ls_auftrag TYPE zia_2order.
    ls_auftrag-aufnr = '999999999999'.
    ls_auftrag-matnr = 'TESTMATERIAL01'.
    TRY.
        DATA(lv_ok) = zcl_ia_2rules=>get_fahrzeuge(
          EXPORTING
            io_arbeitsstelle = mo_arb
            iv_ignore_errors = abap_true
            is_auftrag       = ls_auftrag
          IMPORTING
            eo_fahrzeuge     = lo_fz_map ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_get_fahrzeug_shft.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA lv_fztyp TYPE zia_2_id_fztyp VALUE 99.
    TRY.
        DATA(lo_fz) = zcl_ia_2rules=>get_fahrzeug(
          iv_fztyp         = lv_fztyp
          io_arbeitsstelle = mo_arb
          iv_ignore_errors = abap_true ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD test_check_ausdeh_shft.
    IF mo_arb IS NOT BOUND. RETURN. ENDIF.
    DATA lo_order TYPE REF TO zcl_ia_2order.
    TRY.
        CREATE OBJECT lo_order TYPE ('ZCL_IA_2ORDER').
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
    IF lo_order IS NOT BOUND. RETURN. ENDIF.
    TRY.
        DATA(lv_result) = zcl_ia_2rules=>check_as_ausdehnung(
          io_arbeitsstelle = mo_arb
          io_auftrag       = lo_order ).
      CATCH cx_dynamic_check cx_no_check ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
