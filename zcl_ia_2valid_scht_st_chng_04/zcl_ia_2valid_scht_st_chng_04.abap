CLASS zcl_ia_2valid_scht_st_chng_04 DEFINITION
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

    DATA go_schicht TYPE REF TO zcl_ia_2workshift .
ENDCLASS.



CLASS ZCL_IA_2VALID_SCHT_ST_CHNG_04 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALID_SCHT_ST_CHNG_04->ZIF_IA_2_VALIDATOR~VALIDATE
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

    go_schicht = CAST zcl_ia_2workshift( ii_parameters->get_object( zif_ia_2_validator=>mc_param_schicht ) ).

    DATA(li_arbstelle_i) = go_schicht->get_arbeitsstellen( )->get_values_iterator( ).
    WHILE li_arbstelle_i->has_next( ).
      DATA(lo_arbstelle) = CAST zcl_ia_2wrkplace( li_arbstelle_i->get_next( ) ).
      CHECK NOT lo_arbstelle->is_pneu( ). "Check only for AS with Schiene

      DATA(lv_arbstelle_in_tunnel) = lo_arbstelle->is_in_tunnel( ).

      " in      the Tunnel: check SC and CPM
      " outside the Tunnel: check SC only
      DATA(lv_is_cpm) = xsdbool( lv_arbstelle_in_tunnel = abap_false ).
      DATA(lv_is_sc)  = abap_false.

      DATA(li_fahrzeuge_i) = lo_arbstelle->get_fahrzeuge( )->get_values_iterator( ).
      WHILE li_fahrzeuge_i->has_next( ).
        DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( li_fahrzeuge_i->get_next( ) ).

        DATA(li_sitzplaetze_i) = lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
        WHILE li_sitzplaetze_i->has_next( ).
          DATA(lo_sitzplatz) = CAST zcl_ia_2seat( li_sitzplaetze_i->get_next( ) ).

          CHECK lo_sitzplatz->get_data( )-nicht_belegt = abap_false.
          CHECK lo_sitzplatz->has_quali( ).

          lv_is_sc = COND #( WHEN lo_sitzplatz->is_sc( ) THEN abap_true ELSE lv_is_sc ).

          IF lv_arbstelle_in_tunnel = abap_true.
            lv_is_cpm = COND #( WHEN lo_sitzplatz->is_cpm( ) THEN abap_true ELSE lv_is_cpm ).
          ENDIF.

        ENDWHILE.

      ENDWHILE.

      " the first Arbeitsstelle without correct flags stops the validation
      IF lv_is_cpm = abap_false OR
         lv_is_sc  = abap_false.
        RAISE EXCEPTION TYPE zcx_ia_2validation_error
          EXPORTING
            textid       = zcx_ia_2validation_error=>mc_schicht_frei_sitzpl_func
            gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_04.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.
ENDCLASS.