*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2451-2478
*---------------------------------------------------------------------*
METHOD update_shift_order_components.

  LOOP AT cs_release-materials-material_data ASSIGNING FIELD-SYMBOL(<ls_material>).
    APPEND VALUE #(
      aufnr       = <ls_material>-aufnr
      start_datum = cs_release-shift-details-start_datum
      start_zeit  = cs_release-shift-details-start_zeit
      reserv_no   = <ls_material>-rsnum
      res_item    = <ls_material>-rspos
      fzg_belad   = determine_component_loading_location(
                      is_material = <ls_material>
                      is_release  = cs_release )
    ) TO cs_release-materials-order_components.
  ENDLOOP.

  update_components(
    it_orders = cs_release-materials-order_components ).

ENDMETHOD.
