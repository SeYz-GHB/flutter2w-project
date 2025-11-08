import 'dart:io';
import '../../database/database.dart';
import '../utils/screen_utils.dart';


Future<void> appointmentMenu() async {
  while (true) {
    clearScreenSimple(); 
    print('\n===== APPOINTMENT MANAGEMENT =====');
    print('1 - Create Appointment');
    print('2 - View All Appointments');
    print('3 - Cancel/Delete Appointment');
    print('4 - Back to Main Menu');
    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        clearScreenSimple();
        await createAppointment();
        stdout.write('\nPress Enter to continue...');
        stdin.readLineSync();
        break;
      case '2':
        clearScreenSimple();
        await viewAppointments();
        stdout.write('\nPress Enter to continue...');
        stdin.readLineSync();
        break;
      case '3':
        clearScreenSimple();
        await cancelAppointment();
        stdout.write('\nPress Enter to continue...');
        stdin.readLineSync();
        break;
      case '4':
        return;
      default:
        print('Invalid choice.');
        await Future.delayed(Duration(seconds: 1));
    }
  }
}


String formatAppointmentDate(DateTime date) {
  return '${date.year}-'
         '${date.month.toString().padLeft(2, '0')}-'
         '${date.day.toString().padLeft(2, '0')} '
         '${date.hour.toString().padLeft(2, '0')}:'
         '${date.minute.toString().padLeft(2, '0')}';
}


DateTime? parseAppointmentDate(String input) {
  try {
  
    List<String> parts = input.trim().split(' ');
    List<String> dateParts = parts[0].split('-');
    
    if (dateParts.length != 3) return null;
    
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    
    int hour = 0;
    int minute = 0;
    
  
    if (parts.length > 1) {
      List<String> timeParts = parts[1].split(':');
      if (timeParts.length >= 2) {
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1]);
      }
    }
    
    return DateTime(year, month, day, hour, minute);
  } catch (e) {
    return null;
  }
}


Future<void> createAppointment() async {
  print('\n===== CREATE APPOINTMENT =====');
  
  // Get patient ID with retry
  int? patientId;
  while (patientId == null) {
    final patients = await PatientOperations.getPatients();
    if (patients.isEmpty) {
      print('❌ No patients in system. Add patients first.');
      return;
    }
    
    print('\nAvailable Patients:');
    for (var p in patients) {
      print('  ID: ${p['id']} - ${p['name']}');
    }
    
    stdout.write('Enter Patient ID (or 0 to cancel): ');
    int? inputId = int.tryParse(stdin.readLineSync()!);
    
    if (inputId == 0) {
      print('Cancelled.');
      return;
    }
    
    if (inputId == null) {
      print('❌ Invalid input. Please enter a number.');
      continue;
    }
    
    if (!patients.any((p) => p['id'] == inputId)) {
      print('❌ Patient ID $inputId not found. Please try again.');
      continue;
    }
    
    patientId = inputId;
  }
  
 
  int? doctorId;
  while (doctorId == null) {
    final doctors = await DoctorOperations.getDoctors();
    if (doctors.isEmpty) {
      print('❌ No doctors in system. Add doctors first.');
      return;
    }
    
    print('\nAvailable Doctors:');
    for (var d in doctors) {
      print('  ID: ${d['id']} - ${d['name']} (${d['specialization']})');
    }
    
    stdout.write('Enter Doctor ID (or 0 to cancel): ');
    int? inputId = int.tryParse(stdin.readLineSync()!);
    
    if (inputId == 0) {
      print('Cancelled.');
      return;
    }
    
    if (inputId == null) {
      print('❌ Invalid input. Please enter a number.');
      continue;
    }
    
    if (!doctors.any((d) => d['id'] == inputId)) {
      print('❌ Doctor ID $inputId not found. Please try again.');
      continue;
    }
    
    doctorId = inputId;
  }
  

  DateTime? appointmentDate;
  while (appointmentDate == null) {
    print('\nEnter appointment date and time:');
    print('Format: YYYY-MM-DD HH:MM (e.g., 2025-11-15 14:30)');
    print('Or just date: YYYY-MM-DD (time will default to 00:00)');
    stdout.write('Date: ');
    String? dateInput = stdin.readLineSync();
    
    if (dateInput == null || dateInput.isEmpty) {
      print('❌ Date cannot be empty.');
      continue;
    }
    
    appointmentDate = parseAppointmentDate(dateInput);
    
    if (appointmentDate == null) {
      print('❌ Invalid date format. Please use YYYY-MM-DD HH:MM or YYYY-MM-DD');
      continue;
    }
    
    // Check if date is in the past
    if (appointmentDate.isBefore(DateTime.now())) {
      print('⚠️  Warning: This date is in the past!');
      stdout.write('Continue anyway? (y/n): ');
      String? confirm = stdin.readLineSync()?.toLowerCase();
      if (confirm != 'y' && confirm != 'yes') {
        appointmentDate = null;
        continue;
      }
    }
  }
  
  stdout.write('Reason: ');
  String reason = stdin.readLineSync() ?? '';
  
  // Format the date properly before saving
  String formattedDate = formatAppointmentDate(appointmentDate);
  
  bool success = await AppointmentOperations.insertAppointment(
    patientId: patientId,
    doctorId: doctorId,
    appointmentDate: formattedDate,  // ✅ Properly formatted
    status: 'Scheduled',
    reason: reason.isNotEmpty ? reason : null,
  );
  
  if (success) {
    print('✅ Appointment created successfully!');
    print('   Date: $formattedDate');
  } else {
    print('❌ Failed to create appointment');
  }
}

