-- =====================================================
-- ORGAN DONATION SYSTEM - COMPLETE SAMPLE DATA
-- This creates realistic data demonstrating all features
-- =====================================================

USE organ_donation_db;

-- =====================================================
-- 1. ORGAN TYPES (Reference Data)
-- =====================================================
INSERT INTO Organ_Type (Type_Name, Typical_Viability_Hours, Cold_Ischemia_Time_Max, Description, Special_Requirements) VALUES
('Heart', 6, 4, 'Cardiac organ for heart transplantation', 'Requires specialized cardiac team'),
('Kidney', 36, 30, 'Renal organ for kidney transplantation', 'Can be preserved longer than other organs'),
('Liver', 24, 12, 'Hepatic organ for liver transplantation', 'Requires immediate surgical team availability'),
('Lung', 8, 6, 'Pulmonary organ for lung transplantation', 'Highly time-sensitive'),
('Pancreas', 12, 12, 'Pancreatic organ for diabetes treatment', 'Often transplanted with kidney');

-- =====================================================
-- 2. MEDICATIONS (20 common transplant medications)
-- =====================================================
INSERT INTO Medication (Name, Dosage_Form, Typical_Dosage, Purpose, Side_Effects, Manufacturer) VALUES
('Tacrolimus', 'Capsule', '5mg twice daily', 'Immunosuppressant', 'Tremors, headache, high blood pressure', 'Astellas Pharma'),
('Cyclosporine', 'Capsule', '100mg twice daily', 'Immunosuppressant', 'Kidney problems, high blood pressure', 'Novartis'),
('Prednisone', 'Tablet', '10mg daily', 'Corticosteroid immunosuppressant', 'Weight gain, mood changes', 'Pfizer'),
('Mycophenolate', 'Tablet', '500mg twice daily', 'Immunosuppressant', 'Diarrhea, nausea', 'Roche'),
('Sirolimus', 'Tablet', '2mg daily', 'Immunosuppressant', 'High cholesterol, mouth sores', 'Pfizer'),
('Azathioprine', 'Tablet', '50mg daily', 'Immunosuppressant', 'Low blood counts, nausea', 'GSK'),
('Basiliximab', 'Injection', '20mg IV', 'Induction immunosuppression', 'Allergic reactions', 'Novartis'),
('Valganciclovir', 'Tablet', '450mg twice daily', 'Antiviral for CMV prevention', 'Low white blood cell count', 'Roche'),
('Trimethoprim-Sulfamethoxazole', 'Tablet', '1 tablet daily', 'Antibiotic prophylaxis', 'Rash, nausea', 'Various'),
('Atorvastatin', 'Tablet', '20mg daily', 'Cholesterol management', 'Muscle pain', 'Pfizer'),
('Amlodipine', 'Tablet', '5mg daily', 'Blood pressure control', 'Swelling, dizziness', 'Pfizer'),
('Furosemide', 'Tablet', '40mg daily', 'Diuretic', 'Dehydration, low potassium', 'Sanofi'),
('Insulin Glargine', 'Injection', '10 units daily', 'Diabetes management', 'Low blood sugar', 'Sanofi'),
('Omeprazole', 'Capsule', '20mg daily', 'Stomach protection', 'Headache, nausea', 'AstraZeneca'),
('Epoetin Alfa', 'Injection', '4000 units weekly', 'Anemia treatment', 'High blood pressure', 'Amgen'),
('Calcium Carbonate', 'Tablet', '500mg three times daily', 'Bone health', 'Constipation', 'Various'),
('Vitamin D3', 'Capsule', '1000 IU daily', 'Bone health', 'Rare at normal doses', 'Various'),
('Warfarin', 'Tablet', '5mg daily', 'Anticoagulant', 'Bleeding risk', 'Bristol-Myers Squibb'),
('Aspirin', 'Tablet', '81mg daily', 'Antiplatelet', 'Stomach irritation', 'Bayer'),
('Metoprolol', 'Tablet', '50mg twice daily', 'Beta blocker for heart', 'Fatigue, dizziness', 'AstraZeneca');

-- =====================================================
-- 3. USERS (Authentication accounts)
-- =====================================================
INSERT INTO User (Username, Password_Hash, Email, Role, Account_Status, Created_Date, Last_Login) VALUES
('admin', 'admin123', 'admin@hospital.com', 'Administrator', 'Active', '2024-01-01', '2024-12-03 10:00:00'),
('dr_smith', 'password123', 'smith@hospital.com', 'Medical_Staff', 'Active', '2024-01-15', '2024-12-02 14:30:00'),
('dr_jones', 'password123', 'jones@hospital.com', 'Medical_Staff', 'Active', '2024-02-01', '2024-12-02 09:00:00'),
('coordinator_mary', 'password123', 'mary@hospital.com', 'Coordinator', 'Active', '2024-02-15', '2024-12-03 08:00:00'),
('coordinator_john', 'password123', 'john@hospital.com', 'Coordinator', 'Active', '2024-03-01', '2024-12-02 16:00:00'),
('patient_alice', 'password123', 'alice@email.com', 'Recipient', 'Active', '2024-06-01', '2024-12-01 11:00:00'),
('patient_bob', 'password123', 'bob@email.com', 'Recipient', 'Active', '2024-07-01', '2024-11-30 15:00:00'),
('patient_carol', 'password123', 'carol@email.com', 'Recipient', 'Active', '2024-08-01', NULL),
('dr_williams', 'password123', 'williams@hospital.com', 'Medical_Staff', 'Active', '2024-03-15', '2024-12-03 07:00:00'),
('dr_davis', 'password123', 'davis@hospital.com', 'Medical_Staff', 'Active', '2024-04-01', '2024-12-02 13:00:00');

