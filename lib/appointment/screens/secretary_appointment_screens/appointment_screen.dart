import 'package:clinical/models/appointment.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  const AppointmentScreen(this.appointment, {super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}