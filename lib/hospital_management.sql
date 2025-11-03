-- Create database
CREATE DATABASE hospital_management;
USE hospital_management;

-- =====================================
-- 1. Department Table
-- =====================================
CREATE TABLE department (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT
);

INSERT INTO department (name, description) VALUES
('Cardiology', 'Heart and blood vessel treatment'),
('Neurology', 'Brain and nervous system treatment'),
('Pediatrics', 'Child healthcare'),
('Orthopedics', 'Bone and muscle care'),
('Oncology', 'Cancer treatment'),
('Gynecology', 'Women health and pregnancy'),
('Dermatology', 'Skin treatment'),
('ENT', 'Ear, nose and throat care'),
('Urology', 'Urinary system care'),
('Emergency', '24/7 emergency treatment');

-- =====================================
-- 2. Doctor Table
-- =====================================
CREATE TABLE doctor (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100),
  dept_id INT,
  phone VARCHAR(20),
  email VARCHAR(100),
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

INSERT INTO doctor (name, specialization, dept_id, phone, email) VALUES
('Dr. Sok Dara', 'Cardiologist', 1, '012345678', 'dara@hospital.com'),
('Dr. Lim Chenda', 'Neurologist', 2, '012876543', 'chenda@hospital.com'),
('Dr. Phan Rith', 'Pediatrician', 3, '015987654', 'rith@hospital.com'),
('Dr. Vann Monika', 'Orthopedic Surgeon', 4, '011456789', 'monika@hospital.com'),
('Dr. Kim Sothy', 'Oncologist', 5, '010654321', 'sothy@hospital.com'),
('Dr. Khem Srey', 'Gynecologist', 6, '016789456', 'srey@hospital.com'),
('Dr. Chan Borey', 'Dermatologist', 7, '098321654', 'borey@hospital.com'),
('Dr. Lay Lina', 'ENT Specialist', 8, '097654123', 'lina@hospital.com'),
('Dr. Sok Nara', 'Urologist', 9, '099876321', 'nara@hospital.com'),
('Dr. Tep Vuth', 'Emergency Doctor', 10, '095432678', 'vuth@hospital.com');

-- =====================================
-- 3. Staff Table
-- =====================================
CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  role VARCHAR(100),
  dept_id INT,
  contact VARCHAR(20),
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

INSERT INTO staff (name, role, dept_id, contact) VALUES
('Sokha Mean', 'Nurse', 1, '081234567'),
('Rina Pech', 'Receptionist', 10, '081654321'),
('Dina Roeun', 'Pharmacist', 5, '089456789'),
('Sokny Im', 'Nurse', 3, '086321654'),
('Buntha Mao', 'Technician', 4, '087987654'),
('Sopheap Keo', 'Cashier', 10, '083456789'),
('Chenda Oum', 'Janitor', 9, '088654321'),
('Vicheka Kim', 'Nurse', 6, '082345678'),
('Phearom Soy', 'Security Guard', 10, '085678912'),
('Roth Pisey', 'Lab Assistant', 7, '084123456');

