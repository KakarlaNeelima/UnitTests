*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD normalize_distribution.

  IF ct_distribution IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lv_total) = REDUCE zia_2_percent(
    INIT result = CONV zia_2_percent( 0 )
    FOR <ls_distribution> IN ct_distribution
    NEXT result = result + <ls_distribution>-percentage ).

  IF lv_total = 0.
    RETURN.
  ENDIF.

  LOOP AT ct_distribution ASSIGNING FIELD-SYMBOL(<ls_distribution>).
    <ls_distribution>-percentage =
      ( <ls_distribution>-percentage / lv_total ) * 100.
  ENDLOOP.

ENDMETHOD.
