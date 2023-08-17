import 'decor.dart';
import 'firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'usersettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classKey.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserProvider notifier, child) {
      return Scaffold(
          appBar: AppBar(title: const Text('Settings'), actions: <Widget>[

            GestureDetector(
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  await FirestoreService().googleSignOut();
                   // ignore: use_build_context_synchronously
                   Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 15),
                  child: Text('Logout', style: Decor.textStyler(20),),
                ))
          ]),
          body: Center(
              child: Column(children: [
            const Spacer(),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL!, frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                  //will display CircProgInd if phone is offline!
                  if (frame == null) {
                    return const CircularProgressIndicator();
                  } else {
                    return child;
                  } //is below necessary?
                }, loadingBuilder: (context, child, loadingProgress) {
                  //will display CircProgInd if image.network is not yet loaded!
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const CircularProgressIndicator();
                  }
                })),
            const SizedBox(
              height: 20,
            ),
            Text("${FirebaseAuth.instance.currentUser!.displayName}", style: Decor.textStyler(15)),
            const SizedBox(
              height: 20,
            ),
            Text("${FirebaseAuth.instance.currentUser!.email}",style: Decor.textStyler(15)),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () async {
                  notifier.isDark = !notifier.isDark;
                },
                child: Transform.scale(
                    scale: 2,
                    child: Icon(
                        notifier.isDark ? Icons.dark_mode : Icons.light_mode))),

            const SizedBox(
              height: 40,
            ),
            //textbox to edit and view classKey:
            ElevatedButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  setKey(context, barrierDismissible: true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Class Key', style: Decor.textStyler(25)),
                )),
            const Spacer(),
          ])));
    });
  }
}
