# Sample Data Scripts

## Files

- `01_sample_donors.sql` - 20+ sample donors
- `02_sample_recipients.sql` - 30+ sample recipients
- `03_sample_organs.sql` - 15+ sample organs
- `04_sample_allocations.sql` - Sample allocations

## How to Load
```sql
USE organ_donation_db;

-- Load in order
SOURCE sample_data/01_sample_donors.sql;
SOURCE sample_data/02_sample_recipients.sql;
SOURCE sample_data/03_sample_organs.sql;
SOURCE sample_data/04_sample_allocations.sql;
```

## Important

- Wait for Django to create tables first!
- Use correct table names (e.g., `core_donor`, not `donor`)
```

---

## 🔒 **PART 2: Create .gitignore** (2 minutes)

**Create file: `.gitignore`** in project root
```
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
odts_env/
venv/
env/
ENV/

# Django
*.log
db.sqlite3
db.sqlite3-journal
/media
/staticfiles

# Database
*.sql.backup

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Environment variables
.env

# Personal notes
notes.txt
TODO.md