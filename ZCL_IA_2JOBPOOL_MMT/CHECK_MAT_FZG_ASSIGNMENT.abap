  METHOD check_mat_fzg_assignment.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
* Beschreibung/description: Prüfen, ob alle Materialien dem Fahrzeug zugeordnet wurden
*
* SAP-Prozess/process : ...
* Grund/reason: ( ) QM-Meldung/QM ticket  : ...
*               ( ) Projekt/ project      :
*               ( ) Notkorrektur/ emergency correction: ...
*               ( ) OSS-Hinweis/note      : ...
*               ( ) OSS-Meldung/message   : ...
*               ( ) andere/other          : ...
*
* Auftraggeber/ ordered by: ...
*
*--------------Änderungsdokumentation/ documentation of changes--------*
* Version SAP-Rel    Datum/date        Entwickler/developer
*         Beschreibung/ description
*----------------------------------------------------------------------*
* >000<   7.52       14.09.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-141
*----------------------------------------------------------------------*
* >001<   7.52       05.10.2023   DXC / Piotr Stelmach
*         6800024336/ JADE-791
*----------------------------------------------------------------------*
    DATA lt_shifts TYPE STANDARD TABLE OF REF TO zcl_ia_2workshift WITH EMPTY KEY.
    DATA lo_auftrag_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_arbstl_i TYPE REF TO cl_object_collection_iterator.
    DATA lo_auftrag TYPE REF TO zcl_ia_2order.
    DATA lo_arbstl TYPE REF TO zcl_ia_2wrkplace.
    DATA lt_mat_fzg TYPE zia_2map_matfzg_t.
    DATA lt_comp TYPE bapi_alm_order_component_et.
    DATA lt_return TYPE bapiret2_t.
    DATA lv_as_name TYPE char3.

    APPEND io_schicht TO lt_shifts.
    IF io_schicht->is_versorgung_schicht( ).
      DATA(lt_related_shifts) = io_schicht->get_keine_logistik_schichten( ).
      LOOP AT lt_related_shifts INTO DATA(ls_related_shift).
        APPEND ls_related_shift-o_schicht TO lt_shifts.
      ENDLOOP.
    ENDIF.

    LOOP AT lt_shifts INTO DATA(lo_schicht).
      " The optional mapping belongs only to the shift passed by the caller.
      IF lo_schicht = io_schicht AND it_map_matfzg IS NOT INITIAL.
        lt_mat_fzg = it_map_matfzg.
      ELSE.
        lt_mat_fzg = get_map_matfzg( io_schicht = lo_schicht ).
      ENDIF.
      CLEAR lt_comp.

      lo_auftrag_i ?= lo_schicht->get_auftraege( )->get_values_iterator( ).
      WHILE lo_auftrag_i->has_next( ).
        lo_auftrag ?= lo_auftrag_i->get_next( ).
        CHECK lo_auftrag->get_data( )-zzzugangsart = 1.

        TRY.
            zcl_ia_2lofpm_clh_application=>get_instance(
              iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
            DATA(lt_comp_tmp) = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent(
              )->get_object( iv_aufnr = lo_auftrag->get_data( )-aufnr
              )->get_components( ).
          CATCH cx_static_check INTO DATA(lx_component_error).
            APPEND VALUE #( type = 'E'
                            message = lx_component_error->get_text( )
                            message_v1 = lo_auftrag->get_data( )-aufnr ) TO lt_return.
            CONTINUE.
        ENDTRY.
        APPEND LINES OF lt_comp_tmp TO lt_comp.
      ENDWHILE.

      LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>). "#EC CI_NESTED
        CHECK <ls_comp>-reserv_no IS NOT INITIAL.
        CHECK <ls_comp>-res_item IS NOT INITIAL.
        CHECK <ls_comp>-delete_ind IS INITIAL.
        CHECK <ls_comp>-withdrawn IS INITIAL.
        CHECK <ls_comp>-requirement_quantity IS NOT INITIAL.
        CHECK NOT line_exists( lt_mat_fzg[ rsnum = <ls_comp>-reserv_no
                                          rspos = <ls_comp>-res_item ] ).

        lo_arbstl_i ?= lo_schicht->get_arbeitsstellen( )->get_values_iterator( ).
        WHILE lo_arbstl_i->has_next( ).
          lo_arbstl ?= lo_arbstl_i->get_next( ).
          lo_auftrag = lo_arbstl->get_auftrag( iv_key = <ls_comp>-orderid ).
          CHECK lo_auftrag IS BOUND.
          lv_as_name = lo_arbstl->get_kurztext( ).
          MESSAGE e558(zia_2_real) WITH lv_as_name INTO DATA(lv_msg).
          APPEND VALUE #( type = sy-msgty
                          number = sy-msgno
                          id = sy-msgid
                          message_v1 = lv_as_name
                          message = lv_msg ) TO lt_return.
        ENDWHILE.
      ENDLOOP.
    ENDLOOP.

    SORT lt_return.
    DELETE ADJACENT DUPLICATES FROM lt_return.

    IF lt_return IS NOT INITIAL.
      MESSAGE e557(zia_2_real) INTO lv_msg.
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid
                      message = lv_msg ) INTO lt_return INDEX 1.
      MESSAGE e550(zia_2_real) INTO lv_msg.
      INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid
                      message = lv_msg ) INTO lt_return INDEX 1.
      RAISE EXCEPTION TYPE zcx_ia_2failure EXPORTING gt_bapiret = lt_return.
    ENDIF.

  ENDMETHOD.