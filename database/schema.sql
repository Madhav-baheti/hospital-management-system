-- ==============================================================================
-- HOSPITAL MANAGEMENT SYSTEM DATABASE SCHEMA (SQL DDL)
-- Course: Database Management Systems (DBMS)
-- Student: Madhav Baheti | Enrollment No: 25STUCHH010661
-- Institution: IcfaiTech (Faculty of Science & Technology)
-- ==============================================================================

-- 1. DEPARTMENT
CREATE TABLE IF NOT EXISTS DEPARTMENT (
    Dept_id INTEGER PRIMARY KEY,
    Dept_name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(150),
    Phone VARCHAR(15)
);

-- 2. DOCTOR
CREATE TABLE IF NOT EXISTS DOCTOR (
    Doctor_id INTEGER PRIMARY KEY,
    Doctor_name VARCHAR(100) NOT NULL,
    Qualification VARCHAR(100),
    Specialization VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Dept_id INTEGER,
    FOREIGN KEY (Dept_id) REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 3. SERVICE
CREATE TABLE IF NOT EXISTS SERVICE (
    Service_id INTEGER PRIMARY KEY,
    Service_name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Charge DECIMAL(10,2) CHECK (Charge >= 0)
);

-- 4. SCHEDULE
CREATE TABLE IF NOT EXISTS SCHEDULE (
    Schedule_id INTEGER PRIMARY KEY,
    Doctor_id INTEGER,
    Day VARCHAR(20),
    Start_time TIME,
    End_time TIME,
    FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id) ON DELETE CASCADE
);

-- 5. STAFF
CREATE TABLE IF NOT EXISTS STAFF (
    Staff_id INTEGER PRIMARY KEY,
    Staff_name VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Department_id INTEGER,
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL
);

-- 6. PATIENT
CREATE TABLE IF NOT EXISTS PATIENT (
    Patient_id INTEGER PRIMARY KEY,
    Patient_name VARCHAR(100) NOT NULL,
    DOB DATE,
    Gender VARCHAR(20) CHECK (Gender IN ('Male', 'Female', 'Other')),
    Address VARCHAR(255),
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100),
    Blood_group VARCHAR(10),
    Allergies VARCHAR(255)
);

-- 7. APPOINTMENT
CREATE TABLE IF NOT EXISTS APPOINTMENT (
    Appointment_id INTEGER PRIMARY KEY,
    Patient_id INTEGER NOT NULL,
    Doctor_id INTEGER NOT NULL,
    Appointment_date DATE NOT NULL,
    Appointment_time TIME NOT NULL,
    Status VARCHAR(30) DEFAULT 'Scheduled' CHECK (Status IN ('Scheduled', 'In Consultation', 'Completed', 'Cancelled', 'No-Show')),
    Reason VARCHAR(255),
    FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id) ON DELETE RESTRICT
);

-- 8. TEST
CREATE TABLE IF NOT EXISTS TEST (
    Test_id INTEGER PRIMARY KEY,
    Test_name VARCHAR(100) NOT NULL,
    Test_type VARCHAR(100),
    Normal_range VARCHAR(100),
    Charge DECIMAL(10,2) CHECK (Charge >= 0)
);

-- 9. TEST_RESULT
CREATE TABLE IF NOT EXISTS TEST_RESULT (
    Result_id INTEGER PRIMARY KEY,
    Test_id INTEGER NOT NULL,
    Patient_id INTEGER NOT NULL,
    Doctor_id INTEGER,
    Result_date DATE NOT NULL,
    Result VARCHAR(255),
    Remarks VARCHAR(255),
    Status VARCHAR(30) DEFAULT 'Completed' CHECK (Status IN ('Pending', 'Completed', 'Reviewed')),
    FOREIGN KEY (Test_id) REFERENCES TEST(Test_id) ON DELETE RESTRICT,
    FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id) ON DELETE SET NULL
);

-- 10. PRESCRIPTION
CREATE TABLE IF NOT EXISTS PRESCRIPTION (
    Prescription_id INTEGER PRIMARY KEY,
    Doctor_id INTEGER NOT NULL,
    Patient_id INTEGER NOT NULL,
    Prescription_date DATE NOT NULL,
    Notes VARCHAR(255),
    FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id) ON DELETE RESTRICT,
    FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id) ON DELETE CASCADE
);

-- 11. MEDICINE (Catalog for prescriptions)
CREATE TABLE IF NOT EXISTS MEDICINE (
    Medicine_id INTEGER PRIMARY KEY,
    Medicine_name VARCHAR(100) NOT NULL,
    Dosage_form VARCHAR(50),
    Unit_price DECIMAL(10,2) CHECK (Unit_price >= 0)
);

