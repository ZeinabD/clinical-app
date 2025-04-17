import 'package:clinical/models/appointment.dart';

abstract class AppointmentRepo {
  Future<void> addAppointment(Appointment newAppointment);

  Future<void> deleteAppointment(String appointmentId);

  Future<void> updateInformation(Appointment updatedAppointment);

  Stream<List<Appointment>> getAppointmentsForPatient(String patientId);

  Stream<List<Appointment>> getAllAppointments(String doctorId);

  Stream<List<Appointment>> getAppointmentsForDay(DateTime day, String doctorId);

  Stream<Appointment> getAppointmentById(String appointmentId);

  Stream<Appointment> getCurrentAppointment(String doctorId);
}