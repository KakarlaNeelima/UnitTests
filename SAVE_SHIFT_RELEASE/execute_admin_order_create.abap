*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD execute_admin_order_create.

  DATA(lt_return) = VALUE bapiret2_t( ).

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = it_methods
      it_header    = it_header
      it_operation = it_operations
      return       = lt_return.

  IF bapi_has_errors( lt_return ) = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE EXCEPTION TYPE zcx_ia_2_shift_release
      EXPORTING
        it_bapiret = lt_return.
  ENDIF.

  READ TABLE lt_return
    ASSIGNING FIELD-SYMBOL(<ls_created>)
    WITH KEY id = 'IWO_BAPI2' number = '112'.
  IF sy-subrc <> 0 OR <ls_created>-message_v2 IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE EXCEPTION TYPE zcx_ia_2_shift_release
      EXPORTING
        textid = zcx_ia_2_shift_release=>admin_order_number_missing.
  ENDIF.

  rv_admin_order = <ls_created>-message_v2.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDMETHOD.
