class Patient{
  String patientId;
  String doctorId;
  String name;
  String email;
  String phoneNumber;
  String dateOfBirth;
  String gender;

  Patient({
    required this.patientId,
    required this.doctorId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
  });

  static final empty = Patient(patientId: '', doctorId: '', name: '', email: '', phoneNumber: '', dateOfBirth: '', gender: ''); 

  Map<String, dynamic> toMap(){
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }

  static Patient fromMap(Map<String, dynamic> map){
    return Patient(
      patientId: map['patientId'], 
      doctorId: map['doctorId'], 
      name: map['name'], 
      email: map['email'], 
      phoneNumber: map['phoneNumber'], 
      dateOfBirth: map['dateOfBirth'], 
      gender: map['gender']);
  }
}