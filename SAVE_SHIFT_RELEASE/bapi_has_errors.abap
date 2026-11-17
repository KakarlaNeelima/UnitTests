*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*
* IMPORTING IT_RETURN            TYPE BAPIRET2_T
* RETURNING VALUE(RV_HAS_ERRORS) TYPE ABAP_BOOL
*---------------------------------------------------------------------*
METHOD bapi_has_errors.

  rv_has_errors = xsdbool(
       line_exists( it_return[ type = 'E' ] )
    OR line_exists( it_return[ type = 'A' ] )
    OR line_exists( it_return[ type = 'X' ] ) ).

ENDMETHOD.
