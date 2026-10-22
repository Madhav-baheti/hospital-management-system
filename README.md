# MediCare Plus — Hospital Management System (HMS)
### DBMS Mini Project
**Student Name:** Madhav Baheti  
**Enrollment No:** 25STUCHH010661  
**Course:** Database Management Systems (DBMS)  

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/Madhav-baheti/hospital-management-system)

---

## 🌐 Live Cloud Deployment on Render

You can deploy or run this full-stack application on Render with 1 click:
👉 **[Deploy to Render Directly](https://render.com/deploy?repo=https://github.com/Madhav-baheti/hospital-management-system)**

Once deployed, Render provides a free live HTTPS URL (e.g., `https://hospital-management-system.onrender.com`).

---

## 📋 Project Overview & Completed Phases

This project implements an enterprise-grade relational database and clinical doctor dashboard for a **Hospital Management System (HMS)**.

- **Phase 1 (Steps 1 – 7 - Completed previously):**
  - Title Selection & Problem Statement
  - System Objectives & Scope
  - Functional & Non-Functional Requirements
  - Entity-Relationship (ER) Modeling (17 Entities, Cardinalities, Key Notations)
  - Relational Schema Design (3NF Normalization)
  - Base DDL Table Implementations with Primary/Foreign Key Constraints

- **Phase 2 (Steps 8 – 13 - Implemented & Documented):**
  - **Step 8: Advanced SQL Features** (5 Views, 4 Stored Procedures, 4 Triggers, Multi-table Joins & Subqueries)
  - **Step 9: Transaction Management** (ACID Transaction Blocks, Concurrency Control, Row-Level Locking, Savepoints)
  - **Step 10: Indexing & Query Optimization** (B-Tree Composite Indexes, `EXPLAIN QUERY PLAN` Cost Analysis)
  - **Step 11: Testing & Validation** (Referential Integrity, Domain Constraints, Trigger Aborts, Test Cases)
  - **Step 12: Documentation** (Relational Data Dictionary, 3NF Proof, Entity-Relationship Mapping)
  - **Step 13: Presentation & Reporting** (12-Slide Deck Structure, High-Frequency Viva Questions & Model Answers)

---

## 📁 Repository File Structure

```
c:\PROJECTS\HOSPITAL_MANAGEMENT_SYSTEM\
│
├── Hospital_Management_System_Remaining_Steps_8_to_13.pdf  # Generated Formal Project Report (Steps 8-13)
├── generate_report_pdf.py                                  # PDF Generator script using ReportLab
├── app.py                                                  # Flask Backend Application & REST API
├── README.md                                               # Project documentation and run guide
│
├── database/
│   ├── hospital.db               # Active SQLite Database instance with all seed data, views & triggers
│   ├── schema.sql                # SQL DDL table creation script
│   ├── seed_data.sql             # SQL DML dataset (departments, doctors, patients, appointments, etc.)
│   ├── advanced_features.sql     # Step 8 Views & Triggers, Step 10 Indexes
│   ├── mysql_full_script.sql     # Complete MySQL script (Procedures with DELIMITER //, Triggers, Views)
│   └── db_manager.py             # Python database controller with transaction management logic
│
├── templates/
│   └── index.html                # Doctor Dashboard UI (inspired by Dribbble reference)
│
└── static/
    ├── style.css                 # Polished healthcare CSS design system
    └── app.js                    # Frontend asynchronous API interaction & SQL Studio console
```

---

## 🚀 How to Run the System

### 1. Start the Doctor Dashboard & API Server:
In PowerShell / Command Prompt:
```powershell
python app.py
```
Open your browser and navigate to:
```
http://localhost:5000
```

### 2. Regenerate the Steps 8 to 13 PDF Report:
```powershell
python generate_report_pdf.py
```
The PDF is saved as:
`Hospital_Management_System_Remaining_Steps_8_to_13.pdf`

---

## 🩺 Doctor Dashboard UI Features (Dribbble Reference Design)

1. **Doctor Switcher & Dynamic Profile:**
   - Seamlessly switch active doctors (e.g., Dr. Sarah Jenkins - Cardiologist, Dr. Rajesh Sharma - Neurosurgeon).
2. **Top KPI Metric Cards:**
   - Active Patients count, Today's Consultations (Scheduled vs Completed), Hospital Bed Availability, and Pending Labs.
3. **Today's Consultation Hub:**
   - Real-time queue populated from SQL View `v_doctor_appointments`.
   - Actions to Start Consultation, Mark Completed, or Write Digital Prescriptions.
4. **Bed & In-Patient Ward Tracker:**
   - Live room status populated from SQL View `v_admitted_patients_summary`.
   - One-click discharge calculation and automated billing via Step 8/9 stored procedures.
5. **Interactive SQL Studio:**
   - Built-in evaluation console to execute custom SQL queries directly against the database with execution time and formatted result tables.
