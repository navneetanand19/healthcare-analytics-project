# healthcare-analytics-project
End-to-end healthcare analytics project using Python, SQL and Power BI. Analyzes 318K+ hospital patient records to understand Length of Stay patterns.

# Business Problem
Understanding and predicting patient Length of Stay (LOS) to support hospital resource planning and insurance cost management.

# Tools Used
| Python | Data cleaning, EDA, Feature Engineering |
| MySQL | Database design, 10 business KPI queries |
| Power BI | 3 page interactive dashboard |

# Dataset
- 318,438 patient admission records
- Source: Kaggle Healthcare Dataset
- 3 normalized tables: patients, hospitals, admissions

# Key Findings
- 40.6% of patients stay beyond 30 days - primary cost driver
- Surgery has highest avg LOS at 37.6 days
- Visitor count is strongest predictor of stay length (r=0.54)
- Region Z has highest financial burden per patient (Avg ₹5,060)
- Extreme severity patients stay 8 days longer than Minor cases

# Project Structure
healthcare-analytics-project/
|-- Healthcare_LOS_EDA.ipynb (Python EDA notebook)
|-- Healthcare_queries.sql (10 SQL business queries)
|-- Healthcare Dashboard (Connected with mysql db)
|-- dashboard.pdf

# Business Recommendations
1. Flag patients at admission with Surgery + Extreme severity 
   for early discharge planning.
2. Region Z needs targeted cost management programs.
3. Use visitor count as early long-stay risk signal.
4. Prioritise elderly care protocols for 71+ age group.
5. Trauma drives the highest patient volume (48%) combined with above average Length of Stay — hospitals should 
   prioritise Trauma capacity planning to reduce overcrowding and control long stay costs.
