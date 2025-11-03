import 'dart:io';
import '../data/service.dart';

void main() async {
  await DbHelper.connect(); // connect before starting
  printLoading();

  while (true) {
    showMainMenu();
    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        staffMenu();
        break;
      case '2':
        patientMenu();
        break;
      case '3':
        appointmentMenu();
        break;
      case '4':
        billingMenu();
        break;
      case '5':
        await viewDoctors();
        break;
      case '6':
        await viewPatients();
        break;
      case '7':
        await viewRoomsAndBeds();
        break;
      case '8':
        print('👋 Exiting...');
        exit(0);
      default:
        print('⚠️ Invalid choice.');
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
  print("                   |     ✅ Load Complete!      |");
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
  print('4 - Billing Management');
  print('5 - View Doctors');
  print('6 - View Patients');
  print('7 - View Rooms & Beds');
  print('8 - Exit');
  stdout.write('Choose an option: ');
}

// =======================
// Staff Menu
// =======================
void staffMenu() {
  print('\n===== STAFF MANAGEMENT =====');
  print('1 - Add Doctor');
  print('2 - Add Nurse');
  print('3 - Add Admin');
  print('4 - Back to Main Menu');
  stdout.write('Choose an option: ');
  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      addDoctor();
      break;
    case '2':
      addNurse();
      break;
    case '3':
      addAdmin();
      break;
    case '4':
      return;
    default:
      print('⚠️ Invalid choice.');
  }
}

// =======================
// Patient Menu
// =======================
void patientMenu() {
  print('\n===== PATIENT MANAGEMENT =====');
  print('1 - Add Patient');
  print('2 - Admit Patient');
  print('3 - Back to Main Menu');
  stdout.write('Choose an option: ');
  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      addPatient();
      break;
    case '2':
      admitPatient();
      break;
    case '3':
      return;
    default:
      print('⚠️ Invalid choice.');
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
  print('✅ Appointment added: $patient with $doctor on $date because $reason');
}

// =======================
// Billing Menu
// =======================
void billingMenu() {
  print('\n===== BILLING MANAGEMENT =====');
  stdout.write('Patient Name: ');
  String patient = stdin.readLineSync()!;
  stdout.write('Total Amount: ');
  double total = double.parse(stdin.readLineSync()!);
  stdout.write('Paid Amount: ');
  double paid = double.parse(stdin.readLineSync()!);
  String status = (paid >= total) ? 'Paid' : (paid == 0 ? 'Unpaid' : 'Partial');
  print('✅ Billing added for $patient. Status: $status');
}

// =======================
// Add Functions
// =======================
void addDoctor() {
  stdout.write('Doctor Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Specialization: ');
  String spec = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  print('✅ Doctor added: $name, Spec: $spec, Dept: $deptId');
}

void addNurse() {
  stdout.write('Nurse Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  print('✅ Nurse added: $name, Dept: $deptId');
}

void addAdmin() {
  stdout.write('Admin Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Role: ');
  String role = stdin.readLineSync()!;
  stdout.write('Department ID: ');
  int deptId = int.parse(stdin.readLineSync()!);
  print('✅ Admin added: $name, Role: $role, Dept: $deptId');
}

void addPatient() {
  stdout.write('Patient Name: ');
  String name = stdin.readLineSync()!;
  stdout.write('Gender: ');
  String gender = stdin.readLineSync()!;
  stdout.write('DOB (YYYY-MM-DD): ');
  String dob = stdin.readLineSync()!;
  print('✅ Patient added: $name, $gender, DOB: $dob');
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
  print('✅ Patient admitted: $name, Room $room, Bed $bed on $date');
}

// =======================
// View Functions (from DB)
// =======================
Future<void> viewDoctors() async {
  print('\n===== DOCTORS =====');
  final doctors = await DbHelper.getDoctors();
  if (doctors.isEmpty) {
    print('⚠️ No doctors found.');
  } else {
    for (var d in doctors) {
      print(
          '🩺 ID: ${d['id']} | Name: ${d['name']} | Spec: ${d['specialization']} | Dept: ${d['department_id']}');
    }
  }
}

Future<void> viewPatients() async {
  print('\n===== PATIENTS =====');
  final patients = await DbHelper.getPatients();
  if (patients.isEmpty) {
    print('⚠️ No patients found.');
  } else {
    for (var p in patients) {
      print(
          '👤 ID: ${p['id']} | Name: ${p['name']} | Gender: ${p['gender']} | DOB: ${p['dob']}');
    }
  }
}

Future<void> viewRoomsAndBeds() async {
  print('\n===== ROOMS & BEDS =====');
  final rooms = await DbHelper.getRoomsAndBeds();
  if (rooms.isEmpty) {
    print('⚠️ No rooms found.');
  } else {
    for (var r in rooms) {
      print(
          '🏥 Room ${r['room_number']} | Bed ${r['bed_number']} | Status: ${r['availability']}');
    }
  }
}
