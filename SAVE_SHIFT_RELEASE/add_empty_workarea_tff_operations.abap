*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2482-2504
*---------------------------------------------------------------------*
METHOD add_empty_workarea_tff_operations.

  LOOP AT cs_release-workareas-details ASSIGNING FIELD-SYMBOL(<ls_workarea>).
    IF line_exists(
         cs_release-workareas-original_orders[
           zarbstl = <ls_workarea>-wa_id ] ).
      CONTINUE.
    ENDIF.

    DATA(lt_tff) = FILTER #(
      cs_release-workareas-tff_qualifications
      WHERE wa_id = <ls_workarea>-wa_id ).

    update_tff_in_shift_order(
      iv_shift_aufnr               = cs_release-shift-shift_order
      it_qual_tff                  = lt_tff
      is_schichtdetails            = cs_release-shift-details
      iv_maintenanceplanningplant  = cs_release-shift-planning_plant
      iv_shorttext                 = cs_release-shift-short_text
      iv_steus                     = cs_release-config-control_key
      iv_use04                     = cs_release-config-use04
      iv_usr04                     = cs_release-config-usr04 ).
  ENDLOOP.

ENDMETHOD.
