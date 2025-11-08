import 'db_helper.dart';

class AppointmentOperations {
  
  static Future<bool> insertAppointment({
    required int patientId,
    required int doctorId,
    required String appointmentDate,
    required String status,
    String? reason,
  }) async {
    try {
      final db = await DbHelper.connect();
      await db.insert('appointment', {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'appointment_date': appointmentDate,
        'status': status,
        'reason': reason,
      });
      print('✅ Appointment saved to database!');
      return true;
    } catch (e, st) {
      print('❌ insertAppointment error: $e');
      print(st);
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAppointments() async {
  try {
    final db = await DbHelper.connect();
    final results = await db.rawQuery('''
      SELECT 
        a.appointment_id,
        a.appointment_date,
        a.status,
        a.reason,
        p.name as patient_name,
        d.name as doctor_name,
        d.specialization
      FROM appointment a
      JOIN patient p ON a.patient_id = p.patient_id
      JOIN doctor d ON a.doctor_id = d.doctor_id
      ORDER BY datetime(a.appointment_date) ASC  -- ✅ ONLY THIS LINE CHANGED
    ''');

    return results.map((row) {
      return {
        'id': row['appointment_id'],
        'patient_name': row['patient_name'],
        'doctor_name': row['doctor_name'],
        'specialization': row['specialization'],
        'date': row['appointment_date'],
        'status': row['status'],
        'reason': row['reason']
      };
    }).toList();
  } catch (e, st) {
    print('❌ getAppointments error: $e');
    print(st);
    return [];
  }
}

  static Future<bool> deleteAppointment(int appointmentId) async {
    try {
      final db = await DbHelper.connect();
      final count = await db.delete(
        'appointment',
        where: 'appointment_id = ?',
        whereArgs: [appointmentId],
      );
      if (count > 0) {
        print('✅ Appointment deleted successfully!');
        return true;
      } else {
        print('❌ Appointment not found.');
        return false;
      }
    } catch (e, st) {
      print('❌ deleteAppointment error: $e');
      print(st);
      return false;
    }
  }


  static Future<bool> hasConflict({
  required int patientId,
  required int doctorId,
  required String appointmentDate,
  }) async {
    try {
      final db = await DbHelper.connect();
      
      final results = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM appointment
        WHERE (patient_id = ? OR doctor_id = ?)
          AND appointment_date = ?
          AND status != 'Cancelled'
      ''', [patientId, doctorId, appointmentDate]);
      
      int count = results.first['count'] as int;
      return count > 0;
    } catch (e) {
      print('❌ hasConflict error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAvailablePatients(String appointmentDate) async {
    try {
      final db = await DbHelper.connect();
      final results = await db.rawQuery('''
        SELECT p.patient_id as id, p.name, p.phone
        FROM patient p
        WHERE p.patient_id NOT IN (
          SELECT patient_id 
          FROM appointment 
          WHERE appointment_date = ? 
            AND status != 'Cancelled'
        )
        ORDER BY p.name
      ''', [appointmentDate]);
      
      return results;
    } catch (e) {
      print('❌ getAvailablePatients error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getAvailableDoctors(String appointmentDate) async {
    try {
      final db = await DbHelper.connect();
      final results = await db.rawQuery('''
        SELECT d.doctor_id as id, d.name, d.specialization, d.phone
        FROM doctor d
        WHERE d.doctor_id NOT IN (
          SELECT doctor_id 
          FROM appointment 
          WHERE appointment_date = ? 
            AND status != 'Cancelled'
        )
        ORDER BY d.name
      ''', [appointmentDate]);
      
      return results;
    } catch (e) {
      print('❌ getAvailableDoctors error: $e');
      return [];
    }
  }
}


