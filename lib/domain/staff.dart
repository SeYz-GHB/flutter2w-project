import 'department.dart';

class Staff {
  int? staffId;
  String name;
  String role;
  Department? department;
  String? contact;

  Staff({
    this.staffId,
    required this.name,
    required this.role,
    this.department,
    this.contact,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        staffId: json['staff_id'],
        name: json['name'],
        role: json['role'],
        department: json['department'] != null
            ? Department.fromJson(json['department'])
            : null,
        contact: json['contact'],
      );

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
        'name': name,
        'role': role,
        'department': department?.toJson(),
        'contact': contact,
      };
}
