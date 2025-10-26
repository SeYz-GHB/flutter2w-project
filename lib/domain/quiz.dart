// class Staff {
//   int id;
//   String name;
//   double salary;

//   Staff({required this.id, required this.name, required this.salary});
// }

// class Doctor extends Staff {
//   String specialization;

//   Doctor({required int id, required String name, required double salary, required this.specialization})
//       : super(id: id, name: name, salary: salary);
// }

// class Nurse extends Staff {
//   Nurse({required int id, required String name, required double salary}) 
//       : super(id: id, name: name, salary: salary);
// }

// class Patient {
//   int id;
//   String name;
//   String disease;
//   Doctor? assignedDoctor;

//   Patient({required this.id, required this.name, required this.disease, this.assignedDoctor});
// }

// class Hospital {
//   String name;
//   List<Doctor> doctors = [];
//   List<Nurse> nurses = [];
//   List<Patient> patients = [];

//   Hospital({required this.name});

//   void addDoctor(Doctor doctor) {
//     doctors.add(doctor);
//     print('Doctor ${doctor.name} added!');
//   }

//   void addPatient(Patient patient) {
//     patients.add(patient);
//     print('Patient ${patient.name} added!');
//   }
// }
enum Department{ }
abstract class Person{
  String id;
  String name;
  int age;
  String email;
  String phoneNumber;
  Person({required this.id, required this.name, rethis.age, this.email, this.phoneNumber});
}

class Staff extends Person{
  String role;

  Staff(super.name, super.age, super.email, super.phoneNumber);

}