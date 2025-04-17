import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/models/appointment.dart';
import 'package:clinical/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:patient_repository/patient_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final String doctorId;

  const Calendar(this.doctorId, {super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _selectedDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });

            context.read<GetAllAppointmentsBloc>().add(GetAppointmentsForDay(day: selectedDay, doctorId: widget.doctorId));

            _showAppointmentsDialog(context, selectedDay);
          },
        ),
      ]);
  }

  void _showAppointmentsDialog(BuildContext context, DateTime selectedDay){
    final bloc = context.read<GetAllAppointmentsBloc>();

    if (bloc.state is! GetAppointmentForDayLoaded || (bloc.state as GetAppointmentForDayLoaded).day != selectedDay) {
      bloc.add(GetAppointmentsForDay(day: selectedDay, doctorId: widget.doctorId));
    }

    showDialog(
      context: context, 
      builder: (dialogContext){
        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            title: Text(DateFormat('dd/MM/yyyy').format(selectedDay)),
            content: Container(
              width: double.maxFinite,
              child: BlocBuilder<GetAllAppointmentsBloc, GetAllAppointmentsState>(
                builder: (dialogContext, state) {
                  if(state is GetAllAppointmentsLoading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(state is GetAllAppointmentsError){
                    return const Center(child: Text('Error fetching appointments'));
                  }
                  else if(state is GetAppointmentForDayLoaded){
                    return StreamBuilder<List<Appointment>>(
                      stream: state.appointments,
                      builder: (dialogContext, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        if(snapshot.hasError){
                          return const Center(child: Text('Stream Error', style: TextStyle(fontSize: 30)));
                        }
                        final appointments = snapshot.data ?? [];
                        
                        if(appointments.isEmpty){
                          return const Center(child: Text('No Appointments', style: TextStyle(fontSize: 30)));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: appointments.length,
                          itemBuilder: (dialogContext, int i){
                            final appointment = appointments[i];
                            final String time = DateFormat("hh:mm a").format(appointment.dateTime);
                            return FutureBuilder<Patient>(
                              future: FirebasePatientRepo().getPatientById(appointment.patientId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return ListTile(
                                    leading: const Icon(Icons.local_hospital),
                                    title: const Text('Loading...'),
                                    subtitle: Text(time),
                                  );
                                }else if(snapshot.hasError) {
                                  return ListTile(
                                    leading: const Icon(Icons.error),
                                    title: const Text('Error loading patient'),
                                    subtitle: Text(time),
                                  );
                                } else {
                                  return ListTile(
                                    leading: const Icon(Icons.local_hospital),
                                    title: Text(snapshot.data!.name),
                                    subtitle: Text(time),
                                    onTap: (){
                                      // Navigator.push(
                                      //   dialogContext,
                                      //   MaterialPageRoute<void>(
                                      //     builder: (context) => AppointmentScreen(appointment),
                                      //   ));
                                    },
                                  );
                                }
                              }
                            );
                          });
                      }
                    );
                  }
                  return Container(color: Colors.red);
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); 
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      });
  }
}