import 'package:mysql1/mysql1.dart';

class DbHelper {
  static MySqlConnection? _connection;

  // ✅ Connect once and reuse the connection
  static Future<MySqlConnection> connect() async {
    try {
      if (_connection == null) {
        final settings = ConnectionSettings(
          host: 'localhost', // your MySQL host
          port: 3306, // default port
          user: 'root', // your MySQL user
          password: '', // your MySQL password
          db: 'hospital_management', // your database name
        );
        _connection = await MySqlConnection.connect(settings);
        print('✅ Connected successfully!');

        // quick debug: list tables and counts for common tables so we can
        // verify the DB was initialized correctly.
        try {
          final tables = await _connection!.query('SHOW TABLES');
          print('🔎 Tables in database:');
          for (var row in tables) {
            // row[0] is the table name
            print('  - ${row[0]}');
          }

          // try counts for doctor and patient if present
          try {
            var r = await _connection!.query('SELECT COUNT(*) as c FROM doctor');
            print('  doctor count: ${r.first['c']}');
          } catch (_) {
            print('  doctor table: not found or count failed');
          }
          try {
            var r = await _connection!.query('SELECT COUNT(*) as c FROM patient');
            print('  patient count: ${r.first['c']}');
          } catch (_) {
            print('  patient table: not found or count failed');
          }
          try {
            var r = await _connection!.query('SELECT COUNT(*) as c FROM bed');
            print('  bed count: ${r.first['c']}');
          } catch (_) {
            print('  bed table: not found or count failed');
          }
        } catch (e) {
          print('⚠️ Could not list tables: $e');
        }
        // Additional debug: print column names and up to 5 rows from doctor and patient
        try {
          var cols = await _connection!.query(
              "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'hospital_management' AND TABLE_NAME = 'doctor'");
          print('🔧 doctor columns: ${cols.map((r) => r[0]).toList()}');
        } catch (e) {
          print('🔧 doctor columns: failed to read ($e)');
        }
        try {
          var cols = await _connection!.query(
              "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'hospital_management' AND TABLE_NAME = 'patient'");
          print('🔧 patient columns: ${cols.map((r) => r[0]).toList()}');
        } catch (e) {
          print('🔧 patient columns: failed to read ($e)');
        }

        try {
          var rows = await _connection!.query('SELECT * FROM doctor LIMIT 5');
          print('📝 doctor sample rows (positional):');
          for (var row in rows) {
            print('   - ${row.toList()}');
          }
        } catch (e) {
          print('📝 doctor sample rows: failed ($e)');
        }

        try {
          var rows = await _connection!.query('SELECT * FROM patient LIMIT 5');
          print('📝 patient sample rows (positional):');
          for (var row in rows) {
            print('   - ${row.toList()}');
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
      // alias dept_id to department_id so mapping in UI matches
    // doctor table uses `doctor_id` and `dept_id` per your SQL file
    final results = await conn.query(
      'SELECT doctor_id AS id, name, specialization, dept_id AS department_id, phone, email FROM doctor');

    return results
      .map((row) => {
        'id': row['id'],
        'name': row['name'],
        'specialization': row['specialization'],
        'department_id': row['department_id'],
        'phone': row['phone'],
        'email': row['email']
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
    // patient table uses `patient_id` per your SQL file
    final results =
      await conn.query('SELECT patient_id AS id, name, gender, dob FROM patient');

    return results
      .map((row) => {
        'id': row['id'],
        'name': row['name'],
        'gender': row['gender'],
        // convert DOB to string to avoid issues when printing
        'dob': row['dob']?.toString()
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
    // rooms and beds are split into `room` and `bed` tables in your SQL
    final results = await conn.query('''
    SELECT r.room_number, b.bed_number, b.is_occupied
    FROM bed b
    JOIN room r ON b.room_id = r.room_id
    ''');

    return results
      .map((row) => {
        'room_number': row['room_number'],
        'bed_number': row['bed_number'],
        // map is_occupied -> availability string for UI
        'availability': (row['is_occupied'] == 1 || row['is_occupied'] == true)
          ? 'Occupied'
          : 'Available'
        })
      .toList();
    } catch (e, st) {
      print('❌ getRoomsAndBeds error: $e');
      print(st);
      return [];
    }
  }
}
