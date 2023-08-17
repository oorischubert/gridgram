import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'usersettings.dart';
import 'package:provider/provider.dart';
import 'decor.dart';
import 'dart:math'; //for class key generation

Future setKey(BuildContext context,
    {required bool barrierDismissible}) async {
  String uid = UserSettings.getClassKey(); //reset uid
  showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) =>
          Consumer(builder: (context, UserProvider notifier, child) {
            return AlertDialog(
              title: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: uid));
                        Decor.notification(
                            text: 'Class key copied to clipboard!',
                            context: context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text('Class Key'),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                   const SizedBox(height: 25),
                  TextFormField(
                    initialValue: notifier.classKey,
                    decoration: InputDecoration(
                      labelText: 'Class Key:',
                      enabledBorder: Decor.inputformdeco(),
                      focusedBorder: Decor.inputformdeco(),
                    ),
                    onChanged: (value) {
                      uid = value.trim();
                    },
                  ),
                  
                ],
              ),
              actions: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      onPressed: () {
                        if (uid != "" && uid != notifier.classKey) {
                          notifier.classKey = uid;
                          //
                        }
                        if (uid != "") {
                          Navigator.pop(context);
                        }
                        if (uid == "") {
                          Decor.notification(
                              text: 'Please input class key!',
                              context: context);
                        }
                      },
                      child: Text('Save', style:  Decor.textStyler(20),)),
                ]),
              ],
            );
          }));
}

// generates a new class key
String createClassKey() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}


