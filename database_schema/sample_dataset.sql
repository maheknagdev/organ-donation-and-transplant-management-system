-- =====================================================
-- FRESH SAMPLE DATA - All Organs Procured Today
-- Generated: December 5, 2024
-- =====================================================

USE organ_donation_db;

-- =====================================================
-- 1. ORGAN TYPES
-- =====================================================
INSERT INTO Organ_Type (Type_Name, Typical_Viability_Hours, Cold_Ischemia_Time_Max, Description, Special_Requirements) VALUES
('Heart', 6, 4, 'Cardiac organ for heart transplantation', 'Requires specialized cardiac team'),
('Kidney', 36, 30, 'Renal organ for kidney transplantation', 'Can be preserved longer than other organs'),
('Liver', 24, 12, 'Hepatic organ for liver transplantation', 'Requires immediate surgical team availability'),
('Lung', 8, 6, 'Pulmonary organ for lung transplantation', 'Highly time-sensitive'),
('Pancreas', 12, 12, 'Pancreatic organ for diabetes treatment', 'Often transplanted with kidney');

-- =====================================================
-- 2. MEDICATIONS
-- =====================================================
INSERT INTO Medication (Name, Dosage_Form, Typical_Dosage, Purpose, Side_Effects, Manufacturer) VALUES
('Tacrolimus', 'Capsule', '5mg twice daily', 'Immunosuppressant', 'Tremors, headache', 'Astellas'),
('Cyclosporine', 'Capsule', '100mg twice daily', 'Immunosuppressant', 'Kidney issues', 'Novartis'),
('Prednisone', 'Tablet', '10mg daily', 'Corticosteroid', 'Weight gain', 'Pfizer'),
('Mycophenolate', 'Tablet', '500mg twice daily', 'Immunosuppressant', 'Nausea', 'Roche'),
('Sirolimus', 'Tablet', '2mg daily', 'Immunosuppressant', 'High cholesterol', 'Pfizer');

-- =====================================================
-- 3. USERS
-- =====================================================
INSERT INTO User (Username, Password_Hash, Email, Role, Account_Status, Created_Date, Last_Login) VALUES
('admin', 'admin123', 'admin@hospital.com', 'Administrator', 'Active', '2024-01-01', NOW()),
('dr_smith', 'password123', 'smith@hospital.com', 'Medical_Staff', 'Active', '2024-01-15', NOW()),
('dr_jones', 'password123', 'jones@hospital.com', 'Medical_Staff', 'Active', '2024-02-01', NOW()),
('coordinator_mary', 'password123', 'mary@hospital.com', 'Coordinator', 'Active', '2024-02-15', NOW()),
('patient_alice', 'password123', 'alice@email.com', 'Recipient', 'Active', '2024-06-01', NULL),
('patient_bob', 'password123', 'bob@email.com', 'Recipient', 'Active', '2024-07-01', NULL),
('patient_carol', 'password123', 'carol@email.com', 'Recipient', 'Active', '2024-08-01', NULL);

-- =====================================================
-- 4. HOSPITALS
-- =====================================================
INSERT INTO Hospital (Name, Address, Street_number, Street_name, City, State, Zipcode, Phone, Trauma_Level, OPO_Affiliation) VALUES
('Massachusetts General Hospital', '55 Fruit St', '55', 'Fruit St', 'Boston', 'MA', '02114', '617-726-2000', 1, 'NEDS'),
('Johns Hopkins Hospital', '1800 Orleans St', '1800', 'Orleans St', 'Baltimore', 'MD', '21287', '410-955-5000', 1, 'LLF'),
('Mayo Clinic', '200 First St SW', '200', 'First St SW', 'Rochester', 'MN', '55905', '507-284-2511', 1, 'LifeSource'),
('Cleveland Clinic', '9500 Euclid Ave', '9500', 'Euclid Ave', 'Cleveland', 'OH', '44195', '216-444-2200', 1, 'Lifebanc'),
('UCLA Medical Center', '757 Westwood Plaza', '757', 'Westwood Plaza', 'Los Angeles', 'CA', '90095', '310-825-9111', 1, 'OneLegacy');

-- =====================================================
-- 5. HOSPITAL CAPABILITIES
-- =====================================================
INSERT INTO Hospital_Capabilities (Hospital_ID, Type_Name) VALUES
(1, 'Heart'), (1, 'Kidney'), (1, 'Liver'), (1, 'Lung'), (1, 'Pancreas'),
(2, 'Heart'), (2, 'Kidney'), (2, 'Liver'), (2, 'Lung'), (2, 'Pancreas'),
(3, 'Heart'), (3, 'Kidney'), (3, 'Liver'), (3, 'Lung'), (3, 'Pancreas'),
(4, 'Heart'), (4, 'Kidney'), (4, 'Liver'),
(5, 'Heart'), (5, 'Kidney'), (5, 'Liver'), (5, 'Pancreas');

