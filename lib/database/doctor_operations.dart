import 'db_helper.dart';

class DoctorOperations {
  // ✅ Insert a new doctor
  static Future<bool> insertDoctor({
    required String name,
    required String specialization,
    required int deptId,
    String? phone,
    String? email,
  }) async {
    try {
      final db = await DbHelper.connect();
      await db.insert('doctor', {
        'name': name,
        'specialization': specialization,
        'dept_id': deptId,
        'phone': phone,
        'email': email,
      });
      print('✅ Doctor saved to database!');
      return true;
    } catch (e, st) {
      print('❌ insertDoctor error: $e');
      print(st);
      return false;
    }
  }

  // ✅ Get all doctors
  static Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      final db = await DbHelper.connect();
      final results = await db.query('doctor');

      return results.map((row) {
        return {
          'id': row['doctor_id'],
          'name': row['name'],
          'specialization': row['specialization'],
          'department_id': row['dept_id'],
          'phone': row['phone'],
          'email': row['email']
        };
      }).toList();
    } catch (e, st) {
      print('❌ getDoctors error: $e');
      print(st);
      return [];
    }
  }

  // Delete a doctor by ID
  static Future<bool> deleteDoctor(int doctorId) async {
    try {
      final db = await DbHelper.connect();
      final count = await db.delete(
        'doctor',
        where: 'doctor_id = ?',
        whereArgs: [doctorId],
      );
      if (count > 0) {
        print('✅ Doctor deleted successfully!');
        return true;
      } else {
        print('❌ Doctor not found.');
        return false;
      }
    } catch (e, st) {
      print('❌ deleteDoctor error: $e');
      print(st);
      return false;
    }
  }
}