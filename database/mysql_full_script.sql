-- ==============================================================================
-- HOSPITAL MANAGEMENT SYSTEM COMPLETE MYSQL SCRIPT
-- Steps 1 through 11: DDL, Constraints, Seed DML, Views, Stored Procedures,
-- Triggers, Transactions, and Indexing
-- Course: Database Management Systems (DBMS)
-- Student: Madhav Baheti | Enrollment No: 25STUCHH010661
-- Institution: IcfaiTech (Faculty of Science & Technology)
-- ==============================================================================

DROP DATABASE IF EXISTS hospital_management_system;
CREATE DATABASE hospital_management_system;
USE hospital_management_system;

-- ------------------------------------------------------------------------------
-- DDL TABLE DEFINITIONS (STEP 7)
-- ------------------------------------------------------------------------------

CREATE TABLE DEPARTMENT (
    Dept_id INT PRIMARY KEY,
    Dept_name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(150),
    Phone VARCHAR(15)
) ENGINE=InnoDB;

CREATE TABLE DOCTOR (
    Doctor_id INT PRIMARY KEY,
    Doctor_name VARCHAR(100) NOT NULL,
    Qualification VARCHAR(100),
    Specialization VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Dept_id INT,
    CONSTRAINT fk_doctor_department FOREIGN KEY (Dept_id) 
        REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SERVICE (
    Service_id INT PRIMARY KEY,
    Service_name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Charge DECIMAL(10,2) CHECK (Charge >= 0)
) ENGINE=InnoDB;

CREATE TABLE SCHEDULE (
    Schedule_id INT PRIMARY KEY,
    Doctor_id INT,
    Day VARCHAR(20),
    Start_time TIME,
    End_time TIME,
    CONSTRAINT fk_schedule_doctor FOREIGN KEY (Doctor_id) 
        REFERENCES DOCTOR(Doctor_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE STAFF (
    Staff_id INT PRIMARY KEY,
    Staff_name VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Department_id INT,
    CONSTRAINT fk_staff_department FOREIGN KEY (Department_id) 
        REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE PATIENT (
    Patient_id INT PRIMARY KEY,
    Patient_name VARCHAR(100) NOT NULL,
    DOB DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    Address VARCHAR(255),
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100),
    Blood_group VARCHAR(10),
    Allergies VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE APPOINTMENT (
    Appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_id INT NOT NULL,
    Doctor_id INT NOT NULL,
    Appointment_date DATE NOT NULL,
    Appointment_time TIME NOT NULL,
    Status ENUM('Scheduled', 'In Consultation', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    Reason VARCHAR(255),
    CONSTRAINT fk_appointment_patient FOREIGN KEY (Patient_id) 
        REFERENCES PATIENT(Patient_id) ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (Doctor_id) 
        REFERENCES DOCTOR(Doctor_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE TEST (
    Test_id INT PRIMARY KEY,
    Test_name VARCHAR(100) NOT NULL,
    Test_type VARCHAR(100),
    Normal_range VARCHAR(100),
    Charge DECIMAL(10,2) CHECK (Charge >= 0)
) ENGINE=InnoDB;

CREATE TABLE TEST_RESULT (
    Result_id INT PRIMARY KEY AUTO_INCREMENT,
    Test_id INT NOT NULL,
    Patient_id INT NOT NULL,
    Doctor_id INT,
    Result_date DATE NOT NULL,
    Result VARCHAR(255),
    Remarks VARCHAR(255),
    Status ENUM('Pending', 'Completed', 'Reviewed') DEFAULT 'Completed',
    CONSTRAINT fk_result_test FOREIGN KEY (Test_id) 
        REFERENCES TEST(Test_id) ON DELETE RESTRICT,
    CONSTRAINT fk_result_patient FOREIGN KEY (Patient_id) 
        REFERENCES PATIENT(Patient_id) ON DELETE CASCADE,
    CONSTRAINT fk_result_doctor FOREIGN KEY (Doctor_id) 
        REFERENCES DOCTOR(Doctor_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE PRESCRIPTION (
    Prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_id INT NOT NULL,
    Patient_id INT NOT NULL,
    Prescription_date DATE NOT NULL,
    Notes VARCHAR(255),
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (Doctor_id) 
        REFERENCES DOCTOR(Doctor_id) ON DELETE RESTRICT,
    CONSTRAINT fk_prescription_patient FOREIGN KEY (Patient_id) 
        REFERENCES PATIENT(Patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE MEDICINE (
    Medicine_id INT PRIMARY KEY,
    Medicine_name VARCHAR(100) NOT NULL,
    Dosage_form VARCHAR(50),
    Unit_price DECIMAL(10,2) CHECK (Unit_price >= 0)
) ENGINE=InnoDB;

CREATE TABLE PRESCRIPTION_ITEM (
    Prescription_id INT NOT NULL,
    Medicine_id INT NOT NULL,
    Dose VARCHAR(50),
    Frequency VARCHAR(50),
    Duration VARCHAR(50),
    PRIMARY KEY (Prescription_id, Medicine_id),
    CONSTRAINT fk_prescription_item_prescription FOREIGN KEY (Prescription_id) 
        REFERENCES PRESCRIPTION(Prescription_id) ON DELETE CASCADE,
    CONSTRAINT fk_prescription_item_medicine FOREIGN KEY (Medicine_id) 
        REFERENCES MEDICINE(Medicine_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE ROOM (
    Room_id INT PRIMARY KEY,
    Room_no VARCHAR(20) NOT NULL UNIQUE,
    Room_type ENUM('General Ward', 'Semi-Private', 'Private Deluxe', 'ICU', 'CCU'),
    Floor INT,
    Daily_charge DECIMAL(10,2) CHECK (Daily_charge >= 0),
    Status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available'
) ENGINE=InnoDB;

CREATE TABLE NURSE (
    Nurse_id INT PRIMARY KEY,
    Nurse_name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Dept_id INT,
    CONSTRAINT fk_nurse_department FOREIGN KEY (Dept_id) 
        REFERENCES DEPARTMENT(Dept_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE ADMISSION (
    Admission_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_id INT NOT NULL,
    Doctor_id INT,
    Room_id INT NOT NULL,
    Admission_date DATE NOT NULL,
    Discharge_date DATE,
    Diagnosis VARCHAR(255),
    Status ENUM('Admitted', 'Discharged', 'Transferred') DEFAULT 'Admitted',
    CONSTRAINT fk_admission_patient FOREIGN KEY (Patient_id) 
        REFERENCES PATIENT(Patient_id) ON DELETE RESTRICT,
    CONSTRAINT fk_admission_doctor FOREIGN KEY (Doctor_id) 
        REFERENCES DOCTOR(Doctor_id) ON DELETE SET NULL,
    CONSTRAINT fk_admission_room FOREIGN KEY (Room_id) 
        REFERENCES ROOM(Room_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE ADMISSION_NURSE (
    Admission_id INT NOT NULL,
    Nurse_id INT NOT NULL,
    Shift VARCHAR(30),
    PRIMARY KEY (Admission_id, Nurse_id),
    CONSTRAINT fk_admission_nurse_adm FOREIGN KEY (Admission_id) 
        REFERENCES ADMISSION(Admission_id) ON DELETE CASCADE,
    CONSTRAINT fk_admission_nurse_nurse FOREIGN KEY (Nurse_id) 
        REFERENCES NURSE(Nurse_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE BILL (
    Bill_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_id INT NOT NULL,
    Admission_id INT,
    Bill_date DATE NOT NULL,
    Total_amount DECIMAL(10,2) DEFAULT 0.00,
    Discount DECIMAL(10,2) DEFAULT 0.00,
    Net_amount DECIMAL(10,2) DEFAULT 0.00,
    Status ENUM('Pending', 'Partial', 'Paid', 'Cancelled') DEFAULT 'Pending',
    CONSTRAINT fk_bill_patient FOREIGN KEY (Patient_id) 
        REFERENCES PATIENT(Patient_id) ON DELETE RESTRICT,
    CONSTRAINT fk_bill_admission FOREIGN KEY (Admission_id) 
        REFERENCES ADMISSION(Admission_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE BILL_ITEM (
    Bill_item_id INT PRIMARY KEY AUTO_INCREMENT,
    Bill_id INT NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Unit_price DECIMAL(10,2) CHECK (Unit_price >= 0),
    Quantity INT DEFAULT 1 CHECK (Quantity > 0),
    Amount DECIMAL(10,2) CHECK (Amount >= 0),
    CONSTRAINT fk_bill_item_bill FOREIGN KEY (Bill_id) 
        REFERENCES BILL(Bill_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PAYMENT (
    Payment_id INT PRIMARY KEY AUTO_INCREMENT,
    Bill_id INT NOT NULL,
    Payment_date DATE NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Payment_mode ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Insurance', 'Net Banking'),
    Transaction_no VARCHAR(100) UNIQUE,
    CONSTRAINT fk_payment_bill FOREIGN KEY (Bill_id) 
        REFERENCES BILL(Bill_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- ------------------------------------------------------------------------------
-- STEP 8: VIEWS
-- ------------------------------------------------------------------------------

CREATE VIEW v_doctor_appointments AS
SELECT 
    a.Appointment_id,
    d.Doctor_id,
    d.Doctor_name,
    d.Specialization,
    p.Patient_id,
    p.Patient_name,
    p.Gender,
    p.Phone AS Patient_Phone,
    a.Appointment_date,
    a.Appointment_time,
    a.Status,
    a.Reason
FROM APPOINTMENT a
JOIN DOCTOR d ON a.Doctor_id = d.Doctor_id
JOIN PATIENT p ON a.Patient_id = p.Patient_id;

CREATE VIEW v_admitted_patients_summary AS
SELECT 
    adm.Admission_id,
    p.Patient_id,
    p.Patient_name,
    p.Gender,
    p.Blood_group,
    d.Doctor_name AS Attending_Doctor,
    r.Room_id,
    r.Room_no,
    r.Room_type,
    r.Daily_charge,
    adm.Admission_date,
    adm.Diagnosis,
    adm.Status AS Admission_Status
FROM ADMISSION adm
JOIN PATIENT p ON adm.Patient_id = p.Patient_id
LEFT JOIN DOCTOR d ON adm.Doctor_id = d.Doctor_id
JOIN ROOM r ON adm.Room_id = r.Room_id
WHERE adm.Status = 'Admitted';

CREATE VIEW v_department_analytics AS
SELECT 
    dept.Dept_id,
    dept.Dept_name,
    dept.Location,
    COUNT(DISTINCT d.Doctor_id) AS Total_Doctors,
    COUNT(DISTINCT a.Appointment_id) AS Total_Appointments,
    COUNT(DISTINCT adm.Admission_id) AS Total_Admissions
FROM DEPARTMENT dept
LEFT JOIN DOCTOR d ON dept.Dept_id = d.Dept_id
LEFT JOIN APPOINTMENT a ON d.Doctor_id = a.Doctor_id
LEFT JOIN ADMISSION adm ON d.Doctor_id = adm.Doctor_id
GROUP BY dept.Dept_id, dept.Dept_name, dept.Location;

-- ------------------------------------------------------------------------------
-- STEP 8: STORED PROCEDURES (MYSQL DELIMITER)
-- ------------------------------------------------------------------------------

DELIMITER //

-- Procedure 1: Admit Patient and Mark Room Occupied
CREATE PROCEDURE sp_admit_patient(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_room_id INT,
    IN p_diagnosis VARCHAR(255),
    OUT p_admission_id INT
)
BEGIN
    DECLARE v_room_status VARCHAR(30);
    
    START TRANSACTION;
    
    -- Check room status with row lock
    SELECT Status INTO v_room_status 
    FROM ROOM 
    WHERE Room_id = p_room_id 
    FOR UPDATE;
    
    IF v_room_status != 'Available' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: The selected room is not available.';
        ROLLBACK;
    ELSE
        INSERT INTO ADMISSION (Patient_id, Doctor_id, Room_id, Admission_date, Diagnosis, Status)
        VALUES (p_patient_id, p_doctor_id, p_room_id, CURDATE(), p_diagnosis, 'Admitted');
        
        SET p_admission_id = LAST_INSERT_ID();
        
        UPDATE ROOM 
        SET Status = 'Occupied' 
        WHERE Room_id = p_room_id;
        
        COMMIT;
    END IF;
END //

-- Procedure 2: Discharge Patient and Generate Bill
CREATE PROCEDURE sp_discharge_patient(
    IN p_admission_id INT,
    IN p_discount DECIMAL(10,2),
    OUT p_bill_id INT
)
BEGIN
    DECLARE v_patient_id INT;
    DECLARE v_room_id INT;
    DECLARE v_adm_date DATE;
    DECLARE v_days INT;
    DECLARE v_daily_charge DECIMAL(10,2);
    DECLARE v_total_room_cost DECIMAL(10,2);
    DECLARE v_net DECIMAL(10,2);
    
    START TRANSACTION;
    
    SELECT Patient_id, Room_id, Admission_date 
    INTO v_patient_id, v_room_id, v_adm_date
    FROM ADMISSION 
    WHERE Admission_id = p_admission_id AND Status = 'Admitted'
    FOR UPDATE;
    
    IF v_patient_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Admission record not found or already discharged.';
        ROLLBACK;
    ELSE
        SELECT Daily_charge INTO v_daily_charge FROM ROOM WHERE Room_id = v_room_id;
        
        SET v_days = DATEDIFF(CURDATE(), v_adm_date);
        IF v_days < 1 THEN
            SET v_days = 1;
        END IF;
        
        SET v_total_room_cost = v_days * v_daily_charge;
        SET v_net = v_total_room_cost - p_discount;
        IF v_net < 0 THEN 
            SET v_net = 0;
        END IF;
        
        UPDATE ADMISSION 
        SET Discharge_date = CURDATE(), Status = 'Discharged'
        WHERE Admission_id = p_admission_id;
        
        UPDATE ROOM 
        SET Status = 'Available' 
        WHERE Room_id = v_room_id;
        
        INSERT INTO BILL (Patient_id, Admission_id, Bill_date, Total_amount, Discount, Net_amount, Status)
        VALUES (v_patient_id, p_admission_id, CURDATE(), v_total_room_cost, p_discount, v_net, 'Pending');
        
        SET p_bill_id = LAST_INSERT_ID();
        
        INSERT INTO BILL_ITEM (Bill_id, Description, Unit_price, Quantity, Amount)
        VALUES (p_bill_id, CONCAT('Room Stay (', v_days, ' day(s))'), v_daily_charge, v_days, v_total_room_cost);
        
        COMMIT;
    END IF;
END //

-- ------------------------------------------------------------------------------
-- STEP 8: TRIGGERS (MYSQL DELIMITER)
-- ------------------------------------------------------------------------------

-- Trigger: Prevent Double-booking of doctor
CREATE TRIGGER trg_check_appointment_slot
BEFORE INSERT ON APPOINTMENT
FOR EACH ROW
BEGIN
    DECLARE v_conflict INT;
    SELECT COUNT(*) INTO v_conflict 
    FROM APPOINTMENT 
    WHERE Doctor_id = NEW.Doctor_id 
      AND Appointment_date = NEW.Appointment_date 
      AND Appointment_time = NEW.Appointment_time
      AND Status NOT IN ('Cancelled', 'No-Show');
      
    IF v_conflict > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Constraint Violation: Doctor is already booked for this timeslot.';
    END IF;
END //

DELIMITER ;

-- ------------------------------------------------------------------------------
-- STEP 10: INDEXES
-- ------------------------------------------------------------------------------
CREATE INDEX idx_appointment_doctor_date ON APPOINTMENT (Doctor_id, Appointment_date);
CREATE INDEX idx_patient_phone ON PATIENT (Phone);
CREATE INDEX idx_admission_status_room ON ADMISSION (Status, Room_id);
CREATE INDEX idx_bill_status_patient ON BILL (Status, Patient_id);
CREATE INDEX idx_test_result_patient ON TEST_RESULT (Patient_id, Status);
