INSERT INTO Recipient (Name, Date_of_Birth, Blood_Type, Gender, Medical_Urgency_Level, Registration_Date, Status)
VALUES ('Test Patient', '1980-01-01', 'A+', 'M', 3, '2024-11-01', 'Waiting');

INSERT INTO Recipient_Waitlist (Recipient_ID, Type_Name, Wait_List_Date, Status, Priority_Score)
VALUES (1, 'Kidney', '2024-10-01', 'Waiting', 50.00);

SELECT * FROM Organ_Type;
SELECT * FROM donor;

INSERT INTO Organ_Type (Type_Name, Typical_Viability_Hours, Cold_Ischemia_Time_Max, Description)
VALUES
('Heart', 6, 4, 'Cardiac organ'),
('Kidney', 36, 30, 'Renal organ'),
('Liver', 24, 12, 'Hepatic organ'),
('Lung', 8, 6, 'Pulmonary organ'),
('Pancreas', 12, 12, 'Pancreatic organ');

SELECT CalculateWaitTimeDays(1, 'Kidney');  


INSERT INTO Donor (Name, Date_of_Birth, Blood_Type, Gender, Donor_Type, Registration_Date, Status)
VALUES ('Test Donor', '1975-03-10', 'O+', 'M', 'Deceased', '2024-11-23', 'Deceased');

-- Insert an organ procured recently (2 hours ago)
INSERT INTO Organ (Type_Name, Donor_ID, Procurement_Date, Procurement_Time, Status)
VALUES (
    'Kidney', 
    1, 
    CURDATE(),         -- Today's date
    SUBTIME(CURTIME(), '02:00:00'),  -- 2 hours ago
    'Available'
);

-- Insert another organ procured yesterday (should be expired for heart)
INSERT INTO Organ (Type_Name, Donor_ID, Procurement_Date, Procurement_Time, Status)
VALUES (
    'Heart',
    (SELECT Donor_ID FROM Donor WHERE Name = 'Test Donor'),
    DATE_SUB(CURDATE(), INTERVAL 1 DAY),  
    '10:00:00',
    'Expired'
);

-- Test with kidney procured 2 hours ago
-- Kidney viability = 36 hours, elapsed = 2 hours, remaining = 34 hours
SELECT GetRemainingViableHours(1);  -- Replace 1 with your actual Organ_ID
-- Should return approximately 34.00

-- Test with heart procured yesterday
-- Heart viability = 6 hours, elapsed = ~38 hours, remaining = -32 hours (expired!)
SELECT GetRemainingViableHours(2);  -- Replace 2 with your actual Organ_ID
-- Should return negative number (expired)

-- Test with non-existent organ
SELECT GetRemainingViableHours(999);
-- Should return -999 (error indicator)


-- Test with compatible donor-recipient pair
-- Use actual Donor_ID and Recipient_ID from your database
SELECT CalculateCompatibilityScore(1, 1, 'Kidney');
-- Should return a score between 0-100

-- Test with exact blood type match (should score higher)
-- First, check what blood types you have:
SELECT d.Donor_ID, d.Blood_Type as Donor_Blood, d.Date_of_Birth as Donor_DOB
FROM Donor d;

SELECT r.Recipient_ID, r.Blood_Type as Recipient_Blood, r.Date_of_Birth as Recipient_DOB  
FROM Recipient r;

-- Find a pair with same blood type and test
SELECT CalculateCompatibilityScore(1, 1, 'Kidney');

-- Test with non-existent donor
SELECT CalculateCompatibilityScore(999, 1, 'Kidney');
-- Should return 0

-- Test with non-existent recipient
SELECT CalculateCompatibilityScore(1, 999, 'Kidney');
-- Should return 0

-- Test with a recent organ (should be Normal or Urgent)
CALL CheckOrganViability(1);
-- Should show: Organ_ID, Remaining_Hours, Urgency_Level

-- Test with an old/expired organ
CALL CheckOrganViability(2);
-- Should show: Expired if hours < 0

-- Test with non-existent organ
CALL CheckOrganViability(999);
-- Should show: -999 hours, Expired

-- Check current waitlist
SELECT * FROM Recipient_Waitlist;

-- Test the procedure (use actual Recipient_ID and Type_Name from your waitlist)
CALL CalculatePriorityScore(1, 'Kidney');

SELECT Recipient_ID, Type_Name, Priority_Score, Wait_List_Date
FROM Recipient_Waitlist
WHERE Recipient_ID = 1;

-- Test with high urgency recipient (if you have one)
-- First update urgency to 5
UPDATE Recipient SET Medical_Urgency_Level = 5 WHERE Recipient_ID = 1;

-- Recalculate priority
CALL CalculatePriorityScore(1, 'Kidney');
-- Should see higher score now (urgency_points = 40)

-- Check updated score
SELECT Priority_Score FROM Recipient_Waitlist WHERE Recipient_ID = 1;

-- Test successful allocation (use actual Organ_ID and Recipient_ID)
CALL AllocateOrgan(1, 1);

-- Check available organs
SELECT Organ_ID, Type_Name, Status FROM Organ WHERE Status = 'Available';

-- Check waitlist for that organ type (e.g., Kidney)
SELECT r.Recipient_ID, r.Name, r.Blood_Type, wl.Priority_Score
FROM Recipient r
JOIN Recipient_Waitlist wl ON r.Recipient_ID = wl.Recipient_ID
WHERE wl.Type_Name = 'Kidney' AND wl.Status = 'Waiting';

-- If you need more test recipients, add them:
INSERT INTO Recipient (Name, Date_of_Birth, Blood_Type, Gender, Medical_Urgency_Level, Registration_Date, Status)
VALUES 
('Patient A', '1970-05-10', 'A+', 'F', 5, '2024-09-01', 'Waiting'),
('Patient B', '1985-03-15', 'O+', 'M', 3, '2024-08-01', 'Waiting'),
('Patient C', '1965-11-20', 'A+', 'M', 4, '2024-07-01', 'Waiting');

-- Add them to waitlist
INSERT INTO Recipient_Waitlist (Recipient_ID, Type_Name, Wait_List_Date, Status, Priority_Score)
VALUES 
(4 - 2, 'Kidney', '2024-09-01', 'Waiting', 0),
(4 - 1, 'Kidney', '2024-08-01', 'Waiting', 0),
(4, 'Kidney', '2024-07-01', 'Waiting', 0);

CALL MatchOrganToRecipients(1);
-- Test with a Heart (if you have one available)
CALL MatchOrganToRecipients(2);

-- Test with non-existent organ
CALL MatchOrganToRecipients(999);
-- Should return: "Error: Organ not found"
