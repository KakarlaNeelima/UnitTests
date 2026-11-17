class ZCL_IA_2LAYER definition
  public
  final
  create public .

public section.

  methods GET_ID
    returning
      value(RV_ID) type ZIA_2_LAYER .
  methods GET_RI_SCHICHT
    returning
      value(RO_SCHICHT) type ref to ZCL_IA_2LAYER .
  methods CONSTRUCTOR
    importing
      !IS_DATA type ZIA_2SCHICHTEN
      !IV_START_DATUM type DATUM
      !IV_START_ZEIT type TIMS
      !IV_SCHICHT_NR type ZIA_2_LAYER .
  methods RELOAD .
  methods GET_ARBEITSSTELLEN
    returning
      value(RO_OBJECTS) type ref to CL_OBJECT_MAP .
  methods GET_ARBEITSSTELLE
    importing
      !IV_ARBSTL type ZIA_2_ID_WRKPLACE
    returning
      value(RO_OBJECT) type ref to ZCL_IA_2ARBEITSSTELLE .
  methods GET_ID_INTERVALL
    returning
      value(RV_ID_INTERVALL) type ZIA_2_ID_INTERVALL .
  methods GET_DATA
    returning
      value(RS_DATA) type ZIA_2SCHICHTEN .
  methods GET_PARAMETER
    returning
      value(RO_OBJECT) type ref to ZCL_IA_2PARAMETER .
  methods HAS_ARBEITSSTELLEN_IN_TUNNEL
    importing
      !IV_EIZ type ZIA_2_ID_EST
      !IV_SKIP_STRASSE type BOOLEAN
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  methods IS_JOKER
    returning
      value(RV_BOOLEAN) type BOOLEAN .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IA_2LAYER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZIA_2SCHICHTEN
* | [--->] IV_START_DATUM                 TYPE        DATUM
* | [--->] IV_START_ZEIT                  TYPE        TIMS
* | [--->] IV_SCHICHT_NR                  TYPE        ZIA_2_LAYER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD constructor.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_ARBEITSSTELLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ARBSTL                      TYPE        ZIA_2_ID_WRKPLACE
* | [<-()] RO_OBJECT                      TYPE REF TO ZCL_IA_2ARBEITSSTELLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_arbeitsstelle.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_ARBEITSSTELLEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_OBJECTS                     TYPE REF TO CL_OBJECT_MAP
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_arbeitsstellen.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_DATA                        TYPE        ZIA_2SCHICHTEN
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_data.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZIA_2_LAYER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_id.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_ID_INTERVALL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID_INTERVALL                TYPE        ZIA_2_ID_INTERVALL
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_id_intervall.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_OBJECT                      TYPE REF TO ZCL_IA_2PARAMETER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_parameter.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->GET_RI_SCHICHT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_SCHICHT                     TYPE REF TO ZCL_IA_2LAYER
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD get_ri_schicht.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->HAS_ARBEITSSTELLEN_IN_TUNNEL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EIZ                         TYPE        ZIA_2_ID_EST
* | [--->] IV_SKIP_STRASSE                TYPE        BOOLEAN
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD has_arbeitsstellen_in_tunnel.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->IS_JOKER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BOOLEAN                     TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD is_joker.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IA_2LAYER->RELOAD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
##NEEDED
*----------------------------------------------------------------------*
* SBB AG, SAP CCC-IT, Bern/Berne/Berna
*----------------------------------------------------------------------*
*
*-----------Änderungsdokumentation / documentation of changes----------*
* Version SAP-Rel    Datum / date      Entwickler / developer
*         Beschreibung / description : Get ID
*        Code Migrated from - M02(201)
*----------------------------------------------------------------------*
* >000<   7.50       02.03.2026     tcs / Roshan Wadhwani
*         Programmerstellung / creation of program
*----------------------------------------------------------------------*
* >001<   7.50       tt.mm.jjjj        Firma(company) / Name(name)
*
*----------------------------------------------------------------------*
METHOD reload.
ENDMETHOD.
ENDCLASS.