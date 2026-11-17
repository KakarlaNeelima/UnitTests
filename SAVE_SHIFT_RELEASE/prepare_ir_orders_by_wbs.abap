*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 1365-1438
*---------------------------------------------------------------------*
METHOD prepare_ir_orders_by_wbs.

  populate_n004_wbs_assignments(
    CHANGING
      cs_release = cs_release ).

  SORT cs_release-workareas-ir_orders
    BY workarea_id wbs access_type.

  DELETE ADJACENT DUPLICATES
    FROM cs_release-workareas-ir_orders
    COMPARING workarea_id wbs access_type.

ENDMETHOD.
