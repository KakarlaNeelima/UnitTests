*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_admin_order_header.

  rt_header = VALUE #(
    ( orderid     = '%00000000001'
      order_type  = is_event-admin_order_type
      pmacttype   = 'NAA'
      revision    = is_event-maintenanceevent
      maintplant  = is_event-maintenanceplanningplant
      planplant   = is_event-maintenanceplanningplant
      plant       = is_event-maintenanceplanningplant
      mn_wk_ctr   = 'CH'
      short_text  = is_event-bucket_description
      start_date  = is_shift_details-start_datum
      finish_date = is_shift_details-end_datum ) ).

ENDMETHOD.
