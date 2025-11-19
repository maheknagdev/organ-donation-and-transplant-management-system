# Database Views

## Required Views

### 1. active_wait_list
- **Purpose**: Current recipients waiting for transplants
- **File**: `active_wait_list.sql`

### 2. available_organs
- **Purpose**: Organs ready for allocation
- **File**: `available_organs.sql`

### 3. transplant_success_rate_by_hospital
- **Purpose**: Success rates by hospital
- **File**: `transplant_success_rate.sql`

### 4. critical_recipients
- **Purpose**: High-urgency patients
- **File**: `critical_recipients.sql`

## Template
```sql
USE organ_donation_db;

DROP VIEW IF EXISTS view_name;

CREATE VIEW view_name AS
SELECT 
    -- Your columns
FROM 
    table_name
WHERE 
    -- Your conditions
ORDER BY 
    -- Your sorting;
```