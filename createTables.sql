CREATE TABLE INCIDENT_TYPES
(
  Type_ID_ INT NOT NULL,
  Type_Name_ VARCHAR(200) NOT NULL,
  Default_Priority_ INT NOT NULL,
  Protocol_Instructions_ VARCHAR(500),
  PRIMARY KEY (Type_ID_)
);

CREATE TABLE CALLERS
(
  Caller_ID_ INT NOT NULL,
  Phone_Number_ VARCHAR(20) NOT NULL,
  Full_Name_ VARCHAR(50) NOT NULL,
  Language_Preference_ VARCHAR(50) NOT NULL,
  PRIMARY KEY (Caller_ID_),
  UNIQUE (Phone_Number_)
);

CREATE TABLE PATIENTS
(
  Patient_ID_ INT NOT NULL,
  First_Name_ VARCHAR(50) NOT NULL,
  Last_Name_ VARCHAR(50) NOT NULL,
  Birth_Date_ DATE,
  Gender_ VARCHAR(20),
  Medical_Notes_ VARCHAR(500),
  Insurance_Provider_ VARCHAR(100),
  PRIMARY KEY (Patient_ID_)
);

CREATE TABLE HOSPITALS
(
  Hospital_ID_ INT NOT NULL,
  Hospital_Name_ VARCHAR(100) NOT NULL,
  City_ VARCHAR(50),
  Specialty_Unit_ VARCHAR(100),
  Current_Capacity_Status_ VARCHAR(20),
  PRIMARY KEY (Hospital_ID_)
);

CREATE TABLE INCIDENTS
(
  Incident_ID_ INT NOT NULL,
  Call_Start_Timestamp_ DATE NOT NULL,
  Call_End_Timestamp_ DATE,
  Severity_Level_ INT,
  Status_ VARCHAR(20),
  Type_ID_ INT NOT NULL,
  Caller_ID_ INT NOT NULL,
  PRIMARY KEY (Incident_ID_),
  FOREIGN KEY (Type_ID_) REFERENCES INCIDENT_TYPES(Type_ID_),
  FOREIGN KEY (Caller_ID_) REFERENCES CALLERS(Caller_ID_)
);

CREATE TABLE LOCATIONS
(
  Location_ID_ INT NOT NULL,
  City_ VARCHAR(50) NOT NULL,
  Street_ VARCHAR(100) NOT NULL,
  House_Num_ INT,
  Floor_Num_ INT,
  Entry_Code_ VARCHAR(20),
  Latitude_ NUMERIC(9,6),
  Longitude_ NUMERIC(9,6),
  Incident_ID_ INT NOT NULL,
  PRIMARY KEY (Location_ID_),
  FOREIGN KEY (Incident_ID_) REFERENCES INCIDENTS(Incident_ID_)
);

CREATE TABLE EMERGENCY_DISPATCHES
(
  Dispatch_ID_ INT NOT NULL,
  Vehicle_ID_ VARCHAR(20) NOT NULL,
  Dispatch_Time_ DATE NOT NULL,
  Arrival_Time_ DATE,
  Departure_Time_ DATE,
  Incident_ID_ INT NOT NULL,
  PRIMARY KEY (Dispatch_ID_),
  FOREIGN KEY (Incident_ID_) REFERENCES INCIDENTS(Incident_ID_)
);

CREATE TABLE MEDICAL_MEASUREMENTS
(
  Measurement_ID_ INT NOT NULL,
  Recorded_At_ DATE NOT NULL,
  Systolic_BP_ INT NOT NULL,
  Diastolic_BP_ INT NOT NULL,
  Pulse_ INT NOT NULL,
  Oxygen_Saturation_ INT NOT NULL,
  Dispatch_ID_ INT NOT NULL,
  Patient_ID_ INT NOT NULL,
  PRIMARY KEY (Measurement_ID_),
  FOREIGN KEY (Dispatch_ID_) REFERENCES EMERGENCY_DISPATCHES(Dispatch_ID_),
  FOREIGN KEY (Patient_ID_) REFERENCES PATIENTS(Patient_ID_)
);

CREATE TABLE PROCEDURES_PERFORMED
(
  Action_ID_ INT NOT NULL,
  Procedure_Name_ VARCHAR(100) NOT NULL,
  Performed_At_ DATE NOT NULL,
  Success_Rate_ VARCHAR(20) NOT NULL,
  Dispatch_ID_ INT NOT NULL,
  Patient_ID_ INT NOT NULL,
  PRIMARY KEY (Action_ID_),
  FOREIGN KEY (Dispatch_ID_) REFERENCES EMERGENCY_DISPATCHES(Dispatch_ID_),
  FOREIGN KEY (Patient_ID_) REFERENCES PATIENTS(Patient_ID_)
);

CREATE TABLE TRANSFER_SUMMARIES
(
  Transfer_ID_ INT NOT NULL,
  Receiving_Physician_ VARCHAR(100),
  Handover_Notes_ VARCHAR(1000),
  Arrival_At_Hospital_Time_ DATE NOT NULL,
  Dispatch_ID_ INT NOT NULL,
  Hospital_ID_ INT NOT NULL,
  PRIMARY KEY (Transfer_ID_),
  FOREIGN KEY (Dispatch_ID_) REFERENCES EMERGENCY_DISPATCHES(Dispatch_ID_),
  FOREIGN KEY (Hospital_ID_) REFERENCES HOSPITALS(Hospital_ID_)
);