-- =====================================================
-- 4. HOSPITALS (10 hospitals across different states)
-- =====================================================
INSERT INTO Hospital (Name, Address, Street_number, Street_name, City, State, Zipcode, Phone, Trauma_Level, OPO_Affiliation) VALUES
('Massachusetts General Hospital', '55 Fruit Street', '55', 'Fruit Street', 'Boston', 'MA', '02114', '617-726-2000', 1, 'New England Donor Services'),
('Johns Hopkins Hospital', '1800 Orleans Street', '1800', 'Orleans Street', 'Baltimore', 'MD', '21287', '410-955-5000', 1, 'Living Legacy Foundation'),
('Mayo Clinic', '200 First Street SW', '200', 'First Street SW', 'Rochester', 'MN', '55905', '507-284-2511', 1, 'LifeSource'),
('Cleveland Clinic', '9500 Euclid Avenue', '9500', 'Euclid Avenue', 'Cleveland', 'OH', '44195', '216-444-2200', 1, 'Lifebanc'),
('UCLA Medical Center', '757 Westwood Plaza', '757', 'Westwood Plaza', 'Los Angeles', 'CA', '90095', '310-825-9111', 1, 'OneLegacy'),
('UCSF Medical Center', '505 Parnassus Avenue', '505', 'Parnassus Avenue', 'San Francisco', 'CA', '94143', '415-476-1000', 1, 'Donor Network West'),
('New York-Presbyterian', '525 East 68th Street', '525', 'East 68th Street', 'New York', 'NY', '10065', '212-746-5454', 1, 'LiveOnNY'),
('Northwestern Memorial', '251 East Huron Street', '251', 'East Huron Street', 'Chicago', 'IL', '60611', '312-926-2000', 1, 'Gift of Hope'),
('Stanford Health Care', '300 Pasteur Drive', '300', 'Pasteur Drive', 'Stanford', 'CA', '94305', '650-723-4000', 1, 'Donor Network West'),
('Brigham and Women''s', '75 Francis Street', '75', 'Francis Street', 'Boston', 'MA', '02115', '617-732-5500', 1, 'New England Donor Services');

-- =====================================================
-- 5. HOSPITAL CAPABILITIES
-- =====================================================
INSERT INTO Hospital_Capabilities (Hospital_ID, Type_Name) VALUES
-- Massachusetts General (all organs)
(1, 'Heart'), (1, 'Kidney'), (1, 'Liver'), (1, 'Lung'), (1, 'Pancreas'),
-- Johns Hopkins (all organs)
(2, 'Heart'), (2, 'Kidney'), (2, 'Liver'), (2, 'Lung'), (2, 'Pancreas'),
-- Mayo Clinic (all organs)
(3, 'Heart'), (3, 'Kidney'), (3, 'Liver'), (3, 'Lung'), (3, 'Pancreas'),
-- Cleveland Clinic (Heart, Kidney, Liver)
(4, 'Heart'), (4, 'Kidney'), (4, 'Liver'),
-- UCLA (all organs)
(5, 'Heart'), (5, 'Kidney'), (5, 'Liver'), (5, 'Lung'), (5, 'Pancreas'),
-- UCSF (Kidney, Liver, Pancreas)
(6, 'Kidney'), (6, 'Liver'), (6, 'Pancreas'),
-- NY Presbyterian (all organs)
(7, 'Heart'), (7, 'Kidney'), (7, 'Liver'), (7, 'Lung'), (7, 'Pancreas'),
-- Northwestern (Heart, Kidney, Liver)
(8, 'Heart'), (8, 'Kidney'), (8, 'Liver'),
-- Stanford (all organs)
(9, 'Heart'), (9, 'Kidney'), (9, 'Liver'), (9, 'Lung'), (9, 'Pancreas'),
-- Brigham (Kidney, Liver, Pancreas)
(10, 'Kidney'), (10, 'Liver'), (10, 'Pancreas');

-- =====================================================
-- 6. MEDICAL STAFF (15 staff members)
-- =====================================================
INSERT INTO Medical_Staff (Hospital_ID, Name, Specialization, License_Number, Certification_Date, Certification_Level, Phone, Email, User_ID) VALUES
(1, 'Dr. Sarah Smith', 'Transplant_Surgeon', 'MD-123456', '2015-06-15', 'Board Certified', '617-726-3001', 'smith@mgh.edu', 2),
(2, 'Dr. Michael Jones', 'Transplant_Surgeon', 'MD-234567', '2012-08-20', 'Board Certified', '410-955-6001', 'jones@jhmi.edu', 3),
(1, 'Mary Johnson', 'Coordinator', 'RN-345678', '2018-03-10', 'Certified Transplant Coordinator', '617-726-3002', 'mary@mgh.edu', 4),
(3, 'Dr. Emily Williams', 'Transplant_Surgeon', 'MD-456789', '2014-11-05', 'Board Certified', '507-284-4001', 'williams@mayo.edu', 9),
(4, 'Dr. Robert Davis', 'Nephrologist', 'MD-567890', '2016-09-12', 'Board Certified', '216-444-5001', 'davis@ccf.org', 10),
(2, 'John Martinez', 'Coordinator', 'RN-678901', '2019-01-20', 'Certified Transplant Coordinator', '410-955-6002', 'john@jhmi.edu', 5),
(5, 'Dr. Jennifer Garcia', 'Transplant_Surgeon', 'MD-789012', '2013-07-18', 'Board Certified', '310-825-7001', 'garcia@ucla.edu', NULL),
(6, 'Dr. David Miller', 'Nephrologist', 'MD-890123', '2017-05-22', 'Board Certified', '415-476-8001', 'miller@ucsf.edu', NULL),
(7, 'Dr. Lisa Anderson', 'Transplant_Surgeon', 'MD-901234', '2011-10-30', 'Board Certified', '212-746-9001', 'anderson@nyp.org', NULL),
(3, 'Patricia Wilson', 'Coordinator', 'RN-012345', '2020-02-14', 'Certified Transplant Coordinator', '507-284-4002', 'wilson@mayo.edu', NULL),
(8, 'Dr. James Moore', 'Transplant_Surgeon', 'MD-112233', '2015-04-08', 'Board Certified', '312-926-5001', 'moore@nm.org', NULL),
(9, 'Dr. Maria Taylor', 'Transplant_Surgeon', 'MD-223344', '2014-12-01', 'Board Certified', '650-723-6001', 'taylor@stanford.edu', NULL),
(10, 'Dr. Christopher Lee', 'Nephrologist', 'MD-334455', '2016-06-25', 'Board Certified', '617-732-7001', 'lee@bwh.edu', NULL),
(4, 'Susan White', 'Coordinator', 'RN-445566', '2019-08-10', 'Certified Transplant Coordinator', '216-444-5002', 'white@ccf.org', NULL),
(5, 'Karen Harris', 'Coordinator', 'RN-556677', '2021-03-05', 'Certified Transplant Coordinator', '310-825-7002', 'harris@ucla.edu', NULL);

