CREATE DATABASE healthcare_project;
USE healthcare_project;

CREATE TABLE patients (
    patientid         INT PRIMARY KEY,
    Age               VARCHAR(10),
    Age_Mid           INT,
    City_Code_Patient INT
);

CREATE TABLE hospitals (
    Hospital_code                     INT PRIMARY KEY,
    Hospital_type_code                VARCHAR(5),
    City_Code_Hospital                INT,
    Hospital_region_code              VARCHAR(5),
    Available_Extra_Rooms_in_Hospital INT
);

CREATE TABLE admissions (
    case_id                INT PRIMARY KEY,
    patientid              INT,
    Hospital_code          INT,
    Department             VARCHAR(50),
    Ward_Type              VARCHAR(5),
    Ward_Facility_Code     VARCHAR(5),
    Bed_Grade              FLOAT,
    Type_of_Admission      VARCHAR(20),
    Severity_of_Illness    VARCHAR(20),
    Severity_Score         INT,
    Visitors_with_Patient  INT,
    Admission_Deposit      FLOAT,
    Stay                   VARCHAR(25),
    Stay_Days              INT,
    Long_Stay_Flag         INT,
    FOREIGN KEY (patientid)     REFERENCES patients(patientid),
    FOREIGN KEY (Hospital_code) REFERENCES hospitals(Hospital_code)
);

ALTER TABLE admissions ADD Stay_Sort INT;
Set sql_safe_updates = 0;

UPDATE admissions SET Stay_Sort = CASE Stay
    WHEN '0-10'               THEN 1
    WHEN '11-20'              THEN 2
    WHEN '21-30'              THEN 3
    WHEN '31-40'              THEN 4
    WHEN '41-50'              THEN 5
    WHEN '51-60'              THEN 6
    WHEN '61-70'              THEN 7
    WHEN '71-80'              THEN 8
    WHEN '81-90'              THEN 9
    WHEN '91-100'             THEN 10
    WHEN 'More than 100 Days' THEN 11
END;

SELECT * FROM admissions limit 5;
SELECT * FROM hospitals;
SELECT * FROM patients;


-- Business Question: Which department has the highest avg length of stay?
-- Purpose: Helps hospital allocate resources and plan discharge strategies
SELECT 
    Department,
    ROUND(AVG(Stay_Days), 2)  AS Avg_Stay_Days,
    COUNT(*)                   AS Total_Patients
FROM admissions
GROUP BY Department
ORDER BY Avg_Stay_Days DESC;

-- Business Question: Which department has highest % of long stay patients?
-- Purpose: Identify high cost departments for insurers
Select 
Department, 
count(*)              						AS Total_patients,
SUM(Long_Stay_Flag)                         AS Long_Stay_Patients,
ROUND(SUM(Long_Stay_Flag)/COUNT(*)*100, 2)  AS Long_Stay_Percentage
FROM Admissions
Group by Department
order by Long_Stay_Percentage desc;

-- Business Question: Which admission type brings most extreme severity cases?
-- Purpose: Emergency preparedness and resource planning
select 
Type_of_Admission,
count(*) as Extreme_Cases
from admissions
WHERE Severity_of_Illness = 'Extreme'
group by Type_of_Admission
ORDER BY Extreme_Cases DESC;

-- Business Question: Which hospitals handle the most patients?
-- Purpose: Performance benchmarking across hospital network
SELECT 
    h.Hospital_code,
    h.Hospital_type_code,
    h.Hospital_region_code,
    COUNT(*)                AS Total_Patients,
    ROUND(AVG(a.Stay_Days), 2) AS Avg_Stay_Days
FROM admissions a
JOIN hospitals h ON a.Hospital_code = h.Hospital_code
GROUP BY h.Hospital_code, h.Hospital_type_code, h.Hospital_region_code
ORDER BY Total_Patients DESC
LIMIT 5;

-- Business Question: How does financial risk vary by illness severity?
-- Purpose: Insurance claim estimation at admission stage
SELECT 
    Severity_of_Illness,
    ROUND(AVG(Admission_Deposit), 2) AS Avg_Deposit,
    ROUND(MIN(Admission_Deposit), 2) AS Min_Deposit,
    ROUND(MAX(Admission_Deposit), 2) AS Max_Deposit,
    COUNT(*)                          AS Total_Patients
FROM admissions
GROUP BY Severity_of_Illness
ORDER BY Avg_Deposit DESC;

-- Business Question: What is the age demographic of our patients?
-- Purpose: Targeted preventive care and resource planning
SELECT 
    p.Age AS Age_Group,
    COUNT(*) AS Total_Patients,
    ROUND(COUNT(*) * 100.0 / 
    (SELECT COUNT(*) FROM admissions), 2) AS Percentage
FROM admissions a
JOIN patients p ON a.patientid = p.patientid
GROUP BY p.Age
ORDER BY Total_Patients DESC;

-- Business Question: Which region has highest long stay burden?
-- Purpose: Regional performance benchmarking
SELECT 
    h.Hospital_region_code AS Region,
    COUNT(*) AS Total_Patients,
    SUM(a.Long_Stay_Flag) AS Long_Stay_Count,
    ROUND(SUM(a.Long_Stay_Flag) * 100.0 
    / COUNT(*), 2) AS Long_Stay_Rate
FROM admissions a
JOIN hospitals h ON a.Hospital_code = h.Hospital_code
GROUP BY h.Hospital_region_code
ORDER BY Long_Stay_Rate DESC;

-- Business Question: Do critical patients have more visitors?
-- Purpose: Validate the correlation found in Python EDA
SELECT 
    Severity_of_Illness,
    ROUND(AVG(Visitors_with_Patient), 2) AS Avg_Visitors,
    MAX(Visitors_with_Patient) AS Max_Visitors
FROM admissions
GROUP BY Severity_of_Illness
ORDER BY Avg_Visitors DESC;

-- Business Question: Who are our highest risk patients?
-- Purpose: Priority case management for insurers
SELECT 
    a.case_id,
    p.Age,
    a.Department,
    a.Severity_of_Illness,
    a.Stay_Days,
    a.Admission_Deposit,
    a.Visitors_with_Patient
FROM admissions a
JOIN patients p ON a.patientid = p.patientid
WHERE a.Severity_of_Illness = 'Extreme'
AND   a.Long_Stay_Flag = 1
ORDER BY a.Stay_Days DESC
LIMIT 10;

-- Business Question: Overall performance comparison across hospitals
-- Purpose: Executive level hospital benchmarking report
SELECT 
    h.Hospital_code,
    h.Hospital_region_code AS Region,
    h.Hospital_type_code   AS Type,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(a.Stay_Days), 2) AS Avg_LOS,
    ROUND(SUM(a.Long_Stay_Flag) * 100.0 
    / COUNT(*), 2) AS Long_Stay_Rate,
    ROUND(AVG(a.Admission_Deposit), 2)  AS Avg_Deposit
FROM admissions a
JOIN hospitals h ON a.Hospital_code = h.Hospital_code
GROUP BY h.Hospital_code, h.Hospital_region_code, h.Hospital_type_code
ORDER BY Long_Stay_Rate DESC;

