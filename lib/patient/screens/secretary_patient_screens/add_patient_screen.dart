import 'package:clinical/components/textfield.dart';
import 'package:clinical/patient/blocs/patient_bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  final String doctorId;
  const AddPatientScreen({required this.doctorId, super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String selectedGender = '';
  Patient? patient;
  bool addRequired = false;

  @override
  void initState(){
    super.initState();
    patient = Patient.empty;
    patient!.doctorId = widget.doctorId;
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
      genderController.text = selectedGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Patient', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
        ),
        body: BlocListener<PatientBloc, PatientState>(
          listener: (context, state) {
            if(state is PatientSuccessState){
              setState(() {
                addRequired = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient added successfully'),
                  duration: Duration(seconds: 2),
              ));
              Navigator.pop(context);
            }else if(state is PatientErrorState){
              setState(() {
                addRequired = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to add patient'),
                  duration: Duration(seconds: 2),
              ));
            }else if(state is PatientLoadingState){
              setState(() {
                addRequired = true;
              });
            }
          },
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyTextfield(
                    controller: nameController, 
                    hintText: 'Name', 
                    prefixIcon: Icons.person
                  ),
                  const SizedBox(height: 12),
                  MyTextfield(
                    controller: emailController, 
                    hintText: 'ُEmail', 
                    prefixIcon: Icons.mail
                  ),   
                  const SizedBox(height: 12),
                  MyTextfield(
                    controller: phoneController, 
                    hintText: 'Phone Number', 
                    prefixIcon: Icons.phone
                  ),             
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: genderController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: selectedGender == ''? 'Gender' : selectedGender == 'Female'? 'Female': 'Male',
                      hintStyle: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                      suffixIcon: PopupMenuButton<String>(
                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary, size: 35),
                        onSelected: _selectGender,
                        itemBuilder: (BuildContext context) {
                          return ['Female', 'Male'].map((String gender) {
                            return PopupMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList();
                        },
                      ),
                      prefixIcon: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.female, color: Theme.of(context).colorScheme.primary, size: 25),
                            Icon(Icons.male, color: Theme.of(context).colorScheme.primary, size: 25),
                          ],
                        ),
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
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: dateController,
                    prefixIcon: Icons.calendar_month_outlined,
                    hintText: 'Date of Birth',
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(const Duration(days: 365))
                      );
                      if(newDate != null){
                        setState((){
                          dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                        });
                      }
                    }, 
                  ),    
                  const SizedBox(height: 30),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width*0.5, 50),
                      backgroundColor: Theme.of(context).colorScheme.onSurface
                    ),
                    onPressed: () {
                      setState((){
                        // patient.doctorId = widget.doctorId;
                        patient?.name = nameController.text;
                        patient?.gender = genderController.text;
                        patient?.email = emailController.text;
                        patient?.phoneNumber = phoneController.text;
                        patient?.dateOfBirth = dateController.text;
                      });
                      context.read<PatientBloc>().add(AddPatientEvent(patient!));
                    },
                    child: const Text('Save Patient', style: TextStyle(fontSize: 25, color: Colors.white)),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}