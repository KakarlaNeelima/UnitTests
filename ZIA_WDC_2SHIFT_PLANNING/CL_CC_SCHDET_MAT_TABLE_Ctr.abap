class CL_CC_SCHDET_MAT_TABLE_Ctr implementation.
 
*=======================
method 
Constructor. "#EC NEEDED
*=======================
" Do NOT modify the Constructor, any changes will not be saved !
 
  Me->Wd_This =    Wd_This.
  Me->Wd_Context = Wd_Context.
  Me->Wd_Comp_Controller = Wd_This->get_ComponentController_Ctr( ).
  Me->Wd_Assist =    Wd_Assist.
endmethod.
 
* +-------------------------------------------------------------------+
* |  general methods                                                  |
* +-------------------------------------------------------------------+

method WDDOEXIT . "#EC NEEDED
endmethod.

method WDDOINIT . "#EC NEEDED
endmethod.

METHOD append_table_lvl_arb .
  DATA(lo_schicht)     = io_arbstl->get_schicht( ).
  DATA(ls_schicht)     = lo_schicht->get_data( ).
  DATA(lv_supply_type) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_parameter( )->get_data( )-supply_type.

  IF lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung.
    lv_supply_type = lo_schicht->get_parameter( )->get_data( )-supply_type.
    APPEND VALUE #( ) TO ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    <ls_data>-level        = zif_ia_2_wd_mat_table=>mc_level-lvl_1.
    <ls_data>-o_arbstl     = io_arbstl.
    <ls_data>-zarbstl      = io_arbstl->get_id( ).
    <ls_data>-bezeichnung  = |{ io_arbstl->get_kurztext( ) } / | &
                             |{ zcl_ia_2utilities=>get_dats_as_formated_string( ls_schicht-start_datum ) } / | &
                             |{ ls_schicht-start_zeit(2) }:{ ls_schicht-start_zeit+2(2) } / | &
                             |{ ls_schicht-end_zeit(2) }:{ ls_schicht-end_zeit+2(2) } / | &
                             |{ lv_supply_type } - | &
                             |{ COND #( WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-versorgung
                                        THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/SUPPLY' )
                                        WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-entsorgung
                                        THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/DISPOSAL' )
                                        WHEN lv_supply_type = zif_ia_2_constant=>mc_supply_type-keine_fahrt
                                        THEN cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/NO_RIDE' ) ) }|.
    <ls_data>-path         = |/{ ls_schicht-zschicht }/{ io_arbstl->get_kurztext( ) }|.
    <ls_data>-supply_type  = lv_supply_type.
  ELSE.
    "Normal Schicht
    APPEND VALUE #( ) TO ct_data ASSIGNING <ls_data>.
    <ls_data>-level        = zif_ia_2_wd_mat_table=>mc_level-lvl_1.
    <ls_data>-o_arbstl     = io_arbstl.
    <ls_data>-zarbstl      = io_arbstl->get_id( ).
    <ls_data>-bezeichnung  = io_arbstl->get_kurztext( ).
    <ls_data>-path         = |/{ ls_schicht-zschicht }/{ io_arbstl->get_kurztext( ) }|.
  ENDIF.

ENDMETHOD.

METHOD append_table_lvl_auf .
  DATA lo_auftrag_i TYPE REF TO cl_object_collection_iterator.
  DATA lo_auftrag   TYPE REF TO zcl_ia_2order.


  lo_auftrag_i ?= io_arbstl->get_auftraege( )->get_values_iterator( ).
  WHILE lo_auftrag_i->has_next( ).
    lo_auftrag ?= lo_auftrag_i->get_next( ).

    APPEND VALUE #( ) TO ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    <ls_data>-level         = zif_ia_2_wd_mat_table=>mc_level-lvl_2.
    <ls_data>-o_arbstl      = io_arbstl.
    <ls_data>-o_auftrag     = lo_auftrag.
    <ls_data>-zarbstl       = io_arbstl->get_id( ).
    <ls_data>-aufnr         = lo_auftrag->get_data( )-aufnr.
    <ls_data>-bezeichnung   = lo_auftrag->get_data( )-ktext.
    <ls_data>-fzg_belad     = wd_this->get_blad_fahrzeuge_as_text( io_arbstl = io_arbstl iv_aufnr = lo_auftrag->get_data( )-aufnr ).
    <ls_data>-parent_path   = wd_this->get_table_path( iv_level = zif_ia_2_wd_mat_table=>mc_level-lvl_1 io_arbstl = io_arbstl ).
    <ls_data>-path          = wd_this->get_table_path( iv_level = zif_ia_2_wd_mat_table=>mc_level-lvl_2 io_arbstl = io_arbstl io_auftrag = lo_auftrag ).
    <ls_data>-supply_type   = io_arbstl->get_schicht( )->get_parameter( )->get_data( )-supply_type.
  ENDWHILE.

ENDMETHOD.

METHOD append_table_lvl_mat .
  DATA lo_auftrag_i TYPE REF TO cl_object_collection_iterator.
  DATA lo_auftrag   TYPE REF TO zcl_ia_2order.
  DATA(lt_mat_fzg)  = VALUE wd_this->elements_mat_fzg( ).


  wd_context->get_child_node( name = wd_this->wdctx_mat_fzg )->get_static_attributes_table( IMPORTING table = lt_mat_fzg ).

  lo_auftrag_i ?= io_arbstl->get_auftraege( )->get_values_iterator( ).
  WHILE lo_auftrag_i->has_next( ).
    lo_auftrag ?= lo_auftrag_i->get_next( ).
    ASSIGN ct_data[ zarbstl = io_arbstl->get_id( ) aufnr = lo_auftrag->get_id( ) ] TO FIELD-SYMBOL(<ls_data_parent>) ##WARN_OK.
    CHECK sy-subrc = 0.

    TRY.
        zcl_ia_2lofpm_clh_app=>get_instance( iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
        DATA(lt_comp) = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent( )->get_object( iv_aufnr = lo_auftrag->get_data( )-aufnr )->get_components( ).
      ##NO_HANDLER     CATCH zcx_ia_2lofpm.
      ##NO_HANDLER    CATCH cx_static_check.
        CONTINUE.
    ENDTRY.

*    LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
    LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>) WHERE requirement_quantity > 0.
      ##NEEDED     DATA(lv_weight_mat)      = VALUE brgew( ).
      ##NEEDED     DATA(lv_volume_mat)      = VALUE volum( ).
      DATA(ls_resb)            = wd_this->get_resb_data( iv_rsnum = <ls_comp>-reserv_no iv_rspos = <ls_comp>-res_item iv_rsart = <ls_comp>-res_type ).

      CHECK ls_resb-rsnum IS NOT INITIAL.
      CHECK ls_resb-xloek IS INITIAL.

      DATA(ls_mat_fzg)  = VALUE #( lt_mat_fzg[ "zarbstl = io_arbstl->get_id( )
                                               aufnr   = lo_auftrag->get_data( )-aufnr
                                               matnr   = <ls_comp>-material
                                               rsnum   = ls_resb-rsnum
                                               rspos   = ls_resb-rspos  ] OPTIONAL ).

      APPEND VALUE #( ) TO ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
      <ls_data>-level         = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
      <ls_data>-zarbstl       = io_arbstl->get_id( ).
      <ls_data>-aufnr         = lo_auftrag->get_data( )-aufnr.
      <ls_data>-matnr         = <ls_comp>-material.
      <ls_data>-maktx         = <ls_comp>-matl_desc.
      <ls_data>-rsnum         = ls_resb-rsnum.
      <ls_data>-rspos         = ls_resb-rspos.
      <ls_data>-fzg_pos       = ls_mat_fzg-orientierung.
      <ls_data>-ablad         = ls_resb-ablad.
      <ls_data>-kzear         = ls_resb-kzear.
      <ls_data>-req_quan      = <ls_comp>-requirement_quantity.
      <ls_data>-req_unit      = <ls_comp>-requirement_quantity_unit.
      <ls_data>-o_arbstl      = io_arbstl.
      <ls_data>-o_auftrag     = lo_auftrag.
      <ls_data>-bezeichnung   = |{ <ls_comp>-requirement_quantity } { <ls_comp>-requirement_quantity_unit } { <ls_comp>-matl_desc }|.
      <ls_data>-supply_type   = io_arbstl->get_schicht( )->get_parameter( )->get_data( )-supply_type.

      <ls_data>-fzg_belad = get_blad_fahrzeuge_as_text(
        io_arbstl = io_arbstl
        iv_aufnr  = lo_auftrag->get_data( )-aufnr
        iv_matnr  = CONV matnr( <ls_comp>-material )
        iv_rsnum  = <ls_data>-rsnum
        iv_rspos  = <ls_data>-rspos ).

      <ls_data>-parent_path = get_table_path(
        iv_level   = zif_ia_2_wd_mat_table=>mc_level-lvl_2
        io_arbstl  = io_arbstl
        io_auftrag = lo_auftrag ).

      <ls_data>-path = get_table_path(
        iv_level   = zif_ia_2_wd_mat_table=>mc_level-lvl_3
        io_arbstl  = io_arbstl
        io_auftrag = lo_auftrag
        iv_maktx   = <ls_comp>-matl_desc  ).

      <ls_data>-o_fahrzeug = get_fahrzueg_from_matfzg(
         io_arbstl = <ls_data>-o_arbstl
         iv_aufnr  = <ls_data>-aufnr
         iv_matnr  = <ls_data>-matnr
         iv_rsnum  = <ls_data>-rsnum
         iv_rspos  = <ls_data>-rspos
         iv_fzg_id = ls_mat_fzg-zid_fzg ).
    ENDLOOP.
  ENDWHILE.

