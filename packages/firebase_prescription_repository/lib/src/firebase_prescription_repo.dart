import 'package:clinical/models/prescription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../prescription_repository.dart';

class FirebaseAppointmentRepo extends PrescriptionRepo{
  final prescriptionsCollection = FirebaseFirestore.instance.collection('prescriptions');

  @override
  Future<void> addPrescription(Prescription prescription) async {
    try{
      prescriptionsCollection.doc(prescription.prescriptionId).set(prescription.toMap());
    }catch(e){
      print("Error 'addPrescription': $e");
      rethrow;
    }
  }

  @override
  Future<void> updatePrescription(Prescription updatePrescription) async {
    try{
      prescriptionsCollection.doc(updatePrescription.prescriptionId).update(updatePrescription.toMap());
    }catch(e){
      print("Error 'updatePrescription': $e");
      rethrow;
    }
  }
}