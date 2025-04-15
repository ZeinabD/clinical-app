part of 'get_patients_bloc.dart';

sealed class GetPatientsEvent extends Equatable {
  const GetPatientsEvent();

  @override
  List<Object> get props => [];
}

class GetAllPatients extends GetPatientsEvent{
  final String doctorId;

  const GetAllPatients(this.doctorId);

  @override   
  List<Object> get props => [doctorId];
}

class GetPatientById extends GetPatientsEvent{
  final String patientId;

  const GetPatientById(this.patientId);

  @override   
  List<Object> get props => [patientId];
}