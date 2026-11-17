*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2331-2421
*---------------------------------------------------------------------*
METHOD save_shift_settlement_rules.

  DATA(lt_rules) = build_shift_settlement_rules(
    is_release = cs_release ).

  DATA(lt_methods) = build_settlement_bapi_methods(
    iv_shift_order = cs_release-shift-shift_order
    it_rules       = lt_rules ).

  DATA(lt_return) = VALUE bapiret2_t( ).

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods
      it_srule   = lt_rules
      return     = lt_return.

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
