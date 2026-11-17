*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: repeated bucket VALUE expressions
*---------------------------------------------------------------------*
METHOD build_planning_bucket_create_data.

  DATA(lv_description) = build_planning_bucket_description(
    is_shift_details = is_shift_details
    is_workarea      = is_workarea
    is_order         = is_order
    iv_direction     = iv_direction ).

  rt_create_bucket = VALUE #(
    ( %cid                                    = iv_bucket_cid
      %is_draft                               = if_abap_behv=>mk-on
      maintplanningbucketdescription          = lv_description
      nrofmaintplngbucketsinadvance           = 1
      maintplngbucketgenerationdate           = sy-datum
      maintplanningbuckettype                 = 'STO'
      maintenanceplanningplant                = iv_planning_plant
      maintplngbucketstartdatetime            = CONV #( is_shift_details-start_datum && is_shift_details-start_zeit )
      maintplngbucketenddatetime              = CONV #( is_shift_details-end_datum && is_shift_details-end_zeit )
      maintplngbucketrecurrencetype           = if_eam_mtplngbkt_const=>maintplngbcktrecurrencetype-once
      maintplngbcktrcrrcinterval              = 1
      maintenanceeventtype                    = 'NA'
      mainworkcenter                          = 'MIXCEN'
      adminvordworkcenterinternal             = iv_workcenter_internal
      %control-maintplanningbucketdescription = if_abap_behv=>mk-on
      %control-nrofmaintplngbucketsinadvance  = if_abap_behv=>mk-on
      %control-maintplngbucketgenerationdate  = if_abap_behv=>mk-on
      %control-maintplanningbuckettype        = if_abap_behv=>mk-on
      %control-maintenanceplanningplant       = if_abap_behv=>mk-on
      %control-maintplngbucketstartdatetime   = if_abap_behv=>mk-on
      %control-maintplngbucketenddatetime     = if_abap_behv=>mk-on
      %control-maintplngbucketrecurrencetype  = if_abap_behv=>mk-on
      %control-maintplngbcktrcrrcinterval     = if_abap_behv=>mk-on
      %control-maintenanceeventtype           = if_abap_behv=>mk-on
      %control-mainworkcenter                 = if_abap_behv=>mk-on
      %control-adminvordworkcenterinternal    = if_abap_behv=>mk-on ) ).

ENDMETHOD.
