// AI GENERATE
// lib/ui/test.dart
import 'package:test/test.dart';
import '../database/doctor_operations.dart';
import '../database/patient_operations.dart';
import '../database/staff_operations.dart';

void main() {
  // ==================== DOCTOR TESTS ====================
  group('Doctor Operations Tests', () {
    
    test('Insert doctor increases count by +1', () async {
      int initialCount = (await DoctorOperations.getDoctors()).length;
      
      bool success = await DoctorOperations.insertDoctor(
        name: 'Dr. Test',
        specialization: 'Cardiology',
        deptId: 1,
        phone: '123456789',
        email: 'test@hospital.com',
      );
      
      int finalCount = (await DoctorOperations.getDoctors()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount + 1));
    });

    test('Get doctors returns list', () async {
      List<Map<String, dynamic>> doctors = await DoctorOperations.getDoctors();
      
      expect(doctors, isA<List<Map<String, dynamic>>>());
    });

    test('Delete doctor decreases count by -1', () async {
      // First insert a doctor to delete
      await DoctorOperations.insertDoctor(
        name: 'Dr. ToDelete',
        specialization: 'Surgery',
        deptId: 1,
      );
      
      List<Map<String, dynamic>> doctors = await DoctorOperations.getDoctors();
      int initialCount = doctors.length;
      int doctorId = doctors.last['id'];
      
      bool success = await DoctorOperations.deleteDoctor(doctorId);
      int finalCount = (await DoctorOperations.getDoctors()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount - 1));
    });

    test('Delete non-existent doctor returns false', () async {
      bool success = await DoctorOperations.deleteDoctor(99999);
      
      expect(success, isFalse);
    });
  });

  // ==================== PATIENT TESTS ====================
  group('Patient Operations Tests', () {
    
    test('Insert patient increases count by +1', () async {
      int initialCount = (await PatientOperations.getPatients()).length;
      
      bool success = await PatientOperations.insertPatient(
        name: 'John Test',
        gender: 'Male',
        dob: '1990-01-01',
        address: '123 Test St',
        phone: '987654321',
      );
      
      int finalCount = (await PatientOperations.getPatients()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount + 1));
    });

    test('Get patients returns list', () async {
      List<Map<String, dynamic>> patients = await PatientOperations.getPatients();
      
      expect(patients, isA<List<Map<String, dynamic>>>());
    });

    test('Delete patient decreases count by -1', () async {
      // First insert a patient to delete
      await PatientOperations.insertPatient(
        name: 'Delete Me',
        gender: 'Female',
        dob: '1995-05-05',
        address: '456 Delete Ave',
        phone: '111222333',
      );
      
      List<Map<String, dynamic>> patients = await PatientOperations.getPatients();
      int initialCount = patients.length;
      int patientId = patients.last['id'];
      
      bool success = await PatientOperations.deletePatient(patientId);
      int finalCount = (await PatientOperations.getPatients()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount - 1));
    });

    test('Delete non-existent patient returns false', () async {
      bool success = await PatientOperations.deletePatient(99999);
      
      expect(success, isFalse);
    });
  });

  // ==================== STAFF/NURSE TESTS ====================
  group('Staff Operations Tests', () {
    
    test('Insert nurse increases count by +1', () async {
      int initialCount = (await StaffOperations.getStaff()).length;
      
      bool success = await StaffOperations.insertNurse(
        name: 'Nurse Test',
        deptId: 1,
        contact: '555-0001',
      );
      
      int finalCount = (await StaffOperations.getStaff()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount + 1));
    });

    test('Insert admin increases count by +1', () async {
      int initialCount = (await StaffOperations.getStaff()).length;
      
      bool success = await StaffOperations.insertAdmin(
        name: 'Admin Test',
        role: 'Administrator',
        deptId: 1,
        contact: '555-0002',
      );
      
      int finalCount = (await StaffOperations.getStaff()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount + 1));
    });

    test('Get staff returns list', () async {
      List<Map<String, dynamic>> staff = await StaffOperations.getStaff();
      
      expect(staff, isA<List<Map<String, dynamic>>>());
    });

    test('Delete nurse decreases count by -1', () async {
      // First insert a nurse to delete
      await StaffOperations.insertNurse(
        name: 'Delete Nurse',
        deptId: 1,
        contact: '555-9999',
      );
      
      List<Map<String, dynamic>> staff = await StaffOperations.getStaff();
      int initialCount = staff.length;
      int nurseId = staff.last['id'];
      
      bool success = await StaffOperations.deleteNurse(nurseId);
      int finalCount = (await StaffOperations.getStaff()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount - 1));
    });

    test('Delete admin decreases count by -1', () async {
      // First insert an admin to delete
      await StaffOperations.insertAdmin(
        name: 'Delete Admin',
        role: 'HR',
        deptId: 1,
        contact: '555-8888',
      );
      
      List<Map<String, dynamic>> staff = await StaffOperations.getStaff();
      int initialCount = staff.length;
      int adminId = staff.last['id'];
      
      bool success = await StaffOperations.deleteAdmin(adminId);
      int finalCount = (await StaffOperations.getStaff()).length;
      
      expect(success, isTrue);
      expect(finalCount, equals(initialCount - 1));
    });

    test('Delete non-existent nurse returns false', () async {
      bool success = await StaffOperations.deleteNurse(99999);
      
      expect(success, isFalse);
    });
  });
}