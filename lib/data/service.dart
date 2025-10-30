import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  late MySqlConnection conn;

  Future<void> connect() async {
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '1234', // replace with your MySQL password
      db: 'hospital_management',
    );

    conn = await MySqlConnection.connect(settings);
    print('✅ Connected to MySQL database');
  }

  Future<void> ensureTables() async {
    // Departments
    await conn.query('''
      CREATE TABLE IF NOT EXISTS department (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        description TEXT
      );
    ''');

    // Staff tables
    await conn.query('''
      CREATE TABLE IF NOT EXISTS doctor (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        salary DOUBLE,
        specialization VARCHAR(100),
        department_id INT
      );
    ''');

    await conn.query('''
      CREATE TABLE IF NOT EXISTS nurse (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        salary DOUBLE,
        specialization VARCHAR(100),
        department_id INT
      );
    ''');

    await conn.query('''
      CREATE TABLE IF NOT EXISTS admin_staff (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        salary DOUBLE,
        role VARCHAR(100)
      );
    ''');

    // Patients
    await conn.query('''
      CREATE TABLE IF NOT EXISTS patient (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        gender VARCHAR(10),
        dob DATE,
        address VARCHAR(255),
        phone VARCHAR(20)
      );
    ''');

    // Rooms & Beds
    await conn.query('''
      CREATE TABLE IF NOT EXISTS room (
        id INT AUTO_INCREMENT PRIMARY KEY,
        number VARCHAR(10),
        type VARCHAR(50),
        capacity INT,
        available_beds INT
      );
    ''');

    await conn.query('''
      CREATE TABLE IF NOT EXISTS bed (
        id INT AUTO_INCREMENT PRIMARY KEY,
        room_id INT,
        bed_number VARCHAR(10),
        is_occupied TINYINT(1)
      );
    ''');

    // Admissions
    await conn.query('''
      CREATE TABLE IF NOT EXISTS admission (
        id INT AUTO_INCREMENT PRIMARY KEY,
        patient_id INT,
        room_id INT,
        bed_id INT,
        admit_date DATE,
        discharge_date DATE
      );
    ''');

    // Appointments
    await conn.query('''
      CREATE TABLE IF NOT EXISTS appointment (
        id INT AUTO_INCREMENT PRIMARY KEY,
        patient_id INT,
        doctor_id INT,
        date DATE,
        time TIME,
        reason TEXT,
        status VARCHAR(50)
      );
    ''');

    // Medical Records
    await conn.query('''
      CREATE TABLE IF NOT EXISTS medical_record (
        id INT AUTO_INCREMENT PRIMARY KEY,
        patient_id INT,
        doctor_id INT,
        diagnosis TEXT,
        prescription TEXT,
        date DATE
      );
    ''');

    // Billing
    await conn.query('''
      CREATE TABLE IF NOT EXISTS billing (
        id INT AUTO_INCREMENT PRIMARY KEY,
        patient_id INT,
        total_amount DOUBLE,
        paid_amount DOUBLE,
        status VARCHAR(50)
      );
    ''');

    print('✅ All tables ensured.');

    // Pre-populate Rooms & Beds (only if empty)
    var rooms = await conn.query('SELECT COUNT(*) FROM room');
    if (rooms.first[0] == 0) {
      print('🏥 Pre-populating rooms and beds...');
      // Example: 3 rooms, each with 2 beds
      for (int r = 1; r <= 3; r++) {
        var result = await conn.query(
          'INSERT INTO room (number, type, capacity, available_beds) VALUES (?, ?, ?, ?)',
          ['R$r', 'General', 2, 2],
        );
        int roomId = result.insertId!;
        for (int b = 1; b <= 2; b++) {
          await conn.query(
            'INSERT INTO bed (room_id, bed_number, is_occupied) VALUES (?, ?, 0)',
            [roomId, 'B$b'],
          );
        }
      }
      print('✅ Rooms and beds pre-populated');
    }
  }

  Future<void> close() async {
    await conn.close();
    print('🔒 Connection closed.');
  }
}
