CLASS lcl_ia_2valid_scht_st_chng_05 DEFINITION DEFERRED.
CLASS zcl_ia_2valid_scht_st_chng_05 DEFINITION LOCAL FRIENDS lcl_ia_2valid_scht_st_chng_05.

CLASS lcl_ia_2valid_scht_st_chng_05 DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA go_cut        TYPE REF TO zcl_ia_2valid_scht_st_chng_05.
    DATA gi_parameters TYPE REF TO zif_ia_2_parameters.

    METHODS:
      setup,
      test_constructor                FOR TESTING RAISING cx_static_check,
      test_validate_no_vehicles       FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS lcl_ia_2valid_scht_st_chng_05 IMPLEMENTATION.

  METHOD setup.
    DATA(lo_workshift) = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).

    DATA(lo_wrkplace) = NEW zcl_ia_2wrkplace( iv_id = '9999' io_schicht = lo_workshift ).
    lo_workshift->add_arbeitsstelle( io_arbstelle = lo_wrkplace ).

    gi_parameters = NEW zcl_ia_2parameters_generic(
      VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht dref = REF #( lo_workshift ) ) ) ).

    go_cut = NEW zcl_ia_2valid_scht_st_chng_05( ii_parameters = gi_parameters ).
  ENDMETHOD.

  METHOD test_constructor.
    cl_abap_unit_assert=>assert_bound(
      act = go_cut
      msg = 'Constructor should create a valid instance' ).
  ENDMETHOD.

  METHOD test_validate_no_vehicles.
    TRY.
        go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).
      CATCH zcx_ia_2validation_error INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = 'No validation error expected for empty vehicles' ).
    ENDTRY.

    cl_abap_unit_assert=>assert_bound(
      act = go_cut->go_schicht
      msg = 'Workshift should be set after validate' ).
  ENDMETHOD.

ENDCLASS.
