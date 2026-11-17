CLASS zcl_ia_2valid_scht_st_chng_05 DEFINITION
  PUBLIC
  INHERITING FROM zcl_ia_2valid_scht_st_chng_a
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS ZCL_IA_2VALFACT_order_STAT
                 zcl_ia_2valfact_schicht_stat .

  PUBLIC SECTION.

    METHODS zif_ia_2_validator~validate
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA go_schicht TYPE REF TO zcl_ia_2workshift.
ENDCLASS.



CLASS ZCL_IA_2VALID_SCHT_ST_CHNG_05 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALID_SCHT_ST_CHNG_05->ZIF_IA_2_VALIDATOR~VALIDATE
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

    DATA lo_arbstelle_i   TYPE REF TO cl_object_collection_iterator.
    DATA lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator.
    DATA(lt_bapiret)   = VALUE bapiret2_t( ).

    me->go_schicht   = CAST zcl_ia_2workshift( ii_parameters->get_object( zif_ia_2_validator=>mc_param_schicht ) ).

    lo_arbstelle_i ?=  me->go_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE lo_arbstelle_i->has_next( ) = abap_true.
      DATA(lo_arbstelle)  = CAST zcl_ia_2wrkplace( lo_arbstelle_i->get_next( ) ).

      lo_fahrzeuge_i     ?=  lo_arbstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
        DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).
        CHECK abap_false  = lo_fahrzeug->is_basis_fz_pneu( ).       "Check only Schiene

        IF lo_fahrzeug->get_reihung( ) IS INITIAL.
          MESSAGE e550(zia_2_real) INTO DATA(lv_msg).
          lt_bapiret = VALUE #( ( type = sy-msgty id = sy-msgid number = sy-msgno message = lv_msg ) ).
          DATA(lv_workplace) = lo_arbstelle->get_kurztext( ).
          MESSAGE e553(zia_2_real) WITH lv_workplace INTO lv_msg.
          lt_bapiret = VALUE #( BASE lt_bapiret ( type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message = lv_msg  ) ).
          RAISE EXCEPTION TYPE zcx_ia_2validation_error
            EXPORTING
              gt_bapiret   = lt_bapiret
*             textid       = zcx_ia_2validation_error=>mc_schicht_frei_fahrzeug_reih
              gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_05.
        ENDIF.

      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.