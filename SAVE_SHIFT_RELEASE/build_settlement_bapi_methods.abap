*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_settlement_bapi_methods.

  LOOP AT it_rules ASSIGNING FIELD-SYMBOL(<ls_rule>).
    APPEND VALUE #(
      refnumber  = <ls_rule>-lfdnr
      objecttype = 'SRULE'
      method     = 'CREATE'
      objectkey  = iv_shift_order
    ) TO rt_methods.

    APPEND VALUE #(
      refnumber = <ls_rule>-lfdnr
      method    = 'SAVE'
      objectkey = iv_shift_order
    ) TO rt_methods.
  ENDLOOP.

ENDMETHOD.
