import 'package:clinical/auth/blocs/signin_bloc/signin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';
import '../../../components/textfield.dart';
import '../../../models/doctor.dart';
import '../../blocs/signup_bloc/signup_bloc.dart';
import 'doctor_signin_screen.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController clinicNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController biographyController = TextEditingController();
  bool signupRequired = false;
  String selectedGender = '';

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
      genderController.text = selectedGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (BuildContext context, state) { 
        if(state is SigninFailureState){
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
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create an account!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: emailController, 
                    hintText: 'Email', 
                    prefixIcon: FontAwesomeIcons.solidEnvelope),
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: nameController, 
                    hintText: 'Name', 
                    prefixIcon: FontAwesomeIcons.solidUser),
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: specializationController,
                    hintText: 'Specialization', 
                    prefixIcon: FontAwesomeIcons.stethoscope),
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: biographyController,
                    hintText: 'Biography', 
                    prefixIcon: FontAwesomeIcons.idCard),
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: clinicNameController,
                    hintText: 'Clinic Name', 
                    prefixIcon: FontAwesomeIcons.hospital),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: passwordController, 
                    hintText: 'Password', 
                    prefixIcon: FontAwesomeIcons.lock),
                  const SizedBox(height: 30),
                  !signupRequired
                  ?SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: kToolbarHeight,
                    child: TextButton(
                      onPressed: (){
                        Doctor newDoctor = Doctor.empty;
                        newDoctor.name = nameController.text;
                        newDoctor.email = emailController.text;
                        newDoctor.clinicName = clinicNameController.text;
                        newDoctor.gender = genderController.text;
                        newDoctor.specialization = specializationController.text;
                        newDoctor.biographie = biographyController.text;
                        
                        setState(() {
                          context.read<SignupBloc>().add(SignupRequired(
                            newDoctor,
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
                            child: const DoctorSigninScreen()
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
      ),
    );
  }
}  