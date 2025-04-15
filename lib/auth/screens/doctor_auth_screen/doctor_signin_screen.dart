import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../../components/textfield.dart';
import '../../blocs/signin_bloc/signin_bloc.dart';
import '../../blocs/signup_bloc/signup_bloc.dart';
import 'doctor_signup_screen.dart';

class DoctorSigninScreen extends StatefulWidget {
  const DoctorSigninScreen({super.key});

  @override
  State<DoctorSigninScreen> createState() => _DoctorSigninScreenState();
}

class _DoctorSigninScreenState extends State<DoctorSigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool signinRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if(state is SigninFailureState){
          setState(() {
            signinRequired = false;
          });
        }else if(state is SigninLoadingState){ 
          setState(() {
            signinRequired = true;
          });
        }else{
          setState(() {
            signinRequired = false;
          });
        } 
      },
      child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MyTextfield(
                      controller: emailController, 
                      hintText: 'Email', 
                      prefixIcon: Icons.mail
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MyTextfield(
                      controller: passwordController, 
                      hintText: 'Password', 
                      prefixIcon: Icons.lock
                    ),
                  ),
                  const SizedBox(height: 20),
                  !signinRequired
                  ?SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: kToolbarHeight,
                    child: TextButton(
                      onPressed: (){
                        context.read<SigninBloc>().add(SigninRequired(
                          emailController.text, 
                          passwordController.text
                        ));
                      }, 
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface
                      ),
                      child: const Text(
                        'Sign In', 
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
                          builder: (BuildContext context) => BlocProvider<SignupBloc>(
                            create: (context) => SignupBloc(FirebaseUserRepo()),
                            child: const DoctorSignupScreen()
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                        )),
                        Text(
                          'Register', 
                          style: TextStyle(
                            fontSize: 24, 
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