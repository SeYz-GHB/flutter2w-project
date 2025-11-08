import 'dart:io';
import '../database/database.dart';
import 'menus/main_menu.dart';
import 'menus/staff_menu.dart';
import 'menus/patient_menu.dart';
import 'menus/appointment_menu.dart';
import 'views/staff_view.dart';
import 'views/patient_view.dart';
import 'utils/loading.dart';
import 'utils/screen_utils.dart';  

void main() async {
  await DbHelper.connect();
  printLoading();

  while (true) {
    clearScreenSimple();  
    showMainMenu();
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        clearScreenSimple(); 
        await staffMenu();
        break;
      case '2':
        clearScreenSimple();
        await patientMenu();
        break;
      case '3':
        clearScreenSimple();
        await appointmentMenu();
        break;
      case '4':
        clearScreenSimple();
        await viewAllStaff();
        stdout.write('\nPress Enter to continue...');
        stdin.readLineSync();
        break;
      case '5':
        clearScreenSimple();
        await viewPatients();
        stdout.write('\nPress Enter to continue...');
        stdin.readLineSync();
        break;
      case '6':
        clearScreenSimple();
        print('Exiting...');
        await DbHelper.close();
        exit(0);
      default:
        print('Invalid choice.');
    }
  }
}