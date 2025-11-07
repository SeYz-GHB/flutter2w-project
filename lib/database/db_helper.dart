import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbHelper {
  static Database? _database;
  static bool _initialized = false;

  // ✅ Connect once and reuse the connection
  static Future<Database> connect() async {
    // Initialize FFI for desktop - ONLY ONCE
    if (!_initialized) {
      sqfliteFfiInit();// start sql engine
      databaseFactory = databaseFactoryFfi; //Foreign Function Interface for desktop
      _initialized = true; // do it 1 time only, when app becuase sqlite setup is expensive
    }
    
    try {
      if (_database == null) {
        
        //get current directory (where my app is running) // add hospital to the path to tell sqlite where to save my file
        final path = join(Directory.current.path, 'hospital_management.db'); 
        
        // use databaseFacotry to open database
        _database = await databaseFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1, // If I change tables later, I have to increase this number (2, 3, 4...)
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
      

      // create fle object point to lib/assets/hospital_schema.sql
      final file = File(filePath);
      final sqlScript = await file.readAsString(); //Read entire file as one big string

      final lines = sqlScript.split('\n');
      final buffer = StringBuffer();//Create empty buffer to build clean SQL
      
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
      print('📋 Tables in database:');
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
        print('👨‍⚕️ doctor sample rows:');
        for (var row in rows) {
          print('   - $row');
        }
      } catch (e) {
        print('👨‍⚕️ doctor sample rows: failed ($e)');
      }

      try {
        var rows = await db.query('patient', limit: 5);
        print('🧑‍🦱 patient sample rows:');
        for (var row in rows) {
          print('   - $row');
        }
      } catch (e) {
        print('🧑‍🦱 patient sample rows: failed ($e)');
      }
    } catch (e) {
      print('⚠️ Could not list tables: $e');
    }
  }

  // Helper: Delete and recreate database
  static Future<void> resetDatabase() async {
    final path = join(Directory.current.path, 'hospital_management.db');
    
    await _database?.close();
    _database = null;
    
    await databaseFactory.deleteDatabase(path);
    print('🗑️ Database deleted');
    
    // Reconnect to create fresh database
    await connect();
  }

  // Helper: Close database connection
  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}