import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment{
  String appointmentId;
  String doctorId;
  String patientId;
  DateTime dateTime;
  String status;
  double price;

  Appointment({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.dateTime,
    required this.status,
    required this.price,
  });

  static final empty = Appointment(appointmentId: '', doctorId: '', patientId: '', dateTime: DateTime.now(), status: '', price: 0.0);

  Map<String, dynamic> toMap(){
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status,
      'price': price,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map){
    return Appointment(
      appointmentId: map['appointmentId'], 
      doctorId: map['doctorId'], 
      patientId: map['patientId'], 
      dateTime: (map['dateTime'] as Timestamp).toDate(), 
      status: map['status'], 
      price: map['price']);
  }
}