-- =====================================================
-- 7. DONORS (25 donors - mix of living and deceased)
-- =====================================================
INSERT INTO Donor (Name, Date_of_Birth, Blood_Type, Gender, Contact_Info, Donor_Type, Medical_History, Cause_of_Death, Registration_Date, Medical_Clearance_Date, Status) VALUES
('John Doe', '1985-03-15', 'O+', 'M', '123 Main St, Boston MA, 617-555-0101', 'Deceased', 'No significant history', 'Motor vehicle accident', '2024-11-25', '2024-11-25', 'Deceased'),
('Jane Smith', '1978-07-22', 'A+', 'F', '456 Oak Ave, Baltimore MD, 410-555-0102', 'Deceased', 'Hypertension controlled', 'Stroke', '2024-11-28', '2024-11-28', 'Deceased'),
('Robert Johnson', '1990-11-08', 'B+', 'M', '789 Pine Rd, Rochester MN, 507-555-0103', 'Living', 'Healthy, non-smoker', NULL, '2024-10-15', '2024-10-20', 'Active'),
('Maria Garcia', '1982-05-30', 'AB+', 'F', '321 Elm St, Cleveland OH, 216-555-0104', 'Deceased', 'Diabetes Type 2', 'Aneurysm', '2024-11-30', '2024-11-30', 'Deceased'),
('Michael Brown', '1995-09-12', 'O-', 'M', '654 Maple Dr, Los Angeles CA, 310-555-0105', 'Deceased', 'No known conditions', 'Trauma', '2024-12-01', '2024-12-01', 'Deceased'),
('Emily Wilson', '1988-01-25', 'A-', 'F', '987 Cedar Ln, San Francisco CA, 415-555-0106', 'Living', 'Non-smoker, regular exercise', NULL, '2024-09-20', '2024-09-25', 'Active'),
('David Martinez', '1975-12-18', 'B-', 'M', '147 Birch Ave, New York NY, 212-555-0107', 'Deceased', 'Former smoker', 'Cardiac arrest', '2024-11-20', '2024-11-20', 'Deceased'),
('Lisa Anderson', '1992-04-03', 'AB-', 'F', '258 Spruce St, Chicago IL, 312-555-0108', 'Living', 'Excellent health', NULL, '2024-10-01', '2024-10-05', 'Active'),
('James Taylor', '1980-08-14', 'O+', 'M', '369 Walnut Rd, Stanford CA, 650-555-0109', 'Deceased', 'Hypertension', 'Brain injury', '2024-12-02', '2024-12-02', 'Deceased'),
('Patricia Lee', '1987-06-27', 'A+', 'F', '741 Ash Dr, Boston MA, 617-555-0110', 'Deceased', 'No significant history', 'Accident', '2024-11-27', '2024-11-27', 'Deceased'),
('Christopher White', '1993-10-09', 'B+', 'M', '852 Hickory Ln, Baltimore MD, 410-555-0111', 'Living', 'Athletic, non-smoker', NULL, '2024-08-10', '2024-08-15', 'Active'),
('Sarah Harris', '1979-02-16', 'O-', 'F', '963 Poplar Ave, Rochester MN, 507-555-0112', 'Deceased', 'Well controlled diabetes', 'Complications', '2024-11-29', '2024-11-29', 'Deceased'),
('Daniel Clark', '1991-07-21', 'AB+', 'M', '159 Willow St, Cleveland OH, 216-555-0113', 'Living', 'No medical conditions', NULL, '2024-09-05', '2024-09-10', 'Active'),
('Jennifer Lewis', '1984-11-30', 'A-', 'F', '357 Beech Rd, Los Angeles CA, 310-555-0114', 'Deceased', 'Asthma controlled', 'Trauma', '2024-12-01', '2024-12-01', 'Deceased'),
('Matthew Walker', '1996-03-05', 'B-', 'M', '486 Sycamore Dr, San Francisco CA, 415-555-0115', 'Living', 'Marathon runner', NULL, '2024-07-20', '2024-07-25', 'Active'),
('Amanda Hall', '1983-09-19', 'O+', 'F', '579 Cherry Ln, New York NY, 212-555-0116', 'Deceased', 'No history', 'Accident', '2024-11-26', '2024-11-26', 'Deceased'),
('Joshua Allen', '1989-12-11', 'A+', 'M', '681 Dogwood Ave, Chicago IL, 312-555-0117', 'Living', 'Healthy lifestyle', NULL, '2024-10-10', '2024-10-15', 'Active'),
('Michelle Young', '1977-05-24', 'B+', 'F', '792 Magnolia St, Stanford CA, 650-555-0118', 'Deceased', 'Hypertension', 'Stroke', '2024-11-28', '2024-11-28', 'Deceased'),
('Kevin King', '1994-01-07', 'AB-', 'M', '803 Redwood Rd, Boston MA, 617-555-0119', 'Living', 'No conditions', NULL, '2024-08-25', '2024-08-30', 'Active'),
('Laura Wright', '1981-08-28', 'O-', 'F', '914 Cypress Dr, Baltimore MD, 410-555-0120', 'Deceased', 'Well controlled conditions', 'Brain death', '2024-12-02', '2024-12-02', 'Deceased'),
('Brian Lopez', '1986-02-13', 'A+', 'M', '025 Fir Ln, Rochester MN, 507-555-0121', 'Living', 'Athletic', NULL, '2024-09-15', '2024-09-20', 'Active'),
('Rachel Hill', '1976-10-20', 'B-', 'F', '136 Palm Ave, Cleveland OH, 216-555-0122', 'Deceased', 'Former smoker', 'Accident', '2024-11-25', '2024-11-25', 'Deceased'),
('Steven Scott', '1998-06-04', 'O+', 'M', '247 Laurel St, Los Angeles CA, 310-555-0123', 'Living', 'Excellent health', NULL, '2024-07-01', '2024-07-05', 'Active'),
('Nicole Green', '1985-12-16', 'AB+', 'F', '358 Sequoia Rd, San Francisco CA, 415-555-0124', 'Deceased', 'No history', 'Trauma', '2024-12-03', '2024-12-03', 'Deceased'),
('Thomas Adams', '1991-04-09', 'A-', 'M', '469 Acacia Dr, New York NY, 212-555-0125', 'Living', 'Regular checkups', NULL, '2024-08-01', '2024-08-05', 'Active');

