import 'package:appointment_repository/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/appointment.dart';

part 'get_all_appointments_event.dart';
part 'get_all_appointments_state.dart';

class GetAllAppointmentsBloc extends Bloc<GetAllAppointmentsEvent, GetAllAppointmentsState> {
  final AppointmentRepo appointmentRepo;

  GetAllAppointmentsBloc(this.appointmentRepo) : super(GetAllAppointmentsInitial()) {
    on<GetAllAppointments>((event, emit){
      emit(GetAllAppointmentsLoading());
      try{
        final Stream<List<Appointment>> appointments = appointmentRepo.getAllAppointments(event.doctorId);
        emit(GetAllAppointmentsLoaded(appointments));
      }catch(e){
        emit(GetAllAppointmentsError(e.toString()));
      }
    });

    on<GetAppointmentsForPatient>((event, emit){
      emit(GetAllAppointmentsLoading());
      try{
        final Stream<List<Appointment>> appointments = appointmentRepo.getAppointmentsForPatient(event.patientId);
        emit(GetAppointmentsForPatientLoaded(appointments));
      }catch(e){
        emit(GetAllAppointmentsError(e.toString()));
      }
    });

    on<GetAppointmentById>((event, emit){
      emit(GetAllAppointmentsLoading());
      try{
        final Stream<Appointment> appointment = appointmentRepo.getAppointmentById(event.appointmentId);
        emit(GetAppointmentByIdLoaded(appointment));
      }catch(e){
        emit(GetAllAppointmentsError(e.toString()));
      }
    });

    on<GetAppointmentsForDay>((event, emit) async{
      if(state is! GetAppointmentForDayLoaded || (state as GetAppointmentForDayLoaded).day != event.day){
        emit(GetAllAppointmentsLoading());
      }
      try{
        final Stream<List<Appointment>> appointments = appointmentRepo.getAppointmentsForDay(event.day, event.doctorId);
        emit(GetAppointmentForDayLoaded(appointments, day: event.day));
      }catch(e){
        emit(const GetAllAppointmentsError('Failed Fetch Appointments'));
      }
    });

    on<GetCurrentAppointment>((event, emit) async{
      emit(GetAllAppointmentsLoading());
      try{
        final Stream<Appointment> appointment = appointmentRepo.getCurrentAppointment(event.doctorId);
        if(appointment == Appointment.empty){
          emit(GetCurrentAppointmentEmpty());
        }else{
          emit(GetCurrentAppointmentLoaded(appointment));
        }
      }catch(e){
        emit(const GetAllAppointmentsError('Failed Fetch Appointments'));
      }
    });
  }
}
