CLASS lcl_test_impl DEFINITION FINAL FOR TESTING
  INHERITING FROM zcl_ia_2valfact_base_a.

  PROTECTED SECTION.
    METHODS: get_validators REDEFINITION.

ENDCLASS.

CLASS lcl_test_impl IMPLEMENTATION.

  METHOD get_validators.
    "Return empty validators table for testing
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
    "Given/When: Create instance with no parameters
    DATA(lo_cut) = NEW lcl_test_impl( ).

    "Then: Instance should be created
    cl_abap_unit_assert=>assert_bound(
      act = lo_cut
      msg = 'Instance should be created' ).
  ENDMETHOD.

  METHOD get_validation_iterator.
    "Given: Test implementation
    DATA(lo_cut) = NEW lcl_test_impl( ).

    "When: Get validation iterator
    DATA(lo_result) = lo_cut->zif_ia_2_validator_factory~get_validation_iterator( ).

    "Then: Iterator should be created
    cl_abap_unit_assert=>assert_bound(
      act = lo_result
      msg = 'Validation iterator should be created' ).
  ENDMETHOD.

ENDCLASS.
