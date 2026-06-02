-- 1. Create the trigger function
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

-- 2. Attach the trigger to the table
CREATE TRIGGER trg_verify_critical_closure
BEFORE UPDATE ON INCIDENTS
FOR EACH ROW
EXECUTE FUNCTION verify_critical_incident_closure();

-- 1. Create the trigger function
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

-- 2. Attach the trigger to the table
CREATE TRIGGER trg_escalate_severity
AFTER INSERT OR UPDATE ON MEDICAL_MEASUREMENTS
FOR EACH ROW
EXECUTE FUNCTION escalate_incident_severity();