ENDMETHOD.

METHOD collect_volume_weight .
  SORT ct_data BY zarbstl aufnr matnr.

  "Collect/sum weight and volume on Auftrag level
  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_auf>) WHERE matnr IS INITIAL.
    LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_mat>) WHERE zarbstl = <ls_data_auf>-zarbstl "#EC CI_NESTED "#EC CI_STDSEQ
                                                            AND aufnr   = <ls_data_auf>-aufnr.
      CHECK <ls_data_mat>-matnr IS NOT INITIAL.
      <ls_data_auf>-weight = <ls_data_auf>-weight + <ls_data_mat>-weight.
      <ls_data_auf>-volume = <ls_data_auf>-volume + <ls_data_mat>-volume.
    ENDLOOP.
  ENDLOOP.

  "Collect/sum weight and volume on Arbeitsstelle level
  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_as>) WHERE aufnr IS INITIAL.
    LOOP AT ct_data ASSIGNING <ls_data_auf> WHERE zarbstl = <ls_data_as>-zarbstl. "#EC CI_NESTED "#EC CI_STDSEQ
      CHECK <ls_data_auf>-matnr IS INITIAL.
      <ls_data_as>-weight = <ls_data_as>-weight + <ls_data_auf>-weight.
      <ls_data_as>-volume = <ls_data_as>-volume + <ls_data_auf>-volume.
    ENDLOOP.
  ENDLOOP.
*  DELETE ct_data WHERE weight = 0.

ENDMETHOD.

METHOD convert_mat_to_matfzg .
  DATA(lt_mat_table) = VALUE zia_2schdet_mat_table_data_t( ).

  IF it_mat_table IS NOT INITIAL.
    lt_mat_table = it_mat_table.
  ENDIF.

  IF is_mat_table IS NOT INITIAL.
    APPEND is_mat_table TO lt_mat_table.
  ENDIF.

  LOOP AT lt_mat_table ASSIGNING FIELD-SYMBOL(<ls_mat_table>).
    DATA(ls_matfzg)        = VALUE zia_2map_matfzg( ).
    ls_matfzg              = CORRESPONDING #( <ls_mat_table> ).
    ls_matfzg-ablad        = wd_this->get_ablad_as_text( io_fahrzeug = io_fahrzeug io_auftrag = <ls_mat_table>-o_auftrag iv_orient = <ls_mat_table>-fzg_pos ).
    ls_matfzg-orientierung = <ls_mat_table>-fzg_pos.
    APPEND ls_matfzg TO rt_matfzg.
  ENDLOOP.

ENDMETHOD.

METHOD copy_ctx_data .
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).

  FIELD-SYMBOLS <lt_data> TYPE wd_this->elements_mat_table_data.

  CLEAR wd_this->mt_mat_table_data_copy.
  IF iv_from_ctx = abap_false.
    ASSIGN it_data TO <lt_data>.
    IF <lt_data> IS NOT INITIAL.
      wd_this->mt_mat_table_data_copy = CORRESPONDING #( <lt_data> ).
      RETURN.
    ENDIF.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  wd_this->mt_mat_table_data_copy =  lt_mat_table_data .

ENDMETHOD.

METHOD copy_expanded_flag .
  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    ASSIGN wd_this->mt_mat_table_data_copy[ path = <ls_data>-path parent_path = <ls_data>-parent_path ] TO FIELD-SYMBOL(<ls_data_copy>).
    CHECK sy-subrc = 0.
    <ls_data>-is_expanded = <ls_data_copy>-is_expanded.
  ENDLOOP.

