class ZCL_IA_2VALID_SCHT_ST_CHNG_01 definition
  public
  inheriting from ZCL_IA_2VALID_SCHT_ST_CHNG_A
  final
  create private

  global friends ZCL_IA_2VALFACT_SCHICHT_STAT .

public section.

  constants MC_TABNAME_AUFTR type TABLE_NAME value 'ZIA_2ORDER' ##NO_TEXT.

  methods ZIF_IA_2_VALIDATOR~VALIDATE
    redefinition .
protected section.
PRIVATE SECTION.

  TYPES: BEGIN OF ts_enq_aufnr,
           aufnr TYPE aufnr,
           uname TYPE uname,
         END OF ts_enq_aufnr.
  TYPES: tt_enq_aufnr TYPE STANDARD TABLE OF ts_enq_aufnr WITH DEFAULT KEY.
ENDCLASS.



CLASS ZCL_IA_2VALID_SCHT_ST_CHNG_01 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALID_SCHT_ST_CHNG_01->ZIF_IA_2_VALIDATOR~VALIDATE
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

  DATA(lt_aufnr)       = VALUE aufnr_t( ).
  DATA(lt_enq)         = VALUE wlf_seqg3_tab( ).
  DATA(lt_enq_aufnr)   = VALUE tt_enq_aufnr( ).
  DATA(lt_bapiret)     = VALUE bapiret2_t( ).


  CALL FUNCTION 'ENQUEUE_READ'
    EXPORTING
      gname                 = mc_tabname_auftr
    TABLES
      enq                   = lt_enq
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2
      OTHERS                = 3.
  IF sy-subrc <> 0 OR lt_enq IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lo_schicht) = CAST zcl_ia_2workshift( ii_parameters->get_object( zif_ia_2_validator=>mc_param_schicht ) ).
  lt_aufnr = CAST cl_object_map( lo_schicht->get_auftraege( ) )->get_keys( ).

  LOOP AT lt_aufnr ASSIGNING FIELD-SYMBOL(<ls_aufnr>).
    TRY.
        DATA(ls_enq) = lt_enq[ garg+3 = <ls_aufnr>-aufnr ].
        lt_enq_aufnr = VALUE #( BASE lt_enq_aufnr ( uname = ls_enq-guname aufnr = |{ <ls_aufnr>-aufnr ALPHA = OUT }| )  ).
      CATCH cx_sy_itab_line_not_found.
        CONTINUE.
    ENDTRY.
  ENDLOOP.

  IF lt_enq_aufnr IS NOT INITIAL.
    MESSAGE e012(zia_2_real) INTO DATA(lv_msg).
    lt_bapiret = VALUE #( ( type = sy-msgty id = sy-msgid number = sy-msgno ) ).
    LOOP AT lt_enq_aufnr ASSIGNING FIELD-SYMBOL(<ls_enq_aufnr>).
      TRY.
          zcl_ia_2utilities=>get_user_details( EXPORTING iv_uname = <ls_enq_aufnr>-uname IMPORTING ev_voller_name = DATA(lv_name) ).
        CATCH zcx_ia_2failure.
          lv_name = syst-uname.
      ENDTRY.
      MESSAGE e156(zia_2_real) WITH <ls_enq_aufnr>-aufnr lv_name INTO lv_msg.
      lt_bapiret = VALUE #( BASE lt_bapiret ( type       = sy-msgty
                                              id         = sy-msgid
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message    = lv_msg   ) ).
    ENDLOOP.

    RAISE EXCEPTION TYPE zcx_ia_2validation_error
      EXPORTING
        gt_bapiret   = lt_bapiret
        gv_validator = zif_ia_2_validator_factory=>mc_validator-scht_st_chng_01.
  ENDIF.
ENDMETHOD.
ENDCLASS.