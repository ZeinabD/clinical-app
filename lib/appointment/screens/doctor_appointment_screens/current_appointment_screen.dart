import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/appointment/screens/doctor_appointment_screens/add_prescription_screen.dart';
import 'package:clinical/models/appointment.dart';
import 'package:clinical/models/patient.dart';
import 'package:clinical/patient/screens/doctor_patient_screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:patient_repository/patient_repository.dart';

class CurrentAppointmentScreen extends StatefulWidget {
  const CurrentAppointmentScreen({super.key});

  @override
  State<CurrentAppointmentScreen> createState() => _CurrentAppointmentScreenState();
}

class _CurrentAppointmentScreenState extends State<CurrentAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Current Appointment', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
        builder: (context, state) {
          if(state is GetCurrentAppointmentLoaded){
            final Appointment appointment = state.appointment ?? Appointment.empty;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(DateFormat('hh:mm a').format(appointment.dateTime), style: const TextStyle(fontSize: 16)),
                  Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<Patient>(
                        future: FirebasePatientRepo().getPatientById(appointment.patientId),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          }else if(snapshot.hasError){
                            return const Text('Error fetching patient');
                          }else if(snapshot.hasData){
                            final patient = snapshot.data!;;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Patient Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("Name: ${patient.name}"),
                                Text("Age: ${patient.dateOfBirth}"),
                                Text("Gender: ${patient.gender}"),
                                Text("Phone: ${patient.phoneNumber}"),
                                Text("Email: ${patient.email}"),
                              ]);
                          }else{ return const Text('No Patient Found');}
                        }
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => BlocProvider<AppointmentBloc>(
                                create:(context) => AppointmentBloc(FirebaseAppointmentRepo()),
                                child: AddPrescriptionScreen(appointment.appointmentId))));
                      },
                      child: const Text("Add Prescription")),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => BlocProvider<AppointmentBloc>(
                                create:(context) => AppointmentBloc(FirebaseAppointmentRepo()),
                                child: HistoryScreen(appointment.patientId))));
                      },
                      child: const Text("Patient's History")),
                    ],
                  ),
                ]),
            );
          }else if(state is GetAllAppointmentsLoading){
            return const Center(child: CircularProgressIndicator());
          }else if(state is GetAllAppointmentsError){
            return const Center(child: Text('Error', style: TextStyle(fontSize: 30)));
          }else{
            return Container(color: Colors.red);
          }
        }
      ),
    );
  }
}