-- =====================================
-- 4. Patient Table
-- =====================================
CREATE TABLE patient (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  gender ENUM('Male','Female'),
  dob DATE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

INSERT INTO patient (name, gender, dob, address, phone) VALUES
('Chan Socheat', 'Male', '1990-01-15', 'Phnom Penh', '011111111'),
('Sok Sreyna', 'Female', '1995-02-22', 'Siem Reap', '012222222'),
('Phan Dara', 'Male', '1988-03-05', 'Battambang', '013333333'),
('Khim Rina', 'Female', '2000-04-10', 'Kampong Cham', '014444444'),
('Lorn Piseth', 'Male', '1993-05-12', 'Takeo', '015555555'),
('Neang Sreyneang', 'Female', '1999-06-18', 'Kandal', '016666666'),
('Vuthy Chan', 'Male', '1987-07-09', 'Prey Veng', '017777777'),
('Kim Sreymao', 'Female', '1992-08-30', 'Svay Rieng', '018888888'),
('Sok Rith', 'Male', '1991-09-15', 'Kampot', '019999999'),
('Kanha Lim', 'Female', '2002-10-20', 'Banteay Meanchey', '010101010');

-- =====================================
-- 5. Appointment Table
-- =====================================
CREATE TABLE appointment (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  doctor_id INT,
  appointment_date DATETIME,
  status ENUM('Scheduled','Completed','Cancelled'),
  reason TEXT,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);

INSERT INTO appointment (patient_id, doctor_id, appointment_date, status, reason) VALUES
(1, 1, '2025-10-25 09:00:00', 'Completed', 'Heart checkup'),
(2, 2, '2025-10-26 10:00:00', 'Scheduled', 'Headache consultation'),
(3, 3, '2025-10-27 14:00:00', 'Scheduled', 'Child fever'),
(4, 4, '2025-10-27 16:00:00', 'Completed', 'Leg pain'),
(5, 5, '2025-10-28 09:30:00', 'Cancelled', 'Cancer screening'),
(6, 6, '2025-10-29 10:30:00', 'Scheduled', 'Pregnancy check'),
(7, 7, '2025-10-29 11:30:00', 'Completed', 'Skin rash'),
(8, 8, '2025-10-30 13:00:00', 'Scheduled', 'Ear infection'),
(9, 9, '2025-10-31 15:00:00', 'Scheduled', 'Kidney stone'),
(10, 10, '2025-11-01 08:00:00', 'Scheduled', 'Emergency accident');

-- =====================================
-- 6. Medical Record Table
-- =====================================
CREATE TABLE medical_record (
  record_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  doctor_id INT,
  diagnosis TEXT,
  prescription TEXT,
  record_date DATE,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);

INSERT INTO medical_record (patient_id, doctor_id, diagnosis, prescription, record_date) VALUES
(1, 1, 'High blood pressure', 'Amlodipine 5mg', '2025-10-25'),
(2, 2, 'Migraine', 'Paracetamol 500mg', '2025-10-26'),
(3, 3, 'Flu', 'Tamiflu 75mg', '2025-10-27'),
(4, 4, 'Knee pain', 'Ibuprofen 400mg', '2025-10-27'),
(5, 5, 'Cancer screening', 'Lab test', '2025-10-28'),
(6, 6, 'Pregnancy follow-up', 'Vitamin supplements', '2025-10-29'),
(7, 7, 'Eczema', 'Topical cream', '2025-10-29'),
(8, 8, 'Ear infection', 'Amoxicillin', '2025-10-30'),
(9, 9, 'Kidney stones', 'Hydration + pain relief', '2025-10-31'),
(10, 10, 'Accident trauma', 'Pain relief, wound care', '2025-11-01');

-- =====================================
-- 7. Room Table
-- =====================================
CREATE TABLE room (
  room_id INT AUTO_INCREMENT PRIMARY KEY,
  room_number VARCHAR(10),
  type ENUM('General','ICU','Private'),
  availability BOOLEAN
);

INSERT INTO room (room_number, type, availability) VALUES
('A101', 'General', TRUE),
('A102', 'General', FALSE),
('B201', 'Private', TRUE),
('B202', 'Private', TRUE),
('C301', 'ICU', FALSE),
('C302', 'ICU', TRUE),
('D401', 'General', TRUE),
('D402', 'Private', FALSE),
('E501', 'General', TRUE),
('E502', 'ICU', TRUE);

-- =====================================
-- 8. Admission Table
-- =====================================
CREATE TABLE admission (
  admission_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  room_id INT,
  admit_date DATE,
  discharge_date DATE,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (room_id) REFERENCES room(room_id)
);

INSERT INTO admission (patient_id, room_id, admit_date, discharge_date) VALUES
(1, 2, '2025-10-25', '2025-10-27'),
(2, 3, '2025-10-26', NULL),
(3, 5, '2025-10-27', '2025-10-29'),
(4, 7, '2025-10-27', NULL),
(5, 4, '2025-10-28', '2025-10-30'),
(6, 1, '2025-10-29', NULL),
(7, 6, '2025-10-29', NULL),
(8, 8, '2025-10-30', '2025-11-01'),
(9, 9, '2025-10-31', NULL),
(10, 10, '2025-11-01', NULL);

-- =====================================
-- 9. Billing Table
-- =====================================
CREATE TABLE billing (
  bill_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  total DECIMAL(10,2),
  paid DECIMAL(10,2),
  status ENUM('Paid','Unpaid','Partial'),
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

INSERT INTO billing (patient_id, total, paid, status) VALUES
(1, 150.00, 150.00, 'Paid'),
(2, 200.00, 100.00, 'Partial'),
(3, 75.00, 75.00, 'Paid'),
(4, 180.00, 180.00, 'Paid'),
(5, 250.00, 0.00, 'Unpaid'),
(6, 120.00, 60.00, 'Partial'),
(7, 300.00, 300.00, 'Paid'),
(8, 80.00, 80.00, 'Paid'),
(9, 400.00, 100.00, 'Partial'),
(10, 500.00, 0.00, 'Unpaid');

-- =====================================
-- 7. Room Table
-- =====================================
CREATE TABLE room (
  room_id INT AUTO_INCREMENT PRIMARY KEY,
  room_number VARCHAR(10) NOT NULL,
  type ENUM('General','ICU','Private') DEFAULT 'General',
  capacity INT DEFAULT 2,
  available_beds INT DEFAULT 2,
  availability BOOLEAN DEFAULT TRUE
);

-- Sample room data
INSERT INTO room (room_number, type, capacity, available_beds, availability) VALUES
('A101', 'General', 2, 1, TRUE),
('A102', 'General', 2, 0, FALSE),
('B201', 'Private', 1, 1, TRUE),
('B202', 'Private', 1, 0, FALSE),
('C301', 'ICU', 2, 1, TRUE),
('C302', 'ICU', 2, 2, TRUE),
('D401', 'General', 2, 1, TRUE),
('D402', 'Private', 1, 0, FALSE),
('E501', 'General', 2, 2, TRUE),
('E502', 'ICU', 2, 1, TRUE);

-- =====================================
-- 8. Bed Table
-- =====================================
CREATE TABLE bed (
  bed_id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT,
  bed_number VARCHAR(10) NOT NULL,
  is_occupied BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (room_id) REFERENCES room(room_id)
);

-- Sample beds for each room
INSERT INTO bed (room_id, bed_number, is_occupied) VALUES
(1, 'A101-1', FALSE),
(1, 'A101-2', TRUE),
(2, 'A102-1', TRUE),
(2, 'A102-2', TRUE),
(3, 'B201-1', FALSE),
(4, 'B202-1', TRUE),
(5, 'C301-1', TRUE),
(5, 'C301-2', FALSE),
(6, 'C302-1', FALSE),
(6, 'C302-2', FALSE),
(7, 'D401-1', FALSE),
(7, 'D401-2', TRUE),
(8, 'D402-1', TRUE),
(9, 'E501-1', FALSE),
(9, 'E501-2', FALSE),
(10, 'E502-1', TRUE),
(10, 'E502-2', FALSE);


show tables;