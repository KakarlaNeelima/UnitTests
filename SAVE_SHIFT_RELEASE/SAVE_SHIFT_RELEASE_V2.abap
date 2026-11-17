*---------------------------------------------------------------------*
* Placement: Web Dynpro Component Controller - public method
*
* Create SAVE_SHIFT_RELEASE_V2 in the same component controller that
* currently contains SAVE_SHIFT_RELEASE.
*---------------------------------------------------------------------*
METHOD save_shift_release_v2.

  CLEAR rt_return.

  DATA(ls_shift_details) = VALUE wd_this->element_schichtdetails( ).

  wd_context->get_child_node(
    name = wd_this->wdctx_schichtdetails
  )->get_static_attributes(
    IMPORTING
      static_attributes = ls_shift_details ).

  IF ls_shift_details-object IS NOT BOUND.
    APPEND VALUE #(
      type    = 'E'
      message = 'Shift details are incomplete: shift object is missing'
    ) TO rt_return.
    RETURN.
  ENDIF.

  DATA(lt_material_data) = VALUE wd_this->elements_mat_table_data( ).

  wd_this->collect_shift_material_data(
    EXPORTING
      io_shift         = ls_shift_details-object
    CHANGING
      ct_material_data = lt_material_data ).

  wd_assist->save_shift_release_v2(
    EXPORTING
      is_shift_details = ls_shift_details
      it_material_data = lt_material_data
    IMPORTING
      et_return        = rt_return ).

ENDMETHOD.
