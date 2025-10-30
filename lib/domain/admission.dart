import 'patient.dart';
import 'room.dart';

class Admission {
  int? admissionId;
  Patient? patient;
  Room? room;
  DateTime admitDate;
  DateTime? dischargeDate;

  Admission({
    this.admissionId,
    this.patient,
    this.room,
    required this.admitDate,
    this.dischargeDate,
  });

  factory Admission.fromJson(Map<String, dynamic> json) => Admission(
        admissionId: json['admission_id'],
        patient: json['patient'] != null
            ? Patient.fromJson(json['patient'])
            : null,
        room: json['room'] != null ? Room.fromJson(json['room']) : null,
        admitDate: DateTime.parse(json['admit_date']),
        dischargeDate: json['discharge_date'] != null
            ? DateTime.parse(json['discharge_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'admission_id': admissionId,
        'patient': patient?.toJson(),
        'room': room?.toJson(),
        'admit_date': admitDate.toIso8601String(),
        'discharge_date': dischargeDate?.toIso8601String(),
      };
}
