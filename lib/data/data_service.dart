// import 'dart:convert';
// import 'dart:io';
// import '../domain/hospital_system.dart';

// class DataService {
//   final String filePath = 'hospital_data.json';

//   void saveHospitalData(Hospital hospital) {
//     try{
//       final data = {
//         'name' : hospital.name,

//         'doctors' : hospital.doctors.map((d) => {
//           'id' : d.id,
//           'name' : d.name,
//           'salary' : d.salary,
//           'specialization' : d.specialization,
//         }).toList(),

//         'nurses' : hospital.nurses.map((n) => {
//           'id' : n.id,
//           'name' : n.name,
//           'salary' : n.salary,
//           'specialization' : n.specialization,
//         }).toList(),

//         'adminStaff' : hospital.adminStaff.map((adm) => {
//           'id' : adm.id,
//           'name' : adm.name,
//           'salary' : adm.salary,
//           'specialization' : adm.specialization,
//         }).toList(),
//       };

//       /* Dart converts your Map → JSON string (in memory)
      
//       Then immediately writes it to disk
//       Only after the writing finishes, 
//       it moves to the next line (print('Data saved')) */

//       /* File(filePath).writeAsStringSync(
//         jsonEncode(data),
//         mode : FileMode.write,
//       ); */

//       final encoder = JsonEncoder.withIndent('  '); 
//       final prettyJson = encoder.convert(data);
//       File(filePath).writeAsStringSync(prettyJson);

      
//       print('Data saved to $filePath');
//     }
//     catch(e) {
//       print('Error saving data : $e');
//       rethrow;
//     }
//   }

//   Hospital loadHospitalData() {
//     try{
    
//       final file = File(filePath);
//       if(!file.existsSync()) {
//         print('No saved data found!, Creating new hospital');
//         return Hospital(name : 'Royal hospital');

//       }



//       final jsonString = file.readAsStringSync();
//       final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

//       final hospital = Hospital(name: jsonData['name'] as String);

//       /* jsonData is a Map we got from jsonDecode()
//         'doctors' is a key in that Map
//         jsonData['doctors'] gives the value for that key */

//       final doctors = jsonData['doctors'] as List<dynamic>? ?? [];
//       for(var d in doctors) {
//         hospital.doctors.add(Doctor(  // ← Directly add to list
//           id: d['id'] as String,
//           name: d['name'] as String,
//           salary: (d['salary'] as num).toDouble(),
//           specialization: d['specialization'] as String,
//         ));
//       }

//       final nurses = jsonData['nurses'] as List<dynamic>? ?? [];
//       for (var n in nurses) {
//         hospital.nurses.add(Nurse(  // ← Directly add to list
//           id: n['id'] as String,
//           name: n['name'] as String,
//           salary: (n['salary'] as num).toDouble(),
//           specialization: n['specialization'] as String,
//         ));
//       }

//       final adminStaff = jsonData['adminStaff'] as List<dynamic>? ?? [];
//       for (var a in adminStaff) {
//         hospital.adminStaff.add(AdministrativeStaff(  
//           id: a['id'] as String,
//           name: a['name'] as String,
//           salary: (a['salary'] as num).toDouble(),
//           specialization: a['specialization'] as String,
//         ));
//       }

//       if (hospital.doctors.isNotEmpty) {
//         final lastDoctorId = hospital.doctors.last.id; // e.g., DR-0100
//         hospital.setDoctorCount(int.parse(lastDoctorId.split('-')[1]));
//       }

//       if (hospital.nurses.isNotEmpty) {
//         final lastNurseId = hospital.nurses.last.id; // e.g., NRS-0080
//         hospital.setNurseCount(int.parse(lastNurseId.split('-')[1]));
//       }

//       if (hospital.adminStaff.isNotEmpty) {
//         final lastAdminId = hospital.adminStaff.last.id; // e.g., ADMS-0025
//         hospital.setAdminCount(int.parse(lastAdminId.split('-')[1]));
//       }

//       print(' Data loaded successfully.');
//       return hospital;

//      } catch (e) {
//       print(' Error loading data: $e');
//       print(' Creating new hospital due to corrupted data.');
//       return Hospital(name: 'My Hospital');


//     }
//   }






// }