import 'package:clinical/auth/screens/welcome_screen.dart';
import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/doctor_home_screen/screens/doctor_home_screen.dart';
import 'package:clinical/models/doctor.dart';
import 'package:clinical/models/secretary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'home/secretary_home_screen/screens/secretary_home_screen.dart';
import 'home/blocs/signout_bloc/signout_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: Color(0xFF6D6D88),
          primary: Color(0xFFFB9F9F),
          secondary: Color.fromARGB(255, 251, 241, 193),
          tertiary: Color(0xFF463B4C),
          outline: Color(0xFFB5B682),
          error: Colors.red)),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated){
            if (state.myUser is Secretary){
              Secretary secretary = state.myUser as Secretary;
              return MultiBlocProvider(
                providers: [
                  BlocProvider<MyUserBloc>(
                    create: (context) => MyUserBloc(context.read<AuthenticationBloc>().userRepo)
                      ..add(GetMyUser(state.myUser!.uid))),

                  BlocProvider<SignoutBloc>(
                    create: (context) => SignoutBloc(context.read<AuthenticationBloc>().userRepo)),
                ], 
                child: SecretaryHomeScreen(secretaryId: secretary.uid));
            }else if(state.myUser is Doctor){
              Doctor doctor = state.myUser as Doctor;
              return MultiBlocProvider(
                providers: [
                  BlocProvider<MyUserBloc>(
                    create: (context) => MyUserBloc(context.read<AuthenticationBloc>().userRepo)
                      ..add(GetMyUser(state.myUser!.uid))),
                  BlocProvider<SignoutBloc>(
                    create: (context) => SignoutBloc(context.read<AuthenticationBloc>().userRepo)),
                ], 
                child: DoctorHomeScreen(doctor.uid));
            }else{
              return const CircularProgressIndicator();
            }
          }else{
            return const WelcomeScreen();
          }
        }),
    );
  }
}