ENDMETHOD.

METHOD get_ablad_as_text .
  DATA(lv_fzg_reihung)  = VALUE numc2( ).
  DATA(lv_as_text_id)   = VALUE zia_2_arbst( ).
  DATA(lv_intervallart) = VALUE zia_2_intervallart( ).

  IF io_fahrzeug IS NOT BOUND OR
     io_auftrag  IS NOT BOUND.
    RETURN.
  ENDIF.

  DATA(lo_as)      = io_fahrzeug->go_arbeitsstelle.
  lv_intervallart = io_auftrag->get_data( )-zintervall.
  lv_as_text_id   = lo_as->get_text_id( zcl_ia_2utilities2=>mc_zugangsart_schiene ).
  lv_fzg_reihung  = io_fahrzeug->get_reihung( ).

  IF lv_intervallart = zif_ia_2_constant=>mc_intervallart-li.
    rv_data = |{ lv_as_text_id }{ lv_intervallart(1) }.{ lv_fzg_reihung }{ iv_orient }|.
  ELSE.
    rv_data = |{ lv_as_text_id }.{ lv_fzg_reihung }{ iv_orient }|.
  ENDIF.

ENDMETHOD.

METHOD get_blad_fahrzeuge_as_text .
  DATA(lt_mat_fzg_ctx) = VALUE wd_this->elements_mat_fzg( ).
  DATA(lt_mat_fzg)     = VALUE wd_this->elements_mat_fzg( ).
  DATA(lt_fzg_ktext)   = VALUE string_t( ).
  DATA(lv_fzg_ktext)   = VALUE string( ).
  DATA(lv_fzg_reihung) = VALUE numc2( ).

  IF io_arbstl IS NOT BOUND OR
     iv_aufnr  IS INITIAL.
    RETURN.
  ENDIF.

  wd_context->get_child_node( name = wd_this->wdctx_mat_fzg )->get_static_attributes_table( IMPORTING table = lt_mat_fzg_ctx ).
  DATA(lv_as_text_id) = io_arbstl->get_text_id( zcl_ia_2utilities2=>mc_zugangsart_schiene ).

  "Get Fahrzeuge on Auftrag Level (all belonging to Auftrag and all its materials) - LEVEL2
  "If material provided then get Fahrzeuge on Material Level - LEVEL3
  LOOP AT lt_mat_fzg_ctx ASSIGNING FIELD-SYMBOL(<ls_mat_fzg_ctx>) " WHERE zarbstl = io_arbstl->get_id( )
                                                                  "  AND aufnr   = iv_aufnr.
                                                                   WHERE aufnr = iv_aufnr.
    IF iv_matnr IS NOT INITIAL.
      CHECK <ls_mat_fzg_ctx>-matnr = iv_matnr.
    ENDIF.
    IF iv_zid_fzg IS NOT INITIAL.
      CHECK <ls_mat_fzg_ctx>-zid_fzg = iv_zid_fzg.
    ENDIF.
    IF iv_rsnum IS NOT INITIAL.
      CHECK <ls_mat_fzg_ctx>-rsnum = iv_rsnum.
    ENDIF.
    IF iv_rspos IS NOT INITIAL.
      CHECK <ls_mat_fzg_ctx>-rspos = iv_rspos.
    ENDIF.
    APPEND <ls_mat_fzg_ctx> TO lt_mat_fzg.
  ENDLOOP.

  LOOP AT lt_mat_fzg ASSIGNING FIELD-SYMBOL(<ls_mat_fzg>). "WHERE zarbstl = io_arbstl->get_id( ).
    DATA(lo_fahrzeug) = get_fahrzueg_from_matfzg(
      io_arbstl = io_arbstl
      iv_matnr  = <ls_mat_fzg>-matnr
      iv_aufnr  = <ls_mat_fzg>-aufnr
      iv_rsnum  = <ls_mat_fzg>-rsnum
      iv_rspos  = <ls_mat_fzg>-rspos
      iv_fzg_id = <ls_mat_fzg>-zid_fzg ).
    CHECK lo_fahrzeug IS BOUND.
    lv_fzg_reihung = lo_fahrzeug->get_reihung( ).
    lv_fzg_ktext   = |{ lv_as_text_id }.{ lv_fzg_reihung }|.
    APPEND lv_fzg_ktext TO lt_fzg_ktext.
  ENDLOOP.

  SORT lt_fzg_ktext.
  DELETE ADJACENT DUPLICATES FROM lt_fzg_ktext.

  LOOP AT lt_fzg_ktext ASSIGNING FIELD-SYMBOL(<lv_fzg_ktext>).
    rv_data = COND #( WHEN rv_data IS NOT INITIAL THEN |{ rv_data };| ELSE rv_data ).
    rv_data = |{ rv_data }{ <lv_fzg_ktext> }|.
  ENDLOOP.

  CONDENSE rv_data.

ENDMETHOD.

