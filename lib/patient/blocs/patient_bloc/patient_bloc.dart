import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinical/models/patient.dart';
import 'package:equatable/equatable.dart';
import 'package:patient_repository/patient_repository.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepo patientRepo;

  PatientBloc(this.patientRepo) : super(PatientInitialState()) {
    on<AddPatientEvent>((event, emit) async {
      emit(PatientLoadingState());
      try{
        await patientRepo.addPatient(event.patient);
        emit(PatientSuccessState());
      }catch(e){
        emit(PatientErrorState(e.toString()));
      }
    });

    on<DeletePatientEvent>((event, emit) async {
      emit(PatientLoadingState());
      try{
        await patientRepo.deletePatient(event.patientId);
        emit(PatientSuccessState());
      }catch(e){
        emit(PatientErrorState(e.toString()));
      }
    });

    on<UpdatePatientEvent>((event, emit) async {
      emit(PatientLoadingState());
      try{
        await patientRepo.updateInformation(event.patientId, event.patientUpdated);
        emit(PatientSuccessState());
      }catch(e){
        emit(PatientErrorState(e.toString()));
      }
    });
  }
}