-- =====================================================
-- 8. RECIPIENTS (35 recipients waiting for organs)
-- =====================================================
INSERT INTO Recipient (Name, Date_of_Birth, Blood_Type, Gender, Contact_Info, Medical_History, Primary_Diagnosis, Medical_Urgency_Level, Registration_Date, Status, Insurance_Info, User_ID) VALUES
-- Critical urgency (Level 5)
('Alice Thompson', '1970-03-20', 'A+', 'F', '100 Patient St, Boston MA, 617-555-1001', 'End-stage heart failure', 'Dilated cardiomyopathy', 5, '2024-06-01', 'Waiting', 'Blue Cross MA - Policy #BC123456', 6),
('Bob Richardson', '1965-08-15', 'O+', 'M', '200 Patient Ave, Baltimore MD, 410-555-1002', 'Liver cirrhosis', 'Hepatitis C cirrhosis', 5, '2024-07-15', 'Waiting', 'Medicare - ID #MED789012', 7),
('Carol Evans', '1968-11-22', 'B+', 'F', '300 Patient Rd, Rochester MN, 507-555-1003', 'Kidney failure', 'Diabetic nephropathy', 5, '2024-08-01', 'Waiting', 'United Healthcare - #UHC345678', 8),

-- High urgency (Level 4)
('David Collins', '1972-05-10', 'AB+', 'M', '400 Patient Ln, Cleveland OH, 216-555-1004', 'Lung disease', 'Pulmonary fibrosis', 4, '2024-07-20', 'Waiting', 'Aetna - Policy #AET901234', NULL),
('Emma Stewart', '1975-09-05', 'A-', 'F', '500 Patient Dr, Los Angeles CA, 310-555-1005', 'Kidney disease', 'Polycystic kidney disease', 4, '2024-06-15', 'Waiting', 'Kaiser Permanente - #KP567890', NULL),
('Frank Morris', '1969-12-28', 'O-', 'M', '600 Patient St, San Francisco CA, 415-555-1006', 'Heart failure', 'Ischemic cardiomyopathy', 4, '2024-08-10', 'Waiting', 'Blue Shield CA - #BS234567', NULL),
('Grace Rogers', '1974-04-12', 'B-', 'F', '700 Patient Ave, New York NY, 212-555-1007', 'Liver failure', 'Primary biliary cholangitis', 4, '2024-09-01', 'Waiting', 'Cigna - Policy #CIG890123', NULL),
('Henry Reed', '1971-07-25', 'AB-', 'M', '800 Patient Rd, Chicago IL, 312-555-1008', 'Kidney failure', 'Hypertensive nephropathy', 4, '2024-07-05', 'Waiting', 'Humana - #HUM456789', NULL),

-- Medium urgency (Level 3)
('Isabel Cook', '1976-01-18', 'A+', 'F', '900 Patient Ln, Stanford CA, 650-555-1009', 'Kidney disease', 'Chronic kidney disease Stage 4', 3, '2024-05-01', 'Waiting', 'Anthem Blue Cross - #ABC012345', NULL),
('Jack Morgan', '1973-10-30', 'O+', 'M', '1000 Patient Dr, Boston MA, 617-555-1010', 'Liver disease', 'Alcoholic cirrhosis (sober 3 yrs)', 3, '2024-06-20', 'Waiting', 'Harvard Pilgrim - #HP678901', NULL),
('Karen Bell', '1977-06-14', 'B+', 'F', '1100 Patient St, Baltimore MD, 410-555-1011', 'Kidney failure', 'IgA nephropathy', 3, '2024-08-15', 'Waiting', 'CareFirst - #CF234567', NULL),
('Larry Murphy', '1970-02-08', 'AB+', 'M', '1200 Patient Ave, Rochester MN, 507-555-1012', 'Heart disease', 'Restrictive cardiomyopathy', 3, '2024-09-10', 'Waiting', 'Blue Cross MN - #BCMN890123', NULL),
('Monica Bailey', '1978-11-03', 'A-', 'F', '1300 Patient Rd, Cleveland OH, 216-555-1013', 'Kidney disease', 'Lupus nephritis', 3, '2024-07-25', 'Waiting', 'Medical Mutual OH - #MM456789', NULL),
('Nathan Rivera', '1975-09-16', 'O-', 'M', '1400 Patient Ln, Los Angeles CA, 310-555-1014', 'Liver disease', 'Primary sclerosing cholangitis', 3, '2024-08-20', 'Waiting', 'Health Net - #HN012345', NULL),
('Olivia Cooper', '1979-04-29', 'B-', 'F', '1500 Patient Dr, San Francisco CA, 415-555-1015', 'Lung disease', 'Cystic fibrosis', 3, '2024-09-05', 'Waiting', 'Blue Shield CA - #BSCA678901', NULL),

-- Lower urgency (Level 2 and 1)
('Paul Richardson', '1980-12-11', 'AB-', 'M', '1600 Patient St, New York NY, 212-555-1016', 'Kidney disease', 'Chronic kidney disease Stage 3', 2, '2024-05-15', 'Waiting', 'Empire BlueCross - #EBC234567', NULL),
('Quinn Foster', '1983-07-06', 'A+', 'F', '1700 Patient Ave, Chicago IL, 312-555-1017', 'Liver disease', 'Autoimmune hepatitis', 2, '2024-06-10', 'Waiting', 'Blue Cross IL - #BCIL890123', NULL),
('Ryan Gray', '1982-03-21', 'O+', 'M', '1800 Patient Rd, Stanford CA, 650-555-1018', 'Kidney disease', 'Reflux nephropathy', 2, '2024-07-01', 'Waiting', 'Stanford Health - #SH456789', NULL),
('Sophia Hughes', '1981-08-17', 'B+', 'F', '1900 Patient Ln, Boston MA, 617-555-1019', 'Kidney disease', 'Glomerulonephritis', 2, '2024-08-05', 'Waiting', 'Tufts Health - #TH012345', NULL),
('Tyler Price', '1984-05-02', 'AB+', 'M', '2000 Patient Dr, Baltimore MD, 410-555-1020', 'Liver disease', 'Non-alcoholic fatty liver', 2, '2024-09-20', 'Waiting', 'Johns Hopkins Health - #JHH678901', NULL),
('Uma Bennett', '1986-01-14', 'A-', 'F', '2100 Patient St, Rochester MN, 507-555-1021', 'Kidney disease', 'Chronic kidney disease Stage 3', 1, '2024-04-10', 'Waiting', 'Mayo Clinic Health - #MCH234567', NULL),
('Victor Wood', '1987-09-26', 'O-', 'M', '2200 Patient Ave, Cleveland OH, 216-555-1022', 'Kidney disease', 'Polycystic kidney disease (early)', 1, '2024-05-05', 'Waiting', 'Cleveland Clinic Health - #CCH890123', NULL),
('Wendy Barnes', '1985-06-08', 'B-', 'F', '2300 Patient Rd, Los Angeles CA, 310-555-1023', 'Liver disease', 'Wilson disease', 1, '2024-06-25', 'Waiting', 'UCLA Health - #UCLAH456789', NULL),
('Xavier Ross', '1988-12-30', 'AB-', 'M', '2400 Patient Ln, San Francisco CA, 415-555-1024', 'Kidney disease', 'Alport syndrome', 1, '2024-08-12', 'Waiting', 'UCSF Health - #UCSFH012345', NULL),
('Yolanda Henderson', '1976-04-22', 'A+', 'F', '2500 Patient Dr, New York NY, 212-555-1025', 'Kidney disease', 'Chronic kidney disease Stage 4', 2, '2024-07-18', 'Waiting', 'NY Presbyterian Health - #NYP678901', NULL),

