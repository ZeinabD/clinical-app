import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/models/appointment.dart';
import 'package:clinical/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_repository/patient_repository.dart';

class HistoryScreen extends StatefulWidget {
  final String patientId;
  const HistoryScreen(this.patientId, {super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patient>(
      future: FirebasePatientRepo().getPatientById(widget.patientId),
      builder: (context, patientSnapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${patientSnapshot.data!.name} History'),
          ),
          body: BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
            builder: (context, state) {
              if (state is GetAppointmentsForPatientLoaded) {
                return StreamBuilder<List<Appointment>>(
                  stream: state.appointments,
                  builder: (context, appointmentSnapshot) {
                    if(appointmentSnapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }else if(appointmentSnapshot.hasError){
                      return const Text('Error fetching appointments');
                    }else if(appointmentSnapshot.hasData){
                      final appointments = appointmentSnapshot.data ?? [];
                      if(appointments.isEmpty){
                        return Text('${patientSnapshot.data!.name} has no appointments tell today');
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, int i){
                            return Card(
                              color: Theme.of(context).colorScheme.onSurface,
                              child: const Padding(
                                padding: EdgeInsets.all(13),
                                child: Column(
                                  children: [

                                  ],
                                ),
                              ),
                            );
                          })
                      );
                    }else{return const Text('Error');}
                  }
                );
              }else{
                return const CircularProgressIndicator();
              }
            }
          ),
        );
      }
    );
  }
}