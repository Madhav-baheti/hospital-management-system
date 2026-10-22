import sqlite3
import os
from datetime import datetime, date

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hospital.db")
SCHEMA_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "schema.sql")
SEED_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "seed_data.sql")
ADVANCED_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "advanced_features.sql")

def get_connection():
    """Create and return an SQLite connection with Foreign Keys enabled and Row dict factory."""
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    conn.row_factory = sqlite3.Row
    return conn

def init_db(force_recreate=False):
    """Initializes the database schema, seed data, views, triggers, and indexes."""
    if force_recreate and os.path.exists(DB_PATH):
        os.remove(DB_PATH)
        print("[DB] Removed existing database.")

    conn = get_connection()
    cursor = conn.cursor()

    # Read and execute schema
    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        schema_sql = f.read()
    cursor.executescript(schema_sql)
    print("[DB] Schema initialized successfully.")

    # Check if data already exists
    cursor.execute("SELECT COUNT(*) FROM PATIENT;")
    patient_count = cursor.fetchone()[0]
    if patient_count == 0:
        with open(SEED_PATH, "r", encoding="utf-8") as f:
            seed_sql = f.read()
        cursor.executescript(seed_sql)
        print("[DB] Seed data populated successfully.")

    # Read and execute advanced features (Views, Triggers, Indexes)
    with open(ADVANCED_PATH, "r", encoding="utf-8") as f:
        advanced_sql = f.read()
    cursor.executescript(advanced_sql)
    print("[DB] Views, Triggers, and Indexes configured successfully.")

    conn.commit()
    conn.close()
    return True

# ------------------------------------------------------------------------------
# STEP 8 PROCEDURES IMPLEMENTED WITH ACID TRANSACTION INTEGRITY (STEP 9)
# ------------------------------------------------------------------------------

def book_appointment(patient_id, doctor_id, appt_date, appt_time, reason):
    """
    Step 8 & 9: ACID compliant transaction for booking appointments.
    Triggers check for double-booking; locks ensure isolation.
    """
    conn = get_connection()
    try:
        conn.execute("BEGIN IMMEDIATE TRANSACTION;")
        cur = conn.cursor()

        # Validate doctor exists
        cur.execute("SELECT Doctor_name FROM DOCTOR WHERE Doctor_id = ?;", (doctor_id,))
        doc = cur.fetchone()
        if not doc:
            raise ValueError(f"Doctor with ID {doctor_id} not found.")

        # Validate patient exists
        cur.execute("SELECT Patient_name FROM PATIENT WHERE Patient_id = ?;", (patient_id,))
        pat = cur.fetchone()
        if not pat:
            raise ValueError(f"Patient with ID {patient_id} not found.")

        # Check existing booking conflict (double-layer validation: query check + SQL trigger)
        cur.execute("""
            SELECT Appointment_id FROM APPOINTMENT 
            WHERE Doctor_id = ? AND Appointment_date = ? AND Appointment_time = ? 
              AND Status NOT IN ('Cancelled', 'No-Show');
        """, (doctor_id, appt_date, appt_time))
        conflict = cur.fetchone()
        if conflict:
            raise ValueError(f"Doctor {doc['Doctor_name']} already has an active appointment at {appt_date} {appt_time}.")

        cur.execute("""
            INSERT INTO APPOINTMENT (Patient_id, Doctor_id, Appointment_date, Appointment_time, Status, Reason)
            VALUES (?, ?, ?, ?, 'Scheduled', ?);
        """, (patient_id, doctor_id, appt_date, appt_time, reason))
        
        new_id = cur.lastrowid
        conn.commit()
        return {"success": True, "appointment_id": new_id, "message": f"Appointment booked successfully for {pat['Patient_name']}."}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}
    finally:
        conn.close()

