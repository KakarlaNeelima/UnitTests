***----------------------------------------------------------------------*
*** SBB AG, SAP CCC-IT, BERN/BERNE/BERNA
***----------------------------------------------------------------------*
***
***-----------ÄNDERUNGSDOKUMENTATION / DOCUMENTATION OF CHANGES----------*
*** VERSION SAP-REL    DATUM / DATE      ENTWICKLER / DEVELOPER
*** BESCHREIBUNG / DESCRIPTION:RETURNS THE BLOCKING SECTION TABLE FOR
*** THE SHORT TEXT
***----------------------------------------------------------------------*
*** >000<   7.50       16.05.2025        TCS / SIVASURYA KUCHERLA
***PROGRAMMERSTELLUNG / CREATION OF PROGRAM
**
***----------------------------------------------------------------------*
*** >001<   7.50       TT.MM.JJJJ        FIRMA(COMPANY) / NAME(NAME)
***         ...
***----------------------------------------------------------------------*
METHOD get_sp_ktext_tab.
  CONSTANTS: lc_sort_asc    TYPE string VALUE 'ASCENDING',
             lc_sort_desc   TYPE string VALUE 'DESCENDING',
             lc_zid_eiz_sed TYPE zia_2_id_eiz VALUE 10,
             lc_zid_eiz_fad TYPE zia_2_id_eiz VALUE 20,
             lc_as_prefix_n TYPE zia_2_met_as_name_prefix VALUE 'N',
##NEEDED             lc_as_prefix_s TYPE zia_2_met_as_name_prefix VALUE 'S'.

  DATA: lt_as_sort    TYPE tt_as_km_sort,
        lv_perim      TYPE string,
        lv_zid_eiz    TYPE zia_2_id_eiz,
        lv_zid_eiz_as TYPE zia_2_id_eiz.

  DATA(lt_kenzchn_btg) = VALUE tt_pneu_kennzeichen( ).

  CHECK go_schicht IS BOUND.
  DATA(lo_auftrag) = me->get_auftrag( iv_index = 1 ).
  lv_perim = COND #( WHEN lo_auftrag IS BOUND THEN lo_auftrag->get_data( )-zzperi ELSE go_schicht->get_data( )-zzperi ).

  DATA(ls_zugangsarten) = me->get_zugangsarten( ).
  DATA(lo_arbstelle_i) = CAST cl_object_collection_iterator( go_schicht->get_arbeitsstellen( )->get_values_iterator( ) ).

  WHILE lo_arbstelle_i->has_next( ) = abap_true.
    DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).
    IF lo_arbstelle->is_btg( ).
      DATA(lt_btg_kennzeichen) = lo_arbstelle->get_pneu_kennzeichen( ).
      IF lt_btg_kennzeichen IS NOT INITIAL.
        DATA lv_btg_index TYPE zia_2_index.
        CLEAR lv_btg_index.
        lo_arbstelle->get_btg( IMPORTING ev_index = lv_btg_index ).
        APPEND VALUE #( zarbstbez = lt_btg_kennzeichen[ 1 ]-zarbstbez
                        index = lv_btg_index ) TO lt_kenzchn_btg.
      ENDIF.
      CONTINUE.
    ENDIF.
    lv_zid_eiz_as = me->determine_zid_eiz_value(
      iv_default = lo_arbstelle->get_data( )-zid_eiz
      iv_prefix = lo_arbstelle->get_data( )-prefix_met_as
      iv_use_conditon = lo_arbstelle->has_met( ) ).

    lv_zid_eiz = gs_arbeitsstelle-zid_eiz.
    IF gs_arbeitsstelle-prefix_met_as IS NOT INITIAL.
      lv_zid_eiz = COND #( WHEN me->get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_zid_eiz_sed ELSE lc_zid_eiz_fad ).
    ENDIF.

    DATA(ls_data1) = lo_arbstelle->get_data( ).
    IF lv_zid_eiz = lv_zid_eiz_as.
      lt_as_sort = VALUE #( BASE lt_as_sort ( zarbstl = ls_data1-zarbstl km_max = COND #( WHEN lv_zid_eiz = lc_zid_eiz_sed THEN ls_data1-zkmin ELSE ls_data1-zkmax ) ) ).
    ENDIF.
  ENDWHILE.

  SORT lt_kenzchn_btg BY zarbstbez index.
  DELETE ADJACENT DUPLICATES FROM lt_kenzchn_btg COMPARING ALL FIELDS.

  " Process and adjust data
  DATA(lt_map_sp_as) = me->get_map_sp_as( abap_true ).
