class ZCL_IA_2EXCEL_WORKSHEET definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_column_formula,
        id                     TYPE i,
        column                 TYPE zexcel_cell_column,
        formula                TYPE string,
        table_top_left_row     TYPE zexcel_cell_row,
        table_bottom_right_row TYPE zexcel_cell_row,
        table_left_column_int  TYPE zexcel_cell_column,
        table_right_column_int TYPE zexcel_cell_column,
      END OF ts_column_formula .
  types:
    tt_column_formula
               TYPE HASHED TABLE OF ts_column_formula
               WITH UNIQUE KEY id .

  data GO_EXCEL type ref to ZCL_IA_2EXCEL .
  data GT_COLUMN_FORMULAS type TT_COLUMN_FORMULA read-only .

  methods GET_ROW_DIMENSIONS
    returning
      value(RT_ROW_DIMENSION) type ZIA_2EXCEL_WS_ROWDIMENSION_T .
  methods GET_GUID
    returning
      value(RV_GUID) type UUID .
  methods GET_TITLE
    importing
      !IV_ESCAPED type FLAG default ''
    returning
      value(RV_TITLE) type ZEXCEL_SHEET_TITLE .
protected section.
PRIVATE SECTION.

  TYPES:
    tt_ts_row_dimension TYPE SORTED TABLE OF zia_2_excel_ws_rowdimension_s WITH UNIQUE KEY row .
  TYPES:
##NEEDED    tt_table_settings TYPE STANDARD TABLE OF zexcel_s_table_settings WITH DEFAULT KEY .

  DATA gt_row_dimensions TYPE tt_ts_row_dimension .
  DATA gv_guid TYPE uuid .
  DATA gv_title TYPE zexcel_sheet_title .
ENDCLASS.



CLASS ZCL_IA_2EXCEL_WORKSHEET IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2EXCEL_WORKSHEET->GET_GUID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_GUID                        TYPE        UUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_guid.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_GUID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_guid = me->gv_guid.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2EXCEL_WORKSHEET->GET_ROW_DIMENSIONS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_ROW_DIMENSION               TYPE        ZIA_2EXCEL_WS_ROWDIMENSION_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_row_dimensions.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_ROW_DIMENSIONS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rt_row_dimension[] = me->gt_row_dimensions[].
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2EXCEL_WORKSHEET->GET_TITLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ESCAPED                     TYPE        FLAG (default ='')
* | [<-()] RV_TITLE                       TYPE        ZEXCEL_SHEET_TITLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_title.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : GET_TITLE
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA lv_value TYPE string.
    IF iv_escaped EQ abap_true.
      lv_value = me->gv_title.
      rv_title = zcl_excel_common=>escape_string( lv_value ).
    ELSE.
      rv_title = me->gv_title.
    ENDIF.
  ENDMETHOD.
ENDCLASS.