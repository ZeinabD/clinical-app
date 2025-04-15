part of 'patient_bloc.dart';

sealed class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class AddPatientEvent extends PatientEvent{
  final Patient patient;

  const AddPatientEvent(this.patient);

  @override
  List<Object> get props => [patient];
}

class DeletePatientEvent extends PatientEvent{
  final String patientId;

  const DeletePatientEvent(this.patientId);

  @override
  List<Object> get props => [patientId];
}

class UpdatePatientEvent extends PatientEvent{
  final String patientId;
  final Patient patientUpdated;

  const UpdatePatientEvent(this.patientId, this.patientUpdated);

  @override   
  List<Object> get props => [patientId, patientUpdated];
}