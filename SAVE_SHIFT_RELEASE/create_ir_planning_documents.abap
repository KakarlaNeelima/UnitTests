*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 1172-1996
*
* De-duplicate N004/access-type-2 orders by work area and WBS. For each
* resulting order call the common planning-bucket, event and admin-order
* methods, then store the resulting document references in CS_RELEASE.
*---------------------------------------------------------------------*
METHOD create_ir_planning_documents.

  prepare_ir_orders_by_wbs(
    CHANGING
      cs_release = cs_release ).

  LOOP AT cs_release-workareas-ir_orders ASSIGNING FIELD-SYMBOL(<ls_order>).
    DATA(ls_bucket) = create_and_activate_planning_bucket(
      is_shift_details        = cs_release-shift-details
      is_workarea             = <ls_order>-workarea
      is_order                = <ls_order>-order
      iv_direction            = 'IR'
      iv_planning_plant       = cs_release-shift-aufk-werks
      iv_workcenter_internal  = cs_release-config-workcenter_internal_id ).

    DATA(ls_event) = create_maintenance_event(
      is_bucket = ls_bucket ).

    DATA(lv_admin_order) = create_admin_order(
      is_shift_details = cs_release-shift-details
      is_workarea      = <ls_order>-workarea
      is_order         = <ls_order>-order
      is_event         = ls_event
      iv_direction     = 'IR'
      is_config        = cs_release-config ).

    <ls_order>-bucket      = ls_bucket.
    <ls_order>-event       = ls_event.
    <ls_order>-admin_order = lv_admin_order.
  ENDLOOP.

ENDMETHOD.
