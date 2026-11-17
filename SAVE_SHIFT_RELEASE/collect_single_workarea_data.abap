*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 263-522
*---------------------------------------------------------------------*
METHOD collect_single_workarea_data.

  "Move the original per-work-area order, capacity, vehicle and seat
  "collection block here. Append results only to CS_RELEASE-WORKAREAS.
  collect_workarea_orders(
    EXPORTING io_workarea = io_workarea
    CHANGING  cs_release  = cs_release ).

  collect_workarea_qualifications(
    EXPORTING io_workarea = io_workarea
    CHANGING  cs_release  = cs_release ).

  collect_workarea_vehicle_costs(
    EXPORTING io_workarea = io_workarea
    CHANGING  cs_release  = cs_release ).

ENDMETHOD.
