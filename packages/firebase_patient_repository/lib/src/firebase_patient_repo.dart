import 'package:clinical/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../patient_repository.dart';
import 'package:uuid/uuid.dart';

class FirebasePatientRepo extends PatientRepo{
  final patientsCollection = FirebaseFirestore.instance.collection('patients');

  @override
  Future<void> addPatient(Patient newPatient) async {
    try{
      newPatient.patientId = const Uuid().v1();
      patientsCollection.doc(newPatient.patientId).set(newPatient.toMap());
    }catch(e){
      print('Error "addPatient": $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePatient(String patientId) async {
    try{
      await patientsCollection.doc(patientId).delete();
    }catch(e){
      print('Error "addPatient": $e');
      rethrow;
    }
  }

  @override
  Stream<List<Patient>> getAllPatients(String doctorId) {
    try{
      return patientsCollection
          .where('doctorId', isEqualTo: doctorId)
          .snapshots()
          .map((snapshot) {
          print("Snapshot received: ${snapshot.docs.length} documents"); // Add this log to check document count
          return snapshot.docs.map((doc) {
            print("Document data: ${doc.data()}"); // Log the document data to see what's coming
            return Patient.fromMap(doc.data());
          }).toList();
        });
    }catch(e){
      print('Error "getAllPatients": $e');
      rethrow;
    }
  }

  @override
  Future<Patient> getPatientById(String patientId) async {
     try{
      var querySnapshot = await patientsCollection
          .where('patientId', isEqualTo: patientId)
          .get();
      if(querySnapshot.docs.isEmpty){
        throw(Exception('Patient Not Found'));
      }
      return Patient.fromMap(querySnapshot.docs.first.data());
    }catch(e){
      print('Error "getPatientById": $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateInformation(String patientId, Patient updatedPatient) async {
    try{
      patientsCollection.doc(patientId).update(updatedPatient.toMap());
    }catch(e){
      print('Error "updatePatient": $e');
      rethrow;
    }
  }
}