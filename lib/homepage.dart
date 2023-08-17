import 'package:flutter/material.dart';
import 'package:gridgram/findmistakes/findmistakes.dart';
import 'package:provider/provider.dart';
import 'Verb Game/verbgame.dart';
import 'gridgram/gridgram.dart';
import 'utility/usersettings.dart';
import 'utility/settingspage.dart';
import 'utility/classKey.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //app state observer

    (UserSettings.getClassKey() == '')
        ?
        //does only after widgets are built!
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setKey(context, barrierDismissible: false))
        : null; //must get led's current state from server on init!!!
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserProvider notifier, child) {
      return Scaffold(
          appBar: AppBar(
              title: const Text("Yael's Games"),
              //add settimgs icon whoch links to settings page:
              actions: <Widget>[
                Transform.scale(scale: 1.5, child:
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.settings),
                    )))
              ]),
          body: Center(
              child: Column(children: [
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const YaelApp()));
                },
                child: const Text('GramGrid')),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const VerbGame()));
                },
                child: const Text('Verb Game')),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FindMistakes()));
                },
                child: const Text('Mistakes Game')),
            const Spacer()
          ])));
    });
  }
}
