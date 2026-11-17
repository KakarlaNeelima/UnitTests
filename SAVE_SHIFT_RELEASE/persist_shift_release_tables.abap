*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Source extraction: SAVE_SHIFT_RELEASE.abap lines 2422-2424
*---------------------------------------------------------------------*
METHOD persist_shift_release_tables.

  modify_settlement_tables(
    EXPORTING
      it_zia_2sf_orderstr = cs_release-documents-order_settlement
      it_zia_2sf_veh_cost = cs_release-documents-vehicle_settlement ).

ENDMETHOD.
