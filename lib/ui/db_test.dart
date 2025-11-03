import 'package:mysql1/mysql1.dart';

Future<void> main() async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '1234',
      db: 'hospital_management',
    ));

    print('✅ Connected successfully!');
    var results = await conn.query('SHOW TABLES');
    for (var row in results) {
      print('Table: ${row[0]}');
    }

    await conn.close();
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
