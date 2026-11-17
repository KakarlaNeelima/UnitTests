*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* Consolidate the duplicated BAPI_ALM_ORDER_MAINTAIN create logic from
* the ER and IR branches. Build operations in separate helpers because
* ER uses work-area qualifications while IR uses order/WBS capacities.
*---------------------------------------------------------------------*
METHOD create_admin_order.

  DATA(lt_methods) = build_admin_order_methods(
    iv_direction = iv_direction ).

  DATA(lt_header) = build_admin_order_header(
    is_shift_details = is_shift_details
    is_workarea      = is_workarea
    is_order         = is_order
    is_event         = is_event ).

  DATA(lt_operations) = build_admin_order_operations(
    is_shift_details = is_shift_details
    is_workarea      = is_workarea
    is_order         = is_order
    iv_direction     = iv_direction
    is_config        = is_config ).

  rv_admin_order = execute_admin_order_create(
    it_methods    = lt_methods
    it_header     = lt_header
    it_operations = lt_operations ).

ENDMETHOD.
