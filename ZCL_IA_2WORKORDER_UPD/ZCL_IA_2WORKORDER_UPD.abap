class ZCL_IA_2WORKORDER_UPD definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_UPDATE .

  methods DELETE_DATA_FROM_DB
    importing
      !IV_AUFNR type AUFNR
      !IV_OBJNR type J_OBJNR .
  methods CHECK_DELETION_FLAG
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
      !IV_ITERATION type I
    exporting
      !EV_DELETE type CHAR1 .
  methods GET_LINEAR_FIELDS_DATA
    importing
      !IV_AUFNR type AUFNR
    exporting
      !ES_CUST type EAML_S_LFE_FIELDS_UI
      !ES_EAML_D_LFE_DATA type EAML_D_LFE_DATA .
  methods CHECK_BLOCKING_SECTIONS
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_EAML_D_LFE_DATA type EAML_D_LFE_DATA
    exporting
      !EV_501 type CHAR1
      !EV_502 type CHAR1
      !EV_506 type CHAR1
      !EV_508 type CHAR1 .
  methods CHECK_KMS_AND_MILEAGE
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IV_ZSTDKZ type ZIA_2DI_ORDERS-ZSTDKZ
    exporting
      !EV_505 type CHAR1
      !EV_511 type CHAR1 .
  methods UPDATE_ZUGANGSART
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
      !IV_ZSTDKZ type ZIA_2DI_ORDERS-ZSTDKZ .
  methods CHECK_CONDITIONS1
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
      !IV_ZSTDKZ type ZIA_2DI_ORDERS-ZSTDKZ
      !IV_ZLAGE type ZIA_2DI_ORDERS-ZLAGE
      !IV_ZDIDOK type ZIA_2DI_ORDERS-ZDIDOK
    exporting
      !EV_510 type CHAR1
      !EV_512 type CHAR1
      !EV_507 type CHAR1
      !EV_503 type CHAR1
      !EV_180 type CHAR1
      !EV_504 type CHAR1
      !EV_DLZ type DAUNOR .
  methods UPDATE_TIME_AND_CAPACITIES
    importing
      !IV_AUFNR type AUFNR
      !IV_INTERVAL_TYPE type ZIA_1_INTERVALTYPE .
  methods CHECK_LATERAL_TUBES_AND_SHIFT
    importing
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
    exporting
      !EV_SHIFT_EXISTS type CHAR1
      !EV_504 type CHAR1
      !EV_530 type CHAR1 .
  methods SELECT_ERROR_MESSAGE
    importing
      !IV_501 type CHAR1
      !IV_502 type CHAR1
      !IV_503 type CHAR1
      !IV_504 type CHAR1
      !IV_505 type CHAR1
      !IV_506 type CHAR1
      !IV_507 type CHAR1
      !IV_508 type CHAR1
      !IV_510 type CHAR1
      !IV_511 type CHAR1
      !IV_512 type CHAR1
    exporting
      !EV_MESSAGE type T100-TEXT .
  methods EXECUTE_FINAL_DELETION
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
      !IV_ITERATION type I
      !IV_DELETE type CHAR1 .
  methods CHECK_SHIFT_RULES
    importing
      !IS_CUST type EAML_S_LFE_FIELDS_UI
      !IS_EAML_D_LFE_DATA type EAML_D_LFE_DATA
    exporting
      !EV_013 type CHAR1
      !EV_SHIFT_RULE type ZSE_2_VALUE .
  methods CHANGE_REAL_REAG_STATUS
    importing
      !IV_OBJNR type J_OBJNR .
  methods CALCULATE_START_END_TIME
    importing
      !IV_GSTRP type PM_ORDGSTRP
      !IV_GSUZP type CO_GSUZP
      !IV_GLTRP type CO_GLTRP
      !IV_GLUZP type CO_GLUZP
    exporting
      !EV_START_ZEIT type ZIA_2_ZEIT_DIFF_START
      !EV_END_ZEIT type ZIA_2_ZEIT_DIFF_ENDE .
  methods POPULATE_ZQUALI_ZDISPO_TABLE
    importing
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG .
  methods POPULATE_LS_ZIA_2DI_ORDERS
    importing
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
      !IS_CUST type EAML_S_LFE_FIELDS_UI
    exporting
      !ES_ZIA_2DI_ORDERS type ZIA_2DI_ORDERS .
  methods CHECK_RETURN_CONDITIONS
    importing
      !IS_HEADER_DIALOG type COBAI_S_HEADER_DIALOG
    exporting
      !EV_RETURN type CHAR1 .
private section.
ENDCLASS.



CLASS ZCL_IA_2WORKORDER_UPD IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CALCULATE_START_END_TIME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GSTRP                       TYPE        PM_ORDGSTRP
* | [--->] IV_GSUZP                       TYPE        CO_GSUZP
* | [--->] IV_GLTRP                       TYPE        CO_GLTRP
* | [--->] IV_GLUZP                       TYPE        CO_GLUZP
* | [<---] EV_START_ZEIT                  TYPE        ZIA_2_ZEIT_DIFF_START
* | [<---] EV_END_ZEIT                    TYPE        ZIA_2_ZEIT_DIFF_ENDE
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD calculate_start_end_time.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       09.05.2025     tcs / Roshan W
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

  DATA : lv_diff            TYPE i.
  "ZeitstempelBerechnen:
  CALL FUNCTION 'CCU_TIMESTAMP_DIFFERENCE'
    EXPORTING
      timestamp1 = CONV tzntimestp( |{ iv_gstrp }{ iv_gsuzp }| )
      timestamp2 = CONV tzntimestp( '20000101000000' )
    IMPORTING
      difference = lv_diff.
  ev_start_zeit = lv_diff.
  CLEAR lv_diff.
  CALL FUNCTION 'CCU_TIMESTAMP_DIFFERENCE'
    EXPORTING
      timestamp1 = CONV tzntimestp( |{ iv_gltrp }{ iv_gluzp }| )
      timestamp2 = CONV tzntimestp( '20000101000000' )
    IMPORTING
      difference = lv_diff.
  ev_end_zeit = lv_diff.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHANGE_REAL_REAG_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OBJNR                       TYPE        J_OBJNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD change_real_reag_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       09.05.2025     tcs / Roshan W
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

*to set the status as REAL.

  DATA : lv_objnr         TYPE jsto-objnr,
         lv_txt04         TYPE tj02t-txt04,
         lv_status_number TYPE jest-stat.

  lv_objnr = iv_objnr.
  lv_txt04 = 'REAL'.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
    EXPORTING
      language           = sy-langu
      mode               = 'E'
      objnr              = lv_objnr
      txt04              = lv_txt04
    IMPORTING
      status_number      = lv_status_number
    EXCEPTIONS
      insufficient_input = 1
      not_found          = 2
      object_not_found   = 3
      wrong_mode         = 4
      OTHERS             = 5.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
    EXPORTING
      objnr       = iv_objnr "is_header_dialog-objnr
      user_status = lv_status_number "'E0007'
      set_inact   = 'X'.


*to set the status as REAG.
  CLEAR : lv_status_number.
  lv_txt04 = 'REAG'.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
    EXPORTING
      language           = sy-langu
      mode               = 'E'
      objnr              = lv_objnr
      txt04              = lv_txt04
    IMPORTING
      status_number      = lv_status_number
    EXCEPTIONS
      insufficient_input = 1
      not_found          = 2
      object_not_found   = 3
      wrong_mode         = 4
      OTHERS             = 5.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN' "#EC CI_SUBRC
    EXPORTING
      objnr       = iv_objnr "is_header_dialog-objnr
      user_status = lv_status_number "'E0003'
      set_inact   = ' '.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_BLOCKING_SECTIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_EAML_D_LFE_DATA             TYPE        EAML_D_LFE_DATA
* | [<---] EV_501                         TYPE        CHAR1
* | [<---] EV_502                         TYPE        CHAR1
* | [<---] EV_506                         TYPE        CHAR1
* | [<---] EV_508                         TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_blocking_sections.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*         BESCHREIBUNG / DESCRIPTION
*----------------------------------------------------------------------*
* >000<   7.50       09.12.2025       TCS / ROSHAN WADHWANI (E564128)
*    DESCRIPTION : TO CHECK BLOCKING SECTIONS
*----------------------------------------------------------------------*

    TYPES : BEGIN OF ts_code,
              code TYPE qpcd-code,
            END OF ts_code.

    DATA : lv_count      TYPE i,
           lv_z_section  TYPE eaml_d_lfe_data-z_section,
           lt_z_section  TYPE STANDARD TABLE OF  eaml_d_lfe_data-z_section,
           lv_codegruppe TYPE qpcd-codegruppe,
           lt_code       TYPE STANDARD TABLE OF ts_code,
##NEEDED           ls_code       TYPE ts_code.

    IF is_cust-z_perimeter = 'GBT'.
      lv_codegruppe = 'N-REALG'.
    ENDIF.

    IF is_cust-z_perimeter = 'CBT'.
      lv_codegruppe = 'N-REALC'.
    ENDIF.


*MOVING BLOCKING SECTIONS INTO TABLE.
    SPLIT is_cust-z_section AT ',' INTO TABLE lt_z_section.
    CLEAR lv_count.
    LOOP AT lt_z_section INTO lv_z_section WHERE table_line = 'E' OR table_line = 'E1' OR table_line = 'E2'
                                              OR table_line = 'E3' OR table_line = 'W' OR table_line = 'W1'
                                              OR table_line = 'W2' OR table_line = 'W3' OR table_line =  'X'.

      lv_count = lv_count + 1.


    ENDLOOP.

    IF lv_count GE 2.
