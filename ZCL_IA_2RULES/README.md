# ZCL_IA_2RULES - Unit Tests

## Overview
This folder contains the ABAP class `ZCL_IA_2RULES` and its unit test suite.

## Files Structure
```
ZCL_IA_2RULES/
├── zcl_ia_2rules.abap       # Main class implementation
├── zcl_ia_2rules_test.abap  # Unit test class
└── README.md                 # This file
```

## Class Description
**ZCL_IA_2RULES** is a rules engine class for handling various business rules related to:
- Vehicle management (Fahrzeuge)
- Seating allocation (Sitzplätze)
- Order validation and checking
- Rule enforcement and validation

### Key Methods
1. **GET_REGELSTEUERUNG** - Retrieves and caches rule control data
2. **IS_REGEL_PFLICHT** - Checks if a rule is mandatory
3. **MOVE_SEATS_INSTANCE** - Handles seat movement logic
4. **CHECK_AUF_EINZELKAPAS_RULES** - Validates individual capacity rules
5. **GET_FAHRZEUG** - Retrieves vehicles
6. **CHECK_DATUM** - Validates dates
7. **CHECK_SA_GAP** - Checks signal section gaps
8. **GET_SITZPLATZ** - Retrieves seating

## Unit Test Coverage

### Test Class: `lcl_ia_2rules`

The test suite includes **9 test methods** covering testable functionality:

| Test Method | Purpose | Coverage Target |
|------------|---------|----------------|
| `test_get_regelsteuerung` | Tests rule control retrieval | Database read |
| `test_get_regelsteuerung_cache` | Tests caching mechanism | Cache validation |
| `test_is_regel_pflicht_gbt` | Tests mandatory rule check (closed track) | Business logic |
| `test_is_regel_pflicht_osx` | Tests mandatory rule check (open track) | Business logic |
| `test_is_regel_not_found` | Tests non-existent rule handling | Error handling |
| `test_move_seats_instance` | Tests seat movement flags | Simple logic |
| `test_check_kapas_rules_free` | Tests capacity rules with free seat | Allocation logic |
| `test_check_kapas_rules_no_free` | Tests capacity rules without free seat | Error scenario |
| `test_constants_defined` | Tests class constants | Constants validation |

### Coverage Areas
- ✅ Rule control retrieval and caching
- ✅ Mandatory rule validation logic
- ✅ Seat capacity allocation rules
- ✅ Error handling for missing data
- ✅ Constant definitions
- ⚠️ Methods with complex dependencies (limited testing)

### Methods Difficult to Test
The following methods have complex external dependencies and are difficult to test in isolation:
- `GET_FAHRZEUG` - Requires workplace object, creates database records
- `GET_BASIS_FAHRZEUG` - Complex logic with multiple dependencies
- `CHECK_DATUM` - Requires order and workplace objects
- `CHECK_SA_GAP` - Very complex with many database reads
- `CHECK_AUF_EINZELKAPAS` - Requires multiple object dependencies

These would require integration tests or mocking frameworks beyond standard ABAP Unit capabilities.

### Expected Coverage
**Target: 35-45% coverage**

Coverage is limited by:
- Many methods require complex object dependencies
- Database interactions throughout
- Methods interact with external classes (ZCL_IA_2WRKPLACE, ZCL_IA_2ORDER, etc.)
- Limited mocking capabilities in ABAP Unit Testing

## Running the Tests

### In SAP GUI
1. Open transaction `SE80` or `SE24`
2. Navigate to class `ZCL_IA_2RULES`
3. Right-click and select "Execute" → "Unit Tests" (Shift+Ctrl+F10)
4. View results in the ABAP Unit Test Runner

### Via ABAP Test Cockpit (ATC)
1. Open transaction `ATC`
2. Add the class to the object set
3. Execute the check
4. Review coverage results

## Dependencies
The class depends on:
- `ZCL_IA_2WRKPLACE` - Workplace management
- `ZCL_IA_2ORDER` - Order management
- `ZCL_IA_2VEHICLE` - Vehicle management
- `ZCL_IA_2SEAT` - Seating management
- `ZCL_IA_2UTILITIES2` - Utility functions
- `ZCL_IA_2MESSAGE_MANAGER` - Message handling
- `CL_OBJECT_MAP` - Object collection management
- Various database tables (ZIA_2CONTROL_AP, ZIA_2VEHICLES, etc.)

## Test Naming Conventions
- Test class: `lcl_ia_2rules` (lcl_ prefix)
- Variables: Hungarian notation
  - `lv_` for local variables
  - `lo_` for object references
  - `lt_` for tables
  - `ls_` for structures
  - `li_` for interface references
- Method names: ≤ 30 characters
- All tests use `RAISING cx_static_check`

## Notes
- All test methods include proper exception handling
- Tests focus on methods with minimal external dependencies
- Integration tests would be needed for full coverage of complex methods
- Test duration: SHORT (executes quickly)
- Risk level: HARMLESS (no system modifications during tests)

## Maintenance
When modifying the main class:
1. Run existing unit tests to ensure no regression
2. Add new test methods for new functionality where possible
3. Update this README with new test coverage information
4. Document any untestable methods and reasons

## Author
Generated for unit testing purposes
Date: 2026-02-26