-- =====================================================
-- 6. MEDICAL STAFF
-- =====================================================
INSERT INTO Medical_Staff (Hospital_ID, Name, Specialization, License_Number, Certification_Date, Certification_Level, Phone, Email, User_ID) VALUES
(1, 'Dr. Sarah Smith', 'Transplant_Surgeon', 'MD-123456', '2015-06-15', 'Board Certified', '617-726-3001', 'smith@mgh.edu', 2),
(2, 'Dr. Michael Jones', 'Transplant_Surgeon', 'MD-234567', '2012-08-20', 'Board Certified', '410-955-6001', 'jones@jhmi.edu', 3),
(1, 'Mary Johnson', 'Coordinator', 'RN-345678', '2018-03-10', 'Certified', '617-726-3002', 'mary@mgh.edu', 4),
(3, 'Dr. Emily Williams', 'Transplant_Surgeon', 'MD-456789', '2014-11-05', 'Board Certified', '507-284-4001', 'williams@mayo.edu', NULL),
(4, 'Dr. Robert Davis', 'Nephrologist', 'MD-567890', '2016-09-12', 'Board Certified', '216-444-5001', 'davis@ccf.org', NULL),
(5, 'Dr. Jennifer Garcia', 'Transplant_Surgeon', 'MD-789012', '2013-07-18', 'Board Certified', '310-825-7001', 'garcia@ucla.edu', NULL);

-- =====================================================
-- 7. DONORS (All with clearance, procured TODAY)
-- =====================================================
INSERT INTO Donor (Name, Date_of_Birth, Blood_Type, Gender, Contact_Info, Donor_Type, Medical_History, Cause_of_Death, Registration_Date, Medical_Clearance_Date, Status) VALUES
('John Doe', '1985-03-15', 'O+', 'M', 'Boston MA', 'Deceased', 'None', 'MVA', CURDATE(), CURDATE(), 'Deceased'),
('Jane Smith', '1978-07-22', 'A+', 'F', 'Baltimore MD', 'Deceased', 'HTN', 'Stroke', CURDATE(), CURDATE(), 'Deceased'),
('Robert Johnson', '1990-11-08', 'B+', 'M', 'Rochester MN', 'Living', 'Healthy', NULL, CURDATE(), CURDATE(), 'Active'),
('Maria Garcia', '1982-05-30', 'AB+', 'F', 'Cleveland OH', 'Deceased', 'DM', 'Aneurysm', CURDATE(), CURDATE(), 'Deceased'),
('Michael Brown', '1995-09-12', 'O-', 'M', 'Los Angeles CA', 'Deceased', 'None', 'Trauma', CURDATE(), CURDATE(), 'Deceased'),
('Emily Wilson', '1988-01-25', 'A-', 'F', 'San Francisco CA', 'Living', 'Healthy', NULL, CURDATE(), CURDATE(), 'Active'),
('David Martinez', '1975-12-18', 'B-', 'M', 'New York NY', 'Deceased', 'Former smoker', 'Cardiac arrest', CURDATE(), CURDATE(), 'Deceased');

-- =====================================================
-- 8. RECIPIENTS (20 recipients - mix of urgencies)
-- =====================================================
INSERT INTO Recipient (Name, Date_of_Birth, Blood_Type, Gender, Contact_Info, Medical_History, Primary_Diagnosis, Medical_Urgency_Level, Registration_Date, Status, Insurance_Info, User_ID) VALUES
-- Level 5 (Critical)
('Alice Thompson', '1970-03-20', 'A+', 'F', 'Boston MA', 'Heart failure', 'Dilated cardiomyopathy', 5, '2024-06-01', 'Waiting', 'Blue Cross MA', 5),
('Bob Richardson', '1965-08-15', 'O+', 'M', 'Baltimore MD', 'Liver cirrhosis', 'Hepatitis C', 5, '2024-07-15', 'Waiting', 'Medicare', 6),
('Carol Evans', '1968-11-22', 'B+', 'F', 'Rochester MN', 'Kidney failure', 'Diabetic nephropathy', 5, '2024-08-01', 'Waiting', 'UHC', 7),

