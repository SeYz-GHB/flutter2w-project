import 'dart:io' ;
import '../../database/database.dart' ;
import  '../utils/screen_utils.dart' ;


Future<void> patientMenu() async {
  
  while(true){
    clearScreenSimple() ;
    print('\n===== PATIENT MANAGEMENT =====') ;
    print('1 - Add Patient') ;
    print('2 - Remove Patient') ;
    print('3 - Back to Main Menu') ;
    stdout.write('Choose an option: ') ;
    
    String? choice = stdin.readLineSync() ;
    
    switch(choice){
      case '1':
        clearScreenSimple() ;
        await addPatient() ;
        stdout.write('\nPress Enter to continue...') ;
        stdin.readLineSync() ;
        break ;
        
      case '2' :
        clearScreenSimple() ;
        await removePatient( ) ;
        stdout.write('\nPress Enter to continue...' ) ;
        stdin.readLineSync() ;
        break;
        
      case '3' :
        return ;
        
      default:
        print('Invalid choice..') ;
        await Future.delayed(Duration(seconds : 1)) ;
    }
  }
}



Future<void> addPatient( ) async {

  stdout.write('Patient Name: ') ;
  String name = stdin.readLineSync()! ;


  stdout.write('Gender : ') ;
  String gender = stdin.readLineSync()! ;

  stdout.write('DOB (YYYY-MM-DD): ') ;
  String dob = stdin.readLineSync()! ;

  stdout.write('Address : ') ;
  String address = stdin.readLineSync()! ;

  stdout.write('Phone : ') ;
  String phone = stdin.readLineSync()! ;
  
  await  PatientOperations.insertPatient(
    name: name ,
    gender: gender,
    dob: dob ,
    address: address ,
    phone: phone ,
  ) ;
}




Future<void> removePatient() async {
  stdout.write('Enter Patient ID to remove : ') ;
  int id = int.parse( stdin.readLineSync( )! ) ;
  
  await PatientOperations.deletePatient( id ) ;
}
