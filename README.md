# India Traffic Accident Risk — Severity-Based Analysis

## Project Overview

This project performs a **severity-driven analysis of traffic accidents in India** to identify regions where accident outcomes are disproportionately fatal or severe — not merely where accidents are frequent.

Instead of ranking regions by accident volume alone, the analysis introduces a **Severity Index** combining fatalities, injuries, and total cases to uncover **hidden high-risk regions** that require urgent road safety intervention.

The project uses **SQL for data validation and modeling** and **Tableau for analytical visualization and storytelling**.

---

## Business Problem

High accident counts do **not necessarily imply higher fatality risk**.

Policy decisions based solely on accident volume can misallocate resources, overlooking regions where:
- Fatality rates are unusually high
- Injury severity is disproportionate
- Structural risk exists despite moderate accident counts

### Key Question  
**Which regions face the highest traffic accident severity risk — and why?**

---

## Analytical Approach

The analysis focuses on **severity over scale**, using the following steps:

### 1. Data Audit & Validation
- Verified raw CSV structure and row counts
- Identified and handled aggregated “Total” rows
- Ensured internal consistency across:
  - Road accidents
  - Railway accidents
  - Railway crossing accidents

### 2. Severity Index Construction
A composite metric was created using:
- **Fatality Rate** (Total Died / Total Cases)
- **Injury Rate** (Total Injured / Total Cases)
- **Severity Index** = Fatality Rate + Injury Rate

This allows comparison across regions of different sizes.

### 3. Risk Classification
Regions were categorised into:
- **High Risk**
- **Medium Risk**
- **Low Risk**

based on Severity Index thresholds.

---

## Data Modeling (SQL)

Key SQL tasks included:
- Data type standardisation
- Removal of non-analytical aggregate rows
- Validation queries ensuring:
  - Mode-wise cases sum correctly to totals
- Creation of a **Tableau-ready analytical view**

Example validation logic:
- `Total Cases = Road + Rail + Crossing Cases`
- `Total Injured = Sum of mode-wise injured`
- `Total Died = Sum of mode-wise fatalities`

---

## Visual Analytics (Tableau)

The final dashboard includes:

### Top 10 High-Risk Regions by Severity
- Ranks regions by Severity Index
- Highlights states/cities with disproportionate fatality risk

### Severity vs Accident Volume (Risk Quadrants)
- Scatter plot comparing:
  - Total Cases (volume)
  - Severity Index (impact)
- Reveals regions with **high severity but moderate volume**

### Transport Mode Breakdown (High-Risk Regions)
- Stacked bars showing:
  - Road accidents
  - Railway accidents
  - Railway crossing accidents
- Demonstrates that **road accidents dominate fatality risk**

### Interactive Filters
- Risk Category
- Region selection
- Cross-filtering across all visuals

---

## Key Insights

- **High accident volume does not always correlate with high severity**
- Several regions show **elevated fatality risk despite moderate accident counts**
- **Road accidents account for the majority of severe outcomes**, even in rail-connected states
- Severity-based prioritisation provides **better guidance for safety interventions**

---

## Tools & Technologies

- **SQL (MySQL 8.0)** – Data validation, transformation, and modeling
- **Tableau Public** – Visual analytics and dashboarding
- **Excel** – Initial data inspection