*      MESSAGE E501(ZIA_2_REAL) RAISING ERROR_WITH_MESSAGE. "#EC NON_CL_EXCEPT
      ev_501 = 'X'.
    ENDIF.

*          CHECKING IF THE BLOCKING SECTION ARE CORRECT.
    SELECT code
      FROM qpcd
      WHERE katalogart = '8'
       AND codegruppe = @lv_codegruppe
       AND inaktiv IS INITIAL
      INTO TABLE @lt_code.

    IF sy-subrc = 0.

      LOOP AT lt_z_section INTO lv_z_section.

        ##WARN_OK READ TABLE lt_code INTO ls_code WITH KEY code = lv_z_section.
        IF sy-subrc NE 0.
*        MESSAGE E502(ZIA_2_REAL) RAISING ERROR_WITH_MESSAGE. "#EC NON_CL_EXCEPT
          ev_502 = 'X'.
        ENDIF.

      ENDLOOP.
    ELSE.
      ev_502 = 'X'.
    ENDIF.
    IF is_cust-z_interval EQ 'TS' ."OR is_eaml_d_lfe_data-z_interval  EQ 'TS'.
      LOOP AT lt_z_section INTO lv_z_section.

        IF lv_z_section(1) = 'E' OR lv_z_section(1) = 'W' . "#EC EMPTY_IF_BRANCH
          CHECK sy-subrc = 0.
        ELSE.

*          MESSAGE E506(ZIA_2_REAL) RAISING ERROR_WITH_MESSAGE. "#EC NON_CL_EXCEPT
          ev_506 = 'X'.
        ENDIF.

      ENDLOOP.

    ENDIF.

    IF is_cust-z_perimeter IS NOT INITIAL "AND IS_EAML_D_LFE_DATA-Z_PERIMETER IS NOT INITIAL
      AND is_cust-z_section IS NOT INITIAL "AND IS_EAML_D_LFE_DATA-Z_SECTION IS NOT INITIAL
      AND is_cust-z_interval IS NOT INITIAL ."AND IS_EAML_D_LFE_DATA-Z_INTERVAL IS NOT INITIAL.

      IF  is_cust-km_from IS  INITIAL "AND IS_EAML_D_LFE_DATA-KM_FROM IS INITIAL
       AND  is_cust-km_to IS INITIAL ."AND IS_EAML_D_LFE_DATA-KM_TO IS INITIAL.

        ev_508 = 'X'.

      ENDIF.


    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_CONDITIONS1
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IV_ZSTDKZ                      TYPE        ZIA_2DI_ORDERS-ZSTDKZ
* | [--->] IV_ZLAGE                       TYPE        ZIA_2DI_ORDERS-ZLAGE
* | [--->] IV_ZDIDOK                      TYPE        ZIA_2DI_ORDERS-ZDIDOK
* | [<---] EV_510                         TYPE        CHAR1
* | [<---] EV_512                         TYPE        CHAR1
* | [<---] EV_507                         TYPE        CHAR1
* | [<---] EV_503                         TYPE        CHAR1
* | [<---] EV_180                         TYPE        CHAR1
* | [<---] EV_504                         TYPE        CHAR1
* | [<---] EV_DLZ                         TYPE        DAUNOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_conditions1.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to check various conditions.

*----------------------------------------------------------------------*


    IF iv_zstdkz = 'M'.
