# Hospital Management System

A simple hospital management system implemented in Dart that demonstrates object-oriented programming concepts including inheritance, encapsulation, and class relationships.

## Overview

This system models a basic hospital structure with staff members (doctors and nurses) and patients. It provides functionality to manage doctors, nurses, and patients within a hospital.

## Class Structure

### Staff (Base Class)
The parent class for all hospital staff members.

**Properties:**
- `id` - Unique identifier for the staff member
- `name` - Staff member's name
- `salary` - Staff member's salary

### Doctor (extends Staff)
Represents doctors in the hospital.

**Additional Properties:**
- `specialization` - The doctor's area of medical expertise

### Nurse (extends Staff)
Represents nurses in the hospital.

Inherits all properties from the Staff class without additional fields.

### Patient
Represents patients receiving care at the hospital.

**Properties:**
- `id` - Unique identifier for the patient
- `name` - Patient's name
- `disease` - Patient's condition or diagnosis
- `assignedDoctor` - The doctor assigned to this patient (optional)

### Hospital
The main class that manages the hospital operations.

**Properties:**
- `name` - Name of the hospital
- `doctors` - List of doctors working at the hospital
- `nurses` - List of nurses working at the hospital
- `patients` - List of patients at the hospital

**Methods:**
- `addDoctor(Doctor doctor)` - Adds a doctor to the hospital
- `addPatient(Patient patient)` - Adds a patient to the hospital

## Usage Example
```dart