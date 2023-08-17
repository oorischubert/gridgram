// ignore_for_file: non_constant_identifier_names

import 'utility/usersettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utility/homepicker.dart';
// Firebase Imports:
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSettings.init(); //getting user settings when app Boots up!
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: Consumer(builder: (context, UserProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GridGram', //change?
            theme: ThemeData(
                brightness:
                    notifier.isDark ? Brightness.dark : Brightness.light),
            home: HomePicker(),
          );
        }));
  }
}


