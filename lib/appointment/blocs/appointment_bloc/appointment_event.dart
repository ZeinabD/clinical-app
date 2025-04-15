part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class AddAppointmentEvent extends AppointmentEvent{
  final Appointment appointment;

  const AddAppointmentEvent(this.appointment);

  @override
  List<Object> get props => [appointment];
}

class DeleteAppointmentEvent extends AppointmentEvent{
  final String appointmentId;

  const DeleteAppointmentEvent(this.appointmentId);

  @override
  List<Object> get props => [appointmentId];
}

class UpdateAppointmentEvent extends AppointmentEvent{
  final Appointment appointmentUpdated;

  const UpdateAppointmentEvent(this.appointmentUpdated);

  @override   
  List<Object> get props => [appointmentUpdated];
}
