*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: original revision/status blocks
*---------------------------------------------------------------------*
METHOD complete_planned_orders.

  LOOP AT cs_release-workareas-original_orders ASSIGNING FIELD-SYMBOL(<ls_order>).
    DATA(lv_revision) = find_order_revision(
      is_order   = <ls_order>
      is_release = cs_release ).

    change_planned_order_revision(
      is_order    = <ls_order>
      iv_revision = lv_revision ).

    cl_eams_bo_order=>s_get_instance(
      )->if_eams_bo_order~reset_ready_for_scheduling(
        EXPORTING
          it_ord_id       = VALUE #( ( eams_aufnr = <ls_order>-aufnr ) )
        IMPORTING
          et_message      = DATA(lt_messages)
          et_index_failed = DATA(lt_failed) ).

    update_order_phase_subphase(
      iv_order    = <ls_order>-aufnr
      iv_phase    = '07'
      iv_subphase = '0065' ).
  ENDLOOP.

ENDMETHOD.
