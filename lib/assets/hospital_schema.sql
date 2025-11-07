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

-- ===========================
-- INSERT SAMPLE DATA
-- ===========================

-- Department
INSERT INTO department (name, description) VALUES
('Cardiology', 'Heart and blood vessel related treatments'),
('Neurology', 'Brain and nervous system treatments'),
('Pediatrics', 'Child health care'),
('Orthopedics', 'Bone and muscle treatments'),
('Radiology', 'Medical imaging and scans'),
('Dermatology', 'Skin care and treatment'),
('Oncology', 'Cancer diagnosis and treatment'),
('Ophthalmology', 'Eye care and surgeries'),
('Emergency', 'Emergency care and trauma center'),
('General Medicine', 'General health consultation');

-- Patient
INSERT INTO patient (name, gender, dob, address, phone) VALUES
('Sok Dara', 'Male', '1990-03-15', 'Phnom Penh', '012345678'),
('Chan Sreyneang', 'Female', '1995-07-21', 'Siem Reap', '010112233'),
('Khim Rith', 'Male', '1988-02-10', 'Battambang', '011445566'),
('Keo Socheat', 'Male', '2000-11-05', 'Takeo', '092334455'),
('Ly Pisey', 'Female', '1999-08-18', 'Kandal', '099776655'),
('Phan Rany', 'Female', '1987-01-30', 'Kampong Cham', '096223344'),
('Lim Vuthy', 'Male', '1992-05-22', 'Banteay Meanchey', '088556677'),
('Thy Chan', 'Male', '2001-12-09', 'Kampot', '093334455'),
('Srey Leak', 'Female', '1996-09-25', 'Prey Veng', '097778899'),
('Rin Theary', 'Female', '1985-06-14', 'Kampong Thom', '081223344');

-- Doctor
INSERT INTO doctor (name, specialization, dept_id, phone, email) VALUES
('Dr. Sok Vanna', 'Cardiologist', 1, '012111222', 'vanna@hospital.com'),
('Dr. Kim Sopheak', 'Neurologist', 2, '013333444', 'sopheak@hospital.com'),
('Dr. Chhay Rith', 'Pediatrician', 3, '014555666', 'rith@hospital.com'),
('Dr. Long Phirun', 'Orthopedic Surgeon', 4, '015777888', 'phirun@hospital.com'),
('Dr. Mao Serey', 'Radiologist', 5, '016999000', 'serey@hospital.com'),
('Dr. Heng Chanra', 'Dermatologist', 6, '017123456', 'chanra@hospital.com'),
('Dr. Tep Sokha', 'Oncologist', 7, '018654321', 'sokha@hospital.com'),
('Dr. Roeun Lina', 'Ophthalmologist', 8, '019876543', 'lina@hospital.com'),
('Dr. Eng Dara', 'Emergency Physician', 9, '010909090', 'eng.dara@hospital.com'),
('Dr. Yin Chenda', 'General Practitioner', 10, '011808080', 'chenda@hospital.com');

-- Staff
INSERT INTO staff (name, role, dept_id, contact) VALUES
('Mean Sovann', 'Nurse', 1, '013444555'),
('Sann Vicheka', 'Technician', 5, '015123789'),
('Ly Rina', 'Receptionist', 10, '012777999'),
('Sok Chenda', 'Pharmacist', 10, '010111333'),
('Keo Borey', 'Cleaner', 9, '011222333'),
('Nim Sareth', 'Security', 9, '016444666'),
('Hem Ratana', 'Lab Assistant', 5, '017555888'),
('Touch Sopheary', 'Nurse', 3, '018666999'),
('Chhorn Sophal', 'Admin Staff', 10, '019000111'),
('Chan Navy', 'Accountant', 10, '093123456');

-- Appointment
INSERT INTO appointment (patient_id, doctor_id, appointment_date, status, reason) VALUES
(1, 1, '2025-11-01', 'Completed', 'Routine checkup'),
(2, 3, '2025-11-02', 'Pending', 'Fever and cough'),
(3, 2, '2025-11-03', 'Cancelled', 'Headache and dizziness'),
(4, 4, '2025-11-04', 'Completed', 'Back pain'),
(5, 6, '2025-11-05', 'Completed', 'Skin allergy'),
(6, 5, '2025-11-06', 'Pending', 'Chest X-ray'),
(7, 7, '2025-11-07', 'Completed', 'Cancer follow-up'),
(8, 9, '2025-11-08', 'Pending', 'Accident injury'),
(9, 8, '2025-11-09', 'Completed', 'Eye irritation'),
(10, 10, '2025-11-10', 'Completed', 'General consultation');
