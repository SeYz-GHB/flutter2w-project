import 'db_helper.dart';

class PatientOperations {
  // ✅ Insert a new patient
  static Future<bool> insertPatient({
    required String name,
    required String gender,
    required String dob,
    required String address,
    required String phone,
  }) async {
    try {
      final db = await DbHelper.connect();
      await db.insert('patient', {
        'name': name,
        'gender': gender,
        'dob': dob,
        'address': address,
        'phone': phone,
      });
      print('✅ Patient saved to database!');
      return true;
    } catch (e, st) {
      print('❌ insertPatient error: $e');
      print(st);
      return false;
    }
  }

  // ✅ Get all patients
  static Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      final db = await DbHelper.connect();
      final results = await db.query('patient');

      return results.map((row) {
        return {
          'id': row['patient_id'],
          'name': row['name'],
          'gender': row['gender'],
          'dob': row['dob']?.toString()
        };
      }).toList();
    } catch (e, st) {
      print('❌ getPatients error: $e');
      print(st);
      return [];
    }
  }

  // Delete a patient by ID
  static Future<bool> deletePatient(int patientId) async {
    try {
      final db = await DbHelper.connect();
      final count = await db.delete(
        'patient',
        where: 'patient_id = ?',
        whereArgs: [patientId],
      );
      if (count > 0) {
        print('✅ Patient deleted successfully!');
        return true;
      } else {
        print('❌ Patient not found.');
        return false;
      }
    } catch (e, st) {
      print('❌ deletePatient error: $e');
      print(st);
      return false;
    }
  }
}