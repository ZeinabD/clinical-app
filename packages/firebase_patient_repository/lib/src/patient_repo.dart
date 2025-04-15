import 'package:clinical/models/patient.dart';

abstract class PatientRepo {
  Future<void> addPatient(Patient newPatient);

  Future<void> deletePatient(String patientId);

  Future<void> updateInformation(String patientId, Patient updatedPatient);

  Stream<List<Patient>> getAllPatients(String doctorId);

  Future<Patient> getPatientById(String patientId);
}