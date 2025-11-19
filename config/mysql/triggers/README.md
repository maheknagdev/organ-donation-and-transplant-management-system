# Database Triggers

## Required Triggers

### 1. before_insert_organ
- **Table**: `core_organ`
- **When**: BEFORE INSERT
- **Purpose**: Validate donor eligibility
- **File**: `before_insert_organ.sql`

### 2. after_insert_organ
- **Table**: `core_organ`
- **When**: AFTER INSERT
- **Purpose**: Auto-call matching procedure
- **File**: `after_insert_organ.sql`

### 3. after_update_recipient
- **Table**: `core_recipient`
- **When**: AFTER UPDATE (urgency change)
- **Purpose**: Recalculate priority score
- **File**: `after_update_recipient.sql`

### 4. before_delete_donor
- **Table**: `core_donor`
- **When**: BEFORE DELETE
- **Purpose**: Prevent deletion with active organs
- **File**: `before_delete_donor.sql`

## Template
```sql
USE organ_donation_db;

DROP TRIGGER IF EXISTS trigger_name;

DELIMITER $$
CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
BEGIN
    -- Your logic here
END$$
DELIMITER ;
```