*      ##WARN_OK SELECT SINGLE *
*              FROM zia_2mfs
*              INTO @DATA(ls_zia_2mfs)
*             WHERE zmfs = @iv_zdidok.
*      IF is_cust-km_from >= ls_zia_2mfs-zkm_mfs_von AND is_cust-km_from <= ls_zia_2mfs-zkm_mfs_bis.
*        CHECK sy-subrc = 0.
*      ELSE.
**        message e510(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
*        ev_510 = 'X'.
*      ENDIF.


      ##NEEDED      ##WARN_OK SELECT SINGLE *
                    FROM zia_2mfs
                    INTO @DATA(ls_zia_2mfs)
                   WHERE zmfs = @iv_zdidok
                     AND zkm_mfs_von <= @is_cust-km_from
                     AND zkm_mfs_bis >= @is_cust-km_from.
      IF sy-subrc NE 0.
        ev_510 = 'X'.
      ENDIF.
    ENDIF.

    "*******************
    "* Check if DLZ is relevant for real
    "***************
    zcl_ia_2order=>get_glz( EXPORTING is_caufvd   = is_header_dialog "ls_caufvd
             IMPORTING ev_dlz      = ev_dlz
                       ev_max_diff = DATA(lv_max_diff) ).

    IF ev_dlz = 0.
*      message e512(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
      ev_512 = 'X'.
    ENDIF.
    IF ev_dlz GT lv_max_diff.
*      message e507(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
      ev_507 = 'X'.
    ENDIF.


    IF iv_zstdkz EQ 'Q'.
      IF is_cust-km_from NE is_cust-km_to.
*        message e503(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT3
        ev_503 = 'X'.
      ENDIF.


      ##NEEDED      ##WARN_OK      SELECT SINGLE zqs
                    INTO @DATA(lv_zqs)
                    FROM zia_2lateral_tb
                   WHERE zkm_e = @is_cust-km_from
                     AND zzperi = @is_cust-z_perimeter.
      IF sy-subrc NE 0.
*        message e504(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
        ev_504 = 'X'.
      ENDIF.

      DATA: ls_quer    TYPE zia_2lateral_tb,
            lv_success TYPE char1.

      ##WARN_OK      SELECT SINGLE * INTO ls_quer
             FROM zia_2lateral_tb
             WHERE zkm_e = is_cust-km_to
               AND zzperi = is_cust-z_perimeter.

      IF sy-subrc = 0.
        IF ls_quer-zqs CS iv_zlage.
          lv_success = abap_true.
        ENDIF.

        IF lv_success = abap_false.
          ev_180 = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_DELETION_FLAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IV_ITERATION                   TYPE        I
* | [<---] EV_DELETE                      TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_deletion_flag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to populate deletion flag
*----------------------------------------------------------------------*
    IF iv_iteration = 1.

      CLEAR ev_delete.

      ev_delete = COND #( WHEN is_cust-z_interval NE 'TI' THEN 'X' ELSE ' ' ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_header_dialog-asttx CS 'REAG' THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_zugangsart NE '2' THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_perimeter IS INITIAL THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_eiz IS INITIAL THEN 'X' ELSE ' ' ) ELSE ev_delete ).

    ENDIF.

    IF iv_iteration = 2.

      CLEAR ev_delete.

      ev_delete = COND #( WHEN is_cust-z_interval NE 'TI' THEN 'X' ELSE ' ' ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_header_dialog-asttx NS 'REAG' THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_zugangsart NE '2' THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_perimeter IS INITIAL THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      ev_delete = COND #( WHEN ev_delete IS INITIAL THEN COND #( WHEN is_cust-z_eiz IS INITIAL THEN 'X' ELSE ' ' ) ELSE ev_delete ).

      IF is_cust-z_section IS INITIAL.
        ev_delete = 'X'.
      ENDIF.
    ENDIF.

    IF iv_iteration = 3.

      CLEAR ev_delete.

      ev_delete = COND #( WHEN is_header_dialog-asttx CS 'REAG' THEN 'X' ELSE ' ' ).

      IF ev_delete = 'X'. "this if condition is kept to make sure both the above and below conditions are met.
        TYPES : BEGIN OF ts_zia_2order,
                  zschicht TYPE zia_2order-zschicht,
                  zarbstl  TYPE zia_2order-zarbstl,
                END OF ts_zia_2order.

        DATA ls_zia_2order_temp TYPE ts_zia_2order.

        SELECT SINGLE zschicht,
                      zarbstl
                 FROM zia_2order
                 INTO @ls_zia_2order_temp
                WHERE aufnr = @is_header_dialog-aufnr.
        IF ls_zia_2order_temp-zschicht  IS INITIAL AND ls_zia_2order_temp-zarbstl IS INITIAL .
          ev_delete = 'X'.
        ELSE.
          CLEAR ev_delete.
        ENDIF.

      ENDIF.

      IF is_cust-z_section IS INITIAL.
        ev_delete = 'X'.
      ENDIF.

    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_KMS_AND_MILEAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IV_ZSTDKZ                      TYPE        ZIA_2DI_ORDERS-ZSTDKZ
* | [<---] EV_505                         TYPE        CHAR1
* | [<---] EV_511                         TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_kms_and_mileage.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to populate deletion flag
*----------------------------------------------------------------------*
* >001<   7.50       17.04.2026       TCS / Roshan Wadhwani (E564128)
*    Description : Method to populate deletion flag
*----------------------------------------------------------------------*
* >002<   7.50       dd.mm.yyyy      Company Name/ Developer
*    Description :
*----------------------------------------------------------------------*

    DATA : lv_z_section TYPE eaml_d_lfe_data-z_section,
           lt_z_section TYPE STANDARD TABLE OF  eaml_d_lfe_data-z_section.



*Moving blocking sections into table.
    SPLIT is_cust-z_section AT ',' INTO TABLE lt_z_section.

    IF iv_zstdkz NE 'G' AND iv_zstdkz NE 'M'. " Added M here on 17.04.2026.
      IF is_cust-km_from GT is_cust-km_to.
*              message e505(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
        ev_505 = 'X'.
      ENDIF.

      DATA : lt_sec TYPE RANGE OF eaml_d_lfe_data-z_section.

      LOOP AT lt_z_section INTO lv_z_section.
        IF iv_zstdkz  EQ 'Q'.
          APPEND INITIAL LINE TO lt_sec ASSIGNING FIELD-SYMBOL(<ls_sec>).
          <ls_sec>-option = 'EQ'.
          <ls_sec>-sign = 'I'.
          <ls_sec>-low  = COND #( WHEN lv_z_section = 'E'  OR
                                            lv_z_section = 'W'  OR
                                            lv_z_section = 'X'
                                       THEN 'E'
                                       WHEN lv_z_section = 'E1' OR
                                            lv_z_section = 'W1'
                                       THEN 'E1'
                                       WHEN lv_z_section = 'E2' OR
                                            lv_z_section = 'W2'
                                       THEN 'E2'
                                       WHEN lv_z_section = 'E3' OR
                                            lv_z_section = 'W3'
                                       THEN 'E3'
                                       ELSE 'E' ).

        ELSE.
          APPEND INITIAL LINE TO lt_sec ASSIGNING <ls_sec>.
          <ls_sec>-option = 'EQ'.
          <ls_sec>-sign = 'I'.
          <ls_sec>-low  = lv_z_section.

        ENDIF.

      ENDLOOP.
      SELECT COUNT( * ) AS anzahl
        FROM zia_2sc INTO @DATA(lv_sa_anzahl)
        WHERE zzperi = @is_cust-z_perimeter
          AND zest IN @lt_sec
          AND km_von <= @is_cust-km_to
          AND km_bis >= @is_cust-km_from.

      DATA(lv_sa_kilometer) = COND #( WHEN lv_sa_anzahl >= 1 THEN abap_true ELSE abap_false ).
      IF lv_sa_kilometer IS INITIAL.
*              message e511(zia_2_real) raising error_with_message. "#EC NON_CL_EXCEPT
        ev_511 = 'X'.
      ENDIF.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_LATERAL_TUBES_AND_SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [<---] EV_SHIFT_EXISTS                TYPE        CHAR1
* | [<---] EV_504                         TYPE        CHAR1
* | [<---] EV_530                         TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_lateral_tubes_and_shift.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to check lateral tubes and Shift existance
*----------------------------------------------------------------------*
* TYPES : BEGIN OF ts_zia_2order,
*                  zschicht TYPE zia_2order-zschicht,
*                  zarbstl  TYPE zia_2order-zarbstl,
*                END OF ts_zia_2order.

    DATA ls_zia_2order_temp TYPE zia_2order.

    SELECT SINGLE *
      FROM zia_2order
      INTO @ls_zia_2order_temp
     WHERE aufnr = @is_header_dialog-aufnr.

    TYPES : BEGIN OF ts_afko,
              gstrp TYPE afko-gstrp , "Basic start date
              gsuzp TYPE afko-gsuzp , "Basic start (Time)
              gltrp TYPE afko-gltrp , "Basic finish date
              gluzp TYPE afko-gluzp  , "Basic Finish (Time)
            END OF ts_afko.
    DATA ls_afko TYPE ts_afko.
*To check whether the order exists in any shift.
    SELECT SINGLE
        plannedstartdate,   "GSTRP, "BASIC START DATE
        plannedstarttime,   "GSUZP, "BASIC START (TIME)
        plannedenddate,   "GLTRP, "BASIC FINISH DATE
        plannedendtime   "GLUZP "BASIC FINISH (TIME)
      FROM i_logisticsorder "afko
      INTO @ls_afko
     WHERE orderid = @is_header_dialog-aufnr.


    DATA : ls_data_old1 TYPE eaml_d_lfe_cdoc,
           ls_data_new1 TYPE eaml_d_lfe_cdoc,
           lv_obart1    TYPE eaml_obart VALUE 'OR'.
*                 lv_shift_exists TYPE char1.


*to get the present linear fields.
    CALL METHOD cl_eaml_data_handler=>get_data_for_cdoc
      EXPORTING
        iv_obart    = lv_obart1
        iv_key1     = is_header_dialog-aufnr
      IMPORTING
        es_data_new = ls_data_new1
        es_data_old = ls_data_old1.

    IF ls_afko-gstrp NE is_header_dialog-gstrp "Basic start date
      OR ls_afko-gsuzp NE is_header_dialog-gsuzp "Basic start (Time)
      OR ls_afko-gltrp NE is_header_dialog-gltrp "Basic finish date
      OR ls_afko-gluzp  NE is_header_dialog-gluzp "Basic Finish (Time)
      OR  ls_data_old1 NE ls_data_new1. " Linear Fields

      ##NEEDED      SELECT SINGLE *
              FROM zia_2order_bup
              INTO @DATA(ls_zia_2order_bup)
             WHERE aufnr = @is_header_dialog-aufnr.

      IF sy-subrc = 0.
        ev_shift_exists = 'X'.
*              MESSAGE w504(zia_2_real) RAISING error_with_message. "#EC NON_CL_EXCEPT
        ev_530 = 'X'.
      ELSE.

        IF ls_zia_2order_temp-zschicht  IS INITIAL AND ls_zia_2order_temp-zarbstl IS INITIAL . "#EC EMPTY_IF_BRANCH
          CHECK sy-subrc = 0.
        ELSE.
          ev_shift_exists = 'X'.

        ENDIF.


      ENDIF.



    ENDIF.

*    the below code is to check whether the shift and workarea already exists.

    IF ls_zia_2order_temp IS NOT INITIAL .
      IF ls_zia_2order_temp-zschicht  IS NOT INITIAL AND ls_zia_2order_temp-zarbstl IS NOT INITIAL .
        ev_shift_exists = 'X'.
        ev_530 = 'X'.
      ENDIF.
    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_RETURN_CONDITIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [<---] EV_RETURN                      TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD check_return_conditions.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       09.05.2025     tcs / Roshan W
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  CLEAR ev_return.
  IF syst-tcode = 'IW38'. " this is done so that MASS Changes executes properly.
    ev_return = 'X'.
  ENDIF.
  IF is_header_dialog-auart = 'N010'. " Temporary adjustment for Maurice.
    ev_return = 'X'.
  ENDIF.
  IF is_header_dialog-iphas NE 2.
    ev_return = 'X'.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->CHECK_SHIFT_RULES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_EAML_D_LFE_DATA             TYPE        EAML_D_LFE_DATA
* | [<---] EV_013                         TYPE        CHAR1
* | [<---] EV_SHIFT_RULE                  TYPE        ZSE_2_VALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_shift_rules.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       09.12.2025       TCS / Roshan Wadhwani (E564128)
*    Description : To check Blocking Sections
*----------------------------------------------------------------------*


    CONSTANTS : lc_e           TYPE char1 VALUE 'E',
                lc_w           TYPE char1 VALUE 'W',
                lc_x           TYPE char1 VALUE 'X',
                lc_application TYPE zse_2_params_dep-application VALUE 'ZIA_2_REAL',
                lc_name        TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE',
                lc_e1          TYPE char2 VALUE 'E1',
                lc_e3          TYPE char2 VALUE 'E3',
                lc_w1          TYPE char2 VALUE 'W1',
                lc_w3          TYPE char2 VALUE 'W3',
                lc_name1       TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE_SP1',
                lc_name2       TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE_SP2',
                lc_name3       TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE_SP3',
                lc_name4       TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE_SP4',
                lc_name5       TYPE zse_2_params_dep-name VALUE 'SHIFT_RULE_SP5'.

    ##NEEDED    DATA : lv_z_section        TYPE eaml_d_lfe_data-z_section,
               lt_z_section        TYPE STANDARD TABLE OF  eaml_d_lfe_data-z_section,
               ls_zse_2_params_dep TYPE zse_2_params_dep.

*Moving blocking sections into table.
    SPLIT is_cust-z_section AT ',' INTO TABLE lt_z_section.



* get the parameter table values
    SELECT *
      FROM zse_2_params_dep
     WHERE application = @lc_application
       AND inactive_flag IS INITIAL
      INTO TABLE @DATA(lt_zse_2_params_dep).



    LOOP AT lt_zse_2_params_dep INTO ls_zse_2_params_dep WHERE name(10) EQ lc_name.

      CASE ls_zse_2_params_dep-name.

*    shift_rule_sp1
        WHEN lc_name1.

          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_e1.
          CHECK sy-subrc = 0.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_e3.
          IF sy-subrc = 0.
            ev_013 = 'X'.
            ev_shift_rule = ls_zse_2_params_dep-value.
            EXIT.
          ENDIF.

*    shift_rule_sp2
        WHEN lc_name2.

          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_w1.
          CHECK sy-subrc = 0.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_w3.
          IF sy-subrc = 0.
            ev_013 = 'X'.
            ev_shift_rule = ls_zse_2_params_dep-value.
            EXIT.
          ENDIF.


*    shift_rule_sp3
        WHEN lc_name3.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_e.
          CHECK sy-subrc = 0.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_w.
          IF sy-subrc = 0.
            ev_013 = 'X'.
            ev_shift_rule = ls_zse_2_params_dep-value.
            EXIT.
          ENDIF.

*    shift_rule_sp4
        WHEN lc_name4.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_e.
          CHECK sy-subrc = 0.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_x.
          IF sy-subrc = 0.
            ev_013 = 'X'.
            ev_shift_rule = ls_zse_2_params_dep-value.
            EXIT.
          ENDIF.

*    shift_rule_sp5
        WHEN lc_name5.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_w.
          CHECK sy-subrc = 0.
          READ TABLE lt_z_section INTO lv_z_section WITH KEY table_line = lc_x.
          IF sy-subrc = 0.
            ev_013 = 'X'.
            ev_shift_rule = ls_zse_2_params_dep-value.
            EXIT.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->DELETE_DATA_FROM_DB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [--->] IV_OBJNR                       TYPE        J_OBJNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_data_from_db.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to delete records from Z tables
*----------------------------------------------------------------------*
    DATA : ls_zia_2di_orders TYPE zia_2di_orders,
           lt_quali          TYPE STANDARD TABLE OF zia_2di_qualis,
           lt_dispo          TYPE STANDARD TABLE OF zia_2di_dispo.


    SELECT SINGLE *
      INTO ls_zia_2di_orders
      FROM zia_2di_orders
     WHERE aufnr = iv_aufnr."is_header_dialog-aufnr.
    IF sy-subrc = 0.
      DELETE zia_2di_orders FROM ls_zia_2di_orders.
      COMMIT WORK.

    ENDIF.

    SELECT *
      INTO TABLE lt_quali
      FROM zia_2di_qualis
     WHERE aufnr = iv_aufnr."is_header_dialog-aufnr.       "#EC CI_NO_TRANSFORM
    IF sy-subrc = 0.
      DELETE zia_2di_qualis FROM TABLE lt_quali.
      ##SUBRC_AFTER_COMMIT      COMMIT WORK.
    ENDIF.


    IF sy-subrc = 0.

      SELECT *
        INTO TABLE lt_dispo
        FROM zia_2di_dispo
        FOR ALL ENTRIES IN lt_quali
       WHERE zid_quali = lt_quali-zid_quali.       "#EC CI_NO_TRANSFORM
      IF sy-subrc = 0.
        DELETE zia_2di_dispo FROM TABLE lt_dispo.
        COMMIT WORK.
      ENDIF.


    ENDIF.

    DATA : ls_zia_2order TYPE zia_2order,
           lt_cap        TYPE STANDARD TABLE OF zia_2order_cap,
           lt_tim        TYPE STANDARD TABLE OF zia_2order_tim.
    SELECT SINGLE *
          INTO ls_zia_2order
          FROM zia_2order
         WHERE aufnr = iv_aufnr."is_header_dialog-aufnr.
    IF sy-subrc = 0.
      DELETE zia_2order FROM ls_zia_2order.
      COMMIT WORK.

    ENDIF.

    SELECT *
      INTO TABLE lt_cap
      FROM zia_2order_cap
     WHERE aufnr = iv_aufnr."is_header_dialog-aufnr.       "#EC CI_NO_TRANSFORM
    IF sy-subrc = 0.
      DELETE zia_2order_cap FROM TABLE lt_cap.
      COMMIT WORK.
    ENDIF.



    SELECT *
      INTO TABLE lt_tim
      FROM zia_2order_tim
     WHERE aufnr = iv_aufnr."is_header_dialog-aufnr.       "#EC CI_NO_TRANSFORM
    IF sy-subrc = 0.
      DELETE zia_2order_tim FROM TABLE lt_tim.
      COMMIT WORK.
    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->EXECUTE_FINAL_DELETION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IV_ITERATION                   TYPE        I
* | [--->] IV_DELETE                      TYPE        CHAR1
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD execute_final_deletion.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : execute final deletion if any
*----------------------------------------------------------------------*
    DATA : lv_delete TYPE char1.
    IF iv_delete IS INITIAL.

      check_deletion_flag( EXPORTING is_cust = is_cust
                                    is_header_dialog = is_header_dialog
                                    iv_iteration = 2
                           IMPORTING ev_delete = lv_delete ).

    ENDIF.

    IF lv_delete = 'X'.

      delete_data_from_db( EXPORTING iv_aufnr = is_header_dialog-aufnr
                                     iv_objnr = is_header_dialog-objnr ).

*to set the status as REAL.

      DATA : lv_objnr         TYPE jsto-objnr,
             lv_txt04         TYPE tj02t-txt04,
             lv_status_number TYPE jest-stat.

      lv_objnr = is_header_dialog-objnr.
      lv_txt04 = 'REAL'.

      CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
        EXPORTING
          language           = sy-langu
          mode               = 'E'
          objnr              = lv_objnr
          txt04              = lv_txt04
        IMPORTING
          status_number      = lv_status_number
        EXCEPTIONS
          insufficient_input = 1
          not_found          = 2
          object_not_found   = 3
          wrong_mode         = 4
          OTHERS             = 5.

      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN'
        EXPORTING
          objnr       = is_header_dialog-objnr
          user_status = lv_status_number "'E0007'
          set_inact   = 'X'.


*to set the status as REAG.
      CLEAR lv_status_number.
      lv_txt04 = 'REAG'.

      CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
        EXPORTING
          language           = sy-langu
          mode               = 'E'
          objnr              = lv_objnr
          txt04              = lv_txt04
        IMPORTING
          status_number      = lv_status_number
        EXCEPTIONS
          insufficient_input = 1
          not_found          = 2
          object_not_found   = 3
          wrong_mode         = 4
          OTHERS             = 5.

      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN'
        EXPORTING
          objnr       = is_header_dialog-objnr
          user_status = lv_status_number "'E0003'
          set_inact   = ' '.

      RETURN.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->GET_LINEAR_FIELDS_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<---] ES_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [<---] ES_EAML_D_LFE_DATA             TYPE        EAML_D_LFE_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_linear_fields_data.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to populate deletion flag
*----------------------------------------------------------------------*


    ##NEEDED    DATA : ls_data_old TYPE eaml_d_lfe_cdoc,
               ls_data_new TYPE eaml_d_lfe_cdoc,
               lv_obart    TYPE eaml_obart VALUE 'OR'.


*to get the present linear fields.
    CALL METHOD cl_eaml_data_handler=>get_data_for_cdoc
      EXPORTING
        iv_obart    = lv_obart
        iv_key1     = iv_aufnr
      IMPORTING
        es_data_new = ls_data_new
        es_data_old = ls_data_old.

    ##ENH_OK    MOVE-CORRESPONDING ls_data_new TO es_cust.



*      TO GET THE database LINEAR DATA ( Z FIELDS )
    SELECT SINGLE *
      FROM eaml_d_lfe_data
      INTO es_eaml_d_lfe_data
      WHERE obart  EQ 'OR'
        AND tabkey EQ iv_aufnr.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~ARCHIVE_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AUFNR                        TYPE        CAUFVD-AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~archive_objects.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~AT_DELETION_FROM_DATABASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_AUFK                        TYPE        TABLE
* | [--->] IT_AUTYP                       TYPE        AUFK-AUTYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~at_deletion_from_database.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~AT_RELEASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AKTYP                        TYPE        RC27S-AKTYP
* | [--->] I_NO_DIALOG                    TYPE        C (default =SPACE)
* | [--->] I_FLG_COL_RELEASE              TYPE        C (default =SPACE)
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [EXC!] FREE_FAILED_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~at_release.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~AT_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [EXC!] ERROR_WITH_MESSAGE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_ex_workorder_update~at_save.
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------




    "*******************
    "* Data Definition
    "***************

    CONSTANTS : lc_maintordovrlprocsubphase TYPE eam_ostat_sphase     VALUE '0060'.

    DATA :ls_eaml_d_lfe_data TYPE eaml_d_lfe_data,
          ls_zia_2di_orders  TYPE zia_2di_orders,
          ls_zia_2order      TYPE zia_2order,
          ls_cust            TYPE eaml_s_lfe_fields_ui,
##NEEDED          lv_return          TYPE boolean,
          lv_delete          TYPE char1,
          lv_501             TYPE char1,
          lv_502             TYPE char1,
          lv_503             TYPE char1,
          lv_504             TYPE char1,
          lv_505             TYPE char1,
          lv_506             TYPE char1,
          lv_507             TYPE char1,
          lv_508             TYPE char1,
          lv_510             TYPE char1,
          lv_511             TYPE char1,
          lv_512             TYPE char1,
          lv_013             TYPE char1,
          lv_180             TYPE char1,
          lv_530             TYPE char1,
##NEEDED          lv_dlz             TYPE daunor,
          lv_message         TYPE t100-text,
          lv_shift_rule      TYPE zse_2_value,
          lv_shift_exists    TYPE char1,
          lv_return1         TYPE char1.


    check_return_conditions( EXPORTING is_header_dialog = is_header_dialog
                             IMPORTING ev_return = lv_return1 ).
    IF lv_return1 = 'X'.
      RETURN.
    ENDIF.


    CLEAR : ls_eaml_d_lfe_data, ls_zia_2di_orders ,ls_zia_2order ,
            ls_cust ,lv_return ,lv_delete."lv_created."lt_quali , lt_dispo ,

**to get the present linear fields.
*    IF is_header_dialog-aufnr(1) NE '%'.

    get_linear_fields_data( EXPORTING iv_aufnr = is_header_dialog-aufnr
                            IMPORTING es_cust = ls_cust
                                      es_eaml_d_lfe_data = ls_eaml_d_lfe_data ).


*    ENDIF.


*    CLEAR

    IF     ( ls_cust-z_interval  EQ 'TI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TI'
            OR ls_cust-z_interval  EQ 'RI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'RI'
            OR ls_cust-z_interval  EQ 'JI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'JI'
            OR ls_cust-z_interval  EQ 'TS'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TS'
            OR ls_cust-z_interval  EQ 'LI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'LI' )
       AND ( ls_cust-z_perimeter IS NOT INITIAL OR ls_eaml_d_lfe_data-z_perimeter IS NOT INITIAL ).


      populate_ls_zia_2di_orders( EXPORTING is_header_dialog = is_header_dialog
                                            is_cust = ls_cust
                                  IMPORTING es_zia_2di_orders = ls_zia_2di_orders ).

      IF     ( ls_cust-z_interval  EQ 'TI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TI' )
         AND ( ls_cust-z_perimeter IS NOT INITIAL OR ls_eaml_d_lfe_data-z_perimeter IS NOT INITIAL ).

* Setting the sub phase for TI orders ONLY
        ls_zia_2di_orders-maintordovrlprocsubphase = lc_maintordovrlprocsubphase.

        check_deletion_flag( EXPORTING is_cust = ls_cust
                                      is_header_dialog = is_header_dialog
                                      iv_iteration = 1
                             IMPORTING ev_delete = lv_delete ).

        IF lv_delete = 'X'.

          delete_data_from_db( EXPORTING iv_aufnr = is_header_dialog-aufnr
                                         iv_objnr = is_header_dialog-objnr ).

          change_real_reag_status( EXPORTING iv_objnr = is_header_dialog-objnr ).

          RETURN.

        ENDIF.

        IF lv_delete IS INITIAL.
          populate_zquali_zdispo_table( EXPORTING is_header_dialog = is_header_dialog  ).
*                                                  iv_interval_type = ls_cust-z_interval


          MODIFY zia_2di_orders FROM ls_zia_2di_orders.


        ENDIF.
      ENDIF.


      IF     ( ls_cust-z_interval  NE 'TI'        AND ls_eaml_d_lfe_data-z_interval  NE 'TI' )
        AND ( ls_cust-z_perimeter IS NOT INITIAL OR  ls_eaml_d_lfe_data-z_perimeter IS NOT INITIAL ).

        check_deletion_flag( EXPORTING is_cust = ls_cust
                                      is_header_dialog = is_header_dialog
                                      iv_iteration = 3
                             IMPORTING ev_delete = lv_delete ).
        IF lv_delete = 'X'.

          delete_data_from_db( EXPORTING iv_aufnr = is_header_dialog-aufnr
                                         iv_objnr = is_header_dialog-objnr ).



          change_real_reag_status( EXPORTING iv_objnr = is_header_dialog-objnr ).

          RETURN.

        ENDIF.
        IF lv_delete IS INITIAL.


          MOVE-CORRESPONDING ls_zia_2di_orders TO ls_zia_2order.

          ##LITERAL          ls_zia_2order = VALUE #( BASE ls_zia_2order
                                             zzperi  = ls_cust-z_perimeter
                                             matnr = ls_zia_2di_orders-zia_2mo_actprod_ori
                                             zzkmvpl  = ls_cust-km_from
                                             zzkmbpl  = ls_cust-km_to
                                             zzzugangsart  = ls_cust-z_zugangsart
                                             zid_eiz = COND #( WHEN ls_cust-z_eiz = 'GBTN' THEN '10'
                                                               WHEN ls_cust-z_eiz = 'GBTS' THEN '20' )
                                             zpkor = COND #( WHEN is_header_dialog-auart = 'N001' AND is_header_dialog-ilart = 'NA4' THEN '200'
                                                             WHEN is_header_dialog-gstrp = is_header_dialog-gltrp THEN '999'
                                                             ELSE '0' )
                                             zfix = COND #( WHEN ls_zia_2order-zpkor = '999' THEN 'X' ELSE ' ' )
                                             anlzu = is_header_dialog-anlzu
                                             zintervall  = ls_cust-z_interval ).


*Calculate time stamp

          calculate_start_end_time( EXPORTING iv_gstrp = ls_zia_2order-gstrp
                                              iv_gsuzp = ls_zia_2order-gsuzp
                                              iv_gltrp = ls_zia_2order-gltrp
                                              iv_gluzp = ls_zia_2order-gluzp
                                    IMPORTING ev_start_zeit = ls_zia_2order-start_zeit
                                              ev_end_zeit = ls_zia_2order-end_zeit ).



          check_blocking_sections( EXPORTING is_cust = ls_cust
           is_eaml_d_lfe_data = ls_eaml_d_lfe_data
           IMPORTING ev_501 = lv_501
              ev_502 = lv_502
              ev_506 = lv_506
              ev_508 = lv_508 ).

          select_error_message( EXPORTING
                              iv_501 = lv_501
                              iv_502 = lv_502
                              iv_503 = lv_503
                              iv_504 = lv_504
                              iv_505 = lv_505
                              iv_506 = lv_506
                              iv_507 = lv_507
                              iv_508 = lv_508
                              iv_510 = lv_510
                              iv_511 = lv_511
                              iv_512 = lv_512
                              IMPORTING ev_message = lv_message ).

          IF  lv_message IS NOT INITIAL.
            MESSAGE lv_message TYPE 'E' RAISING error_with_message. "#EC NON_CL_EXCEPT
          ENDIF.

          check_shift_rules( EXPORTING is_cust = ls_cust
         is_eaml_d_lfe_data = ls_eaml_d_lfe_data
         IMPORTING ev_013 = lv_013
                   ev_shift_rule = lv_shift_rule  ).

          IF lv_013 = 'X'.
            MESSAGE e013(zia_2_real) WITH lv_shift_rule RAISING error_with_message. "#EC NON_CL_EXCEPT

          ENDIF.

          check_kms_and_mileage( EXPORTING is_cust = ls_cust
            iv_zstdkz = ls_zia_2di_orders-zstdkz
            IMPORTING ev_505 = lv_505
              ev_511 = lv_511 ).


          select_error_message( EXPORTING
                              iv_501 = lv_501
                              iv_502 = lv_502
                              iv_503 = lv_503
                              iv_504 = lv_504
                              iv_505 = lv_505
                              iv_506 = lv_506
                              iv_507 = lv_507
                              iv_508 = lv_508
                              iv_510 = lv_510
                              iv_511 = lv_511
                              iv_512 = lv_512
                              IMPORTING ev_message = lv_message ).

          IF  lv_message IS NOT INITIAL.
            MESSAGE lv_message TYPE 'E' RAISING error_with_message. "#EC NON_CL_EXCEPT
          ENDIF.
          update_zugangsart( EXPORTING is_cust = ls_cust
             is_header_dialog = is_header_dialog
             iv_zstdkz = ls_zia_2di_orders-zstdkz ).

          check_conditions1( EXPORTING is_cust = ls_cust
                is_header_dialog = is_header_dialog
                       iv_zstdkz = ls_zia_2di_orders-zstdkz
                       iv_zdidok = ls_zia_2di_orders-zdidok
                       iv_zlage = ls_zia_2di_orders-zlage
                       IMPORTING ev_510 = lv_510
                         ev_512 = lv_512
                         ev_507 = lv_507
                         ev_503 = lv_503
                         ev_504 = lv_504
                         ev_180 = lv_180
                         ev_dlz = lv_dlz ).

          IF lv_180 = 'X'.
            MESSAGE e180(zia_2_real) WITH is_header_dialog-aufnr ls_zia_2di_orders-zlage RAISING error_with_message. "#EC NON_CL_EXCEPT
          ENDIF.

          select_error_message( EXPORTING
                              iv_501 = lv_501
                              iv_502 = lv_502
                              iv_503 = lv_503
                              iv_504 = lv_504
                              iv_505 = lv_505
                              iv_506 = lv_506
                              iv_507 = lv_507
                              iv_508 = lv_508
                              iv_510 = lv_510
                              iv_511 = lv_511
                              iv_512 = lv_512
                              IMPORTING ev_message = lv_message ).

          IF  lv_message IS NOT INITIAL.
            MESSAGE lv_message TYPE 'E' RAISING error_with_message. "#EC NON_CL_EXCEPT
          ENDIF.


          update_time_and_capacities( EXPORTING iv_aufnr = is_header_dialog-aufnr
                                                iv_interval_type = ls_cust-z_interval ).



          check_lateral_tubes_and_shift( EXPORTING is_header_dialog = is_header_dialog
            IMPORTING ev_shift_exists = lv_shift_exists
              ev_504 = lv_504
              ev_530 = lv_530 ).

          IF lv_530 = 'X'.
            MESSAGE w530(zia_2_real)." RAISING error_with_message. "#EC NON_CL_EXCEPT
          ENDIF.


          IF lv_shift_exists IS INITIAL.

            MODIFY  zia_2order FROM ls_zia_2order .
*            COMMIT WORK
*              CALL FUNCTION 'Z_IA_2_UPD_ZORDER_TABLES' IN UPDATE TASK
**            ##FM_RFC_OK CALL FUNCTION 'Z_IA_2_UPD_ZORDER_TABLES' IN BACKGROUND TASK
**            CALL FUNCTION 'Z_IA_2_UPD_ZORDER_TABLES' DESTINATION 'NONE'
*                EXPORTING
*                  iv_zia_2orders    = 'X'
*                  iv_zia_2di_orders = ' '
*                  is_zia_2order     = ls_zia_2order
*                  is_zia_2di_orders = ' '.



          ENDIF.
          CLEAR lv_shift_exists .
        ENDIF.


      ENDIF.

      RETURN.

    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~BEFORE_UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER                      TYPE        COBAI_T_HEADER(optional)
* | [--->] IT_HEADER_OLD                  TYPE        COBAI_T_HEADER_OLD(optional)
* | [--->] IT_ITEM                        TYPE        COBAI_T_ITEM(optional)
* | [--->] IT_ITEM_OLD                    TYPE        COBAI_T_ITEM_OLD(optional)
* | [--->] IT_SEQUENCE                    TYPE        COBAI_T_SEQUENCE(optional)
* | [--->] IT_SEQUENCE_OLD                TYPE        COBAI_T_SEQUENCE_OLD(optional)
* | [--->] IT_OPERATION                   TYPE        COBAI_T_OPERATION(optional)
* | [--->] IT_OPERATION_OLD_AFVC          TYPE        COBAI_T_OPERATION_OLD_AFVC(optional)
* | [--->] IT_OPERATION_OLD_AFVV          TYPE        COBAI_T_OPERATION_OLD_AFVV(optional)
* | [--->] IT_OPERATION_OLD_AFVU          TYPE        COBAI_T_OPERATION_OLD_AFVU(optional)
* | [--->] IT_COMPONENT                   TYPE        COBAI_T_COMPONENT(optional)
* | [--->] IT_COMPONENT_OLD               TYPE        COBAI_T_COMPONENT_OLD(optional)
* | [--->] IT_RELATIONSHIP                TYPE        COBAI_T_RELATIONSHIP(optional)
* | [--->] IT_RELATIONSHIP_OLD            TYPE        COBAI_T_RELATIONSHIP_OLD(optional)
* | [--->] IT_PSTEXT                      TYPE        COBAI_T_PSTEXT(optional)
* | [--->] IT_PSTEXT_OLD                  TYPE        COBAI_T_PSTEXT_OLD(optional)
* | [--->] IT_MILESTONE                   TYPE        COBAI_T_MILESTONE(optional)
* | [--->] IT_MILESTONE_OLD               TYPE        COBAI_T_MILESTONE_OLD(optional)
* | [--->] IT_PLANNED_ORDER               TYPE        COBAI_T_PLANNED_ORDER(optional)
* | [--->] IT_STATUS                      TYPE        COBAI_T_STATUS(optional)
* | [--->] IT_STATUS_OLD                  TYPE        COBAI_T_STATUS_OLD(optional)
* | [--->] IT_OPR_RELATIONS               TYPE        COBAI_T_OPR_RELATIONS(optional)
* | [--->] IT_OPR_RELATIONS_OLD           TYPE        COBAI_T_OPR_RELATIONS_OLD(optional)
* | [--->] IT_DOCLINK                     TYPE        COBAI_T_DOCLINK(optional)
* | [--->] IT_DOCLINK_OLD                 TYPE        COBAI_T_DOCLINK_OLD(optional)
* | [--->] IT_PRT_ALLOCATION              TYPE        COBAI_T_PRT_ALLOCATION(optional)
* | [--->] IT_PRT_ALLOCATION_OLD          TYPE        COBAI_T_PRT_ALLOCATION_OLD(optional)
* | [--->] IT_PMPARTNER                   TYPE        COBAI_T_PMPARTNER(optional)
* | [--->] IT_PMPARTNER_OLD               TYPE        COBAI_T_PMPARTNER_OLD(optional)
* | [--->] IT_PIINSTRUCTION               TYPE        COBAI_T_PIINSTRUCTION(optional)
* | [--->] IT_PIINSTRUCTIONVALUE          TYPE        COBAI_T_PIINSTRUCTIONVALUE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_ex_workorder_update~before_update.
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       31.05.2025     tcs / Pratima Sahu
*      Programmerstellung / Updating Subphase.
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Updating Subphase.
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------

    CONSTANTS : lc_maintordovrlprocsubphase TYPE eam_ostat_sphase     VALUE '0060'.

    TYPES tt_caufv_int TYPE STANDARD TABLE OF caufvdb.
    FIELD-SYMBOLS <lt_caufv_bt> TYPE tt_caufv_int.
    ##NEEDED    FIELD-SYMBOLS <ls_caufv_bt> TYPE caufvdb.

    DATA(ls_header) = VALUE #( it_header[ 1 ] OPTIONAL ).

*    CHECK ls_header-auart(1) = 'N'.

    DATA ls_eaml_d_lfe_data TYPE eaml_d_lfe_data.
*    DATA ls_custfield       TYPE eaml_s_lfe_fields_ui.
    DATA ls_cust            TYPE eaml_s_lfe_fields_ui.
    DATA : ls_header_old     TYPE cobai_s_header_dialog,
           ls_zia_2di_orders TYPE zia_2di_orders,
           ls_zia_2order     TYPE zia_2order.

    DATA : ls_status TYPE jstat,
           lt_status TYPE tt_jstat.

    ##ENH_OK    MOVE-CORRESPONDING ls_header TO ls_header_old.

    IF syst-tcode = 'IW38'. " this is done so that MASS Changes executes properly.
      SELECT SINGLE *
       FROM zia_2order
      WHERE aufnr = @ls_header-aufnr
        AND zschicht IS INITIAL
        INTO @DATA(ls_order).

      IF sy-subrc = 0.
        DELETE zia_2order FROM ls_order.

*to set the status as REAL.

        DATA : lv_objnr         TYPE jsto-objnr,
               lv_txt04         TYPE tj02t-txt04,
               lv_status_number TYPE jest-stat.

        lv_objnr = ls_header-objnr.
        lv_txt04 = 'REAL'.

        CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
          EXPORTING
            language           = sy-langu
            mode               = 'E'
            objnr              = lv_objnr
            txt04              = lv_txt04
          IMPORTING
            status_number      = lv_status_number
          EXCEPTIONS
            insufficient_input = 1
            not_found          = 2
            object_not_found   = 3
            wrong_mode         = 4
            OTHERS             = 5.

        ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN'
          EXPORTING
            objnr       = ls_header-objnr
            user_status = lv_status_number "'E0007'
            set_inact   = 'X'.
      ENDIF.
      RETURN.
    ENDIF.
**to get the present linear fields.

    get_linear_fields_data( EXPORTING iv_aufnr = ls_header-aufnr
                            IMPORTING es_cust = ls_cust
                                      es_eaml_d_lfe_data = ls_eaml_d_lfe_data ).


    IF ls_header-iphas EQ 2.

*The below check is done to allow only REAL orders to be used
      IF ls_cust-z_perimeter IS NOT INITIAL
        AND ls_cust-z_eiz IS NOT INITIAL
        AND ls_cust-z_zugangsart IS NOT INITIAL
        AND ls_cust-z_interval IS NOT INITIAL
        AND ls_cust-z_section IS NOT INITIAL.
***
        populate_ls_zia_2di_orders( EXPORTING is_header_dialog = ls_header_old
                                              is_cust = ls_cust
                                    IMPORTING es_zia_2di_orders = ls_zia_2di_orders ).

***


        IF     ( ls_cust-z_interval  EQ 'TI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TI' )
           AND ( ls_cust-z_perimeter IS NOT INITIAL OR ls_eaml_d_lfe_data-z_perimeter IS NOT INITIAL )
          AND ( ls_header-maintordovrlprocsubphase LE '0060' ).

***
          ls_zia_2di_orders-maintordovrlprocsubphase = lc_maintordovrlprocsubphase.

***
          ASSIGN ('(SAPLCOBT)CAUFV_BT[]') TO <lt_caufv_bt>. "#EC CI_SUBRC. "Network Buffer

          MODIFY <lt_caufv_bt> FROM VALUE #( maintordovrlprocphase    = '06'
                                             maintordovrlprocsubphase = '0060' )
                 TRANSPORTING maintordovrlprocphase maintordovrlprocsubphase WHERE aufnr EQ ls_header-aufnr.

          ls_status-stat = 'IEAM5'.
          APPEND ls_status TO lt_status.
          CLEAR ls_status.

          DATA(lo_cut) = cl_itob_ustat_functions=>get_instance_class( ).

          lo_cut->if_itob_ustat_functions~status_change_intern(
            EXPORTING
              iv_client = sy-mandt
              iv_objnr  = ls_header-objnr
            CHANGING
              ct_status = lt_status ).



***
          populate_zquali_zdispo_table( EXPORTING is_header_dialog = ls_header_old ).
*                                                  iv_interval_type = ls_cust-z_interval ).
          MODIFY zia_2di_orders FROM ls_zia_2di_orders.

