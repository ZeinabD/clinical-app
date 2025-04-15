import 'package:clinical/app_view.dart';
import 'package:clinical/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepo myUserRepo;
  const MyApp(this.myUserRepo, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationBloc(userRepo: myUserRepo),
      child: const MyAppView());
  }
}