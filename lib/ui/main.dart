import 'dart:io';
import '../data/sqlite_helper.dart';

void main() async {
  await DbHelper.connect(); // connect before starting
  printLoading();

  while (true) {
    showMainMenu();
    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await staffMenu();
        break;
      case '2':
        await patientMenu();
        break;
      case '3':
        appointmentMenu();
        break;
      case '4':
        await viewAllStaff();
        break;
      case '5':
        await viewPatients();
        break;
      case '6':
        print('Exiting...');
        exit(0);
      default:
        print('Invalid choice.');
    }
  }
}

// =======================
// Loading animation
// =======================
void printLoading() {
  const total = 30;
  for (int i = 0; i <= total; i++) {
    stdout.write('\x1B[2J\x1B[0;0H');
    int filled = i;
    String bar = '█' * filled + '-' * (total - filled);

    print("                   ==============================");
    print("                   | Loading... ${i * 100 ~/ total}%      |");
    print("                   ==============================");
    print("                   [$bar]");

    sleep(Duration(milliseconds: 50));
  }

  stdout.write('\x1B[2J\x1B[0;0H');
  print("                   ==============================");
  print("                   |     Load Complete!      |");
  print("                   ==============================");
}

// =======================
// Main Menu
// =======================
void showMainMenu() {
  print('\n===== HOSPITAL MANAGEMENT SYSTEM =====');
  print('1 - Staff Management');
  print('2 - Patient Management');
  print('3 - Appointment Management');
  print('4 - View All Staff');
  print('5 - View Patients');
  print('6 - Exit');
  stdout.write('Choose an option: ');
}

// =======================
// Staff Menu
// =======================
Future<void> staffMenu() async {
  print('\n===== STAFF MANAGEMENT =====');
  print('1 - Add Doctor');
  print('2 - Add Nurse');
  print('3 - Add Admin');
  print('4 - Remove Doctor');
  print('5 - Remove Nurse');
  print('6 - Remove Admin');
  print('7 - Back to Main Menu');
  stdout.write('Choose an option: ');
  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await addDoctor();
      break;
    case '2':
      await addNurse();
      break;
    case '3':
      await addAdmin();
      break;
    case '4':
      await removeDoctor();
      break;
    case '5':
      await removeNurse();
      break;
    case '6':
      await removeAdmin();
      break;
    case '7':
      return;
    default:
      print('Invalid choice.');
  }
}

// =======================
// Patient Menu
// =======================
Future<void> patientMenu() async {
  print('\n===== PATIENT MANAGEMENT =====');
  print('1 - Add Patient');
  print('2 - Admit Patient');
  print('3 - Remove Patient');
  print('4 - Back to Main Menu');
  stdout.write('Choose an option: ');
  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await addPatient();
      break;
    case '2':
      admitPatient();
      break;
    case '3':
      await removePatient();
      break;
    case '4':
      return;
    default:
      print('Invalid choice.');
  }
}

// =======================
// Appointment Menu
// =======================
void appointmentMenu() {
  print('\n===== APPOINTMENT MANAGEMENT =====');
  stdout.write('Patient Name: ');
  String patient = stdin.readLineSync()!;
  stdout.write('Doctor Name: ');
  String doctor = stdin.readLineSync()!;
  stdout.write('Date (YYYY-MM-DD HH:MM): ');
  String date = stdin.readLineSync()!;
  stdout.write('Reason: ');
  String reason = stdin.readLineSync()!;
  print('Appointment added: $patient with $doctor on $date because $reason');
}

// =======================
// Add Functions
// =======================
Future<void> addDoctor() async {
  stdout.write('Doctor Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Specialization: ');
  String spec = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  stdout.write('Phone (optional): ');
  String? phone = stdin.readLineSync();
  stdout.write('Email (optional): ');
  String? email = stdin.readLineSync();
  
  await DbHelper.insertDoctor(
    name: name,
    specialization: spec,
    deptId: deptId,
    phone: phone?.isEmpty ?? true ? null : phone,
    email: email?.isEmpty ?? true ? null : email,
  );
}

