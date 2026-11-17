*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD find_order_revision.

  READ TABLE is_release-documents-order_revisions
    ASSIGNING FIELD-SYMBOL(<ls_revision>)
    WITH KEY order = is_order-aufnr.

  IF sy-subrc = 0.
    rv_revision = <ls_revision>-revision.
  ENDIF.

ENDMETHOD.
