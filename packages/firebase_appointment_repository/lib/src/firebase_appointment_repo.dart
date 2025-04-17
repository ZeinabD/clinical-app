import 'package:clinical/models/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../appointment_repository.dart';
import 'package:uuid/uuid.dart';

class FirebaseAppointmentRepo extends AppointmentRepo{
  final appointmentsCollection = FirebaseFirestore.instance.collection('appointments');

  @override
  Future<void> addAppointment(Appointment newAppointment) async {
    try{
      newAppointment.appointmentId = const Uuid().v1();
      newAppointment.status = 'Scheduled';
      appointmentsCollection.doc(newAppointment.appointmentId).set(newAppointment.toMap());
    }catch(e){
      print('Error "addAppointment": $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    try{
      await appointmentsCollection.doc(appointmentId).delete();
    }catch(e){
      print('Error "addAppointment": $e');
      rethrow;
    }
  }

  @override
  Stream<List<Appointment>> getAppointmentsForPatient(String patientId) {
    try{
      return appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList());
    }catch(e){
      print('Error "getAppointmentsForPatient": $e');
      rethrow;
    }
  }

  @override
  Stream<Appointment> getAppointmentById(String appointmentId) {
    try{
      return appointmentsCollection
          .where('appointmentId', isEqualTo: appointmentId)
          .snapshots()
          .map((snapshot){
            if(snapshot.docs.isNotEmpty){
              return Appointment.fromMap(snapshot.docs.first.data());
            }else{
              throw Exception('Appointment Not Found');
            }
          });
    }catch(e){
      print('Error "getAppointmentById": $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateInformation(Appointment updatedAppointment) async {
    try{
      appointmentsCollection.doc(updatedAppointment.appointmentId).update(updatedAppointment.toMap());
    }catch(e){
      print('Error "updatedAppointment": $e');
      rethrow;
    }
  }
  
  @override
  Stream<List<Appointment>> getAllAppointments(String doctorId) {
    try{
      return appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList());
    }catch(e){
      print('Error "getAllAppointments": $e');
      rethrow;
    }
  }
  
  @override
  Stream<List<Appointment>> getAppointmentsForDay(DateTime day, String doctorId) {
    try{
      // DateTime startOfDay = DateTime(day.year, day.month, day.day, 0, 0);
      // DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);
      DateTime startOfDay = DateTime(day.year, day.month, day.day);
      DateTime endOfDay = DateTime(day.year, day.month, day.day + 1);

      return appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
          .where('dateTime', isLessThan: endOfDay)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList());
    }catch(e){
      print('Error "getAppointmentsForDay": $e');
      rethrow;
    }
  }
  
  @override
  Stream<Appointment> getCurrentAppointment(String doctorId) {
    try{
      final now = Timestamp.fromDate(DateTime.now());

      final querySnapshot = appointmentsCollection.where('doctorId', isEqualTo: doctorId);

      return querySnapshot
          .where('dateTime', isGreaterThanOrEqualTo: now)
          .orderBy('dateTime')
          .limit(1)
          .snapshots()
          .map((snapshot) => snapshot.docs.isEmpty
            ? Appointment.empty
            : Appointment.fromMap(snapshot.docs.first.data()));
    }catch(e){
      print('Error displaying current appointment');
      rethrow;
    }
  }
}