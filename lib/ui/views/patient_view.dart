import '../../database/database.dart';

Future<void> viewPatients() async {
  print('\n===== PATIENTS =====');
  final patients = await PatientOperations.getPatients();
  if (patients.isEmpty) {
    print('No patients found.');
  } else {
    for (var p in patients) {
      print(
          'ID: ${p['id']} | Name: ${p['name']} | Gender: ${p['gender']} | DOB: ${p['dob']}');
    }
  }
}