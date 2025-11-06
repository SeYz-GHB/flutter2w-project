import 'dart:io';
import '../database/database.dart';
import 'menus/main_menu.dart';
import 'menus/staff_menu.dart';
import 'menus/patient_menu.dart';
import 'menus/appointment_menu.dart';
import 'views/staff_view.dart';
import 'views/patient_view.dart';
import 'utils/loading.dart';

void main() async {
  await DbHelper.connect();
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
        await appointmentMenu();
        break;
      case '4':
        await viewAllStaff();
        break;
      case '5':
        await viewPatients();
        break;
      case '6':
        print('Exiting...');
        await DbHelper.close();
        exit(0);
      default:
        print('Invalid choice.');
    }
  }
}