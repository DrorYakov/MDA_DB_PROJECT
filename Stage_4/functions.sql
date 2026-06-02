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
        RETURN 0;
END;
$$ LANGUAGE plpgsql;







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