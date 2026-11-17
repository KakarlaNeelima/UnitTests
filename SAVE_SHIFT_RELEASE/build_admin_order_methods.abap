*---------------------------------------------------------------------*
* Placement: Web Dynpro Assistance Class - private method
*---------------------------------------------------------------------*
METHOD build_admin_order_methods.

  rt_methods = VALUE #(
    ( refnumber  = 1
      objecttype = 'HEADER'
      method     = 'CREATE'
      objectkey  = '%00000000001' )
    ( refnumber  = 1
      objecttype = space
      method     = 'SAVE'
      objectkey  = '%00000000001' ) ).

ENDMETHOD.
