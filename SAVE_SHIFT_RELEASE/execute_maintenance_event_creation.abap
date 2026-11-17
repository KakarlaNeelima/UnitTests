*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Contains EDIT/PREPARE/ACTIVATE/READ ENTITIES.
*---------------------------------------------------------------------*
METHOD execute_maintenance_event_creation.

  "Copy the common EML event block from original lines 755-829 here.
  "Populate ES_EVENT with the READ ENTITIES result. On FAILED or a
  "reported error, rollback and raise ZCX_IA_2_SHIFT_RELEASE.

ENDMETHOD.