METHOD get_data_from_selection .
  DATA(ls_mat_table_sel) = VALUE wd_this->element_mat_table_data( ).
  DATA(ls_mat_table)     = VALUE wd_this->element_mat_table_data( ).
  DATA(lt_mat_table)     = VALUE wd_this->elements_mat_table_data( ).
  DATA(lt_sel_el)        = VALUE wdr_context_element_set( ).
  DATA li_sel_el         TYPE REF TO if_wd_context_element.
  DATA li_mat_table_nd   TYPE REF TO if_wd_context_node.


  li_mat_table_nd = wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data ).
  lt_sel_el       = li_mat_table_nd->get_selected_elements( ).
  li_sel_el       = VALUE #( lt_sel_el[ 1 ] OPTIONAL  ).
  li_sel_el->get_static_attributes( IMPORTING static_attributes = ls_mat_table_sel ).
  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data )->get_static_attributes_table( IMPORTING table = lt_mat_table ).

  "Auftrag line was selected - get all materials related to this Auftrag
  IF ls_mat_table_sel-zarbstl IS NOT INITIAL AND
     ls_mat_table_sel-aufnr   IS NOT INITIAL AND
     ls_mat_table_sel-matnr   IS INITIAL.
    LOOP AT lt_mat_table ASSIGNING FIELD-SYMBOL(<ls_mat_table>) WHERE zarbstl         = ls_mat_table_sel-zarbstl
                                                                  AND aufnr           = ls_mat_table_sel-aufnr
                                                                  AND is_drag_allowed = abap_true.
      CHECK <ls_mat_table>-matnr IS NOT INITIAL.
      APPEND <ls_mat_table> TO rt_data.
    ENDLOOP.
  ENDIF.

  "Material line was slelected - get only this material
  IF ls_mat_table_sel-zarbstl IS NOT INITIAL AND
     ls_mat_table_sel-aufnr   IS NOT INITIAL AND
     ls_mat_table_sel-matnr   IS NOT INITIAL AND
     ls_mat_table_sel-is_drag_allowed = abap_true.
    ls_mat_table = VALUE #( lt_mat_table[ zarbstl = ls_mat_table_sel-zarbstl
                                          aufnr   = ls_mat_table_sel-aufnr
                                          matnr   = ls_mat_table_sel-matnr
                                          rsnum   = ls_mat_table_sel-rsnum
                                          rspos   = ls_mat_table_sel-rspos ] OPTIONAL ).
    IF ls_mat_table IS NOT INITIAL.
      APPEND ls_mat_table TO rt_data.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD get_fahrzueg_from_matfzg .
  DATA(lt_mat_fzg) = VALUE wd_this->elements_mat_fzg( ).



  wd_context->get_child_node( name = wd_this->wdctx_mat_fzg )->get_static_attributes_table( IMPORTING table = lt_mat_fzg ).
  DATA(ls_mat_fzg) = VALUE #( lt_mat_fzg[ aufnr   = iv_aufnr
                                          matnr   = iv_matnr
                                          zid_fzg = iv_fzg_id
                                          rsnum   = iv_rsnum
                                          rspos   = iv_rspos
                                          "zarbstl = io_arbstl->get_id( )
                                           ] OPTIONAL ).
  ro_instance = CAST zcl_ia_2vehicle( io_arbstl->get_fahrzeuge( )->get( key = ls_mat_fzg-zid_fzg  ) ).

  IF NOT io_arbstl->get_schicht( )->is_versorgung_schicht( ) AND ro_instance IS NOT BOUND.
    DATA(lo_supply_shift) = io_arbstl->get_schicht( )->get_versorgung_schicht( ).
    IF lo_supply_shift IS BOUND.
      DATA(lo_arbstl_tmp) = zcl_ia_2wrkplace=>get_instance( iv_arbstle_id = ls_mat_fzg-zarbstl
                               iv_schicht_id = lo_supply_shift->get_id( ) ).
      IF lo_arbstl_tmp IS BOUND.
        ro_instance = CAST zcl_ia_2vehicle( lo_arbstl_tmp->get_fahrzeuge( )->get( key = ls_mat_fzg-zid_fzg  ) ).
      ENDIF.
    ENDIF.
  ENDIF.

  IF ro_instance IS NOT BOUND.
    "Most probably it is a Versosrgung Scihcht - Auftrag assigned to Versorgung Fahrzeug
    ls_mat_fzg = VALUE #( lt_mat_fzg[ aufnr   = iv_aufnr
                                      matnr   = iv_matnr
                                      zid_fzg = iv_fzg_id
                                      rsnum   = iv_rsnum
                                      rspos   = iv_rspos
                                      zarbstl = wd_comp_controller->mo_curr_arbstelle->get_id( ) ] OPTIONAL ).
    ro_instance = CAST zcl_ia_2vehicle( wd_comp_controller->mo_curr_arbstelle->get_fahrzeuge( )->get( key = ls_mat_fzg-zid_fzg  ) ).
  ENDIF.

ENDMETHOD.

METHOD get_mat_fzg_data .
  DATA lt_id_arbstl TYPE STANDARD TABLE OF zia_2_id_arbstl WITH DEFAULT KEY.


  CLEAR wd_this->mt_matfzg.

  IF wd_comp_controller->mo_curr_arbstelle IS NOT BOUND.
    RETURN.
  ENDIF.

  DATA(lo_schicht)          = COND #( WHEN io_schicht IS BOUND THEN io_schicht ELSE wd_comp_controller->mo_curr_arbstelle->get_schicht( ) ).
  DATA(lo_arbeitsstellen)   = CAST cl_object_map( lo_schicht->get_arbeitsstellen( ) ).
  DATA(lo_arbeitsstellen_i) = CAST cl_object_collection_iterator( lo_arbeitsstellen->get_values_iterator( ) ).

  "Extract AS IDs
  WHILE lo_arbeitsstellen_i->has_next( ) = abap_true.
    DATA(lo_arbeitsstelle) = CAST zcl_ia_2wrkplace( lo_arbeitsstellen_i->get_next( ) ).
    DATA(lv_id_arbstl) = lo_arbeitsstelle->get_id( ).
    APPEND lv_id_arbstl TO lt_id_arbstl.
  ENDWHILE.

  "Extract AS Ids for Entsorgung and Keine Fahrt Schichts
  IF lo_schicht->is_versorgung_schicht( ).
    DATA(lt_klog_schichten) = lo_schicht->get_keine_logistik_schichten( ).
    LOOP AT lt_klog_schichten ASSIGNING FIELD-SYMBOL(<ls_klog_schichten>).
      lo_arbeitsstellen_i ?=  <ls_klog_schichten>-o_schicht->get_arbeitsstellen( )->get_values_iterator( ).
      WHILE lo_arbeitsstellen_i->has_next( ) = abap_true.
        lo_arbeitsstelle ?= lo_arbeitsstellen_i->get_next( ).
        lv_id_arbstl = lo_arbeitsstelle->get_id( ).
        APPEND lv_id_arbstl TO lt_id_arbstl.
      ENDWHILE.
    ENDLOOP.
  ELSE.
    DATA(lo_supply_shift) = lo_schicht->get_versorgung_schicht( ).
    IF lo_supply_shift IS BOUND.
      lo_arbeitsstellen = CAST cl_object_map( lo_supply_shift->get_arbeitsstellen( ) ).
      lo_arbeitsstellen_i = CAST cl_object_collection_iterator( lo_arbeitsstellen->get_values_iterator( ) ).
      "Extract AS IDs
      WHILE lo_arbeitsstellen_i->has_next( ) = abap_true.
        lo_arbeitsstelle = CAST zcl_ia_2wrkplace( lo_arbeitsstellen_i->get_next( ) ).
        lv_id_arbstl = lo_arbeitsstelle->get_id( ).
        APPEND lv_id_arbstl TO lt_id_arbstl.
      ENDWHILE.
    ENDIF.
  ENDIF.

  "Get MatFzg data
  IF lt_id_arbstl IS NOT INITIAL.
