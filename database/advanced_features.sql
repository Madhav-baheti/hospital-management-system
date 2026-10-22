-- ==============================================================================
-- HOSPITAL MANAGEMENT SYSTEM ADVANCED SQL FEATURES (STEPS 8 - 11)
-- Course: Database Management Systems (DBMS)
-- Student: Madhav Baheti | Enrollment No: 25STUCHH010661
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- STEP 8.1: VIEWS FOR REPORTING & DOCTOR DASHBOARD ANALYTICS
-- ------------------------------------------------------------------------------

-- View 1: Doctor Daily Consultations & Appointments
CREATE VIEW IF NOT EXISTS v_doctor_appointments AS
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

-- View 2: Currently Admitted Patients Summary with Room Allocation
CREATE VIEW IF NOT EXISTS v_admitted_patients_summary AS
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
    r.Floor,
    r.Daily_charge,
    adm.Admission_date,
    adm.Diagnosis,
    adm.Status AS Admission_Status
FROM ADMISSION adm
JOIN PATIENT p ON adm.Patient_id = p.Patient_id
LEFT JOIN DOCTOR d ON adm.Doctor_id = d.Doctor_id
JOIN ROOM r ON adm.Room_id = r.Room_id
WHERE adm.Status = 'Admitted';

-- View 3: Department Performance & Revenue Analytics
CREATE VIEW IF NOT EXISTS v_department_analytics AS
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

-- View 4: Consolidated Patient Billing & Balance Due Summary
CREATE VIEW IF NOT EXISTS v_patient_billing_summary AS
SELECT 
    b.Bill_id,
    p.Patient_id,
    p.Patient_name,
    p.Phone,
    b.Bill_date,
    b.Total_amount,
    b.Discount,
    b.Net_amount,
    COALESCE(SUM(pay.Amount), 0.00) AS Total_Paid,
    (b.Net_amount - COALESCE(SUM(pay.Amount), 0.00)) AS Balance_Due,
    b.Status AS Bill_Status
FROM BILL b
JOIN PATIENT p ON b.Patient_id = p.Patient_id
LEFT JOIN PAYMENT pay ON b.Bill_id = pay.Bill_id
GROUP BY b.Bill_id, p.Patient_id, p.Patient_name, p.Phone, b.Bill_date, b.Total_amount, b.Discount, b.Net_amount, b.Status;

-- View 5: Pending Lab Diagnostics Worklist
CREATE VIEW IF NOT EXISTS v_pending_lab_reports AS
SELECT 
    tr.Result_id,
    p.Patient_id,
    p.Patient_name,
    t.Test_id,
    t.Test_name,
    t.Test_type,
    t.Charge,
    tr.Result_date,
    d.Doctor_name AS Ordering_Doctor,
    tr.Status AS Report_Status
FROM TEST_RESULT tr
JOIN TEST t ON tr.Test_id = t.Test_id
JOIN PATIENT p ON tr.Patient_id = p.Patient_id
LEFT JOIN DOCTOR d ON tr.Doctor_id = d.Doctor_id
WHERE tr.Status = 'Pending';


-- ------------------------------------------------------------------------------
-- STEP 8.2: TRIGGERS FOR DATA INTEGRITY & AUTOMATION
-- ------------------------------------------------------------------------------

-- Trigger 1: Automatically calculate Net Amount before saving Bill
CREATE TRIGGER IF NOT EXISTS trg_calc_bill_net_amount_insert
BEFORE INSERT ON BILL
FOR EACH ROW
BEGIN
    SELECT CASE 
        WHEN NEW.Net_amount != (NEW.Total_amount - NEW.Discount) THEN
            RAISE(ABORT, 'Net amount must equal Total amount minus Discount')
    END;
END;

-- Trigger 2: Automatically mark Room as 'Occupied' when Patient is Admitted
CREATE TRIGGER IF NOT EXISTS trg_room_occupied_on_admission
AFTER INSERT ON ADMISSION
FOR EACH ROW
BEGIN
    UPDATE ROOM
    SET Status = 'Occupied'
    WHERE Room_id = NEW.Room_id;
END;

-- Trigger 3: Automatically free Room when Patient is Discharged
CREATE TRIGGER IF NOT EXISTS trg_room_available_on_discharge
AFTER UPDATE OF Status, Discharge_date ON ADMISSION
FOR EACH ROW
WHEN NEW.Status = 'Discharged' OR NEW.Discharge_date IS NOT NULL
BEGIN
    UPDATE ROOM
    SET Status = 'Available'
    WHERE Room_id = NEW.Room_id;
END;

-- Trigger 4: Prevent Doctor Double-Booking Conflict
CREATE TRIGGER IF NOT EXISTS trg_prevent_appointment_overlap
BEFORE INSERT ON APPOINTMENT
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM APPOINTMENT 
    WHERE Doctor_id = NEW.Doctor_id 
      AND Appointment_date = NEW.Appointment_date 
      AND Appointment_time = NEW.Appointment_time
      AND Status NOT IN ('Cancelled', 'No-Show')
)
BEGIN
    SELECT RAISE(ABORT, 'Scheduling Conflict: Doctor already has an active appointment at this date and time.');
END;


-- ------------------------------------------------------------------------------
-- STEP 10: INDEXING FOR QUERY OPTIMIZATION
-- ------------------------------------------------------------------------------

-- Index 1: High-frequency appointment lookups by Doctor and Date
CREATE INDEX IF NOT EXISTS idx_appointment_doctor_date 
ON APPOINTMENT (Doctor_id, Appointment_date);

-- Index 2: Patient lookup by phone number (OPD check-in desk)
CREATE INDEX IF NOT EXISTS idx_patient_phone 
ON PATIENT (Phone);

-- Index 3: Active in-patient lookup by status & room
CREATE INDEX IF NOT EXISTS idx_admission_status_room 
ON ADMISSION (Status, Room_id);

-- Index 4: Unpaid bill queries
CREATE INDEX IF NOT EXISTS idx_bill_status_patient 
ON BILL (Status, Patient_id);

-- Index 5: Diagnostic search by patient and status
CREATE INDEX IF NOT EXISTS idx_test_result_patient 
ON TEST_RESULT (Patient_id, Status);
