import 'package:doctor_repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';
import '../../../components/textfield.dart';
import '../../../models/doctor.dart';
import '../../../models/secretary.dart';
import '../../blocs/signin_bloc/signin_bloc.dart';
import '../../blocs/signup_bloc/signup_bloc.dart';
import 'secretary_signin_screen.dart';

class SecretarySignupScreen extends StatefulWidget {
  const SecretarySignupScreen({super.key});

  @override
  State<SecretarySignupScreen> createState() => _SecretarySignupScreenState();
}

class _SecretarySignupScreenState extends State<SecretarySignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool signupRequired = false;
  List<String>? _doctorsId;

  Future<List<String>?> _showDoctorsDialog() async{
    List<Doctor>? allDoctors = await FirebaseDoctorRepo().getAllDoctors() ?? [];
    Map<String, bool> selectedDoctors = {};
    selectedDoctors = {for(var doctor in allDoctors) doctor.uid: false};

    return showDialog<List<String>>(
      context: context, 
      builder: (context){
         return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Select Doctors'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: allDoctors.map((doc){//!
                    return CheckboxListTile(
                      title: Text(doc.name),
                      subtitle: Text(doc.specialization),
                      value: selectedDoctors[doc.uid], 
                      onChanged: (bool? value){
                        setState(() {
                          selectedDoctors[doc.uid] = value ?? false;
                        });
                      });
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop(context);
                }, 
                child: const Text('Cancel')),
    
                TextButton(
                  onPressed: (){
                    if(selectedDoctors.isNotEmpty){
                      List<String> selectedDoctorsIds = selectedDoctors.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                      Navigator.of(context).pop(selectedDoctorsIds);
                    }
                  }, 
                  child: const Text('Confirm')),
              ],
            );
        });
    });
  }

  @override
  Widget build(BuildContext context) {
  return BlocListener<SignupBloc, SignupState>(
    listener: (BuildContext context, state) { 
      if(state is SignupFailureState){
        setState(() {
          signupRequired = false;
        });
      }else if(state is SignupLoadingState){ 
        setState(() {
          signupRequired = true;
        });
      }else{
        setState(() {
          signupRequired = false;
        });
      } 
    },
    child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create an account!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  controller: emailController, 
                  hintText: 'Email', 
                  prefixIcon: Icons.mail
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: nameController, 
                  hintText: 'Name', 
                  prefixIcon: Icons.person_2_rounded
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    readOnly: true,
                    onTap:  () async {
                      _doctorsId = await _showDoctorsDialog();
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Doctors',
                      hintStyle: TextStyle(fontSize: 23, color: Theme.of(context).colorScheme.onSurface),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: FaIcon(
                          Icons.medical_services, 
                          color: Theme.of(context).colorScheme.primary, 
                          size: 35),
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
                const SizedBox(height: 10),
                MyTextfield(
                  controller: passwordController, 
                  hintText: 'Password', 
                  prefixIcon: Icons.lock
                ),
                const SizedBox(height: 20),
                !signupRequired
                ?SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: kToolbarHeight,
                  child: TextButton(
                    onPressed: (){
                      Secretary newSecretary = Secretary.empty;
                      newSecretary.name = nameController.text;
                      newSecretary.email = emailController.text;
                      newSecretary.doctorsId = _doctorsId!;
                      
                      setState(() {
                        context.read<SignupBloc>().add(SignupRequired(
                          newSecretary,
                          passwordController.text
                        ));
                      });
                    }, 
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface
                    ),
                    child: const Text(
                      'Sign Up', 
                      style: TextStyle(
                        fontSize: 30, 
                        color: Colors.white
                      ))
                  ),
                )
                :const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => BlocProvider<SigninBloc>(
                          create: (context) => SigninBloc(FirebaseUserRepo()),
                          child: const SecretarySigninScreen()
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ', 
                        style: TextStyle(
                          fontSize: 25, 
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                      )),
                      Text(
                        'Login', 
                        style: TextStyle(
                          fontSize: 25, 
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}