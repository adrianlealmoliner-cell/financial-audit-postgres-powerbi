# Financial \& Accounting Audit Dashboard (PostgreSQL + Power BI)

## 📌 Project Overview

This project presents an end-to-end financial data pipeline and interactive business intelligence dashboard modeled after the Spanish **Plan General Contable (PGC)**. It demonstrates robust ETL processes, relational data integrity enforcement in **PostgreSQL**, and financial reporting using **Power BI** and **DAX**.

The primary objective is to simulate an enterprise-grade Accounting Information System (AIS) capable of automated double-entry verification, quarterly VAT tax estimation (Modelo 303), and dynamic Income Statement (P\&L) rendering.

\---

## 🛠️ Tech Stack \& Architecture

* **Database Engine:** PostgreSQL 16+
* **Database Client:** DBeaver
* **Business Intelligence \& Analytics:** Power BI Desktop (VertiPaq Engine)
* **Languages:** SQL (Data Definition \& Manipulation), DAX (Data Analysis Expressions)
* **Data Architecture:** Star Schema (1 Fact Table, 2 Dimension Tables)

\---

## 📐 Data Model \& Schema Design

The database schema is built using a strict star-schema layout to optimize analytical queries and DAX measure performance:

1. **`Diario\\\_Contable` (Fact Table):** Contains transactional journal entries with debit/credit balance constraints (`debe >= 0 AND haber >= 0`).
2. **`Cuentas\\\_PGC` (Dimension Table):** Hierarchical mapping of chart of accounts (Grupo, Subgrupo, Cuenta).
3. **`Terceros` (Dimension Table):** Master record of clients, vendors, and third parties.

### Relational Schema (ERD Logic)

```
\\\[Cuentas\\\_PGC] (1) ─── (N) \\\[Diario\\\_Contable] (N) ─── (1) \\\[Terceros]
```

\---

## ⚙️ SQL Implementation \& Audit Queries

### 1\. Data Integrity \& Double-Entry Verification

To ensure no unbalanced journal entries exist in the system, an automated audit query verifies that `SUM(debe) - SUM(haber) = 0` per journal entry ID:

```sql
SELECT 
    num\\\_asiento AS "Asiento",
    SUM(debe) AS "Total Debe (€)",
    SUM(haber) AS "Total Haber (€)",
    (SUM(debe) - SUM(haber)) AS "Descuadre (€)"
FROM Diario\\\_Contable
GROUP BY num\\\_asiento
ORDER BY num\\\_asiento;
```

### 2\. Quarterly VAT Tax Settlement (Modelo 303)

Calculates output VAT (Account 477) minus input VAT (Account 472) to determine net tax liability:

```sql
SELECT 
    SUM(CASE WHEN codigo\\\_cuenta = '4770000' THEN haber - debe ELSE 0 END) AS "IVA Repercutido (€)",
    SUM(CASE WHEN codigo\\\_cuenta = '4720000' THEN debe - haber ELSE 0 END) AS "IVA Soportado (€)",
    SUM(CASE WHEN codigo\\\_cuenta = '4770000' THEN haber - debe ELSE 0 END) - 
    SUM(CASE WHEN codigo\\\_cuenta = '4720000' THEN debe - haber ELSE 0 END) AS "Resultado Liquidación (€)"
FROM Diario\\\_Contable;
```

\---

## 📊 Power BI Analytics \& DAX Formulas



!\[Estado de Pérdidas y Ganancias](dashboard.png)



Data is ingested via direct PostgreSQL connection using Import Mode for optimal performance.

### Core DAX Measures

```dax
// Total Revenues (Group 7 PGC)
Total Ingresos = 
CALCULATE(
    SUM(Diario\\\_Contable\\\[haber]) - SUM(Diario\\\_Contable\\\[debe]),
    Cuentas\\\_PGC\\\[grupo] = "7"
)

// Total Expenses (Group 6 PGC)
Total Gastos = 
CALCULATE(
    SUM(Diario\\\_Contable\\\[debe]) - SUM(Diario\\\_Contable\\\[haber]),
    Cuentas\\\_PGC\\\[grupo] = "6"
)

// Net Financial Result
Resultado del Ejercicio = \\\[Total Ingresos] - \\\[Total Gastos]

// Single-Column P\\\&L Impact Measure
Monto P\\\&G = 
VAR Ingreso = \\\[Total Ingresos]
VAR Gasto = \\\[Total Gastos]
RETURN
COALESCE(Ingreso, 0) - COALESCE(Gasto, 0)
```

\---

## 🚀 Key Visuals \& Features

* **Executive KPI Cards:** Instant visibility into Net Income / Loss.
* **Hierarchical P\&L Matrix:** Drill-down capability from Group to individual Account levels.
* **Waterfall Chart:** Financial bridge visual tracking revenue gains against operational expenses.

\---

## 🚀 How to Run Locally

1. **Clone Repository:**

```bash
   git clone https://github.com/your-username/financial-audit-postgres-powerbi.git
   ```

2. **Execute Database Setup:**

   * Run `scripts/01\\\_schema.sql` in PostgreSQL via DBeaver.
   * Run `scripts/02\\\_sample\\\_data.sql` to populate sample accounting records.
3. **Open Power BI Dashboard:**

   * Open `reports/Financial\\\_Dashboard.pbix`.
   * Update credentials under Data Source Settings (`localhost`, database name, username `postgres`).

