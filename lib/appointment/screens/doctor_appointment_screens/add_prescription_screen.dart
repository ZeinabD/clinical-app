import 'package:clinical/appointment/blocs/prescription_bloc/prescription_bloc.dart';
import 'package:clinical/components/textfield.dart';
import 'package:clinical/models/prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final String appointmentId;
  const AddPrescriptionScreen(this.appointmentId, {super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  TextEditingController medicationsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  late Prescription prescription;

  @override
  void initState() {
    prescription = Prescription.empty;
    prescription.appointmentId = widget.appointmentId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prescription', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MyTextfield(
              controller: medicationsController, 
              hintText: 'Medicals', 
              prefixIcon: Icons.medication),
            MyTextfield(
              controller: instructionsController, 
              hintText: 'Instructions', 
              prefixIcon: Icons.arrow_circle_right),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
                  backgroundColor: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                setState(() {
                  prescription.medications = medicationsController.text;
                  prescription.instructions = instructionsController.text;
                });
                context.read<PrescriptionBloc>().add(AddPrescriptionEvent(prescription));
              },
              child: const Text('Add Prescription', style: TextStyle(fontSize: 25, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}