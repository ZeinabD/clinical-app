import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_repository/patient_repository.dart';
import '../../../models/patient.dart';
import 'edit_appointment_screen.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Appointments', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
        builder: (context, state) {
          if(state is GetAllAppointmentsLoaded){
            return StreamBuilder<List<Appointment>>(
              stream: state.appointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error', style: TextStyle(fontSize: 30)));
                }
                final appointments = snapshot.data ?? [];

                if (appointments.isEmpty) {
                  return const Center(child: Text('No Appointments', style: TextStyle(fontSize: 30)));
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, int i){
                    final appointment = appointments[i];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Theme.of(context).colorScheme.onSurface,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<Patient>(
                                    future: FirebasePatientRepo().getPatientById(appointment.patientId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return const Text('Error fetching patient');
                                      }
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!.name, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20));
                                      }
                                      return const Text('No Patient Found');
                                    }
                                  ),
                                  const SizedBox(height: 10),
                                  Text(appointment.dateTime.toString(), style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20)),
                                  const SizedBox(height: 10),
                                  Text(appointment.status, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20)),
                                  const SizedBox(height: 10),
                                  Text(appointment.price.toString(), style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20)),
                              ]),
                              Column(
                                children: [
                                  IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => BlocProvider<AppointmentBloc>(
                                          create:(context) => AppointmentBloc(FirebaseAppointmentRepo()),
                                          child: EditAppointmentScreen(appointment)),
                                      ));
                                  }, 
                                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary, size: 30)),
                                  IconButton(
                                  onPressed: (){
                                    context.read<AppointmentBloc>().add(DeleteAppointmentEvent(appointment.appointmentId));
                                  }, 
                                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary, size: 30)),
                                ],
                              ),
                            ]),
                        ),
                      ),
                    );
                  }
                );
              }
            );
          }else if(state is GetAllAppointmentsError){
            return const Center(child: Text('Error', style: TextStyle(fontSize: 30)));
          }else if(state is GetAllAppointmentsLoading){
            return const Center(child: CircularProgressIndicator());
          }else{
            return Container(color: Colors.red);
          }
        }
      ),
    );
  }
}