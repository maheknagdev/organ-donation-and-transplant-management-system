# Database Schema SQL Files

## Execution Order

Run these files in MySQL in the following order:

1. `schema.sql` - Creates all tables with constraints
2. `functions.sql` - Creates user-defined functions
3. `procedures.sql` - Creates stored procedures
4. `triggers.sql` - Creates triggers
5. `views.sql` - Creates views

## How to Run
```bash
mysql -u root -p organ_donation_db < schema.sql
mysql -u root -p organ_donation_db < functions.sql
mysql -u root -p organ_donation_db < procedures.sql
mysql -u root -p organ_donation_db < triggers.sql
mysql -u root -p organ_donation_db < views.sql
```

## Database Details
- Total Tables: 17 (12 entity tables + 5 junction tables)
- Stored Procedures: 4
- Triggers: 6
- Functions: 4
- Views: 5