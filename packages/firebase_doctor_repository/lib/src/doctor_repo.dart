import 'package:clinical/models/doctor.dart';

abstract class DoctorRepo {
  Future<Doctor> getDoctorById(String uid);

  Future<List<Doctor>?> getAllDoctors();

  Future<List<Doctor>> getSecretaryDoctors(String secretaryId);
}