import 'department.dart';
import 'staff.dart';

class Doctor extends Staff {
  int? doctorId;
  String? specialization;
  String? phone;
  String? email;

  Doctor({
    this.doctorId,
    required String name,
    this.specialization,
    Department? department,
    this.phone,
    this.email,
  }) : super(
          staffId: doctorId,
          name: name,
          role: 'Doctor',
          department: department,
          contact: phone,
        );

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

  @override
  Map<String, dynamic> toJson() => {
        'doctor_id': doctorId,
        'name': name,
        'specialization': specialization,
        'department': department?.toJson(),
        'phone': phone,
        'email': email,
      };
}