// =======================
// View Appointments
// =======================
Future<void> viewAppointments() async {
  print('\n===== ALL APPOINTMENTS =====');
  final appointments = await AppointmentOperations.getAppointments();
  
  if (appointments.isEmpty) {
    print('No appointments found.');
  } else {
    for (var a in appointments) {
      print('─' * 60);
      print('Date: ${a['date']}');
      print('ID: ${a['id']}');
      print('Patient: ${a['patient_name']}');
      print('Doctor: ${a['doctor_name']} (${a['specialization']})');
      print('Status: ${a['status']}');
      print('Reason: ${a['reason'] ?? 'N/A'}');
    }
    print('─' * 60);
  }
}

// =======================
// Cancel Appointment
// =======================
Future<void> cancelAppointment() async {
  print('\n===== CANCEL APPOINTMENT =====');
  
  int? appointmentId;
  while (appointmentId == null) {
    final appointments = await AppointmentOperations.getAppointments();
    if (appointments.isEmpty) {
      print('❌ No appointments to cancel.');
      return;
    }
    
    print('\nCurrent Appointments:');
    for (var a in appointments) {
      print('ID: ${a['id']} - ${a['patient_name']} with Dr. ${a['doctor_name']} on ${a['date']} [${a['status']}]');
    }
    
    stdout.write('\nEnter Appointment ID to cancel (or 0 to go back): ');
    int? inputId = int.tryParse(stdin.readLineSync()!);
    
    if (inputId == 0) {
      print('Cancelled.');
      return;
    }
    
    if (inputId == null) {
      print('❌ Invalid input. Please enter a number.');
      continue;
    }
    
    if (!appointments.any((a) => a['id'] == inputId)) {
      print('❌ Appointment ID $inputId not found. Please try again.');
      continue;
    }
    
    appointmentId = inputId;
  }
  
  stdout.write('Are you sure you want to cancel this appointment? (y/n): ');
  String? confirm = stdin.readLineSync()?.toLowerCase();
  
  if (confirm == 'y' || confirm == 'yes') {
    bool success = await AppointmentOperations.deleteAppointment(appointmentId);
    if (!success) {
      print('❌ Failed to cancel appointment');
    }
  } else {
    print('Cancellation aborted.');
  }
}