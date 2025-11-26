-- Check organ Viability
DELIMITER //
CREATE PROCEDURE CheckOrganViability(IN p_organ_id INT)
BEGIN
    DECLARE remaining_hours DECIMAL(10,2);
    DECLARE urgency_level VARCHAR(20);
    -- Call the function to get remaining hours
    SET remaining_hours = GetRemainingViableHours(p_organ_id);
    -- Determine urgency level based on remaining hours
    IF remaining_hours < 0 THEN
        SET urgency_level = 'Expired';
    ELSEIF remaining_hours < 2 THEN
        SET urgency_level = 'Critical';
    ELSEIF remaining_hours <= 6 THEN
        SET urgency_level = 'Urgent';
    ELSE
        SET urgency_level = 'Normal';
    END IF;
    -- Return results
    SELECT 
        p_organ_id as Organ_ID,
        remaining_hours as Remaining_Hours,
        urgency_level as Urgency_Level;
END //
DELIMITER ;

-- Calculate priority score
DELIMITER //
CREATE PROCEDURE CalculatePriorityScore(IN p_recipient_id INT,IN p_organ_type VARCHAR(30))
BEGIN
    DECLARE urgency_level INT;
    DECLARE wait_days INT;
    DECLARE meld_score DECIMAL(5,2);
    DECLARE cpra_score DECIMAL(5,2);
    DECLARE urgency_points DECIMAL(5,2) DEFAULT 0;
    DECLARE wait_points DECIMAL(5,2) DEFAULT 0;
    DECLARE organ_specific_points DECIMAL(5,2) DEFAULT 0;
    DECLARE new_priority_score DECIMAL(5,2);
    -- Get recipient's medical urgency level
    SELECT Medical_Urgency_Level INTO urgency_level
    FROM Recipient
    WHERE Recipient_ID = p_recipient_id;
    -- If recipient not found, exit
    IF urgency_level IS NULL THEN
        SELECT 'Error: Recipient not found' as Message;
    END IF;
    -- Calculate wait time in days using our function
    SET wait_days = CalculateWaitTimeDays(p_recipient_id, p_organ_type);
    -- Get organ-specific scores from waitlist
    SELECT MELD_Score, CPRA_Score INTO meld_score, cpra_score
    FROM Recipient_Waitlist
    WHERE Recipient_ID = p_recipient_id AND Type_Name = p_organ_type;
    -- Calculate urgency points (40% of total, max 40 points)
    -- Urgency level 1-5, multiply by 8 to get 8-40 points
    SET urgency_points = urgency_level * 8;
    -- Calculate wait time points (30% of total, max 30 points)
    -- 1 point per 30 days waiting, capped at 30 points
    SET wait_points = LEAST(wait_days / 30, 30);
    -- Calculate organ-specific points (30% of total, max 30 points)
    IF p_organ_type = 'Liver' AND meld_score IS NOT NULL THEN
        -- MELD score ranges 6-40, normalize to 0-30 points
        SET organ_specific_points = LEAST((meld_score - 6) / 34 * 30, 30);
    ELSEIF p_organ_type = 'Kidney' AND cpra_score IS NOT NULL THEN
        -- CPRA is 0-100%, convert to 0-30 points
        SET organ_specific_points = cpra_score * 0.3;
    ELSE
        -- No organ-specific score, give base 15 points
        SET organ_specific_points = 15;
    END IF;
    -- Calculate total priority score (max 100)
    SET new_priority_score = urgency_points + wait_points + organ_specific_points;
    -- UPDATE the waitlist with new priority score
    UPDATE Recipient_Waitlist
    SET Priority_Score = new_priority_score
    WHERE Recipient_ID = p_recipient_id AND Type_Name = p_organ_type;
    -- Return the calculated score
    SELECT 
        p_recipient_id as Recipient_ID,
        p_organ_type as Organ_Type,
        urgency_level as Urgency_Level,
        wait_days as Days_Waiting,
        urgency_points as Urgency_Points,
        wait_points as Wait_Points,
        organ_specific_points as Organ_Specific_Points,
        new_priority_score as New_Priority_Score;
END //
DELIMITER ;

