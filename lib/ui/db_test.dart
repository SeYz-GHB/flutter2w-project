import 'package:mysql_client/mysql_client.dart';

Future<void> main() async {
  try {
    final conn = await MySQLConnection.createConnection(
      host: "localhost",
      port: 3306,
      userName: "root",
      password: "1234",
      databaseName: "hospital_management",
    );

    await conn.connect();
    print("✅ Connected successfully!");

    var results = await conn.execute('SHOW TABLES');
    for (var row in results.rows) {
      print('Table: ${row.colAt(0)}');
    }

    await conn.close();
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}