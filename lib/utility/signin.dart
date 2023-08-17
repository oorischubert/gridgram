import 'firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            //scale image by half
            Transform.scale(
                scale: 0.5,
                child: Image.asset(
                    'ios/Runner/Assets.xcassets/Appicon.appiconset/1024.png')),
            const Spacer(),
            ElevatedButton.icon(
                icon:
                    const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  FirestoreService().signInWithGoogle();
                },
                label: const Text('Sign in with Google')),
            const Spacer()
          ],
        ));
  }
}
