import 'package:clinical/models/my_user.dart';

class Secretary extends MyUser{
  List<String> doctorsId;

  Secretary({
    required super.uid,
    required this.doctorsId,
    required super.email,
    required super.name,
    required super.role,
  });

  static final empty = Secretary(uid: '', doctorsId: [], email: '', name: '', role: 'secretary'); 

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'doctorsId': doctorsId,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  static Secretary fromMap(Map<String, dynamic> map){
    return Secretary(
      uid: map['uid'],
      doctorsId: List<String>.from(map['doctorsId'] ?? []), 
      email: map['email'], 
      name: map['name'], 
      role: map['role'], 
    );
  }
}