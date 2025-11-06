import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbHelper {
  static Database? _database;
  static bool _initialized = false;  // ← ADDED

  // ✅ Connect once and reuse the connection
  static Future<Database> connect() async {
    // Initialize FFI for desktop - ONLY ONCE
    if (!_initialized) {  // ← ADDED
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _initialized = true;  // ← ADDED
    }
    
    try {
      if (_database == null) {
        // Use current directory instead of getDatabasesPath()
        final path = join(Directory.current.path, 'hospital_management.db');

        _database = await databaseFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              // Load and execute the schema file
              await _executeSqlFile(db, 'lib/assets/hospital_schema.sql');
            },
          ),
        );

        print('✅ Connected successfully to SQLite!');

        // Debug: list tables and counts
        await _debugInfo();
      }
      return _database!;
    } catch (e, st) {
      print('❌ Failed to connect to DB: $e');
      print(st);
      rethrow;
    }
  }

  static Future<void> _executeSqlFile(Database db, String filePath) async {
    try {
      // Read the SQL file
      final file = File(filePath);
      final sqlScript = await file.readAsString();

      // Remove single-line comments and empty lines
      final lines = sqlScript.split('\n');
      final buffer = StringBuffer();
      
      for (var line in lines) {
        final trimmed = line.trim();
        // Skip comment lines and empty lines
        if (trimmed.startsWith('--') || trimmed.isEmpty) {
          continue;
        }
        buffer.write(line);
        buffer.write(' '); // Add space to prevent joining words
      }
      
      // Split by semicolon to get individual statements
      final statements = buffer
          .toString()
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      print('🔧 Found ${statements.length} SQL statements to execute...');
      
      // Execute each statement one by one
      for (var i = 0; i < statements.length; i++) {
        var statement = statements[i];
        try {
          await db.execute(statement);
          // Show first 60 chars of statement
          final preview = statement.length > 60 
              ? '${statement.substring(0, 60)}...' 
              : statement;
          print('✅ [${i + 1}/${statements.length}] $preview');
        } catch (e) {
          print('❌ Failed at statement ${i + 1}:');
          print('   ${statement.substring(0, statement.length > 100 ? 100 : statement.length)}');
          print('   Error: $e');
          rethrow;
        }
      }

      print('✅ All SQL statements executed successfully!');
    } catch (e) {
      print('❌ Failed to load schema file: $e');
      rethrow;
    }
  }

  static Future<void> _debugInfo() async {
    try {
      final db = _database!;

      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");
      print(' Tables in database:');
      for (var table in tables) {
        print('  - ${table['name']}');
      }

      try {
        var result = await db.rawQuery('SELECT COUNT(*) as c FROM doctor');
        print('  doctor count: ${result.first['c']}');
      } catch (_) {
        print('  doctor table: not found or count failed');
      }

      try {
        var result = await db.rawQuery('SELECT COUNT(*) as c FROM patient');
        print('  patient count: ${result.first['c']}');
      } catch (_) {
        print('  patient table: not found or count failed');
      }

      try {
        var result = await db.rawQuery('SELECT COUNT(*) as c FROM room');
        print('  room count: ${result.first['c']}');
      } catch (_) {
        print('  room table: not found or count failed');
      }

      // Print sample rows
      try {
        var rows = await db.query('doctor', limit: 5);
        print(' doctor sample rows:');
        for (var row in rows) {
          print('   - $row');
        }
      } catch (e) {
        print(' doctor sample rows: failed ($e)');
      }

      try {
        var rows = await db.query('patient', limit: 5);
        print(' patient sample rows:');
        for (var row in rows) {
          print('   - $row');
        }
      } catch (e) {
        print(' patient sample rows: failed ($e)');
      }
    } catch (e) {
      print('⚠️ Could not list tables: $e');
    }
  }

  // ✅ Insert a new doctor
  static Future<bool> insertDoctor({
    required String name,
    required String specialization,
    required int deptId,
    String? phone,
    String? email,
  }) async {
    try {
      final db = await connect();
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

  // ✅ Insert a new patient
  static Future<bool> insertPatient({
    required String name,
    required String gender,
    required String dob,
    required String address,
    required String phone,
  }) async {
    try {
      final db = await connect();
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

  // ✅ Insert a new appointment
  static Future<bool> insertAppointment({
    required int patientId,
    required int doctorId,
    required String appointmentDate,
    required String status,
    String? reason,
  }) async {
    try {
      final db = await connect();
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

  // ✅ Insert a new nurse (as staff)
  static Future<bool> insertNurse({
    required String name,
    required int deptId,
    String? contact,
  }) async {
    try {
      final db = await connect();
      await db.insert('staff', {
        'name': name,
        'role': 'Nurse',
        'dept_id': deptId,
        'contact': contact,
      });
      print('✅ Nurse saved to database!');
      return true;
    } catch (e, st) {
      print('❌ insertNurse error: $e');
      print(st);
      return false;
    }
  }

  // ✅ Insert a new admin (as staff)
  static Future<bool> insertAdmin({
    required String name,
    required String role,
    required int deptId,
    String? contact,
  }) async {
    try {
      final db = await connect();
      await db.insert('staff', {
        'name': name,
        'role': role,
        'dept_id': deptId,
        'contact': contact,
      });
      print('✅ Admin saved to database!');
      return true;
    } catch (e, st) {
      print('❌ insertAdmin error: $e');
      print(st);
      return false;
    }
  }

  // ✅ Get all staff (nurses and admins)
  static Future<List<Map<String, dynamic>>> getStaff() async {
    try {
      final db = await connect();
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
      print('❌ getStaff error: $e');
      print(st);
      return [];
    }
  }

  // ✅ Get all doctors
  static Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      final db = await connect();
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

  // ✅ Get all patients
  static Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      final db = await connect();
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

  // Delete a doctor by ID
static Future<bool> deleteDoctor(int doctorId) async {
  try {
    final db = await connect();
    final count = await db.delete(
      'doctor',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
    );
    if (count > 0) {
      print('Doctor deleted successfully!');
      return true;
    } else {
      print('Doctor not found.');
      return false;
    }
  } catch (e, st) {
    print('deleteDoctor error: $e');
    print(st);
    return false;
  }
}

// Delete a nurse by ID
static Future<bool> deleteNurse(int staffId) async {
  try {
    final db = await connect();
    final count = await db.delete(
      'staff',
      where: 'staff_id = ? AND role = ?',
      whereArgs: [staffId, 'Nurse'],
    );
    if (count > 0) {
      print('Nurse deleted successfully!');
      return true;
    } else {
      print('Nurse not found.');
      return false;
    }
  } catch (e, st) {
    print('deleteNurse error: $e');
    print(st);
    return false;
  }
}

// Delete an admin by ID
static Future<bool> deleteAdmin(int staffId) async {
  try {
    final db = await connect();
    final count = await db.delete(
      'staff',
      where: 'staff_id = ?',
      whereArgs: [staffId],
    );
    if (count > 0) {
      print('Admin deleted successfully!');
      return true;
    } else {
      print('Admin not found.');
      return false;
    }
  } catch (e, st) {
    print('deleteAdmin error: $e');
    print(st);
    return false;
  }
}

// Delete a patient by ID
static Future<bool> deletePatient(int patientId) async {
  try {
    final db = await connect();
    final count = await db.delete(
      'patient',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    if (count > 0) {
      print('Patient deleted successfully!');
      return true;
    } else {
      print('Patient not found.');
      return false;
    }
  } catch (e, st) {
    print('deletePatient error: $e');
    print(st);
    return false;
  }
}

// Add these two new functions at the bottom, before the closing }

static Future<bool> deleteAppointment(int appointmentId) async {
  try {
    final db = await connect();
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

static Future<List<Map<String, dynamic>>> getAppointments() async {
  try {
    final db = await connect();
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
      ORDER BY a.appointment_date DESC
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


  // Helper: Delete and recreate database
  static Future<void> resetDatabase() async {
    final path = join(Directory.current.path, 'hospital_management.db');
    
    await _database?.close();
    _database = null;
    
    await databaseFactory.deleteDatabase(path);
    print(' Database deleted');
    
    // Reconnect to create fresh database
    await connect();
  }

  // Helper: Close database connection
  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}