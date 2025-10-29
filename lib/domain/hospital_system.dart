class Staff {
  String id;
  String name;
  double salary;
  String specialization;

  Staff({required this.id, required this.name, required this.salary, required this.specialization});
}

class Doctor extends Staff {
  Doctor({required String id, required String name, required double salary, required String specialization})
      : super(id: id, name: name, salary: salary, specialization: specialization);
}

class Nurse extends Staff {
  Nurse({required String id, required String name, required double salary, required String specialization}) 
      : super(id: id, name: name, salary: salary, specialization: specialization);
}

class Patient {
  String id;
  String name;
  String disease;
  Doctor? assignedDoctor;

  Patient({required this.id, required this.name, required this.disease, this.assignedDoctor});
}

class AdministrativeStaff extends Staff {
  AdministrativeStaff({
    required String id,        
    required String name, 
    required double salary,
    required String specialization 
  }) : super(id: id, name: name, salary: salary, specialization: specialization); 
}

class Hospital {
  String name;
  List<Doctor> doctors = [];
  List<Nurse> nurses = [];
  List<Patient> patients = [];
  List<AdministrativeStaff> adminStaff = [];


  int _doctorCount = 0;
  int _nurseCount = 0;
  int _adminCount = 0;


  Hospital({required this.name});

  void setDoctorCount(int count) {
    _doctorCount = count;
  }

  void setNurseCount(int count) {
    _nurseCount = count;
  }

  void setAdminCount(int count) {
    _adminCount = count;
  }


   // Auto generate Doctor ID
  String _generateDoctorId() {
    _doctorCount++;
    return 'DR-${_doctorCount.toString().padLeft(4, '0')}';
  }

  // Auto generate Nurse ID
  String _generateNurseId() {
    _nurseCount++;
    return 'NRS-${_nurseCount.toString().padLeft(4, '0')}';
  }

  // Auto generate Admin Staff ID
  String _generateAdminId() {
    _adminCount++;
    return 'ADMS-${_adminCount.toString().padLeft(4, '0')}';
  }

  void addDoctor(Doctor doctor) {
    doctor.id = _generateDoctorId();
    doctors.add(doctor);
    print('Doctor ${doctor.name} added with ID ${doctor.id}!');
  }

  void addNurse(Nurse nurse) {
    nurse.id = _generateNurseId();
    nurses.add(nurse);
    print('Nurse ${nurse.name} added with ID ${nurse.id}!');
  }

  void addAdministrativeStaff(AdministrativeStaff staff) {
    staff.id = _generateAdminId();
    adminStaff.add(staff);
    print('${staff.specialization} ${staff.name} added with ID ${staff.id}!');
  }

  
  void removeDoctor(String id) {
    doctors.removeWhere((doc) => doc.id == id);
    print(' Doctor with ID $id removed!');
  }

  void removeNurse(String id) {
    nurses.removeWhere((nurse) => nurse.id == id);
    print(' Nurse with ID $id removed!');
  }

  void removeAdministrativeStaff(String id) {
    adminStaff.removeWhere((staff) => staff.id == id);
    print(' Administrative staff with ID $id removed!');
  }

  Doctor? findDoctorById(String id) {
    try {
      return doctors.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  Nurse? findNurseById(String id) {
    try {
      return nurses.firstWhere((nurse) => nurse.id == id);
    } catch (e) {
      return null;
    }
  }

  AdministrativeStaff? findAdminStaffById(String id) {
    try {
      return adminStaff.firstWhere((staff) => staff.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateDoctorSalary(String id, double newSalary) {
    var doctor = findDoctorById(id);
    if (doctor != null) {
      doctor.salary = newSalary;
      print(' Doctor ${doctor.name} salary updated to \$${newSalary}');
    } else {
      print(' Doctor not found!');
    }
  }

  void updateNurseSalary(String id, double newSalary) {
    var nurse = findNurseById(id);
    if (nurse != null) {
      nurse.salary = newSalary;
      print('Nurse ${nurse.name} salary updated to \$${newSalary}');
    } else {
      print(' Nurse not found!');
    }
  }

  void updateAdminStaffSalary(String id, double newSalary) {
    var staff = findAdminStaffById(id);
    if (staff != null) {
      staff.salary = newSalary;
      print(' ${staff.specialization} ${staff.name} salary updated to \$${newSalary}');
    } else {
      print(' Administrative staff not found!');
    }
  }

  void displayAllStaff() {
    print('\n========== ALL STAFF ==========');
    
    print('\n DOCTORS (${doctors.length}):');
    for (var doc in doctors) {
      print('  ID: ${doc.id} | ${doc.name} | ${doc.specialization} | Salary: \$${doc.salary}');
    }
    
    print('\nNURSES (${nurses.length}):');
    for (var nurse in nurses) {
      print('  ID: ${nurse.id} | ${nurse.name} | Salary: \$${nurse.salary}');
    }
    
    print('\n ADMINISTRATIVE STAFF (${adminStaff.length}):');
    for (var staff in adminStaff) {
      print('  ID: ${staff.id} | ${staff.name} | ${staff.specialization} | Salary: \$${staff.salary}');
    }
  }

  int getTotalStaffCount() {
    return doctors.length + nurses.length + adminStaff.length;
  }

  double getTotalSalaryExpense() {
    double total = 0;
    for (var doc in doctors) total += doc.salary;
    for (var nurse in nurses) total += nurse.salary;
    for (var staff in adminStaff) total += staff.salary;
    return total;
  }

  void displayStaffSummary() {
    print('\n========== STAFF SUMMARY ==========');
    print('Total Staff: ${getTotalStaffCount()}');
    print('Doctors: ${doctors.length}');
    print('Nurses: ${nurses.length}');
    print('Administrative Staff: ${adminStaff.length}');
    print('Total Monthly Salary Expense: \$${getTotalSalaryExpense().toStringAsFixed(2)}');
  }

  void searchStaffById(String id) {
    
  }
}