-- Allocate organ
DELIMITER //
CREATE PROCEDURE AllocateOrgan(IN p_organ_id INT, IN p_recipient_id INT)
BEGIN
    DECLARE organ_status VARCHAR(50);
    DECLARE recipient_status VARCHAR(50);
    DECLARE remaining_hours DECIMAL(10,2);
    DECLARE deadline DATETIME;
    DECLARE new_allocation_id INT;
    DECLARE organ_type_name VARCHAR(30);
    DECLARE match_score DECIMAL(5,2);
    -- Start transaction for data consistency
    START TRANSACTION;
    -- Check if organ exists and is available
    SELECT Status, Type_Name INTO organ_status, organ_type_name
    FROM Organ
    WHERE Organ_ID = p_organ_id;
    IF organ_status IS NULL THEN
        ROLLBACK;
        SELECT 'Error: Organ not found' as Message;
    ELSEIF organ_status != 'Available' THEN
        ROLLBACK;
        SELECT CONCAT('Error: Organ is not available. Current status: ', organ_status) as Message;
    ELSE
        -- Check if recipient exists and is waiting
        SELECT Status INTO recipient_status
        FROM Recipient
        WHERE Recipient_ID = p_recipient_id;
        IF recipient_status IS NULL THEN
            ROLLBACK;
            SELECT 'Error: Recipient not found' as Message;
        ELSEIF recipient_status != 'Waiting' THEN
            ROLLBACK;
            SELECT CONCAT('Error: Recipient is not waiting. Current status: ', recipient_status) as Message;
        ELSE
            -- Calculate remaining viable hours
            SET remaining_hours = GetRemainingViableHours(p_organ_id);
            
            -- Check if organ still viable
            IF remaining_hours <= 0 THEN
                ROLLBACK;
                SELECT 'Error: Organ has expired' as Message;
            ELSE
                -- Calculate response deadline (50% of remaining viable time)
                SET deadline = DATE_ADD(NOW(), INTERVAL (remaining_hours * 0.5) HOUR);
                
                -- Calculate compatibility score
                SET match_score = CalculateCompatibilityScore(
                    (SELECT Donor_ID FROM Organ WHERE Organ_ID = p_organ_id),
                    p_recipient_id,
                    organ_type_name
                );
                -- Create allocation record
                INSERT INTO Organ_Allocation (
                    Organ_ID,
                    Recipient_ID,
                    Allocation_Date,
                    Match_Score,
                    Status,
                    Response_Deadline
                )
                VALUES (
                    p_organ_id,
                    p_recipient_id,
                    NOW(),
                    match_score,
                    'Pending',
                    deadline
                );
                -- Get the allocation ID that was just created
                SET new_allocation_id = LAST_INSERT_ID();
                -- Update organ status to Allocated
                UPDATE Organ
                SET Status = 'Allocated'
                WHERE Organ_ID = p_organ_id;
                -- Commit the transaction
                COMMIT;
                -- Return success message with details
                SELECT 
                    'Success: Organ allocated' as Message,
                    new_allocation_id as Allocation_ID,
                    p_organ_id as Organ_ID,
                    p_recipient_id as Recipient_ID,
                    match_score as Match_Score,
                    deadline as Response_Deadline,
                    remaining_hours as Hours_Remaining;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

-- Match organ to recipient
DELIMITER //
CREATE PROCEDURE MatchOrganToRecipients(IN p_organ_id INT)
BEGIN
    DECLARE organ_type_name VARCHAR(30);
    DECLARE organ_donor_id INT;
    DECLARE organ_blood_type VARCHAR(3);
    DECLARE organ_procurement_datetime DATETIME;
    DECLARE organ_zip VARCHAR(10);
    -- Get organ details
    SELECT 
        o.Type_Name,
        o.Donor_ID,
        d.Blood_Type,
        CONCAT(o.Procurement_Date, ' ', o.Procurement_Time),
        h.Zipcode
    INTO 
        organ_type_name,
        organ_donor_id,
        organ_blood_type,
        organ_procurement_datetime,
        organ_zip
    FROM Organ o
    JOIN Donor d ON o.Donor_ID = d.Donor_ID
    LEFT JOIN Hospital h ON d.Donor_ID = d.Donor_ID
    WHERE o.Organ_ID = p_organ_id;
    -- If organ not found, return error
    IF organ_type_name IS NULL THEN
        SELECT 'Error: Organ not found' as Message;
    ELSE
        -- Find and rank compatible recipients
        SELECT 
            r.Recipient_ID,
            r.Name as Recipient_Name,
            r.Blood_Type as Recipient_Blood,
            r.Medical_Urgency_Level,
            wl.Priority_Score,
            wl.Wait_List_Date,
            CalculateWaitTimeDays(r.Recipient_ID, organ_type_name) as Days_Waiting,
            -- Calculate individual score components
            CASE 
                WHEN CheckBloodTypeCompatibility(organ_blood_type, r.Blood_Type) = FALSE THEN 0
                WHEN organ_blood_type = r.Blood_Type THEN 30.00
                ELSE 20.00
            END as Blood_Type_Score,
            -- HLA score (simplified - would need actual HLA matching logic)
            15.00 as HLA_Score,
            -- Wait time score (20 points max, 1 point per 30 days)
            LEAST(CalculateWaitTimeDays(r.Recipient_ID, organ_type_name) / 30, 20) as Wait_Time_Score,
            -- Geographic score (15 points - simplified, assume same state = 15, different = 7)
            15.00 as Geographic_Score,
            -- Urgency score (10 points max, based on urgency level 1-5)
            r.Medical_Urgency_Level * 2 as Urgency_Score,
            -- Total compatibility score
            CASE 
                WHEN CheckBloodTypeCompatibility(organ_blood_type, r.Blood_Type) = FALSE THEN 0
                ELSE (
                    -- Blood type (30%)
                    CASE 
                        WHEN organ_blood_type = r.Blood_Type THEN 30.00
                        ELSE 20.00
                    END +
                    -- HLA (25%)
                    15.00 +
                    -- Wait time (20%)
                    LEAST(CalculateWaitTimeDays(r.Recipient_ID, organ_type_name) / 30, 20) +
                    -- Geographic (15%)
                    15.00 +
                    -- Urgency (10%)
                    r.Medical_Urgency_Level * 2
                )
            END as Total_Match_Score
        FROM Recipient r
        JOIN Recipient_Waitlist wl ON r.Recipient_ID = wl.Recipient_ID
        WHERE wl.Type_Name = organ_type_name
          AND wl.Status = 'Waiting'
          AND r.Status = 'Waiting'
          AND CheckBloodTypeCompatibility(organ_blood_type, r.Blood_Type) = TRUE
        -- Check for positive crossmatch (incompatible)
          AND NOT EXISTS (
              SELECT 1 FROM Compatibility_Test ct
              WHERE ct.Donor_ID = organ_donor_id
                AND ct.Recipient_ID = r.Recipient_ID
                AND ct.Test_Result = 'Incompatible'
          )
        -- Order by total score (best matches first)
        ORDER BY Total_Match_Score DESC, Days_Waiting DESC
        LIMIT 10;
    END IF;
END //
DELIMITER ;