-- Level 4 (High)
('David Collins', '1972-05-10', 'AB+', 'M', 'Cleveland OH', 'Lung disease', 'Pulmonary fibrosis', 4, '2024-07-20', 'Waiting', 'Aetna', NULL),
('Emma Stewart', '1975-09-05', 'A-', 'F', 'Los Angeles CA', 'Kidney disease', 'PKD', 4, '2024-06-15', 'Waiting', 'Kaiser', NULL),
('Frank Morris', '1969-12-28', 'O-', 'M', 'San Francisco CA', 'Heart failure', 'Ischemic cardiomyopathy', 4, '2024-08-10', 'Waiting', 'Blue Shield', NULL),
('Grace Rogers', '1974-04-12', 'B-', 'F', 'New York NY', 'Liver failure', 'PBC', 4, '2024-09-01', 'Waiting', 'Cigna', NULL),

-- Level 3 (Medium)
('Henry Reed', '1971-07-25', 'AB-', 'M', 'Chicago IL', 'Kidney failure', 'Hypertensive nephropathy', 3, '2024-07-05', 'Waiting', 'Humana', NULL),
('Isabel Cook', '1976-01-18', 'A+', 'F', 'Stanford CA', 'Kidney disease', 'CKD Stage 4', 3, '2024-05-01', 'Waiting', 'Anthem', NULL),
('Jack Morgan', '1973-10-30', 'O+', 'M', 'Boston MA', 'Liver disease', 'Cirrhosis', 3, '2024-06-20', 'Waiting', 'Harvard Pilgrim', NULL),
('Karen Bell', '1977-06-14', 'B+', 'F', 'Baltimore MD', 'Kidney failure', 'IgA nephropathy', 3, '2024-08-15', 'Waiting', 'CareFirst', NULL),
('Larry Murphy', '1970-02-08', 'AB+', 'M', 'Rochester MN', 'Heart disease', 'Restrictive CM', 3, '2024-09-10', 'Waiting', 'BCMN', NULL),

-- Level 2 (Low)
('Monica Bailey', '1978-11-03', 'A-', 'F', 'Cleveland OH', 'Kidney disease', 'Lupus nephritis', 2, '2024-07-25', 'Waiting', 'Medical Mutual', NULL),
('Nathan Rivera', '1975-09-16', 'O-', 'M', 'Los Angeles CA', 'Liver disease', 'PSC', 2, '2024-08-20', 'Waiting', 'Health Net', NULL),
('Olivia Cooper', '1979-04-29', 'B-', 'F', 'San Francisco CA', 'Lung disease', 'CF', 2, '2024-09-05', 'Waiting', 'Blue Shield', NULL),

-- Level 1 (Stable)
('Paul Richardson', '1980-12-11', 'AB-', 'M', 'New York NY', 'Kidney disease', 'CKD Stage 3', 1, '2024-05-15', 'Waiting', 'Empire', NULL),
('Quinn Foster', '1983-07-06', 'A+', 'F', 'Chicago IL', 'Liver disease', 'Autoimmune hepatitis', 1, '2024-06-10', 'Waiting', 'BCIL', NULL),
('Ryan Gray', '1982-03-21', 'O+', 'M', 'Stanford CA', 'Kidney disease', 'Reflux nephropathy', 1, '2024-07-01', 'Waiting', 'Stanford Health', NULL),
('Sophia Hughes', '1981-08-17', 'B+', 'F', 'Boston MA', 'Kidney disease', 'Glomerulonephritis', 1, '2024-08-05', 'Waiting', 'Tufts', NULL),
('Tyler Price', '1984-05-02', 'AB+', 'M', 'Baltimore MD', 'Liver disease', 'NAFLD', 1, '2024-09-20', 'Waiting', 'Hopkins Health', NULL);

-- =====================================================
-- 9. RECIPIENT WAITLIST - MUST ADD TO SEE IN MATCHES
-- =====================================================
INSERT INTO Recipient_Waitlist (Recipient_ID, Type_Name, Priority_Score, Wait_List_Date, Status, MELD_Score, CPRA_Score) VALUES
-- Heart waitlist
(1, 'Heart', 85.00, '2024-06-01', 'Waiting', NULL, NULL),
(6, 'Heart', 72.00, '2024-08-10', 'Waiting', NULL, NULL),
(12, 'Heart', 65.00, '2024-09-10', 'Waiting', NULL, NULL),

-- Liver waitlist
(2, 'Liver', 90.00, '2024-07-15', 'Waiting', 35.50, NULL),
(7, 'Liver', 75.00, '2024-09-01', 'Waiting', 28.00, NULL),
(10, 'Liver', 68.00, '2024-06-20', 'Waiting', 22.00, NULL),
(17, 'Liver', 42.00, '2024-06-10', 'Waiting', 18.00, NULL),

