*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_shift_settlement_rules.

  DATA(lv_sequence) = 0.

  LOOP AT is_release-documents-labor_distribution
       ASSIGNING FIELD-SYMBOL(<ls_labor>).
    lv_sequence += 1.
    APPEND VALUE #(
      objnr      = is_release-shift-shift_order
      lfdnr      = lv_sequence
      settl_type = 'PER'
      source     = 'L_3'
      orderid    = <ls_labor>-admin_order
      percentage = <ls_labor>-percentage
    ) TO rt_rules.
  ENDLOOP.

  LOOP AT is_release-documents-vehicle_distribution
       ASSIGNING FIELD-SYMBOL(<ls_vehicle>).
    lv_sequence += 1.
    APPEND VALUE #(
      objnr      = is_release-shift-shift_order
      lfdnr      = lv_sequence
      settl_type = 'PER'
      source     = 'I_2'
      orderid    = <ls_vehicle>-admin_order
      percentage = <ls_vehicle>-percentage
    ) TO rt_rules.
  ENDLOOP.

ENDMETHOD.
