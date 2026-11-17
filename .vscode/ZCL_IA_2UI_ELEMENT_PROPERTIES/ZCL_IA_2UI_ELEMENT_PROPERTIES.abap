class ZCL_IA_2UI_ELEMENT_PROPERTIES definition
  public
  final
  create public .

public section.

  constants MC_IS_ACTIVE type WDUI_BUTTON_DESIGN value 01 ##NO_TEXT.
  constants MC_IS_ENABLED type WDY_BOOLEAN value 'X' ##NO_TEXT.
  constants MC_IS_INACTIVE type WDUI_BUTTON_DESIGN value 00 ##NO_TEXT.
  constants MC_IS_NOT_ENABLED type WDY_BOOLEAN value ' ' ##NO_TEXT.
  constants MC_IS_NOT_READ_ONLY type WDY_BOOLEAN value ' ' ##NO_TEXT.
  constants MC_IS_NOT_VISIBLE type WDY_BOOLEAN value ' ' ##NO_TEXT.
  constants MC_IS_READ_ONLY type WDY_BOOLEAN value 'X' ##NO_TEXT.
  constants MC_IS_VISIBLE type WDY_BOOLEAN value 'X' ##NO_TEXT.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !IV_ID type ZIA_2_ID_FZG optional
      !IS_DATA type ZIA_2FZG optional
      !IO_ARBEITSSTELLE type ref to ZCL_IA_2WRKPLACE optional .
  methods GET_DSG_BTN_EDIT
    returning
      value(RV_DESIGN) type WDUI_BUTTON_DESIGN .
  methods RELOAD .
  methods SET_UI_ARBSTELLE_EDIT_MODE
    importing
      !IV_EDIT_MODE type BOOLEAN .
  methods SET_ENA_BTN_AS_EDIT
    importing
      !IV_DATA type BOOLEAN .
  methods SET_ENA_BTN_AS_LOESCHEN
    importing
      !IV_DATA type BOOLEAN .
  methods SET_DSG_BTN_AS_EDIT
    importing
      !IV_DESIGN type WDUI_BUTTON_DESIGN .
  methods SET_REA_CKB_AS_BEG
    importing
      !IV_DATA type BOOLEAN .
  methods SET_REA_CKB_AS_THF
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_AS_CPM
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_DD_AS_FZ_REIHUNG
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_AS_FZ_ETCS
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_AS_FZ_ORIENT
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_AS_QUALI_ADD
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_AS_QUALI_REMOVE
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_AS_FZ_ADD
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_AS_FZ_REMOVE
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_VIS_TCO_FILTER_DISTANZ
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_VIS_TC_AS_TABLEPOPIN
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_JP_AUF_EINPL
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_JP_SEL_AUFTR
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_IMG_QUALI_DRAG
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_IMG_EINZEL_KAPA_DRAG
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_MAT_TABLE_DRAG
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_FZG_REF
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_FZ_AUSW
    importing
      !IV_VALUE type ABAP_BOOL .
  methods SET_REA_CKB_AS_SC
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_UI_SCHICHT_EDIT_MODE
    importing
      !IV_EDIT_MODE type BOOLEAN .
  methods SET_ENA_LTA_RESET_SCHICHT
    importing
      !IV_DATA type BOOLEAN .
  methods SET_ENA_LTA_START
    importing
      !IV_DATA type BOOLEAN .
  methods SET_DSG_BTN_EDIT
    importing
      !IV_DESIGN type WDUI_BUTTON_DESIGN .
  methods SET_ENA_CKB_MET_FAIDO
    importing
      !IV_DATA type BOOLEAN .
  methods SET_ENA_CKB_MET_SEDRUN
    importing
      !IV_DATA type BOOLEAN .
  methods SET_REA_CKB_MET_FAIDO
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_REA_CKB_MET_SEDRUN
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_EZ_FORMATION_BEST
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_ENA_BTN_BERECHNUNG_TREMOLA .
  methods SET_VIS_BTN_BERECHNUNG_TREMOLA .
  methods SET_VIS_BTN_AS_EDIT
    importing
      !IV_DATA type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  methods SET_VIS_SP_DETAILS
    importing
      !IV_DATA type BOOLEAN .
  methods SET_ENA_RMP_FOR_STATUS
    importing
      !IV_EDIT_MODE type ABAP_BOOL
      !IV_CURR_STATUS type ZIA_2_SHIFT_STATUS .
  methods SET_UI_SCHICHT_PERIMETER_MODE
    importing
      !IV_PERIMETER type ZIA_2_PERIMETERS
      !IV_TREMOLA_ACTIVE type ABAP_BOOL .
  methods GET_UI_SCHICHT
    returning
      value(RS_DATA) type ZIA_2_UI_SHIFT_S .
  methods GET_UI_ARBEITSSTELLE
    returning
      value(RS_DATA) type ZIA_2_UI_WORKPLACE_S .
  methods SET_VIS_TC_MET
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_VIS_TC_OSS
    importing
      value(IV_DATA) type BOOLEAN .
  methods SET_VIS_BTN_BILDFAHRPLAN_ANZ .
  methods GET_VIS_TC_MET
    returning
      value(RV_RETURN) type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  methods GET_VIS_TC_OSS
    returning
      value(RV_RETURN) type BOOLEAN
    raising
      ZCX_IA_2FAILURE .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_shicht_status_key ,
        status TYPE zia_2_shift_status,
      END   OF ts_shicht_status_key .
  types:
    tt_shicht_status_key TYPE STANDARD TABLE OF ts_shicht_status_key WITH EMPTY KEY .

  data gS_UI_SCHICHT type ZIA_2_UI_SHIFT_S .
  data gS_UI_ARBEITSSTELLE type ZIA_2_UI_WORKPLACE_S .
  class-data MT_SHICHT_STATUS_KEY type TT_SHICHT_STATUS_KEY .
  data gV_PERIMETER type ZIA_2_WRKSHIFTS-ZZPERI .
  data gV_TREMOLA_ACTIVE type ABAP_BOOL .

  class-methods INITIALIZE_SCHICHT_STATUS_KEYS .
  methods SET_UI_STATUS_EDIT_MODE
    importing
      !IV_EDIT_MODE type BOOLEAN .
  methods SET_ENA_RMP_STATUS
    importing
      !IV_STATUS type ZIA_2_SHIFT_STATUS
      !IV_ENABLED type WDY_BOOLEAN .
