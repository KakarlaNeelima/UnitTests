*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_planning_bucket_description.

  DATA(lv_access_type) = COND string(
    WHEN is_order IS SUPPLIED
    THEN is_order-zzzugangsart
    ELSE is_workarea-access_type ).

  CONCATENATE is_shift_details-start_datum+6(2) '.'
              is_shift_details-start_datum+4(2) '.'
              is_shift_details-start_datum(4) '_'
              is_shift_details-zzperi '_'
              is_workarea-text '_'
              iv_direction '_'
              lv_access_type
         INTO rv_description.

  IF iv_direction = 'IR' AND is_order IS SUPPLIED.
    CONCATENATE rv_description '_'
                is_order-wbs
           INTO rv_description.
  ENDIF.

ENDMETHOD.
