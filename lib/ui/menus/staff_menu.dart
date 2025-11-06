import 'dart:io';
import '../../database/database.dart';

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
  
  await DoctorOperations.insertDoctor(
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
  
  await StaffOperations.insertNurse(
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
  
  await StaffOperations.insertAdmin(
    name: name,
    role: role,
    deptId: deptId,
    contact: contact?.isEmpty ?? true ? null : contact,
  );
}

Future<void> removeDoctor() async {
  stdout.write('Enter Doctor ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await DoctorOperations.deleteDoctor(id);
}

Future<void> removeNurse() async {
  stdout.write('Enter Nurse ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await StaffOperations.deleteNurse(id);
}

Future<void> removeAdmin() async {
  stdout.write('Enter Admin ID to remove: ');
  int id = int.parse(stdin.readLineSync()!);
  await StaffOperations.deleteAdmin(id);
}