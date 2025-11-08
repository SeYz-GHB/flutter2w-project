import 'db_helper.dart';

class StaffOperations {
  static Future<bool> insertNurse({
    required String name,
    required int deptId,
    String? contact,
  }) async {
    try {
      final db = await DbHelper.connect();
      await db.insert('staff', {
        'name': name,
        'role': 'Nurse',
        'dept_id': deptId,
        'contact': contact,
      });
      print(' Nurse saved to database!');
      return true;
    } catch (e, st) {
      print(' insertNurse error: $e');
      print(st);
      return false;
    }
  }

  static Future<bool> insertAdmin({
    required String name,
    required String role,
    required int deptId,
    String? contact,
  }) async {
    try {
      final db = await DbHelper.connect();
      await db.insert('staff', {
        'name': name,
        'role': role,
        'dept_id': deptId,
        'contact': contact,
      });
      print(' Admin saved to database!');
      return true;
    } catch (e, st) {
      print(' insertAdmin error: $e');
      print(st);
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getStaff() async {
    try {
      final db = await DbHelper.connect();
      final results = await db.query('staff');

      return results.map((row) {
        return {
          'id': row['staff_id'],
          'name': row['name'],
          'role': row['role'],
          'department_id': row['dept_id'],
          'contact': row['contact']
        };
      }).toList();
    } catch (e, st) {
      print(' getStaff error: $e');
      print(st);
      return [];
    }
  }

  static Future<bool> deleteNurse(int staffId) async {
    try {
      final db = await DbHelper.connect();
      final count = await db.delete(
        'staff',
        where: 'staff_id = ? AND role = ?',
        whereArgs: [staffId, 'Nurse'],
      );
      if (count > 0) {
        print(' Nurse deleted successfully!');
        return true;
      } else {
        print(' Nurse not found.');
        return false;
      }
    } catch (e, st) {
      print(' deleteNurse error: $e');
      print(st);
      return false;
    }
  }

  static Future<bool> deleteAdmin(int staffId) async {
    try {
      final db = await DbHelper.connect();
      final count = await db.delete(
        'staff',
        where: 'staff_id = ?',
        whereArgs: [staffId],
      );
      if (count > 0) {
        print(' Admin deleted successfully!');
        return true;
      } else {
        print(' Admin not found.');
        return false;
      }
    } catch (e, st) {
      print(' deleteAdmin error: $e');
      print(st);
      return false;
    }
  }
}
