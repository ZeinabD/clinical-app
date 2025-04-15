import 'package:clinical/appointment/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../components/textfield.dart';
import '../../../models/appointment.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String patientId;
  final String doctorId;
  const AddAppointmentScreen({required this.patientId, required this.doctorId, super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  late Appointment appointment;
  bool addRequired = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime fullDateTime = DateTime.now();

  @override
  void initState() {
    appointment = Appointment.empty;
    appointment.patientId = widget.patientId;
    appointment.doctorId = widget.doctorId;
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Appointment', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if(state is AppointmentSuccessState){
            setState(() {
              addRequired = false;
            });
            Navigator.pop(context);
          }else if(state is AppointmentErrorState){
            setState(() {
              addRequired = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to edit appointment'),
                duration: Duration(seconds: 2),
            ));
          }else if(state is AppointmentLoadingState){
            setState(() {
              addRequired = true;
            });
          }
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                MyTextfield(
                  controller: dateController,
                  prefixIcon: Icons.calendar_month_outlined,
                  hintText: 'Select Date',
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)));
                    if (newDate != null) {
                      setState(() {
                        selectedDate = newDate;
                        dateController.text = DateFormat('dd-MM-yyyy').format(newDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  controller: timeController,
                  hintText: 'Choose Time',
                  prefixIcon: Icons.watch_later,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (newTime != null) {
                      setState(() {
                        selectedTime = newTime;
                        String period = newTime.period == DayPeriod.am ? 'AM' : 'PM';
                        timeController.text = '${newTime.hour.toString()}:${newTime.minute.toString()}  $period';
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                MyTextfield(
                    controller: priceController,
                    hintText: 'Price',
                    prefixIcon: Icons.monetization_on),
                const SizedBox(height: 30),
                !addRequired
                ?TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
                      backgroundColor: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    if(selectedDate != null && selectedTime != null){
                      fullDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                    }
                    setState(() {
                      appointment.dateTime = fullDateTime;
                      appointment.price = double.parse(priceController.text);
                    });
                    context.read<AppointmentBloc>().add(AddAppointmentEvent(appointment));
                  },
                  child: const Text('Save Appointment', style: TextStyle(fontSize: 25, color: Colors.white)),
                )
                : const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
