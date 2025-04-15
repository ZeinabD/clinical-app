import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:clinical/home/secretary_home_screen/screens/appointment_calendar.dart';
import 'package:clinical/models/doctor.dart';
import 'package:clinical/patient/screens/secretary_patient_screens/patients_screen.dart';
import 'package:doctor_repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_repository/patient_repository.dart';
import 'package:user_repository/user_repository.dart';
import '../../../appointment/blocs/appointment_bloc/appointment_bloc.dart';
import '../../../appointment/screens/secretary_appointment_screens/all_appointment_screen.dart';
import '../../../patient/blocs/get_patients_bloc/get_patients_bloc.dart';
import 'secretary_settings_screen.dart';
import '../../blocs/signout_bloc/signout_bloc.dart';

class SecretaryHomeScreen extends StatefulWidget {
  final String secretaryId;
  const SecretaryHomeScreen({super.key, required this.secretaryId});

  @override
  State<SecretaryHomeScreen> createState() => _SecretaryHomeScreenState();
}

class _SecretaryHomeScreenState extends State<SecretaryHomeScreen> {
  List<Doctor> _doctors = [];
  Doctor _selectedDoctor = Doctor.empty;

  @override
  void initState(){
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      _doctors = await FirebaseDoctorRepo().getSecretaryDoctors(widget.secretaryId);
      if (_doctors.isNotEmpty) {
        _selectedDoctor = _doctors[0];
      }
      setState(() {});
    } catch (e) {
      print("Error loading doctors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            state.user?.name ?? 'unknown',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.home, size: 40));
          }),
          actions: [
            DropdownButton(
              icon: const Icon(Icons.arrow_drop_down),
              value: _selectedDoctor,
              items: _doctors.map<DropdownMenuItem<Doctor>>((Doctor doctor) {
                return DropdownMenuItem<Doctor>(
                  value: doctor, 
                  child: Text(doctor.name, style: const TextStyle(fontSize: 20)));
              }).toList(),
              onChanged: (Doctor? newValue) {
                _selectedDoctor = newValue!;
              }),
            IconButton(
              onPressed: () {
                context.read<SignoutBloc>().add(const SignoutRequired());
              },
              icon: const Icon(Icons.logout, size: 40)),
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
                      builder: (BuildContext context) => BlocProvider<UpdateUserInfoBloc>(
                        create: (context) => UpdateUserInfoBloc(FirebaseUserRepo()),
                        child: SecretarySettingsScreen(secretaryId: widget.secretaryId))));
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
                          ..add(GetAllPatients(_selectedDoctor.uid)),
                        child: PatientsScreen(doctorId: _selectedDoctor.uid))));
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
                              ..add(GetAllAppointments(_selectedDoctor.uid))),

                          BlocProvider<AppointmentBloc>(
                           create: (context) => AppointmentBloc(FirebaseAppointmentRepo()))
                        ], 
                        child: const AllAppointmentScreen())));
                },
              ),
            ]),
          ), 
        ),
        body: BlocProvider<GetAllAppointmentsBloc>(
          create: (context) => GetAllAppointmentsBloc(FirebaseAppointmentRepo()),
          child: Calendar(_selectedDoctor.uid))
      );
    });
  }
}