*    SELECT *
*      FROM zia_2map_matfzg
*      INTO CORRESPONDING FIELDS OF TABLE @rt_data
*      FOR ALL ENTRIES IN @lt_id_arbstl
*      WHERE zarbstl = @lt_id_arbstl-table_line.
    rt_data =  wd_assist->get_vehicle_material( it_id_arbstl = lt_id_arbstl ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD get_resb_data .
  DATA lt_rsnum TYPE RANGE OF rsnum.
  DATA lt_rspos TYPE RANGE OF rspos.
  DATA lt_rsart TYPE RANGE OF rsart.
  DATA lt_aufnr TYPE RANGE OF aufnr.


  lt_rsnum = COND #( WHEN iv_rsnum IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_rsnum ) ) ).
  lt_rspos = COND #( WHEN iv_rspos IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_rspos ) ) ).
  lt_rsart = COND #( WHEN iv_rsart IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_rsart ) ) ).
  lt_aufnr = COND #( WHEN iv_aufnr IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_aufnr ) ) ).

*  SELECT SINGLE rsnum, rspos, kzear, ablad, xloek
*    FROM resb INTO CORRESPONDING FIELDS OF @rs_data
*    WHERE rsnum IN @lt_rsnum
*      AND rspos IN @lt_rspos
*      AND rsart IN @lt_rsart
*      AND aufnr IN @lt_aufnr.
  rs_data = wd_assist->get_resb_data( it_aufnr = lt_aufnr
                                      it_rsart = lt_rsart
                                      it_rsnum = lt_rsnum
                                      it_rspos = lt_rspos ).

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

ENDMETHOD.

METHOD get_table_path .
  IF io_arbstl IS NOT BOUND.
    RETURN.
  ENDIF.

  "Get path for Arbeitsstelle - Level #1
  IF iv_level = zif_ia_2_wd_mat_table=>mc_level-lvl_1.
    rv_path = |/{ io_arbstl->get_schicht( )->get_id( ) }/{ io_arbstl->get_kurztext( ) }|.
    RETURN.
  ENDIF.

  "Get path for Auftrag - Level #2
  IF iv_level = zif_ia_2_wd_mat_table=>mc_level-lvl_2.
    IF io_auftrag IS BOUND.
      rv_path = |/{ io_arbstl->get_schicht( )->get_id( ) }/{ io_arbstl->get_kurztext( ) }/{ io_auftrag->get_data( )-aufnr }|.
    ENDIF.
    RETURN.
  ENDIF.

  "Get path for Material - Level #3
  IF iv_level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    IF io_auftrag IS BOUND.
      rv_path = |/{ io_arbstl->get_schicht( )->get_id( ) }/{ io_arbstl->get_kurztext( ) }/{ io_auftrag->get_data( )-aufnr }/{ iv_maktx }|.
    ENDIF.
    RETURN.
  ENDIF.

ENDMETHOD.

METHOD get_volume_weight_by_matnr .

  CLEAR: ev_volume, ev_weight.

  TRY.
      zcl_ia_2utilities=>get_volum_gew_by_matnr(
         EXPORTING
           iv_matnr      = iv_matnr
           iv_gew_unit   = iv_weight_unit
           iv_volum_unit = iv_volume_unit
         IMPORTING
           ev_gew        = ev_weight
           ev_volum      = ev_volume ).
    CATCH zcx_ia_2failure.
      RETURN.
  ENDTRY.

ENDMETHOD.

METHOD invalidate_mat_fzg .

  TRY.
      wd_context->get_child_node( name = wd_this->wdctx_mat_fzg )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD invalidate_mat_table_data .

  wd_this->copy_ctx_data( iv_from_ctx = abap_true ).

  TRY.
      wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data )->invalidate( ).
    ##NO_HANDLER   CATCH cx_sy_ref_is_initial.
  ENDTRY.

ENDMETHOD.

METHOD on_delete_fahrzeug .
  DATA li_context_el      TYPE REF TO if_wd_context_element.
  DATA(ls_mat_table_data) = VALUE wd_this->element_mat_table_data( ).


  li_context_el = io_event->get_context_element( `CONTEXT_ELEMENT` ).
  li_context_el->get_static_attributes( IMPORTING static_attributes = ls_mat_table_data ).

  IF ls_mat_table_data-o_fahrzeug IS BOUND.
    DATA(lv_status) = ls_mat_table_data-o_fahrzeug->remove_material(
      EXPORTING
        iv_aufnr = ls_mat_table_data-aufnr
        iv_matnr = ls_mat_table_data-matnr
        iv_rsnum = ls_mat_table_data-rsnum
        iv_rspos = ls_mat_table_data-rspos ).
    IF lv_status = abap_true.
      wd_this->invalidate_mat_fzg( ).
      wd_this->invalidate_mat_table_data( ).
    ENDIF.
  ENDIF.

ENDMETHOD.

METHOD on_fzg_pos_selected .
  DATA(lt_dd_fzg_pos)     = VALUE wd_this->elements_mt_dd_fzg_pos( ).
  DATA(ls_mat_table_data) = VALUE wd_this->element_mat_table_data( ).

  DATA(li_mat_table_elem)  = io_event->get_context_element( name = 'CONTEXT_ELEMENT' ).
  DATA(lv_mat_table_index) = io_event->get_int( name = 'INDEX' ).

  li_mat_table_elem->get_child_node( name = wd_this->wdctx_mt_dd_fzg_pos )->get_static_attributes_table( IMPORTING table  = lt_dd_fzg_pos ).
  li_mat_table_elem->get_static_attributes( IMPORTING static_attributes = ls_mat_table_data ).
  ls_mat_table_data-fzg_pos = VALUE #( lt_dd_fzg_pos[ lv_mat_table_index ]-fzg_pos OPTIONAL ).

  IF ls_mat_table_data-o_fahrzeug IS BOUND.
    DATA(lt_matfzg) = wd_this->convert_mat_to_matfzg( io_fahrzeug = ls_mat_table_data-o_fahrzeug is_mat_table = ls_mat_table_data ).
    DATA(ls_matfzg) = VALUE #( lt_matfzg[ 1 ] OPTIONAL ).
    ls_mat_table_data-o_fahrzeug->add_material( EXPORTING is_data = ls_matfzg ).
    li_mat_table_elem->set_static_attributes( EXPORTING static_attributes = ls_mat_table_data ).
  ENDIF.

ENDMETHOD.

