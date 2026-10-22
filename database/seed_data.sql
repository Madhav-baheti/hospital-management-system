-- ==============================================================================
-- HOSPITAL MANAGEMENT SYSTEM SEED DATA (SQL DML)
-- Course: Database Management Systems (DBMS)
-- Student: Madhav Baheti | Enrollment No: 25STUCHH010661
-- ==============================================================================

-- 1. DEPARTMENTS
INSERT INTO DEPARTMENT (Dept_id, Dept_name, Location, Phone) VALUES
(1, 'Cardiology', 'Block A, 3rd Floor', '040-2345001'),
(2, 'Neurology', 'Block B, 2nd Floor', '040-2345002'),
(3, 'Orthopedics', 'Block A, 1st Floor', '040-2345003'),
(4, 'Pediatrics', 'Block C, Ground Floor', '040-2345004'),
(5, 'General Medicine', 'Block B, 1st Floor', '040-2345005'),
(6, 'Emergency & Trauma', 'Block E, Ground Floor', '040-2345006');

-- 2. DOCTORS
INSERT INTO DOCTOR (Doctor_id, Doctor_name, Qualification, Specialization, Phone, Email, Dept_id) VALUES
(101, 'Dr. Sarah Jenkins', 'MD, DM (Cardiology), FACC', 'Chief Interventional Cardiologist', '9876543210', 's.jenkins@icfaihms.org', 1),
(102, 'Dr. Rajesh Sharma', 'MS, M.Ch (Neuro), FAANS', 'Senior Neurosurgeon', '9876543211', 'r.sharma@icfaihms.org', 2),
(103, 'Dr. Priya Patel', 'MS (Ortho), Fellowship Spine', 'Orthopedic & Joint Surgeon', '9876543212', 'p.patel@icfaihms.org', 3),
(104, 'Dr. Michael Chang', 'MD (Pediatrics), DCH', 'Consultant Pediatrician', '9876543213', 'm.chang@icfaihms.org', 4),
(105, 'Dr. Emily Clark', 'MD (Internal Medicine)', 'General Physician & Diabetologist', '9876543214', 'e.clark@icfaihms.org', 5),
(106, 'Dr. David Miller', 'MS, FRCS (Cardiovascular)', 'Pediatric Cardiologist', '9876543215', 'd.miller@icfaihms.org', 1);

-- 3. SERVICES
INSERT INTO SERVICE (Service_id, Service_name, Description, Charge) VALUES
(1, 'OPD Consultation', 'Outpatient General Consultation', 800.00),
(2, 'Specialist Consultation', 'Senior Super-Specialist Review', 1500.00),
(3, 'Emergency Care', 'Triage, Resuscitation & Emergency Stabilizing', 2500.00),
(4, 'ICU Daily Care', 'Intensive Critical Monitoring & Nursing', 5000.00),
(5, 'Physiotherapy Session', 'Rehabilitation and mobility therapy', 1200.00);

-- 4. SCHEDULES
INSERT INTO SCHEDULE (Schedule_id, Doctor_id, Day, Start_time, End_time) VALUES
(1, 101, 'Monday', '09:00:00', '13:00:00'),
(2, 101, 'Wednesday', '09:00:00', '13:00:00'),
(3, 101, 'Friday', '14:00:00', '18:00:00'),
(4, 102, 'Tuesday', '10:00:00', '14:00:00'),
(5, 102, 'Thursday', '10:00:00', '14:00:00'),
(6, 103, 'Monday', '14:00:00', '18:00:00'),
(7, 104, 'Tuesday', '09:00:00', '13:00:00'),
(8, 105, 'Everyday', '08:00:00', '16:00:00');

-- 5. STAFF
INSERT INTO STAFF (Staff_id, Staff_name, Role, Phone, Email, Department_id) VALUES
(1, 'Ramesh Nair', 'Reception Head', '9123456780', 'ramesh.nair@icfaihms.org', 5),
(2, 'Sunita Rao', 'Billing Coordinator', '9123456781', 'sunita.rao@icfaihms.org', 5),
(3, 'Vikram Malhotra', 'Lab Technician', '9123456782', 'vikram.m@icfaihms.org', 5),
(4, 'Ananya Das', 'Pharmacy Executive', '9123456783', 'ananya.das@icfaihms.org', 5);

