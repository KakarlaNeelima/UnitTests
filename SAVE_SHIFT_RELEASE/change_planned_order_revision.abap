*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD change_planned_order_revision.

  DATA(lt_methods) = VALUE bapi_alm_order_method_t(
    ( refnumber  = 1
      objecttype = 'HEADER'
      method     = 'CHANGE'
      objectkey  = is_order-aufnr )
    ( refnumber  = 1
      objecttype = space
      method     = 'SAVE'
      objectkey  = is_order-aufnr ) ).

  DATA(lt_header) = VALUE bapi_alm_order_headers_i_t(
    ( orderid   = is_order-aufnr
      order_type = is_order-auart
      revision   = iv_revision ) ).

  DATA(lt_header_up) = VALUE bapi_alm_order_headers_up_t(
    ( orderid = is_order-aufnr
      revision = abap_true ) ).

  DATA(lt_return) = VALUE bapiret2_t( ).

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_header    = lt_header
      it_header_up = lt_header_up
      return       = lt_return.

  IF bapi_has_errors( lt_return ) = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE EXCEPTION TYPE zcx_ia_2_shift_release
      EXPORTING
        it_bapiret = lt_return.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDMETHOD.
