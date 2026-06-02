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
        RAISE NOTICE 'An error occurred while updating hospital capacities.';
END;
$$;






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
        RAISE NOTICE 'Error encountered during stale incident cancellation.';
END;
$$;