def admit_patient(patient_id, doctor_id, room_id, diagnosis):
    """
    Step 8 & 9: Stored procedure for admitting a patient.
    Atomically creates admission and updates ROOM status to 'Occupied' via trigger.
    """
    conn = get_connection()
    try:
        conn.execute("BEGIN IMMEDIATE TRANSACTION;")
        cur = conn.cursor()

        # Validate room is available
        cur.execute("SELECT Room_no, Room_type, Status, Daily_charge FROM ROOM WHERE Room_id = ?;", (room_id,))
        room = cur.fetchone()
        if not room:
            raise ValueError(f"Room ID {room_id} does not exist.")
        if room["Status"] != "Available":
            raise ValueError(f"Room {room['Room_no']} ({room['Room_type']}) is currently {room['Status']}.")

        cur.execute("""
            INSERT INTO ADMISSION (Patient_id, Doctor_id, Room_id, Admission_date, Diagnosis, Status)
            VALUES (?, ?, ?, DATE('now'), ?, 'Admitted');
        """, (patient_id, doctor_id, room_id, diagnosis))
        
        adm_id = cur.lastrowid
        conn.commit()
        return {"success": True, "admission_id": adm_id, "room": room["Room_no"], "message": f"Patient admitted to {room['Room_no']}."}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}
    finally:
        conn.close()

def discharge_patient(admission_id, discount=0.0):
    """
    Step 8 & 9: Discharge patient, generate bill, free up room.
    """
    conn = get_connection()
    try:
        conn.execute("BEGIN IMMEDIATE TRANSACTION;")
        cur = conn.cursor()

        cur.execute("""
            SELECT adm.Admission_id, adm.Patient_id, adm.Room_id, adm.Admission_date, r.Daily_charge, r.Room_no
            FROM ADMISSION adm
            JOIN ROOM r ON adm.Room_id = r.Room_id
            WHERE adm.Admission_id = ? AND adm.Status = 'Admitted';
        """, (admission_id,))
        row = cur.fetchone()
        if not row:
            raise ValueError("Active admission not found for the given ID.")

        # Calculate days
        adm_date = datetime.strptime(row["Admission_date"], "%Y-%m-%d").date()
        today = date.today()
        days = (today - adm_date).days
        if days < 1:
            days = 1

        room_cost = days * float(row["Daily_charge"])
        net_amt = max(0.0, room_cost - float(discount))

        # Update Admission (Trigger will automatically free the room)
        cur.execute("""
            UPDATE ADMISSION 
            SET Discharge_date = DATE('now'), Status = 'Discharged'
            WHERE Admission_id = ?;
        """, (admission_id,))

        # Create Bill
        cur.execute("""
            INSERT INTO BILL (Patient_id, Admission_id, Bill_date, Total_amount, Discount, Net_amount, Status)
            VALUES (?, ?, DATE('now'), ?, ?, ?, 'Pending');
        """, (row["Patient_id"], admission_id, room_cost, discount, net_amt))
        bill_id = cur.lastrowid

        # Insert Bill Item
        cur.execute("""
            INSERT INTO BILL_ITEM (Bill_id, Description, Unit_price, Quantity, Amount)
            VALUES (?, ?, ?, ?, ?);
        """, (bill_id, f"Room Charges - {row['Room_no']} ({days} day(s))", row["Daily_charge"], days, room_cost))

        conn.commit()
        return {"success": True, "bill_id": bill_id, "total": room_cost, "net": net_amt, "message": f"Patient discharged and Bill #{bill_id} generated."}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}
    finally:
        conn.close()

def record_payment(bill_id, amount, payment_mode, txn_no):
    """
    Step 8 & 9: Record payment and update bill status.
    """
    conn = get_connection()
    try:
        conn.execute("BEGIN IMMEDIATE TRANSACTION;")
        cur = conn.cursor()

        cur.execute("SELECT Net_amount, Status FROM BILL WHERE Bill_id = ?;", (bill_id,))
        bill = cur.fetchone()
        if not bill:
            raise ValueError("Bill ID not found.")

        # Check existing payments
        cur.execute("SELECT COALESCE(SUM(Amount), 0) as paid FROM PAYMENT WHERE Bill_id = ?;", (bill_id,))
        already_paid = cur.fetchone()["paid"]

        cur.execute("""
            INSERT INTO PAYMENT (Bill_id, Payment_date, Amount, Payment_mode, Transaction_no)
            VALUES (?, DATE('now'), ?, ?, ?);
        """, (bill_id, amount, payment_mode, txn_no))

        total_now_paid = already_paid + float(amount)
        new_status = "Paid" if total_now_paid >= float(bill["Net_amount"]) else "Partial"

        cur.execute("UPDATE BILL SET Status = ? WHERE Bill_id = ?;", (new_status, bill_id))

        conn.commit()
        return {"success": True, "status": new_status, "total_paid": total_now_paid, "message": "Payment recorded successfully."}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}
    finally:
        conn.close()

if __name__ == "__main__":
    init_db(force_recreate=True)
    print("[DB] Test check complete.")
