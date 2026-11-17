*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: ER operations lines 900-980; IR lines 1680-1875
*---------------------------------------------------------------------*
METHOD build_admin_order_operations.

  IF iv_direction = 'ER'.
    rt_operations = build_er_admin_order_operations(
      is_shift_details = is_shift_details
      is_workarea      = is_workarea
      is_config        = is_config ).
  ELSE.
    rt_operations = build_ir_admin_order_operations(
      is_shift_details = is_shift_details
      is_workarea      = is_workarea
      is_order         = is_order
      is_config        = is_config ).
  ENDIF.

ENDMETHOD.
