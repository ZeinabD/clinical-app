part of 'appointment_bloc.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();
  
  @override
  List<Object> get props => [];
}

final class AppointmentInitialState extends AppointmentState {}

final class AppointmentLoadingState extends AppointmentState {}
final class AppointmentSuccessState extends AppointmentState {}
final class AppointmentErrorState extends AppointmentState {
  final String error;

  const AppointmentErrorState(this.error);

  @override  
  List<Object> get props => [error];
}