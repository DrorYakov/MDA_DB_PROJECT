-- מטופלים עם מדדים חריגים שאושפזו
-- דרך 1: שימוש ב-JOIN ופונקציות תאריך (EXTRACT)
SELECT P.First_Name_ || ' ' || P.Last_Name_ AS Full_Name, P.Insurance_Provider_
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
)
GROUP BY P.First_Name_, P.Last_Name_, P.Insurance_Provider_;