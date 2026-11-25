# JADE-1753: Implementation Guide

## 1. Class to change

Change only this ABAP class:

```text
ZCL_IA_2WORKSHIFT
```

Source file:

```text
ZCL_IA_2RULES/ZCL_IA_2WORKSHIFT.abap
```

Do not change `ZCL_IA_2ORDER_UTILS` or `ZCL_IA_2WORKSHIFT->DEACTIVATE_USER_STATUS`.

## 2. Why the change is needed

Resetting a shift or deleting a work area can leave planning orders with active `PL1` or `PL2` status.

The requirement is to process every planning order and deactivate:

- `PL1`
- `PL2`
- `PL3`

After reset or work-area deletion, the affected planning orders must have `REAL` status.

---

## 3. Change for `RESET`

### Location

Method:

```text
ZCL_IA_2WORKSHIFT->RESET
```

### Code to add

Add the following block after `reset_orsc_status( )`:

```abap
* [START] JADE-1753: Deactivate planning statuses for every reset order
DATA(lo_1753_reset_iterator) = lo_orders->get_values_iterator( ).

WHILE lo_1753_reset_iterator->has_next( ) = abap_true.
  DATA(lo_1753_reset_order) = CAST zcl_ia_2order( lo_1753_reset_iterator->get_next( ) ).
  DATA(lv_1753_reset_order) = lo_1753_reset_order->get_id( ).

  me->deactivate_user_status(
    iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
    iv_order = lv_1753_reset_order ).
ENDWHILE.
* [END] JADE-1753
```

### Code that may be deleted

The following block is marked in the source as `[DELETE CANDIDATE] JADE-1753`:

```abap
IF line_exists( lo_orders->map[ 1 ] ) AND lo_orders->map[ 1 ]-key IS NOT INITIAL.
  lv_order = lo_orders->map[ 1 ]-key.
  me->deactivate_user_status(
    iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
    iv_order = lv_order ).
ENDIF.
```

Delete this block only after SAP verification.

**Reason:** It processes only `lo_orders->map[ 1 ]`. The new loop already processes every order, so keeping both blocks can process the first order twice.

### Code that must remain

Keep the following `READ TABLE` block unchanged:

```abap
READ TABLE lo_orders->map INDEX 1 INTO DATA(ls_entry).

IF sy-subrc = 0 AND ls_entry-key IS NOT INITIAL.
  lv_order = ls_entry-key.
  " Existing maintenance-order phase update continues here.
ENDIF.
```

This block performs the phase update. It is not the user-status cleanup.

---

## 4. Change for `REMOVE_ARBEITSSTELLE`

### Location

Method:

```text
ZCL_IA_2WORKSHIFT->REMOVE_ARBEITSSTELLE
```

### Code to add

Add this block after ERP restore and before `remove_auftraege( )`:

```abap
* [START] JADE-1753: Deactivate planning statuses for every work-area order
DATA(lo_1753_workarea_orders) = io_object->get_auftraege( ).
DATA(lo_1753_order_iterator) = lo_1753_workarea_orders->get_values_iterator( ).

WHILE lo_1753_order_iterator->has_next( ) = abap_true.
  DATA(lo_1753_order) = CAST zcl_ia_2order( lo_1753_order_iterator->get_next( ) ).
  DATA(lv_1753_order) = lo_1753_order->get_id( ).

  me->deactivate_user_status(
    iv_qmnum = CONV zia_2_workshift( gs_schicht-zschicht )
    iv_order = lv_1753_order ).
ENDWHILE.
* [END] JADE-1753
```

### Code to delete

No existing code needs to be deleted in `REMOVE_ARBEITSSTELLE`.

---

## 5. Existing method to reuse

Reuse this existing method:

```text
ZCL_IA_2WORKSHIFT->DEACTIVATE_USER_STATUS
```

No change is required in this method.

It:

1. Reads the order object number.
2. Reads active SAP user statuses.
3. Deactivates `PL1`, `PL2`, and `PL3`.

---

## 6. Clear change summary

| Method | Code to add | Existing code to delete |
|---|---|---|
| `RESET` | Full-order iterator loop | First-order `IF line_exists(...)` status block, after verification |
| `REMOVE_ARBEITSSTELLE` | Full-order iterator loop | Nothing |
| `DEACTIVATE_USER_STATUS` | Nothing | Nothing |

## 7. SAP test verification

Use disposable, Dispo-released GBT shifts:

| Test | Shift |
|---|---|
| Reset from starting page | `1500004173` |
| Reset from detail page | `1500004174` |
| Delete work area | `1500004175` |
| Delete work area | `1500004176` |

After each test, verify every affected planning order:

- `PL1` is inactive.
- `PL2` is inactive.
- `PL3` is inactive.
- `REAL` status is present.
