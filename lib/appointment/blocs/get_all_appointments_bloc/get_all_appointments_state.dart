part of 'get_all_appointments_bloc.dart';

sealed class GetAllAppointmentsState extends Equatable {
  const GetAllAppointmentsState();

  @override
  List<Object> get props => [];
}

final class GetAllAppointmentsInitial extends GetAllAppointmentsState {}

final class GetAllAppointmentsLoading extends GetAllAppointmentsState {}

final class GetAllAppointmentsLoaded extends GetAllAppointmentsState {
  final Stream<List<Appointment>> appointments;

  const GetAllAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

final class GetAppointmentsForPatientLoaded extends GetAllAppointmentsState {
  final Stream<List<Appointment>>? appointments;

  const GetAppointmentsForPatientLoaded(this.appointments);

  @override
  List<Object> get props => [appointments!];
}

final class GetAppointmentByIdLoaded extends GetAllAppointmentsState {
  final Stream<Appointment>? appointment;

  const GetAppointmentByIdLoaded(this.appointment);

  @override
  List<Object> get props => [appointment!];
}

final class GetAppointmentForDayLoaded extends GetAllAppointmentsState {
  final Stream<List<Appointment>>? appointments;

  const GetAppointmentForDayLoaded(this.appointments);

  @override
  List<Object> get props => [appointments!];
}

final class GetCurrentAppointmentLoaded extends GetAllAppointmentsState {
  final Appointment? appointment;

  const GetCurrentAppointmentLoaded(this.appointment);

  @override
  List<Object> get props => [appointment!];
}

final class GetAllAppointmentsError extends GetAllAppointmentsState {
  final String error;

  const GetAllAppointmentsError(this.error);

  @override
  List<Object> get props => [error];
}
