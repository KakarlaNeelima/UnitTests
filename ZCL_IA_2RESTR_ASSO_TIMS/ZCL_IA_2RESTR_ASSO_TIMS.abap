class ZCL_IA_2RESTR_ASSO_TIMS definition
  public
  final
  create private .

public section.

  class-methods GET_INSTANCE
    importing
      !IV_ID type ZIA_2SF_BS_TIME-SP_ZEITEN_ID optional
    returning
      value(RO_INSTANCE) type ref to ZCL_IA_2RESTR_ASSO_TIMS .
  methods GET_DATA
    returning
      value(RS_DATA) type ZIA_2SF_BS_TIME .
  methods GET_DATA_CONV_24
    returning
      value(RS_DATA) type ZIA_2SF_BS_TIME .
  methods GET_ID
    returning
      value(RV_ID) type ZIA_2_SP_ZEITEN_ID .
  methods RELOAD .
  methods SET_DATA
    importing
      !IS_DATA type ZIA_2SF_BS_TIME .
  methods UPDATE_DATA
    importing
      !IS_DATA type ZIA_2SF_BS_TIME .
protected section.
private section.

  types:
    BEGIN OF ts_register ,
      sp_zeiten_id TYPE zia_2sf_bs_time-sp_zeiten_id,
      oref         TYPE REF TO zcl_ia_2restr_asso_tims,
    END   OF ts_register .
  types:
    tt_register TYPE HASHED TABLE OF ts_register WITH UNIQUE KEY sp_zeiten_id .
  types:
    BEGIN OF ts_key ,
      sp_zeiten_id TYPE zia_2sf_bs_time-sp_zeiten_id,
      zarbstl      TYPE zia_2sf_bs_time-zarbstl,
      sperras_id   TYPE zia_2sf_bs_time-sperras_id,
    END   OF ts_key .
  types:
    BEGIN OF ts_data ,
      start_datum TYPE zia_2sf_bs_time-start_datum,
      start_zeit  TYPE zia_2sf_bs_time-start_zeit,
      end_datum   TYPE zia_2sf_bs_time-end_datum,
      end_zeit    TYPE zia_2sf_bs_time-end_zeit,
      aedat       TYPE zia_2sf_bs_time-aedat,
      aetim       TYPE zia_2sf_bs_time-aetim,
      aenam       TYPE zia_2sf_bs_time-aenam,
    END   OF ts_data .
  types:
    BEGIN OF ts_db ,
      mandt TYPE zia_2sf_bs_time-mandt.
      INCLUDE TYPE ts_key AS skey.
      INCLUDE TYPE ts_data AS sdata.
TYPES END   OF ts_db .

  class-data MT_REGISTER type TT_REGISTER .
  data GS_SP_ZEITEN type TS_DB .

  methods CONSTRUCTOR
    importing
      !IV_ID type ZIA_2ID optional .
  methods SAVE .
ENDCLASS.



