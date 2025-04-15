import 'package:appointment_repository/appointment_repository.dart';
import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/appointment/screens/secretary_appointment_screens/add_appointment_screen.dart';
import 'package:clinical/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/patient.dart';
import 'edit_appointment_screen.dart';

class AppointmentsForPatientScreen extends StatefulWidget {
  final Patient patient;
  const AppointmentsForPatientScreen({required this.patient, super.key});

  @override
  State<AppointmentsForPatientScreen> createState() => _AppointmentsForPatientScreenState();
}

class _AppointmentsForPatientScreenState extends State<AppointmentsForPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => BlocProvider(
                create: (context) => AppointmentBloc(FirebaseAppointmentRepo()),
                child: AddAppointmentScreen(
                  patientId: widget.patient.patientId,
                  doctorId: widget.patient.doctorId),
              ),
            ));
        },
        icon: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add, size: 50))),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone Number: ${widget.patient.phoneNumber}', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            Text('Gender: ${widget.patient.gender}', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            Text('Date of Birth: ${widget.patient.dateOfBirth}', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            Text('Appointments',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
            BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
              builder: (context, state) {
                if(state is GetAppointmentsForPatientLoaded){
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
                      return Expanded(
                        child: ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, int i) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Theme.of(context).colorScheme.onSurface,
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(appointments[i].dateTime.toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20)),
                                          const SizedBox(height: 10),
                                          Text(appointments[i].status,
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20)),
                                          const SizedBox(height: 10),
                                          Text(appointments[i].price.toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20)),
                                      ]),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder: (BuildContext context) => BlocProvider<AppointmentBloc>(
                                                    create:(context) => AppointmentBloc(FirebaseAppointmentRepo()),
                                                    child: EditAppointmentScreen(appointments[i]))));
                                            },
                                            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary, size: 30)),
                                          IconButton(
                                            onPressed: (){
                                              context.read<AppointmentBloc>().add(DeleteAppointmentEvent(appointments[i].appointmentId));
                                            }, 
                                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary, size: 30)),
                                      ]),
                                    ]),
                                ),
                              ),
                            );
                          }),
                      );
                    }
                  );
                }else if(state is GetAllAppointmentsLoading){
                  return const Center(child: CircularProgressIndicator());
                }else if(state is GetAllAppointmentsError){
                  return const Center(child: Text('Error', style: TextStyle(fontSize: 30)));
                }else{
                  return Container(color: Colors.red);
                }
              }
            )],
        ),
      ),
    );
  }
}
