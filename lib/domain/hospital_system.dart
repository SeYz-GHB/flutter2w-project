class Staff {
  int id;
  String name;
  double salary;

  Staff({required this.id, required this.name, required this.salary});
}

class Doctor extends Staff {
  String specialization;

  Doctor({required int id, required String name, required double salary, required this.specialization})
      : super(id: id, name: name, salary: salary);
}

class Nurse extends Staff {
  Nurse({required int id, required String name, required double salary}) 
      : super(id: id, name: name, salary: salary);
}

class Patient {
  int id;
  String name;
  String disease;
  Doctor? assignedDoctor;

  Patient({required this.id, required this.name, required this.disease, this.assignedDoctor});
}

class AdministrativeStaff extends Staff {
  String role;

  AdministrativeStaff({
    required int id,        
    required String name, 
    required double salary,
    required this.role 
  }) : super(id: id, name: name, salary: salary); 
}

class Hospital {
  String name;
  List<Doctor> doctors = [];
  List<Nurse> nurses = [];
  List<Patient> patients = [];
  List<AdministrativeStaff> adminStaff = [];

  Hospital({required this.name});

  void addDoctor(Doctor doctor) {
    doctors.add(doctor);
    print('Doctor ${doctor.name} added!');
  }

  void addNurse(Nurse nurse) {
    nurses.add(nurse);
    print("Nurse ${nurse.name} added successfully!");

  }

  void addPatient(Patient patient) {
    patients.add(patient);
    print('Patient ${patient.name} added!');
  }


  void addAdministrativeStaff(AdministrativeStaff staff) {
    adminStaff.add(staff);
    print('${staff.role} ${staff.name} added successfully!');
  }

  void removeDoctor(int id) {
    doctors.removeWhere((doc) => doc.id == id);
    print(' Doctor with ID $id removed!');
  }

  void removeNurse(int id) {
    nurses.removeWhere((nurse) => nurse.id == id);
    print(' Nurse with ID $id removed!');
  }

  void removeAdministrativeStaff(int id) {
    adminStaff.removeWhere((staff) => staff.id == id);
    print(' Administrative staff with ID $id removed!');
  }

  Doctor? findDoctorById(int id) {
    try {
      return doctors.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  Nurse ? findNurseById(int id) {
    try {
      return nurses.firstWhere((nurse) => nurse.id == id);
    }
    catch(e) {
      return null;
    }
  }

  AdministrativeStaff ? findAdminStaffById(int id) {
    try{
      return adminStaff.firstWhere((staff) => staff.id == id);
    }
    catch(e) {
      return null;
    }

  }

  void updateDoctorSalary(int id, double newSalary) {
    var doctor = findDoctorById(id);
    if (doctor != null) {
      doctor.salary = newSalary;
      print(' Doctor ${doctor.name} salary updated to \$${newSalary}');
    } else {
      print(' Doctor not found!');
    }
  }

  void updateNurseSalary(int id, double newSalary) {
    var nurse = findNurseById(id);
    if (nurse != null) {
      nurse.salary = newSalary;
      print('Nurse ${nurse.name} salary updated to \$${newSalary}');
    } else {
      print(' Nurse not found!');
    }
  }

  void updateAdminStaffSalary(int id, double newSalary) {
    var staff = findAdminStaffById(id);
    if (staff != null) {
      staff.salary = newSalary;
      print(' ${staff.role} ${staff.name} salary updated to \$${newSalary}');
    } else {
      print(' Administrative staff not found!');
    }
  }

  




    // Display All Staff
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
      print('  ID: ${staff.id} | ${staff.name} | ${staff.role} | Salary: \$${staff.salary}');
    }
  }

  // Get Total Staff Count
  int getTotalStaffCount() {
    return doctors.length + nurses.length + adminStaff.length;
  }

  // Get Total Salary Expense
  double getTotalSalaryExpense() {
    double total = 0;
    for (var doc in doctors) total += doc.salary;
    for (var nurse in nurses) total += nurse.salary;
    for (var staff in adminStaff) total += staff.salary;
    return total;
  }

  // Display Staff Summary
  void displayStaffSummary() {
    print('\n========== STAFF SUMMARY ==========');
    print('Total Staff: ${getTotalStaffCount()}');
    print('Doctors: ${doctors.length}');
    print('Nurses: ${nurses.length}');
    print('Administrative Staff: ${adminStaff.length}');
    print('Total Monthly Salary Expense: \$${getTotalSalaryExpense().toStringAsFixed(2)}');
  }

 
  

}
