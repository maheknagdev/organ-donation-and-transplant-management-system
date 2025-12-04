# Database Connection Information

## Database Details
- **Database Name**: `organ_donation_db`
- **Host**: `localhost`
- **Port**: `3306`
- **Charset**: `utf8mb4`
- **Collation**: `utf8mb4_unicode_ci`

## For SQL Developer (Teammate)

### Connection Setup
```sql
-- You'll need to create the same database on your local MySQL:
CREATE DATABASE organ_donation_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

### Current Tables (After Day 1)
- `core_customuser` - User authentication with roles
- `auth_*` tables - Django authentication
- `django_*` tables - Django admin

### Upcoming Tables (Day 2)
- `core_donor`
- `core_recipient`
- `core_organ`
- `core_hospital`
- `core_medicalstaff`

### Your Work (SQL Developer)
1. **DO NOT** create tables manually
2. Wait for Django developer to run migrations
3. After tables exist, add:
   - Stored procedures (`sql/procedures/`)
   - Triggers (`sql/triggers/`)
   - Views (`sql/views/`)
   - Complex queries (`sql/queries/`)
   - Sample data (`sql/sample_data/`)

### Table Naming
Django uses format: `appname_modelname`
- Model: `Donor` → Table: `core_donor`
- Model: `Recipient` → Table: `core_recipient`

### Field Naming
Django adds `_id` to foreign keys:
- Model: `donor = ForeignKey(Donor)` → Column: `donor_id`

### Workflow
1. Django creates tables via migrations
2. You inspect tables in MySQL Workbench
3. You write SQL scripts based on actual table structure
4. You test SQL scripts
5. Django app calls your procedures/uses your views