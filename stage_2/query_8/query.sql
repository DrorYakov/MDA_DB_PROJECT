--אחוזי הצלחה של פרוצדורות לפי קבוצות גיל (חישוב גיל)
SELECT PP.Procedure_Name_, PP.Success_Rate_, P.First_Name_, P.Last_Name_,
       EXTRACT(YEAR FROM PP.Performed_At_) - EXTRACT(YEAR FROM P.Birth_Date_) AS Patient_Age_At_Procedure
FROM PROCEDURES_PERFORMED PP
JOIN PATIENTS P ON PP.Patient_ID_ = P.Patient_ID_
WHERE PP.Success_Rate_ = 'High'
ORDER BY Patient_Age_At_Procedure ASC;