class ZCL_IA_2VALFACT_BASE_A definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_IA_2_VALIDATOR_FACTORY .

  methods CONSTRUCTOR
    importing
      !II_PARAMETERS type ref to ZIF_IA_2_PARAMETERS optional .
protected section.

  methods GET_VALIDATORS
  abstract
    importing
      !II_PARAMETERS type ref to ZIF_IA_2_PARAMETERS
    returning
      value(RT_VALIDATORS) type ZIA_2_VALIDATORS_T .
private section.
ENDCLASS.



CLASS ZCL_IA_2VALFACT_BASE_A IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALFACT_BASE_A->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] II_PARAMETERS                  TYPE REF TO ZIF_IA_2_PARAMETERS(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       11.09.2025     tcs / Sivasurya k
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
METHOD constructor.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2VALFACT_BASE_A->ZIF_IA_2_VALIDATOR_FACTORY~GET_VALIDATION_ITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] II_PARAMETERS                  TYPE REF TO ZIF_IA_2_PARAMETERS(optional)
* | [<-()] RI_INSTANCE                    TYPE REF TO ZIF_IA_2_VALIDATION_ITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD zif_ia_2_validator_factory~get_validation_iterator.
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description :
*----------------------------------------------------------------------*
* >000<   7.50       18.08.2025     tcs / Sivasurya K
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*         ...
*----------------------------------------------------------------------*
  DATA(lt_validators) = get_validators( ii_parameters ).

  ri_instance = NEW zcl_ia_2validation_iterator( lt_validators ).
ENDMETHOD.
ENDCLASS.
