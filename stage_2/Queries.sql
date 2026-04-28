--דוח עומס אירועים חריגים לפי ערים
-- מטופלים עם מדדים חריגים שאושפזו
-- דרך 1: שימוש ב-JOIN קלאסי (הדרך היעילה בדרך כלל)
SELECT L.City_, COUNT(I.Incident_ID_) AS Total_Severe_Incidents, AVG(I.Severity_Level_) AS Avg_Severity
FROM INCIDENTS I
JOIN LOCATIONS L ON I.Incident_ID_ = L.Incident_ID_
WHERE I.Severity_Level_ >= 3
GROUP BY L.City_
HAVING COUNT(I.Incident_ID_) > 5
ORDER BY Total_Severe_Incidents DESC;

-- דרך 2: שימוש בתת-שאילתה (Subquery ב-WHERE עם IN)
SELECT City_, COUNT(Location_ID_) AS Total_Severe_Incidents
FROM LOCATIONS
WHERE Incident_ID_ IN (SELECT Incident_ID_ FROM INCIDENTS WHERE Severity_Level_ >= 3)
GROUP BY City_
HAVING COUNT(Location_ID_) > 5
ORDER BY Total_Severe_Incidents DESC;


-- מטופלים עם מדדים חריגים שאושפזו
-- דרך 1: שימוש ב-JOIN ופונקציות תאריך (EXTRACT)
SELECT P.First_Name_ || ' ' || P.Last_Name_ AS Full_Name, P.Insurance_Provider_, COUNT(M.Measurement_ID_) as Abnormal_Measurements
FROM PATIENTS P
JOIN MEDICAL_MEASUREMENTS M ON P.Patient_ID_ = M.Patient_ID_
WHERE M.Pulse_ > 120 
  AND EXTRACT(YEAR FROM M.Recorded_At_) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY P.First_Name_, P.Last_Name_, P.Insurance_Provider_;

-- דרך 2: שימוש ב-EXISTS כדי לבדוק רק קיום של מדד (ללא ספירה)
SELECT First_Name_ || ' ' || Last_Name_ AS Full_Name, Insurance_Provider_
FROM PATIENTS P
WHERE EXISTS (
    SELECT 1 
    FROM MEDICAL_MEASUREMENTS M 
    WHERE M.Patient_ID_ = P.Patient_ID_ 
      AND M.Pulse_ > 120 
      AND EXTRACT(YEAR FROM M.Recorded_At_) = EXTRACT(YEAR FROM CURRENT_DATE)
);


