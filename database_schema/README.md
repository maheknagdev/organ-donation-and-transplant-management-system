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
