# SQL Scripts for Organ Donation System

## Important Notes

⚠️ **Django creates the base tables automatically!**
- DO NOT manually create tables
- Django migrations handle table creation
- These scripts ADD functionality ON TOP of Django tables

## Table Naming Convention

Django prefixes tables with app name:
- Model: `Donor` → Table: `core_donor`
- Model: `Recipient` → Table: `core_recipient`
- Model: `CustomUser` → Table: `core_customuser`

## Workflow

1. **Django Developer** creates models and runs migrations
2. **SQL Developer** (you) adds:
   - Stored procedures
   - Triggers
   - Views
   - Complex queries
3. Both work on same database: `organ_donation_and_transplant_db`

## Folder Structure

- `procedures/` - Stored procedures (.sql files)
- `triggers/` - Trigger definitions (.sql files)
- `views/` - Database views (.sql files)
- `queries/` - Complex analytical queries (.sql files)
- `sample_data/` - Test data scripts (.sql files)

## How to Use

1. Wait for Django developer to create tables (Day 2)
2. Connect to `organ_donation_and_transplant_db` in MySQL Workbench
3. Run your SQL scripts to add procedures/triggers/views
4. Test using Django admin or custom views

## Connection Info

- Database: `organ_donation_and_transplant_db`
- Host: `localhost`
- Port: `3306`
- User: `root` (or your MySQL user)

## Current Status

- [x] Database created
- [x] User authentication table (`core_customuser`)
- [ ] Waiting for core models (Donor, Recipient, Organ, etc.)