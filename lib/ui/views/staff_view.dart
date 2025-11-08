import '../../database/database.dart';

Future<void> viewAllStaff() async {
  print('\n===== ALL STAFF =====');
  

  print('\n--- DOCTORS ---');
  final doctors = await DoctorOperations.getDoctors();
  if (doctors.isEmpty) {
    print('No doctors found.');
  } 
  
  else {
    
    for (var d in doctors) {
      print(
          'ID: ${d['id']} | Name: ${d['name']} | Spec: ${d['specialization']} | Dept: ${d['department_id']}');
    }
  }
  
 
  final staff = await StaffOperations.getStaff();
  

  print('\n--- NURSES ---');
  final nurses = staff.where((s) => s['role'] == 'Nurse').toList();
  if (nurses.isEmpty) {

    print('No nurses found.');
  }

  else {
    
    for (var n in nurses) {
      print(
          'ID: ${n['id']} | Name: ${n['name']} | Dept: ${n['department_id']} | Contact: ${n['contact']}');
    }
  }
  

  print('\n--- ADMINS ---');
  final admins = staff.where((s) => s['role'] != 'Nurse').toList();
  if (admins.isEmpty) {

    print('No admins found.');

  } 
  
  else {
    for (var a in admins) {
      print(
          'ID: ${a['id']} | Name: ${a['name']} | Role: ${a['role']} | Dept: ${a['department_id']} | Contact: ${a['contact']}');
    }
  }
}