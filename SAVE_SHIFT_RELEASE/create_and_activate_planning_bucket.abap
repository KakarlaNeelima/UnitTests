*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* Shared implementation for ER and IR planning buckets. Move the common
* CREATE/PREPARE/ACTIVATE/COMMIT ENTITIES code currently duplicated near
* original lines 620-805 and 1440-1613 into this method.
*
* Return a structure containing:
*   BUCKET_CID
*   MAINTPLANNINGBUCKETUUID
*   DESCRIPTION
*---------------------------------------------------------------------*
METHOD create_and_activate_planning_bucket.

  DATA(lv_bucket_cid) = xco_cp=>uuid( )->value.

  DATA(lt_create_bucket) = build_planning_bucket_create_data(
    is_shift_details       = is_shift_details
    is_workarea            = is_workarea
    is_order               = is_order
    iv_direction           = iv_direction
    iv_planning_plant      = iv_planning_plant
    iv_workcenter_internal = iv_workcenter_internal
    iv_bucket_cid          = lv_bucket_cid ).

  DATA(lt_create_scope) = build_planning_bucket_scope(
    iv_bucket_cid          = lv_bucket_cid
    iv_planning_plant      = iv_planning_plant
    iv_workcenter_internal = iv_workcenter_internal ).

  execute_planning_bucket_create(
    EXPORTING
      it_create_bucket = lt_create_bucket
      it_create_scope  = lt_create_scope
    IMPORTING
      es_bucket        = rs_bucket ).

ENDMETHOD.
