part of 'prescription_bloc.dart';

sealed class PrescriptionEvent extends Equatable {
  const PrescriptionEvent();

  @override
  List<Object> get props => [];
}

class AddPrescriptionEvent extends PrescriptionEvent{
  final Prescription prescription;

  const AddPrescriptionEvent(this.prescription);

  @override
  List<Object> get props => [prescription];
}

class UpdatePrescriptionEvent extends PrescriptionEvent{
  final String prescriptionId;
  final Prescription prescriptionUpdated;

  const UpdatePrescriptionEvent(this.prescriptionId, this.prescriptionUpdated);

  @override   
  List<Object> get props => [prescriptionId, prescriptionUpdated];
}
