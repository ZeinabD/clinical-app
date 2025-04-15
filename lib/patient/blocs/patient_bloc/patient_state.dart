part of 'patient_bloc.dart';

sealed class PatientState extends Equatable {
  const PatientState();
  
  @override
  List<Object> get props => [];
}

final class PatientInitialState extends PatientState{}

final class PatientLoadingState extends PatientState{}

final class PatientSuccessState extends PatientState{}

final class PatientErrorState extends PatientState{
  final String error;

  const PatientErrorState(this.error);

  @override
  List<Object> get props => [error];
}