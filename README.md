# 🏠 Real Estate Data Analysis — SQL Server & Python

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat&logo=python&logoColor=white)
![Excel](https://img.shields.io/badge/Export-Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-2E6DA4?style=flat)



📌 Overview

A full end-to-end real estate analytics platform built on **SQL Server** using a dataset of over **1,048,575 property records** across the United States. The project covers database design, data cleaning, analytical querying, stored procedure development, and automated Excel report generation via Python.

This project was developed to answer real business questions around property pricing, market velocity, agent performance, and investment opportunity scoring — all derived from a single flat-table dataset.



 📊 Dataset

| Attribute | Detail |
|-----------|--------|
| Source Table | `RealEstateDB.dbo.realtor_data` |
| Total Records | 1,048,575 |
| Columns | 24 |
| Coverage | Multi-state USA (FL, NC, GA, AZ, NE, RI, MA and more) |
| Key Fields | Sale price, listing price, property type, zip code, agent info, financing type, days on market |



 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **SQL Server (T-SQL)** | Database, views, stored procedures, triggers |
| **SSMS** | Query execution and database management |
| **Python 3.11** | Automated Excel report generation |
| **pyodbc** | SQL Server connection from Python |
| **pandas** | Data handling and DataFrame management |
| **openpyxl** | Excel workbook creation and formatting |




⚙️ How to Run

 Prerequisites
- SQL Server (any edition) with SSMS installed
- Python 3.11+
- ODBC Driver 17 for SQL Server

 Step 1 — Set up the database (SSMS)

Run the SQL files **in order** inside SSMS:


 Step 2 — Install Python dependencies (CMD)

```bash
pip install pyodbc pandas openpyxl
```

Step 3 — Configure the exporter

Open `export_reports.py` and update the server name on line 20:

```python
SERVER = r'YOUR-SERVER-NAME\SQLEXPRESS'  # get this by running SELECT @@SERVERNAME in SSMS
```

### Step 4 — Generate the Excel report (CMD)

```bash
python export_reports.py
```

### Step 5 — Open the report

```
RealEstate_FullReport.xlsx  →  opens in Excel with all sheets formatted
```

---

 🔍 Analytical Reports

 Section A — Pricing & Valuation
| Query | Description |
|-------|-------------|
| A1 | Average sale price per sqft by city and property type |
| A2 | Year-over-year price appreciation by state |
| A3 | Price spread and standard deviation by property type |
| A4 | Price bucket distribution ($100K tiers) |

 Section B — Market Velocity
| Query | Description |
|-------|-------------|
| B1 | Average days on market by property type and season |
| B2 | Top 20 fastest-moving zip codes |
| B3 | Sold rate by state |
| B4 | Days on market by financing type |

Section C — Agent Performance
| Query | Description |
|-------|-------------|
| C1 | Agent volume and transaction rankings (window functions) |
| C2 | Agents beating market-average sale price |
| C3 | Performance by specialization level |
| C4 | Buyer type purchasing pattern analysis |

 Section D — Investment Signals
| Query | Description |
|-------|-------------|
| D1 | Top zip codes by weighted investment score |
| D2 | Bidding war detection (sold >3% above ask) |
| D3 | Neighborhood-level performance |
| D4 | PIVOT — avg sale price by property type across states |

---

 🗄️ Stored Procedures

 `sp_GetMarketReport_Live`
Full market summary for any zip code and year — returns 4 result sets:
- KPI Summary (avg price, DOM, sold rate, bidding wars)
- Breakdown by property type
- Breakdown by financing type
- Individual transaction records

```sql
EXEC dbo.sp_GetMarketReport_Live @ZipCode = '33993', @Year = 2021;
```

`sp_AgentReport_Live`
Ranked agent scorecard filterable by state and minimum sales count.

```sql
EXEC dbo.sp_AgentReport_Live @State = 'North Carolina', @MinSales = 5;
```

### `sp_InvestmentIndex_Live`
Ranks the top N zip codes using a four-factor weighted investment score.

```sql
EXEC dbo.sp_InvestmentIndex_Live @TopN = 10, @MinListings = 50;
```

---

 📈 Investment Index Scoring Model

Each zip code is scored on a 0–100 scale using four weighted factors:

| Factor | Weight | Description |
|--------|--------|-------------|
| Sold Rate | 40% | Percentage of listings that result in a sale |
| Sale-to-List Ratio | 35% | How close properties sell to asking price |
| Days on Market | 15% | Inverse score — faster markets rank higher |
| Price Per Sqft | 10% | Value density indicator |

---

 🧹 Data Cleaning Approach

The raw dataset had several data quality issues addressed in `00_DataPrep.sql` and `03_PopulateNullColumns.sql`:

| Issue | Solution |
|-------|----------|
| `price` stored as nvarchar | `TRY_CAST` to `DECIMAL(14,2)` inside view |
| `listing_price` 100% NULL | Derived as `price × realistic market factor (0.97–1.08)` |
| `listing_date` 100% NULL | Derived backwards from `prev_sold_date` minus DOM |
| `bed`, `bath`, `house_size` ~30% NULL | Imputed using property type distributions |
| `neighborhood` 100% NULL | Generated from `city + zone suffix` |
| zip_code inconsistent length | Standardized to `LEFT(5)` |
| Status values mixed case | Normalized with `LOWER + LTRIM/RTRIM` |

---

## 📤 Excel Report Output

The Python exporter generates a single professionally formatted Excel workbook with:

-  One sheet per report section
-  Navy blue headers with white text
-  Alternating row colors for readability
-  Auto-fitted column widths
-  Frozen header rows
-  README summary sheet with sheet index
-  Timestamp and data source on every sheet

---

 🗺️ Key Findings (Sample — Zip 33993, FL, 2021)

| Metric | Value |
|--------|-------|
| Total Listings | 415 |
| Avg Sale Price | $265,871 |
| Avg List Price | $275,491 |
| Sale-to-List Ratio | 96.66% |
| Avg Days on Market | 67.8 days |
| Bidding Wars | 101 properties |
| Top Financing Type | Mortgage (208 transactions) |

---

 📄 License

This project is for educational and portfolio purposes.  
Dataset sourced from public real estate listing data.

---

 👤 Author

Dave Avina.

Built as a full end-to-end data analytics portfolio project covering  
SQL Server database design, T-SQL analytics, Python automation, and Excel reporting.
