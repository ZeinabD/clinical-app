
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/signin_bloc/signin_bloc.dart';
import 'doctor_auth_screen/doctor_signin_screen.dart';
import 'secretary_auth_screen/secretary_signin_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35
                  )),
                  const Text(
                  'What is your Career?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35
                  )),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  height: kToolbarHeight,
                  child: TextButton(
                    onPressed: (){
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onSurface),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                        FontAwesomeIcons.userDoctor ,
                        color: Theme.of(context).colorScheme.primary, 
                        size: 35),
                        const SizedBox(width: 10),
                        Text("I'm a Doctor", style: TextStyle(
                        fontSize: 30, 
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500
                      )),
                      ])
                    ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  height: kToolbarHeight,
                  child: TextButton(
                    onPressed: (){
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                        FontAwesomeIcons.userTie ,
                        color: Theme.of(context).colorScheme.onSurface, 
                        size: 35),
                        const SizedBox(width: 10),
                        Text("I'm a Secretary", style: TextStyle(
                        fontSize: 30, 
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500
                      )),
                      ])
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