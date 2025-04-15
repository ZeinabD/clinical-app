part of 'prescription_bloc.dart';

sealed class PrescriptionState extends Equatable {
  const PrescriptionState();
  
  @override
  List<Object> get props => [];
}

final class PrescriptionInitialState extends PrescriptionState {}
final class PrescriptionLoadingState extends PrescriptionState {}
final class PrescriptionSuccessState extends PrescriptionState {}
final class PrescriptionErrorState extends PrescriptionState {
  final String error;

  const PrescriptionErrorState(this.error);

  @override  
  List<Object> get props => [error];
}