CLASS zcl_ia_2valid_scht_st_chng_07 DEFINITION
  PUBLIC
  INHERITING FROM zcl_ia_2valid_scht_st_chng_a
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_ia_2valfact_order_stat
                 zcl_ia_2valfact_schicht_stat .

  PUBLIC SECTION.

    METHODS zif_ia_2_validator~validate
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA go_schicht TYPE REF TO zcl_ia_2workshift.
ENDCLASS.



CLASS ZCL_IA_2VALID_SCHT_ST_CHNG_07 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALID_SCHT_ST_CHNG_07->ZIF_IA_2_VALIDATOR~VALIDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] II_PARAMETERS                  TYPE REF TO ZIF_IA_2_PARAMETERS(optional)
* | [!CX!] ZCX_IA_2STATIC_CHECK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_ia_2_validator~validate.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       07.01.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    CONSTANTS: lc_storage_location TYPE lgort_d VALUE '2000',
               lc_plant_gbts       TYPE werks_d VALUE '8324',
               lc_plant_gbtn       TYPE werks_d VALUE '8325'.

    DATA: lt_components TYPE bapi_alm_order_component_et,
          lt_return     TYPE bapiret2_t,
          lt_aufnr      TYPE aufnr_t,
          lt_order_keys TYPE RANGE OF eaml_d_lfe_data-tabkey.

    me->go_schicht   = CAST zcl_ia_2workshift( ii_parameters->get_object( zif_ia_2_validator=>mc_param_schicht ) ).
    lt_aufnr = go_schicht->get_auftraege( )->get_keys( ).
    IF lt_aufnr IS INITIAL.
      RETURN.
    ENDIF.

    lt_order_keys = VALUE #( FOR ls_aufnr IN lt_aufnr ( sign = 'I' option = 'EQ' low = ls_aufnr-aufnr ) ).

    SELECT tabkey,
           CASE z_eiz
             WHEN @zcl_ia_2tremola=>mc_eiz_gbts THEN @lc_plant_gbts
             WHEN @zcl_ia_2tremola=>mc_eiz_gbtn THEN @lc_plant_gbtn
           END AS expected_plant
      FROM eaml_d_lfe_data
      WHERE obart = 'OR'
        AND tabkey IN @lt_order_keys
        AND ( z_eiz = @zcl_ia_2tremola=>mc_eiz_gbts OR z_eiz = @zcl_ia_2tremola=>mc_eiz_gbtn )
      INTO TABLE @DATA(lt_order_plants).
    IF lt_order_plants IS INITIAL.
      RETURN.
    ENDIF.
    SORT lt_order_plants BY tabkey.

    LOOP AT lt_aufnr ASSIGNING FIELD-SYMBOL(<ls_aufnr>).
      READ TABLE lt_order_plants ASSIGNING FIELD-SYMBOL(<ls_order_plant>) WITH KEY tabkey = <ls_aufnr>-aufnr BINARY SEARCH.
      CHECK sy-subrc = 0.
      DATA(lv_aufnr) = <ls_aufnr>-aufnr.
      CLEAR lt_components.
      TRY.
          zcl_ia_2lofpm_clh_application=>get_instance( iv_applid = CONV #( zif_ia_2_constant=>mc_perim-gbt ) ).
          lt_components = zcl_ia_2lofpm_cla_agency=>get_maint_order_agent( )->get_object( iv_aufnr = lv_aufnr )->get_components( ).
        CATCH cx_static_check INTO DATA(lx_component_error).
          INSERT VALUE #( type = 'E' message = lx_component_error->get_text( ) message_v1 = lv_aufnr ) INTO lt_return INDEX 1.
          CONTINUE.
      ENDTRY.

      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<ls_component>). "#EC CI_NESTED
        CHECK <ls_component>-delete_ind IS INITIAL.
        CHECK <ls_component>-material IS NOT INITIAL.
        CHECK <ls_component>-requirement_quantity IS NOT INITIAL.
        IF <ls_component>-stge_loc = lc_storage_location
           AND <ls_component>-plant = <ls_order_plant>-expected_plant.
          CONTINUE.
        ENDIF.
        MESSAGE e569(zia_2_real) INTO DATA(lv_message) WITH |{ lv_aufnr ALPHA = OUT }| |{ <ls_component>-material ALPHA = OUT }| <ls_component>-plant <ls_component>-stge_loc.
        INSERT VALUE #( type = sy-msgty number = sy-msgno id = sy-msgid message = lv_message message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) INTO lt_return INDEX 1.
      ENDLOOP.
    ENDLOOP.

    IF lt_return IS NOT INITIAL.
      SORT lt_return.
      DELETE ADJACENT DUPLICATES FROM lt_return COMPARING ALL FIELDS.
      RAISE EXCEPTION TYPE zcx_ia_2validation_error
        EXPORTING
          gt_bapiret   = lt_return
          gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_07.
    ENDIF.

  ENDMETHOD.
ENDCLASS.