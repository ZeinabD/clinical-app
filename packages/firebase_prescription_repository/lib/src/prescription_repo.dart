import 'package:clinical/models/prescription.dart';

abstract class PrescriptionRepo {
  Future<void> addPrescription(Prescription prescription);

  Future<void> updatePrescription(Prescription updatePrescription);
}