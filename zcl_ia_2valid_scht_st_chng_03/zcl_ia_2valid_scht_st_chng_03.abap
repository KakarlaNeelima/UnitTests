class zcl_ia_2valid_scht_st_chng_03 definition
  public
  inheriting from zcl_ia_2valid_scht_st_chng_a
  final
  create private

  global friends zcl_ia_2valfact_order_stat
                 zcl_ia_2valfact_schicht_stat .

public section.

  methods zif_ia_2_validator~VALIDATE
    redefinition .
protected section.
private section.

  data go_schicht type ref to zcl_ia_2workshift .
ENDCLASS.



CLASS ZCL_IA_2VALID_SCHT_ST_CHNG_03 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALID_SCHT_ST_CHNG_03->ZIF_IA_2_VALIDATOR~VALIDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] II_PARAMETERS                  TYPE REF TO ZIF_IA_2_PARAMETERS(optional)
* | [!CX!] ZCX_IA_2STATIC_CHECK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_ia_2_validator~validate.
    DATA lo_fahrzeuge_i   TYPE REF TO cl_object_collection_iterator.
    DATA lo_sitzplaetze_i TYPE REF TO cl_object_collection_iterator.


    me->go_schicht = CAST zcl_ia_2workshift( ii_parameters->get_object( zif_ia_2_validator=>mc_param_schicht ) ).

    "Check Disposition for Fahrzeuge
    lo_fahrzeuge_i ?= me->go_schicht->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      DATA(lo_fahrzeug) = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).

      CHECK abap_false = lo_fahrzeug->is_basis_fz_pneu( ).
      IF lo_fahrzeug->get_uic_nummer( ) IS INITIAL.
        RAISE EXCEPTION TYPE zcx_ia_2validation_error
          EXPORTING
            textid       = zcx_ia_2validation_error=>mc_schicht_frei_dispo_incmplet
            gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_03.
      ENDIF.
    ENDWHILE.


    "Check Disposition for Sitzplaetze
    lo_fahrzeuge_i ?= me->go_schicht->get_fahrzeuge( )->get_values_iterator( ).
    WHILE lo_fahrzeuge_i->has_next( ) = abap_true.
      lo_fahrzeug = CAST zcl_ia_2vehicle( lo_fahrzeuge_i->get_next( ) ).

      CHECK abap_false = lo_fahrzeug->is_basis_fz_pneu( ).

      lo_sitzplaetze_i ?= lo_fahrzeug->get_sitzplaetze( )->get_values_iterator( ).
      WHILE lo_sitzplaetze_i->has_next( ) = abap_true.
        DATA(lo_sitzplatz) = CAST zcl_ia_2seat( lo_sitzplaetze_i->get_next( ) ).

        CHECK lo_sitzplatz->get_data( )-nicht_belegt = abap_false.
        CHECK lo_sitzplatz->has_quali( ).
        CHECK lo_sitzplatz->get_data( )-uname IS INITIAL.
        RAISE EXCEPTION TYPE zcx_ia_2validation_error
          EXPORTING
            textid       = zcx_ia_2validation_error=>mc_schicht_frei_dispo_incmplet
            gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_03.
      ENDWHILE.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.