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
