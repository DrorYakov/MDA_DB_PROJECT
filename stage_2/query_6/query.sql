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