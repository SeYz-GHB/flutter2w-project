class Patient {
  int? patientId;
  String name;
  String gender;
  DateTime dob;
  String address;
  String phone;

  Patient({
    this.patientId,
    required this.name,
    required this.gender,
    required this.dob,
    required this.address,
    required this.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientId: json['patient_id'],
        name: json['name'],
        gender: json['gender'],
        dob: DateTime.parse(json['dob']),
        address: json['address'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'patient_id': patientId,
        'name': name,
        'gender': gender,
        'dob': dob.toIso8601String(),
        'address': address,
        'phone': phone,
      };
}