Future<void> addNurse() async {
  stdout.write('Nurse Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  stdout.write('Contact (optional): ');
  String? contact = stdin.readLineSync();
  
  await DbHelper.insertNurse(
    name: name,
    deptId: deptId,
    contact: contact?.isEmpty ?? true ? null : contact,
  );
}

Future<void> addAdmin() async {
  stdout.write('Admin Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Role: ');
  String role = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  stdout.write('Contact (optional): ');
  String? contact = stdin.readLineSync();
  
  await DbHelper.insertAdmin(
    name: name,
    role: role,
    deptId: deptId,
    contact: contact?.isEmpty ?? true ? null : contact,
  );
}

Future<void> addPatient() async {
  stdout.write('Patient Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Gender: ');
  String gender = stdin.readLineSync()!;
  stdout.write('DOB (YYYY-MM-DD): ');
  String dob = stdin.readLineSync()!;
  stdout.write('Address: ');
  String address = stdin.readLineSync()!;
  stdout.write('Phone: ');
  String phone = stdin.readLineSync()!;
  
  await DbHelper.insertPatient(
    name: name,
    gender: gender,
    dob: dob,
    address: address,
    phone: phone,
  );
}

void admitPatient() {
  stdout.write('Patient Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Room Number: ');
  String room = stdin.readLineSync()!;
  stdout.write('Bed Number: ');
  String bed = stdin.readLineSync()!;
  stdout.write('Admit Date (YYYY-MM-DD): ');
  String date = stdin.readLineSync()!;
  print('Patient admitted: $name, Room $room, Bed $bed on $date');
}

// =======================
// Delete Functions
// =======================
Future<void> removeDoctor() async {
  stdout.write('Enter Doctor ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await DbHelper.deleteDoctor(id);
}

Future<void> removeNurse() async {
  stdout.write('Enter Nurse ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await DbHelper.deleteNurse(id);
}

Future<void> removeAdmin() async {
  stdout.write('Enter Admin ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await DbHelper.deleteAdmin(id);
}

Future<void> removePatient() async {
  stdout.write('Enter Patient ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await DbHelper.deletePatient(id);
}

// =======================
// View Functions (from DB)
// =======================
Future<void> viewAllStaff() async {
  print('\n===== ALL STAFF =====');
  
  // Get doctors
  print('\n--- DOCTORS ---');
  final doctors = await DbHelper.getDoctors();
  if (doctors.isEmpty) {
    print('No doctors found.');
  } else {
    for (var d in doctors) {
      print(
          'ID: ${d['id']} | Name: ${d['name']} | Spec: ${d['specialization']} | Dept: ${d['department_id']}');
    }
  }
  
  // Get all staff
  final staff = await DbHelper.getStaff();
  
  // Filter and display nurses
  print('\n--- NURSES ---');
  final nurses = staff.where((s) => s['role'] == 'Nurse').toList();
  if (nurses.isEmpty) {
    print('No nurses found.');
  } else {
    for (var n in nurses) {
      print(
          'ID: ${n['id']} | Name: ${n['name']} | Dept: ${n['department_id']} | Contact: ${n['contact']}');
    }
  }
  
  // Filter and display admins
  print('\n--- ADMINS ---');
  final admins = staff.where((s) => s['role'] != 'Nurse').toList();
  if (admins.isEmpty) {
    print('No admins found.');
  } else {
    for (var a in admins) {
      print(
          'ID: ${a['id']} | Name: ${a['name']} | Role: ${a['role']} | Dept: ${a['department_id']} | Contact: ${a['contact']}');
    }
  }
}

Future<void> viewPatients() async {
  print('\n===== PATIENTS =====');
  final patients = await DbHelper.getPatients();
  if (patients.isEmpty) {
    print('No patients found.');
  } else {
    for (var p in patients) {
      print(
          'ID: ${p['id']} | Name: ${p['name']} | Gender: ${p['gender']} | DOB: ${p['dob']}');
    }
  }
}