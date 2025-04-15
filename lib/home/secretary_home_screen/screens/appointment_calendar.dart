import 'package:clinical/appointment/blocs/get_all_appointments_bloc/get_all_appointments_bloc.dart';
import 'package:clinical/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../appointment/screens/secretary_appointment_screens/appointment_screen.dart';

class Calendar extends StatefulWidget {
  final String doctorId;

  const Calendar(this.doctorId, {super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

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
    final getAllAppointmentsBloc = context.read<GetAllAppointmentsBloc>();

    showDialog(
      context: context, 
      builder: (dialogContext){
        return BlocProvider.value(
          value: getAllAppointmentsBloc,
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
                          return const Center(child: Text('Error', style: TextStyle(fontSize: 30)));
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
                            // final patient = FirebasePatientRepo().getPatientById(appointment.patientId);
                            return ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text('patient.name)'),
                              subtitle: Text(time),
                              onTap: (){
                                Navigator.push(
                                  dialogContext,
                                  MaterialPageRoute<void>(
                                    builder: (context) => AppointmentScreen(appointment),
                                  ));
                              },
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