-- 6. NURSES
INSERT INTO NURSE (Nurse_id, Nurse_name, Phone, Email, Dept_id) VALUES
(201, 'Sister Maria Gomez', '9988776655', 'maria.g@icfaihms.org', 1),
(202, 'Sister Kavita Menon', '9988776656', 'kavita.m@icfaihms.org', 2),
(203, 'Sister Preeti Sen', '9988776657', 'preeti.s@icfaihms.org', 1),
(204, 'Sister Rachel Green', '9988776658', 'rachel.g@icfaihms.org', 4);

-- 7. ROOMS
INSERT INTO ROOM (Room_id, Room_no, Room_type, Floor, Daily_charge, Status) VALUES
(301, 'ICU-101', 'ICU', 1, 7500.00, 'Occupied'),
(302, 'ICU-102', 'ICU', 1, 7500.00, 'Available'),
(303, 'DLX-201', 'Private Deluxe', 2, 4500.00, 'Occupied'),
(304, 'DLX-202', 'Private Deluxe', 2, 4500.00, 'Available'),
(305, 'SMP-301', 'Semi-Private', 3, 2500.00, 'Occupied'),
(306, 'SMP-302', 'Semi-Private', 3, 2500.00, 'Available'),
(307, 'GEN-401', 'General Ward', 4, 1200.00, 'Available'),
(308, 'GEN-402', 'General Ward', 4, 1200.00, 'Available');

-- 8. PATIENTS
INSERT INTO PATIENT (Patient_id, Patient_name, DOB, Gender, Address, Phone, Email, Blood_group, Allergies) VALUES
(1001, 'Eleanor Vance', '1988-04-12', 'Female', 'Flat 402, Green Glen Towers, Hyderabad', '9811122233', 'eleanor.vance@gmail.com', 'O+', 'Penicillin'),
(1002, 'Robert Wilson', '1975-09-24', 'Male', 'H.No 12-4, Banjara Hills, Hyderabad', '9822233344', 'robert.wilson@yahoo.com', 'A+', 'Sulfa drugs'),
(1003, 'Sarah Connor', '1992-11-03', 'Female', 'Plot 88, Jubilee Hills Road 36, Hyderabad', '9833344455', 'sarah.c@outlook.com', 'B-', 'None'),
(1004, 'David Kim', '1964-07-19', 'Male', 'Tower 3, Gachibowli High Street, Hyderabad', '9844455566', 'david.kim@techfirm.com', 'AB+', 'Aspirin'),
(1005, 'Anita Roy', '1999-02-15', 'Female', 'D-14, Madhapur Silicon Valley, Hyderabad', '9855566677', 'anita.roy@gmail.com', 'O-', 'Dust & Pollen'),
(1006, 'Marcus Brody', '1958-12-01', 'Male', 'Villa 5, Palm Meadows, Kondapur, Hyderabad', '9866677788', 'marcus.brody@domain.com', 'A-', 'Latex'),
(1007, 'Clara Oswald', '2001-06-20', 'Female', 'Secunderabad Cantonment, Hyderabad', '9877788899', 'clara.oswald@gmail.com', 'B+', 'None'),
(1008, 'Alexander Pierce', '1970-03-30', 'Male', 'Hitec City Phase 2, Hyderabad', '9888899900', 'alex.pierce@global.com', 'O+', 'Ibuprofen');

-- 9. MEDICINES CATALOG
INSERT INTO MEDICINE (Medicine_id, Medicine_name, Dosage_form, Unit_price) VALUES
(501, 'Atorvastatin 20mg', 'Tablet', 18.50),
(502, 'Metoprolol Succinate 50mg', 'Tablet', 14.00),
(503, 'Aspirin 75mg Gastro-resistant', 'Tablet', 5.00),
(504, 'Ramipril 5mg', 'Capsule', 12.00),
(505, 'Levetiracetam 500mg', 'Tablet', 28.00),
(506, 'Amoxicillin-Clavulanate 625mg', 'Tablet', 22.00),
(507, 'Pantoprazole 40mg', 'Tablet', 10.50),
(508, 'Paracetamol 650mg', 'Tablet', 3.50);

