# Stored Procedures

## Required Procedures

### 1. MatchOrganToRecipients(organ_id)
- **Purpose**: Find compatible recipients for an organ
- **Returns**: Ranked list with match scores
- **File**: `match_organ_to_recipients.sql`

### 2. AllocateOrgan(organ_id, recipient_id)
- **Purpose**: Allocate organ to recipient
- **Returns**: Allocation ID or error
- **File**: `allocate_organ.sql`

### 3. CalculatePriorityScore(recipient_id)
- **Purpose**: Calculate recipient priority
- **Returns**: Updated priority score
- **File**: `calculate_priority_score.sql`

### 4. CheckOrganViability(organ_id)
- **Purpose**: Check remaining viable hours
- **Returns**: Hours remaining, urgency level
- **File**: `check_organ_viability.sql`

## Template
```sql
USE organ_donation_db;

DROP PROCEDURE IF EXISTS ProcedureName;

DELIMITER $$
CREATE PROCEDURE ProcedureName(IN param_name TYPE)
BEGIN
    -- Your logic here
END$$
DELIMITER ;
```

## Testing Procedures
```sql
-- Test the procedure
CALL ProcedureName(param_value);
```