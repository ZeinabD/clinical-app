part of 'get_patients_bloc.dart';

sealed class GetPatientsState extends Equatable {
  const GetPatientsState();
  
  @override
  List<Object> get props => [];
}

final class GetPatientsInitial extends GetPatientsState {}

final class GetAllPatientsLoading extends GetPatientsState {}
final class GetAllPatientsLoaded extends GetPatientsState {
  final Stream<List<Patient>> patients;

  const GetAllPatientsLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}
final class GetAllPatientsError extends GetPatientsState {
  final String error;

  const GetAllPatientsError(this.error);

  @override
  List<Object> get props => [error];
}

final class GetPatientByIdLoading extends GetPatientsState {}
final class GetPatientByIdLoaded extends GetPatientsState {
  final Patient patient;

  const GetPatientByIdLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}
final class GetPatientByIdError extends GetPatientsState {
  final String error;

  const GetPatientByIdError(this.error);

  @override
  List<Object> get props => [error];
}
