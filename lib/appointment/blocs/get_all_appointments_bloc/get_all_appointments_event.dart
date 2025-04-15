part of 'get_all_appointments_bloc.dart';

sealed class GetAllAppointmentsEvent extends Equatable {
  const GetAllAppointmentsEvent();

  @override
  List<Object> get props => [];
}

class GetAllAppointments extends GetAllAppointmentsEvent{
  final String doctorId;

  const GetAllAppointments(this.doctorId);

  @override   
  List<Object> get props => [doctorId];
}

class GetAppointmentsForPatient extends GetAllAppointmentsEvent{
  final String patientId;

  const GetAppointmentsForPatient(this.patientId);

  @override   
  List<Object> get props => [patientId];
}

class GetAppointmentById extends GetAllAppointmentsEvent{
  final String appointmentId;

  const GetAppointmentById(this.appointmentId);

  @override   
  List<Object> get props => [appointmentId];
}

class GetAppointmentsForDay extends GetAllAppointmentsEvent{
  final DateTime day;
  final String doctorId;

  const GetAppointmentsForDay({required this.day, required this.doctorId});

  @override   
  List<Object> get props => [day, doctorId];
}


class GetCurrentAppointment extends GetAllAppointmentsEvent{
  final String doctorId;

  const GetCurrentAppointment({required this.doctorId});

  @override   
  List<Object> get props => [doctorId];
}