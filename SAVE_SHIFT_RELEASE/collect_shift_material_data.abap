*---------------------------------------------------------------------*
* Placement: Web Dynpro Component Controller - private method
*
* IMPORTING IO_SHIFT         TYPE REF TO ZCL_IA_2WORKSHIFT
* CHANGING  CT_MATERIAL_DATA TYPE WD_THIS->ELEMENTS_MAT_TABLE_DATA
*---------------------------------------------------------------------*
METHOD collect_shift_material_data.

  DATA(lo_workarea_iterator) =
    CAST cl_object_collection_iterator(
      io_shift->get_arbeitsstellen( )->get_values_iterator( ) ).

  WHILE lo_workarea_iterator->has_next( ) = abap_true.
    DATA(lo_workarea) =
      CAST zcl_ia_2wrkplace( lo_workarea_iterator->get_next( ) ).

    mo_cc_schdet_mat_table->append_table_lvl_arb(
      EXPORTING
        io_arbstl = lo_workarea
      CHANGING
        ct_data   = ct_material_data ).

    mo_cc_schdet_mat_table->append_table_lvl_auf(
      EXPORTING
        io_arbstl = lo_workarea
      CHANGING
        ct_data   = ct_material_data ).

    mo_cc_schdet_mat_table->append_table_lvl_mat(
      EXPORTING
        io_arbstl = lo_workarea
      CHANGING
        ct_data   = ct_material_data ).
  ENDWHILE.

  DELETE ct_material_data WHERE level <> 'LEVEL_3'.

ENDMETHOD.
