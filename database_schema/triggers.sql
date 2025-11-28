-- before organ insert
DELIMITER //
CREATE TRIGGER before_organ_insert
BEFORE INSERT ON Organ
FOR EACH ROW
BEGIN
    DECLARE donor_status VARCHAR(50);
    DECLARE clearance_date DATE;
    -- Get donor status and clearance date
    SELECT Status, Medical_Clearance_Date INTO donor_status, clearance_date
    FROM Donor
    WHERE Donor_ID = NEW.Donor_ID;
    -- Check if donor exists
    IF donor_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Donor does not exist';
    END IF;
    -- Check if donor is eligible (Active or Deceased)
    IF donor_status NOT IN ('Active', 'Deceased') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Donor is not eligible. Status must be Active or Deceased';
    END IF;
    -- Check if medical clearance exists
    IF clearance_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Donor has no medical clearance date';
    END IF;
    -- All validations passed - organ will be inserted
END //
DELIMITER ;

-- after organ insert
DELIMITER //
CREATE TRIGGER after_organ_insert
AFTER INSERT ON Organ
FOR EACH ROW
BEGIN
    -- Automatically create allocation offers for top 3 matched recipients
    -- This uses a temporary table to store matching results
    -- Insert allocation offers for top matches
    INSERT INTO Organ_Allocation (Organ_ID, Recipient_ID, Allocation_Date, Match_Score, Status, Response_Deadline)
    SELECT 
        NEW.Organ_ID,
        r.Recipient_ID,
        NOW(),
        -- Calculate match score
        CASE 
            WHEN CheckBloodTypeCompatibility(d.Blood_Type, r.Blood_Type) = FALSE THEN 0
            ELSE (
                CASE WHEN d.Blood_Type = r.Blood_Type THEN 30.00 ELSE 20.00 END +
                15.00 +
                LEAST(CalculateWaitTimeDays(r.Recipient_ID, NEW.Type_Name) / 30, 20) +
                15.00 +
                r.Medical_Urgency_Level * 2
            )
        END as match_score,
        'Pending',
        DATE_ADD(NOW(), INTERVAL (GetRemainingViableHours(NEW.Organ_ID) * 0.5) HOUR)
    FROM Recipient r
    JOIN Recipient_Waitlist wl ON r.Recipient_ID = wl.Recipient_ID
    JOIN Donor d ON d.Donor_ID = NEW.Donor_ID
    WHERE wl.Type_Name = NEW.Type_Name
      AND wl.Status = 'Waiting'
      AND r.Status = 'Waiting'
      AND CheckBloodTypeCompatibility(d.Blood_Type, r.Blood_Type) = TRUE
      AND NOT EXISTS (
          SELECT 1 FROM Compatibility_Test ct
          WHERE ct.Donor_ID = NEW.Donor_ID
            AND ct.Recipient_ID = r.Recipient_ID
            AND ct.Test_Result = 'Incompatible'
      )
    ORDER BY match_score DESC
    LIMIT 3;
END //
DELIMITER ;

-- before organ update
DELIMITER //
CREATE TRIGGER before_organ_update
BEFORE UPDATE ON Organ
FOR EACH ROW
BEGIN
    -- Prevent changing status from Transplanted back to Available
    IF OLD.Status = 'Transplanted' AND NEW.Status IN ('Available', 'Allocated') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot revert transplanted organ to available status';
    END IF;
    -- Prevent changing status from Expired to Available
    IF OLD.Status = 'Expired' AND NEW.Status = 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot revert expired organ to available status';
    END IF;
END //
DELIMITER ;

-- after recipient update
DELIMITER //
CREATE TRIGGER after_recipient_update
AFTER UPDATE ON Recipient
FOR EACH ROW
BEGIN
    -- Only recalculate if medical urgency level actually changed
    IF OLD.Medical_Urgency_Level != NEW.Medical_Urgency_Level THEN
        -- Recalculate priority for all organ types this recipient is waiting for
        -- We need to use a cursor or handle each waitlist entry
        -- Simple approach: Update priority scores directly
        UPDATE Recipient_Waitlist
        SET Priority_Score = (
            -- Urgency points (40%)
            (NEW.Medical_Urgency_Level * 8) +
            -- Wait time points (30%)
            LEAST(CalculateWaitTimeDays(NEW.Recipient_ID, Type_Name) / 30, 30) +
            -- Organ-specific points (30%)
            CASE 
                WHEN Type_Name = 'Liver' AND MELD_Score IS NOT NULL THEN
                    LEAST((MELD_Score - 6) / 34 * 30, 30)
                WHEN Type_Name = 'Kidney' AND CPRA_Score IS NOT NULL THEN
                    CPRA_Score * 0.3
                ELSE
                    15
            END
        )
        WHERE Recipient_ID = NEW.Recipient_ID
          AND Status = 'Waiting';
    END IF;
END //
DELIMITER ;

-- before donor delete
DELIMITER //
CREATE TRIGGER before_donor_delete
BEFORE DELETE ON Donor
FOR EACH ROW
BEGIN
    DECLARE active_organ_count INT;
    -- Count how many active organs this donor has
    SELECT COUNT(*) INTO active_organ_count
    FROM Organ
    WHERE Donor_ID = OLD.Donor_ID
      AND Status IN ('Available', 'Allocated');
    -- If donor has active organs, prevent deletion
    IF active_organ_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot delete donor with active organs. Please expire or transplant organs first.';
    END IF;
    -- If no active organs, deletion proceeds
    -- (organs that are Transplanted or Expired are OK)
END //
DELIMITER ;

-- after surgery update
DELIMITER //
CREATE TRIGGER after_surgery_insert
AFTER INSERT ON Surgery
FOR EACH ROW
BEGIN
    -- 1. Update organ status to Transplanted
    UPDATE Organ
    SET Status = 'Transplanted'
    WHERE Organ_ID = NEW.Organ_ID;
    -- 2. Update recipient status to Transplanted
    UPDATE Recipient
    SET Status = 'Transplanted'
    WHERE Recipient_ID = NEW.Recipient_ID;
    -- 3. Remove recipient from all waitlists
    DELETE FROM Recipient_Waitlist
    WHERE Recipient_ID = NEW.Recipient_ID;
    -- 4. Update allocation status to Accepted (if allocation exists)
    UPDATE Organ_Allocation
    SET Status = 'Accepted'
    WHERE Organ_ID = NEW.Organ_ID 
      AND Recipient_ID = NEW.Recipient_ID
      AND Status = 'Pending';
    -- 5. Create initial follow-up appointment (1 week after surgery)
    INSERT INTO Follow_Up_Appointment (
        Surgery_ID,
        Recipient_ID,
        Staff_ID,
        Appointment_Date,
        Appointment_Time,
        Notes,
        Next_Appointment_Date
    )
    VALUES (
        NEW.Surgery_ID,
        NEW.Recipient_ID,
        NEW.Primary_Surgeon_ID,
        DATE_ADD(NEW.Surgery_Date, INTERVAL 1 WEEK),
        '09:00:00',
        'First post-transplant follow-up - check for rejection signs',
        DATE_ADD(NEW.Surgery_Date, INTERVAL 1 MONTH)
    );
END //
DELIMITER ;