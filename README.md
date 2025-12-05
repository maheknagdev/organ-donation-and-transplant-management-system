# 🏥 Organ Donation and Transplant Management System

## 🎯 System Overview

A comprehensive database-driven application managing the complete organ donation lifecycle:
1. Donor registration and organ procurement
2. Automated recipient matching using multi-criteria algorithms
3. Priority-based waitlist management
4. Organ allocation with viability tracking
5. Surgery scheduling with automated workflows
6. Post-transplant follow-up care

**Key Innovation:** Automated matching algorithm with weighted scoring system (Blood: 30%, HLA: 25%, Wait Time: 20%, Geographic: 15%, Urgency: 10%)

---

## 💻 Prerequisites

### **Required Software**

1. **Python 3.13 or higher**
   - Download: https://www.python.org/downloads/
   - Installation: ✅ Check "Add Python to PATH"
   - Verify: `python --version`

2. **MySQL 8.0 or higher**
   - Download: https://dev.mysql.com/downloads/installer/
   - Components needed:
     - MySQL Server
     - MySQL Workbench
   - Verify: `mysql --version`

3. **Git** (Optional but recommended)
   - Download: https://git-scm.com/downloads

4. **Code Editor**
   - Recommended: Visual Studio Code (https://code.visualstudio.com/)
   - Alternative: PyCharm, Sublime Text

---

## 📦 Installation Steps

### **1. Clone or Download Project**

```bash
# Using Git
git clone git@github.com:maheknagdev/organ-donation-and-transplant-management-system.git

# OR download ZIP and extract
```

### **2. Set Up Python Virtual Environment**

```bash
# Create virtual environment
python -m venv odts_env

# Activate virtual environment
# Windows:
odts_env\Scripts\activate

# Mac/Linux:
source odts_env/bin/activate
```

**✅ Success:** Terminal shows `(odts_env)` prefix

### **3. Install Python Dependencies**

```bash
# Install all required packages
pip install -r requirements.txt
```

**If you encounter mysqlclient installation errors on Windows:**
```bash
pip uninstall mysqlclient
pip install pymysql
```

Then create `config/__init__.py` with:
```python
import pymysql
pymysql.install_as_MySQLdb()
```

---

## 🗄️ Database Configuration

### **Step 1: Create MySQL Database**

**Open MySQL Workbench**

**Connect to MySQL** (localhost, root user)

**Run this command:**
```sql
CREATE DATABASE organ_donation_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

### **Step 2: Load Database Schema**

**Execute SQL files in this EXACT order:**

```sql
-- In MySQL Workbench, File → Open SQL Script → Run each file:

-- File 1: Create all tables
SOURCE /path/to/sql/schema/schema.sql;

-- File 2: Create functions
SOURCE /path/to/sql/functions/functions.sql;

-- File 3: Create stored procedures
SOURCE /path/to/sql/procedures/procedures.sql;

-- File 4: Create triggers
SOURCE /path/to/sql/triggers/triggers.sql;

-- File 5: Create views
SOURCE /path/to/sql/views/views.sql;

-- File 6: Load sample data
SOURCE /path/to/sql/sample_data/sample_data.sql;
```

**⚠️ Note:** Replace `/path/to/` with your actual file path

**OR run SQL directly in Workbench:**
- Open each .sql file
- Execute (⚡ lightning bolt icon)

### **Step 3: Verify Database Setup**

```sql
USE organ_donation_db;

-- Should show ~28 tables (18 custom + 10 Django)
SHOW TABLES;

-- Should show 4 procedures
SHOW PROCEDURE STATUS WHERE Db = 'organ_donation_db';

-- Should show 6 triggers
SHOW TRIGGERS;

-- Should show 5 views
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Test matching procedure
CALL MatchOrganToRecipients(1);
```

### **Step 4: Configure Django Settings**

**Edit:** `config/settings.py`

**Find `DATABASES` section (around line 75) and update:**

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'organ_donation_db',
        'USER': 'root',                    # YOUR MySQL username
        'PASSWORD': 'YOUR_MYSQL_PASSWORD', # YOUR MySQL password
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
            'charset': 'utf8mb4',
        },
    }
}
```

**⚠️ CRITICAL:** Replace `YOUR_MYSQL_PASSWORD` with your actual MySQL password!

---

## ▶️ Running the Application

### **Step 1: Apply Django Migrations**

```bash
# Navigate to project directory
cd organ-donation-and-transplant-management-system

# Activate virtual environment (if not already)
odts_env\Scripts\activate

# Apply Django's built-in migrations
python manage.py migrate

# Verify no errors
python manage.py check
```

**Expected output:**
```
System check identified no issues (0 silenced).
```

### **Step 2: Create Django Superuser** (Optional)

```bash
python manage.py createsuperuser

# Enter credentials:
Username: admin
Email: admin@example.com
Password: admin123
```

### **Step 3: Start Development Server**

```bash
python manage.py runserver
```

**✅ Server runs at:** http://127.0.0.1:8000/

**Expected output:**
```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
Django version 5.2.8, using settings 'config.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
```

### **Step 4: Access Application**

**Open browser and visit:**
- **Login Page:** http://127.0.0.1:8000/login/
- **Main Dashboard:** http://127.0.0.1:8000/
- **Django Admin:** http://127.0.0.1:8000/admin/

---

## 🔐 Default User Accounts

Sample data includes pre-configured test accounts:

| Username | Password | Role | Access Level |
|----------|----------|------|--------------|
| `admin` | `admin123` | Administrator | Full system access, all operations |
| `dr_smith` | `password123` | Medical_Staff | Clinical operations, organ management |
| `coordinator_mary` | `password123` | Coordinator | Registration, waitlist management |
| `patient_alice` | `password123` | Recipient | Personal dashboard, respond to offers |

---

## 🎯 Quick Start Guide

### **First-Time Setup (10 minutes):**

1. **Create database** in MySQL Workbench
2. **Run all SQL scripts** (schema → functions → procedures → triggers → views → data)
3. **Update** `config/settings.py` with your MySQL password
4. **Run** `python manage.py migrate`
5. **Start server** with `python manage.py runserver`
6. **Login** at http://127.0.0.1:8000/login/

### **Quick Functional Test:**

1. Login as `admin` / `admin123`
2. View dashboard with statistics
3. Navigate to "Available Organs"
4. Click "🎯 Find Matches" on Organ #1
5. See ranked list of compatible recipients ← Stored procedure works!

---

## 📂 Project Structure

```
organ-donation-and-transplant-management-system/
├── apps/
│   ├── __init__.py
│   └── core/
│       ├── migrations/              # Django migrations
│       ├── templates/core/          # HTML templates (20+ files)
│       ├── __init__.py
│       ├── admin.py                # Django admin configuration
│       ├── apps.py                 # App configuration
│       ├── decorators.py           # Access control decorators
│       ├── models.py               # Django models (18 tables)
│       ├── urls.py                 # URL routing
│       └── views.py                # Application logic (~700 lines)
├── config/
│   ├── __init__.py
│   ├── settings.py                # Django settings ⚠️ EDIT THIS
│   ├── urls.py                    # Main URL configuration
│   ├── asgi.py
│   └── wsgi.py
├── sql/
│   ├── schema.sql      # 18 table definitions
│   ├── functions.sql          # 4 MySQL functions
│   ├── procedures.sql         # 4 stored procedures
│   ├── triggers.sql           # 6 automated triggers
│   ├── views.sql              # 5 database views
│   └── sample_data.sql        # Test data (realistic dataset)
├── odts_env/                      # Virtual environment (not in git)
├── manage.py                      # Django management script
├── requirements.txt               # Python dependencies
├── README.md                      # This file
├── .gitignore                    # Git ignore rules
└── DATABASE_SCHEMA.md            # Detailed schema documentation
```

---

## 🔧 Database Features

### **18 Database Tables (3NF Normalized):**

**Primary Entities (10):**
1. Organ_Type (Reference table)
2. Medication
3. User (Authentication)
4. Donor
5. Hospital
6. Recipient
7. Medical_Staff
8. Organ
9. Surgery
10. Follow_Up_Appointment

**Weak Entities (2):**
11. Donor_Emergency_Contact
12. Recipient_Emergency_Contact

**Junction Tables (6):**
13. Hospital_Capabilities
14. Recipient_Waitlist
15. Compatibility_Test
16. Organ_Allocation
17. Recipient_Medication
18. Surgery_Performed_By

### **4 Stored Procedures:**

| Procedure | Purpose | Calls Functions |
|-----------|---------|-----------------|
| `MatchOrganToRecipients(organ_id)` | Multi-criteria matching | CheckBloodTypeCompatibility, CalculateWaitTimeDays |
| `AllocateOrgan(organ_id, recipient_id)` | Create allocation record | GetRemainingViableHours, CalculateCompatibilityScore |
| `CalculatePriorityScore(recipient_id, organ_type)` | Calculate waitlist priority | CalculateWaitTimeDays |
| `CheckOrganViability(organ_id)` | Check organ expiration | GetRemainingViableHours |

### **6 Automated Triggers:**

| Trigger | Event | Actions |
|---------|-------|---------|
| `before_organ_insert` | Before organ creation | Validates donor eligibility and clearance |
| `after_organ_insert` | After organ creation | Auto-matches top 3 recipients, creates allocations |
| `before_organ_update` | Before organ update | Prevents invalid status changes (transplanted→available) |
| `after_recipient_update` | After urgency change | Recalculates all priority scores |
| `before_donor_delete` | Before donor deletion | Prevents deletion if active organs exist |
| `after_surgery_insert` | After surgery creation | 5 actions: Updates organ/recipient status, removes from waitlist, accepts allocation, creates follow-up |

### **4 Custom Functions:**

| Function | Returns | Used In |
|----------|---------|---------|
| `CheckBloodTypeCompatibility(donor, recipient)` | BOOLEAN | Procedures, views |
| `CalculateWaitTimeDays(recipient_id, organ_type)` | INT | Procedures, views, queries |
| `GetRemainingViableHours(organ_id)` | DECIMAL | Procedures, views |
| `CalculateCompatibilityScore(donor, recipient, type)` | DECIMAL | Procedures |

### **5 MySQL Views:**

| View | Purpose | Joins |
|------|---------|-------|
| `active_wait_list` | Current waitlist by priority | Recipient + Recipient_Waitlist |
| `available_organs` | Organs with viability countdown | Organ + Donor + Organ_Type |
| `critical_recipients` | High-urgency patients | Recipient + Recipient_Waitlist |
| `transplant_success_rate_by_hospital` | Hospital performance | Hospital + Surgery |
| `upcoming_follow_ups` | Appointments next 30 days | 4-table join |

---

## 🔍 MySQL Features Call Chain

### **How Procedures Call Functions:**

```
MatchOrganToRecipients(organ_id)
├── CheckBloodTypeCompatibility(donor_blood, recipient_blood)
├── CalculateWaitTimeDays(recipient_id, organ_type)
└── Returns: Top 10 ranked recipients

AllocateOrgan(organ_id, recipient_id)
├── GetRemainingViableHours(organ_id)
├── CalculateCompatibilityScore(donor_id, recipient_id, organ_type)
│   └── CheckBloodTypeCompatibility() [nested call]
└── Returns: Allocation ID or error message

CalculatePriorityScore(recipient_id, organ_type)
├── CalculateWaitTimeDays(recipient_id, organ_type)
└── Returns: Priority score breakdown

CheckOrganViability(organ_id)
├── GetRemainingViableHours(organ_id)
└── Returns: Hours remaining + urgency level
```

### **Trigger Execution Flow:**

```
1. User creates organ via Django
   ↓
2. before_organ_insert TRIGGER fires
   ├── Validates donor has medical clearance
   ├── Checks donor status is Active/Deceased
   └── Blocks insert if validation fails
   ↓
3. Organ inserted into database
   ↓
4. after_organ_insert TRIGGER fires
   ├── Calls MatchOrganToRecipients(NEW.Organ_ID)
   ├── Creates 3 allocation records for top matches
   └── Sets status to 'Pending'
   ↓
5. Allocations appear in Django immediately
```

```
1. User creates surgery via Django
   ↓
2. after_surgery_insert TRIGGER fires
   ├── Action 1: UPDATE Organ SET Status='Transplanted'
   ├── Action 2: UPDATE Recipient SET Status='Transplanted'
   ├── Action 3: DELETE FROM Recipient_Waitlist
   ├── Action 4: UPDATE Organ_Allocation SET Status='Accepted'
   └── Action 5: INSERT INTO Follow_Up_Appointment (1 week later)
   ↓
3. All 5 changes committed in single transaction
```

---

## 👥 User Roles & Permissions

### **Role-Based Access Matrix:**

| Feature | Recipient | Coordinator | Medical_Staff | Administrator |
|---------|-----------|-------------|---------------|---------------|
| **Dashboard** | Own data only | Full stats | Full stats | Full stats |
| **View Organs** | ✅ Read-only | ✅ Read-only | ✅ + Actions | ✅ + Actions |
| **Match Organ** | ❌ | ❌ | ✅ | ✅ |
| **Allocate Organ** | ❌ | ❌ | ✅ | ✅ |
| **Create Organ** | ❌ | ❌ | ✅ | ✅ |
| **Register Donor** | ❌ | ✅ | ❌ | ✅ |
| **Register Recipient** | ❌ | ✅ | ❌ | ✅ |
| **Manage Waitlist** | ❌ | ✅ | ❌ | ✅ |
| **Calculate Priority** | ❌ | ✅ | ✅ | ✅ |
| **Respond to Offer** | ✅ Own only | ✅ All | ✅ All | ✅ All |
| **Schedule Surgery** | ❌ | ❌ | ✅ | ✅ |
| **View Reports** | ❌ | ✅ | ✅ | ✅ |
| **Admin Panel** | ❌ | ❌ | ❌ | ✅ |

---

## 🧪 Testing Guide

### **Complete Workflow Test (15 minutes):**

**Login as Administrator:** http://127.0.0.1:8000/login/
- Username: `admin` / Password: `admin123`

**1. Register Donor:**
- Navigate to Donors → Register New Donor
- Creates donor with medical clearance

**2. Record Organ Procurement:**
- Navigate to Organs → Record Organ
- ✅ **Triggers fire:** Validates donor + auto-matches recipients

**3. Match Organ:**
- Click "🎯 Find Matches" on any organ
- ✅ **Stored Procedure:** MatchOrganToRecipients shows ranked list

**4. Check Viability:**
- Click "⏱️ Viability" on any organ
- ✅ **Stored Procedure:** CheckOrganViability shows countdown

**5. Allocate Organ:**
- Click "✓ Allocate" on available organ
- Select top-ranked recipient
- ✅ **Stored Procedure:** AllocateOrgan creates allocation

**6. Accept Allocation:**
- Navigate to Allocations
- Respond → Accept

**7. Schedule Surgery:**
- Navigate to Surgeries → Create Surgery
- Select allocated organ-recipient pair
- ✅ **Trigger fires:** 5 automatic database updates!

**8. Verify Trigger Effects:**
- Organ status → Transplanted ✓
- Recipient status → Transplanted ✓
- Removed from waitlist ✓
- Allocation accepted ✓
- Follow-up created ✓

---

## 🛠️ Troubleshooting

### **Issue: "mysqlclient won't install"**
```bash
# Windows alternative:
pip install pymysql

# Then add to config/__init__.py:
import pymysql
pymysql.install_as_MySQLdb()
```

### **Issue: "Access denied for user 'root'"**
- Check password in `config/settings.py`
- Verify MySQL service is running (Services → MySQL)
- Test connection in MySQL Workbench first

### **Issue: "Table doesn't exist"**
- Verify all SQL scripts ran successfully
- Check: `SHOW TABLES;` in MySQL
- Re-run schema creation scripts

### **Issue: "Stored procedure not found"**
```sql
-- Check procedures exist
SHOW PROCEDURE STATUS WHERE Db = 'organ_donation_db';

-- If missing, re-run:
SOURCE sql/procedures/procedures.sql;
```

### **Issue: "No compatible recipients found"**
- Recipient must be on waitlist for THAT organ type
- Check: `SELECT * FROM Recipient_Waitlist;`
- Add recipient to waitlist before matching

### **Issue: "Virtual environment not activating"**
```bash
# PowerShell issue - run this once:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then activate:
odts_env\Scripts\activate
```

### **Issue: "Port 8000 already in use"**
```bash
# Use different port:
python manage.py runserver 8001

# Or find and kill process:
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

---

## 📊 Database Statistics

**After loading sample data:**
- Organ Types: 5
- Medications: 20
- Users: 10
- Hospitals: 10
- Medical Staff: 15
- Donors: 25
- Recipients: 35
- Organs: 18
- Waitlist Entries: 31
- Allocations: 10
- Surgeries: 4
- Follow-ups: 5+

---

## 📄 Project Deliverables

This project includes:
- ✅ Complete MySQL database schema (18 tables, 3NF)
- ✅ 4 Stored procedures
- ✅ 6 Automated triggers
- ✅ 5 Database views
- ✅ 4 Custom functions
- ✅ Full-stack Django web application
- ✅ 4 user role workflows
- ✅ Comprehensive error handling
- ✅ Sample data for testing
- ✅ Complete documentation

**Bonus Features Implemented:**
- Complex analytical queries
- Web-based GUI with role-based access
- Multi-table joins (5+ tables)
- Automated workflow triggers
- Real-time data visualization

---

## 🙏 Acknowledgments

**Data Source:**
- OPTN Database: https://optn.transplant.hrsa.gov/data/

**Technologies:**
- Django: https://www.djangoproject.com/
- MySQL: https://www.mysql.com/
- Python: https://www.python.org/

---

**Last Updated:** December 5, 2024  
**Version:** 1.0  
**License:** Academic Project - Educational Use Only