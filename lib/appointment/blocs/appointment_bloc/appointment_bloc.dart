import 'package:appointment_repository/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepo appointmentRepo;

  AppointmentBloc(this.appointmentRepo) : super(AppointmentInitialState()) {
    on<AddAppointmentEvent>((event, emit) async {
      emit(AppointmentLoadingState());
      try{
        await appointmentRepo.addAppointment(event.appointment);
        emit(AppointmentSuccessState());
      }catch(e){
        emit(AppointmentErrorState(e.toString()));
      }
    });

    on<DeleteAppointmentEvent>((event, emit) async {
      emit(AppointmentLoadingState());
      try{
        appointmentRepo.deleteAppointment(event.appointmentId);
        emit(AppointmentSuccessState());
      }catch(e){
        emit(AppointmentErrorState(e.toString()));
      }
    });

    on<UpdateAppointmentEvent>((event, emit) async {
      emit(AppointmentLoadingState());
      try{
        appointmentRepo.updateInformation(event.appointmentUpdated);
        emit(AppointmentSuccessState());
      }catch(e){
        emit(AppointmentErrorState(e.toString()));
      }
    });
  }
}
