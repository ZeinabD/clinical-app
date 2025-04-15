import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinical/models/patient.dart';
import 'package:equatable/equatable.dart';
import 'package:patient_repository/patient_repository.dart';

part 'get_patients_event.dart';
part 'get_patients_state.dart';

class GetPatientsBloc extends Bloc<GetPatientsEvent, GetPatientsState> {
  final PatientRepo patientRepo;

  GetPatientsBloc(this.patientRepo) : super(GetPatientsInitial()) {
    on<GetAllPatients>((event, emit) {
      emit(GetAllPatientsLoading());
      try{
        Stream<List<Patient>> patients = patientRepo.getAllPatients(event.doctorId);
        emit(GetAllPatientsLoaded(patients));
      }catch(e){
        emit(GetAllPatientsError(e.toString()));
      }
    });

    on<GetPatientById>((event, emit) async {
      emit(GetPatientByIdLoading());
      try{
        final Patient patient = await patientRepo.getPatientById(event.patientId);
        emit(GetPatientByIdLoaded(patient));
      }catch(e){
        emit(GetPatientByIdError(e.toString()));
      }
    });
  }
}
