import 'patient.dart';
import 'doctor.dart';

class MedicalRecord {
  int? recordId;
  Patient? patient;
  Doctor? doctor;
  String diagnosis;
  String prescription;
  DateTime recordDate;

  MedicalRecord({
    this.recordId,
    this.patient,
    this.doctor,
    required this.diagnosis,
    required this.prescription,
    required this.recordDate,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        recordId: json['record_id'],
        patient: json['patient'] != null
            ? Patient.fromJson(json['patient'])
            : null,
        doctor: json['doctor'] != null
            ? Doctor.fromJson(json['doctor'])
            : null,
        diagnosis: json['diagnosis'],
        prescription: json['prescription'],
        recordDate: DateTime.parse(json['record_date']),
      );

  Map<String, dynamic> toJson() => {
        'record_id': recordId,
        'patient': patient?.toJson(),
        'doctor': doctor?.toJson(),
        'diagnosis': diagnosis,
        'prescription': prescription,
        'record_date': recordDate.toIso8601String(),
      };
}