-- Additional recipients for variety
('Zachary Coleman', '1990-08-03', 'O+', 'M', '2600 Patient St, Chicago IL, 312-555-1026', 'Heart disease', 'Hypertrophic cardiomyopathy', 3, '2024-09-25', 'Waiting', 'Northwestern Health - #NWH234567', NULL),
('Ava Jenkins', '1973-11-15', 'B+', 'F', '2700 Patient Ave, Stanford CA, 650-555-1027', 'Liver disease', 'Hepatitis B cirrhosis', 3, '2024-08-30', 'Waiting', 'Stanford Health - #SH890123', NULL),
('Brandon Perry', '1982-02-27', 'AB+', 'M', '2800 Patient Rd, Boston MA, 617-555-1028', 'Kidney failure', 'Focal segmental glomerulosclerosis', 4, '2024-10-05', 'Waiting', 'Partners Healthcare - #PH456789', NULL),
('Chloe Powell', '1979-07-11', 'A-', 'F', '2900 Patient Ln, Baltimore MD, 410-555-1029', 'Kidney disease', 'Membranous nephropathy', 3, '2024-09-15', 'Waiting', 'Hopkins Health - #HH012345', NULL),
('Dylan Long', '1985-12-04', 'O-', 'M', '3000 Patient Dr, Rochester MN, 507-555-1030', 'Heart failure', 'Viral cardiomyopathy', 4, '2024-10-20', 'Waiting', 'Mayo Health - #MH678901', NULL),
('Ella Patterson', '1974-03-17', 'B-', 'F', '3100 Patient St, Cleveland OH, 216-555-1031', 'Liver failure', 'Autoimmune hepatitis', 3, '2024-08-25', 'Waiting', 'Clinic Health - #CH234567', NULL),
('Felix Hughes', '1992-09-09', 'AB-', 'M', '3200 Patient Ave, Los Angeles CA, 310-555-1032', 'Kidney disease', 'Chronic glomerulonephritis', 2, '2024-07-30', 'Waiting', 'UCLA Care - #UC890123', NULL),
('Gina Flores', '1978-05-31', 'A+', 'F', '3300 Patient Rd, San Francisco CA, 415-555-1033', 'Kidney failure', 'Diabetic nephropathy', 4, '2024-10-15', 'Waiting', 'UCSF Care - #UCSFC456789', NULL),
('Harry Washington', '1971-01-23', 'O+', 'M', '3400 Patient Ln, New York NY, 212-555-1034', 'Liver cirrhosis', 'Hepatitis C', 3, '2024-09-08', 'Waiting', 'NY Health - #NYH012345', NULL),
('Iris Butler', '1987-10-06', 'B+', 'F', '3500 Patient Dr, Chicago IL, 312-555-1035', 'Kidney disease', 'IgA nephropathy', 2, '2024-08-18', 'Waiting', 'Illinois Health - #ILH678901', NULL);

-- =====================================================
-- 9. RECIPIENT WAITLIST (Add recipients to organ waitlists)
-- =====================================================
INSERT INTO Recipient_Waitlist (Recipient_ID, Type_Name, Priority_Score, Wait_List_Date, Status, MELD_Score, CPRA_Score) VALUES
-- Heart waitlist
(1, 'Heart', 85.00, '2024-06-01', 'Waiting', NULL, NULL),
(6, 'Heart', 72.00, '2024-08-10', 'Waiting', NULL, NULL),
(12, 'Heart', 65.00, '2024-09-25', 'Waiting', NULL, NULL),
(30, 'Heart', 70.00, '2024-10-20', 'Waiting', NULL, NULL),

-- Liver waitlist
(2, 'Liver', 90.00, '2024-07-15', 'Waiting', 35.50, NULL),
(7, 'Liver', 75.00, '2024-09-01', 'Waiting', 28.00, NULL),
(10, 'Liver', 68.00, '2024-06-20', 'Waiting', 22.00, NULL),
(14, 'Liver', 65.00, '2024-08-30', 'Waiting', 20.50, NULL),
(18, 'Liver', 72.00, '2024-08-25', 'Waiting', 25.00, NULL),
(27, 'Liver', 68.00, '2024-08-30', 'Waiting', 23.00, NULL),
(31, 'Liver', 65.00, '2024-08-25', 'Waiting', 21.00, NULL),
(34, 'Liver', 70.00, '2024-09-08', 'Waiting', 24.50, NULL),

