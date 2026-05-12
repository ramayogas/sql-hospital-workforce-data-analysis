# SQL Hospital Workforce Data Analysis

![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat)

A structured SQL pipeline for cleaning and analyzing simulated hospital employee data.
Built to address real-world HR data quality issues and extract workforce insights.

> Dataset is simulated to reflect realistic hospital HR data issues — no real patient or employee data is used.

---

## Overview

Hospital HR systems frequently suffer from inconsistent records — malformed names, misclassified professions, and unvalidated demographic fields. This project demonstrates a full SQL-based pipeline from raw ingestion to clean data and actionable workforce analytics.

**Dataset:** 1,482 simulated hospital employees (anonymized)  
**Tool:** SQLite  
**Domain:** Healthcare / HR Analytics

---

## Pipeline

```
employees_raw.csv
      ↓
01_raw_data.sql       → Load raw data
      ↓
02_data_cleaning.sql  → Standardize, validate, deduplicate
      ↓
03_final_view.sql     → Build clean employees table
      ↓
04_analysis.sql       → Workforce analytics & data quality report
      ↓
outputs/              → CSV results
```

---

## Cleaning Steps

| Step | Issue Handled | SQL Technique |
|---|---|---|
| Name standardization | Malformed name format (44.2% of records) | `TRIM()`, `PROPER()` |
| Gender normalization | Mixed formats (M/F, Male/Female, etc.) | `CASE WHEN` |
| Date type validation | Invalid or out-of-range date strings | `DATE()`, conditional filtering |
| Profession validation | Orphaned `profession_id` references | `LEFT JOIN` + NULL check |
| Duplicate detection | Repeated `employee_id` entries | `GROUP BY` + `HAVING COUNT > 1` |

---

## Key Findings

- **56.07%** of employees are female; **43.93%** male
- **Nurses** are the largest profession group, making up **23%** of total workforce
- **44.2%** of employee names had malformed formatting before cleaning — all resolved post-pipeline
- The workforce is dominated by **Millennials (25–40)** and **Gen X (41–56)**
- **Specialist Doctors** and **Doctors** combined account for **13%** of total staff
- Female nurses alone represent **18.42%** of the entire workforce

---

## Analysis Performed

1. **Gender Distribution** — overall male vs female headcount and percentage
2. **Profession Distribution** — headcount and percentage across all 25 professions
3. **Most Common Professions** — top 5 professions by employee count
4. **Gender Breakdown per Profession** — gender split within each profession
5. **Age Distribution per Generation** — workforce segmented by Gen Z, Millennial, Gen X, Baby Boomers
6. **Name Format Standardization Rate** — before vs after cleaning comparison

---

## Repo Structure

```
sql-hospital-workforce-data-analysis/
├── data/
│   └── employees_raw.csv
├── queries/
│   ├── 01_raw_data.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_final_view.sql
│   └── 04_analysis.sql
├── outputs/
│   ├── employees_clean.csv
│   ├── gender_distribution.csv
│   ├── profession_distribution.csv
│   ├── gender_by_profession.csv
│   ├── age_generation_distribution.csv
│   └── data_quality_report.csv
├── schemas.sql
├── seed.sql
└── README.md
```

---

## Database Schema

```
employees_raw              → raw ingestion table (uncleaned)
employees                  → cleaned output table
employee_professions       → lookup: profession_id → profession_name
employee_profession_groups → lookup: profession_group_id → group_name
```

Raw and clean tables are kept separate intentionally — preserving original data while building a validated version alongside it.

---

## How to Run

**Requirements:** SQLite 3.30+

```bash
# 1. Clone the repository
git clone https://github.com/ramayogas/sql-hospital-workforce-data-analysis.git
cd sql-hospital-workforce-data-analysis

# 2. Open SQLite and run files in order
sqlite3 data/hospital.db

# 3. Inside SQLite shell, run in this order:
.read schemas.sql
.read seed.sql
.read queries/01_raw_data.sql
.read queries/02_data_cleaning.sql
.read queries/03_final_view.sql
.read queries/04_analysis.sql
```

Outputs are available as ready-to-use CSV files in the `/outputs` folder — no setup required to view results.

---

*Part of my data portfolio — Rama Yogaswara*