***

        ENDIF.

        IF     ( ls_cust-z_interval  EQ 'TI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TI'
            OR ls_cust-z_interval  EQ 'RI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'RI'
            OR ls_cust-z_interval  EQ 'JI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'JI'
            OR ls_cust-z_interval  EQ 'TS'        OR ls_eaml_d_lfe_data-z_interval  EQ 'TS'
            OR ls_cust-z_interval  EQ 'LI'        OR ls_eaml_d_lfe_data-z_interval  EQ 'LI' )
       AND ( ls_cust-z_perimeter IS NOT INITIAL OR ls_eaml_d_lfe_data-z_perimeter IS NOT INITIAL ).

          IF <lt_caufv_bt> IS NOT ASSIGNED.

            ASSIGN ('(SAPLCOBT)CAUFV_BT[]') TO <lt_caufv_bt>. "#EC CI_SUBRC. "Network Buffer
          ENDIF.
          IF ls_header-asttx CA 'REAL'.

            MODIFY <lt_caufv_bt> FROM VALUE #( terkz     = '5' )
                   TRANSPORTING terkz WHERE aufnr EQ ls_header-aufnr.

          ENDIF.


***
          MOVE-CORRESPONDING ls_zia_2di_orders TO ls_zia_2order.

          ##LITERAL          ls_zia_2order = VALUE #( BASE ls_zia_2order
                                             zzperi  = ls_cust-z_perimeter
                                             matnr = ls_zia_2di_orders-zia_2mo_actprod_ori
                                             zzkmvpl  = ls_cust-km_from
                                             zzkmbpl  = ls_cust-km_to
                                             zzzugangsart  = ls_cust-z_zugangsart
                                             zid_eiz = COND #( WHEN ls_cust-z_eiz = 'GBTN' THEN '10'
                                                               WHEN ls_cust-z_eiz = 'GBTS' THEN '20' )
                                             zpkor = COND #( WHEN ls_header_old-auart = 'N001' AND ls_header_old-ilart = 'NA4' THEN '200'
                                                             WHEN ls_header_old-gstrp = ls_header_old-gltrp THEN '999'
                                                             ELSE '0' )
                                             zfix = COND #( WHEN ls_zia_2order-zpkor = '999' THEN 'X' ELSE ' ' )
                                             anlzu = ls_header_old-anlzu
                                             zintervall  = ls_cust-z_interval ).


          calculate_start_end_time( EXPORTING iv_gstrp = ls_zia_2order-gstrp
                                              iv_gsuzp = ls_zia_2order-gsuzp
                                              iv_gltrp = ls_zia_2order-gltrp
                                              iv_gluzp = ls_zia_2order-gluzp
                                    IMPORTING ev_start_zeit = ls_zia_2order-start_zeit
                                              ev_end_zeit = ls_zia_2order-end_zeit ).


          update_time_and_capacities( EXPORTING iv_aufnr = ls_header_old-aufnr
                                                iv_interval_type = ls_cust-z_interval ).


          MODIFY zia_2order FROM ls_zia_2order.
