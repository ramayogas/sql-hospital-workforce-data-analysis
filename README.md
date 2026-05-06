# Hospital Workforce Data Cleaning
**Tool:** SQL (SQLite)  
**Domain:** Healthcare  
**Dataset:** Simulated hospital employee data (anonymized)

---

## Overview

Inconsistent employee records are a common data quality issue in hospital information systems, especially around name formatting, profession classification, and demographic fields. Messy HR data leads to reporting errors, duplicate records, and failed system integrations.

This project demonstrates a **structured SQL-based data cleaning pipeline** for hospital workforce data, from raw ingestion to a clean, standardized output table.

---

## Problem Statement

Given a raw employee dataset with issues including:
- Inconsistent or improperly formatted full names
- Missing or misclassified profession and profession group references
- Incorrect data types on date fields
- Unvalidated gender entries

**Goal:** Produce a clean, reliable employee table suitable for HR reporting and system integration.

---

## Database Schema

```
employees_raw          → raw ingestion table (uncleaned)
employees              → cleaned output table
employee_professions   → lookup: profession_id → profession_name
employee_profession_groups → lookup: profession_group_id → group_name
```

The design separates raw and clean tables intentionally — preserving the original data while building a validated version alongside it.

---

## Cleaning Steps

| Step | Issue Handled | SQL Technique |
|---|---|---|
| Name standardization | Inconsistent casing, extra spaces | `TRIM()`, `UPPER()`, `LOWER()` |
| Profession validation | Orphaned profession_id references | `LEFT JOIN` + `NULL` check |
| Gender normalization | Mixed formats (M/F, Male/Female, etc.) | `CASE WHEN` |
| Date type validation | Invalid or out-of-range date strings | `DATE()`, conditional filtering |
| Duplicate detection | Repeated employee_id entries | `GROUP BY` + `HAVING COUNT > 1` |

---

## Sample Query

```sql
-- Standardize full_name: trim whitespace and title-case
UPDATE employees
SET full_name = TRIM(
    UPPER(SUBSTR(full_name, 1, 1)) ||
    LOWER(SUBSTR(full_name, 2))
)
WHERE full_name IS NOT NULL;
```

> Full cleaning queries available in [`/queries`](./queries/)

---

## Repo Structure

```
sql-hospital-workforce-data-cleaning/
├── data/
│   └── employees_raw.csv       # Raw input data
├── queries/
│   └── cleaning.sql            # All cleaning queries, annotated
├── schemas.sql                 # Table definitions (raw + clean)
├── seed.sql                    # Sample data seed
└── README.md
```

---

## Tools Used

`SQL` `SQLite` `Relational Schema Design` `Data Cleaning`

---

## Notes

- Dataset is simulated to reflect realistic hospital HR data issues, no real patient or employee data is used
- Schema uses foreign key constraints to enforce referential integrity between professions and profession groups
- Raw table is kept intact throughout the process; all cleaning is applied to the `employees` table

---

*Part of my [data portfolio](https://github.com/ramayogas/data-portofolio) — Rama Yogaswara*
