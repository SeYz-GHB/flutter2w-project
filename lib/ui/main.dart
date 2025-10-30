import 'dart:io';
import '../data/service.dart';

void main() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.connect();
  await dbHelper.ensureTables();

  final conn = dbHelper.conn;

  while (true) {
    print('\n===== HOSPITAL MANAGEMENT SYSTEM =====');
    print('1. Add Doctor');
    print('2. Add Nurse');
    print('3. Add Admin Staff');
    print('4. Add Patient');
    print('5. Admit Patient');
    print('6. Add Appointment');
    print('7. Add Medical Record');
    print('8. Add Billing');
    print('9. View All Staff');
    print('10. View All Patients');
    print('11. View Rooms & Beds');
    print('12. Exit');
    stdout.write('Choose an option: ');
    final choice = stdin.readLineSync();

    switch (choice) {

      // ===== STAFF =====
      case '1':
        stdout.write('Name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Salary: ');
        double salary = double.parse(stdin.readLineSync()!);
        stdout.write('Specialization: ');
        String spec = stdin.readLineSync()!;
        stdout.write('Department ID: ');
        int deptId = int.parse(stdin.readLineSync()!);
        await conn.query(
          'INSERT INTO doctor (name, salary, specialization, department_id) VALUES (?, ?, ?, ?)',
          [name, salary, spec, deptId],
        );
        print('✅ Doctor added');
        break;

      case '2':
        stdout.write('Name: ');
        String name2 = stdin.readLineSync()!;
        stdout.write('Salary: ');
        double salary2 = double.parse(stdin.readLineSync()!);
        stdout.write('Specialization: ');
        String spec2 = stdin.readLineSync()!;
        stdout.write('Department ID: ');
        int deptId2 = int.parse(stdin.readLineSync()!);
        await conn.query(
          'INSERT INTO nurse (name, salary, specialization, department_id) VALUES (?, ?, ?, ?)',
          [name2, salary2, spec2, deptId2],
        );
        print('✅ Nurse added');
        break;

      case '3':
        stdout.write('Name: ');
        String name3 = stdin.readLineSync()!;
        stdout.write('Salary: ');
        double salary3 = double.parse(stdin.readLineSync()!);
        stdout.write('Role: ');
        String role = stdin.readLineSync()!;
        await conn.query(
          'INSERT INTO admin_staff (name, salary, role) VALUES (?, ?, ?)',
          [name3, salary3, role],
        );
        print('✅ Admin staff added');
        break;

      // ===== PATIENT =====
      case '4':
        stdout.write('Name: ');
        String pname = stdin.readLineSync()!;
        stdout.write('Gender: ');
        String gender = stdin.readLineSync()!;
        stdout.write('DOB (YYYY-MM-DD): ');
        String dob = stdin.readLineSync()!;
        stdout.write('Address: ');
        String address = stdin.readLineSync()!;
        stdout.write('Phone: ');
        String phone = stdin.readLineSync()!;
        await conn.query(
          'INSERT INTO patient (name, gender, dob, address, phone) VALUES (?, ?, ?, ?, ?)',
          [pname, gender, dob, address, phone],
        );
        print('✅ Patient added');
        break;

      // ===== ADMISSION =====
      case '5':
        stdout.write('Patient ID: ');
        int pid = int.parse(stdin.readLineSync()!);
        stdout.write('Room ID: ');
        int rid = int.parse(stdin.readLineSync()!);
        stdout.write('Bed ID: ');
        int bid = int.parse(stdin.readLineSync()!);
        stdout.write('Admit Date (YYYY-MM-DD): ');
        String admitDate = stdin.readLineSync()!;
        await conn.query(
          'INSERT INTO admission (patient_id, room_id, bed_id, admit_date) VALUES (?, ?, ?, ?)',
          [pid, rid, bid, admitDate],
        );
        await conn.query('UPDATE bed SET is_occupied=1 WHERE id=?', [bid]);
        print('✅ Patient admitted');
        break;

      // ===== APPOINTMENT =====
      case '6':
        stdout.write('Patient ID: ');
        int pid2 = int.parse(stdin.readLineSync()!);
        stdout.write('Doctor ID: ');
        int did = int.parse(stdin.readLineSync()!);
        stdout.write('Date (YYYY-MM-DD): ');
        String appDate = stdin.readLineSync()!;
        stdout.write('Time (HH:MM:SS): ');
        String time = stdin.readLineSync()!;
        stdout.write('Reason: ');
        String reason = stdin.readLineSync()!;
        await conn.query(
          'INSERT INTO appointment (patient_id, doctor_id, date, time, reason, status) VALUES (?, ?, ?, ?, ?, ?)',
          [pid2, did, appDate, time, reason, 'Scheduled'],
        );
        print('✅ Appointment added');
        break;

      // ===== MEDICAL RECORD =====
      case '7':
        stdout.write('Patient ID: ');
        int pid3 = int.parse(stdin.readLineSync()!);
        stdout.write('Doctor ID: ');
        int did2 = int.parse(stdin.readLineSync()!);
        stdout.write('Diagnosis: ');
        String diag = stdin.readLineSync()!;
        stdout.write('Prescription: ');
        String pres = stdin.readLineSync()!;
        stdout.write('Date (YYYY-MM-DD): ');
        String mdate = stdin.readLineSync()!;
        await conn.query(
          'INSERT INTO medical_record (patient_id, doctor_id, diagnosis, prescription, date) VALUES (?, ?, ?, ?, ?)',
          [pid3, did2, diag, pres, mdate],
        );
        print('✅ Medical record added');
        break;

      // ===== BILLING =====
      case '8':
        stdout.write('Patient ID: ');
        int pid4 = int.parse(stdin.readLineSync()!);
        stdout.write('Total Amount: ');
        double total = double.parse(stdin.readLineSync()!);
        stdout.write('Paid Amount: ');
        double paid = double.parse(stdin.readLineSync()!);
        String status = (total == paid) ? 'Paid' : 'Unpaid';
        await conn.query(
          'INSERT INTO billing (patient_id, total_amount, paid_amount, status) VALUES (?, ?, ?, ?)',
          [pid4, total, paid, status],
        );
        print('✅ Billing added');
        break;

      // ===== VIEW STAFF =====
      case '9':
        print('--- Doctors ---');
        var doctors = await conn.query('SELECT * FROM doctor');
        for (var row in doctors) {
          print('ID: ${row[0]}, Name: ${row[1]}, Salary: ${row[2]}, Spec: ${row[3]}, Dept: ${row[4]}');
        }

        print('--- Nurses ---');
        var nurses = await conn.query('SELECT * FROM nurse');
        for (var row in nurses) {
          print('ID: ${row[0]}, Name: ${row[1]}, Salary: ${row[2]}, Spec: ${row[3]}, Dept: ${row[4]}');
        }

        print('--- Admin Staff ---');
        var admins = await conn.query('SELECT * FROM admin_staff');
        for (var row in admins) {
          print('ID: ${row[0]}, Name: ${row[1]}, Salary: ${row[2]}, Role: ${row[3]}');
        }
        break;

      // ===== VIEW PATIENTS =====
      case '10':
        var patients = await conn.query('SELECT * FROM patient');
        for (var row in patients) {
          print('ID: ${row[0]}, Name: ${row[1]}, Gender: ${row[2]}, DOB: ${row[3]}, Address: ${row[4]}, Phone: ${row[5]}');
        }
        break;

      // ===== VIEW ROOMS & BEDS =====
      case '11':
        var rooms = await conn.query('SELECT * FROM room');
        for (var room in rooms) {
          print('Room ID: ${room[0]}, Number: ${room[1]}, Type: ${room[2]}, Capacity: ${room[3]}, Available Beds: ${room[4]}');
          var beds = await conn.query('SELECT * FROM bed WHERE room_id=?', [room[0]]);
          for (var bed in beds) {
            print('  Bed ID: ${bed[0]}, Number: ${bed[2]}, Occupied: ${bed[3]}');
          }
        }
        break;

      case '12':
        print('👋 Exiting...');
        await dbHelper.close();
        return;

      default:
        print('⚠️ Invalid choice. Try again.');
    }
  }
}
