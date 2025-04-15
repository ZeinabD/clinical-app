import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/blocs/signout_bloc/signout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorHomeScreen extends StatefulWidget {
  final String doctorId;
  const DoctorHomeScreen(this.doctorId, {super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user?.name ?? 'unknown'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SignoutBloc>().add(const SignoutRequired());
                },
                icon: const Icon(Icons.logout, size: 50)),
            ],
          ),
        );
      }
    );
  }
}