import 'department.dart';

class Doctor {
  int? doctorId;
  String name;
  String? specialization;
  Department? department;
  String? phone;
  String? email;

  Doctor({
    this.doctorId,
    required this.name,
    this.specialization,
    this.department,
    this.phone,
    this.email,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        doctorId: json['doctor_id'],
        name: json['name'],
        specialization: json['specialization'],
        department: json['department'] != null
            ? Department.fromJson(json['department'])
            : null,
        phone: json['phone'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'doctor_id': doctorId,
        'name': name,
        'specialization': specialization,
        'department': department?.toJson(),
        'phone': phone,
        'email': email,
      };
}
