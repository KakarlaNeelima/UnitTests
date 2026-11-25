# JADE-1753: Implementation Location

## Main class to change

Class:

`ZCL_IA_2WORKSHIFT`

File:

`ZCL_IA_2RULES/ZCL_IA_2WORKSHIFT.abap`

## Methods to update

### 1. `RESET`

Process every planning order linked to each work area. The existing logic currently checks only the first order entry in the order map.

Changes required:

- Iterate through all orders returned by `lo_orders`.
- Deactivate `PL1`, `PL2`, and `PL3` for every affected order.
- Update or verify the order phase for each order.
- Continue removing all orders and vehicles from the work area.

The first-order check must be replaced with processing for every order in the order map.

Modify this block in `ZCL_IA_2WORKSHIFT->RESET`:

```abap
TRY.
    zcl_ia_2order_utils=>reset_orsc_status( io_auftraege = lo_orders ).
  ##NO_HANDLER CATCH zcx_ia_2failure.
ENDTRY.
```

Replace the existing first-entry and `READ TABLE` status logic:

```abap
IF line_exists( lo_orders->map[ 1 ] ) AND lo_orders->map[ 1 ]-key IS NOT INITIAL.
  lv_order = lo_orders->map[ 1 ]-key.
  me->deactivate_user_status( iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
                             iv_order = lv_order ).
ENDIF.

READ TABLE lo_orders->map INDEX 1 INTO DATA(ls_entry).
```

with an iterator loop that processes every order:

```abap
DATA(lo_order_iterator) = lo_orders->get_values_iterator( ).

WHILE lo_order_iterator->has_next( ) = abap_true.
  DATA(lo_order) = CAST zcl_ia_2order( lo_order_iterator->get_next( ) ).

  lv_order = lo_order->get_id( ).

  me->deactivate_user_status(
    iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
    iv_order = lv_order ).

  zcl_ia_2utilities=>update_maint_ord_phase(
    iv_aufnr                    = lv_order
    iv_maintordovrlprocphase    = lv_maintordovrlprocphase
    iv_maintordovrlprocsubphase = lv_maintordovrlprocsubphase ).
ENDWHILE.
```

Remove the old separate `READ TABLE lo_orders->map INDEX 1` block after the new loop to prevent duplicate phase processing.

### 2. `REMOVE_ARBEITSSTELLE`

Before removing the work area's orders, process every order linked to `io_object`.

Changes required:

- Get all orders using `io_object->get_auftraege( )`.
- Process each order in the returned order map.
- Deactivate `PL1`, `PL2`, and `PL3` for each affected order.
- Then continue existing work-area deletion logic.

Add an order-iterator loop in `ZCL_IA_2WORKSHIFT->REMOVE_ARBEITSSTELLE` after ERP restore and before:

```abap
io_object->remove_auftraege( iv_change_erp = abap_false ).
```

Use this code pattern:

```abap
DATA(lo_workarea_orders) = io_object->get_auftraege( ).
DATA(lo_order_iterator) = lo_workarea_orders->get_values_iterator( ).

WHILE lo_order_iterator->has_next( ) = abap_true.
  DATA(lo_order) = CAST zcl_ia_2order( lo_order_iterator->get_next( ) ).

  DATA(lv_order) = lo_order->get_id( ).

  me->deactivate_user_status(
    iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
    iv_order = lv_order ).
ENDWHILE.
```

This loop must be present before `remove_auftraege`, because order removal clears the work-area order assignments afterward.

## Supporting method

Method:

`ZCL_IA_2WORKSHIFT->DEACTIVATE_USER_STATUS`

Reuse this existing method for both reset and work-area deletion. It is responsible for reading active user statuses and deactivating `PL1`, `PL2`, and `PL3`.

## Optional supporting class

Class:

`ZCL_IA_2ORDER_UTILS`

File:

`ZCL_IA_2ORDER_UTILS/ZCL_IA_2ORDER_UTILS.abap`

Use this class only if the status cleanup is centralized as a new shared order-status method. The existing reset and work-area deletion methods can initially call `ZCL_IA_2WORKSHIFT->DEACTIVATE_USER_STATUS` directly.