-- 10. APPOINTMENTS
INSERT INTO APPOINTMENT (Appointment_id, Patient_id, Doctor_id, Appointment_date, Appointment_time, Status, Reason) VALUES
(2001, 1001, 101, '2026-10-21', '09:30:00', 'In Consultation', 'Chest tightness & palpitation during workouts'),
(2002, 1002, 101, '2026-10-21', '10:15:00', 'Scheduled', 'Hypertension quarterly cardiac review'),
(2003, 1003, 101, '2026-10-21', '11:00:00', 'Scheduled', 'Follow-up on Echo test results'),
(2004, 1004, 101, '2026-10-21', '11:45:00', 'Scheduled', 'Post-angioplasty routine check'),
(2005, 1005, 102, '2026-10-21', '10:30:00', 'Scheduled', 'Persistent migraine aura episodes'),
(2006, 1006, 103, '2026-10-21', '14:30:00', 'Scheduled', 'Left knee osteoarthritis pain'),
(2007, 1007, 105, '2026-10-21', '09:00:00', 'Completed', 'Acute viral fever and fatigue'),
(2008, 1008, 101, '2026-10-22', '09:30:00', 'Scheduled', 'Holter monitor report assessment');

-- 11. TESTS
INSERT INTO TEST (Test_id, Test_name, Test_type, Normal_range, Charge) VALUES
(601, '12-Lead Electrocardiogram (ECG)', 'Cardiac Diagnostic', 'Normal Sinus Rhythm', 650.00),
(602, '2D Echocardiogram with Doppler', 'Cardiovascular Imaging', 'LVEF: 55-70%', 2800.00),
(603, 'Cardiac Troponin-I High Sensitivity', 'Serum Biomarker', '< 0.04 ng/mL', 1200.00),
(604, 'Lipid Profile Comprehensive', 'Clinical Biochemistry', 'LDL < 100 mg/dL', 950.00),
(605, 'Brain MRI with Contrast', 'Neuro Imaging', 'No acute infarction', 7500.00),
(606, 'Complete Blood Count (CBC)', 'Hematology', 'Hb: 13-17 g/dL', 450.00);

-- 12. TEST RESULTS
INSERT INTO TEST_RESULT (Result_id, Test_id, Patient_id, Doctor_id, Result_date, Result, Remarks, Status) VALUES
(701, 601, 1001, 101, '2026-10-21', 'Sinus tachycardia, rate 104 bpm, ST elevation 1mm in V2-V4', 'Suggestive of acute coronary evaluation', 'Completed'),
(702, 604, 1002, 101, '2026-10-20', 'Total Chol: 242 mg/dL, LDL: 165 mg/dL, HDL: 38 mg/dL', 'Dyslipidemia, statin titrate recommended', 'Completed'),
(703, 602, 1004, 101, '2026-10-19', 'LVEF 58%, mild concentric LV hypertrophy, no wall motion defect', 'Stable post-intervention status', 'Reviewed'),
(704, 603, 1001, 101, '2026-10-21', '0.082 ng/mL (Elevated)', 'Observation advised in cardiac unit', 'Completed'),
(705, 605, 1005, 102, '2026-10-21', 'Pending radiologist review', 'Scan performed at 10:00 AM', 'Pending');

-- 13. PRESCRIPTIONS
INSERT INTO PRESCRIPTION (Prescription_id, Doctor_id, Patient_id, Prescription_date, Notes) VALUES
(801, 101, 1002, '2026-10-20', 'Strict low-sodium diet, regular 30m aerobic walk, follow up in 4 weeks'),
(802, 101, 1004, '2026-10-19', 'Continue dual antiplatelet therapy for 12 months, hydrate well'),
(803, 105, 1007, '2026-10-21', 'Rest for 3 days, drink electrolyte water, monitor temperature TDS');

