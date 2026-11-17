*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2460-2475
*---------------------------------------------------------------------*
METHOD determine_component_loading_location.

  rv_loading_location = is_material-fzg_belad.
  IF rv_loading_location IS NOT INITIAL.
    RETURN.
  ENDIF.

  READ TABLE is_release-workareas-original_orders
    ASSIGNING FIELD-SYMBOL(<ls_order>)
    WITH KEY aufnr = is_material-aufnr.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  READ TABLE is_release-workareas-details
    ASSIGNING FIELD-SYMBOL(<ls_workarea>)
    WITH KEY wa_id = <ls_order>-zarbstl.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  DATA(lv_text) = <ls_workarea>-text.
  IF lv_text CA '-'.
    SPLIT lv_text AT '-' INTO DATA(lv_prefix) lv_text.
  ENDIF.
  SPLIT lv_text AT '(' INTO rv_loading_location DATA(lv_suffix).
  CONDENSE rv_loading_location.

ENDMETHOD.