***
        ENDIF.
      ENDIF.


    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~CMTS_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_MATNR                        TYPE        AFPOD-MATNR
* | [--->] I_PROD_PLANT                   TYPE        AFPOD-DWERK
* | [--->] I_PLAN_PLANT                   TYPE        AFPOD-PWERK
* | [<-->] FLG_CMTS_ALLOWED               TYPE        FLAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~cmts_check.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~COMP_RQMT_DATE_TIME_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_PLND_ORDER_SCHEDG            TYPE        ABAP_BOOL
* | [--->] IS_HEADER                      TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IT_OPERATIONS                  TYPE        CO_TT_AFVGDGET
* | [--->] IS_COMPONENT                   TYPE        COBAI_S_COMPONENT
* | [<-->] C_RQMT_DATE                    TYPE        BDTER
* | [<-->] C_RQMT_TIME                    TYPE        BDZTP
* | [<-->] C_LATEST_RQMT_DATE             TYPE        SBTER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~comp_rqmt_date_time_set.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~INITIALIZE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CAUFVDB                     TYPE        CAUFVDB
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~initialize.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~IN_UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER                      TYPE        COBAI_T_HEADER(optional)
* | [--->] IT_HEADER_OLD                  TYPE        COBAI_T_HEADER_OLD(optional)
* | [--->] IT_ITEM                        TYPE        COBAI_T_ITEM(optional)
* | [--->] IT_ITEM_OLD                    TYPE        COBAI_T_ITEM_OLD(optional)
* | [--->] IT_SEQUENCE                    TYPE        COBAI_T_SEQUENCE(optional)
* | [--->] IT_SEQUENCE_OLD                TYPE        COBAI_T_SEQUENCE_OLD(optional)
* | [--->] IT_OPERATION                   TYPE        COBAI_T_OPERATION(optional)
* | [--->] IT_OPERATION_OLD               TYPE        COBAI_T_OPERATION_OLD(optional)
* | [--->] IT_COMPONENT                   TYPE        COBAI_T_COMPONENT(optional)
* | [--->] IT_COMPONENT_OLD               TYPE        COBAI_T_COMPONENT_OLD(optional)
* | [--->] IT_DOCLINK                     TYPE        COBAI_T_DOCLINK(optional)
* | [--->] IT_DOCLINK_OLD                 TYPE        COBAI_T_DOCLINK_OLD(optional)
* | [--->] IT_PRT_ALLOCATION              TYPE        COBAI_T_PRT_ALLOCATION(optional)
* | [--->] IT_PRT_ALLOCATION_OLD          TYPE        COBAI_T_PRT_ALLOCATION_OLD(optional)
* | [--->] IT_MILESTONE                   TYPE        COBAI_T_MILESTONE(optional)
* | [--->] IT_MILESTONE_OLD               TYPE        COBAI_T_MILESTONE_OLD(optional)
* | [--->] IT_PLANNED_ORDER               TYPE        COBAI_T_PLANNED_ORDER(optional)
* | [--->] IT_RELATIONSHIP                TYPE        COBAI_T_RELATIONSHIP(optional)
* | [--->] IT_RELATIONSHIP_OLD            TYPE        COBAI_T_RELATIONSHIP_OLD(optional)
* | [--->] IT_PMPARTNER                   TYPE        COBAI_T_PMPARTNER(optional)
* | [--->] IT_PMPARTNER_OLD               TYPE        COBAI_T_PMPARTNER_OLD(optional)
* | [--->] IT_PSTEXT                      TYPE        COBAI_T_PSTEXT(optional)
* | [--->] IT_PSTEXT_OLD                  TYPE        COBAI_T_PSTEXT_OLD(optional)
* | [--->] IT_PIINSTRUCTION               TYPE        COBAI_T_PIINSTRUCTION(optional)
* | [--->] IT_PIINSTRUCTIONVALUE          TYPE        COBAI_T_PIINSTRUCTIONVALUE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~in_update.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~NUMBER_SWITCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AUFNR_OLD                    TYPE        CAUFVD-AUFNR
* | [--->] I_AUFNR_NEW                    TYPE        CAUFVD-AUFNR
* | [--->] I_AUFPL_OLD                    TYPE        CAUFVD-AUFPL
* | [--->] I_AUFPL_NEW                    TYPE        CAUFVD-AUFPL
* | [--->] I_AUTYP                        TYPE        AUFTYP(optional)
* | [<-->] I_AUFNR_CHANGE                 TYPE        CAUFVD-AUFNR(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~number_switch.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACTIVATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~reorg_status_activate.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACT_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* | [EXC!] REORG_NOT_ALLOWED
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~reorg_status_act_check.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->IF_EX_WORKORDER_UPDATE~REORG_STATUS_REVOKE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*-----------------------------------------------------------------------
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*-----------------------------------------------------------------------
*
*-----------Änderungsdokumentation / documentation of changes-----------
* Version SAP-Rel    Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
*  >000<   7.50       20.05.2025     tcs / Pratima Sahu
*      Programmerstellung / creation of program
*-----------------------------------------------------------------------
*  >001<   7.58       16.11.2025     tcs / Roshan Wadhwani
*          Programmerstellung / Addition of other iterval types
*-----------------------------------------------------------------------
*  >002<   7.58       Datum / date      Entwickler / developer
*          Beschreibung / description
*-----------------------------------------------------------------------
METHOD if_ex_workorder_update~reorg_status_revoke.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->POPULATE_LS_ZIA_2DI_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [<---] ES_ZIA_2DI_ORDERS              TYPE        ZIA_2DI_ORDERS
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD populate_ls_zia_2di_orders.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       09.05.2025     tcs / Roshan W
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*


  ##ENH_OK  MOVE-CORRESPONDING is_header_dialog TO es_zia_2di_orders.
*to set the status as REAL.
*The below check is done to allow only REAL orders to be used
  IF is_cust-z_perimeter IS INITIAL
    OR is_cust-z_eiz IS INITIAL
    OR is_cust-z_zugangsart IS INITIAL
    OR is_cust-z_interval IS INITIAL
    OR is_cust-z_section IS INITIAL.

    RETURN.
  ENDIF.

  DATA : lv_objnr         TYPE jsto-objnr,
         lv_txt04         TYPE tj02t-txt04,
         lv_status_number TYPE jest-stat.

  lv_objnr = is_header_dialog-objnr.
  lv_txt04 = 'REAL'.

  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_TEXT_CONVERSION' "#EC CI_SUBRC
    EXPORTING
      language           = sy-langu
      mode               = 'E'
      objnr              = lv_objnr
      txt04              = lv_txt04
    IMPORTING
      status_number      = lv_status_number
    EXCEPTIONS
      insufficient_input = 1
      not_found          = 2
      object_not_found   = 3
      wrong_mode         = 4
      OTHERS             = 5.
*
  ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'STATUS_CHANGE_EXTERN'
    EXPORTING
      objnr       = is_header_dialog-objnr
      user_status = lv_status_number "'E0007'
      set_inact   = ' '.


  es_zia_2di_orders = VALUE #( BASE es_zia_2di_orders
                               zzumeli = is_header_dialog-eqfnr
                               zzperi = is_cust-z_perimeter
                               ingrp = is_header_dialog-ingpr
                               zzkmvpl = is_cust-km_from
                               zzkmbpl = is_cust-km_to
                               zzzugangsart = is_cust-z_zugangsart ).
