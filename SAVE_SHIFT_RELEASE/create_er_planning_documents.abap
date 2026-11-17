*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 568-1171
*
* For every work area containing non-N004 orders:
*   1. Build the ER bucket description.
*   2. Call CREATE_AND_ACTIVATE_PLANNING_BUCKET.
*   3. Call CREATE_MAINTENANCE_EVENT.
*   4. Call CREATE_ADMIN_ORDER.
*   5. Store bucket, revision and admin-order results in CS_RELEASE.
*---------------------------------------------------------------------*
METHOD create_er_planning_documents.

  LOOP AT cs_release-workareas-items ASSIGNING FIELD-SYMBOL(<ls_workarea>)
       WHERE er_orders IS NOT INITIAL.

    DATA(ls_bucket) = create_and_activate_planning_bucket(
      is_shift_details        = cs_release-shift-details
      is_workarea             = <ls_workarea>
      iv_direction            = 'ER'
      iv_planning_plant       = cs_release-shift-aufk-werks
      iv_workcenter_internal  = cs_release-config-workcenter_internal_id ).

    DATA(ls_event) = create_maintenance_event(
      is_bucket = ls_bucket ).

    DATA(lv_admin_order) = create_admin_order(
      is_shift_details = cs_release-shift-details
      is_workarea      = <ls_workarea>
      is_event         = ls_event
      iv_direction     = 'ER'
      is_config        = cs_release-config ).

    <ls_workarea>-er_bucket      = ls_bucket.
    <ls_workarea>-er_event       = ls_event.
    <ls_workarea>-er_admin_order = lv_admin_order.
  ENDLOOP.

ENDMETHOD.