-- Kidney waitlist (MOST RECIPIENTS HERE - O+ organ will match many!)
(3, 'Kidney', 88.00, '2024-08-01', 'Waiting', NULL, 85.50),
(5, 'Kidney', 78.00, '2024-06-15', 'Waiting', NULL, 62.00),
(8, 'Kidney', 72.00, '2024-07-05', 'Waiting', NULL, 55.00),
(9, 'Kidney', 65.00, '2024-05-01', 'Waiting', NULL, 38.00),
(11, 'Kidney', 60.00, '2024-08-15', 'Waiting', NULL, 42.00),
(13, 'Kidney', 55.00, '2024-07-25', 'Waiting', NULL, 28.00),
(16, 'Kidney', 50.00, '2024-05-15', 'Waiting', NULL, 22.00),
(18, 'Kidney', 45.00, '2024-07-01', 'Waiting', NULL, 25.00),
(19, 'Kidney', 42.00, '2024-08-05', 'Waiting', NULL, 20.00),

-- Lung waitlist
(4, 'Lung', 72.00, '2024-07-20', 'Waiting', NULL, NULL),
(15, 'Lung', 55.00, '2024-09-05', 'Waiting', NULL, NULL),

-- Pancreas waitlist
(3, 'Pancreas', 60.00, '2024-08-01', 'Waiting', NULL, NULL);

-- =====================================================
-- 10. ORGANS - ALL PROCURED TODAY (FRESH, NOT EXPIRED!)
-- =====================================================
INSERT INTO Organ (Type_Name, Donor_ID, HLA_Type, Procurement_Date, Procurement_Time, Size_Weight, Status) VALUES
-- Procured THIS MORNING (8-10 hours ago) - ALL AVAILABLE
('Kidney', 1, 'A1-B8-DR3', CURDATE(), '06:00:00', 150.50, 'Available'),  -- O+ kidney
('Liver', 2, 'A2-B7-DR4', CURDATE(), '07:00:00', 1450.00, 'Available'),   -- A+ liver
('Heart', 5, 'A3-B44-DR7', CURDATE(), '08:00:00', 320.00, 'Available'),    -- O- heart
('Kidney', 3, 'A1-B8-DR3', CURDATE(), '09:00:00', 145.00, 'Available'),   -- B+ kidney
('Lung', 1, 'A2-B35-DR1', CURDATE(), '10:00:00', 850.00, 'Available'),    -- O+ lung

-- Procured RECENTLY (2-4 hours ago) - VERY FRESH
('Kidney', 6, 'A3-B7-DR4', CURDATE(), '12:00:00', 155.75, 'Available'),   -- A- kidney
('Liver', 4, 'A1-B44-DR3', CURDATE(), '11:00:00', 1380.00, 'Available'),  -- AB+ liver
('Pancreas', 2, 'A2-B7-DR1', CURDATE(), '13:00:00', 95.00, 'Available'),  -- A+ pancreas
('Kidney', 7, 'A1-B35-DR3', CURDATE(), '14:00:00', 148.00, 'Available'),  -- B- kidney
('Heart', 1, 'A2-B8-DR7', CURDATE(), '10:30:00', 305.50, 'Available');    -- O+ heart

-- =====================================================
-- VERIFICATION
-- =====================================================
SELECT '✓ Fresh data loaded successfully!' as Status;
SELECT '✓ All organs procured TODAY - none expired!' as Note;

-- Show counts
SELECT 'Organ Types' as Item, COUNT(*) as Count FROM Organ_Type
UNION ALL SELECT 'Medications', COUNT(*) FROM Medication
UNION ALL SELECT 'Users', COUNT(*) FROM User
UNION ALL SELECT 'Hospitals', COUNT(*) FROM Hospital
UNION ALL SELECT 'Medical Staff', COUNT(*) FROM Medical_Staff
UNION ALL SELECT 'Donors', COUNT(*) FROM Donor
UNION ALL SELECT 'Recipients', COUNT(*) FROM Recipient
UNION ALL SELECT 'Waitlist Entries', COUNT(*) FROM Recipient_Waitlist
UNION ALL SELECT 'Organs (ALL FRESH)', COUNT(*) FROM Organ;

-- Test organ 1 matches (should return ~9 kidney recipients!)
SELECT '🧪 Testing MatchOrganToRecipients for Organ #1 (O+ Kidney)' as Test;
CALL MatchOrganToRecipients(1);