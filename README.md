# Hospital Management System (specific on management staff)

A command-line hospital management system built with **pure Dart** and **SQLite**, featuring staff management, patient records, and appointment scheduling.

##  Features

### Staff Management
- **Doctors**: Add, view, and remove doctors with specializations
- **Nurses**: Manage nursing staff with department assignments
- **Admins**: Track administrative personnel
- Complete staff directory with role-based filtering

### Patient Management
- Register new patients with personal information
- Store patient demographics (name, gender, DOB, address, phone)
- View complete patient records
- Remove patient records

### Appointment System
- Schedule appointments between patients and doctors
- View all scheduled appointments with details
- Cancel/delete appointments
- Smart validation (prevents booking with non-existent patients/doctors)

### User Interface
- Clean CLI menu system
- Loading animation on startup
- Organized menu navigation
- Input validation and error handling

## Architecture

### Project Structure
```
hospitalProject/
├── lib/
│   ├── database/                 # Database layer
│   │   ├── database.dart         # Barrel file (exports all DB operations)
│   │   ├── db_helper.dart        # SQLite connection & utilities
│   │   ├── doctor_operations.dart
│   │   ├── patient_operations.dart
│   │   ├── staff_operations.dart
│   │   └── appointment_operations.dart
│   │
│   ├── ui/                       # User interface layer
│   │   ├── main.dart             # Application entry point
│   │   ├── menus/                # Menu logic
│   │   │   ├── main_menu.dart
│   │   │   ├── staff_menu.dart
│   │   │   ├── patient_menu.dart
│   │   │   └── appointment_menu.dart
│   │   ├── views/                # Display logic
│   │   │   ├── staff_view.dart
│   │   │   └── patient_view.dart
│   │   └── utils/                # Utilities
│   │       └── loading.dart
│   │
│   └── assets/
│       └── hospital_schema.sql   # Database schema
│
├── hospital_management.db        # SQLite database file
├── pubspec.yaml                  # Dependencies
└── README.md
```

### Database Schema

```sql
-- Main Tables
├── department (dept_id, name, description)
├── doctor (doctor_id, name, specialization, dept_id, phone, email)
├── staff (staff_id, name, role, dept_id, contact)
├── patient (patient_id, name, gender, dob, address, phone)
└── appointment (appointment_id, patient_id, doctor_id, appointment_date, status, reason)
```

### Design Pattern
The project follows a **layered architecture**:

1. **Database Layer** (`lib/database/`)
   - Handles all database operations
   - Separated by domain (Doctor, Patient, Staff, Appointment)
   - Single responsibility principle

2. **UI Layer** (`lib/ui/`)
   - Menu-driven interface
   - Separated by feature (menus, views, utils)
   - Clean imports using barrel files

## 🚀 Getting Started

### Prerequisites
- Dart SDK (3.0.0 or higher)
- No Flutter required - this is pure Dart!

### Installation

1. **Clone the repository**
   ```bash
   git clone <https://github.com/SeYz-GHB/flutter2w-project.git>
   cd hospitalProject
   ```

2. **Install dependencies**
   ```bash
   dart pub get
   ```

3. **Run the application**
   ```bash
   dart lib/ui/main.dart
   ```

### Dependencies
```yaml
dependencies:
  sqflite_common_ffi: ^2.3.0  # SQLite for desktop
  path: ^1.8.4
```

## Usage Guide

### Main Menu
```
===== HOSPITAL MANAGEMENT SYSTEM =====
1 - Staff Management
2 - Patient Management
3 - Appointment Management
4 - View All Staff
5 - View Patients
6 - Exit
```

### Staff Management Operations
- **Add Doctor**: Enter name, specialization, department ID, phone, email
- **Add Nurse**: Enter name, department ID, contact
- **Add Admin**: Enter name, role, department ID, contact
- **Remove Staff**: Enter staff member ID to delete

