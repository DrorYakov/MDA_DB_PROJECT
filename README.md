# 🚑 מערכת ניהול אירועים ושיגורים - מד"א (MDA DB Project)

**מיני פרויקט במסגרת קורס בסיסי נתונים**

## 👥 מגישים
* **לידן רובינוב** - 215015900
* **דרור יעקב חי** - 325846319

**מרצה:** הרב יעקב ברזילי הי"ו  
**קישור למאגר ה-GitHub:** [MDA_DB_PROJECT](https://github.com/DrorYakov/MDA_DB_PROJECT)

---
## 📑 תוכן עניינים
1. [מבוא](#מבוא)
2. [מסכי המערכת (AI Studio)](#מסכי-המערכת)
3. [תרשימי ERD ו-DSD](#תרשימי-erd-ו-dsd)
4. [מילון מושגים (Data Dictionary)](#-מילון-מושגים-data-dictionary-וקשר-לממשק-המשתמש-ui)
5. [החלטות עיצוב](#החלטות-עיצוב)
7. [גיבוי ושחזור](#גיבוי-ושחזור)
8. [שלב ב׳: שאילתות ואילוצים](#שלב-ב-שאילתות-ואילוצים)
9. [מסמכי ה ROLLBACK ו-COMMIT](#rollback-ו-commit-הדגמות)
10. [אילוצים באמצעות ALTER TABLE](#אילוצים-3-סהכ-באמצעות-alter-table)
11. [אינדקסים (Indexes)](#אינדקסים-3-סהכ--בדיקות-זמן-ריצה)
12. [שלב ג': אינטגרציה ומבטים מתקדמים](#שלב-ג--אינטגרציית-בסיסי-נתונים-ומבטים-מתקדמים)
13. [שלב ד'](#שלב-ד-תכנות-במסד-הנתונים-plpgsql)
---

## מבוא

**תיאור המערכת והיחידה הנבחרת:** המערכת שפיתחנו מדמה את מערך ניהול האירועים וההזנקות במוקד השליטה של מגן דוד אדום (מד"א). היא מתמקדת ביחידת **השליטה, הבקרה והתיעוד הרפואי בשטח**. 

**הנתונים הנשמרים במערכת:**
המערכת מנהלת מידע מקיף על מחזור החיים של קריאת חירום:
* **קריאות ואירועים (Incidents & Callers):** פרטי המתקשר, סוג האירוע, רמת חומרה, ומיקום מדויק (כולל נ"צ גיאוגרפי).
* **מטופלים (Patients):** פרטים אישיים, היסטוריה רפואית, ואלרגיות.
* **שיגורים (Emergency Dispatches):** ניהול צוותי הרפואה, זמני הזנקה, הגעה לשטח וסיום טיפול.
* **תיעוד קליני בשטח (Measurements & Procedures):** רישום מדדים חיוניים (לחץ דם, דופק, סטורציה) ופעולות רפואיות שבוצעו בשטח (החייאה, מתן חמצן, מתן תרופות).
* **העברות לבתי חולים (Transfer Summaries):** סיכום הטיפול והעברת המטופל לבית חולים ספציפי כולל הערות לרופא המקבל.

**פונקציונליות עיקרית:**
המערכת מאפשרת למוקדנים ולצוותי הרפואה:
1. פתיחת אירוע חדש בזמן אמת וסיווגו.
2. ניטור סטאטוס של כלל האירועים הפעילים בגזרה.
3. תיעוד רציף של המצב הרפואי של המטופל מרגע ההגעה ועד לפינוי.
4. הפקת דוחות סיכום העברה מסודרים עבור בתי החולים.

---

## מסכי המערכת

מסכי המערכת נוצרו בעזרת כלי AI כדי להמחיש את ממשק המשתמש (UI) של המוקדן והצוות הרפואי.

🔗 **קישור לאתר ב-AI STUDIO:** 'https://ai.studio/apps/64ec0f00-3fc3-4032-9eda-76dc68e13f70'
### 1. דשבורד אירועים פעילים (Active Incidents)
תצוגה מרכזית למוקדן המציגה את כל האירועים הפעילים, זמן שחלף, צוותים משוגרים וסטטוס (קריטי/יציב).
![Active Incidents](images/ActiveIncidents)

### 2. פתיחת אירוע חדש (New Incident)
טופס הזנת נתונים ראשוניים מקריאת החירום - הזנת פרטי מתקשר וקרבתו למטופל.
![New Incident](images/NewIncidents)

### 3. מסך מעקב וניטור רפואי (Incident Monitor)
מסך המציג בזמן אמת את פרטי המטופל, מדדים חיוניים (Vitals), אק"ג, ופרטי השיגור של הניידת (MICU).
![Incident Monitor](images/IncidentMonitor)

### 4. דוח העברה לבית חולים (Hospital Transfer Report)
סיכום כלל הפעולות שבוצעו בשטח (CPR, IV, Medication) והכנת הנתונים להעברה לצוות המיון בבית החולים היעד.
![Transfer Report](images/HospitalTransferReport)

---

## תרשימי ERD ו-DSD

### Entity Relationship Diagram (ERD)
התרשים מציג את הישויות במערכת, התכונות שלהן והקשרים ביניהן. 
![ERD Diagram](images/ERD_Diagram)

### Data Structure Diagram (DSD) / מבנה סכמה

![SSD Diagram](images/SSD.png)

---

## 📚 מילון מושגים (Data Dictionary) וקשר לממשק המשתמש (UI)

להלן פירוט מבנה בסיס הנתונים של מערכת מד"א. המילון מפרט את תפקיד הטבלאות, סוגי הנתונים, והקשרים הבין-טבלאיים המאפשרים את זרימת המידע במערכת.

---

### 1. סוגי אירועים (`INCIDENT_TYPES`)
**תיאור:** קטלוג סוגי מקרי החירום והפרוטוקולים הרפואיים המקושרים אליהם.

**קשר לממשק:** מופיע כרשימה נפתחת במסך המוקדן ומקפיץ הנחיות טיפול בטאבלט האמבולנס.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Type_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי לסוג האירוע. |
| `Type_Name_` | מחרוזת טקסט | שם סוג האירוע (למשל: דום לב, תאונה). |
| `Default_Priority_` | מספר שלם | רמת העדיפות המוגדרת כברירת מחדל לסוג זה. |
| `Protocol_Instructions_` | מחרוזת טקסט | הנחיות לטיפול רפואי או תדרוך טלפוני מציל חיים. |

---

### 2. מדווחים (`CALLERS`)
**תיאור:** פרטי האנשים שפנו למוקד לדיווח על אירוע חירום.

**קשר לממשק:** זיהוי אוטומטי של המדווח במערכת הטלפוניה והצגת היסטוריית קריאות למוקדן.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Caller_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי של המתקשר. |
| `Phone_Number_` | מחרוזת טקסט | מספר הטלפון של המתקשר (ערך ייחודי). |
| `Full_Name_` | מחרוזת טקסט | שמו המלא של המדווח. |
| `Language_Preference_` | מחרוזת טקסט | שפת דיבור מועדפת (ברירת מחדל: עברית). |

---

### 3. מטופלים (`PATIENTS`)
**תיאור:** מידע אישי ורפואי של המטופלים שקיבלו סיוע.

**קשר לממשק:** שליפת היסטוריה רפואית בטאבלט והצגת אלרגיות לצוות הקליטה בבית החולים.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Patient_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי (ת"ז) של המטופל. |
| `First_Name_` | מחרוזת טקסט | שם פרטי. |
| `Last_Name_` | מחרוזת טקסט | שם משפחה. |
| `Birth_Date_` | תאריך | תאריך לידה (אילוץ: לא יכול להיות בעתיד). |
| `Gender_` | מחרוזת טקסט | מין (זכר, נקבה, אחר, לא ידוע). |
| `Medical_Notes_` | מחרוזת טקסט | הערות רפואיות, מחלות רקע ואלרגיות. |
| `Insurance_Provider_` | מחרוזת טקסט | קופת חולים או ספק ביטוח רפואי. |

---

### 4. בתי חולים (`HOSPITALS`)
**תיאור:** רשימת המרכזים הרפואיים הזמינים לפינוי.

**קשר לממשק:** מפת משגר המציגה עומסים בזמן אמת (ירוק/אדום) בבתי החולים.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Hospital_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי של בית החולים. |
| `Hospital_Name_` | מחרוזת טקסט | שם בית החולים. |
| `City_` | מחרוזת טקסט | העיר בה ממוקם בית החולים. |
| `Specialty_Unit_` | מחרוזת טקסט | יחידות התמחות (למשל: מרכז טראומה). |
| `Current_Capacity_Status_` | מחרוזת טקסט | סטטוס תפוסה (Low, Normal, High, Full). |

---

### 5. אירועים (`INCIDENTS`)
**תיאור:** התיעוד המרכזי של כל קריאת חירום שנפתחה במוקד.

**קשר לממשק:** לוח בקרה למשגר המציג אירועים פתוחים ודחיפותם.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Incident_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי של האירוע. |
| `Call_Start_Timestamp_` | תאריך | מועד תחילת שיחת הדיווח. |
| `Call_End_Timestamp_` | תאריך | מועד סיום השיחה (אילוץ: סיום >= התחלה). |
| `Severity_Level_` | מספר שלם | רמת חומרה שנקבעה על ידי המוקדן. |
| `Status_` | מחרוזת טקסט | סטטוס נוכחי (ממתין, בטיפול, הסתיים). |
| `Type_ID_` | מספר שלם | **מפתח זר**. מקשר לסוג האירוע כדי לקבוע עדיפות ופרוטוקול טיפול. |
| `Caller_ID_` | מספר שלם | **מפתח זר**. מקשר למדווח כדי לאפשר יצירת קשר חוזר במידת הצורך. |

---

### 6. מיקומים (`LOCATIONS`)
**תיאור:** המיקום הגיאוגרפי והכתובת המדויקת של אירוע החירום.

**קשר לממשק:** הצגת סיכות (Pins) על המפה ושידור ניווט לאמבולנס כולל קודי כניסה.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Location_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי למיקום. |
| `City_` | מחרוזת טקסט | עיר האירוע. |
| `Street_` | מחרוזת טקסט | שם הרחוב. |
| `House_Num_` | מספר שלם | מספר הבית. |
| `Entry_Code_` | מחרוזת טקסט | קוד כניסה לבניין או אינטרקום. |
| `Latitude_` | מספר עשרוני | קואורדינטת רוחב לניווט GPS מדויק. |
| `Longitude_` | מספר עשרוני | קואורדינטת אורך לניווט GPS מדויק. |
| `Incident_ID_` | מספר שלם | **מפתח זר**. מקשר את הכתובת הפיזית לאירוע הספציפי שנפתח. |

---

### 7. שיגורים (`EMERGENCY_DISPATCHES`)
**תיאור:** תיעוד שליחת צוותי הרפואה (אמבולנסים/אופנועים) לזירה.

**קשר לממשק:** אפליקציית הצוות המאפשרת עדכוני סטטוס ("יצאנו", "הגענו").

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Dispatch_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי לשיגור צוות. |
| `Vehicle_ID_` | מחרוזת טקסט | מספר הרישוי או מזהה הרכב המשוגר. |
| `Dispatch_Time_` | תאריך | זמן יציאת הצוות מהתחנה. |
| `Arrival_Time_` | תאריך | זמן הגעה לזירה. |
| `Departure_Time_` | תאריך | זמן עזיבת הזירה (אילוץ: סדר זמנים כרונולוגי). |
| `Incident_ID_` | מספר שלם | **מפתח זר**. מקשר את רכב ההצלה לאירוע אליו הוא נשלח. |

---

### 8. מדדים רפואיים (`MEDICAL_MEASUREMENTS`)
**תיאור:** נתונים רפואיים חיים שנלקחו מהמטופל במהלך הטיפול.

**קשר לממשק:** תצוגת מוניטור באמבולנס והעברת נתונים קריטיים לבית החולים בדרך.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Measurement_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי לבדיקה. |
| `Recorded_At_` | תאריך | מועד לקיחת המדדים. |
| `Systolic_BP_` | מספר שלם | לחץ דם סיסטולי. |
| `Diastolic_BP_` | מספר שלם | לחץ דם דיאסטולי (אילוץ: סיסטולי > דיאסטולי). |
| `Pulse_` | מספר שלם | דופק (אילוץ: 0-300). |
| `Oxygen_Saturation_` | מספר שלם | סטורציה (אילוץ: 0-100). |
| `Dispatch_ID_` | מספר שלם | **מפתח זר**. מקשר את המדד למשימת האמבולנס הספציפית. |
| `Patient_ID_` | מספר שלם | **מפתח זר**. משייך את המדדים הרפואיים למטופל הנבדק. |

---

### 9. פרוצדורות שבוצעו (`PROCEDURES_PERFORMED`)
**תיאור:** פעולות רפואיות (החייאה, מתן תרופות) שבוצעו בשטח.

**קשר לממשק:** צ'ק-ליסט דיגיטלי לפרמדיק ודוחות בקרת איכות למנהל הרפואי.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Action_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי לפעולה שבוצעה. |
| `Procedure_Name_` | מחרוזת טקסט | שם ההליך הרפואי שבוצע. |
| `Performed_At_` | תאריך | מועד ביצוע הפעולה. |
| `Success_Rate_` | מחרוזת טקסט | רמת ההצלחה (High, Medium, Low, Failed). |
| `Dispatch_ID_` | מספר שלם | **מפתח זר**. מזהה את הצוות שביצע את הפעולה. |
| `Patient_ID_` | מספר שלם | **מפתח זר**. מזהה את המטופל שקיבל את הטיפול. |

---

### 10. סיכומי העברה (`TRANSFER_SUMMARIES`)
**תיאור:** תיעוד תהליך העברת המטופל מצוות האמבולנס לבית החולים.

**קשר לממשק:** מסך חפיפה דיגיטלי המאפשר לרופא המקבל לחתום על אישור קבלת המטופל.

| שם שדה | טיפוס נתונים | תיאור, אילוצים וקשרים |
| :--- | :--- | :--- |
| `Transfer_ID_` | מספר שלם | **מפתח ראשי**. מזהה ייחודי של טופס ההעברה. |
| `Receiving_Physician_` | מחרוזת טקסט | שם הרופא שקיבל את המטופל במיון. |
| `Handover_Notes_` | מחרוזת טקסט | הערות חפיפה קריטיות מהשטח לבית החולים. |
| `Arrival_At_Hospital_Time_` | תאריך | מועד ההגעה הפיזי לבית החולים. |
| `Dispatch_ID_` | מספר שלם | **מפתח זר**. מקשר את טופס ההעברה לשיגור המקורי. |
| `Hospital_ID_` | מספר שלם | **מפתח זר**. מגדיר לאיזה בית חולים פונה המטופל. |

---

## החלטות עיצוב

במהלך תכנון בסיס הנתונים, קיבלנו מספר החלטות משמעותיות:

1. **הפרדה מוחלטת בין מתקשר למטופל (`CALLERS` מול `PATIENTS`):** * *נימוק:* במקרי חירום, לעיתים קרובות המתקשר הוא עובר אורח או בן משפחה ולא המטופל עצמו. הפרדה זו מונעת כפילויות ומאפשרת שמירת שפת האם של המתקשר בנפרד מההיסטוריה הרפואית של המטופל.
2. **טבלאות גישור למדדים וטיפולים (`MEDICAL_MEASUREMENTS` ו-`PROCEDURES_PERFORMED`):** * *נימוק:* פעולות רפואיות ומדדים מקושרים גם לשיגור ספציפי (`Dispatch_ID`) וגם למטופל (`Patient_ID`). תכנון זה תומך באירועים רבי נפגעים (אר"ן) שבהם אמבולנס אחד (שיגור אחד) מעניק טיפול למספר מטופלים שונים באותה זירה.
3. **נרמול טבלת מיקומים (`LOCATIONS`):** * *נימוק:* הפרדנו את פרטי המיקום המדויקים (עיר, רחוב, קואורדינטות) מהאירוע עצמו. זה מאפשר ביצוע שאילתות גיאוגרפיות יעילות יותר, סטטיסטיקות על אזורי סיכון, והתממשקות עתידית למערכות GIS.
4. **שימוש נרחב באילוצי הנתונים (Constraints):**
   * *נימוק:* הוספנו אילוצי `CHECK` קפדניים כגון וידוא שלחץ דם סיסטולי גבוה מהדיאסטולי, אחוז חמצן בין 0 ל-100, וסטטוס בתי חולים ספציפי ('Low', 'Normal', 'Full', 'Diverting'). החלטה זו נועדה להבטיח את שלמות ואמינות הנתונים במערכת קריטית כמו מד"א.

---

##  הכנסת נתונים

להלן שלוש שיטות שבהן השתמשנו להכנסת נתונים (DML) לבסיס הנתונים שלנו:

1. **הכנסה ידנית (Manual INSERTs):** שימוש בשאילתות `INSERT INTO` לטובת הכנסת נתוני ליבה סטטיים (כמו סוגי אירועים, רשימת בתי חולים).
2. **יבוא קבצי CSV:** תוך שימוש ב Excel ליצירת אקראיות.
3. **סקריפט אוטומטי (Mock Data Generation):** בשימוש בסקריפט python שיצרנו.

**צילומי מסך של הכנסת הנתונים:**
![Python](images/Python.png)
![Manual](images/Insert.png)
![Excel](images/Excel.png)

---

## גיבוי ושחזור

תהליך הגיבוי והשחזור של בסיס הנתונים בוצע כדי להבטיח זמינות נתונים במקרה של קריסת מערכת:

**צילום מסך של תהליך ביצוע הגיבוי (Backup):**
![Backup Screenshot](images/Backup.png)

**צילום מסך של תהליך שחזור הנתונים (Restore):**
![Restore Screenshot](images/Restore.png)

---

## שלב ב׳: שאילתות ואילוצים

בשלב זה בוצע תשאול של בסיס הנתונים, הוגדרו אילוצים ואינדקסים, ונבדקו פעולות `ROLLBACK` ו-`COMMIT`.

### קבצי ההגשה (תיקיית `שלב ב`)

- **`Stage_2/Queries.sql`**: שאילתות `DELETE` ו-`UPDATE`
- **`Stage_2/query_1..query_8/query.sql`**: שאילתות `SELECT` (כולל 4 כפולות בשתי צורות)
- **`Stage_2/Constraints.sql`**: הוספת 3 אילוצים באמצעות `ALTER TABLE`
- **`Stage_2/RollbackCommit.sql`**: דוגמת `ROLLBACK` (ודוגמת `COMMIT` תתווסף)
- **`Stage_2/Index.sql`**: הוספת 3 אינדקסים + בדיקת זמני ריצה לפני/אחרי
- **`backup2`**: קובץ גיבוי מעודכן לאחר השינויים

### שאילתות SELECT (8 סה״כ)

דרישות כלליות: שאילתות לא טריוויאליות, צירוף מידע ממספר טבלאות, שימוש ב-`GROUP BY`, `ORDER BY`, תתי-שאילתות/קינון, ושימוש בשדות תאריך (עדיפות לפירוק ליום/חודש/שנה). תוצאת כל שאילתה כוללת **יותר מ-2 עמודות** ומתאימה להצגה במסכים.

#### 4 שאילתות SELECT כפולות (אותה תוצאה בשתי צורות) + הסבר יעילות

##### SELECT כפולה 1 — תיאור בעברית

- **תיאור**: דוח ניהולי המציג **עומס אירועים חמורים לפי עיר**: עבור כל עיר מוצגים מספר האירועים החמורים, ממוצע חומרה, ומיון לפי כמות אירועים.
- **שאילתה – צורה א׳**:
```sql
SELECT L.City_, COUNT(I.Incident_ID_) AS Total_Severe_Incidents, AVG(I.Severity_Level_) AS Avg_Severity
FROM INCIDENTS I
JOIN LOCATIONS L ON I.Incident_ID_ = L.Incident_ID_
WHERE I.Severity_Level_ >= 3
GROUP BY L.City_
HAVING COUNT(I.Incident_ID_) > 5
ORDER BY Total_Severe_Incidents DESC;
```
![Image](stage_2/query_1/query1First.png)

- **שאילתה – צורה ב׳**:
```sql
SELECT City_, COUNT(Location_ID_) AS Total_Severe_Incidents
FROM LOCATIONS
WHERE Incident_ID_ IN (SELECT Incident_ID_ FROM INCIDENTS WHERE Severity_Level_ >= 3)
GROUP BY City_
HAVING COUNT(Location_ID_) > 5
ORDER BY Total_Severe_Incidents DESC;
```
![Image](stage_2/query_1/query1Second.png)

- **הבדלים ויעילות**:
  - **מה ההבדל בין צורה א׳ לצורה ב׳**: צורה א׳ משתמשת ב-`JOIN` ומחזירה גם ממוצע חומרה; צורה ב׳ משתמשת בתת-שאילתה עם `IN` ומבצעת ספירה על טבלת `LOCATIONS`.
  - **מה יותר יעיל ולמה**: ברוב המקרים צורה א׳ יעילה יותר כי האופטימייזר יכול לבחור תכנית חיבור יעילה (`Hash Join`/`Merge Join`) ולבצע אגרגציה לאחר החיבור. בצורה ב׳ יש תת-שאילתה שיכולה להוביל ל־`Subquery Scan`/חומרה של `IN` (תלוי DB), ולעיתים פחות מנצלת אינדקסים על צירוף.

##### SELECT כפולה 2 — תיאור בעברית

- **תיאור**: דוח קליני המציג **מטופלים עם דופק חריג (Pulse > 120) במהלך השנה הנוכחית** כולל שם מלא וספק ביטוח.
- **שאילתה – צורה א׳**:
```sql
SELECT P.First_Name_ || ' ' || P.Last_Name_ AS Full_Name, P.Insurance_Provider_
FROM PATIENTS P
JOIN MEDICAL_MEASUREMENTS M ON P.Patient_ID_ = M.Patient_ID_
WHERE M.Pulse_ > 120 
  AND EXTRACT(YEAR FROM M.Recorded_At_) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY P.First_Name_, P.Last_Name_, P.Insurance_Provider_;
```
![Image](stage_2/query_2/query2First.png)

- **שאילתה – צורה ב׳**:
```sql
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
```
![Image](stage_2/query_2/query2Second.png)

- **הבדלים ויעילות**:
  - **הבדל**: צורה א׳ עושה `JOIN` ישיר על טבלת המדדים ועלולה להחזיר/לעבד ריבוי שורות לכל מטופל; צורה ב׳ משתמשת ב-`EXISTS` ובודקת רק קיום מדד מתאים (אפשר “לעצור מוקדם”).
  - **יעילות**: לרוב `EXISTS` יעיל יותר כשהמטרה היא “יש/אין” כי ניתן לבצע `Semi-Join` ולצמצם סריקות. `JOIN` מתאים אם רוצים אגרגציות/חישובים על המדדים עצמם.

##### SELECT כפולה 3 — תיאור בעברית

- **תיאור**: דוח למשרד הבריאות: **בתי חולים שלא קלטו אף מטופל בשנה הנוכחית** (לא הופיעו ב־`TRANSFER_SUMMARIES`).
- **שאילתה – צורה א׳**:
```sql
SELECT H.Hospital_Name_, H.City_
FROM HOSPITALS H
LEFT JOIN TRANSFER_SUMMARIES TS 
  ON H.Hospital_ID_ = TS.Hospital_ID_ 
  AND EXTRACT(YEAR FROM TS.Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
WHERE TS.Transfer_ID_ IS NULL;
```
![Image](stage_2/query_3/query3First.png)

- **שאילתה – צורה ב׳**:
```sql
SELECT Hospital_Name_, City_
FROM HOSPITALS
WHERE Hospital_ID_ NOT IN (
    SELECT Hospital_ID_ 
    FROM TRANSFER_SUMMARIES 
    WHERE EXTRACT(YEAR FROM Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
);
```
![Image](stage_2/query_3/query3Second.png)

- **הבדלים ויעילות**:
  - **הבדל**: צורה א׳ משתמשת ב־`LEFT JOIN ... IS NULL` (אנטי-ג'וין). צורה ב׳ משתמשת ב־`NOT IN` עם תת-שאילתה.
  - **יעילות**: בדרך כלל `LEFT JOIN ... IS NULL` או `NOT EXISTS` עדיפים על `NOT IN` (במיוחד כשיש `NULL`s בתת-שאילתה שעלולים לשנות לוגיקה). האופטימייזר לרוב ממיר `LEFT JOIN ... IS NULL` לאנטי-ג'וין יעיל.

##### SELECT כפולה 4 — תיאור בעברית

- **תיאור**: דוח למוקדן המציג **כמות קריאות לכל מדווח לפי שנה וחודש**, כולל שם מדווח וטלפון, ומסנן מדווחים עם יותר מ־2 קריאות בחודש.
- **שאילתה – צורה א׳**:
```sql
SELECT C.Full_Name_, C.Phone_Number_, 
       EXTRACT(YEAR FROM I.Call_Start_Timestamp_) AS Call_Year, 
       EXTRACT(MONTH FROM I.Call_Start_Timestamp_) AS Call_Month,
       COUNT(I.Incident_ID_) AS Total_Calls
FROM CALLERS C
JOIN INCIDENTS I ON C.Caller_ID_ = I.Caller_ID_
GROUP BY C.Full_Name_, C.Phone_Number_, Call_Year, Call_Month
HAVING COUNT(I.Incident_ID_) > 2;
```
![Image](stage_2/query_4/query4First.png)

- **שאילתה – צורה ב׳**:
```sql
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
```
![Image](stage_2/query_4/query4Second.png)

- **הבדלים ויעילות**:
  - **הבדל**: צורה א׳ מסננת עם `HAVING` על האגרגציה. צורה ב׳ בונה טבלה נגזרת (Derived Table) ואז מסננת ב־`WHERE`.
  - **יעילות**: לרוב האופטימייזר מפיק תכנית דומה, אבל צורה א׳ ישירה וברורה יותר; צורה ב׳ שימושית כשצריך להמשיך לבצע סינונים/חיבורים נוספים על התוצאה האגרגטיבית.

#### 4 שאילתות SELECT נוספות (ללא כפילות)

##### SELECT 5 — תיאור בעברית

- **תיאור**: מסך פרמדיק/רופא: **סיכום מדדים קריטיים לפי מטופל בחודש הנוכחי** (סטורציה מינימלית, דופק מקסימלי) כולל חישוב גיל, סינון מטופלים עם סטורציה מתחת ל־90 ומיון לפי הנמוכה ביותר.
- **שאילתה**:
```sql
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
```
![Image](stage_2/query_5/query5.png)


##### SELECT 6 — תיאור בעברית

- **תיאור**: מסך משגר/מנהל: **“מיקומים חמים” של אירועים פעילים** לפי עיר ורחוב, כולל כמות אירועים פעילים, חומרה מקסימלית, וזמן הקריאה הוותיק ביותר באזור.
- **שאילתה**:
```sql
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
```
![Image](stage_2/query_6/query6.png)


##### SELECT 7 — תיאור בעברית

- **תיאור**: מסך מנהל רפואי: **עומס על רופאים מקבלים בבתי חולים** בשנה הנוכחית, כולל בית חולים/עיר/שם רופא, מספר מטופלים שקיבל ותאריך הגעה אחרון.
- **שאילתה**:
```sql
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
```
![Image](stage_2/query_7/query7.png)


##### SELECT 8 — תיאור בעברית

- **תיאור**: דוח איכות: **פרוצדורות עם הצלחה גבוהה** כולל שם פרוצדורה, דירוג הצלחה, שם מטופל וחישוב גיל בזמן ביצוע הפרוצדורה, ומיון לפי גיל.
- **שאילתה**:
```sql
SELECT PP.Procedure_Name_, PP.Success_Rate_, P.First_Name_, P.Last_Name_,
       EXTRACT(YEAR FROM PP.Performed_At_) - EXTRACT(YEAR FROM P.Birth_Date_) AS Patient_Age_At_Procedure
FROM PROCEDURES_PERFORMED PP
JOIN PATIENTS P ON PP.Patient_ID_ = P.Patient_ID_
WHERE PP.Success_Rate_ = 'High'
ORDER BY Patient_Age_At_Procedure ASC;
```
![Image](stage_2/query_8/query8.png)


### שאילתות DELETE (3 סה״כ)

> לכל שאילתת `DELETE`: יש לכלול תיאור בעברית + צילום הרצה + צילום מצב בסיס הנתונים **לפני** ו**אחרי**.

#### DELETE 1

- **תיאור**: ארכוב/ניקוי נתונים: מחיקת מדדים רפואיים ישנים מאוד (שנת הקלטה לפני 2014) מטבלת `MEDICAL_MEASUREMENTS`.
- **שאילתה**:
```sql
DELETE FROM MEDICAL_MEASUREMENTS
WHERE EXTRACT(YEAR FROM Recorded_At_) < 2014;
```

![Image](images/stage_2/delete2.png)
![Image](images/stage_2/delete2After.png)

#### DELETE 2

- **תיאור**: מחיקת מדווחים (Callers) שאין להם אף אירוע מקושר (ללא היסטוריית דיווח) כדי לשמור על בסיס נתונים נקי.
- **שאילתה**:
```sql
DELETE FROM CALLERS
WHERE Caller_ID_ NOT IN (SELECT DISTINCT Caller_ID_ FROM INCIDENTS);
```
![Image](images/stage_2/Delete.png)
![Image](images/stage_2/Delete1After.png)

#### DELETE 3

- **תיאור**: מחיקת רשומות מיקום של אירועים שבוטלו (`Cancelled`) כדי להימנע מנתוני מיקום מיותרים שאינם רלוונטיים לתפעול.
- **שאילתה**:
```sql
DELETE FROM LOCATIONS
WHERE Incident_ID_ IN (SELECT Incident_ID_ FROM INCIDENTS WHERE Status_ = 'Cancelled');
```

![Image](images/stage_2/delete3.png)
![Image](images/stage_2/delete3After.png)

### שאילתות UPDATE (3 סה״כ)

> לכל שאילתת `UPDATE`: יש לכלול תיאור בעברית + צילום הרצה + צילום מצב בסיס הנתונים **לפני** ו**אחרי**.

#### UPDATE 1

- **תיאור**: עדכון סטטוס עומס בית חולים: אם לבית חולים היו יותר מ־2 פינויים בשנה הנוכחית, הסטטוס שלו מתעדכן ל־`High` (מבוסס `TRANSFER_SUMMARIES`).
- **שאילתה**:
```sql
UPDATE HOSPITALS
SET Current_Capacity_Status_ = 'High'
WHERE Hospital_ID_ IN (
    SELECT Hospital_ID_ 
    FROM TRANSFER_SUMMARIES 
    WHERE EXTRACT(YEAR FROM Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY Hospital_ID_ 
    HAVING COUNT(Transfer_ID_) > 2
);
```
![Image](images/stage_2/Update1.png)


#### UPDATE 2

- **תיאור**: סגירת אירועים ישנים: אירועים בסטטוס `Pending` עם זמן סיום קריאה לא ריק, ושנת תחילת קריאה לפני 2025 — מתעדכנים ל־`Resolved`.
- **שאילתה**:
```sql
UPDATE INCIDENTS
SET Status_ = 'Resolved'
WHERE Status_ = 'Pending' 
  AND Call_End_Timestamp_ IS NOT NULL 
  AND EXTRACT(YEAR FROM Call_Start_Timestamp_) < 2025;
```
![Image](images/stage_2/Update2.png)

#### UPDATE 3

- **תיאור**: העלאת דרגת עדיפות לסוגי אירוע חמורים: סוג אירוע שעבורו ממוצע חומרה של האירועים גבוה מ־4 — עדיפות ברירת המחדל מתעדכנת ל־1 (הגבוהה ביותר).
- **שאילתה**:
```sql
UPDATE INCIDENT_TYPES
SET Default_Priority_ = 1
WHERE Type_ID_ IN (
    SELECT Type_ID_ 
    FROM INCIDENTS 
    GROUP BY Type_ID_ 
    HAVING AVG(Severity_Level_) > 4
);
```
![Image](images/stage_2/Update3.png)


### ROLLBACK ו-COMMIT (הדגמות)

#### הדגמה 1 — עדכון ואז `ROLLBACK`

- **תיאור**: מבצעים עדכון בבסיס הנתונים, מציגים מצב, מבצעים `ROLLBACK`, ומציגים שהמצב חזר לקדמותו.
- **צילום מצב התחלתי (לפני העדכון)**: _(להדביק תמונה כאן)_
- **צילום אחרי העדכון**: _(להדביק תמונה כאן)_
- **צילום אחרי `ROLLBACK`**: _(להדביק תמונה כאן)_

#### הדגמה 2 — עדכון ואז `COMMIT`

- **תיאור**: מבצעים עדכון בבסיס הנתונים, מציגים מצב, מבצעים `COMMIT`, ומציגים שהמצב נשאר כפי שהיה.
![Image](images/stage_2/beforeCommit.png)
![Image](images/stage_2/afterCommit.png)


### אילוצים (3 סה״כ) באמצעות `ALTER TABLE`

לכל אילוץ: יש לתאר את השינוי, להציג את פקודת ה-`ALTER TABLE`, לנסות להכניס נתון שסותר את האילוץ, ולהראות שמתקבלת שגיאת הרצה.

#### אילוץ 1

- **תיאור**: הגבלת רמת חומרה בטבלת `INCIDENTS` לטווח 1–5 (שומר על עקביות הערכים במערכת).
- **פקודת `ALTER TABLE`**:
```sql
ALTER TABLE INCIDENTS
ADD CONSTRAINT CHK_Severity_Level CHECK (Severity_Level_ BETWEEN 1 AND 5);
```

#### אילוץ 2

- **תיאור**: וידוא שמספר בית (`House_Num_`) בטבלת `LOCATIONS` חיובי (> 0), למניעת כתובות לא תקינות.
- **פקודת `ALTER TABLE`**:
```sql
ALTER TABLE LOCATIONS
ADD CONSTRAINT CHK_House_Num CHECK (House_Num_ > 0);
```


#### אילוץ 3

- **תיאור**: הגבלת ערכי `Success_Rate_` בטבלת `PROCEDURES_PERFORMED` לערכים מוגדרים בלבד (Enum לוגי).
- **פקודת `ALTER TABLE`**:
```sql
ALTER TABLE PROCEDURES_PERFORMED
ADD CONSTRAINT CHK_Success_Rate_Enum CHECK (Success_Rate_ IN ('High', 'Medium', 'Low', 'Failed'));
```
![Image](images/stage_2/alertError2.png)


### אינדקסים (3 סה״כ) + בדיקות זמן ריצה

לכל אינדקס: לבדוק זמן ריצה לפני ואחרי הוספת האינדקס, ולהסביר תוצאות.

#### אינדקס 1
![Image](images/stage_2/index1Before.png)
![Image](images/stage_2/Index1.png)
![Image](images/stage_2/index1After.png)


#### אינדקס 2
![Image](images/stage_2/index2Before.png)
![Image](images/stage_2/Index2.png)
![Image](images/stage_2/index2After.png)

#### אינדקס 3
![Image](images/stage_2/index3Before.png)
![Image](images/stage_2/Index3.png)
![Image](images/stage_2/index3After.png)

---

## שלב ג' – אינטגרציית בסיסי נתונים ומבטים מתקדמים

## 1. תרשימי ה-ERD וה-DSD המעודכנים

### 1.1 תרשים קונספטואלי (ERD)
מציג את ישות האם `Personnel` ואת קשר ההורשה (IS-A) המתפצל לישויות הבנות `Drivers` ו-`Volunteers` (ביחס של 1:1). בנוסף, מוצגת ישות `Emergency_Dispatches` (שיגורים) המקושרת לנהג ולרכב, ואת קשר הרבים-לרבים (M:N) `Crew_Of` בין מתנדבים לשיגורים.

![תרשים ERD מעודכן ומאוחד](Stage_3/new_ERD.png)

### 1.2 תרשים מבני / סכמה רלציונית (DSD)
מציג את הטבלאות הפיזיות, מפתחות ראשיים (PK) ומפתחות זרים (FK). בתרשים זה ניתן לראות את טבלת הגישור הפיזית `dispatch_volunteers` המכילה מפתח ראשי מורכב, וכן את הקישורים הישירים מטבלאות הרכש, המדים והמוסך אל טבלת האם `personnel`.

![תרשים DSD / סכמה רלציונית מעודכנת](Stage_3/new_DSD.png)

---

## 2. החלטות שנעשו בשלב האינטגרציה

במהלך מיזוג המערכת המבצעית-רפואית עם המערכת הלוגיסטית ומערכת משאבי האנוש, התמודדנו עם אתגר ארכיטקטוני מורכב: כיצד להחיל חוקים מבצעיים נוקשים על אנשי הצוות מבלי לפגוע בשלמות הנתונים של המערכת הלוגיסטית (שבה כלל אנשי הצוות מבצעים פעולות רכש, ניפוק מדים או טיפול ברכבים).

להלן ההחלטות ההנדסיות המרכזיות שנתקבלו:

1. **אימוץ מודל הכללה והתמחות (Supertype / Subtype):** הוחלט לשמר את טבלת `personnel` המקורית כטבלת אב (Supertype). היא מרכזת את הפרטים האישיים והשיוך התחנתי של כלל העובדים בארגון. תחתיה, הוקמו שתי טבלאות בנות – `drivers` ו-`volunteers` – המקושרות אליה בקשר ירושה (1:1). החלטה זו מנעה כפילות נתונים (Data Redundancy) ושמרה על שלמות מוחלטת של כל קשרי הלוגיסטיקה הקיימים.
2. **ייצוג קשר רבים-לרבים לצוותי המשימה:** באמבולנס יחיד משובץ נהג אחד בדיוק, אך מספר משתנה של מתנדבים. כדי לאפשר שיבוץ דינמי זה תוך שמירה על נרמול, הוקמה טבלת גישור ייעודית בשם `dispatch_volunteers`.
3. **העברת אכיפת החוקים העסקיים לרמת מסד הנתונים (Triggers):** הוחלט לנעול את החוקים המבצעיים באמצעות טריגרים הרצים לפני פעולות הוספה או עדכון, כגון:
    * **טריגר אימות נוכחות בצוות:** מונע רישום של איש צוות כמבצע פעולה רפואית בשטח, אלא אם המערכת מאמתת שהוא שובץ פיזית באמבולנס הספציפי שייצא לאירוע.
    * **טריגר סמכות מסירה למיון:** חוסם כל ניסיון לחתום על טופס העברת מטופל לבית חולים, אלא אם החותם הוא הנהג המוגדר של אותה הנסיעה.
4. **פתרון בעיית אופטימיזציית ההגרלה ב-PostgreSQL:** כדי להבטיח פיזור אקראי אמיתי של שיבוץ רכבים ונהגים לכל נסיעה (ולמנוע שיוך של אותו רכב לכל הנסיעות בבת אחת בשל אופטימיזציית מנוע), השתמשנו בהמרת עמודות למערכים דינמיים ושליפת אינדקס אקראי המחושב מחדש אקטיבית לכל שורת נתונים בנפרד.

---

## 3. הסבר מילולי של התהליך והפקודות

תהליך המיזוג והחלת הארכיטקטורה החדשה בוצע במספר פעימות של שאילתות ופעולות על בסיס הנתונים:

* **שלב א' - פיצול ישויות (Subtypes):** יצרנו את טבלאות הנהגים והמתנדבים. הנתונים נשאבו לתוכן מתוך טבלת `personnel` המקורית באמצעות חיתוך טקסטואלי על שדה התפקיד, תוך הגדרת מפתח ראשי המהווה גם מפתח זר לטבלת האם עם חוק מחיקה מדורגת.
* **שלב ב' - הרחבת התשתיות:** הוספנו את עמודות הקישור הנדרשות לטבלאות המבצעיות (כגון שדה מזהה נהג או לוחית רישוי בטבלת השיגורים), ויצרנו פיזית את טבלת הגישור של המתנדבים עם מפתח ראשי מורכב למניעת כפילויות שיבוץ באותה נסיעה.
* **שלב ג' - סימולציה ויישור נתונים לוגי (Data Alignment):** ביצענו עדכון גורף לשיבוץ רנדומלי של רכבים ונהגים חוקיים לכל משימה. בנוסף, סינכרנו את הזמנים כך שזמני ההגעה והעזיבה יהיו כרונולוגיים והגיוניים לזמן הקריאה, ודאגנו להתאמה גיאוגרפית של בית החולים הקולט. להגרלת המתנדבים השתמשנו בלולאת הצלבה מתקדמת.
* **שלב ד' - החלת אילוצי שלמות (Constraints):** הוגדרו המפתחות הזרים הפיזיים אשר חוסמים הזנת רשומות ללא סימוכין (למשל, שיגור רכב שאינו קיים במצבת הרכבים או נהג שלא קיים בטבלת נהגים).
* **שלב ה' - פיתוח טריגרים (Triggers):** נכתבו פונקציות אכיפה אשר בודקות תנאים לוגיים המאחדים את צוות הנהגים והמתנדבים בנסיעה ספציפית, וזורקות שגיאה חמורה העוצרת את התהליך במידה ויש ניסיון להזין נתון המפר את נוהלי הארגון.

---

## 4. תיאור מילולי של המבטים ושליפת נתונים בסיסית

### מבט 1: אגף משאבי אנוש ולוגיסטיקה (`hr_personnel_deployment_view`)
**תיאור מילולי:** מבט ניהולי המחבר בין טבלת האם של העובדים לטבלת התחנות, ומבצע בדיקה דינמית מול טבלאות הבנות כדי לקבוע באופן מילולי האם העובד מתפקד בארגון כנהג ('Driver') או כמתנדב ('Volunteer'). המבט חוסך למנהל כוח האדם את הצורך לבצע תתי-שאילתות מורכבות בעת הפקת דוח מצבת עובדים.

![פלט שליפת נתונים בסיסית - מבט 1](Stage_3/view_1/View_1.png)

---

### מבט 2: האגף המבצעי-רפואי (`medical_procedures_tracking_view`)
**תיאור מילולי:** מבט המיועד לבקרת איכות רפואית. הוא משלב נתונים מטבלת הטיפולים הרפואיים בשטח, טבלת נסיעות החירום, טבלת האירועים המרכזית וטבלת העובדים. המבט מציג תמונה אחודה הכוללת את שם הטיפול, אחוז ההצלחה, רמת החומרה, וסוג המקרה, לצד שמו המלא של איש הצוות שביצע את הטיפול בפועל (נהג או מתנדב).

![פלט שליפת נתונים בסיסית - מבט 2](Stage_3/view_2/View_2.png)

---

### מבט 3: אינטגרציית מערכות - המבט המשולב (`integrated_mission_log_view`)
**תיאור מילולי:** זהו המבט האינטגרטיבי המרכזי של הפרויקט, המהווה גשר ישיר בין האגף המבצעי לאגף הלוגיסטי. עבור כל נסיעת חירום, המבט שולף את זמן ההזנקה וחומרת האירוע, ומחבר אותם ישירות ללוחית הרישוי של הרכב, סוג האמבולנס, תחנת האם אליה הרכב שייך, ושמו המלא של הנהג שהוביל את המשימה.

![פלט שליפת נתונים בסיסית - מבט 3](Stage_3/view_3/View_3.png)

---

## 5. שאילתות משמעותיות על המבטים

### 5.1 שאילתות על מבט משאבי אנוש ולוגיסטיקה

#### שאילתא א': התפלגות כוח אדם בתחנות
**תיאור מילולי:** שאילתא ניהולית המציגה את התפלגות התפקידים בארגון. היא מקבצת את הנתונים לפי תחנה ולפי סוג העובד, וסופרת כמה נהגים וכמה מתנדבים רשומים ומסווגים בכל תחנה.

![פלט שאילתא 1א](Stage_3/view_1/Select_1_1.png)

#### שאילתא ב': יומן כוננות נהגים מרחבי
**תיאור מילולי:** שליפת רשימת שמותיהם המלאים של כלל אנשי הצוות המוגדרים כנהגים ומשרתים בתחנות במחוז או בעיר ספציפית, לצורך שיבוץ משמרות זמין ויעיל.

![פלט שאילתא 1ב](Stage_3/view_1/Select_1_2.png)

---

### 5.2 שאילתות על מבט מעקב פרוצדורות רפואיות

#### שאילתא א': בקרת מקרים קריטיים
**תיאור מילולי:** איתור וריכוז של כל הפעולות הרפואיות שבוצעו בשטח באירועים קריטיים במיוחד (דרגת חומרה 5). השאילתה מסדרת את הנתונים לפי רמת הצלחת הטיפול בסדר יורד, לשם ביצוע תחקיר אירוע והפקת לקחים רפואיים.

![פלט שאילתא 2א](Stage_3/view_2/Select_2_1.png)

#### שאילתא ב': איתור אנשי צוות פעילים
**תיאור מילולי:** שאילתת אופטימיזציה המזהה מיהם חמשת אנשי הצוות (נהגים או מתנדבים) הפעילים ביותר בשטח, אשר ביצעו בפועל את כמות הפרוצדורות הרפואיות הגבוהה ביותר מתוך סך כלל האירועים.

![פלט שאילתא 2ב](Stage_3/view_2/Select_2_2.png)

---

### 5.3 שאילתות על המבט המשולב

#### שאילתא א': יומן פעילות כלי רכב
**תיאור מילולי:** הפקת דוח היסטורי ומלא עבור אמבולנס ספציפי המציג מתי הוא הוזנק לאירוע, מה הייתה חומרת המקרה, ומי הנהג שפיקד על הרכב באותה נסיעה. מיועד למעקב קילומטראז' מבצעי וטיפולים מונעים של הצי.

![פלט שאילתא 3א](Stage_3/view_3/Select_3_1.png)

#### שאילתא ב': ניתוח עומסי חירום למרחב
**תיאור מילולי:** שאילתת אסטרטגיה המדרגת את כמות אירועי החירום הקשים (חומרה 4 ו-5) שהוזנקו מכל תחנה לוגיסטית, במטרה לאתר נקודות פריסה הדורשות תגבור עתידי של ניידות טיפול נמרץ (נט"ן).

![פלט שאילתא 3ב](Stage_3/view_3/Select_3_2.png)

## שלב ד': תכנות במסד הנתונים (PL/pgSQL)

בשלב זה הוספנו לוגיקה עסקית דינמית ומורכבת בצד השרת באמצעות כתיבת פונקציות, פרוצדורות, טריגרים ותוכניות ראשיות ב-PL/pgSQL. 
הקוד מיישם עקרונות תכנות מתקדמים במסד הנתונים ומכסה את הדרישות הבאות: שימוש בסמנים (Implicit & Explicit), החזרת `REF CURSOR`, פקודות DML שונות, הסתעפויות (`IF/ELSIF`), לולאות (`LOOP`, `FOR`), טיפול בשגיאות (`EXCEPTION`), ושימוש במשתנים מטיפוס `RECORD`.

כל התוכניות נבדקו ורצו בהצלחה. להלן הפירוט, הקוד והוכחות ההרצה לכל תוכנית.

---

### 1. פונקציות (Functions)

#### 1.1 פונקציה לחישוב ציון סיכון (`calculate_patient_risk_score`)
* **תיאור מילולי:** הפונקציה מקבלת מזהה מטופל (`Patient_ID_`), שולפת באמצעות סמן מרומז את כל המדדים הרפואיים שלו, ומחשבת "ציון סיכון" המבוסס על חריגות בסטורציה, דופק ולחץ דם. הפונקציה משתמשת בלולאות, הסתעפויות ומשתנה מטיפוס `RECORD`. אם לא נמצאו מדדים למטופל, נזרקת חריגה (Exception) יזומה.
* **קוד הפונקציה:**
```sql
CREATE OR REPLACE FUNCTION calculate_patient_risk_score(p_patient_id INT)
RETURNS INT AS $$
DECLARE
    v_risk_score INT := 0;
    v_measurement RECORD; -- Explicit use of RECORD type to hold table rows
    v_found_measurements BOOLEAN := FALSE;
BEGIN
    -- Implicit cursor using a FOR loop to iterate over patient measurements
    FOR v_measurement IN (
        SELECT Systolic_BP_, Diastolic_BP_, Pulse_, Oxygen_Saturation_
        FROM MEDICAL_MEASUREMENTS
        WHERE Patient_ID_ = p_patient_id
    ) LOOP
        v_found_measurements := TRUE;

        -- Branching logic based on the oxygen saturation
        IF v_measurement.Oxygen_Saturation_ < 90 THEN
            v_risk_score := v_risk_score + 3;
        ELSIF v_measurement.Oxygen_Saturation_ BETWEEN 90 AND 94 THEN
            v_risk_score := v_risk_score + 1;
        END IF;

        -- Branching logic based on pulse abnormalities
        IF v_measurement.Pulse_ > 120 OR v_measurement.Pulse_ < 50 THEN
            v_risk_score := v_risk_score + 2;
        END IF;

        -- Branching logic based on high blood pressure
        IF v_measurement.Systolic_BP_ > 180 OR v_measurement.Diastolic_BP_ > 110 THEN
            v_risk_score := v_risk_score + 2;
        END IF;
    END LOOP;

    -- Exception simulation: throw an error if no records exist for calculation
    IF NOT v_found_measurements THEN
        RAISE EXCEPTION 'No medical measurements found for patient %', p_patient_id;
    END IF;

    RETURN v_risk_score;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle unexpected errors gracefully and return a default score of 0
        RAISE NOTICE 'Error in calculate_patient_risk_score: %', SQLERRM;
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

```
הוכחת הרצה: (הכנס כאן 2 תמונות: אחת של קריאה לפונקציה עם מטופל תקין שמחזירה מספר, ואחת של קריאה עם מטופל שאין לו מדדים שמציגה את ה-Exception)
---
1.2 פונקציית שליפת אירועים קריטיים (get_active_critical_incidents)
תיאור מילולי: פונקציה המיועדת למערכת הניהול. היא מקבלת רמת חומרה מינימלית, ומחזירה מצביע (REF CURSOR) לתוצאות שאילתה המשלבת את טבלת האירועים וטבלת המיקומים עבור אירועים פעילים.
---
קוד הפונקציה:
```sql
SQL
CREATE OR REPLACE FUNCTION get_active_critical_incidents(p_min_severity INT)
RETURNS REFCURSOR AS $$
DECLARE
    v_ref_cursor REFCURSOR; -- Variable declaration for the reference cursor
BEGIN
    -- Open the ref cursor dynamically based on the severity parameter
    OPEN v_ref_cursor FOR
        SELECT I.Incident_ID_, I.Call_Start_Timestamp_, I.Severity_Level_, L.City_, L.Street_
        FROM INCIDENTS I
        JOIN LOCATIONS L ON I.Incident_ID_ = L.Incident_ID_
        WHERE I.Status_ IN ('Pending', 'Dispatched', 'On Scene')
          AND I.Severity_Level_ >= p_min_severity
        ORDER BY I.Severity_Level_ DESC, I.Call_Start_Timestamp_ ASC;

    -- Return the cursor pointing to the result set
    RETURN v_ref_cursor;
END;
$$ LANGUAGE plpgsql;
```
הוכחת הרצה: (הכנס כאן תמונה מתוך בלוק טרנזקציה ב-pgAdmin שבה קראת לפונקציה ועשית FETCH ALL IN והתוצאות הוצגו)
---

2. פרוצדורות (Procedures)
2.1 עדכון תפוסת בתי חולים (update_hospital_capacities)
תיאור מילולי: הפרוצדורה משתמשת בסמן מפורש (Explicit Cursor) כדי לעבור על כל בתי החולים. עבור כל בית חולים, היא סופרת את כמות המטופלים שהועברו אליו השנה, ומשתמשת בפקודות UPDATE והסתעפויות כדי לעדכן את עמודת סטטוס התפוסה שלו ל-'Full', 'High' או 'Normal'.
---

קוד הפרוצדורה:

```sql
CREATE OR REPLACE PROCEDURE update_hospital_capacities()
LANGUAGE plpgsql AS $$
DECLARE
    v_hospital_record RECORD; -- Using RECORD type for the explicit cursor
    v_transfer_count INT;
    
    -- Explicit cursor declaration to fetch all hospitals
    cursor_hospitals CURSOR FOR 
        SELECT Hospital_ID_, Current_Capacity_Status_ 
        FROM HOSPITALS;
BEGIN
    -- Open the cursor and begin looping through the rows
    OPEN cursor_hospitals;
    LOOP
        FETCH cursor_hospitals INTO v_hospital_record;
        
        -- Exit the loop when there are no more rows
        EXIT WHEN NOT FOUND;

        -- Count transfers to this specific hospital in the current year
        SELECT COUNT(Transfer_ID_) INTO v_transfer_count
        FROM TRANSFER_SUMMARIES
        WHERE Hospital_ID_ = v_hospital_record.Hospital_ID_
          AND EXTRACT(YEAR FROM Arrival_At_Hospital_Time_) = EXTRACT(YEAR FROM CURRENT_DATE);

        -- Branching logic to determine and update the new capacity status
        IF v_transfer_count > 10 THEN
            UPDATE HOSPITALS
            SET Current_Capacity_Status_ = 'Full'
            WHERE Hospital_ID_ = v_hospital_record.Hospital_ID_;
            
        ELSIF v_transfer_count BETWEEN 5 AND 10 THEN
            UPDATE HOSPITALS
            SET Current_Capacity_Status_ = 'High'
            WHERE Hospital_ID_ = v_hospital_record.Hospital_ID_;
            
        ELSE
            UPDATE HOSPITALS
            SET Current_Capacity_Status_ = 'Normal'
            WHERE Hospital_ID_ = v_hospital_record.Hospital_ID_;
        END IF;
    END LOOP;
    
    -- Close the cursor to free memory
    CLOSE cursor_hospitals;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle execution errors safely without crashing the system
        RAISE NOTICE 'An error occurred while updating hospital capacities: %', SQLERRM;
END;
$$;
```
הוכחת הרצה: (הכנס כאן תמונה של טבלת HOSPITALS לפני ההרצה, ותמונה אחרי ההרצה שבה רואים את הסטטוסים שהשתנו)
---

2.2 ניקוי אירועי שווא (cancel_stale_incidents)
תיאור מילולי: הפרוצדורה עוברת על כל האירועים המוגדרים כ-'Pending' אך שיחתם הסתיימה. היא מבצעת מספר פקודות DML ברצף: מעדכנת את סטטוס האירוע ל-'Cancelled', ולאחר מכן מוחקת (DELETE) את רשומת המיקום שלו מטבלת המיקומים כדי לנקות נתונים מיותרים מהמפה.
---

קוד הפרוצדורה:

```sql
CREATE OR REPLACE PROCEDURE cancel_stale_incidents()
LANGUAGE plpgsql AS $$
DECLARE
    v_incident_record RECORD; -- Implicit cursor record
    v_deleted_locations INT := 0;
    v_updated_incidents INT := 0;
BEGIN
    -- Implicit cursor using a FOR loop to find stale pending incidents
    FOR v_incident_record IN (
        SELECT Incident_ID_ 
        FROM INCIDENTS 
        WHERE Status_ = 'Pending' 
          AND Call_End_Timestamp_ IS NOT NULL
    ) LOOP
        -- DML Command 1: Cancel the incident status
        UPDATE INCIDENTS
        SET Status_ = 'Cancelled'
        WHERE Incident_ID_ = v_incident_record.Incident_ID_;
        
        v_updated_incidents := v_updated_incidents + 1;

        -- DML Command 2: Delete the corresponding physical location
        DELETE FROM LOCATIONS
        WHERE Incident_ID_ = v_incident_record.Incident_ID_;
        
        v_deleted_locations := v_deleted_locations + 1;
    END LOOP;

    -- Output a success message showing the summary of the operations
    RAISE NOTICE 'Cleanup finished: % incidents cancelled, % locations deleted.', 
                 v_updated_incidents, v_deleted_locations;

EXCEPTION
    WHEN OTHERS THEN
        -- Safely handle exceptions during the cleanup process
        RAISE NOTICE 'Error encountered during stale incident cancellation: %', SQLERRM;
END;
$$;
```
הוכחת הרצה: (הכנס כאן תמונה מתוך לשונית Messages המראה את ההדפסה של סיכום המחיקות)
---

3. טריגרים (Triggers)
3.1 חסימת סגירת אירוע ללא פינוי (trg_verify_critical_closure)
תיאור מילולי: טריגר הפועל BEFORE UPDATE על טבלת INCIDENTS. במקרה של ניסיון לשנות סטטוס של אירוע בעל חומרה 5 ל-'Resolved', הטריגר בודק האם קיים לו טופס העברה לבית חולים. אם לא – העדכון נחסם ונזרקת שגיאה קריטית.
---

קוד הטריגר:

```sql
CREATE OR REPLACE FUNCTION verify_critical_incident_closure()
RETURNS TRIGGER AS $$
DECLARE
    v_transfer_exists BOOLEAN := FALSE;
BEGIN
    -- Check if the incident is being marked as Resolved and is critical (Severity 5)
    IF NEW.Status_ = 'Resolved' AND NEW.Severity_Level_ = 5 THEN
        
        -- Check if there is at least one transfer summary for this incident
        SELECT EXISTS (
            SELECT 1
            FROM TRANSFER_SUMMARIES TS
            JOIN EMERGENCY_DISPATCHES ED ON TS.Dispatch_ID_ = ED.Dispatch_ID_
            WHERE ED.Incident_ID_ = NEW.Incident_ID_
        ) INTO v_transfer_exists;
        
        -- If no transfer summary exists, block the update
        IF NOT v_transfer_exists THEN
            RAISE EXCEPTION 'Cannot resolve critical incident % without a hospital transfer summary.', NEW.Incident_ID_;
        END IF;
    END IF;
    
    -- Allow the update to proceed if conditions are met
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verify_critical_closure
BEFORE UPDATE ON INCIDENTS
FOR EACH ROW
EXECUTE FUNCTION verify_critical_incident_closure();
```
הוכחת הרצה: (הכנס צילום מסך של ניסיון לבצע פקודת UPDATE כזו, וצילום של הודעת השגיאה שהטריגר זרק)
---

3.2 הקפצת חומרה אוטומטית (trg_escalate_severity)
תיאור מילולי: טריגר מבצעי הפועל AFTER INSERT OR UPDATE על טבלת המדדים (MEDICAL_MEASUREMENTS). אם מוזן מדד חריג ממוניטור הצוות בשטח (למשל, סטורציה מתחת ל-85 או דופק מעל 150), הטריגר מזהה את האירוע הרלוונטי ומבצע עליו פקודת UPDATE המעלה אוטומטית את דרגת החומרה שלו ל-5.
---

קוד הטריגר:

```sql
CREATE OR REPLACE FUNCTION escalate_incident_severity()
RETURNS TRIGGER AS $$
DECLARE
    v_incident_id INT;
BEGIN
    -- Check if the new measurement indicates a critical condition
    IF NEW.Oxygen_Saturation_ < 85 OR NEW.Pulse_ > 150 THEN
        
        -- Find the corresponding incident ID via the dispatch table
        SELECT Incident_ID_ INTO v_incident_id
        FROM EMERGENCY_DISPATCHES
        WHERE Dispatch_ID_ = NEW.Dispatch_ID_;
        
        -- If an incident is found, automatically elevate its severity to 5 (Critical)
        IF v_incident_id IS NOT NULL THEN
            UPDATE INCIDENTS
            SET Severity_Level_ = 5
            WHERE Incident_ID_ = v_incident_id AND Severity_Level_ < 5;
        END IF;
    END IF;
    
    -- Proceed with the insertion of the measurement
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_escalate_severity
AFTER INSERT OR UPDATE ON MEDICAL_MEASUREMENTS
FOR EACH ROW
EXECUTE FUNCTION escalate_incident_severity();
```

הוכחת הרצה: (הכנס צילום של טבלת INCIDENTS לפני עם חומרה נמוכה, צילום פקודת ה-INSERT של המדד, וצילום INCIDENTS אחרי בו רואים שהחומרה קפצה ל-5)
---

4. תוכניות ראשיות (Anonymous Blocks)
4.1 תוכנית ראשית א': ניהול סיכונים ותפוסה
תיאור מילולי: בלוק אנונימי המזמן קודם כל את הפרוצדורה update_hospital_capacities, ולאחר מכן קורא לפונקציה calculate_patient_risk_score עבור מטופל ספציפי ומדפיס את ציון הסיכון שהוחזר לקונסולה.
---

קוד התוכנית:

```sql
DO $$
DECLARE
    v_test_patient_id INT := 1; 
    v_calculated_risk INT;
BEGIN
    -- 1. Call the procedure to update hospital capacities
    RAISE NOTICE 'Starting hospital capacity update...';
    CALL update_hospital_capacities();
    RAISE NOTICE 'Hospital capacities updated successfully.';

    -- 2. Call the function to calculate risk score for a specific patient
    RAISE NOTICE 'Calculating risk score for patient ID: %', v_test_patient_id;
    v_calculated_risk := calculate_patient_risk_score(v_test_patient_id);
    
    -- Print the returned result
    RAISE NOTICE 'The calculated risk score is: %', v_calculated_risk;

EXCEPTION
    WHEN OTHERS THEN
        -- Safely handle any execution errors
        RAISE NOTICE 'An error occurred in Main Program 1: %', SQLERRM;
END;
$$;
```
הוכחת הרצה: (הכנס צילום מסך של חלונית ה-Messages ב-pgAdmin לאחר הרצת הבלוק)
---

4.2 תוכנית ראשית ב': מערך שליטה ובקרה לאירועים קריטיים
תיאור מילולי: התוכנית מפעילה בתחילה את פרוצדורת הניקוי cancel_stale_incidents. מיד לאחר מכן, היא מזמנת את הפונקציה get_active_critical_incidents ומקבלת ממנה REF CURSOR. באמצעות לולאת LOOP, התוכנית שואבת רשומה אחר רשומה מהסמן ומדפיסה את פרטי האירועים הקריטיים למסך הפלט.
---

קוד התוכנית:

```sql
DO $$
DECLARE
    v_cursor REFCURSOR;
    v_incident_id INT;
    v_call_time TIMESTAMP;
    v_severity INT;
    v_city VARCHAR;
    v_street VARCHAR;
BEGIN
    -- 1. Call the procedure to clean up stale incidents first
    RAISE NOTICE 'Running cleanup for stale incidents...';
    CALL cancel_stale_incidents();

    -- 2. Call the function that returns a Ref Cursor (severity >= 4)
    RAISE NOTICE 'Fetching active critical incidents...';
    v_cursor := get_active_critical_incidents(4);
    
    -- Loop to process the returned cursor rows one by one
    LOOP
        FETCH NEXT FROM v_cursor INTO v_incident_id, v_call_time, v_severity, v_city, v_street;
        
        -- Exit loop when no more rows are fetched from the cursor
        EXIT WHEN NOT FOUND;
        
        -- Display the fetched record
        RAISE NOTICE 'Critical Incident ID: % | Severity: % | Location: % %', 
                     v_incident_id, v_severity, v_street, v_city;
    END LOOP;
    
    -- Close the cursor to free database memory
    CLOSE v_cursor;

EXCEPTION
    WHEN OTHERS THEN
        -- Safely handle any execution errors
        RAISE NOTICE 'An error occurred in Main Program 2: %', SQLERRM;
END;
$$;
```
הוכחת הרצה: (הכנס צילום מסך של חלונית ה-Messages המראה את הלולאה מדפיסה את האירועים אחד אחד)
