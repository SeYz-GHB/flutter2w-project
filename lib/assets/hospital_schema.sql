-- Drop and recreate database (SQLite doesn't support CREATE DATABASE)
-- Instead, just delete your .db file manually or programmatically if needed.

-- Create Department table
CREATE TABLE department (
    dept_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create Patient table
CREATE TABLE patient (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    dob TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL
);

-- Create Room table
CREATE TABLE room (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    number TEXT NOT NULL UNIQUE,
    type TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    available_beds INTEGER NOT NULL,
    CHECK (available_beds >= 0 AND available_beds <= capacity)
);

-- Create Doctor table
CREATE TABLE doctor (
    doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    specialization TEXT,
    dept_id INTEGER,
    phone TEXT,
    email TEXT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);

-- Create Staff table
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    dept_id INTEGER,
    contact TEXT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);

-- Create Appointment table
CREATE TABLE appointment (
    appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    doctor_id INTEGER,
    appointment_date TEXT NOT NULL,
    status TEXT NOT NULL,
    reason TEXT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE SET NULL
);

-- Create Admission table
CREATE TABLE admission (
    admission_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    room_id INTEGER,
    admit_date TEXT NOT NULL,
    discharge_date TEXT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(id) ON DELETE SET NULL,
    CHECK (discharge_date IS NULL OR discharge_date >= admit_date)
);

-- Create Medical Record table
CREATE TABLE medical_record (
    record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    doctor_id INTEGER,
    diagnosis TEXT NOT NULL,
    prescription TEXT NOT NULL,
    record_date TEXT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE SET NULL
);

-- Create Billing table
CREATE TABLE billing (
    bill_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    total REAL NOT NULL,
    paid REAL NOT NULL DEFAULT 0,
    status TEXT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE,
    CHECK (total >= 0),
    CHECK (paid >= 0),
    CHECK (paid <= total)
);

-- Create indexes for better performance
CREATE INDEX idx_doctor_dept ON doctor(dept_id);
CREATE INDEX idx_doctor_specialization ON doctor(specialization);
CREATE INDEX idx_staff_dept ON staff(dept_id);
CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_doctor ON appointment(doctor_id);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);
CREATE INDEX idx_admission_patient ON admission(patient_id);
CREATE INDEX idx_admission_room ON admission(room_id);
CREATE INDEX idx_medical_record_patient ON medical_record(patient_id);
CREATE INDEX idx_medical_record_doctor ON medical_record(doctor_id);
CREATE INDEX idx_billing_patient ON billing(patient_id);
CREATE INDEX idx_billing_status ON billing(status);
