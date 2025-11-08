import '../database/database.dart';

Future<void> main() async {
  print('🔍 DATABASE TESTING TOOL\n');

  try {
    // Connect
    await DbHelper.connect();
    print(" Connected to SQLite!\n");
    final db = await DbHelper.connect();

    // Show all tables
    print('=' * 50);
    print(' TABLES IN DATABASE');
    print('=' * 50);
    var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");
    for (var row in tables) {
      print('  ✓ ${row['name']}');
    }

    // Show counts for each table
    print('\n' + '=' * 50);
    print(' RECORD COUNTS');
    print('=' * 50);

    try {
      var deptCount =
          await db.rawQuery('SELECT COUNT(*) as count FROM department');
      print('  Department: ${deptCount.first['count']}');
    } catch (e) {
      print('  Department: 0');
    }

    try {
      var doctorCount =
          await db.rawQuery('SELECT COUNT(*) as count FROM doctor');
      print('  Doctor: ${doctorCount.first['count']}');
    } catch (e) {
      print('  Doctor: 0');
    }

    try {
      var staffCount = await db.rawQuery('SELECT COUNT(*) as count FROM staff');
      print('  Staff: ${staffCount.first['count']}');
    } catch (e) {
      print('  Staff: 0');
    }

    try {
      var patientCount =
          await db.rawQuery('SELECT COUNT(*) as count FROM patient');
      print('  Patient: ${patientCount.first['count']}');
    } catch (e) {
      print('  Patient: 0');
    }

    try {
      var appointmentCount =
          await db.rawQuery('SELECT COUNT(*) as count FROM appointment');
      print('  Appointment: ${appointmentCount.first['count']}');
    } catch (e) {
      print('  Appointment: 0');
    }

    // Sample data from doctors (if any)
    print('\n' + '=' * 50);
    print(' SAMPLE DOCTORS');
    print('=' * 50);
    var doctors = await DoctorOperations.getDoctors();
    if (doctors.isEmpty) {
      print('  No doctors in database');
    } else {
      for (var d in doctors.take(5)) {
        print('  ID: ${d['id']} | ${d['name']} (${d['specialization']})');
      }
      if (doctors.length > 5) {
        print('  ... and ${doctors.length - 5} more');
      }
    }

    // Sample data from patients (if any)
    print('\n' + '=' * 50);
    print(' SAMPLE PATIENTS');
    print('=' * 50);
    var patients = await PatientOperations.getPatients();
    if (patients.isEmpty) {
      print('  No patients in database');
    } else {
      for (var p in patients.take(5)) {
        print('  ID: ${p['id']} | ${p['name']} (${p['gender']})');
      }
      if (patients.length > 5) {
        print('  ... and ${patients.length - 5} more');
      }
    }

    // Sample appointments
    print('\n' + '=' * 50);
    print(' SAMPLE APPOINTMENTS');
    print('=' * 50);
    var appointments = await AppointmentOperations.getAppointments();
    if (appointments.isEmpty) {
      print('  No appointments in database');
    } else {
      for (var a in appointments.take(5)) {
        print(
            '  ID: ${a['id']} | ${a['patient_name']} → Dr. ${a['doctor_name']} (${a['date']})');
      }
      if (appointments.length > 5) {
        print('  ... and ${appointments.length - 5} more');
      }
    }

    // Close
    await DbHelper.close();
    print('\n Test complete!\n');
  } catch (e, st) {
    print(' Error: $e');
    print(st);
  }
}