**  DATA(lv_sort_order) = COND #( WHEN lv_perim = zif_ia_2_constant=>mc_perim-cbt THEN lc_sort_desc
**                          WHEN has_met( ) THEN COND #( WHEN get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_sort_desc ELSE lc_sort_asc )
**                          ELSE lc_sort_asc ).
  DATA(lv_sort_order) = COND #( WHEN lv_perim =  zif_ia_2_constant=>mc_perim-cbt THEN lc_sort_desc
                           WHEN has_met( )
                           THEN COND #( WHEN get_data( )-prefix_met_as = lc_as_prefix_n THEN lc_sort_desc ELSE lc_sort_asc )
                           ELSE COND #( WHEN get_data( )-zid_eiz = lc_zid_eiz_sed       THEN lc_sort_desc ELSE lc_sort_asc ) ).
*
*  SORT lt_as_sort BY km_max % CASE lv_sort_order WHEN lc_sort_desc THEN DESCENDING ELSE ASCENDING ENDCASE.
  IF lv_sort_order = lc_sort_desc.
    SORT lt_as_sort BY km_max DESCENDING.
  ELSE.
    SORT lt_as_sort BY km_max.
  ENDIF.

  IF ( line_exists( lt_map_sp_as[ zugangsart = '1' ] ) OR ls_zugangsarten-schiene = abap_true ) AND me->is_schiene( ).
    et_data = VALUE #( BASE et_data (
      position = lines( et_data ) + 1
      index = line_index( lt_as_sort[ zarbstl = me->gs_arbeitsstelle-zarbstl ] )
      zugangsart = '1'
      prefix = COND #( WHEN lv_perim = 'GBT' AND me->gs_arbeitsstelle-zid_eiz = 10 THEN 'N' WHEN lv_perim = 'GBT' AND me->gs_arbeitsstelle-zid_eiz = 20 THEN 'S' WHEN lv_perim = 'CBT' THEN 'C' ) ) ).
  ENDIF.

  IF ( line_exists( lt_map_sp_as[ zugangsart = '2' ] ) OR ls_zugangsarten-pneu = abap_true ).
    IF NOT me->is_btg( ).
      LOOP AT me->get_pneu_kennzeichen( ) ASSIGNING FIELD-SYMBOL(<ls_data>).
        " Reserve the existing BTG positions for this Street prefix.
        DATA(lv_btg_count) = REDUCE i(
          INIT lv_count = 0
          FOR ls_btg IN lt_kenzchn_btg
          WHERE ( zarbstbez = <ls_data>-zarbstbez )
          NEXT lv_count = lv_count + 1 ).
        DATA(lv_street_index) = lv_btg_count +
          line_index( lt_as_sort[ zarbstl = me->gs_arbeitsstelle-zarbstl ] ).
        CHECK NOT line_exists( et_data[ prefix = <ls_data>-zarbstbez index = lv_street_index zugangsart = '2' ] ).
        et_data = VALUE #( BASE et_data (
                           position   = lines( et_data ) + 1
                           prefix     = <ls_data>-zarbstbez
                           index      = lv_street_index
                           zugangsart = '2' ) ).
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF me->is_btg( ).   "Compare with other AS-BTG in Schicht (for the same Kenneichen ) to get INDEX
    DATA(lt_kennzeichen_cur) = me->get_pneu_kennzeichen( ).
    IF lt_kennzeichen_cur IS NOT INITIAL.
      DATA(lv_kennzeichen_btg) = lt_kennzeichen_cur[ 1 ]-zarbstbez.
      DELETE lt_kenzchn_btg WHERE zarbstbez <> lv_kennzeichen_btg.
      me->get_btg( IMPORTING ev_index = DATA(lv_index) ).
      IF lv_index IS NOT INITIAL.
        et_data = VALUE #( BASE et_data ( position   = lines( et_data ) + 1
                                          prefix     = lv_kennzeichen_btg
                                          index      = line_index( lt_kenzchn_btg[ index = lv_index ] )
                                          zugangsart = '2' ) ).
      ENDIF.
    ENDIF.
  ENDIF.


  SORT et_data BY position.
ENDMETHOD.                                               "#EC CI_VALPAR