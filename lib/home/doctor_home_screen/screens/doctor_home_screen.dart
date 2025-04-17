import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/appointment/screens/doctor_appointment_screens/add_prescription_screen.dart';
import 'package:clinical/appointment/screens/secretary_appointment_screens/all_appointment_screen.dart';
import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/blocs/signout_bloc/signout_bloc.dart';
import 'package:clinical/home/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:clinical/home/doctor_home_screen/screens/doctor_settings_screen.dart';
import 'package:clinical/models/appointment.dart';
import 'package:clinical/models/patient.dart';
import 'package:clinical/patient/blocs/get_patients_bloc/get_patients_bloc.dart';
import 'package:clinical/patient/screens/doctor_patient_screens/history_screen.dart';
import 'package:clinical/patient/screens/secretary_patient_screens/patients_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:patient_repository/patient_repository.dart';
import 'package:user_repository/user_repository.dart';

class DoctorHomeScreen extends StatefulWidget {
  final String doctorId;
  const DoctorHomeScreen(this.doctorId, {super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user?.name ?? 'unknown'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SignoutBloc>().add(const SignoutRequired());
                },
                icon: const Icon(Icons.logout, size: 50)),
            ],
          ),
        drawer: Drawer(
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            child: ListView(children: [
              const DrawerHeader(child: Icon(Icons.home, size: 50, color: Colors.white)),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(Icons.settings, size: 35)),
                title: Text('Settings',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w500,
                    fontSize: 23)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<UpdateUserInfoBloc>(create: (context) => UpdateUserInfoBloc(FirebaseUserRepo())),
                          BlocProvider<MyUserBloc>(create: (context) => MyUserBloc(FirebaseUserRepo())),
                        ],
                        child: DoctorSettingsScreen(doctorId: widget.doctorId))));
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(Icons.person, size: 35)),
                title: Text('Patients',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w500,
                    fontSize: 23)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider<GetPatientsBloc>(
                        create: (context) => GetPatientsBloc(FirebasePatientRepo())
                          ..add(GetAllPatients(widget.doctorId)),
                        child: PatientsScreen(doctorId: widget.doctorId))));
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(Icons.monitor_heart_rounded, size: 35)),
                title: Text('Appointments',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w500,
                    fontSize: 23)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<GetAllAppointmentsBloc>(
                           create: (context) => GetAllAppointmentsBloc(FirebaseAppointmentRepo())
                              ..add(GetAllAppointments(widget.doctorId))),

                          BlocProvider<AppointmentBloc>(
                           create: (context) => AppointmentBloc(FirebaseAppointmentRepo()))
                        ], 
                        child: const AllAppointmentScreen())));
                },
              ),
            ]),
          ), 
        ),
        body: BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
        builder: (context, state) {
          if(state is GetCurrentAppointmentLoaded){
            return StreamBuilder<Appointment>(
              stream: state.appointment,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return const Center(child: Text('Stream Error', style: TextStyle(fontSize: 30)));
                }
                Appointment appointment = snapshot.data!;
                
                if(appointment == Appointment.empty){
                  return const Center(child: Text('No Current Appointments', style: TextStyle(fontSize: 30)));
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  builder: (BuildContext context) => BlocProvider<GetAllAppointmentsBloc>(
                                    create:(context) => GetAllAppointmentsBloc(FirebaseAppointmentRepo()),
                                    child: HistoryScreen(appointment.patientId))));
                          },
                          child: const Text("Patient's History")),
                        ],
                      ),
                    ]),
                );
              }
            );
          }else if(state is GetCurrentAppointmentEmpty){
            return const Center(child: Text('No Current Appointments'));
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
    );
  }
}