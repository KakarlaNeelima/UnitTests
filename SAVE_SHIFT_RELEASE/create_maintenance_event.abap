*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* Move the repeated EDIT/PREPARE/ACTIVATE/READ ENTITIES implementation
* from the ER and IR branches into this method.
*---------------------------------------------------------------------*
METHOD create_maintenance_event.

  execute_maintenance_event_creation(
    EXPORTING
      iv_bucket_cid  = is_bucket-bucket_cid
      iv_bucket_uuid = is_bucket-maintplanningbucketuuid
    IMPORTING
      es_event       = rs_event ).

  IF rs_event-maintenanceevent IS INITIAL.
    RAISE EXCEPTION TYPE zcx_ia_2_shift_release
      EXPORTING
        textid = zcx_ia_2_shift_release=>maintenance_event_failed.
  ENDIF.

ENDMETHOD.
