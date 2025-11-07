import 'package:flutter2w_project/database/db_helper.dart';

Future<void> main() async {
  print('Resetting database (this will delete current DB file and recreate it from schema)...');
  await DbHelper.resetDatabase();
  print('Done. Database should be rebuilt.');
}
