--Before update
SELECT Hospital_Name_, City_, Current_Capacity_Status_ FROM HOSPITALS WHERE City_ = 'Tel Aviv';

UPDATE HOSPITALS SET Current_Capacity_Status_ = 'Full' WHERE City_ = 'Tel Aviv';
--After update
SELECT Hospital_Name_, City_, Current_Capacity_Status_ FROM HOSPITALS WHERE City_ = 'Tel Aviv';

ROLLBACK;
--Proof that nothing changed
SELECT Hospital_Name_, City_, Current_Capacity_Status_ FROM HOSPITALS WHERE City_ = 'Tel Aviv';