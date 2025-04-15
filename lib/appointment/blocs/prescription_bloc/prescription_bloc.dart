import 'package:clinical/models/prescription.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prescription_repository/prescription_repository.dart';

part 'prescription_event.dart';
part 'prescription_state.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final PrescriptionRepo prescriptionRepo;

  PrescriptionBloc(this.prescriptionRepo) : super(PrescriptionInitialState()) {
    on<AddPrescriptionEvent>((event, emit) async {
      emit(PrescriptionLoadingState());
      try{
        await prescriptionRepo.addPrescription(event.prescription);
        emit(PrescriptionSuccessState());
      }catch(e){
        emit(PrescriptionErrorState(e.toString()));
      }
    });

    on<UpdatePrescriptionEvent>((event, emit) async {
      emit(PrescriptionLoadingState());
      try{
        prescriptionRepo.updatePrescription(event.prescriptionUpdated);
        emit(PrescriptionSuccessState());
      }catch(e){
        emit(PrescriptionErrorState(e.toString()));
      }
    });
  }
}
