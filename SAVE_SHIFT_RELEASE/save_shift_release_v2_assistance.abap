*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - public method
*
* IMPORTING IS_SHIFT_DETAILS
*           IT_MATERIAL_DATA
* EXPORTING ET_RETURN TYPE BAPIRET2_T
*---------------------------------------------------------------------*
METHOD save_shift_release_v2.

  CLEAR et_return.

  DATA(ls_release) = initialize_shift_release(
    is_shift_details = is_shift_details
    it_material_data = it_material_data ).

  TRY.
      collect_workarea_release_data(
        CHANGING cs_release = ls_release ).

      create_er_planning_documents(
        CHANGING cs_release = ls_release ).

      create_ir_planning_documents(
        CHANGING cs_release = ls_release ).

      complete_planned_orders(
        CHANGING cs_release = ls_release ).

      calculate_settlement_distribution(
        CHANGING cs_release = ls_release ).

      save_shift_settlement_rules(
        CHANGING cs_release = ls_release ).

      persist_shift_release_tables(
        CHANGING cs_release = ls_release ).

      update_shift_order_components(
        CHANGING cs_release = ls_release ).

      add_empty_workarea_tff_operations(
        CHANGING cs_release = ls_release ).

      release_shift_order(
        EXPORTING
          iv_shift_order = ls_release-shift_order
        CHANGING
          ct_return      = et_return ).

      IF bapi_has_errors( et_return ) = abap_true.
        RETURN.
      ENDIF.

      update_shift_notification_priority(
        EXPORTING
          iv_notification = is_shift_details-zschicht
        CHANGING
          ct_return       = et_return ).

    CATCH zcx_ia_2_shift_release INTO DATA(lx_release).
      rollback_entities( ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      APPEND VALUE #(
        type       = 'E'
        id         = lx_release->if_t100_message~t100key-msgid
        number     = lx_release->if_t100_message~t100key-msgno
        message_v1 = lx_release->if_t100_dyn_msg~msgv1
        message_v2 = lx_release->if_t100_dyn_msg~msgv2
        message_v3 = lx_release->if_t100_dyn_msg~msgv3
        message_v4 = lx_release->if_t100_dyn_msg~msgv4
        message    = lx_release->get_text( )
      ) TO et_return.
  ENDTRY.

ENDMETHOD.
