*"* use this source file for your ABAP unit test classes
CLASS lcl_ia_2order_utils DEFINITION DEFERRED.
CLASS zcl_ia_2order_utils DEFINITION LOCAL FRIENDS lcl_ia_2order_utils.

CLASS lcl_ia_2order_utils DEFINITION FINAL
                                     FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA go_auftraege	TYPE REF TO cl_object_map.
    DATA go_schicht	TYPE REF TO zcl_ia_2workshift.
    METHODS setup  RAISING cx_static_check.
    METHODS change_user_status              FOR TESTING RAISING cx_static_check.
    METHODS create_backup               FOR TESTING RAISING cx_static_check.
    METHODS get_aufk               FOR TESTING RAISING cx_static_check.
    METHODS get_cust_eiz               FOR TESTING RAISING cx_static_check.
    METHODS set_orsc_status               FOR TESTING RAISING cx_static_check.
    METHODS set_orsc_invalid_order FOR TESTING RAISING cx_static_check.


ENDCLASS.


CLASS lcl_ia_2order_utils IMPLEMENTATION.

  METHOD setup.
    go_auftraege = NEW #( ).
    DATA lv_schicht TYPE zia_2_workshift.
    go_schicht = NEW #( iv_zschicht = lv_schicht ).
  ENDMETHOD.

  METHOD change_user_status.

    DATA lv_status  TYPE j_txt04 .
    DATA lv_arbzeit_upd	TYPE abap_bool.
    DATA lv_test_run  TYPE abap_bool.

    zcl_ia_2order_utils=>change_user_status( EXPORTING io_auftraege = go_auftraege
                                                       io_schicht = go_schicht
                                                       iv_status = lv_status
                                                       iv_arbzeit_upd = lv_arbzeit_upd
                                                       iv_test_run = lv_test_run ).
    cl_abap_unit_assert=>assert_bound( go_schicht ).
  ENDMETHOD.

  METHOD create_backup.
    ##NEEDED    DATA lo_auftraege	TYPE REF TO cl_object_map .
    DATA lo_auftrag	TYPE REF TO zcl_ia_2order.
    ##NEEDED    DATA lo_schicht	TYPE REF TO zcl_ia_2workshift.
    DATA lt_aufk  TYPE tt_aufk.
    lo_auftrag = NEW #( ).

    zcl_ia_2order_utils=>create_backup( EXPORTING io_auftraege = go_auftraege
                                                  io_auftrag = lo_auftrag
                                                  io_schicht = go_schicht
                                                  it_aufk = lt_aufk ).
    cl_abap_unit_assert=>assert_bound( go_schicht ).
  ENDMETHOD.

  METHOD get_aufk.
    ##NEEDED    DATA lo_auftraege	TYPE REF TO cl_object_map.
    DATA(lt_data) = zcl_ia_2order_utils=>get_aufk( EXPORTING io_auftraege = go_auftraege ).
    cl_abap_unit_assert=>assert_initial( lt_data ).
  ENDMETHOD.

  METHOD get_cust_eiz.
    DATA lv_arbpl	TYPE arbpl.
    DATA lv_werks	TYPE werks_d.
    DATA(lt_data) = zcl_ia_2order_utils=>get_cust_eiz( EXPORTING iv_arbpl = lv_arbpl
                                                 iv_werks = lv_werks ).
    cl_abap_unit_assert=>assert_initial( lt_data ).
  ENDMETHOD.

  METHOD set_orsc_status.
    TRY.
        zcl_ia_2order_utils=>set_orsc_status( io_auftraege = go_auftraege ).
      CATCH zcx_ia_2failure ##NO_HANDLER.
    ENDTRY.
    cl_abap_unit_assert=>assert_bound( go_auftraege ).
  ENDMETHOD.

  METHOD set_orsc_invalid_order.
    DATA(lo_auftrag) = NEW zcl_ia_2order( iv_aufnr = '999999999999' ).
    DATA(lo_auftraege) = NEW cl_object_map( ).
    lo_auftraege->put( EXPORTING key   = lo_auftrag->get_id( )
                                 value = lo_auftrag ).

    TRY.
        zcl_ia_2order_utils=>set_orsc_status( io_auftraege = lo_auftraege ).
        cl_abap_unit_assert=>fail( msg = 'ZCX_IA_2FAILURE was expected' ).
      CATCH zcx_ia_2failure.
        cl_abap_unit_assert=>assert_true( act = abap_true ).
    ENDTRY.
  ENDMETHOD.



ENDCLASS.