*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
* Contains CREATE/PREPARE/ACTIVATE and rollback checks.
*---------------------------------------------------------------------*
METHOD execute_planning_bucket_create.

  "Copy the common EML block from original lines 672-743 here.
  "Populate ES_BUCKET-BUCKET_CID and
  "ES_BUCKET-MAINTPLANNINGBUCKETUUID after successful activation.
  "On FAILED or reported type E, call ROLLBACK_ENTITIES and raise
  "ZCX_IA_2_SHIFT_RELEASE. Do not silently RETURN.

ENDMETHOD.
