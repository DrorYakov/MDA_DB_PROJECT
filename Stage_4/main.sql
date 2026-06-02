DO $$
DECLARE
    -- Change this variable to a valid Patient_ID_ that exists in your database
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