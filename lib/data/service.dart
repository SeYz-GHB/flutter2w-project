import 'package:mysql_client/mysql_client.dart';

class DbHelper {
  static MySQLConnection? _connection;

  // ✅ Connect once and reuse the connection
  static Future<MySQLConnection> connect() async {
    try {
      if (_connection == null) {
        _connection = await MySQLConnection.createConnection(
          host: 'localhost',
          port: 3306,
          userName: 'root',
          password: r"Pisey@!#$%^&*1234858483", // Update this to your password
          databaseName: 'hospital_management',
        );
        
        await _connection!.connect();
        print('✅ Connected successfully!');

        // quick debug: list tables and counts for common tables
        try {
          final tables = await _connection!.execute('SHOW TABLES');
          print('🔎 Tables in database:');
          for (var row in tables.rows) {
            print('  - ${row.colAt(0)}');
          }

          // try counts for doctor and patient if present
          try {
            var r = await _connection!.execute('SELECT COUNT(*) as c FROM doctor');
            print('  doctor count: ${r.rows.first.colByName('c')}');
          } catch (_) {
            print('  doctor table: not found or count failed');
          }
          try {
            var r = await _connection!.execute('SELECT COUNT(*) as c FROM patient');
            print('  patient count: ${r.rows.first.colByName('c')}');
          } catch (_) {
            print('  patient table: not found or count failed');
          }
          try {
            var r = await _connection!.execute('SELECT COUNT(*) as c FROM bed');
            print('  bed count: ${r.rows.first.colByName('c')}');
          } catch (_) {
            print('  bed table: not found or count failed');
          }
        } catch (e) {
          print('⚠️ Could not list tables: $e');
        }

        // Additional debug: print column names
        try {
          var cols = await _connection!.execute(
              "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'hospital_management' AND TABLE_NAME = 'doctor'");
          print('🔧 doctor columns: ${cols.rows.map((r) => r.colAt(0)).toList()}');
        } catch (e) {
          print('🔧 doctor columns: failed to read ($e)');
        }
        try {
          var cols = await _connection!.execute(
              "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'hospital_management' AND TABLE_NAME = 'patient'");
          print('🔧 patient columns: ${cols.rows.map((r) => r.colAt(0)).toList()}');
        } catch (e) {
          print('🔧 patient columns: failed to read ($e)');
        }

        try {
          var rows = await _connection!.execute('SELECT * FROM doctor LIMIT 5');
          print('📝 doctor sample rows:');
          for (var row in rows.rows) {
            print('   - ${row.assoc()}');
          }
        } catch (e) {
          print('📝 doctor sample rows: failed ($e)');
        }

        try {
          var rows = await _connection!.execute('SELECT * FROM patient LIMIT 5');
          print('📝 patient sample rows:');
          for (var row in rows.rows) {
            print('   - ${row.assoc()}');
          }
        } catch (e) {
          print('📝 patient sample rows: failed ($e)');
        }
      }
      return _connection!;
    } catch (e, st) {
      print('❌ Failed to connect to DB: $e');
      print(st);
      rethrow;
    }
  }

  // ✅ Get all doctors
  static Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      final conn = await connect();
      final results = await conn.execute(
        'SELECT doctor_id AS id, name, specialization, dept_id AS department_id, phone, email FROM doctor');

      return results.rows
          .map((row) {
            final data = row.assoc();
            return {
              'id': data['id'],
              'name': data['name'],
              'specialization': data['specialization'],
              'department_id': data['department_id'],
              'phone': data['phone'],
              'email': data['email']
            };
          })
          .toList();
    } catch (e, st) {
      print('❌ getDoctors error: $e');
      print(st);
      return [];
    }
  }

  // ✅ Get all patients
  static Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      final conn = await connect();
      final results = await conn.execute(
          'SELECT patient_id AS id, name, gender, dob FROM patient');

      return results.rows
          .map((row) {
            final data = row.assoc();
            return {
              'id': data['id'],
              'name': data['name'],
              'gender': data['gender'],
              'dob': data['dob']?.toString()
            };
          })
          .toList();
    } catch (e, st) {
      print('❌ getPatients error: $e');
      print(st);
      return [];
    }
  }

  // ✅ Get all rooms and beds
  static Future<List<Map<String, dynamic>>> getRoomsAndBeds() async {
    try {
      final conn = await connect();
      final results = await conn.execute('''
        SELECT r.room_number, b.bed_number, b.is_occupied
        FROM bed b
        JOIN room r ON b.room_id = r.room_id
      ''');

      return results.rows
          .map((row) {
            final data = row.assoc();
            return {
              'room_number': data['room_number'],
              'bed_number': data['bed_number'],
              'availability': (data['is_occupied'] == 1 || data['is_occupied'] == '1')
                  ? 'Occupied'
                  : 'Available'
            };
          })
          .toList();
    } catch (e, st) {
      print('❌ getRoomsAndBeds error: $e');
      print(st);
      return [];
    }
  }
}