-- Create the database
CREATE DATABASE IF NOT EXISTS organ_donation_db;
-- Use the database
USE organ_donation_db;
-- Number of tables created: 18

-- Organ Table creation
CREATE TABLE Organ_Type (
    Type_Name VARCHAR(30) PRIMARY KEY,
    Typical_Viability_Hours INT NOT NULL,
    Cold_Ischemia_Time_Max INT NOT NULL,
    Description VARCHAR(256),
    Special_Requirements VARCHAR(256)
);

-- Medication Table Creation
CREATE TABLE Medication (
    Medication_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Dosage_Form VARCHAR(50),
    Typical_Dosage VARCHAR(50),
    Purpose VARCHAR(100),
    Side_Effects VARCHAR(256),
    Manufacturer VARCHAR(100)
);

-- User Table Creation
CREATE TABLE User (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password_Hash VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role ENUM('Coordinator', 'Medical_Staff', 'Recipient', 'Administrator') NOT NULL,
    Account_Status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active',
    Created_Date DATE NOT NULL,
    Last_Login DATETIME
);

-- Donor Table Creation
CREATE TABLE Donor (
    Donor_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Blood_Type VARCHAR(3) NOT NULL,
    Gender ENUM('M', 'F', 'Other'),
    Contact_Info VARCHAR(255),
    Donor_Type ENUM('Living', 'Deceased') NOT NULL,
    Medical_History VARCHAR(256),
    Cause_of_Death VARCHAR(255),
    Registration_Date DATE NOT NULL,
    Medical_Clearance_Date DATE,
    Status ENUM('Active', 'Inactive', 'Deceased') DEFAULT 'Active'
);

-- Hospital Table Creation
CREATE TABLE Hospital (
    Hospital_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(255),
    Street_number VARCHAR(20),
    Street_name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Zipcode VARCHAR(10),
    Phone VARCHAR(20),
    Trauma_Level INT,
    OPO_Affiliation VARCHAR(100)
);

-- Tranplant Capabilites Table Creation
CREATE TABLE Hospital_Capabilities (
    Hospital_ID INT NOT NULL,
    Type_Name VARCHAR(30) NOT NULL,
    PRIMARY KEY (Hospital_ID, Type_Name),
    FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Type_Name) REFERENCES Organ_Type(Type_Name) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Medical Staff Table Creation