METHOD on_toggle .
  DATA(ls_mat_table_data) = VALUE wd_this->element_mat_table_data( ).
  DATA li_context_el      TYPE REF TO if_wd_context_element.

  wd_this->show_hide_action_column( io_event ).

  "Update backup table - expand/collapse
  li_context_el = io_event->get_context_element( `CONTEXT_ELEMENT` ).
  li_context_el->get_static_attributes( IMPORTING static_attributes = ls_mat_table_data ).
  ASSIGN wd_this->mt_mat_table_data_copy[ path = ls_mat_table_data-path parent_path = ls_mat_table_data-parent_path ] TO FIELD-SYMBOL(<ls_data_copy>).
  IF sy-subrc = 0.
    <ls_data_copy>-is_expanded = ls_mat_table_data-is_expanded.
  ENDIF.

ENDMETHOD.

METHOD process_event .
  CASE io_event->get_name( ).
    WHEN 'ON_ACTION'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'BTN_MAT_TABLE_FZG_DELETE'.
          wd_this->on_delete_fahrzeug( io_event ).
        WHEN  OTHERS.
          RETURN.
      ENDCASE.
    WHEN 'ON_TOGGLE'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'MAT_TABLE_AGR_TABLE_COL'.
          wd_this->on_toggle( io_event ).
        WHEN OTHERS.
          RETURN.
      ENDCASE.
    WHEN 'ON_SELECT'.
      CASE io_event->get_string( EXPORTING name = 'ID').
        WHEN 'DD_MT_FZG_POS'.
          wd_this->on_fzg_pos_selected( io_event ).
      ENDCASE.
  ENDCASE.

ENDMETHOD.

METHOD set_dd_tags .
  DATA(lt_mat_fzg) = VALUE wd_this->elements_mat_fzg( ).


  wd_context->get_child_node( name = wd_this->wdctx_mat_fzg )->get_static_attributes_table( IMPORTING table = lt_mat_fzg ).
  DATA(lo_curr_schicht) = wd_comp_controller->mo_curr_arbstelle->get_schicht( ).

  "Set drag tag to all table entries - this must be the case for a table with an aggregation, otherwise it won't work
  LOOP  AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    <ls_data>-drag_tags = zif_ia_2_wd_mat_table=>mc_dd_flavor_move.
  ENDLOOP.

  "Set Is Drag Allowed Flag on material level
  LOOP AT ct_data ASSIGNING <ls_data> WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    "Check if materials is already assigned to some Fzg
    IF line_exists( lt_mat_fzg[ aufnr = <ls_data>-aufnr
                                matnr = <ls_data>-matnr
                                rsnum = <ls_data>-rsnum
                                rspos = <ls_data>-rspos ] ).
      CONTINUE.
    ENDIF.

    "Check Final Issue for Reservation flag
    IF <ls_data>-kzear <> abap_false.
      CONTINUE.
    ENDIF.

    IF <ls_data>-o_auftrag->get_data( )-zzzugangsart = zcl_ia_2utilities2=>mc_zugangsart_strasse.
      CONTINUE.
    ENDIF.

    "For Keine Fahrt and Entsorgung Schichts the drag and drop is not allowed -
    " allowed only in Versorgung Schicht
    IF <ls_data>-o_auftrag->get_data( )-zintervall = zif_ia_2_constant=>mc_intervallart-li.
*    IF zif_ia_2_constant=>mc_intervallart-li = 'TS'.
      IF <ls_data>-supply_type IS NOT INITIAL.
        IF lo_curr_schicht->get_parameter( )->get_data( )-supply_type <> zif_ia_2_constant=>mc_supply_type-versorgung
          AND lo_curr_schicht->get_parameter( )->get_data( )-supply_type <> 'X'.
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDIF.

    <ls_data>-is_drag_allowed = abap_true.
  ENDLOOP.

  "Set Set Is Drag Allowed Flag on Auftrag level - if all materials related to Auftrag cannot be moved then Auftrag cannot be moved as well
  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_prnt>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_2.
    CLEAR <ls_data_prnt>-is_drag_allowed.
    LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_child>) WHERE parent_path = <ls_data_prnt>-path. "#EC CI_NESTED "#EC CI_STDSEQ
      CHECK <ls_data_child>-is_drag_allowed IS NOT INITIAL.
      <ls_data_prnt>-is_drag_allowed = abap_true.
      EXIT.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.

METHOD set_ui_settings .
  IF wd_comp_controller->mo_curr_arbstelle IS BOUND.
    DATA(lv_status) = wd_comp_controller->mo_curr_arbstelle->get_schicht( )->get_status( ).
  ENDIF.
  " >001< + end

  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    "General settings
    <ls_data>-is_child_loaded       = COND #( WHEN line_exists( ct_data[ parent_path = <ls_data>-path ] )     THEN abap_true ELSE abap_false ).
    <ls_data>-is_leaf               = COND #( WHEN NOT line_exists( ct_data[ parent_path = <ls_data>-path ] ) THEN abap_true ELSE abap_false ).
    <ls_data>-design_row            = 00.
    <ls_data>-color                 = cl_wd_text_view=>e_semantic_color-standard.
    <ls_data>-is_tv_weight_visible  = abap_true.
    <ls_data>-is_tv_volume_visible  = abap_true.
    <ls_data>-is_tv_auftrag_visible = abap_true.

    "--------------- Level 2 - Auftrag ---------------
    IF <ls_data>-level = zif_ia_2_wd_mat_table=>mc_level-lvl_2.
      <ls_data>-color = COND #( WHEN <ls_data>-is_drag_allowed = abap_false THEN cl_wd_text_view=>e_semantic_color-diminished ELSE <ls_data>-color ).

      "Set visibility of action column
      IF <ls_data>-is_expanded = abap_true.
        LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data_child>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_3. "#EC CI_NESTED "#EC CI_STDSEQ
          CHECK <ls_data_child>-matnr IS NOT INITIAL.
          cs_data_ui-is_col_action_visible = COND #( WHEN wd_this->mv_edit_mode = abap_false THEN abap_false ELSE abap_true ).
          EXIT.
        ENDLOOP.
      ENDIF.
    ENDIF.

    "--------------- Level 3 - Material ---------------
    IF <ls_data>-level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
      <ls_data>-color              = COND #( WHEN <ls_data>-is_drag_allowed = abap_false THEN cl_wd_text_view=>e_semantic_color-diminished ELSE <ls_data>-color ).
      <ls_data>-is_btn_del_visible = COND #( WHEN <ls_data>-o_fahrzeug IS BOUND THEN abap_true ELSE abap_false ).

      "Set enabed and read only flag for Fzg Pos dropdown list
      IF <ls_data>-o_fahrzeug IS BOUND.
        <ls_data>-is_dd_fzg_pos_enabled   = COND #( WHEN wd_this->mv_edit_mode = abap_false
                                                    OR lv_status = zif_ia_2_wrkshft_status=>mc_shift_released  " >001< +
                                                    THEN abap_false
                                                    ELSE abap_true ).
        <ls_data>-is_dd_fzg_pos_read_only = COND #( WHEN wd_this->mv_edit_mode = abap_false
                                                    OR lv_status = zif_ia_2_wrkshft_status=>mc_shift_released   " >001< +
                                                    THEN abap_true
                                                    ELSE abap_false ).
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD set_volume_weight .
  DATA(lv_weight_mat) = VALUE brgew( ).
  DATA(lv_volume_mat) = VALUE volum( ).


  LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>) WHERE matnr IS NOT INITIAL.
    "Get Volume and Weight
    wd_this->get_volume_weight_by_matnr(
       EXPORTING
         iv_matnr  = <ls_data>-matnr
       IMPORTING
         ev_weight = lv_weight_mat
         ev_volume = lv_volume_mat ).

    "Calculate total volume and weight
    <ls_data>-weight = <ls_data>-req_quan * lv_weight_mat.
    <ls_data>-volume = <ls_data>-req_quan * lv_volume_mat.
  ENDLOOP.

