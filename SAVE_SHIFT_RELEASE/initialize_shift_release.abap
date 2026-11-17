*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 1-260
*
* Move the declarations into private type TY_SHIFT_RELEASE. This method
* initializes that structure, copies IS_SHIFT_DETAILS/IT_MATERIAL_DATA,
* and calls POPULATE_VEH_TYP_AND_COST_BLCK.
*---------------------------------------------------------------------*
METHOD initialize_shift_release.

  rs_release-shift-details       = is_shift_details.
  rs_release-shift-shift_object  = is_shift_details-object.
  rs_release-materials-material_data = it_material_data.

  populate_veh_typ_and_cost_blck(
    IMPORTING
      et_zia_2veh_typ_rat = rs_release-config-vehicle_type_rates
      et_zia_2cost_blck   = rs_release-config-cost_blocks
      et_zia_2veh_typ_sp  = rs_release-config-special_vehicle_types
      ev_steus            = rs_release-config-control_key
      ev_use04            = rs_release-config-use04
      ev_usr04            = rs_release-config-usr04 ).

  CONCATENATE is_shift_details-start_datum
              is_shift_details-start_zeit
         INTO rs_release-shift-start_datetime.

  CONCATENATE is_shift_details-end_datum
              is_shift_details-end_zeit
         INTO rs_release-shift-end_datetime.

ENDMETHOD.
