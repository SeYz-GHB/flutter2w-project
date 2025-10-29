import 'dart:io';
import '../domain/hospital_system.dart';
import '../data/data_service.dart';

void main() {
  final dataService = DataService();
  Hospital hospital = dataService.loadHospitalData();

  while (true) {
    print('\n===== HOSPITAL STAFF MANAGEMENT =====');
    print('1. Add Doctor');
    print('2. Add Nurse');
    print('3. Add Admin Staff');
    print('4. View All Staff');
    print('5. Save Data');
    print('6. Exit');
    stdout.write('Choose an option: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter Name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Enter Salary: ');
        double salary = double.parse(stdin.readLineSync()!);
        stdout.write('Enter Specialization: ');
        String spec = stdin.readLineSync()!;
        hospital.addDoctor(Doctor(id: '', name: name, salary: salary, specialization: spec));
        break;

      case '2':
        stdout.write('Enter Name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Enter Salary: ');
        double salary = double.parse(stdin.readLineSync()!);
        stdout.write('Enter Specialization: ');
        String spec = stdin.readLineSync()!;
        hospital.addNurse(Nurse(id: '', name: name, salary: salary, specialization: spec));
        break;

      case '3':
        stdout.write('Enter Name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Enter Salary: ');
        double salary = double.parse(stdin.readLineSync()!);
        stdout.write('Enter Role: ');
        String role = stdin.readLineSync()!;
        hospital.addAdministrativeStaff(AdministrativeStaff(id: '', name: name, salary: salary, specialization: role));
        break;

      case '4':
        hospital.displayAllStaff();
        break;

      case '5':
        dataService.saveHospitalData(hospital);
        break;

      case '6':
        print('👋 Exiting... Goodbye!');
        return;

      default:
        print('⚠️ Invalid choice. Try again.');
    }
  }
}