ENDMETHOD.

METHOD show_hide_action_column .
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).
  DATA(ls_mat_table_ui)   = VALUE wd_this->element_mat_table_ui( ).


  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  DATA(lv_edit_mode) = wd_comp_controller->get_schdet_edit_mode( ).

  LOOP AT lt_mat_table_data ASSIGNING FIELD-SYMBOL(<ls_mat_table_data>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_2.
    CHECK <ls_mat_table_data>-is_expanded = abap_true.
    CHECK lv_edit_mode = abap_true.
    CHECK line_exists( lt_mat_table_data[ parent_path = <ls_mat_table_data>-path ] ).
    ls_mat_table_ui-is_col_action_visible = abap_true.
    EXIT.
  ENDLOOP.

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_ui
  )->set_static_attributes( EXPORTING static_attributes = ls_mat_table_ui ).

ENDMETHOD.

METHOD supply_mat_fzg .
  DATA(lt_data)    = VALUE wd_this->elements_mat_fzg( ).
  DATA(lt_mat_fzg) = VALUE zia_2map_matfzg_t( ).

  lt_mat_fzg = wd_this->get_mat_fzg_data( ).
  lt_data    = CORRESPONDING #( lt_mat_fzg ).

  io_node->bind_table( EXPORTING new_items = lt_data set_initial_elements  = abap_true ).

ENDMETHOD.

METHOD supply_mat_table_data .
  DATA(lt_data)       = VALUE wd_this->elements_mat_table_data( ).
  DATA lo_arbstl      TYPE REF TO zcl_ia_2wrkplace.
  DATA lo_arbstl_i    TYPE REF TO cl_object_collection_iterator.
  DATA lt_arbstl_obj  TYPE STANDARD TABLE OF REF TO zcl_ia_2wrkplace.


  IF wd_comp_controller->mo_curr_arbstelle IS NOT BOUND.
    io_node->bind_table( EXPORTING new_items = lt_data set_initial_elements  = abap_true ).
    RETURN.
  ENDIF.

  DATA(lo_curr_arbstl) = wd_comp_controller->mo_curr_arbstelle.
  APPEND lo_curr_arbstl TO lt_arbstl_obj.
  "Check if Schicht is Versorgung Schicht - if so, appen AS of Keine Logistik Schichts
  IF lo_curr_arbstl->get_schicht( )->is_versorgung_schicht( ).
    DATA(lt_klog_schichten) = lo_curr_arbstl->get_schicht( )->get_keine_logistik_schichten( ).
    LOOP AT lt_klog_schichten ASSIGNING FIELD-SYMBOL(<ls_klog_schichten>).
      lo_arbstl_i ?= <ls_klog_schichten>-o_schicht->get_arbeitsstellen( )->get_values_iterator( ).
      WHILE lo_arbstl_i->has_next( ) = abap_true.
        lo_arbstl ?=  lo_arbstl_i->get_next( ).
        CHECK lo_arbstl->get_kurztext( iv_zgart_txt = abap_false ) = lo_curr_arbstl->get_kurztext( iv_zgart_txt = abap_false ).
        APPEND lo_arbstl TO lt_arbstl_obj.
        EXIT.
      ENDWHILE.
    ENDLOOP.
  ENDIF.

  LOOP AT lt_arbstl_obj ASSIGNING FIELD-SYMBOL(<lo_arbstl>).
    lo_arbstl = <lo_arbstl>.
    "Append Level #1: Arbeitsstelle
    wd_this->append_table_lvl_arb( EXPORTING io_arbstl = lo_arbstl CHANGING ct_data = lt_data ).

    "Append Level #2: Auftrag
    wd_this->append_table_lvl_auf( EXPORTING io_arbstl = lo_arbstl CHANGING ct_data = lt_data ).

    "Append Level #3: Material
    wd_this->append_table_lvl_mat( EXPORTING io_arbstl = lo_arbstl CHANGING ct_data = lt_data ).

    "Set volume and weight
    wd_this->set_volume_weight( CHANGING ct_data = lt_data ).

    "Collect volume and weight
    wd_this->collect_volume_weight( CHANGING ct_data = lt_data ).

    "Set Drag&Drop tags
    wd_this->set_dd_tags( CHANGING ct_data = lt_data ).

    "Set UI settings
    wd_this->set_ui_settings( CHANGING ct_data = lt_data ).

    "Copy expanded flag - to keep expanded nodes after screen event
    wd_this->copy_expanded_flag( CHANGING ct_data = lt_data ).

  ENDLOOP.

  "Copy context -  we need backup to keep expanded nodes
  wd_this->copy_ctx_data( it_data = lt_data ).

  "Bind data table
  io_node->bind_table( EXPORTING new_items = lt_data set_initial_elements = abap_true ).

ENDMETHOD.