*                                   maintordovrlprocsubphase = lc_maintordovrlprocsubphase ).


  zcl_ia_2order=>get_didok_lage_stdkz( EXPORTING is_caufvd = is_header_dialog
                                       IMPORTING ev_didok  = es_zia_2di_orders-zdidok
                                                 ev_lage   = es_zia_2di_orders-zlage
                                                 ev_stdkz  = es_zia_2di_orders-zstdkz ).

*populating the zir_nummer field.
  SELECT SINGLE zir_nummer
    INTO es_zia_2di_orders-zir_nummer
    FROM zia_2di_orders
    WHERE aufnr = is_header_dialog-aufnr.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->POPULATE_ZQUALI_ZDISPO_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD populate_zquali_zdispo_table.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       09.05.2025     tcs / Roshan W
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  DATA : lt_quali  TYPE STANDARD TABLE OF zia_2di_qualis,
         lt_dispo  TYPE STANDARD TABLE OF zia_2di_dispo,
         lv_return TYPE boolean.

  CLEAR : lt_quali , lt_dispo .
  ##LITERAL  zcl_ia_2schichtplan_algorithm=>find_pm_order_ressources( EXPORTING iv_aufnr     = is_header_dialog-aufnr
                                                                       iv_strategy  = 'A'
                                                                       iv_nwtmax    = '999999999'
