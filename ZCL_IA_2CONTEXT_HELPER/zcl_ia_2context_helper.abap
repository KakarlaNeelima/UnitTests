CLASS zcl_ia_2context_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ts_element_tabs_schichten TYPE zia_2_shifts_tabs_wd_s .
    TYPES:
      tt_elements_tabs_schichten TYPE STANDARD TABLE OF ts_element_tabs_schichten WITH DEFAULT KEY .
    TYPES ts_element_schichtplan TYPE zia_2_shiftplan_wd_s .
    TYPES:
      tt_elements_schichtplan    TYPE STANDARD TABLE OF ts_element_schichtplan .
    TYPES ts_element_auftraege_alv TYPE zia_2_auftr_wd_s .
    TYPES:
      tt_elements_auftraege_alv TYPE STANDARD TABLE OF zia_2_auftr_wd_s .
    TYPES ts_element_arbst_osn TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_arbst_osn TYPE STANDARD TABLE OF ts_element_arbst_osn .
    TYPES ts_element_btg_osn TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_btg_osn TYPE STANDARD TABLE OF ts_element_btg_osn .
    TYPES ts_element_arbst_tunnel TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_arbst_tunnel TYPE STANDARD TABLE OF ts_element_arbst_tunnel .
    TYPES ts_element_btg_tunnel TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_btg_tunnel TYPE STANDARD TABLE OF ts_element_btg_tunnel .
    TYPES ts_element_arbst_oss TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_arbst_oss TYPE STANDARD TABLE OF ts_element_arbst_oss .
    TYPES ts_element_btg_oss TYPE zia_2_work_area_wd_s .
    TYPES:
      tt_elements_btg_oss TYPE STANDARD TABLE OF ts_element_btg_oss .
    TYPES ts_element_jobpool TYPE zia_2_jobpool_wd_s .
    TYPES:
      tt_elements_jobpool TYPE STANDARD TABLE OF zia_2_jobpool_wd_s .
    TYPES ts_element_sitzplatz TYPE zia_2_visquali_wd_s .
    TYPES:
      tt_elements_sitzplatz TYPE STANDARD TABLE OF ts_element_sitzplatz WITH DEFAULT KEY .
    TYPES ts_element_einzelkapas TYPE zia_2_visorder_wd_s .
    TYPES:
      tt_elements_einzelkapas TYPE STANDARD TABLE OF ts_element_einzelkapas WITH DEFAULT KEY .

    CONSTANTS mc_atnam_aufnr TYPE string VALUE 'AUFNR' ##NO_TEXT.
    CONSTANTS mc_atnam_auswahl TYPE string VALUE 'AUSWAHL' ##NO_TEXT.
    CONSTANTS mc_atnam_img_for_visualization TYPE string VALUE 'IMAGE_FOR_VISUALIZATION' ##NO_TEXT.
    CONSTANTS mc_atnam_img_for_visualiz_copy TYPE string VALUE 'IMAGE_FOR_VISUALIZATION_COPY' ##NO_TEXT.
    CONSTANTS mc_atnam_object TYPE string VALUE 'OBJECT' ##NO_TEXT.
    CONSTANTS mc_wdctx_einzelkapas TYPE string VALUE 'EINZELKAPAS' ##NO_TEXT.
    CONSTANTS mc_wdctx_sitzplatz TYPE string VALUE 'SITZPLATZ' ##NO_TEXT.

    CLASS-METHODS unlock_previous_schicht
      IMPORTING
        !ii_context TYPE REF TO if_wd_context_node .
    CLASS-METHODS unlock_prev_schicht_in_tab
      IMPORTING
        !ii_context TYPE REF TO if_wd_context_node
      RAISING
        zcx_ia_2failure .
    CLASS-METHODS mark_first_arbst
      IMPORTING
        !ii_context     TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(ro_arbst) TYPE REF TO zcl_ia_2wrkplace .
    CLASS-METHODS set_editmode_in_schichtplan
      IMPORTING
        !ii_context      TYPE REF TO if_wd_context_node
        !io_schicht      TYPE REF TO zcl_ia_2workshift
        !iv_is_editable  TYPE boolean
      RETURNING
        VALUE(rv_return) TYPE boolean
      RAISING
        zcx_ia_2failure .
    CLASS-METHODS del_schicht_tab
      IMPORTING
        !ii_context      TYPE REF TO if_wd_context_node
        !io_schicht      TYPE REF TO zcl_ia_2workshift
      RETURNING
        VALUE(rv_return) TYPE boolean .
    CLASS-METHODS get_editable_schicht
      IMPORTING
        !ii_context       TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(ro_schicht) TYPE REF TO zcl_ia_2workshift
      RAISING
        zcx_ia_2failure .
    CLASS-METHODS get_selected_auftrag_as_obj
      IMPORTING
        !ii_context       TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(ro_auftrag) TYPE REF TO zcl_ia_2order
      RAISING
        zcx_ia_2failure .
    CLASS-METHODS add_schicht_tab
      IMPORTING
        !io_schicht      TYPE REF TO zcl_ia_2workshift
      CHANGING
        !Ci_context      TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(rv_return) TYPE boolean .
    CLASS-METHODS add_gantt_tab
      IMPORTING
        !iv_perim   TYPE string
        !ii_context TYPE REF TO if_wd_context_node .
    CLASS-METHODS refresh_popin_jobpool
      IMPORTING
        !io_event   TYPE REF TO cl_wd_custom_event
        !ii_context TYPE REF TO if_wd_context_node .
    CLASS-METHODS mark_einzelkapas_by_aufnr
      IMPORTING
        !ii_context TYPE REF TO if_wd_context_node
        !iv_aufnr   TYPE aufnr
        !iv_image   TYPE zia_2_image_for_visualization DEFAULT zif_ia_2_wd_indiv_capacity=>mc_image_selected .
    CLASS-METHODS set_arbst_as_selected
      IMPORTING
        !is_arbst   TYPE zia_2_work_area_wd_s
        !ii_context TYPE REF TO if_wd_context_node .
    CLASS-METHODS is_ready_to_remove_qualifs
      IMPORTING
        !ii_context     TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(rv_value) TYPE abap_bool .
    CLASS-METHODS get_qualifications_to_remove
      IMPORTING
        !ii_context          TYPE REF TO if_wd_context_node
      RETURNING
        VALUE(ri_collection) TYPE REF TO if_object_collection .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      tt_objects TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY .

    CONSTANTS mc_wdctx_arbst_osn TYPE string VALUE 'ARBST_OSN' ##NO_TEXT.
    CONSTANTS mc_wdctx_arbst_oss TYPE string VALUE 'ARBST_OSS' ##NO_TEXT.
    CONSTANTS mc_wdctx_arbst_tunnel TYPE string VALUE 'ARBST_TUNNEL' ##NO_TEXT.
    CONSTANTS mc_wdctx_arbst_vis TYPE string VALUE 'ARBST_VIS' ##NO_TEXT.
    CONSTANTS mc_wdctx_auftraege TYPE string VALUE 'AUFTRAEGE' ##NO_TEXT.
    CONSTANTS mc_wdctx_auftrage_alv TYPE string VALUE 'AUFTRAEGE_ALV' ##NO_TEXT.
    CONSTANTS mc_wdctx_btg_osn TYPE string VALUE 'BTG_OSN' ##NO_TEXT.
    CONSTANTS mc_wdctx_btg_oss TYPE string VALUE 'BTG_OSS' ##NO_TEXT.
    CONSTANTS mc_wdctx_btg_tunnel TYPE string VALUE 'BTG_TUNNEL' ##NO_TEXT.
    CONSTANTS mc_wdctx_jobpool TYPE string VALUE 'JOBPOOL' ##NO_TEXT.
    CONSTANTS mc_wdctx_schichtdetails TYPE string VALUE 'SCHICHTDETAILS' ##NO_TEXT.
    CONSTANTS mc_wdctx_schichtplan TYPE string VALUE 'SCHICHTPLAN' ##NO_TEXT.
    CONSTANTS mc_wdctx_tabs_schichten TYPE string VALUE 'TABS_SCHICHTEN' ##NO_TEXT.

    CLASS-METHODS deselect_all_arbst
      IMPORTING
        !it_arbst TYPE zia_2_work_area_wd_t
        !Ii_NODE  TYPE REF TO if_wd_context_node .
    CLASS-METHODS get_unique_collection
      IMPORTING
        !it_objects          TYPE tt_objects
      RETURNING
        VALUE(ri_collection) TYPE REF TO if_object_collection .
    CLASS-METHODS read_arbst_osn
      IMPORTING
        !is_arbst     TYPE zia_2_work_area_wd_s
      CHANGING
        !ct_arbst_osn TYPE tt_ELEMENTS_ARBST_OSN .
    CLASS-METHODS read_arbst_tunnel
      IMPORTING
        !is_arbst        TYPE zia_2_work_area_wd_s
      CHANGING
        !ct_arbst_tunnel TYPE tt_ELEMENTS_ARBST_TUNNEL .
    CLASS-METHODS read_arbst_oss
      IMPORTING
        !is_arbst     TYPE zia_2_work_area_wd_s
      CHANGING
        !ct_arbst_oss TYPE tt_ELEMENTS_ARBST_OSN .
    CLASS-METHODS read_btg_osn
      IMPORTING
        !is_arbst   TYPE zia_2_work_area_wd_s
      CHANGING
        !ct_btg_osn TYPE tt_ELEMENTS_BTG_OSN .
    CLASS-METHODS read_btg_tunnel
      IMPORTING
        !is_arbst      TYPE zia_2_work_area_wd_s
      CHANGING
        !ct_btg_tunnel TYPE tt_ELEMENTS_BTG_TUNNEL .
ENDCLASS.



CLASS ZCL_IA_2CONTEXT_HELPER IMPLEMENTATION.
* Implementation details omitted for brevity
ENDCLASS.
