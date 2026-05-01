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