CLASS ZCL_IA_2RESTR_ASSO_TIMS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2RESTR_ASSO_TIMS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIA_2ID(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Constructor for SP_ZEITEN object – handles ID generation or reload *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " If no ID is provided, generate new ID using number range object
    IF iv_id IS INITIAL.
      ##UNHANDLED_FUNC_EXCEPTION_OK CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr = '1'           " Number range subobject
          object      = 'ZIA_2GBT'     " Number range object name
        IMPORTING
          number      = gs_sp_zeiten-sp_zeiten_id. " Generated ID
    ELSE.
      " If ID is provided, use it and reload the corresponding entry
      gs_sp_zeiten-sp_zeiten_id = iv_id.
      reload( ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                               *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Returns the structure GS_SP_ZEITEN                                  *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Return the internal structure containing SP-Zeiten data
    rs_data = me->gs_sp_zeiten.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->GET_DATA_CONV_24
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data_conv_24.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                               *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Returns the GS_SP_ZEITEN data, converting '240000' to next day     *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Copy internal structure
    rs_data = gs_sp_zeiten.

    " Convert start time '240000' to 00:00:00 of next day
    rs_data-start_zeit  = COND #( WHEN gs_sp_zeiten-start_zeit = '240000'
                                  THEN rs_data-start_zeit - ( 24 * 3600 )
                                  ELSE rs_data-start_zeit ).

    rs_data-start_datum = COND #( WHEN gs_sp_zeiten-start_zeit = '240000'
                                  THEN rs_data-start_datum + 1
                                  ELSE rs_data-start_datum ).

    " Convert end time '240000' to 00:00:00 of next day
    rs_data-end_zeit    = COND #( WHEN gs_sp_zeiten-end_zeit = '240000'
                                  THEN rs_data-end_zeit - ( 24 * 3600 )
                                  ELSE rs_data-end_zeit ).

    rs_data-end_datum   = COND #( WHEN gs_sp_zeiten-end_zeit = '240000'
                                  THEN rs_data-end_datum + 1
                                  ELSE rs_data-end_datum ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->GET_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZIA_2_SP_ZEITEN_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_id.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                               *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Returns the ID (SP_ZEITEN_ID) of the SP_ZEITEN structure           *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Return the unique identifier of the structure
    rv_id = gs_sp_zeiten-sp_zeiten_id.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2RESTR_ASSO_TIMS=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIA_2SF_BS_TIME-SP_ZEITEN_ID(optional)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_IA_2RESTR_ASSO_TIMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_instance.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                               *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Retrieves or creates a singleton instance identified by iv_id      *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*---------------------------------------------------------------------*

  TRY.
      " Try to find an existing instance in the register by iv_id
      ro_instance = mt_register[ sp_zeiten_id = iv_id ]-oref.
    ##NO_HANDLER    CATCH cx_sy_itab_line_not_found.
      " Instance not found, proceed to create new one
  ENDTRY.

  " If instance found, exit method
  CHECK ro_instance IS NOT BOUND.

  " Create new instance with the provided iv_id
  ro_instance = NEW zcl_ia_2restr_asso_tims( iv_id = iv_id ).
  CHECK ro_instance IS BOUND.

  " Register the newly created instance in mt_register table
  INSERT VALUE #( sp_zeiten_id = ro_instance->get_id( ) oref = ro_instance ) INTO TABLE mt_register.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD reload.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                               *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Reloads the SP_ZEITEN structure from the database table            *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Select current data for the given SP_ZEITEN_ID from the DB
    ##WARN_OK    SELECT SINGLE *
          FROM zia_2sf_bs_time
          INTO @DATA(ls_sp_zeiten)
          WHERE sp_zeiten_id = @gs_sp_zeiten-sp_zeiten_id.

    " Update the internal structure with the latest DB record
    gs_sp_zeiten = ls_sp_zeiten.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2RESTR_ASSO_TIMS->SAVE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Saves the current SP_ZEITEN structure to the database              *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Ensure all key fields are filled before saving
    ASSERT FIELDS gs_sp_zeiten
        CONDITION gs_sp_zeiten-sp_zeiten_id IS NOT INITIAL
              AND gs_sp_zeiten-zarbstl      IS NOT INITIAL
              AND gs_sp_zeiten-sperras_id   IS NOT INITIAL.

    " Update the corresponding record in the custom table ZIA_2SF_BS_TIME
    UPDATE zia_2sf_bs_time SET
      start_datum = @gs_sp_zeiten-start_datum,
      start_zeit  = @gs_sp_zeiten-start_zeit,
      end_datum   = @gs_sp_zeiten-end_datum,
      end_zeit    = @gs_sp_zeiten-end_zeit,
      aedat       = @gs_sp_zeiten-aedat,
      aetim       = @gs_sp_zeiten-aetim,
      aenam       = @gs_sp_zeiten-aenam
      WHERE sp_zeiten_id = @gs_sp_zeiten-sp_zeiten_id
        AND zarbstl      = @gs_sp_zeiten-zarbstl
        AND sperras_id   = @gs_sp_zeiten-sperras_id.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->SET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_data.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Sets or updates the SP_ZEITEN structure with provided data         *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Transfer matching fields from input structure to internal structure
    gs_sp_zeiten-sdata = CORRESPONDING #( is_data ).

    " If Arbeitsstelle ID is not already set, take it from input
    IF gs_sp_zeiten-zarbstl IS INITIAL.
      gs_sp_zeiten-zarbstl = is_data-zarbstl.
    ENDIF.

    " If Sperrassistent ID is not already set, take it from input
    IF gs_sp_zeiten-sperras_id IS INITIAL.
      gs_sp_zeiten-sperras_id = is_data-sperras_id.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2RESTR_ASSO_TIMS->UPDATE_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZIA_2SF_BS_TIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_data.
*---------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA                                *
*---------------------------------------------------------------------*
*
*----------- ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES -------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER         *
* BESCHREIBUNG / DESCRIPTION                                          *
*---------------------------------------------------------------------*
* >000<   7.50       16.07.2025        TCS / SIVASURYA KUCHERLA       *
* PROGRAMMERSTELLUNG / CREATION OF PROGRAM                           *
* Updates start/end time data in GS_SP_ZEITEN and saves the change   *
*---------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)    *
*                                                                       *
*---------------------------------------------------------------------*

    " Ensure that either all identity fields are empty or match existing ones
    ASSERT FIELDS gs_sp_zeiten is_data
        CONDITION (     is_data-sp_zeiten_id IS INITIAL
                    AND is_data-zarbstl      IS INITIAL
                    AND is_data-sperras_id   IS INITIAL )
               OR (     is_data-sp_zeiten_id = gs_sp_zeiten-sp_zeiten_id
                    AND is_data-zarbstl      = gs_sp_zeiten-zarbstl
                    AND is_data-sperras_id   = gs_sp_zeiten-sperras_id ).

    " Update time and date fields
    gs_sp_zeiten-start_datum = is_data-start_datum.
    gs_sp_zeiten-start_zeit  = is_data-start_zeit.
    gs_sp_zeiten-end_datum   = is_data-end_datum.
    gs_sp_zeiten-end_zeit    = is_data-end_zeit.

    " Set change metadata
    gs_sp_zeiten-aedat = sy-datum.
    gs_sp_zeiten-aetim = sy-uzeit.
    CALL METHOD cl_abap_syst=>get_user_name
      RECEIVING
        user_name = gs_sp_zeiten-aenam.

    " Save updated structure
    save( ).

  ENDMETHOD.
ENDCLASS.