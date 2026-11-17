CLASS lcl_test_impl DEFINITION FINAL FOR TESTING
  INHERITING FROM zcl_ia_2valfact_base_a.
  PROTECTED SECTION.
    METHODS: get_validators REDEFINITION.
ENDCLASS.

CLASS lcl_test_impl IMPLEMENTATION.
  METHOD get_validators.
    rt_validators = VALUE #( ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_valfact_base_a DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS:
      test_constructor FOR TESTING RAISING cx_static_check,
      get_validation_iterator FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_valfact_base_a IMPLEMENTATION.
  METHOD test_constructor.
    DATA(lo_cut) = NEW lcl_test_impl( ).
    cl_abap_unit_assert=>assert_bound( act = lo_cut msg = 'Instance created' ).
  ENDMETHOD.

  METHOD get_validation_iterator.
    DATA(lo_cut) = NEW lcl_test_impl( ).
    DATA(lo_result) = lo_cut->zif_ia_2_validator_factory~get_validation_iterator( ).
    cl_abap_unit_assert=>assert_bound( act = lo_result msg = 'Iterator created' ).
  ENDMETHOD.
ENDCLASS.
