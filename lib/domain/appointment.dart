import 'patient.dart';
import 'doctor.dart';

class Appointment {
  int? appointmentId;
  Patient? patient;
  Doctor? doctor;
  DateTime appointmentDate;
  String status;
  String? reason;

  Appointment({
    this.appointmentId,
    this.patient,
    this.doctor,
    required this.appointmentDate,
    required this.status,
    this.reason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        appointmentId: json['appointment_id'],
        patient: json['patient'] != null
            ? Patient.fromJson(json['patient'])
            : null,
        doctor: json['doctor'] != null
            ? Doctor.fromJson(json['doctor'])
            : null,
        appointmentDate: DateTime.parse(json['appointment_date']),
        status: json['status'],
        reason: json['reason'],
      );

  Map<String, dynamic> toJson() => {
        'appointment_id': appointmentId,
        'patient': patient?.toJson(),
        'doctor': doctor?.toJson(),
        'appointment_date': appointmentDate.toIso8601String(),
        'status': status,
        'reason': reason,
      };
}
