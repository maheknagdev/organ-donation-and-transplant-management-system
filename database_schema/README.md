# Database Schema SQL Files

## Overview
Complete MySQL database implementation for the Organ Donation and Transplant Management System.
All tables designed in 3rd Normal Form with proper constraints, relationships, and referential integrity.

## Database Statistics
- **Total Tables:** 18
  - Entity Tables: 10
  - Weak Entity Tables: 2 
  - Junction Tables: 6
- **Stored Procedures:** 4
- **Triggers:** 6
- **Functions:** 4
- **Views:** 5

## Execution Order

Run these files in MySQL in the following order:

1. `schema.sql` - Creates all 18 tables with constraints and relationships
2. `functions.sql` - Creates 4 user-defined functions
3. `procedures.sql` - Creates 4 stored procedures
4. `triggers.sql` - Creates 6 automated triggers
5. `views.sql` - Creates 5 views for reporting and analytics
6. `sample_data.sql` - Inserts test data for demonstration (optional)

## How to Run

### Create Database and Schema
```bash
# Run schema creation
mysql -u root -p organ_donation_db < schema.sql

# Add functions
mysql -u root -p organ_donation_db < functions.sql

# Add stored procedures
mysql -u root -p organ_donation_db < procedures.sql

# Add triggers
mysql -u root -p organ_donation_db < triggers.sql

# Add views
mysql -u root -p organ_donation_db < views.sql

# Load sample data (optional)
mysql -u root -p organ_donation_db < sample_data.sql
```

### Or Run All at Once
```bash
cat schema.sql functions.sql procedures.sql triggers.sql views.sql sample_data.sql | mysql -u root -p organ_donation_db
```

## Table Structure

### Entity Tables (10)
1. **Organ_Type** - Reference table for organ categories (Heart, Kidney, Liver, Lung, Pancreas)
2. **Medication** - Database of transplant-related medications
3. **User** - Authentication and role-based access control
4. **Donor** - Living and deceased organ donors
5. **Hospital** - Medical facilities in transplant network
6. **Recipient** - Patients awaiting organ transplants
7. **Medical_Staff** - Surgeons, coordinators, and medical personnel
8. **Organ** - Individual procured organs with viability tracking
9. **Surgery** - Transplant surgical procedures
10. **Follow_Up_Appointment** - Post-transplant monitoring appointments

### Weak Entity Tables (2)
11. **Donor_Emergency_Contact** - Emergency contacts for donors (composite PK: Donor_ID, Contact_Number)
12. **Recipient_Emergency_Contact** - Emergency contacts for recipients (composite PK: Recipient_ID, Contact_Number)

### Junction Tables (6)
13. **Hospital_Capabilities** - Which organ types each hospital can handle (M:M)
14. **Recipient_Waitlist** - Recipients waiting for organ types with priority scores (M:M)
15. **Compatibility_Test** - Donor-recipient compatibility testing results (M:M)
16. **Organ_Allocation** - Organ allocation offers and responses (M:M)
17. **Recipient_Medication** - Medication prescriptions for recipients (M:M)
18. **Surgery_Performed_By** - Surgical team members and their roles (M:M)

## Key Relationships
- Donor → Organ (1:M)
- Organ_Type → Organ (1:M)
- Hospital → Medical_Staff (1:M)
- Hospital → Surgery (1:M)
- Organ → Surgery (1:1)
- Recipient → Surgery (1:M)
- Surgery → Follow_Up_Appointment (1:M)
- User → Medical_Staff (1:1 optional)
- User → Recipient (1:1 optional)

## Database Features

### Stored Procedures (4)
1. **MatchOrganToRecipients(organ_id)** - Multi-criteria matching algorithm
2. **AllocateOrgan(organ_id, recipient_id)** - Allocation transaction handling
3. **CalculatePriorityScore(recipient_id)** - Dynamic priority calculation
4. **CheckOrganViability(organ_id)** - Real-time viability monitoring

### Triggers (6)
1. **Before Insert on Organ** - Validate donor eligibility
2. **After Insert on Organ** - Automatic matching initiation
3. **Before Update on Organ** - Audit trail logging
4. **After Update on Recipient** - Priority recalculation
5. **Before Delete on Donor** - Referential integrity check
6. **After Insert on Surgery** - Status updates and follow-up scheduling

### Functions (4)
1. **CheckBloodTypeCompatibility(donor_blood, recipient_blood)** - Blood type matching
2. **CalculateCompatibilityScore(donor_id, recipient_id, organ_type)** - Compatibility scoring
3. **GetRemainingViableHours(organ_id)** - Viability countdown
4. **CalculateWaitTimeDays(recipient_id, organ_type)** - Wait time calculation

### Views (5)
1. **Active_Wait_List** - Current recipients waiting, sorted by priority
2. **Available_Organs** - Organs ready for allocation with viability countdown
3. **Transplant_Success_Rate_By_Hospital** - Hospital performance metrics
4. **Critical_Recipients** - High-urgency patients
5. **Upcoming_Follow_Ups** - Scheduled appointments for next 30 days

## Development Status
- [x] Schema design complete (18 tables)
- [ ] Functions implementation
- [ ] Stored procedures implementation
- [ ] Triggers implementation
- [ ] Views implementation
- [ ] Sample data generation

## Notes
- User authentication supports role-based access (Coordinator, Medical_Staff, Recipient, Administrator)
