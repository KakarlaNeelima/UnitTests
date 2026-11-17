class CL_CC_MAIN_SCHTAB_Ctr implementation.
 
*=======================
method 
Constructor. "#EC NEEDED
*=======================
" Do NOT modify the Constructor, any changes will not be saved !
 
  Me->Wd_This =    Wd_This.
  Me->Wd_Context = Wd_Context.
  Me->Wd_Comp_Controller = Wd_This->get_ComponentController_Ctr( ).
  Me->Wd_Assist =    Wd_Assist.
endmethod.
 
* +-------------------------------------------------------------------+
* |  general methods                                                  |
* +-------------------------------------------------------------------+

METHOD wddoexit . "#EC NEEDED
ENDMETHOD.

METHOD wddoinit . "#EC NEEDED
ENDMETHOD.

METHOD close_tab_gantt .
  wd_this->delete_gantt_tab( iv_perim = iv_perim ).
ENDMETHOD.

METHOD close_tab_schicht .

  io_schicht->unlock( ).
  io_schicht->unlock_sub_objects( ).

  wd_this->delete_schicht_tab( io_schicht->get_id( ) ).
ENDMETHOD.

METHOD delete_gantt_tab .
  DATA(ls_tabs_schichten) = VALUE wd_this->element_tabs_schichten( ).


  DATA(lt_elements) = wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_elements( ).
  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).
    CHECK ls_tabs_schichten-is_gantt_tab = abap_true.
    CHECK ls_tabs_schichten-gantt_perim  = iv_perim.
    wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->remove_element( element = <li_element> ).
    EXIT.
  ENDLOOP.

ENDMETHOD.

METHOD delete_schicht_tab .
  DATA(ls_tabs_schichten) = VALUE wd_this->element_tabs_schichten( ).

  DATA(lt_elements) = wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_elements( ).

  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    <li_element>->get_static_attributes( IMPORTING static_attributes = ls_tabs_schichten ).
    CHECK ls_tabs_schichten-is_gantt_tab = abap_false. ">001< (+)
    CHECK ls_tabs_schichten-object->get_id( ) = iv_schicht_id.

    DATA(lv_schicht_id) = iv_schicht_id.
    wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->remove_element( element = <li_element> ).
    EXIT.
  ENDLOOP.

  IF lv_schicht_id IS NOT INITIAL.
    wd_this->fire_schicht_tab_deleted_evt( iv_schicht_id = lv_schicht_id ).
  ENDIF.
ENDMETHOD.

METHOD get_schicht_object .
  DATA(lt_tabs_schichten) = VALUE wd_this->elements_tabs_schichten( ).

  wd_context->get_child_node( name = wd_this->wdctx_tabs_schichten )->get_static_attributes_table( IMPORTING table = lt_tabs_schichten ).

  READ TABLE lt_tabs_schichten ASSIGNING FIELD-SYMBOL(<ls_tabs_schichten>) WITH KEY zschicht = iv_schicht.
  CHECK <ls_tabs_schichten> IS ASSIGNED.

  ro_schicht = <ls_tabs_schichten>-object.
ENDMETHOD.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD on_schicht_reset .
  DATA(li_node) = wd_context->get_child_node( wd_this->wdctx_tabs_schichten ).
  DATA(lt_elements) = li_node->get_elements( ).

  LOOP AT lt_elements ASSIGNING FIELD-SYMBOL(<li_element>).
    DATA(lv_schicht_id) = VALUE zia_2_workshift( ).
    <li_element>->get_attribute( EXPORTING name  = `ZSCHICHT`
                                 IMPORTING value = lv_schicht_id ).
    CHECK lv_schicht_id = iv_schicht_id.
    li_node->remove_element( <li_element> ).
  ENDLOOP.
ENDMETHOD.

endclass.
 