*                                                                       iv_interval_type = iv_interval_type
                                                             IMPORTING et_plan_out  = FINAL(lt_plan_out) ).

  LOOP AT lt_plan_out ASSIGNING FIELD-SYMBOL(<ls_plan_out>).

    APPEND INITIAL LINE TO lt_quali ASSIGNING FIELD-SYMBOL(<ls_quali>).

    ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '1'
        object      = 'ZIA_2REAL'
      IMPORTING
        number      = <ls_quali>-zid_quali.

    <ls_quali> = VALUE #( BASE <ls_quali>
                          aufnr  = is_header_dialog-aufnr
                          zobjid = <ls_plan_out>-objid
                          zobjty = <ls_plan_out>-objty ).

  ENDLOOP.

  "*******************
  "* Begin Disposition data
  "***************
  DATA(lv_datum) = is_header_dialog-gstrp.

  WHILE lv_datum LE is_header_dialog-gltrp.

    LOOP AT lt_quali ASSIGNING <ls_quali>.

      APPEND INITIAL LINE TO lt_dispo ASSIGNING FIELD-SYMBOL(<ls_dispo>).

      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr = '1'
          object      = 'ZIA_2REAL'
        IMPORTING
          number      = <ls_dispo>-zid_dispo.

      <ls_dispo> = VALUE #( BASE <ls_dispo>
                ztag      = lv_datum
                zid_quali = <ls_quali>-zid_quali ).



    ENDLOOP.

    lv_datum = CONV dats( lv_datum + 1 ).

  ENDWHILE.

