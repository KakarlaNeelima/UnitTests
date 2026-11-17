class ZCL_IA_2PARAMETERS_GENERIC definition
  public
  inheriting from ZCL_IA_2PARAMETERS_BASE_A
  final
  create public .

public section.

  class-methods _DEMO
    exporting
      value(EV_OUTPUT) type STRING .
protected section.
private section.

  class-methods _DEMO_GET_PARAMETERS
    returning
      value(Ri_INSTANCE) type ref to ZIF_IA_2_PARAMETERS .
ENDCLASS.



CLASS ZCL_IA_2PARAMETERS_GENERIC IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_IA_2PARAMETERS_GENERIC=>_DEMO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD _demo.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : _DEMO
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
    DATA(li_parameters) = _demo_get_parameters( ).

    TRY .
        DATA(lo_object) = li_parameters->get_object( `OBJECT` ).
        DATA(lo_descr) = cl_abap_typedescr=>describe_by_object_ref( lo_object ).
        ev_output = |TYPE REF TO: { lo_descr->get_relative_name( ) }|.

        lo_object = li_parameters->get_object( `LOCOBJ` ).
        lo_descr = cl_abap_typedescr=>describe_by_object_ref( lo_object ).
        ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }TYPE REF TO: { lo_descr->get_relative_name( ) }|.

        DATA(lv_string) = li_parameters->get_string( `STRING` ).
        ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }String VALUE: { lv_string }|.

        DATA(lt_range) = li_parameters->get_string_range( `RANGET` ).
        ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }RANGE of Strings:|.
        LOOP AT lt_range ASSIGNING FIELD-SYMBOL(<ls_range>).
          ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }{ <ls_range>-sign } { <ls_range>-option } { <ls_range>-low } { <ls_range>-high }|.
        ENDLOOP.

        lv_string = li_parameters->get_string( `NONAME` ).
        ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }Variable not found { lv_string }|.

      CATCH zcx_ia_2no_check INTO DATA(lx_error).
        ev_output = |{ ev_output }{ cl_abap_char_utilities=>newline }{ lx_error->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_IA_2PARAMETERS_GENERIC=>_DEMO_GET_PARAMETERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RI_INSTANCE                    TYPE REF TO ZIF_IA_2_PARAMETERS
* | [<-()] RO_INSTANCE                    TYPE REF TO ZIF_IA_2_PARAMETERS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD _demo_get_parameters.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : _DEMO_GET_PARAMETERS
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       03.10.2025     tcs / Pratima Sahu
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*

    DATA(ls_params) = VALUE zia_2sf_params( ).

    DATA(lo_datadescr) = cl_abap_typedescr=>describe_by_data( ls_params ).
    DATA(lo_object) = lo_datadescr.

    DATA(lt_range) = VALUE zia_2string_range_t( ( sign = 'I' option = 'EQ' low = `TEST` ) ).

    ri_instance = NEW zcl_ia_2parameters_generic( VALUE #( ( name = `OBJECT` dref = REF #( lo_datadescr ) )
                                                            ( name = `LOCOBJ` dref = REF #( lo_object ) )
                                                            ( name = `STRING` dref = REF #( `TEST` ) )
                                                            ( name = `RANGET` dref = REF #( lt_range ) )
                                                          )
                                                 ).
  ENDMETHOD.
ENDCLASS.