--מציאת בתי חולים שלא קלטו אף מטופל בשנה הנוכחית (דוח למשרד הבריאות לבדיקת בתי חולים לא פעילים).
SELECT H.Hospital_Name_, H.City_
FROM HOSPITALS H
LEFT JOIN TRANSFER_SUMMARIES TS 
  ON H.Hospital_ID_ = TS.Hospital_ID_ 
  AND EXTRACT(YEAR FROM TS.Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
WHERE TS.Transfer_ID_ IS NULL;

SELECT Hospital_Name_, City_
FROM HOSPITALS
WHERE Hospital_ID_ NOT IN (
    SELECT Hospital_ID_ 
    FROM TRANSFER_SUMMARIES 
    WHERE EXTRACT(YEAR FROM Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
);


--כמות אירועים למדווח לפי שנים וחודשים (עבור מסך מוקדן)
-- דרך 1: GROUP BY לפי חלקי התאריך
SELECT C.Full_Name_, C.Phone_Number_, 
       EXTRACT(YEAR FROM I.Call_Start_Timestamp_) AS Call_Year, 
       EXTRACT(MONTH FROM I.Call_Start_Timestamp_) AS Call_Month,
       COUNT(I.Incident_ID_) AS Total_Calls
FROM CALLERS C
JOIN INCIDENTS I ON C.Caller_ID_ = I.Caller_ID_
GROUP BY C.Full_Name_, C.Phone_Number_, Call_Year, Call_Month
HAVING COUNT(I.Incident_ID_) > 2;

-- דרך 2: שימוש בתת-שאילתה ב-FROM (Derived Table)
SELECT Full_Name_, Phone_Number_, Call_Year, Call_Month, Total_Calls
FROM (
    SELECT C.Full_Name_, C.Phone_Number_, 
           EXTRACT(YEAR FROM I.Call_Start_Timestamp_) AS Call_Year, 
           EXTRACT(MONTH FROM I.Call_Start_Timestamp_) AS Call_Month,
           COUNT(I.Incident_ID_) AS Total_Calls
    FROM CALLERS C
    JOIN INCIDENTS I ON C.Caller_ID_ = I.Caller_ID_
    GROUP BY C.Full_Name_, C.Phone_Number_, EXTRACT(YEAR FROM I.Call_Start_Timestamp_), EXTRACT(MONTH FROM I.Call_Start_Timestamp_)
) AS MonthlyStats
WHERE Total_Calls > 2;


--סיכום מדדים קריטיים לפי מטופל (מסך פרמדיק/רופא)
SELECT 
    P.First_Name_ || ' ' || P.Last_Name_ AS Patient_Name,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM P.Birth_Date_) AS Patient_Age,
    MIN(M.Oxygen_Saturation_) AS Lowest_Oxygen,
    MAX(M.Pulse_) AS Highest_Pulse
FROM PATIENTS P
JOIN MEDICAL_MEASUREMENTS M ON P.Patient_ID_ = M.Patient_ID_
WHERE EXTRACT(MONTH FROM M.Recorded_At_) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY P.First_Name_, P.Last_Name_, P.Birth_Date_
HAVING MIN(M.Oxygen_Saturation_) < 90
ORDER BY Lowest_Oxygen ASC;


--מיקומים חמים של אירועים פעילים (מסך משגר/מנהל):
SELECT 
    L.City_,
    L.Street_,
    COUNT(I.Incident_ID_) AS Active_Incidents,
    MAX(I.Severity_Level_) AS Highest_Severity,
    MIN(I.Call_Start_Timestamp_) AS Oldest_Call_Time
FROM INCIDENTS I
JOIN LOCATIONS L ON I.Incident_ID_ = L.Incident_ID_
WHERE I.Status_ IN ('Pending', 'Dispatched', 'On Scene')
GROUP BY L.City_, L.Street_
HAVING COUNT(I.Incident_ID_) >= 2
ORDER BY Highest_Severity DESC, Active_Incidents DESC;


--עומס על רופאים מקבלים בבתי החולים (מסך מנהל רפואי)
SELECT 
    H.Hospital_Name_,
    H.City_,
    TS.Receiving_Physician_ AS Doctor_Name,
    COUNT(TS.Transfer_ID_) AS Total_Patients_Received,
    MAX(TS.Arrival_At_Hospital_Time_) AS Last_Transfer_Date
FROM HOSPITALS H
JOIN TRANSFER_SUMMARIES TS ON H.Hospital_ID_ = TS.Hospital_ID_
WHERE EXTRACT(YEAR FROM TS.Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY H.Hospital_Name_, H.City_, TS.Receiving_Physician_
HAVING COUNT(TS.Transfer_ID_) > 5
ORDER BY Total_Patients_Received DESC;


--אחוזי הצלחה של פרוצדורות לפי קבוצות גיל (חישוב גיל)
SELECT PP.Procedure_Name_, PP.Success_Rate_, P.First_Name_, P.Last_Name_,
       EXTRACT(YEAR FROM PP.Performed_At_) - EXTRACT(YEAR FROM P.Birth_Date_) AS Patient_Age_At_Procedure
FROM PROCEDURES_PERFORMED PP
JOIN PATIENTS P ON PP.Patient_ID_ = P.Patient_ID_
WHERE PP.Success_Rate_ = 'High'
ORDER BY Patient_Age_At_Procedure ASC;


--שאילתות עדכון
--עדכון סטטוס בית חולים לפי עומס פינויים
UPDATE HOSPITALS
SET Current_Capacity_Status_ = 'High'
WHERE Hospital_ID_ IN (
    SELECT Hospital_ID_ 
    FROM TRANSFER_SUMMARIES 
    WHERE EXTRACT(YEAR FROM Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY Hospital_ID_ 
    HAVING COUNT(Transfer_ID_) > 10
);


--סגירת אירועים ישנים
UPDATE INCIDENTS
SET Status_ = 'Resolved'
WHERE Status_ = 'Pending' 
  AND Call_End_Timestamp_ IS NOT NULL 
  AND EXTRACT(YEAR FROM Call_Start_Timestamp_) < 2024;


--העלאת דרגת העדיפות של סוג אירוע
UPDATE INCIDENT_TYPES
SET Default_Priority_ = 1
WHERE Type_ID_ IN (
    SELECT Type_ID_ 
    FROM INCIDENTS 
    GROUP BY Type_ID_ 
    HAVING AVG(Severity_Level_) > 4
);


--שאילות מחיקה
--מחיקת מדווחים (Callers) ללא היסטוריית דיווח
DELETE FROM CALLERS
WHERE Caller_ID_ NOT IN (SELECT DISTINCT Caller_ID_ FROM INCIDENTS);

--מחיקת מיקומים של אירועים שבוטלו
DELETE FROM LOCATIONS
WHERE Incident_ID_ IN (SELECT Incident_ID_ FROM INCIDENTS WHERE Status_ = 'Cancelled');

--ארכיון מדדים רפואיים ישנים
DELETE FROM MEDICAL_MEASUREMENTS
WHERE EXTRACT(YEAR FROM Recorded_At_) < 2014;