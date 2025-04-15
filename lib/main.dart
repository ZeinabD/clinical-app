import 'dart:io';
import 'package:clinical/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clinical/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyD3gjMG9UjGE03m8RfIfA-y4BJHucoB8Ac",
            appId: "1:641114884597:android:43ec6b9ff4cda29ce778bc",
            messagingSenderId: "641114884597",
            projectId: "clinical-app-2ae62",
          ),
        )
      : await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
