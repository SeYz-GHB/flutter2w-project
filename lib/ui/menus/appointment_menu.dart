import 'dart:io';
import '../../database/database.dart';

Future<void> appointmentMenu() async {
  print('\n===== APPOINTMENT MANAGEMENT =====');
  print('1 - Create Appointment');
  print('2 - View All Appointments');
  print('3 - Cancel/Delete Appointment');
  print('4 - Back to Main Menu');
  stdout.write('Choose an option: ');
  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await createAppointment();
      break;
    case '2':
      await viewAppointments();
      break;
    case '3':
      await cancelAppointment();
      break;
    case '4':
      return;
    default:
      print('Invalid choice.');
  }
}

// =======================
// Create Appointment
// =======================
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
  
  // Get doctor ID with retry
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
  
  stdout.write('Date (YYYY-MM-DD HH:MM): ');
  String date = stdin.readLineSync()!;
  stdout.write('Reason: ');
  String reason = stdin.readLineSync()!;
  
  bool success = await AppointmentOperations.insertAppointment(
    patientId: patientId,
    doctorId: doctorId,
    appointmentDate: date,
    status: 'Scheduled',
    reason: reason,
  );
  
  if (success) {
    print('✅ Appointment created successfully!');
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