*********************************************

  CHECK lt_quali IS NOT INITIAL.

  lv_return = zcl_ia_2order=>check_auf_for_change( is_caufvd = is_header_dialog
                                                   it_quali  = lt_quali ).

*when something is changed, the variable lv_return is populated as X
  IF lv_return IS NOT INITIAL.
    DELETE FROM zia_2di_dispo WHERE zid_quali IN ( SELECT zid_quali
                                                     FROM zia_2di_qualis
                                                     WHERE aufnr EQ is_header_dialog-aufnr ).
    DELETE FROM zia_2di_qualis WHERE aufnr EQ is_header_dialog-aufnr.

    MODIFY : zia_2di_qualis FROM TABLE lt_quali,
             zia_2di_dispo FROM TABLE lt_dispo.
  ENDIF.

*********************************************

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->SELECT_ERROR_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_501                         TYPE        CHAR1
* | [--->] IV_502                         TYPE        CHAR1
* | [--->] IV_503                         TYPE        CHAR1
* | [--->] IV_504                         TYPE        CHAR1
* | [--->] IV_505                         TYPE        CHAR1
* | [--->] IV_506                         TYPE        CHAR1
* | [--->] IV_507                         TYPE        CHAR1
* | [--->] IV_508                         TYPE        CHAR1
* | [--->] IV_510                         TYPE        CHAR1
* | [--->] IV_511                         TYPE        CHAR1
* | [--->] IV_512                         TYPE        CHAR1
* | [<---] EV_MESSAGE                     TYPE        T100-TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_error_message.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : select error message.
*----------------------------------------------------------------------*

    IF iv_501 = 'X'.
      MESSAGE e501(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.

    IF iv_502 = 'X'.
      MESSAGE e502(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.

    IF iv_503 = 'X'.
      MESSAGE e503(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_504 = 'X'.
      MESSAGE e504(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_505 = 'X'.
      MESSAGE e505(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_506 = 'X'.
      MESSAGE e506(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_507 = 'X'.
      MESSAGE e507(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_508 = 'X'.
      MESSAGE e508(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_510 = 'X'.
      MESSAGE e510(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_511 = 'X'.
      MESSAGE e511(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
    IF iv_512 = 'X'.
      MESSAGE e512(zia_2_real) INTO ev_message.
      RETURN.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->UPDATE_TIME_AND_CAPACITIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [--->] IV_INTERVAL_TYPE               TYPE        ZIA_1_INTERVALTYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_time_and_capacities.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to update tables for Time and capacities
*----------------------------------------------------------------------*



    DATA : lt_plan_out1      TYPE zcl_ia_2schichtplan_algorithm=>tt_plan_out_t,
##NEEDED           lt_1time_opr1     TYPE zcl_ia_2schichtplan_algorithm=>tt_1xvrg_out_t,
           ls_zia_2order_cap TYPE zia_2order_cap,
           ls_zia_2order_tim TYPE zia_2order_tim,
           ls_update_data    TYPE zia_2_update_data.



    " Informationen für kumulierte Aufwände und Einmalvorgänge holen
    ##LITERAL    zcl_ia_2schichtplan_algorithm=>find_pm_order_ressources( EXPORTING iv_aufnr = iv_aufnr
                                                                            iv_strategy = 'A'
                                                                            iv_nwtmax = '640'
*                                                                            iv_interval_type = iv_interval_type
*                                                                             iv_nwtmax    = '999999999'
                                                                  IMPORTING et_plan_out = lt_plan_out1
                                                                            et_1xvrg_out = lt_1time_opr1
                                                                            ev_dauto = DATA(lv_dlz) ).

    " Check if individual capacities have already been saved
    SELECT COUNT( * ) AS anzahl FROM zia_2order_cap  INTO @DATA(lv_lines_ek_check) WHERE aufnr = @iv_aufnr.

    " Check if entries already exist and which strategy is being used
    IF lv_lines_ek_check EQ 0.

      " Loop through the results table for cumulative time expenditure per job
      LOOP AT lt_plan_out1 INTO DATA(ls_plan_out).

        ls_zia_2order_cap-zid_ek = zcl_ia_2utilities2=>get_next_id( ).
        CLEAR: ls_update_data.
        ls_update_data = zcl_ia_2utilities=>set_update_data( ).
        ls_zia_2order_cap-aetim  = ls_update_data-aetim.
        ls_zia_2order_cap-aenam  = ls_update_data-aenam.
        ls_zia_2order_cap-aedat  = ls_update_data-aedat.
        ls_zia_2order_cap-aufnr  = iv_aufnr.
        ls_zia_2order_cap-zdauer = ls_plan_out-duration.
        ls_zia_2order_cap-zobjid = ls_plan_out-objid.
        ls_zia_2order_cap-zobjty = ls_plan_out-objty.
        ls_zia_2order_cap-zmunit = 'Min'.
        INSERT INTO zia_2order_cap VALUES ls_zia_2order_cap. "#EC CI_IMUD_NESTED
      ENDLOOP.

      " Populate the ZIO_AUFTRAG_ZEIT table
      ls_zia_2order_tim-aufnr = iv_aufnr.
      ls_zia_2order_tim-zdzeit = lv_dlz.

      INSERT INTO zia_2order_tim  VALUES ls_zia_2order_tim.
    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2WORKORDER_UPD->UPDATE_ZUGANGSART
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CUST                        TYPE        EAML_S_LFE_FIELDS_UI
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] IV_ZSTDKZ                      TYPE        ZIA_2DI_ORDERS-ZSTDKZ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_zugangsart.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description
*----------------------------------------------------------------------*
* >000<   7.50       25.11.2025       TCS / Roshan Wadhwani (E564128)
*    Description : Method to UPDATE  field ZUGANGSART
*----------------------------------------------------------------------*
    IF iv_zstdkz EQ 'G'.

      DATA :
**            ls_data_old TYPE eaml_d_lfe_cdoc,
*             ls_data_new TYPE eaml_d_lfe_cdoc,
        lv_obart TYPE eaml_obart VALUE 'OR',
        ls_cust1 TYPE eaml_s_lfe_data_ui,
      ##NEEDED lt_error    TYPE bapirettab.


      MOVE-CORRESPONDING is_cust TO ls_cust1.

      ls_cust1-z_zugangsart = '2'.

      CALL METHOD cl_eaml_data_handler=>set_data
        EXPORTING
          iv_obart       = lv_obart
          iv_key1        = is_header_dialog-aufnr
          is_lfe_data    = ls_cust1
        IMPORTING
          et_message     = lt_error
        EXCEPTIONS
          error_in_field = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.                            "#EC EMPTY_IF_BRANCH
*                       Implement suitable error handling here
        CHECK sy-subrc = 0.
      ELSE.
        COMMIT WORK.
      ENDIF.


*          ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.