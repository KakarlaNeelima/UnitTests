class CL_V_POPUP_BEMERKUNG_Ctr implementation.
 
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

method WDDOAFTERACTION . "#EC NEEDED
endmethod.

method WDDOBEFOREACTION . "#EC NEEDED
*  data lo_api_controller type ref to if_wd_view_controller.
*  data lo_action         type ref to if_wd_action.

*  lo_api_controller = wd_this->wd_get_api( ).
*  lo_action = lo_api_controller->get_current_action( ).

*  if lo_action is bound.
*    case lo_action->name.
*      when '...'.

*    endcase.
*  endif.
endmethod.

method WDDOEXIT . "#EC NEEDED
endmethod.

method WDDOINIT . "#EC NEEDED
endmethod.

method WDDOMODIFYVIEW . "#EC NEEDED
endmethod.

method WDDOONCONTEXTMENU . "#EC NEEDED
endmethod.

* +-------------------------------------------------------------------+
* |  event handlers                                                   |
* +-------------------------------------------------------------------+

METHOD onactionadd_notes .
  DATA ls_schichtplan     TYPE wd_this->element_schichtplan.
  DATA ls_bemerkung       TYPE wd_this->element_popup_bemerkung.


  "------------------------------------------------------------------------------------------------------
  " Kontext auslesen
  "------------------------------------------------------------------------------------------------------
  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->get_static_attributes( IMPORTING static_attributes = ls_schichtplan ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_bemerkung )->get_element( )->get_static_attributes( IMPORTING static_attributes = ls_bemerkung ).


  "*******************
  "* Bemerkungen in Schicht erfassen
  "***************
  IF ls_bemerkung-new_bemerkung IS NOT INITIAL.
    ls_schichtplan-object->add_notes( ls_bemerkung-new_bemerkung ).
    ls_schichtplan-notes_icon = '~Icon/PlaintextFile'.
    ls_schichtplan-notes_tooltip = cl_wd_utilities=>get_otr_text_by_alias( alias = 'ZIA_2GBT_PG2/COMMENTS_EXIST' ).
    ls_schichtplan-notes_visibile = COND #( WHEN ls_schichtplan-edit_mode EQ abap_true THEN abap_true ELSE abap_false ).
  ENDIF.

  DATA(lt_current_bemerkungen) = ls_schichtplan-object->get_notes( ).
  ls_bemerkung-show_current = COND #( WHEN lt_current_bemerkungen IS INITIAL THEN abap_false ELSE abap_true ).

  IF ls_schichtplan-edit_mode EQ abap_true.
    ls_bemerkung-show_new = abap_true.
  ELSE.
    ls_bemerkung-show_current = abap_false.
  ENDIF.

  CLEAR ls_bemerkung-new_bemerkung.

  "*******************
  "* Update Kontext
  "***************
  wd_context->get_child_node( name = wd_this->wdctx_popup_bemerkung )->get_element( )->set_static_attributes( static_attributes = ls_bemerkung ).
  wd_context->get_child_node( name = wd_this->wdctx_popup_bemerkung )->get_child_node( name = wd_this->wdctx_current_bemerkungen )->bind_table(
    EXPORTING new_items = lt_current_bemerkungen set_initial_elements = abap_true ).
  wd_context->get_child_node( name = wd_this->wdctx_schichtplan )->set_static_attributes( static_attributes = ls_schichtplan ).


  wd_context->get_child_node( name = wd_this->wdctx_schichtdetails )->invalidate( ).

  "*******************
  "* Popup schliessen
  "***************
  wd_this->wd_get_api( )->get_embedding_window( )->close( ).

ENDMETHOD.

* +-------------------------------------------------------------------+
* |  supply methods                                                   |
* +-------------------------------------------------------------------+

method SUPPLY_JOBPOOL_POPIN_DETAILS . "#EC NEEDED
* General Notes
* =============
* A common scenario for a supply method is to aquire key
* informations from the parameter <parent_element> and then
* to invoke a data provider.
* A free navigation thru the context, especially to nodes on
* the same or deeper hierachical level is strongly discouraged,
* because such a strategy may easily lead to unresolvable
* situations!!

*  if necessary, get static attributes of parent element
*  DATA ls_parent_attributes TYPE wd_this->element_table_popin_jobpool.
*  parent_element->get_static_attributes(
*    IMPORTING
*      static_attributes = ls_parent_attributes ).

*
** data declaration
*  DATA lt_jp_popin_detail TYPE wd_this->Elements_jp_popin_detail.
*  DATA ls_jp_popin_detail LIKE LINE OF lt_jp_popin_detail.
** @TODO compute values
** e.g. call a data providing FuBa
*
** bind all the elements
*  node->bind_table(
*    new_items            =  lt_jp_popin_detail
*    set_initial_elements = abap_true ).
*
endmethod.

method SUPPLY_SP_INTVART_AS . "#EC NEEDED
* General Notes
* =============
* A common scenario for a supply method is to aquire key
* informations from the parameter <parent_element> and then
* to invoke a data provider.
* A free navigation thru the context, especially to nodes on
* the same or deeper hierachical level is strongly discouraged,
* because such a strategy may easily lead to unresolvable
* situations!!

*  if necessary, get static attributes of parent element
*  DATA ls_parent_attributes TYPE wd_this->element_schichtdetails.
*  parent_element->get_static_attributes(
*    IMPORTING
*      static_attributes = ls_parent_attributes ).

*
** data declaration
*  DATA lt_sp_intvart_as TYPE wd_this->Elements_sp_intvart_as.
*  DATA ls_sp_intvart_as LIKE LINE OF lt_sp_intvart_as.
** @TODO compute values
** e.g. call a data providing FuBa
*
** bind all the elements
*  node->bind_table(
*    new_items            =  lt_sp_intvart_as
*    set_initial_elements = abap_true ).
*
endmethod.

endclass.
 