*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* IMPORTING IV_NOTIFICATION TYPE QMNUM
* CHANGING  CT_RETURN       TYPE BAPIRET2_T
*---------------------------------------------------------------------*
METHOD update_shift_notification_priority.

  DATA(lt_bapi_return) = VALUE bapiret2_t( ).

  CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
    EXPORTING
      number        = CONV bapi2080_nothdre-notif_no( iv_notification )
      notifheader   = VALUE bapi2080_nothdri( priority = 3 )
      notifheader_x = VALUE bapi2080_nothdri_x( priority = abap_true )
    TABLES
      return        = lt_bapi_return.

  APPEND LINES OF lt_bapi_return TO ct_return.

  IF bapi_has_errors( lt_bapi_return ) = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDIF.

  CLEAR lt_bapi_return.

  CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
    EXPORTING
      number = CONV bapi2080_nothdre-notif_no( iv_notification )
    TABLES
      return = lt_bapi_return.

  APPEND LINES OF lt_bapi_return TO ct_return.

  IF bapi_has_errors( lt_bapi_return ) = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDMETHOD.
