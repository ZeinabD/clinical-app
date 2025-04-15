import 'my_user.dart';

class Doctor extends MyUser{
  String clinicName, specialization, biographie, gender;

  Doctor({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    required this.clinicName,
    required this.specialization,
    required this.biographie,
    required this.gender
  });

  static final empty = Doctor(
    uid: '',
    clinicName: '',
    name: '',
    email: '',
    role: 'doctor',
    specialization: '',
    biographie: '',
    gender: '');

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'clinicName': clinicName,
      'name': name,
      'email': email,
      'role': role,
      'specialization': specialization,
      'biographie': biographie,
      'gender': gender,
    };
  }

  static Doctor fromMap(Map<String, dynamic> map){
    return Doctor(
      uid: map['uid'] ?? '', 
      clinicName: map['clinicName'] ?? '', 
      name: map['name']?? '', 
      email: map['email'] ?? '', 
      role: map['role'] ?? '', 
      specialization: map['specialization'] ?? '', 
      biographie: map['biographie'] ?? '', 
      gender: map['gender'] ?? '');
  }
}