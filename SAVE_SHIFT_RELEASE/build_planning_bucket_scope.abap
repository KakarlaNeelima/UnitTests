*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_planning_bucket_scope.

  rt_create_scope = VALUE #(
    ( %cid_ref                       = iv_bucket_cid
      %is_draft                      = if_abap_behv=>mk-on
      maintplngbcktscprangefieldname = 'ARBPL'
      %target = VALUE #(
        ( %cid                              = xco_cp=>uuid( )->value
          %is_draft                         = if_abap_behv=>mk-on
          maintplngbucketscopergsg          = 'I'
          maintplngbucketscopergop          = 'EQ'
          maintplngbucketscopergfr          = 'MIXCEN'
          mainworkcenter                    = 'MIXCEN'
          workcenterinternalid              = iv_workcenter_internal
          mainworkcenterplant               = iv_planning_plant
          maintenanceplanningplant          = iv_planning_plant
          %control-maintplngbucketscopergsg = if_abap_behv=>mk-on
          %control-maintplngbucketscopergop = if_abap_behv=>mk-on
          %control-maintplngbucketscopergfr = if_abap_behv=>mk-on
          %control-mainworkcenter           = if_abap_behv=>mk-on
          %control-workcenterinternalid     = if_abap_behv=>mk-on
          %control-mainworkcenterplant      = if_abap_behv=>mk-on
          %control-maintenanceplanningplant = if_abap_behv=>mk-on ) ) ) ).

ENDMETHOD.
