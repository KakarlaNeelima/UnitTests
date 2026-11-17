# Manual Changes: `GET_AUFTRAEGE_PLANUNG`

## Scope

Apply these changes manually in:

```text
ZCL_IA_2WRKPLACE->GET_AUFTRAEGE_PLANUNG
```

The method currently stops after filtering orders by blocking section. The corresponding legacy method, `ZCL_IO_5_ARBEITSSTELLE->GET_AUFTRAEGE_PLANUNG`, additionally:

1. Determines the permitted kilometer extension of the workplace.
2. Removes orders outside that extension.
3. Returns the remaining orders in `rt_auftraege`.

## Step 1: Add declarations

After the existing loop that filters `lt_auftraege` by blocking section, add:

```abap
DATA: lv_max_sa TYPE i,
      lt_sa     TYPE STANDARD TABLE OF zia_2sc,
      ls_sa     TYPE zia_2sc,
      lv_km     TYPE zia_2_km,
      lv_km_von TYPE zia_2_km,
      lv_km_bis TYPE zia_2_km,
      lv_index  TYPE i,
      lv_lines  TYPE i.
```

## Step 2: Determine the allowed kilometer range

Add the following code after the declarations:

```abap
IF iv_km_min IS NOT INITIAL OR iv_km_max IS NOT INITIAL.
  lv_km_von = iv_km_min.
  lv_km_bis = iv_km_max.
ELSE.
  lv_max_sa = me->get_schicht( )->get_parameter( )->get_data( )-max_ausdehnung.
  DATA(lv_est) = me->go_schicht->get_rj_est( ).

  SELECT *
    FROM zia_2sc
    INTO TABLE @lt_sa
    WHERE zest = @lv_est.

  SORT lt_sa BY km_von.
  DESCRIBE TABLE lt_sa LINES lv_lines.

  LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmin
                             AND km_bis >= me->get_data( )-zkmin.
    lv_index = sy-tabix + lv_max_sa.
    IF lv_index > lv_lines.
      lv_index = lv_lines.
    ENDIF.
    READ TABLE lt_sa INDEX lv_index INTO ls_sa.
    lv_km_bis = ls_sa-km_bis.
  ENDLOOP.

  LOOP AT lt_sa INTO ls_sa WHERE km_von <= me->get_data( )-zkmax
                             AND km_bis >= me->get_data( )-zkmax.
    lv_index = sy-tabix - lv_max_sa.
    IF lv_index < 0.
      lv_index = 0.
    ENDIF.
    READ TABLE lt_sa INDEX lv_index INTO ls_sa.
    lv_km_von = ls_sa-km_von.
  ENDLOOP.
ENDIF.
```

## Step 3: Remove orders outside the permitted range

Add this code immediately after Step 2:

```abap
LOOP AT lt_auftraege ASSIGNING FIELD-SYMBOL(<ls_auftrag>).
  CASE <ls_auftrag>-zstdkz.
    WHEN 'S'.
      DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
    WHEN 'Q'.
      IF me->go_schicht->get_rj_est( ) = mc_sperrabs-w
      OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w1
      OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w2
      OR me->go_schicht->get_rj_est( ) = mc_sperrabs-w3.
        SELECT SINGLE zkm_w
          FROM zia_2lateral_tb
          INTO @lv_km
          WHERE zkm_e = @<ls_auftrag>-zzkmvpl
            AND zzperi = @<ls_auftrag>-zzperi.
      ELSE.
        lv_km = <ls_auftrag>-zzkmvpl.
      ENDIF.

      IF lv_km NOT BETWEEN lv_km_von AND lv_km_bis.
        DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
      ENDIF.
    WHEN 'T'.
      IF <ls_auftrag>-zzkmvpl NOT BETWEEN lv_km_von AND lv_km_bis
      OR <ls_auftrag>-zzkmbpl NOT BETWEEN lv_km_von AND lv_km_bis.
        DELETE lt_auftraege WHERE aufnr = <ls_auftrag>-aufnr.
      ENDIF.
  ENDCASE.
ENDLOOP.
```

Behavior:

- `S` orders are excluded.
- `Q` orders use their west-side kilometer (`zkm_w`) for west-oriented blocking sections (`W`, `W1`, `W2`, `W3`).
- `T` orders are retained only if both planned kilometer values are within the range.

## Step 4: Set the returning parameter

Before `ENDMETHOD.`, add:

```abap
rt_auftraege = lt_auftraege.
```

## Step 5: Activate and validate

1. Activate `ZCL_IA_2WRKPLACE`.
2. Run the related ABAP Unit tests or the planning flow.
3. Validate these cases:
   - Explicit `iv_km_min` and `iv_km_max`.
   - No KM parameters, using `max_ausdehnung`.
   - `S`, `Q`, and `T` orders inside and outside the allowed range.
   - `Q` orders for `W`, `W1`, `W2`, and `W3`.
