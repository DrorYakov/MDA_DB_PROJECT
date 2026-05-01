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