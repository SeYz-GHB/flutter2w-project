-- Drop and recreate database (SQLite doesn't support CREATE DATABASE)
-- Instead, just delete your .db file manually or programmatically if needed.


CREATE TABLE department (
    dept_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);


CREATE TABLE patient (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    dob TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL
);



CREATE TABLE doctor (
    doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    specialization TEXT,
    dept_id INTEGER,
    phone TEXT,
    email TEXT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);


CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    dept_id INTEGER,
    contact TEXT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);


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



CREATE INDEX idx_doctor_dept ON doctor(dept_id);
CREATE INDEX idx_doctor_specialization ON doctor(specialization);
CREATE INDEX idx_staff_dept ON staff(dept_id);
CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_doctor ON appointment(doctor_id);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);

