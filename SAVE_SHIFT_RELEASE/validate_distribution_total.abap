*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD validate_distribution_total.

  DATA(lv_total) = REDUCE zia_2_percent(
    INIT result = CONV zia_2_percent( 0 )
    FOR <ls_distribution> IN it_distribution
    NEXT result = result + <ls_distribution>-percentage ).

  IF abs( lv_total - 100 ) > '0.01'.
    RAISE EXCEPTION TYPE zcx_ia_2_shift_release
      EXPORTING
        textid = zcx_ia_2_shift_release=>invalid_distribution
        msgv1  = CONV #( iv_source )
        msgv2  = CONV #( lv_total ).
  ENDIF.

ENDMETHOD.