### Patient Management Operations
- **Add Patient**: Enter name, gender, DOB (YYYY-MM-DD), address, phone
- **Remove Patient**: Enter patient ID to delete

### Appointment Management
- **Create Appointment**: 
  - Select patient from available list
  - Select doctor from available list
  - Enter date (YYYY-MM-DD HH:MM)
  - Enter reason for visit
- **View Appointments**: See all scheduled appointments with details
- **Cancel Appointment**: Remove appointment by ID

## Development

### Adding New Features

#### 1. Add a new database operation
Create a new file in `lib/database/`:
```dart
// lib/database/new_feature_operations.dart
import 'db_helper.dart';

class NewFeatureOperations {
  static Future<bool> insertNewFeature(...) async {
    final db = await DbHelper.connect();
    // Your code here
  }
}
```

Then export it in `lib/database/database.dart`:
```dart
export 'new_feature_operations.dart';
```

#### 2. Add a new menu
Create a new file in `lib/ui/menus/`:
```dart
// lib/ui/menus/new_menu.dart
import 'dart:io';
import '../../database/database.dart';

Future<void> newMenu() async {
  // Your menu code here
}
```

Import and call it from `lib/ui/main.dart`.

### Testing the Database

Run the database test utility:
```bash
dart lib/ui/db_test.dart
```

This will show:
- All tables in the database
- Record counts for each table
- Sample data from doctors, patients, and appointments

## 🗄️ Database Operations

### Connection Management
```dart
// Connect to database
await DbHelper.connect();

// Close connection
await DbHelper.close();

// Reset database (delete and recreate)
await DbHelper.resetDatabase();
```

### CRUD Examples

**Create:**
```dart
await DoctorOperations.insertDoctor(
  name: 'Dr. Smith',
  specialization: 'Cardiology',
  deptId: 1,
  phone: '555-0100',
  email: 'smith@hospital.com',
);
```

**Read:**
```dart
var doctors = await DoctorOperations.getDoctors();
var patients = await PatientOperations.getPatients();
var appointments = await AppointmentOperations.getAppointments();
```

**Delete:**
```dart
await DoctorOperations.deleteDoctor(doctorId);
await PatientOperations.deletePatient(patientId);
await AppointmentOperations.deleteAppointment(appointmentId);
```

## Database Viewing

### Option 1: DB Browser for SQLite
1. Download from https://sqlitebrowser.org/
2. Open `hospital_management.db`
3. Browse tables visually

### Option 2: Command Line
```bash
sqlite3 hospital_management.db
SELECT * FROM doctor;
SELECT * FROM patient;
.quit
```

### Option 3: Built-in Test Tool
```bash
dart lib/ui/db_test.dart
```

## Key Features Implemented

### Core Functionality
- [x] SQLite database integration
- [x] Staff CRUD operations (Doctors, Nurses, Admins)
- [x] Patient CRUD operations
- [x] Appointment scheduling system
- [x] Menu-driven CLI interface
- [x] Database connection pooling (single connection reuse)

### Code Quality
- [x] Modular architecture (separation of concerns)
- [x] Error handling with try-catch blocks
- [x] Input validation
- [x] Clean code organization
- [x] No code duplication (DRY principle)

### User Experience
- [x] Loading animation
- [x] Clear menu navigation
- [x] Helpful error messages
- [x] Confirmation prompts for deletions
- [x] Data validation before operations

## 🔧 Troubleshooting

### Common Issues

**Issue: "Database file not found"**
- Solution: Ensure you run from the project root directory
- The database is created automatically on first run

**Issue: "Method not found" errors**
- Solution: Make sure you have the latest code and run `dart pub get`

**Issue: Import path errors**
- Solution: Use relative imports (`../database/database.dart`) from UI files


## Author
Khen chandarapisey
Soy Chanratana
## Acknowledgments

- Dart team for excellent documentation
- sqflite_common_ffi for SQLite support on desktop
- Community for best practices and patterns

---

**Made with using pure Dart**