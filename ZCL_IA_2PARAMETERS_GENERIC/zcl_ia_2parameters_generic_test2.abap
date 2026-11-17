*"* Additional test class for _DEMO coverage
CLASS lcl_ia_2params_gen_demo DEFINITION DEFERRED.
CLASS zcl_ia_2parameters_generic DEFINITION LOCAL FRIENDS lcl_ia_2params_gen_demo.

CLASS lcl_ia_2params_gen_demo DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_demo FOR TESTING,
      test_demo_output_content FOR TESTING.
ENDCLASS.

CLASS lcl_ia_2params_gen_demo IMPLEMENTATION.

  METHOD test_demo.
    DATA lv_output TYPE string.
    zcl_ia_2parameters_generic=>_demo(
      IMPORTING ev_output = lv_output ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_output
      msg = 'Demo output must not be empty' ).
  ENDMETHOD.

  METHOD test_demo_output_content.
    DATA lv_output TYPE string.
    zcl_ia_2parameters_generic=>_demo(
      IMPORTING ev_output = lv_output ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_output
      exp = '*TYPE REF TO*'
      msg = 'Output must contain TYPE REF TO' ).
  ENDMETHOD.

ENDCLASS.