-- Kidney waitlist (most common)
(3, 'Kidney', 88.00, '2024-08-01', 'Waiting', NULL, 85.50),
(4, 'Kidney', 70.00, '2024-07-20', 'Waiting', NULL, 45.00),
(5, 'Kidney', 78.00, '2024-06-15', 'Waiting', NULL, 62.00),
(8, 'Kidney', 72.00, '2024-07-05', 'Waiting', NULL, 55.00),
(9, 'Kidney', 65.00, '2024-05-01', 'Waiting', NULL, 38.00),
(11, 'Kidney', 60.00, '2024-08-15', 'Waiting', NULL, 42.00),
(13, 'Kidney', 58.00, '2024-07-25', 'Waiting', NULL, 35.00),
(15, 'Kidney', 55.00, '2024-08-12', 'Waiting', NULL, 28.00),
(16, 'Kidney', 50.00, '2024-05-15', 'Waiting', NULL, 22.00),
(17, 'Kidney', 48.00, '2024-06-10', 'Waiting', NULL, 25.00),
(19, 'Kidney', 45.00, '2024-08-05', 'Waiting', NULL, 30.00),
(21, 'Kidney', 42.00, '2024-07-30', 'Waiting', NULL, 18.00),
(23, 'Kidney', 40.00, '2024-07-01', 'Waiting', NULL, 15.00),
(25, 'Kidney', 38.00, '2024-07-18', 'Waiting', NULL, 20.00),
(28, 'Kidney', 75.00, '2024-10-15', 'Waiting', NULL, 75.00),
(29, 'Kidney', 62.00, '2024-09-15', 'Waiting', NULL, 50.00),
(32, 'Kidney', 55.00, '2024-07-30', 'Waiting', NULL, 40.00),
(33, 'Kidney', 52.00, '2024-10-15', 'Waiting', NULL, 45.00),
(35, 'Kidney', 48.00, '2024-08-18', 'Waiting', NULL, 35.00),

-- Lung waitlist
(15, 'Lung', 62.00, '2024-09-05', 'Waiting', NULL, NULL),

-- Pancreas waitlist
(3, 'Pancreas', 60.00, '2024-08-01', 'Waiting', NULL, NULL);

-- =====================================================
-- 10. ORGANS (18 organs - some fresh, some allocated)
-- =====================================================
INSERT INTO Organ (Type_Name, Donor_ID, HLA_Type, Procurement_Date, Procurement_Time, Size_Weight, Status) VALUES
-- Recently procured (within last 24 hours) - AVAILABLE
('Kidney', 1, 'A1-B8-DR3', CURDATE(), SUBTIME(CURTIME(), '02:00:00'), 150.50, 'Available'),
('Liver', 2, 'A2-B7-DR4', CURDATE(), SUBTIME(CURTIME(), '04:00:00'), 1450.00, 'Available'),
('Heart', 5, 'A3-B44-DR7', CURDATE(), SUBTIME(CURTIME(), '01:30:00'), 320.00, 'Available'),
('Kidney', 7, 'A1-B8-DR3', CURDATE(), SUBTIME(CURTIME(), '06:00:00'), 145.00, 'Available'),
('Lung', 9, 'A2-B35-DR1', CURDATE(), SUBTIME(CURTIME(), '03:00:00'), 850.00, 'Available'),

