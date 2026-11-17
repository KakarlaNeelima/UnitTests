# How to Use These Test Files

## Quick Instructions

### Step 1: Open SAP
```
Transaction: SE24 or SE80
Class: ZCL_IA_2CONTEXT_HELPER
```

### Step 2: Go to Test Classes Tab
- Click on "Test Classes" button/tab in SE24
- This opens the test include for the class

### Step 3: Copy the Test Code
- Open file: `zcl_ia_2context_helper_test_internal.abap`
- **Copy ALL contents** (Ctrl+A, Ctrl+C)
- **Paste into Test Classes tab** in SE24 (Ctrl+V)

### Step 4: Activate
- Click "Activate" or press Ctrl+F3
- Fix any syntax errors if needed

### Step 5: Run Tests
- Right-click on class name
- Select "Execute" → "Unit Tests" (Shift+Ctrl+F10)
- Or use transaction: SAUNIT_CLIENT_SETUP

### Expected Result
- ✅ All tests should pass
- ✅ Coverage should be **25-35%** (target: >20%)

## File Summary

| File | Purpose | Coverage | Location |
|------|---------|----------|----------|
| `zcl_ia_2context_helper_test.abap` | External tests | 1.46% | Keep as file |
| `zcl_ia_2context_helper_test_internal.abap` | **Internal tests** | **25-35%** | **Copy to SAP** |

## Why Two Files?

**External test file** (`_test.abap`):
- Can be included as external file
- Only tests public methods and constants
- Cannot access local classes
- Low coverage (1.46%)

**Internal test file** (`_test_internal.abap`):
- Must be in SAP Test Classes tab
- Tests local classes where actual logic is
- High coverage (25-35%)
- **This is the one that achieves >20% target!**

## Troubleshooting

### Error: "Local class not found"
- **Solution**: Make sure you copied into Test Classes tab, not as external include

### Error: "Interface not found"
- **Solution**: Check that interface `lif_ctxelem_interpreter` is defined in class

### Tests fail
- **Solution**: Check that local classes implementation is present in main class

### Coverage still low
- **Solution**: Make sure you're running tests from INSIDE the class in SE24, not externally

## Naming Conventions Used
✅ Test class: `lcl_` prefix (lcl_test_context_helper)
✅ Variables: Hungarian notation (lv_, li_, lo_, lt_)
✅ NO instance attributes
✅ Method names ≤ 30 characters
✅ Uses RAISING cx_static_check

---

**Need help?** See `TESTING_INSTRUCTIONS.md` for detailed explanation.
