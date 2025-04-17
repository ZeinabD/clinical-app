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
            apiKey: "AIzaSyCT7tNgtARcv--0hxIrLMAPwK64hb6bZWc",
            appId: "1:270140547194:android:7c1d41e6b58b0a82b6dbc3",
            messagingSenderId: "270140547194",
            projectId: "clinical-app-131c5",
          ),
        )
      : await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
