import 'dart:math';
import 'package:clinical/models/doctor.dart';
import 'package:clinical/models/secretary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../doctor_repository.dart';

class FirebaseDoctorRepo extends DoctorRepo{
  final doctorsCollection = FirebaseFirestore.instance.collection('doctor');
  final secretaryCollection = FirebaseFirestore.instance.collection('secretary');

  @override
  Future<Doctor> getDoctorById(String uid) async {
    try{
      return await doctorsCollection
          .doc(uid)
          .get()
          .then((doctor) => Doctor.fromMap(doctor.data()!));
    }catch(e){
      log(e.toString() as num);
      return Doctor.empty;
    }
  }
  
  @override
  Future<List<Doctor>?> getAllDoctors() async {
    try{
      return await doctorsCollection
          .get()
          .then((doc) => doc.docs.map((doctor) => Doctor.fromMap(doctor.data())).toList());
    }catch(e){
      print(e);
      return [];
    }
  }
  
  @override
  Future<List<Doctor>> getSecretaryDoctors(String secretaryId) async {
    Secretary secretary = await secretaryCollection
        .doc(secretaryId)
        .get()
        .then((doc) => Secretary.fromMap(doc.data()!));

    List<String> doctorsId = secretary.doctorsId;

    return doctorsCollection
        .where('uid', whereIn: doctorsId)
        .get()
        .then((doc) => doc.docs.map((doctor) => Doctor.fromMap(doctor.data())).toList());
  }
}