*"* Local classes implementation for ZCL_IA_2CONTEXT_HELPER

CLASS lcl_interpreter_factory_a IMPLEMENTATION.

  METHOD get_ctxelem_interpreter.

    CASE iv_node_name.

      WHEN zcl_ia_2context_helper=>mc_wdctx_sitzplatz.
        ri_instance = NEW lcl_interp_sitzplatz( ).

      WHEN zcl_ia_2context_helper=>mc_wdctx_einzelkapas.
        ri_instance = NEW lcl_interp_einzelkapas( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_ctxelem_interpreter IMPLEMENTATION.

  METHOD lif_ctxelem_interpreter~set_context_element.
    gi_context_element = ii_context_element.
  ENDMETHOD.

  METHOD lif_ctxelem_interpreter~get_attribute_object.
    TRY .
        gi_context_element->get_attribute( EXPORTING name  = iv_name
                                           IMPORTING value = ro_object ).
      CATCH cx_no_check.
    ENDTRY.
  ENDMETHOD.

  METHOD lif_ctxelem_interpreter~get_attribute_string.
    TRY .
        gi_context_element->get_attribute( EXPORTING name  = iv_name
                                           IMPORTING value = rv_value ).
      CATCH cx_no_check.
    ENDTRY.
  ENDMETHOD.

  METHOD lif_ctxelem_interpreter~is_selected.

    DATA(lv_true_value)      = get_true_value( ).
    DATA(lv_selection_value) = get_selection_value( ).

    rv_value = COND #( WHEN lv_selection_value = lv_true_value THEN abap_true ELSE abap_false ).

  ENDMETHOD.

  METHOD get_context_element.
    ri_context_element = gi_context_element.
  ENDMETHOD.

  ##NEEDED  METHOD get_selection_value.
  ENDMETHOD.

  METHOD get_true_value.
    rv_value = abap_true.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_interp_sitzplatz IMPLEMENTATION.

  METHOD get_selection_value.

    DATA(li_context_element) = get_context_element( ).

    TRY .
        li_context_element->get_attribute( EXPORTING name  = zcl_ia_2context_helper=>mc_atnam_auswahl
                                           IMPORTING value = rv_value ).
      CATCH cx_sy_ref_is_initial.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_interp_einzelkapas IMPLEMENTATION.

  METHOD get_selection_value.

    DATA(li_context_element) = get_context_element( ).

    TRY .
        li_context_element->get_attribute( EXPORTING name  = zcl_ia_2context_helper=>mc_atnam_img_for_visualization
                                           IMPORTING value = rv_value ).
      CATCH cx_sy_ref_is_initial.
    ENDTRY.

  ENDMETHOD.

  METHOD get_true_value.
    rv_value = zif_ia_2_wd_indiv_capacity=>mc_image_selected.
  ENDMETHOD.

ENDCLASS.
