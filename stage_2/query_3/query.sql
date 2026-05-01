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