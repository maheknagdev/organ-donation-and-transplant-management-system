-- Check blood compatibility function
DELIMITER //
CREATE FUNCTION CheckBloodTypeCompatibility(
    donor_blood VARCHAR(3),
    recipient_blood VARCHAR(3)
) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- O- is universal donor
    IF donor_blood = 'O-' THEN 
        RETURN TRUE;
    END IF;
    -- AB+ is universal recipient
    IF recipient_blood = 'AB+' THEN 
        RETURN TRUE;
    END IF;
    -- Exact match
    IF donor_blood = recipient_blood THEN 
        RETURN TRUE;
    END IF;
    -- O+ can donate to O+, A+, B+, AB+
    IF donor_blood = 'O+' AND recipient_blood IN ('O+', 'A+', 'B+', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- A- can donate to A-, A+, AB-, AB+
    IF donor_blood = 'A-' AND recipient_blood IN ('A-', 'A+', 'AB-', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- A+ can donate to A+, AB+
    IF donor_blood = 'A+' AND recipient_blood IN ('A+', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- B- can donate to B-, B+, AB-, AB+
    IF donor_blood = 'B-' AND recipient_blood IN ('B-', 'B+', 'AB-', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- B+ can donate to B+, AB+
    IF donor_blood = 'B+' AND recipient_blood IN ('B+', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- AB- can donate to AB-, AB+
    IF donor_blood = 'AB-' AND recipient_blood IN ('AB-', 'AB+') THEN 
        RETURN TRUE;
    END IF;
    -- If none of the above, incompatible
    RETURN FALSE;
END //
DELIMITER ;

-- Calculate wait time function
DELIMITER //
CREATE FUNCTION CalculateWaitTimeDays(
    p_recipient_id INT,
    p_organ_type VARCHAR(30)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE wait_date DATE;
    DECLARE days_waiting INT;
    -- Get the wait list date for this recipient and organ type
    SELECT Wait_List_Date INTO wait_date
    FROM Recipient_Waitlist
    WHERE Recipient_ID = p_recipient_id 
      AND Type_Name = p_organ_type
    LIMIT 1;
    -- If no waitlist entry found, return 0
    IF wait_date IS NULL THEN
        RETURN 0;
    END IF;
    -- Calculate days between wait_date and current date
    SET days_waiting = DATEDIFF(CURDATE(), wait_date);
    RETURN days_waiting;
END //
DELIMITER ;

-- Get viable hours function
DELIMITER //
CREATE FUNCTION GetRemainingViableHours(
    p_organ_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE procurement_datetime DATETIME;
    DECLARE typical_hours INT;
    DECLARE elapsed_hours DECIMAL(10,2);
    DECLARE remaining_hours DECIMAL(10,2);
    -- Get organ procurement datetime and type
    SELECT 
        CONCAT(Procurement_Date, ' ', Procurement_Time),
        ot.Typical_Viability_Hours
    INTO 
        procurement_datetime,
        typical_hours
    FROM Organ o
    JOIN Organ_Type ot ON o.Type_Name = ot.Type_Name
    WHERE o.Organ_ID = p_organ_id;
    -- If organ not found, return -999 as error indicator
    IF procurement_datetime IS NULL THEN
        RETURN -999;
    END IF;
    -- Calculate hours elapsed since procurement
    SET elapsed_hours = TIMESTAMPDIFF(HOUR, procurement_datetime, NOW());
    -- Calculate remaining hours
    SET remaining_hours = typical_hours - elapsed_hours;
    RETURN remaining_hours;
END //
DELIMITER ;

-- Calculate compatibility score
DELIMITER //
CREATE FUNCTION CalculateCompatibilityScore(
    p_donor_id INT,
    p_recipient_id INT,
    p_organ_type VARCHAR(30)
)
RETURNS DECIMAL(5,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE donor_blood VARCHAR(3);
    DECLARE recipient_blood VARCHAR(3);
    DECLARE donor_age INT;
    DECLARE recipient_age INT;
    DECLARE donor_hla VARCHAR(50);
    DECLARE recipient_hla VARCHAR(50);
    DECLARE blood_score DECIMAL(5,2) DEFAULT 0;
    DECLARE hla_score DECIMAL(5,2) DEFAULT 0;
    DECLARE age_score DECIMAL(5,2) DEFAULT 0;
    DECLARE size_score DECIMAL(5,2) DEFAULT 15.00;
    DECLARE total_score DECIMAL(5,2) DEFAULT 0;
    -- Get donor information
    SELECT Blood_Type, TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE())
    INTO donor_blood, donor_age
    FROM Donor
    WHERE Donor_ID = p_donor_id;
    -- Get recipient information  
    SELECT Blood_Type, TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE())
    INTO recipient_blood, recipient_age
    FROM Recipient
    WHERE Recipient_ID = p_recipient_id;
    -- If either donor or recipient not found, return 0
    IF donor_blood IS NULL OR recipient_blood IS NULL THEN
        RETURN 0;
    END IF;
    -- Calculate Blood Type Score (30 points max)
    IF CheckBloodTypeCompatibility(donor_blood, recipient_blood) = FALSE THEN
        -- Incompatible blood type = 0 total score
        RETURN 0;
    END IF;
    -- Exact blood type match
    IF donor_blood = recipient_blood THEN
        SET blood_score = 30.00;
    -- Compatible but not exact
    ELSE
        SET blood_score = 20.00;
    END IF;
    -- Calculate HLA Score (25 points max)
    -- Simplified: Get HLA types from organ (donor HLA) and check similarity
    SELECT HLA_Type INTO donor_hla
    FROM Organ
    WHERE Donor_ID = p_donor_id AND Type_Name = p_organ_type
    LIMIT 1;
    -- Simplified HLA matching (in real system, this would be more complex)
    -- For now, assume partial match gives 15 points, no data gives 10 points
    IF donor_hla IS NOT NULL THEN
        SET hla_score = 15.00;
    ELSE
        SET hla_score = 10.00;
    END IF;
    -- Calculate Age Compatibility Score (20 points max)
    -- Closer ages are better
    IF ABS(donor_age - recipient_age) <= 5 THEN
        SET age_score = 20.00;
    ELSEIF ABS(donor_age - recipient_age) <= 10 THEN
        SET age_score = 15.00;
    ELSEIF ABS(donor_age - recipient_age) <= 20 THEN
        SET age_score = 10.00;
    ELSE
        SET age_score = 5.00;
    END IF;
    -- Size matching score (15 points) - simplified, assume good match
    SET size_score = 15.00;
    -- Calculate total score
    SET total_score = blood_score + hla_score + age_score + size_score;
    RETURN total_score;
END //
DELIMITER ;