-- 12. PRESCRIPTION_ITEM
CREATE TABLE IF NOT EXISTS PRESCRIPTION_ITEM (
    Prescription_id INTEGER NOT NULL,
    Medicine_id INTEGER NOT NULL,
    Dose VARCHAR(50),
    Frequency VARCHAR(50),
    Duration VARCHAR(50),
    PRIMARY KEY (Prescription_id, Medicine_id),
    FOREIGN KEY (Prescription_id) REFERENCES PRESCRIPTION(Prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (Medicine_id) REFERENCES MEDICINE(Medicine_id) ON DELETE RESTRICT
);

-- 13. ROOM
CREATE TABLE IF NOT EXISTS ROOM (
    Room_id INTEGER PRIMARY KEY,
    Room_no VARCHAR(20) NOT NULL UNIQUE,
    Room_type VARCHAR(50) CHECK (Room_type IN ('General Ward', 'Semi-Private', 'Private Deluxe', 'ICU', 'CCU')),
    Floor INTEGER,
    Daily_charge DECIMAL(10,2) CHECK (Daily_charge >= 0),
    Status VARCHAR(30) DEFAULT 'Available' CHECK (Status IN ('Available', 'Occupied', 'Maintenance'))
);

-- 14. NURSE
CREATE TABLE IF NOT EXISTS NURSE (
    Nurse_id INTEGER PRIMARY KEY,
    Nurse_name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Dept_id INTEGER,
    FOREIGN KEY (Dept_id) REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL
);

-- 15. ADMISSION
CREATE TABLE IF NOT EXISTS ADMISSION (
    Admission_id INTEGER PRIMARY KEY,
    Patient_id INTEGER NOT NULL,
    Doctor_id INTEGER,
    Room_id INTEGER NOT NULL,
    Admission_date DATE NOT NULL,
    Discharge_date DATE,
    Diagnosis VARCHAR(255),
    Status VARCHAR(30) DEFAULT 'Admitted' CHECK (Status IN ('Admitted', 'Discharged', 'Transferred')),
    FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id) ON DELETE SET NULL,
    FOREIGN KEY (Room_id) REFERENCES ROOM(Room_id) ON DELETE RESTRICT
);

-- 16. ADMISSION_NURSE (N:M Assignment)
CREATE TABLE IF NOT EXISTS ADMISSION_NURSE (
    Admission_id INTEGER NOT NULL,
    Nurse_id INTEGER NOT NULL,
    Shift VARCHAR(30),
    PRIMARY KEY (Admission_id, Nurse_id),
    FOREIGN KEY (Admission_id) REFERENCES ADMISSION(Admission_id) ON DELETE CASCADE,
    FOREIGN KEY (Nurse_id) REFERENCES NURSE(Nurse_id) ON DELETE CASCADE
);

-- 17. BILL
CREATE TABLE IF NOT EXISTS BILL (
    Bill_id INTEGER PRIMARY KEY,
    Patient_id INTEGER NOT NULL,
    Admission_id INTEGER,
    Bill_date DATE NOT NULL,
    Total_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (Total_amount >= 0),
    Discount DECIMAL(10,2) DEFAULT 0.00 CHECK (Discount >= 0),
    Net_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (Net_amount >= 0),
    Status VARCHAR(30) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Partial', 'Paid', 'Cancelled')),
    FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (Admission_id) REFERENCES ADMISSION(Admission_id) ON DELETE SET NULL
);

-- 18. BILL_ITEM
CREATE TABLE IF NOT EXISTS BILL_ITEM (
    Bill_item_id INTEGER PRIMARY KEY,
    Bill_id INTEGER NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Unit_price DECIMAL(10,2) CHECK (Unit_price >= 0),
    Quantity INTEGER DEFAULT 1 CHECK (Quantity > 0),
    Amount DECIMAL(10,2) CHECK (Amount >= 0),
    FOREIGN KEY (Bill_id) REFERENCES BILL(Bill_id) ON DELETE CASCADE
);

-- 19. PAYMENT
CREATE TABLE IF NOT EXISTS PAYMENT (
    Payment_id INTEGER PRIMARY KEY,
    Bill_id INTEGER NOT NULL,
    Payment_date DATE NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Payment_mode VARCHAR(50) CHECK (Payment_mode IN ('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Insurance', 'Net Banking')),
    Transaction_no VARCHAR(100) UNIQUE,
    FOREIGN KEY (Bill_id) REFERENCES BILL(Bill_id) ON DELETE CASCADE
);