CREATE TABLE Medical_Staff (
    Staff_ID INT PRIMARY KEY AUTO_INCREMENT,
    Hospital_ID INT,
    Name VARCHAR(100) NOT NULL,
    Specialization ENUM('Transplant_Surgeon', 'Coordinator', 'Nephrologist') NOT NULL,
    License_Number VARCHAR(50) UNIQUE,
    Certification_Date DATE,
    Certification_Level VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Organ Table Creation
CREATE TABLE Organ (
    Organ_ID INT PRIMARY KEY AUTO_INCREMENT,
    Type_Name VARCHAR(30) NOT NULL,
    Donor_ID INT NOT NULL,
    HLA_Type VARCHAR(50),
    Procurement_Date DATE NOT NULL,
    Procurement_Time TIME NOT NULL,
    Size_Weight DECIMAL(10,2),
    Status ENUM('Available', 'Allocated', 'Transplanted', 'Expired') DEFAULT 'Available',
    FOREIGN KEY (Type_Name) REFERENCES Organ_Type(Type_Name) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Recipient Table Creation
CREATE TABLE Recipient (
    Recipient_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Blood_Type VARCHAR(3) NOT NULL,
    Gender ENUM('M', 'F', 'Other'),
    Contact_Info VARCHAR(255),
    Medical_History VARCHAR(256),
    Primary_Diagnosis VARCHAR(255),
    Medical_Urgency_Level INT CHECK (Medical_Urgency_Level BETWEEN 1 AND 5),
    Registration_Date DATE NOT NULL,
    Status ENUM('Waiting', 'Transplanted', 'Deceased', 'Inactive') DEFAULT 'Waiting',
    Insurance_Info VARCHAR(255)
);

-- Surgery Table Creation
CREATE TABLE Surgery (
    Surgery_ID INT PRIMARY KEY AUTO_INCREMENT,
    Hospital_ID INT NOT NULL,
    Organ_ID INT NOT NULL UNIQUE,
    Recipient_ID INT NOT NULL,
    Primary_Surgeon_ID INT NOT NULL,
    Surgery_Date DATE NOT NULL,
    Surgery_Time TIME,
    Duration_Hours DECIMAL(4,2),
    Outcome ENUM('Success', 'Complications', 'Failed'),
    Notes VARCHAR(256),
    Complications_Description VARCHAR(256),
    FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Organ_ID) REFERENCES Organ(Organ_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Primary_Surgeon_ID) REFERENCES Medical_Staff(Staff_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Follow up Appointment Table Creation
CREATE TABLE Follow_Up_Appointment (
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Surgery_ID INT NOT NULL,
    Recipient_ID INT NOT NULL,
    Staff_ID INT NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME,
    Rejection_Indicators VARCHAR(255),
    Lab_Results VARCHAR(256),
    Medication_Adherence VARCHAR(50),
    Notes VARCHAR(256),
    Next_Appointment_Date DATE,
    FOREIGN KEY (Surgery_ID) REFERENCES Surgery(Surgery_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Staff_ID) REFERENCES Medical_Staff(Staff_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Recipient Emergency Contact Table Creation
CREATE TABLE Recipient_Emergency_Contact (
    Recipient_ID INT NOT NULL,
    Contact_Number INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Relationship VARCHAR(50),
    Phone VARCHAR(20) NOT NULL,
    Alternate_Phone VARCHAR(20),
    Address VARCHAR(255),
    Street_number VARCHAR(20),
    Street_name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Zipcode VARCHAR(10),
    PRIMARY KEY (Recipient_ID, Contact_Number),
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Donor Emergency Contact Table Creation
CREATE TABLE Donor_Emergency_Contact (
    Donor_ID INT NOT NULL,
    Contact_Number INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Relationship VARCHAR(50),
    Phone VARCHAR(20) NOT NULL,
    Alternate_Phone VARCHAR(20),
    Address VARCHAR(255),
    Street_number VARCHAR(20),
    Street_name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Zipcode VARCHAR(10),
    PRIMARY KEY (Donor_ID, Contact_Number),
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Waitlist Table Creation
CREATE TABLE Recipient_Waitlist (
    Recipient_ID INT NOT NULL,
    Type_Name VARCHAR(30) NOT NULL,
    Priority_Score DECIMAL(5,2) DEFAULT 0.00,
    Wait_List_Date DATE NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Waiting', 'On Hold', 'Removed')) DEFAULT 'Waiting',
    MELD_Score DECIMAL(5,2),
    CPRA_Score DECIMAL(5,2),
    PRIMARY KEY (Recipient_ID, Type_Name),
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Type_Name) REFERENCES Organ_Type(Type_Name) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Compatibility Test Table Creation
CREATE TABLE Compatibility_Test (
    Test_ID INT PRIMARY KEY AUTO_INCREMENT,
    Donor_ID INT NOT NULL,
    Recipient_ID INT NOT NULL,
    Test_Type VARCHAR(50) NOT NULL,
    Test_Date DATE NOT NULL,
    Test_Result VARCHAR(20) CHECK (Test_Result IN ('Compatible', 'Incompatible', 'Partial')) NOT NULL,
    Compatibility_Score DECIMAL(5,2) DEFAULT 0.00,
    Performed_By_Staff_ID INT,
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Performed_By_Staff_ID) REFERENCES Medical_Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Organ Allocation Table Creation
CREATE TABLE Organ_Allocation (
    Allocation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Organ_ID INT NOT NULL,
    Recipient_ID INT NOT NULL,
    Allocation_Date DATETIME NOT NULL,
    Match_Score DECIMAL(5,2) DEFAULT 0.00,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Accepted', 'Rejected', 'Expired')) DEFAULT 'Pending',
    Response_Deadline DATETIME,
    FOREIGN KEY (Organ_ID) REFERENCES Organ(Organ_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Recipient Medication Table Creation
CREATE TABLE Recipient_Medication (
    Recipient_ID INT NOT NULL,
    Medication_ID INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    Dosage VARCHAR(50) NOT NULL,
    Frequency VARCHAR(50) NOT NULL,
    Prescribing_Staff_ID INT,
    PRIMARY KEY (Recipient_ID, Medication_ID, Start_Date),
    FOREIGN KEY (Recipient_ID) REFERENCES Recipient(Recipient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Medication_ID) REFERENCES Medication(Medication_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Prescribing_Staff_ID) REFERENCES Medical_Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Surgery performed by Table Creation
CREATE TABLE Surgery_Performed_By (
    Surgery_ID INT NOT NULL,
    Staff_ID INT NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Start_Time DATETIME,
    End_Time DATETIME,
    Primary_Surgeon BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (Surgery_ID, Staff_ID),
    FOREIGN KEY (Surgery_ID) REFERENCES Surgery(Surgery_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Staff_ID) REFERENCES Medical_Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Add User_ID to Medical_Staff
ALTER TABLE Medical_Staff 
ADD COLUMN User_ID INT UNIQUE;

ALTER TABLE Medical_Staff
ADD CONSTRAINT fk_medical_staff_user
FOREIGN KEY (User_ID) REFERENCES User(User_ID) ON DELETE SET NULL ON UPDATE CASCADE;

-- Add User_ID to Recipient
ALTER TABLE Recipient
ADD COLUMN User_ID INT UNIQUE;

ALTER TABLE Recipient
ADD CONSTRAINT fk_recipient_user
FOREIGN KEY (User_ID) REFERENCES User(User_ID)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
