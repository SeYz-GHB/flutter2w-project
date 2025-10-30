class Department {
  int? deptId;
  String name;
  String? description;

  Department({
    this.deptId,
    required this.name,
    this.description,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        deptId: json['dept_id'],
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'dept_id': deptId,
        'name': name,
        'description': description,
      };
}
