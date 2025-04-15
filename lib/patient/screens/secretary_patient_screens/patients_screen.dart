import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:clinical/models/patient.dart';
import 'package:clinical/patient/blocs/patient_bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_repository/patient_repository.dart';
import '../../../appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import '../../../appointment/screens/secretary_appointment_screens/appointments_for_patient_screen.dart';
import '../../blocs/get_patients_bloc/get_patients_bloc.dart';
import 'add_patient_screen.dart';

class PatientsScreen extends StatefulWidget {
  final String doctorId;
  const PatientsScreen({required this.doctorId, super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Patients',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500)),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => BlocProvider<PatientBloc>(
                create: (context) => PatientBloc(FirebasePatientRepo()),
                child: AddPatientScreen(doctorId: widget.doctorId),
              )));
        },
        icon: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add, size: 50))),
      body: BlocBuilder<GetPatientsBloc, GetPatientsState>(
        builder: (context, state) {
          if (state is GetAllPatientsError) {
            return const Center(child: Text('Error Fetching Patients', style: TextStyle(fontSize: 30)));
          }else if (state is GetAllPatientsLoading) {
            return const Center(child: CircularProgressIndicator());
          }else if (state is GetAllPatientsLoaded) {
            return StreamBuilder<List<Patient>>(
              stream: state.patients,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error Fetching Patient', style: TextStyle(fontSize: 30)));
                }

                final patients = snapshot.data ?? [];
                if (patients.isEmpty) {
                  return const Center(child: Text('No Patients', style: TextStyle(fontSize: 30, color: Colors.black)));
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                    itemCount: patients.length,
                    itemBuilder: (context, int i) {
                      final patient = patients[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<GetAllAppointmentsBloc>(
                                    create: (context) => GetAllAppointmentsBloc(FirebaseAppointmentRepo())
                                      ..add(GetAppointmentsForPatient(patient.patientId))),
                                  BlocProvider<AppointmentBloc>(
                                    create: (context) => AppointmentBloc(FirebaseAppointmentRepo()))
                                ], 
                                child: AppointmentsForPatientScreen(patient: patient))
                              ));
                        },
                        child: Card(
                            color: Theme.of(context).colorScheme.onSurface,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    patient.name,
                                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface)),
                                  const SizedBox(height: 10),
                                  Text(
                                    patient.phoneNumber, 
                                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface)),
                                  Text(
                                    patient.gender,
                                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface))
                                ])),
                      );
                    }),
                );
              });
        }
        return Container();
      }),
    );
  }
}
