*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: vehicle calculations in original lines 2001-2330
*---------------------------------------------------------------------*
METHOD calculate_vehicle_distribution.

  CLEAR cs_release-documents-vehicle_distribution.

  LOOP AT cs_release-documents-vehicle_settlement
       ASSIGNING FIELD-SYMBOL(<ls_vehicle>).
    DATA(lv_receiver) = COND aufnr(
      WHEN <ls_vehicle>-spez_fzg_kstenblck IS NOT INITIAL
      THEN <ls_vehicle>-spez_fzg_kstenblck
      ELSE <ls_vehicle>-etap_aufnr ).

    COLLECT VALUE ty_distribution(
      admin_order = lv_receiver
      percentage  = <ls_vehicle>-prozent
    ) INTO cs_release-documents-vehicle_distribution.
  ENDLOOP.

  normalize_distribution(
    CHANGING
      ct_distribution = cs_release-documents-vehicle_distribution ).

ENDMETHOD.
