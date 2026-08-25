📌 \*\*Project Overview\*\*

This project presents an end-to-end financial data pipeline and interactive business intelligence dashboard modeled after the Spanish Plan General Contable (PGC). It demonstrates robust ETL processes, relational data integrity enforcement in PostgreSQL, and financial reporting using Power BI and DAX.



The primary objective is to simulate an enterprise-grade Accounting Information System (AIS) capable of automated double-entry verification, quarterly VAT tax estimation (Modelo 303), and dynamic Income Statement (P\&L) rendering.



\---



🛠️ \*\*Tech Stack \& Architecture\*\*

\* \*\*Database Engine:\*\* PostgreSQL 16+

\* \*\*Database Client:\*\* DBeaver

\* \*\*Business Intelligence \& Analytics:\*\* Power BI Desktop (VertiPaq Engine)

\* \*\*Languages:\*\* SQL (Data Definition \& Manipulation), DAX (Data Analysis Expressions)

\* \*\*Data Architecture:\*\* Star Schema (1 Fact Table, 2 Dimension Tables)



\---



📐 \*\*Data Model \& Schema Design\*\*

The database schema is built using a strict star-schema layout to optimize analytical queries and DAX measure performance:

\* `Diario\_Contable` (Fact Table): Contains transactional journal entries with debit/credit balance constraints (`debe >= 0 AND haber >= 0`).

\* `Cuentas\_PGC` (Dimension Table): Hierarchical mapping of chart of accounts (Grupo, Subgrupo, Cuenta).

\* `Terceros` (Dimension Table): Master record of clients, vendors, and third parties.



\*\*Relational Schema (ERD Logic)\*\*



\[Cuentas\_PGC] (1) ─── (N) \[Diario\_Contable] (N) ─── (1) \[Terceros]



\---



⚙️ \*\*SQL Implementation \& Audit Queries\*\*



\*\*1. Data Integrity \& Double-Entry Verification\*\*



To ensure no unbalanced journal entries exist in the system, an automated audit query verifies that `SUM(debe) - SUM(haber) = 0` per journal entry ID:



```sql



SELECT 

&#x20;   num\_asiento AS "Asiento",

&#x20;   SUM(debe) AS "Total Debe (€)",

&#x20;   SUM(haber) AS "Total Haber (€)",

&#x20;   (SUM(debe) - SUM(haber)) AS "Descuadre (€)"

FROM Diario\_Contable

GROUP BY num\_asiento

ORDER BY num\_asiento;



2\. Quarterly VAT Tax Settlement (Modelo 303)

Calculates output VAT (Account 477) minus input VAT (Account 472) to determine net tax liability:





```sql



SELECT 

&#x20;   SUM(CASE WHEN codigo\_cuenta = '4770000' THEN haber - debe ELSE 0 END) AS "IVA Repercutido (€)",

&#x20;   SUM(CASE WHEN codigo\_cuenta = '4720000' THEN debe - haber ELSE 0 END) AS "IVA Soportado (€)",

&#x20;   SUM(CASE WHEN codigo\_cuenta = '4770000' THEN haber - debe ELSE 0 END) - 

&#x20;   SUM(CASE WHEN codigo\_cuenta = '4720000' THEN debe - haber ELSE 0 END) AS "Resultado Liquidación (€)"

FROM Diario\_Contable;



📊 **Power BI Analytics \& DAX Formulas**



Data is ingested via direct PostgreSQL connection using Import Mode for optimal performance.



**Core DAX Measures**



// Total Revenues (Group 7 PGC)

Total Ingresos = 

CALCULATE(

&#x20;   SUM(Diario\_Contable\[haber]) - SUM(Diario\_Contable\[debe]),

&#x20;   Cuentas\_PGC\[grupo] = "7"

)



// Total Expenses (Group 6 PGC)

Total Gastos = 

CALCULATE(

&#x20;   SUM(Diario\_Contable\[debe]) - SUM(Diario\_Contable\[haber]),

&#x20;   Cuentas\_PGC\[grupo] = "6"

)



// Net Financial Result

Resultado del Ejercicio = \[Total Ingresos] - \[Total Gastos]



// Single-Column P\&L Impact Measure

Monto P\&G = 

VAR Ingreso = \[Total Ingresos]

VAR Gasto = \[Total Gastos]

RETURN

COALESCE(Ingreso, 0) - COALESCE(Gasto, 0)



**🚀 Key Visuals \& Features**



**Executive KPI Cards:** Instant visibility into Net Income / Loss.



**Hierarchical P\&L Matrix:** Drill-down capability from Group to individual Account levels.



**Waterfall Chart:** Financial bridge visual tracking revenue gains against operational expenses.



**🚀 How to Run Locally**



<<<<<<< HEAD
**1. Clone Repository:**



git clone \[https://github.com/your-username/financial-audit-postgres-powerbi.git](https://github.com/your-username/financial-audit-postgres-powerbi.git)



**2. Execute Database Setup:**



Run scripts/01\_schema.sql in PostgreSQL via DBeaver.



Run scripts/02\_sample\_data.sql to populate sample accounting records.



**3. Open Power BI Dashboard:**



Open reports/Financial\_Dashboard.pbix.



Update credentials under Data Source Settings (localhost, database name, username postgres).





📊 **Financial Data Architecture \& Data Models**



* \*\*PostgreSQL Layer\*\*: Relational schema supporting full double-entry bookkeeping with dynamic foreign key references, transactional ledger (Diario\_Contable), and automated accounting views (vw\_balance\_situacion with year-end closing logic \& vw\_perdidas\_y\_ganancias).



* \*\*Power BI Layer\*\*: Direct connection to SQL views using conditional DAX metrics for executive Financial Statement reporting (P\&L Waterfall \& Balance Sheet Matrix).
=======
- **PostgreSQL Layer:** Relational schema supporting full double-entry bookkeeping with dynamic foreign key references, transactional ledger (`Diario_Contable`), and automated accounting views (`vw_balance_situacion`) with year-end closing logic & (`vw_perdidas_y_ganancias`).
- **Power BI Layer:** Direct connection to SQL views using conditional DAX metrics for executive Financial Statement reporting (P&L Waterfall & Balance Sheet Matrix).
>>>>>>> e4db5f733edf2f1de06c993e0429355801f89292