METHOD supply_mat_table_dd_fzg_pos .
  DATA(lt_dd_fzg_pos)     = VALUE wd_this->elements_mt_dd_fzg_pos( ).
  DATA(ls_mat_table_data) = VALUE wd_this->element_mat_table_data( ).


  "Get parent data - table line
  io_parent_element->get_static_attributes( IMPORTING static_attributes = ls_mat_table_data ).
  IF ls_mat_table_data-level <> zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    RETURN.
  ENDIF.

  "Set DD List for Fzg. Pos
  lt_dd_fzg_pos = VALUE #( ( fzg_pos = '' )
                           ( fzg_pos = zif_ia_2_constant=>mc_mt_fzg_pos-n )
                           ( fzg_pos = zif_ia_2_constant=>mc_mt_fzg_pos-s ) ).

  io_node->bind_table( new_items = lt_dd_fzg_pos ).
  DATA(lv_index) = line_index( lt_dd_fzg_pos[ fzg_pos = ls_mat_table_data-fzg_pos ] ).
  io_node->set_lead_selection_index( index = COND #( WHEN lv_index IS NOT INITIAL THEN lv_index ELSE 1 ) ).

ENDMETHOD.

METHOD supply_mat_table_ui .
  DATA(ls_data_ui)        = VALUE wd_this->element_mat_table_ui( ).
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  DATA(lv_edit_mode) = wd_comp_controller->get_schdet_edit_mode( ).

  LOOP AT lt_mat_table_data ASSIGNING FIELD-SYMBOL(<ls_mat_table_data>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    CHECK <ls_mat_table_data>-is_expanded = abap_true.
    CHECK lv_edit_mode = abap_true.
    ls_data_ui-is_col_action_visible = abap_true.
    EXIT.
  ENDLOOP.

  io_node->bind_structure( EXPORTING new_item = ls_data_ui set_initial_elements = abap_true ).

ENDMETHOD.

METHOD update_belad_fzg .
  wd_this->invalidate_mat_fzg( ).

  "Update Auftrag Level - LEVEL 2
  ASSIGN ct_data[ zarbstl = io_arbstl->get_data( )-zarbstl aufnr = iv_aufnr level = zif_ia_2_wd_mat_table=>mc_level-lvl_2 ] TO FIELD-SYMBOL(<ls_data>).
  IF sy-subrc = 0.
    <ls_data>-fzg_belad = wd_this->get_blad_fahrzeuge_as_text(
      EXPORTING
        io_arbstl = io_arbstl
        iv_aufnr  = iv_aufnr ).
  ENDIF.


  "Update Material Level - LEVEL 3
  LOOP AT ct_data ASSIGNING <ls_data> WHERE zarbstl = io_arbstl->get_id( ) AND
                                              aufnr = iv_aufnr             AND
                                              matnr IS NOT INITIAL.

    <ls_data>-fzg_belad = wd_this->get_blad_fahrzeuge_as_text(
       EXPORTING
         io_arbstl = io_arbstl
         iv_aufnr  = iv_aufnr
         iv_matnr  = <ls_data>-matnr
         iv_rsnum  = <ls_data>-rsnum
         iv_rspos  = <ls_data>-rspos ).
  ENDLOOP.

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_reihung_changed .

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data )->invalidate( )."""

  DATA(lt_mat_table) = VALUE wd_this->elements_mat_table_data( ).
  DATA(lt_mat_table_temp) = VALUE wd_this->elements_mat_table_data( ).
  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data )->get_static_attributes_table( IMPORTING table = lt_mat_table ).
  DATA(lo_fahrzeug) = io_fahrzeug.
  DATA(lv_arbeitsstelle) = io_fahrzeug->get_arbeitsstelle( )->get_text_id( zcl_ia_2utilities2=>mc_zugangsart_schiene ).
  DATA(lv_sortierung) = lo_fahrzeug->get_reihung( ).
  IF lv_sortierung IS INITIAL.
    lv_sortierung =  '00'.
  ENDIF.
  DATA(lv_loaded_veh) = |{ lv_arbeitsstelle }.{ lv_sortierung }|.
  lt_mat_table_temp = VALUE #( BASE lt_mat_table_temp FOR ls_mat_table IN lt_mat_table WHERE ( fzg_belad = lv_loaded_veh ) ( ls_mat_table ) ).
  DATA(lt_matfzg) = wd_this->convert_mat_to_matfzg( it_mat_table = lt_mat_table_temp io_fahrzeug = lo_fahrzeug ).

  LOOP AT lt_matfzg ASSIGNING FIELD-SYMBOL(<ls_matfzg>).
    lo_fahrzeug->add_material( is_data = <ls_matfzg> ).
  ENDLOOP.

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data )->invalidate( )."""

ENDMETHOD.

METHOD on_schdet_btn_edit .
  DATA(ls_mat_table_ui)   = VALUE wd_this->element_mat_table_ui( ).
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).


  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_ui
    )->get_static_attributes( IMPORTING static_attributes = ls_mat_table_ui ).

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  wd_this->mv_edit_mode = iv_mode.
  ls_mat_table_ui-is_col_action_visible = abap_false.

  "Set UI settings
  wd_this->set_ui_settings( CHANGING ct_data = lt_mat_table_data cs_data_ui = ls_mat_table_ui ).


  "Bind UI table data
  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_ui
    )->bind_structure( new_item = ls_mat_table_ui set_initial_elements = abap_true ).

  "Bind main table data
  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->bind_table( new_items  = lt_mat_table_data set_initial_elements = abap_true ).

ENDMETHOD.

METHOD on_selected_arbst .
  wd_this->invalidate_mat_table_data( ).

ENDMETHOD.

METHOD on_table_collapse .
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
     )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  LOOP AT lt_mat_table_data ASSIGNING FIELD-SYMBOL(<ls_mat_table_data>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_1 OR
                                                                              level = zif_ia_2_wd_mat_table=>mc_level-lvl_2 OR
                                                                              level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    <ls_mat_table_data>-is_expanded = abap_false.
  ENDLOOP.

  wd_this->mt_mat_table_data_copy = lt_mat_table_data.

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->bind_table( EXPORTING new_items = lt_mat_table_data set_initial_elements = abap_true ).

ENDMETHOD.

METHOD on_table_expand .
  DATA(lt_mat_table_data) = VALUE wd_this->elements_mat_table_data( ).

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
     )->get_static_attributes_table( IMPORTING table = lt_mat_table_data ).

  LOOP AT lt_mat_table_data ASSIGNING FIELD-SYMBOL(<ls_mat_table_data>) WHERE level = zif_ia_2_wd_mat_table=>mc_level-lvl_1 OR
                                                                              level = zif_ia_2_wd_mat_table=>mc_level-lvl_2 OR
                                                                              level = zif_ia_2_wd_mat_table=>mc_level-lvl_3.
    <ls_mat_table_data>-is_expanded = abap_true.
  ENDLOOP.

  wd_this->mt_mat_table_data_copy = lt_mat_table_data.

  wd_context->get_child_node( name = wd_this->wdctx_mat_table )->get_child_node( name = wd_this->wdctx_mat_table_data
    )->bind_table( EXPORTING new_items = lt_mat_table_data set_initial_elements = abap_true ).

ENDMETHOD.

endclass.
 