ENDCLASS.



CLASS ZCL_IA_2UI_ELEMENT_PROPERTIES IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    initialize_schicht_status_keys( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID                          TYPE        ZIA_2_ID_FZG(optional)
* | [--->] IS_DATA                        TYPE        ZIA_2FZG(optional)
* | [--->] IO_ARBEITSSTELLE               TYPE REF TO ZCL_IA_2WRKPLACE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    me->reload( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->GET_DSG_BTN_EDIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DESIGN                      TYPE        WDUI_BUTTON_DESIGN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_dsg_btn_edit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    rv_design = me->gs_ui_schicht-dsg_btn_edit.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2UI_ELEMENT_PROPERTIES=>INITIALIZE_SCHICHT_STATUS_KEYS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD initialize_schicht_status_keys.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

  mt_shicht_status_key = VALUE #( ( status = zif_ia_2_wrkshft_status=>mc_plannig_started )
                                  ( status = zif_ia_2_wrkshft_status=>mc_disposition_released )
                                  ( status = zif_ia_2_wrkshft_status=>mc_shift_released )
                                ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD reload.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  CLEAR me->gs_ui_schicht.
  CLEAR me->gs_ui_arbeitsstelle.


  gs_ui_schicht-ena_edit_mode = mc_is_not_enabled.

  me->gs_ui_schicht-ena_btn_edit = mc_is_not_enabled.
  me->gs_ui_schicht-dsg_btn_edit = mc_is_inactive.


  "------------------------------------------------------------------"
  " Anzeigebutton bei Schicht visible
  "------------------------------------------------------------------"
  "Button Bildfahrplan anzeigen -> visible
  me->gs_ui_schicht-vis_btn_bildfahrplan_anzeigen = abap_false.
  "Button Drehbücher generieren -> visible
  me->gs_ui_schicht-vis_btn_drehbuecher_generieren = abap_true.
  "Button Schichtreport -> visible
  me->gs_ui_schicht-vis_btn_schichtreport = abap_true.
  "Button GBT Detail -> visible
  me->gs_ui_schicht-vis_btn_gbt_detail = abap_true.
  "------------------------------------------------------------------"
  " Enablesteuerung bei Button für Anzeige Schicht
  "------------------------------------------------------------------"
  "Button EZ-Formation bestimmen not enabled
  me->gs_ui_schicht-ena_btn_ez_formation_bestimmen = abap_false.
  "Button Berechnung Tremola not enabled
  me->gs_ui_schicht-ena_btn_berechnung_tremola = abap_false.

  "------------------------------------------------------------------"
  " Anzeigebutton bei Schicht NOT visible
  "------------------------------------------------------------------"
  "Button Berechnung Tremola not visible
  me->gs_ui_schicht-vis_btn_berechnung_tremola = abap_false.

  me->gs_ui_schicht-vis_btn_ez_formation_bestimmen = abap_true.


  me->gs_ui_arbeitsstelle-lead_selection_jl = 0.
  me->gs_ui_arbeitsstelle-lead_selection_jp = 0.

  gs_ui_arbeitsstelle-rea_dd_as_fz_reihung = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_jp_sel_auftr = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_as_fz_etcs   = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_as_fz_orient = mc_is_read_only.


  gs_ui_arbeitsstelle-rea_ckb_as_beg = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_as_sc = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_as_thf = mc_is_read_only.
  gs_ui_arbeitsstelle-rea_ckb_as_cpm = mc_is_read_only.

  gs_ui_arbeitsstelle-vis_btn_as_edit = mc_is_visible.
  gs_ui_arbeitsstelle-vis_sp_details = mc_is_visible.


  set_ui_status_edit_mode( abap_false ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_DSG_BTN_AS_EDIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DESIGN                      TYPE        WDUI_BUTTON_DESIGN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_dsg_btn_as_edit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-dsg_btn_as_edit = iv_design.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_EDIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_as_edit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-ena_btn_as_edit = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_FZ_ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_ena_btn_as_fz_add.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025       TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM

*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  me->gs_ui_arbeitsstelle-ena_btn_as_fz_add = iv_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_FZ_REMOVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_ena_btn_as_fz_remove.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
*----------------------------------------------------------------------*
*
*-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
* VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
* BESCHREIBUNG / DESCRIPTION:
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025       TCS / SIVASURYA KUCHERLA
*PROGRAMMERSTELLUNG / CREATION OF PROGRAM

*----------------------------------------------------------------------*
* >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
*         ...
*----------------------------------------------------------------------*
  me->gs_ui_arbeitsstelle-ena_btn_as_fz_remove = iv_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_LOESCHEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_as_loeschen.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-ena_btn_as_loeschen = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_QUALI_ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_as_quali_add.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-ena_btn_as_quali_add = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_AS_QUALI_REMOVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_as_quali_remove.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-ena_btn_as_quali_remove = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_FZG_REF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_fzg_ref.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-ena_btn_fzg_ref = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_JP_AUF_EINPL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_jp_auf_einpl.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-ena_btn_jp_auf_einpl = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_IMG_EINZEL_KAPA_DRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_img_einzel_kapa_drag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-ena_img_einzel_kapa_drag = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_IMG_QUALI_DRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_img_quali_drag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-ena_img_quali_drag = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_MAT_TABLE_DRAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_mat_table_drag.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-ena_mat_table_drag = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_RMP_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STATUS                      TYPE        ZIA_2_SHIFT_STATUS
* | [--->] IV_ENABLED                     TYPE        WDY_BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_rmp_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    FIELD-SYMBOLS <ls_status> TYPE zia_2_ui_shift_status_s  .

    CHECK iv_status IS NOT INITIAL.

    DATA(lv_group) = VALUE ddgroup( ).
    lv_group = |SCHICHT_STATUS_{ iv_status }|.

    ASSIGN COMPONENT lv_group OF STRUCTURE gs_ui_schicht TO <ls_status>.
    CHECK <ls_status> IS ASSIGNED.

    <ls_status>-ena_rmp_step_ = iv_enabled.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_BEG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_as_beg.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-rea_ckb_as_beg = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_CPM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_as_cpm.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-rea_ckb_as_cpm = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_FZ_ETCS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_rea_ckb_as_fz_etcs.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  gs_ui_arbeitsstelle-rea_ckb_as_fz_etcs = iv_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_FZ_ORIENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_as_fz_orient.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    me->gs_ui_arbeitsstelle-rea_ckb_as_fz_orient = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_SC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_as_sc.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-rea_ckb_as_sc = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_AS_THF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_as_thf.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-rea_ckb_as_thf = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_FZ_AUSW
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_fz_ausw.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-rea_ckb_fz_ausw = iv_value.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_JP_SEL_AUFTR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_jp_sel_auftr.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_arbeitsstelle-rea_ckb_jp_sel_auftr = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_DD_AS_FZ_REIHUNG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_rea_dd_as_fz_reihung.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  me->gs_ui_arbeitsstelle-rea_dd_as_fz_reihung = iv_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_UI_ARBSTELLE_EDIT_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDIT_MODE                   TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ui_arbstelle_edit_mode.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    CASE iv_edit_mode.
      WHEN abap_true.
        set_ena_btn_as_edit( mc_is_enabled ).
        set_ena_btn_as_loeschen( mc_is_enabled ).
        set_dsg_btn_as_edit( mc_is_active  ).
        set_rea_ckb_as_beg( mc_is_not_read_only ).
        set_rea_ckb_as_sc( mc_is_not_read_only ).
        set_rea_ckb_as_thf( mc_is_not_read_only ).
        set_rea_ckb_as_cpm( mc_is_not_read_only ).
        set_rea_dd_as_fz_reihung( mc_is_not_read_only ).
        set_rea_ckb_as_fz_etcs( mc_is_not_read_only ).
        set_rea_ckb_as_fz_orient( mc_is_not_read_only ).
        set_ena_btn_as_quali_add( mc_is_enabled ).
        set_ena_btn_as_quali_remove( mc_is_enabled ).
        set_ena_btn_as_fz_add( mc_is_enabled ).
        set_ena_btn_as_fz_remove( mc_is_enabled ).
        set_vis_tco_filter_distanz( mc_is_visible ).
        set_vis_tc_as_tablepopin( mc_is_visible ).
        set_ena_btn_jp_auf_einpl( mc_is_enabled ).
        set_rea_ckb_jp_sel_auftr( mc_is_not_read_only ).
        set_ena_img_quali_drag( mc_is_enabled ).
        set_ena_img_einzel_kapa_drag( mc_is_enabled ).
        set_ena_mat_table_drag( mc_is_enabled ).             ">001< +
        set_ena_btn_fzg_ref( mc_is_enabled ).                ">002< +
        set_rea_ckb_fz_ausw( mc_is_not_read_only ).          ">003< +
      WHEN abap_false.
        set_ena_btn_as_edit( mc_is_not_enabled ).
        set_ena_btn_as_loeschen( mc_is_not_enabled ).
        set_dsg_btn_as_edit( mc_is_inactive ).
        set_rea_ckb_as_beg( mc_is_read_only ).
        set_rea_ckb_as_sc( mc_is_read_only ).
        set_rea_ckb_as_thf( mc_is_read_only ).
        set_rea_ckb_as_cpm( mc_is_read_only ).
        set_rea_dd_as_fz_reihung( mc_is_read_only ).
        set_rea_ckb_as_fz_etcs( mc_is_read_only ).
        set_rea_ckb_as_fz_orient( mc_is_read_only ).
        set_ena_btn_as_quali_add( mc_is_not_enabled ).
        set_ena_btn_as_quali_remove( mc_is_not_enabled ).
        set_ena_btn_as_fz_add( mc_is_not_enabled ).
        set_ena_btn_as_fz_remove( mc_is_not_enabled ).
        set_vis_tco_filter_distanz( mc_is_not_visible ).
        set_vis_tc_as_tablepopin( mc_is_not_visible ).
        set_ena_btn_jp_auf_einpl( mc_is_not_enabled ).
        set_rea_ckb_jp_sel_auftr( mc_is_read_only ).
        set_ena_img_quali_drag( mc_is_not_enabled ).
        set_ena_img_einzel_kapa_drag( mc_is_not_enabled ).
        set_ena_mat_table_drag( mc_is_not_enabled ).         ">001< +
        set_ena_btn_fzg_ref( mc_is_not_enabled ).            ">002< +
        set_rea_ckb_fz_ausw( mc_is_read_only ).              ">003< +
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_UI_STATUS_EDIT_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDIT_MODE                   TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ui_status_edit_mode.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_enabled) = COND #( WHEN iv_edit_mode = abap_true THEN mc_is_enabled ELSE mc_is_not_enabled ).

    set_ena_rmp_status( iv_status  = zif_ia_2_wrkshft_status=>mc_plannig_started
                        iv_enabled = lv_enabled ).
    set_ena_rmp_status( iv_status  = zif_ia_2_wrkshft_status=>mc_disposition_released
                        iv_enabled = lv_enabled ).
    set_ena_rmp_status( iv_status  = zif_ia_2_wrkshft_status=>mc_shift_released
                        iv_enabled = lv_enabled ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_TCO_FILTER_DISTANZ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_tco_filter_distanz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-vis_tco_filter_distanz = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_TC_AS_TABLEPOPIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_tc_as_tablepopin.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-vis_tc_as_tablepopin = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_DSG_BTN_EDIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DESIGN                      TYPE        WDUI_BUTTON_DESIGN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_dsg_btn_edit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  me->gs_ui_schicht-dsg_btn_edit = iv_design.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_BERECHNUNG_TREMOLA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_ena_btn_berechnung_tremola.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  gs_ui_schicht-ena_btn_berechnung_tremola =
    COND #( WHEN gs_ui_schicht-vis_btn_berechnung_tremola = mc_is_not_visible
            THEN mc_is_not_enabled
            ELSE COND #( WHEN gs_ui_schicht-ena_edit_mode = mc_is_enabled THEN mc_is_enabled ELSE mc_is_not_enabled )
          ).
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_BTN_EZ_FORMATION_BEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_btn_ez_formation_best.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ENA_BTN_EZ_FORMATION_BEST
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_schicht-ena_btn_ez_formation_bestimmen = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_CKB_MET_FAIDO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_ckb_met_faido.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ENA_CKB_MET_FAIDO
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_schicht-ena_ckb_met_faido = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_CKB_MET_SEDRUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_ckb_met_sedrun.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ENA_CKB_MET_SEDRUN
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_schicht-ena_ckb_met_sedrun = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_LTA_RESET_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_lta_reset_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_schicht-ena_lta_reset_schicht = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_LTA_START
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_lta_start.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_ENA_LTA_START
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_schicht-ena_lta_start = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_MET_FAIDO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_met_faido.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_REA_CKB_MET_FAIDO
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    me->gs_ui_schicht-rea_ckb_met_faido = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_REA_CKB_MET_SEDRUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_rea_ckb_met_sedrun.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : SET_REA_CKB_MET_SEDRUN
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    me->gs_ui_schicht-rea_ckb_met_sedrun = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_UI_SCHICHT_EDIT_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDIT_MODE                   TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_ui_schicht_edit_mode.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  CASE iv_edit_mode.

    WHEN abap_true.
      gs_ui_schicht-ena_edit_mode = mc_is_enabled.

      set_ena_lta_start( mc_is_enabled ).
      set_ena_lta_reset_schicht( mc_is_enabled ).
      set_dsg_btn_edit( mc_is_active  ).
      set_rea_ckb_met_faido( mc_is_not_read_only ).
      set_rea_ckb_met_sedrun( mc_is_not_read_only ).
      set_ena_btn_ez_formation_best( mc_is_enabled ).
      set_vis_btn_berechnung_tremola( ).
      set_ena_btn_berechnung_tremola( ).
      set_ena_ckb_met_faido( mc_is_enabled ).
      set_ena_ckb_met_sedrun( mc_is_enabled ).

    WHEN abap_false.
      gs_ui_schicht-ena_edit_mode = mc_is_not_enabled.

      set_ena_lta_start( mc_is_not_enabled ).
      set_ena_lta_reset_schicht( mc_is_not_enabled ).
      set_dsg_btn_edit( mc_is_inactive  ).
      set_rea_ckb_met_faido( mc_is_read_only ).
      set_rea_ckb_met_sedrun( mc_is_read_only ).
      set_ena_btn_ez_formation_best( mc_is_not_enabled ).
      set_vis_btn_berechnung_tremola( ).
      set_ena_btn_berechnung_tremola( ).
      set_ena_ckb_met_faido( mc_is_not_enabled ).
      set_ena_ckb_met_sedrun( mc_is_not_enabled ).

  ENDCASE.

  set_ui_status_edit_mode( iv_edit_mode ).

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_BTN_BERECHNUNG_TREMOLA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_btn_berechnung_tremola.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    gs_ui_schicht-vis_btn_berechnung_tremola =
  COND #( WHEN gv_perimeter = 'CBT'
          THEN mc_is_not_visible
          ELSE COND #( WHEN gv_tremola_active = abap_true THEN mc_is_visible ELSE mc_is_not_visible )
        ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_BTN_AS_EDIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_btn_as_edit.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    me->gs_ui_arbeitsstelle-vis_btn_as_edit = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_ENA_RMP_FOR_STATUS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDIT_MODE                   TYPE        ABAP_BOOL
* | [--->] IV_CURR_STATUS                 TYPE        ZIA_2_SHIFT_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_ena_rmp_for_status.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(lv_prev_status) = zif_ia_2_wrkshft_status=>mc_initial.

    LOOP AT mt_shicht_status_key REFERENCE INTO DATA(ld_status_key).

      DATA(lv_enabled) = mc_is_not_enabled.

      CASE iv_edit_mode.
        WHEN abap_true.
          IF   iv_curr_status = ld_status_key->status
            OR iv_curr_status = lv_prev_status.
            lv_enabled = mc_is_enabled.
          ENDIF.
        WHEN abap_false.
          IF iv_curr_status = ld_status_key->status.
            lv_enabled = mc_is_enabled.
          ENDIF.
      ENDCASE.

      " added for release 2

      IF iv_curr_status = '2'
           AND ld_status_key->status = '2'.
        lv_enabled = mc_is_not_enabled.
      ENDIF.


      set_ena_rmp_status( iv_status  = ld_status_key->status
                          iv_enabled = lv_enabled ).

      lv_prev_status = ld_status_key->status.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_UI_SCHICHT_PERIMETER_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERIMETER                   TYPE        ZIA_2_PERIMETERS
* | [--->] IV_TREMOLA_ACTIVE              TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD set_ui_schicht_perimeter_mode.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

   gv_perimeter = iv_perimeter.
   gv_tremola_active = iv_tremola_active.

   CASE gv_perimeter.
     WHEN 'GBT'.
       set_vis_tc_met( mc_is_visible ).
       set_vis_tc_oss( mc_is_visible ).
       set_vis_btn_berechnung_tremola( ).
       set_ena_btn_berechnung_tremola( ).
       set_vis_btn_bildfahrplan_anz( ).

     WHEN 'CBT'.
       set_vis_tc_met( mc_is_not_visible ).
       set_vis_tc_oss( mc_is_not_visible ).
       set_vis_btn_berechnung_tremola( ).
       set_ena_btn_berechnung_tremola( ).
       set_vis_btn_bildfahrplan_anz( ).

   ENDCASE.
 ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_SP_DETAILS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD set_vis_sp_details.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  me->gs_ui_arbeitsstelle-vis_sp_details = iv_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->GET_UI_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2_UI_SHIFT_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_ui_schicht.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  rs_data = gs_ui_schicht.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->GET_UI_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2_UI_WORKPLACE_S
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_ui_arbeitsstelle.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  rs_data = gs_ui_arbeitsstelle.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->GET_VIS_TC_MET
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RETURN                      TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vis_tc_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    rv_return = me->gs_ui_schicht-vis_tc_met.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->GET_VIS_TC_OSS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RETURN                      TYPE        BOOLEAN
* | [!CX!] ZCX_IA_2FAILURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vis_tc_oss.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    rv_return = me->gs_ui_schicht-vis_tc_oss.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_BTN_BILDFAHRPLAN_ANZ
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_btn_bildfahrplan_anz.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    gs_ui_schicht-vis_btn_bildfahrplan_anzeigen = COND #( WHEN gv_perimeter = 'CBT' THEN mc_is_not_visible ELSE mc_is_visible ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_TC_MET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_tc_met.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    me->gs_ui_schicht-vis_tc_met = iv_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2UI_ELEMENT_PROPERTIES->SET_VIS_TC_OSS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_vis_tc_oss.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
    me->gs_ui_schicht-vis_tc_oss = iv_data.
  ENDMETHOD.
ENDCLASS.