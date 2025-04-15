import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../components/textfield.dart';
import '../../../models/appointment.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  const EditAppointmentScreen(this.appointment, {super.key});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  bool editRequired = false;
  DateTime? selectedDate, newDateTime; 
  TimeOfDay? selectedTime; 
  String initialDate = '', initialStatus = '', initialTime = '', selectedStatus = '';

  @override
  void initState(){
    super.initState();
    initialDate = DateFormat('dd-MM-yyyy').format(widget.appointment.dateTime);
    initialTime = DateFormat('hh:mm a').format(widget.appointment.dateTime);
    initialStatus = widget.appointment.status;
    selectedStatus = initialStatus;

    dateController.text = initialDate;
    statusController.text = initialStatus;
    timeController.text = initialTime;
  }

  void _selectStatus(String currentStatus){
    setState(() {
      selectedStatus = currentStatus;
      statusController.text = selectedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if(state is AppointmentSuccessState){
            setState(() {
              editRequired = false;
            });
            Navigator.pop(context);
          }else if(state is AppointmentErrorState){
            setState(() {
              editRequired = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to edit appointment'),
                duration: Duration(seconds: 2),
            ));
          }else if(state is AppointmentLoadingState){
            setState(() {
              editRequired = true;
            });
          }
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: MyTextfield(
                    controller: dateController,
                    prefixIcon: Icons.calendar_month_outlined,
                    hintText: 'select a date',
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365))
                      );
                      if(newDate != null){
                        setState((){
                          selectedDate = newDate;
                          dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                        });
                      }
                    },
                  ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: MyTextfield(
                  controller: timeController, 
                  hintText: 'choose a time', 
                  prefixIcon: Icons.watch_later,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if(newTime != null){
                      setState((){
                        selectedTime = newTime;
                        String period = newTime.period == DayPeriod.am ? 'AM' : 'PM';
                        timeController.text = '${newTime.hour.toString()}:${newTime.minute.toString()}  $period';
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: statusController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: selectedStatus == ''? 'Status' : selectedStatus == 'Scheduled'? 'Scheduled': selectedStatus == 'Completed'? 'Completed': 'Missed',
                    hintStyle: TextStyle(fontSize: 23, color: Theme.of(context).colorScheme.onSurface),
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary, size: 35),
                      onSelected: _selectStatus,
                      itemBuilder: (BuildContext context) {
                        return ['Scheduled', 'Completed', 'Missed'].map((String status) {
                          return PopupMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList();
                      },
                    ),
                    prefixIcon: SizedBox(
                      width: 60,
                      child: Icon(Icons.alarm_on, color: Theme.of(context).colorScheme.primary, size: 35),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                  ),
                ),
              ),  
              const SizedBox(height: 30),
              !editRequired
              ?TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width*0.5, 50),
                  backgroundColor: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: (){
                  if(selectedDate != null && selectedTime != null){
                    newDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute
                    );
                  }
                  setState(() {
                    if(dateController.text != initialDate && timeController.text != initialTime){
                      widget.appointment.dateTime = newDateTime!;
                    }
                    if(statusController.text != initialStatus){
                      widget.appointment.status = selectedStatus;
                    }
                  });
                  context.read<AppointmentBloc>().add(UpdateAppointmentEvent(widget.appointment));
                },
                child: const Text('Edit Appointment', style: TextStyle(fontSize: 25, color: Colors.white)),
              )
              : const Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}