-- Procured yesterday - some allocated
('Kidney', 10, 'A3-B7-DR4', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '14:30:00', 155.75, 'Allocated'),
('Liver', 12, 'A1-B44-DR3', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '10:15:00', 1380.00, 'Allocated'),
('Heart', 16, 'A2-B8-DR7', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:45:00', 305.50, 'Allocated'),

-- Older organs - some transplanted
('Kidney', 14, 'A1-B35-DR1', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '16:20:00', 148.00, 'Transplanted'),
('Liver', 18, 'A2-B7-DR4', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '11:00:00', 1420.00, 'Transplanted'),
('Heart', 20, 'A3-B8-DR3', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '09:30:00', 315.00, 'Transplanted'),

-- Very old - expired
('Heart', 22, 'A1-B44-DR7', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '06:00:00', 310.00, 'Expired'),

-- More recent organs
('Kidney', 24, 'A2-B35-DR1', CURDATE(), SUBTIME(CURTIME(), '08:00:00'), 152.00, 'Available'),
('Pancreas', 5, 'A3-B7-DR4', CURDATE(), SUBTIME(CURTIME(), '05:00:00'), 95.00, 'Available'),
('Kidney', 1, 'A1-B8-DR3', CURDATE(), SUBTIME(CURTIME(), '10:00:00'), 148.50, 'Available'),
('Liver', 4, 'A2-B44-DR7', CURDATE(), SUBTIME(CURTIME(), '07:00:00'), 1410.00, 'Available'),
('Lung', 14, 'A1-B35-DR3', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '12:00:00', 820.00, 'Allocated'),
('Kidney', 20, 'A3-B7-DR1', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '15:30:00', 153.00, 'Transplanted');

-- =====================================================
-- 11. ORGAN ALLOCATIONS (Some pending, some accepted)
-- =====================================================
INSERT INTO Organ_Allocation (Organ_ID, Recipient_ID, Allocation_Date, Match_Score, Status, Response_Deadline) VALUES
-- Recent allocations - pending
(6, 3, NOW(), 88.50, 'Pending', DATE_ADD(NOW(), INTERVAL 12 HOUR)),
(7, 2, DATE_SUB(NOW(), INTERVAL 2 HOUR), 90.00, 'Pending', DATE_ADD(NOW(), INTERVAL 10 HOUR)),
(8, 1, DATE_SUB(NOW(), INTERVAL 1 HOUR), 85.00, 'Pending', DATE_ADD(NOW(), INTERVAL 2 HOUR)),
(17, 15, DATE_SUB(NOW(), INTERVAL 3 HOUR), 75.00, 'Pending', DATE_ADD(NOW(), INTERVAL 3 HOUR)),

-- Accepted allocations (led to surgery)
(9, 5, DATE_SUB(NOW(), INTERVAL 3 DAY), 92.00, 'Accepted', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(10, 7, DATE_SUB(NOW(), INTERVAL 4 DAY), 88.00, 'Accepted', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(11, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 87.00, 'Accepted', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(18, 4, DATE_SUB(NOW(), INTERVAL 2 DAY), 85.00, 'Accepted', DATE_SUB(NOW(), INTERVAL 2 DAY)),

-- Rejected allocations
(1, 16, DATE_SUB(NOW(), INTERVAL 1 DAY), 65.00, 'Rejected', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(13, 9, DATE_SUB(NOW(), INTERVAL 6 HOUR), 70.00, 'Rejected', DATE_SUB(NOW(), INTERVAL 6 HOUR));

-- =====================================================
-- 12. SURGERIES (Completed transplants)
-- =====================================================
INSERT INTO Surgery (Hospital_ID, Organ_ID, Recipient_ID, Primary_Surgeon_ID, Surgery_Date, Surgery_Time, Duration_Hours, Outcome, Notes, Complications_Description) VALUES
(1, 9, 5, 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '09:00:00', 4.5, 'Success', 'Routine kidney transplant, no complications', NULL),
(2, 10, 7, 2, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:30:00', 6.0, 'Success', 'Liver transplant successful', NULL),
(1, 11, 1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '07:00:00', 5.5, 'Complications', 'Heart transplant with minor bleeding complications', 'Post-operative bleeding controlled'),
(4, 18, 4, 5, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '10:15:00', 4.0, 'Success', 'Kidney transplant, excellent outcome', NULL);

-- =====================================================
-- 13. SURGERY PERFORMED BY (Surgical teams)
-- =====================================================
INSERT INTO Surgery_Performed_By (Surgery_ID, Staff_ID, Role, Start_Time, End_Time, Primary_Surgeon) VALUES
-- Surgery 1 team
(1, 1, 'Lead Surgeon', CONCAT(DATE_SUB(CURDATE(), INTERVAL 3 DAY), ' 09:00:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 3 DAY), ' 13:30:00'), 1),
(1, 3, 'Coordinator', CONCAT(DATE_SUB(CURDATE(), INTERVAL 3 DAY), ' 08:30:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 3 DAY), ' 14:00:00'), 0),

-- Surgery 2 team
(2, 2, 'Lead Surgeon', CONCAT(DATE_SUB(CURDATE(), INTERVAL 4 DAY), ' 08:30:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 4 DAY), ' 14:30:00'), 1),
(2, 6, 'Coordinator', CONCAT(DATE_SUB(CURDATE(), INTERVAL 4 DAY), ' 08:00:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 4 DAY), ' 15:00:00'), 0),

-- Surgery 3 team
(3, 1, 'Lead Surgeon', CONCAT(DATE_SUB(CURDATE(), INTERVAL 5 DAY), ' 07:00:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 5 DAY), ' 12:30:00'), 1),
(3, 3, 'Assistant', CONCAT(DATE_SUB(CURDATE(), INTERVAL 5 DAY), ' 07:00:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 5 DAY), ' 12:30:00'), 0),

-- Surgery 4 team
(4, 5, 'Lead Surgeon', CONCAT(DATE_SUB(CURDATE(), INTERVAL 2 DAY), ' 10:15:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 2 DAY), ' 14:15:00'), 1),
(4, 14, 'Coordinator', CONCAT(DATE_SUB(CURDATE(), INTERVAL 2 DAY), ' 10:00:00'), CONCAT(DATE_SUB(CURDATE(), INTERVAL 2 DAY), ' 14:30:00'), 0);

-- =====================================================
-- 14. FOLLOW-UP APPOINTMENTS (Auto-created by trigger)
-- Note: after_surgery_insert trigger already created some
-- Adding additional scheduled appointments
-- =====================================================
INSERT INTO Follow_Up_Appointment (Surgery_ID, Recipient_ID, Staff_ID, Appointment_Date, Appointment_Time, Rejection_Indicators, Lab_Results, Medication_Adherence, Notes, Next_Appointment_Date) VALUES
-- Follow-ups for surgery 1
(1, 5, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '09:00:00', 'None detected', 'Creatinine 1.2 mg/dL - Normal', 'Good', '3-day post-op check - healing well', DATE_ADD(CURDATE(), INTERVAL 9 DAY)),
(1, 5, 1, DATE_ADD(CURDATE(), INTERVAL 9 DAY), '09:00:00', NULL, NULL, NULL, 'One week follow-up scheduled', DATE_ADD(CURDATE(), INTERVAL 27 DAY)),

-- Follow-ups for surgery 2
(2, 7, 2, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:00:00', 'None', 'Bilirubin 1.0 mg/dL - Normal', 'Excellent', 'Post-liver transplant - stable', DATE_ADD(CURDATE(), INTERVAL 10 DAY)),

-- Follow-ups for surgery 3  
(3, 1, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '08:00:00', 'Minimal edema', 'Troponin slightly elevated', 'Good', 'Minor complications resolving', DATE_ADD(CURDATE(), INTERVAL 9 DAY)),

-- Follow-ups for surgery 4
(4, 4, 5, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '11:00:00', NULL, NULL, NULL, 'First week check scheduled', DATE_ADD(CURDATE(), INTERVAL 12 DAY));

-- =====================================================
-- 15. RECIPIENT MEDICATIONS (Post-transplant regimens)
-- =====================================================
INSERT INTO Recipient_Medication (Recipient_ID, Medication_ID, Start_Date, End_Date, Dosage, Frequency, Prescribing_Staff_ID) VALUES
-- Recipient 5 (kidney transplant) - typical immunosuppression regimen
(5, 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NULL, '5mg', 'Twice daily', 1),
(5, 3, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NULL, '10mg', 'Once daily', 1),
(5, 4, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NULL, '500mg', 'Twice daily', 1),
(5, 8, DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 90 DAY), '450mg', 'Twice daily', 1),
(5, 9, DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 180 DAY), '1 tablet', 'Daily', 1),

-- Recipient 7 (liver transplant)
(7, 2, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, '100mg', 'Twice daily', 2),
(7, 3, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, '15mg', 'Once daily', 2),
(7, 4, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, '500mg', 'Twice daily', 2),
(7, 8, DATE_SUB(CURDATE(), INTERVAL 4 DAY), DATE_ADD(CURDATE(), INTERVAL 90 DAY), '450mg', 'Twice daily', 2),

-- Recipient 1 (heart transplant)
(1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '7mg', 'Twice daily', 1),
(1, 3, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '20mg', 'Once daily', 1),
(1, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '1000mg', 'Twice daily', 1),
(1, 18, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '5mg', 'Daily', 1),
(1, 19, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '81mg', 'Daily', 1),

-- Recipient 4 (kidney transplant)
(4, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), NULL, '4mg', 'Twice daily', 5),
(4, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), NULL, '10mg', 'Once daily', 5),
(4, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), NULL, '500mg', 'Twice daily', 5);

-- =====================================================
-- 16. COMPATIBILITY TESTS (Pre-transplant testing)
-- =====================================================
INSERT INTO Compatibility_Test (Donor_ID, Recipient_ID, Test_Type, Test_Date, Test_Result, Compatibility_Score, Performed_By_Staff_ID) VALUES
-- Tests for successful matches
(1, 3, 'Crossmatch', '2024-11-24', 'Compatible', 92.00, 1),
(1, 5, 'HLA Typing', '2024-11-24', 'Compatible', 88.00, 1),
(2, 2, 'Crossmatch', '2024-11-27', 'Compatible', 95.00, 2),
(2, 7, 'HLA Typing', '2024-11-27', 'Compatible', 90.00, 2),
(5, 1, 'Crossmatch', '2024-11-24', 'Compatible', 87.00, 1),
(7, 4, 'HLA Typing', '2024-11-29', 'Compatible', 85.00, 5),

-- Some incompatible tests
(10, 9, 'Crossmatch', '2024-11-20', 'Incompatible', 0.00, 1),
(12, 10, 'Crossmatch', '2024-11-25', 'Partial', 55.00, 2),
(14, 11, 'HLA Typing', '2024-11-22', 'Compatible', 78.00, 4),
(16, 6, 'Crossmatch', '2024-11-26', 'Compatible', 82.00, 1);

-- =====================================================
-- 17. DONOR EMERGENCY CONTACTS
-- =====================================================
INSERT INTO Donor_Emergency_Contact (Donor_ID, Contact_Number, Name, Relationship, Phone, Alternate_Phone, Address, Street_number, Street_name, City, State, Zipcode) VALUES
(1, 1, 'Mary Doe', 'Spouse', '617-555-2001', '617-555-2002', '123 Main St', '123', 'Main St', 'Boston', 'MA', '02114'),
(2, 1, 'John Smith Sr', 'Father', '410-555-2003', NULL, '456 Oak Ave', '456', 'Oak Ave', 'Baltimore', 'MD', '21287'),
(3, 1, 'Lisa Johnson', 'Sister', '507-555-2004', '507-555-2005', '789 Pine Rd', '789', 'Pine Rd', 'Rochester', 'MN', '55905'),
(3, 2, 'Robert Johnson Sr', 'Father', '507-555-2006', NULL, '789 Pine Rd', '789', 'Pine Rd', 'Rochester', 'MN', '55905'),
(5, 1, 'Susan Brown', 'Mother', '310-555-2007', '310-555-2008', '654 Maple Dr', '654', 'Maple Dr', 'Los Angeles', 'CA', '90095'),
(7, 1, 'Carlos Martinez', 'Brother', '212-555-2009', NULL, '147 Birch Ave', '147', 'Birch Ave', 'New York', 'NY', '10065');

-- =====================================================
-- 18. RECIPIENT EMERGENCY CONTACTS
-- =====================================================
INSERT INTO Recipient_Emergency_Contact (Recipient_ID, Contact_Number, Name, Relationship, Phone, Alternate_Phone, Address, Street_number, Street_name, City, State, Zipcode) VALUES
(1, 1, 'Tom Thompson', 'Spouse', '617-555-3001', '617-555-3002', '100 Patient St', '100', 'Patient St', 'Boston', 'MA', '02114'),
(1, 2, 'Sarah Thompson', 'Daughter', '617-555-3003', NULL, '101 College Ave', '101', 'College Ave', 'Cambridge', 'MA', '02138'),
(2, 1, 'Linda Richardson', 'Sister', '410-555-3004', '410-555-3005', '200 Patient Ave', '200', 'Patient Ave', 'Baltimore', 'MD', '21287'),
(3, 1, 'Mark Evans', 'Spouse', '507-555-3006', NULL, '300 Patient Rd', '300', 'Patient Rd', 'Rochester', 'MN', '55905'),
(4, 1, 'Nancy Collins', 'Mother', '216-555-3007', '216-555-3008', '400 Patient Ln', '400', 'Patient Ln', 'Cleveland', 'OH', '44195'),
(5, 1, 'Paul Stewart', 'Spouse', '310-555-3009', NULL, '500 Patient Dr', '500', 'Patient Dr', 'Los Angeles', 'CA', '90095'),
(6, 1, 'George Morris', 'Father', '415-555-3010', '415-555-3011', '600 Patient St', '600', 'Patient St', 'San Francisco', 'CA', '94143'),
(7, 1, 'Diana Rogers', 'Mother', '212-555-3012', NULL, '700 Patient Ave', '700', 'Patient Ave', 'New York', 'NY', '10065');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
SELECT '✓ Sample data loaded successfully!' as Status;

-- Show counts
SELECT 'Organ Types' as Table_Name, COUNT(*) as Record_Count FROM Organ_Type
UNION ALL SELECT 'Medications', COUNT(*) FROM Medication
UNION ALL SELECT 'Users', COUNT(*) FROM User
UNION ALL SELECT 'Hospitals', COUNT(*) FROM Hospital
UNION ALL SELECT 'Hospital Capabilities', COUNT(*) FROM Hospital_Capabilities
UNION ALL SELECT 'Medical Staff', COUNT(*) FROM Medical_Staff
UNION ALL SELECT 'Donors', COUNT(*) FROM Donor
UNION ALL SELECT 'Recipients', COUNT(*) FROM Recipient
UNION ALL SELECT 'Organs', COUNT(*) FROM Organ
UNION ALL SELECT 'Waitlist Entries', COUNT(*) FROM Recipient_Waitlist
UNION ALL SELECT 'Allocations', COUNT(*) FROM Organ_Allocation
UNION ALL SELECT 'Surgeries', COUNT(*) FROM Surgery
UNION ALL SELECT 'Follow-ups', COUNT(*) FROM Follow_Up_Appointment
UNION ALL SELECT 'Compatibility Tests', COUNT(*) FROM Compatibility_Test
UNION ALL SELECT 'Recipient Medications', COUNT(*) FROM Recipient_Medication
UNION ALL SELECT 'Donor Emergency Contacts', COUNT(*) FROM Donor_Emergency_Contact
UNION ALL SELECT 'Recipient Emergency Contacts', COUNT(*) FROM Recipient_Emergency_Contact
UNION ALL SELECT 'Surgery Teams', COUNT(*) FROM Surgery_Performed_By;

-- Show some key statistics
SELECT 
    'Available Organs' as Metric, 
    COUNT(*) as Count 
FROM Organ 
WHERE Status = 'Available'
UNION ALL
SELECT 'Waiting Recipients', COUNT(*) FROM Recipient WHERE Status = 'Waiting'
UNION ALL
SELECT 'Pending Allocations', COUNT(*) FROM Organ_Allocation WHERE Status = 'Pending'
UNION ALL
SELECT 'Completed Surgeries', COUNT(*) FROM Surgery;


CALL MatchOrganToRecipients(1);