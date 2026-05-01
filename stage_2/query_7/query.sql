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