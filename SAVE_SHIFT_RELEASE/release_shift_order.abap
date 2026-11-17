*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* IMPORTING IV_SHIFT_ORDER TYPE AUFNR
* CHANGING  CT_RETURN      TYPE BAPIRET2_T
*---------------------------------------------------------------------*
METHOD release_shift_order.

  DATA(lt_methods) = VALUE bapi_alm_order_method_t(
    ( refnumber  = 1
      objecttype = 'HEADER'
      method     = 'RELEASE'
      objectkey  = iv_shift_order )
    ( refnumber  = 1
      objecttype = space
      method     = 'SAVE'
      objectkey  = iv_shift_order ) ).

  DATA(lt_bapi_return) = VALUE bapiret2_t( ).

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods
      return     = lt_bapi_return.

  APPEND LINES OF lt_bapi_return TO ct_return.

  IF bapi_has_errors( lt_bapi_return ) = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

  update_order_phase_subphase(
    iv_order    = iv_shift_order
    iv_phase    = '07'
    iv_subphase = '0065' ).

ENDMETHOD.
