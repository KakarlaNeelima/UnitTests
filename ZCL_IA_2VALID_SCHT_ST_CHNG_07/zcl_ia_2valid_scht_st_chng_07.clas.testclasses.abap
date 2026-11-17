CLASS lcl_valid_scht_st_chng_07 DEFINITION DEFERRED.
CLASS zcl_ia_2valid_scht_st_chng_07 DEFINITION LOCAL FRIENDS lcl_valid_scht_st_chng_07.

CLASS lcl_valid_scht_st_chng_07 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS mc_order TYPE aufnr VALUE '999999999998'.

    CLASS-DATA mi_sql_environment TYPE REF TO if_osql_test_environment.

    DATA: go_cut        TYPE REF TO zcl_ia_2valid_scht_st_chng_07,
          go_schicht    TYPE REF TO zcl_ia_2workshift,
          gi_parameters TYPE REF TO zif_ia_2_parameters.

    CLASS-METHODS: class_setup RAISING cx_static_check,
      class_teardown RAISING cx_static_check.

    METHODS: setup RAISING cx_static_check,
      test_constructor       FOR TESTING,
      test_no_orders         FOR TESTING RAISING cx_static_check,
      test_empty_workplace   FOR TESTING RAISING cx_static_check,
      test_no_linear_data    FOR TESTING RAISING cx_static_check,
      test_outside_eiz_scope FOR TESTING RAISING cx_static_check,
      test_gbts_no_components FOR TESTING RAISING cx_static_check,
      test_gbtn_no_components FOR TESTING RAISING cx_static_check,
      add_test_order RAISING cx_static_check,
      check_no_components IMPORTING iv_eiz TYPE eaml_d_lfe_data-z_eiz RAISING cx_static_check.
ENDCLASS.


CLASS lcl_valid_scht_st_chng_07 IMPLEMENTATION.
  METHOD class_setup.
    mi_sql_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'EAML_D_LFE_DATA' ) ( 'ZIA_2ORDER' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    mi_sql_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    mi_sql_environment->clear_doubles( ).
    go_schicht = NEW zcl_ia_2workshift( iv_zschicht = '999999999999' ).
    go_schicht->get_arbeitsstellen( )->clear( ).
    gi_parameters = NEW zcl_ia_2parameters_generic( VALUE #( ( name = zif_ia_2_validator=>mc_param_schicht dref = REF #( go_schicht ) ) ) ).
    go_cut = NEW zcl_ia_2valid_scht_st_chng_07( ii_parameters = gi_parameters ).
  ENDMETHOD.

  METHOD test_constructor.
    cl_abap_unit_assert=>assert_bound( act = go_cut ).
  ENDMETHOD.

  METHOD test_no_orders.
    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_initial( act = lt_aufnr ).

    go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).

    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_initial( act = lt_aufnr ).
  ENDMETHOD.

  METHOD test_empty_workplace.
    DATA(lo_workplace) = NEW zcl_ia_2wrkplace( iv_id = '9999' io_schicht = go_schicht ).
    lo_workplace->get_auftraege( )->clear( ).
    go_schicht->add_arbeitsstelle( io_arbstelle = lo_workplace ).

    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_initial( act = lt_aufnr ).

    go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).

    cl_abap_unit_assert=>assert_bound( act = go_schicht->get_arbeitsstelle_by_id( iv_id = lo_workplace->get_data( )-zarbstl ) ).
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_initial( act = lt_aufnr ).
  ENDMETHOD.

  METHOD test_no_linear_data.
    add_test_order( ).

    go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).

    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_aufnr ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_aufnr[ 1 ]-aufnr exp = mc_order ).
  ENDMETHOD.

  METHOD test_outside_eiz_scope.
    add_test_order( ).
    DATA lt_linear_data TYPE STANDARD TABLE OF eaml_d_lfe_data WITH EMPTY KEY.
    lt_linear_data = VALUE #(
      ( obart = 'OR' tabkey = mc_order z_eiz = 'CBTN' )
      ( obart = 'EQ' tabkey = mc_order z_eiz = zcl_ia_2tremola=>mc_eiz_gbts )
      ( obart = 'OR' tabkey = '999999999997' z_eiz = zcl_ia_2tremola=>mc_eiz_gbtn ) ).
    mi_sql_environment->insert_test_data( lt_linear_data ).

    go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).

    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_aufnr ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_aufnr[ 1 ]-aufnr exp = mc_order ).
  ENDMETHOD.

  METHOD test_gbts_no_components.
    check_no_components( iv_eiz = zcl_ia_2tremola=>mc_eiz_gbts ).
  ENDMETHOD.

  METHOD test_gbtn_no_components.
    check_no_components( iv_eiz = zcl_ia_2tremola=>mc_eiz_gbtn ).
  ENDMETHOD.

  METHOD check_no_components.
    add_test_order( ).

    DATA lt_linear_data TYPE STANDARD TABLE OF eaml_d_lfe_data WITH EMPTY KEY.
    lt_linear_data = VALUE #( ( obart = 'OR' tabkey = mc_order z_eiz = iv_eiz ) ).
    mi_sql_environment->insert_test_data( lt_linear_data ).

    zcl_ia_2lofpm_clh_application=>get_instance( iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
    DATA(lt_components) = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent( )->get_object( iv_aufnr = mc_order )->get_components( ).
    cl_abap_unit_assert=>assert_initial( act = lt_components msg = 'The fixture must return no order components' ).

    go_cut->zif_ia_2_validator~validate( ii_parameters = gi_parameters ).

    cl_abap_unit_assert=>assert_equals( act = go_cut->go_schicht exp = go_schicht ).
    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_aufnr ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_aufnr[ 1 ]-aufnr exp = mc_order ).
  ENDMETHOD.

  METHOD add_test_order.
    DATA lt_orders TYPE STANDARD TABLE OF zia_2order WITH EMPTY KEY.
    lt_orders = VALUE #( ( aufnr = mc_order zschicht = '999999999999' zarbstl = '9999' ) ).
    mi_sql_environment->insert_test_data( lt_orders ).

    DATA(lo_order) = NEW zcl_ia_2order( iv_aufnr = mc_order ).
    lo_order->set_vorschau_flag( iv_vorschau = abap_false ).
    cl_abap_unit_assert=>assert_equals( act = lo_order->get_data( )-aufnr exp = mc_order msg = 'Test order must be loaded before validating' ).

    DATA(lo_workplace) = NEW zcl_ia_2wrkplace( iv_id = '9999' io_schicht = go_schicht ).
    lo_workplace->get_auftraege( )->clear( ).
    lo_workplace->get_auftraege( )->put( key = mc_order value = lo_order ).
    go_schicht->add_arbeitsstelle( io_arbstelle = lo_workplace ).

    DATA lt_aufnr TYPE aufnr_t.
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_aufnr ) exp = 1 msg = 'Validation must receive a nonempty order list' ).
    cl_abap_unit_assert=>assert_equals( act = lt_aufnr[ 1 ]-aufnr exp = mc_order ).
  ENDMETHOD.
ENDCLASS.