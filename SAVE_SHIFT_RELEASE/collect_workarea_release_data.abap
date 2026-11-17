*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 261-567
*
* Move the work-area/order/vehicle/seat traversal from the original
* method here. Store every result in CS_RELEASE-WORKAREAS.
* Do not move material-tree calls; those remain in the controller method
* COLLECT_SHIFT_MATERIAL_DATA.
*---------------------------------------------------------------------*
METHOD collect_workarea_release_data.

  DATA(lo_workarea_iterator) =
    CAST cl_object_collection_iterator(
      cs_release-shift-shift_object->get_arbeitsstellen(
      )->get_values_iterator( ) ).

  WHILE lo_workarea_iterator->has_next( ) = abap_true.
    DATA(lo_workarea) =
      CAST zcl_ia_2wrkplace( lo_workarea_iterator->get_next( ) ).

    collect_single_workarea_data(
      EXPORTING
        io_workarea = lo_workarea
      CHANGING
        cs_release  = cs_release ).
  ENDWHILE.

ENDMETHOD.
