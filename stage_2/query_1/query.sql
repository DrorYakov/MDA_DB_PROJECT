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