-- 14. PRESCRIPTION ITEMS
INSERT INTO PRESCRIPTION_ITEM (Prescription_id, Medicine_id, Dose, Frequency, Duration) VALUES
(801, 501, '20mg', 'Once Daily (Night)', '30 Days'),
(801, 502, '50mg', 'Once Daily (Morning)', '30 Days'),
(801, 504, '5mg', 'Once Daily (Morning)', '30 Days'),
(802, 501, '40mg', 'Once Daily (Night)', '60 Days'),
(802, 503, '75mg', 'Once Daily (After Lunch)', '60 Days'),
(803, 508, '650mg', 'SOS after food', '3 Days'),
(803, 507, '40mg', 'Once Daily (Empty Stomach)', '5 Days');

-- 15. ADMISSIONS
INSERT INTO ADMISSION (Admission_id, Patient_id, Doctor_id, Room_id, Admission_date, Discharge_date, Diagnosis, Status) VALUES
(901, 1001, 101, 301, '2026-10-21', NULL, 'Acute Coronary Syndrome (NSTEMI observation)', 'Admitted'),
(902, 1004, 101, 303, '2026-10-18', '2026-10-20', 'Elective Stent Placement & Telemetry', 'Discharged'),
(903, 1006, 103, 305, '2026-10-20', NULL, 'Bilateral Knee Arthroscopy Post-Op Care', 'Admitted');

-- 16. ADMISSION NURSE MAPPING
INSERT INTO ADMISSION_NURSE (Admission_id, Nurse_id, Shift) VALUES
(901, 201, 'Morning (07:00 - 15:00)'),
(901, 203, 'Night (23:00 - 07:00)'),
(902, 201, 'General Day Shift'),
(903, 202, 'Evening (15:00 - 23:00)');

-- 17. BILLS
INSERT INTO BILL (Bill_id, Patient_id, Admission_id, Bill_date, Total_amount, Discount, Net_amount, Status) VALUES
(4001, 1004, 902, '2026-10-20', 28500.00, 2500.00, 26000.00, 'Paid'),
(4002, 1007, NULL, '2026-10-21', 800.00, 0.00, 800.00, 'Paid'),
(4003, 1006, 903, '2026-10-21', 14500.00, 1000.00, 13500.00, 'Pending'),
(4004, 1001, 901, '2026-10-21', 9350.00, 500.00, 8850.00, 'Pending');

-- 18. BILL ITEMS
INSERT INTO BILL_ITEM (Bill_item_id, Bill_id, Description, Unit_price, Quantity, Amount) VALUES
(1, 4001, 'Room Charges (Private Deluxe x 2 Days)', 4500.00, 2, 9000.00),
(2, 4001, 'Cardiac Angioplasty Specialist Fees', 15000.00, 1, 15000.00),
(3, 4001, '2D Echocardiogram with Doppler', 2800.00, 1, 2800.00),
(4, 4001, 'Nursing Care and Monitoring (48 Hours)', 850.00, 2, 1700.00),
(5, 4002, 'OPD General Consultation (Dr. Emily Clark)', 800.00, 1, 800.00),
(6, 4003, 'Room Charges (Semi-Private x 2 Days)', 2500.00, 2, 5000.00),
(7, 4003, 'Arthroscopy Surgical Assistance & Nursing', 9500.00, 1, 9500.00),
(8, 4004, 'ICU Bed Charges (Day 1)', 7500.00, 1, 7500.00),
(9, 4004, '12-Lead ECG Diagnostic', 650.00, 1, 650.00),
(10, 4004, 'Cardiac Troponin-I HS Test', 1200.00, 1, 1200.00);

-- 19. PAYMENTS
INSERT INTO PAYMENT (Payment_id, Bill_id, Payment_date, Amount, Payment_mode, Transaction_no) VALUES
(5001, 4001, '2026-10-20', 26000.00, 'Insurance', 'TPA-MEDI-2026-99381'),
(5002, 4002, '2026-10-21', 800.00, 'UPI', 'UPI-REF-0938472911');
