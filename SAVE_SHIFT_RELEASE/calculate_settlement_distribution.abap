*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2001-2330
*---------------------------------------------------------------------*
METHOD calculate_settlement_distribution.

  calculate_labor_distribution(
    CHANGING
      cs_release = cs_release ).

  calculate_vehicle_distribution(
    CHANGING
      cs_release = cs_release ).

  validate_distribution_total(
    it_distribution = cs_release-documents-labor_distribution
    iv_source        = 'L_3' ).

  validate_distribution_total(
    it_distribution = cs_release-documents-vehicle_distribution
    iv_source        = 'I_2' ).

ENDMETHOD.
