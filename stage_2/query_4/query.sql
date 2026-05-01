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