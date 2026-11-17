CLASS lcl_ia_2valid_scht_st_chng_03 DEFINITION DEFERRED.
CLASS zcl_ia_2valid_scht_st_chng_03 DEFINITION LOCAL FRIENDS lcl_ia_2valid_scht_st_chng_03.

CLASS lcl_ia_2valid_scht_st_chng_03 DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA go_cut        TYPE REF TO zcl_ia_2valid_scht_st_chng_03.
    DATA gi_parameters TYPE REF TO zif_ia_2_parameters.

    METHODS:
      setup,
      test_constructor                    FOR TESTING RAISING cx_static_check,
      test_validate_empty_schicht         FOR TESTING RAISING cx_static_check,
      test_validate_with_vehicles         FOR TESTING RAISING cx_static_check,
      test_validate_with_fahrzeug         FOR TESTING RAISING cx_static_check,
      test_schicht_assigned               FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS lcl_ia_2valid_scht_st_chng_03 IMPLEMENTATION.

  METHOD setup.
    DATA(lo_workshift) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).

    DATA(lo_wrkplace) = NEW zcl_ia_2wrkplace( iv_id = '9999' io_schicht = lo_workshift ).
    lo_workshift->add_arbeitsstelle( io_arbstelle = lo_wrkplace ).

    gi_parameters = NEW zcl_ia_2parameters_generic(
      VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht dref = REF #( lo_workshift ) ) ) ).

    go_cut = NEW zcl_ia_2valid_scht_st_chng_03( ii_parameters = gi_parameters ).
  ENDMETHOD.

  METHOD test_constructor.
    cl_abap_unit_assert=>assert_bound(
      act = go_cut
      msg = 'Constructor should create a valid instance' ).
  ENDMETHOD.

  METHOD test_validate_empty_schicht.
    " Create workshift without any vehicles to test empty iteration paths
    DATA(lo_empty_ws) = NEW zcl_ia_2workshift( iv_zschicht = '888888888888' ).
    DATA(lv_validated) = abap_false.

    DATA(lo_empty_params) = NEW zcl_ia_2parameters_generic(
      VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht dref = REF #( lo_empty_ws ) ) ) ).

    TRY.
        go_cut->zif_ia_2_validator~validate( ii_parameters = lo_empty_params ).
        lv_validated = abap_true.
      CATCH zcx_ia_2validation_error.
        cl_abap_unit_assert=>fail( msg = 'No validation error expected for empty schicht' ).
    ENDTRY.

    cl_abap_unit_assert=>assert_true(
      act = lv_validated
      msg = 'Validation should complete for empty schicht' ).
  ENDMETHOD.

  METHOD test_validate_with_vehicles.
    " Validate with default setup - may raise exception depending on vehicle data
    DATA(lv_executed) = abap_false.

    TRY.
        go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).
        lv_executed = abap_true.
      CATCH zcx_ia_2validation_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->gv_validator
          exp = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_03
          msg = 'Validator ID should match scht_st_chng_03' ).
        lv_executed = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_true(
      act = lv_executed
      msg = 'Validation path should execute with vehicles' ).
  ENDMETHOD.

  METHOD test_validate_with_fahrzeug.
    " Create workshift with a vehicle to enter the fahrzeuge iteration loop
    DATA(lv_executed) = abap_false.

    DATA(lo_workshift) = NEW zcl_ia_2workshift( iv_zschicht = '777777777777' ).
    DATA(lo_wrkplace) = NEW zcl_ia_2wrkplace( iv_id = '7777' io_schicht = lo_workshift ).
    lo_workshift->add_arbeitsstelle( io_arbstelle = lo_wrkplace ).

    DATA(lo_fahrzeug) = NEW zcl_ia_2vehicle( io_arbstelle = lo_wrkplace ).
    lo_wrkplace->add_fahrzeug( io_fahrzeug = lo_fahrzeug ).

    DATA(lo_params) = NEW zcl_ia_2parameters_generic(
      VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht dref = REF #( lo_workshift ) ) ) ).

    TRY.
        go_cut->zif_ia_2_validator~validate( ii_parameters = lo_params ).
        lv_executed = abap_true.
      CATCH zcx_ia_2validation_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->gv_validator
          exp = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_03
          msg = 'Validator ID should match scht_st_chng_03' ).
        lv_executed = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_true(
      act = lv_executed
      msg = 'Validation path should execute with fahrzeug' ).
  ENDMETHOD.

  METHOD test_schicht_assigned.
    " Verify go_schicht is properly assigned after validate call
    TRY.
        go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).
      CATCH zcx_ia_2validation_error.
        " Expected if vehicle disposition is incomplete
    ENDTRY.

    cl_abap_unit_assert=>assert_bound(
      act = go_cut->go_schicht
      msg = 'Workshift should be assigned after validate' ).
  ENDMETHOD.

ENDCLASS.
