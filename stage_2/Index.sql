SELECT * FROM PATIENTS 
ORDER BY Last_Name_ DESC, First_Name_ DESC 

CREATE INDEX idx_patients_names ON PATIENTS(Last_Name_ DESC, First_Name_ DESC);
--אינדקס מיון למטופלים (idx_patients_names): שאילתות השולפות מטופלים לפי סדר אלפביתי גורמות לפעולת Sort כבדה בזיכרון ה-RAM. יצרנו אינדקס מרוכב שיצר מראש עץ חיפוש ממוין (B-Tree), מה שאפשר למנוע לשלוף את הנתונים ב-Index Scan ללא פעולת מיון כלל.


SELECT * FROM MEDICAL_MEASUREMENTS 
ORDER BY Pulse_ DESC 

CREATE INDEX idx_med_pulse ON MEDICAL_MEASUREMENTS(Pulse_ DESC);
-- אינדקס מיון למדדים רפואיים (idx_med_pulse): במסכי בקרת איכות (QA) רופאים שולפים את המקרים עם המדדים הקיצוניים ביותר (למשל הדופק הגבוה ביותר). ללא אינדקס, שאילתת השליפה מאלצת את המערכת לבצע פעולת מיון כבדה (Sort) על כל טבלת המדדים. יצירת אינדקס מסודר יורד (DESC) יצרה עץ B-Tree ממוין מראש, מה שאפשר למנוע לשלוף את הנתונים באופן מיידי ללא מיון בזיכרון.


SELECT * FROM INCIDENTS 
ORDER BY Severity_Level_ DESC, Call_Start_Timestamp_ DESC 

CREATE INDEX idx_inc_sev_time ON INCIDENTS(Severity_Level_ DESC, Call_Start_Timestamp_ DESC);
-- אינדקס מרוכב לאירועים קריטיים (idx_inc_sev_time): מסכי הניהול של מד"א מציגים תמיד בראש המסך את האירועים החמורים ביותר והעדכניים ביותר. כדי למנוע צוואר בקבוק במשיכת הנתונים, יצרנו אינדקס מרוכב המשלב את רמת החומרה וזמן תחילת הקריאה. הדבר איפשר ל-Optimizer לבצע Index Scan ישיר ולקצץ את זמן הריצה לאלפיות שנייה בודדות.