*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: labor calculations in original lines 2001-2330
*---------------------------------------------------------------------*
METHOD calculate_labor_distribution.

  CLEAR cs_release-documents-labor_distribution.

  LOOP AT cs_release-documents-order_settlement
       ASSIGNING FIELD-SYMBOL(<ls_order>).
    COLLECT VALUE ty_distribution(
      admin_order = <ls_order>-etap_aufnr
      percentage  = <ls_order>-percentage
    ) INTO cs_release-documents-labor_distribution.
  ENDLOOP.

  normalize_distribution(
    CHANGING
      ct_distribution = cs_release-documents-labor_distribution ).

ENDMETHOD.
