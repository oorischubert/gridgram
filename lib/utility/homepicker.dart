import 'firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import 'signin.dart';

class HomePicker extends StatelessWidget {
  HomePicker({Key? key}) : super(key: key);
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("ERROR: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          firestoreService.setUserId();
          return const HomePage();
        } else {
          return const SignIn();
        }
      },
    ));
  }
}
