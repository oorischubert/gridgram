import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utility/decor.dart';
import './grid.dart';
import './button.dart';
import './winner.dart';
import './textInput.dart';
import 'package:confetti/confetti.dart';

//import './titles.dart';

// to run on ios: flutter run --release (ios/Runner.xcworkspace)

class YaelApp extends StatefulWidget {
  const YaelApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _YaelAppState();
  }
}

class _YaelAppState extends State<YaelApp> {
  var player1Name = "Player 1";
  var player2Name = "Player 2";
  var winnerName = "null";
  var player = 1;
  var player1 = [];
  var player2 = [];
  var winnerCheck = [];
  var placeCheck = []; //created in initState!
  var xAxis = 9;
  var yAxis = 7;
  late ConfettiController _confettiController;

  @override
  //below function launcges initPlace on build of app!
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlace());
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void initPlace() {
    placeCheck = [];
    for (var i = 0; i < xAxis; i++) {
      placeCheck.add((xAxis * yAxis + i));
    }
  }

  void _updateScore(x) {
    if (winnerCheck.isEmpty) {
      setState(() {
        if (placeCheck.contains(x + xAxis)) {
          if (player == 1) {
            player1.add(x);
            player = 2;
            checkScore(player1, player1Name, x);
          } else {
            player2.add(x);
            player = 1;
            checkScore(player2, player2Name, x);
          }
          placeCheck.add(x);
        }
      });
    }
  }

  _editName(controller, x) {
    if (x == 1) {
      player1Name = "$controller";
    } else {
      player2Name = "$controller";
    }
  }

  _backSpace() {
    if (winnerName == "null" && placeCheck.length > xAxis) {
      setState(() {
        if (player == 2) {
          player1.removeLast();
          placeCheck.removeLast();
          player = 1;
        } else {
          player2.removeLast();
          placeCheck.removeLast();
          player = 2;
        }
      });
    }
  }

  void checkScore(list, player, x) {
    var betaCheck = [];
    var preCheck = [];
    bool betaChecker() {
      bool proof = false;
      for (var i = 0; i < (yAxis - 2); i++) {
        if ((betaCheck.contains(i * xAxis) ||
                betaCheck.contains((i + 1) * xAxis) ||
                betaCheck.contains((i + 2) * xAxis)) &&
            (betaCheck.contains(((i + 1) * xAxis) - 1) ||
                betaCheck.contains(((i + 2) * xAxis) - 1) ||
                betaCheck.contains(((i + 3) * xAxis) - 1))) {
          proof = true;
        }
      }
      return proof;
    }

    void check(y) {
      if (list.contains(x + y) &&
          list.contains(x + (2 * y)) &&
          (list.contains(x + (3 * y)) || list.contains(x - y))) {
        betaCheck = betaCheck + [x, x + y, x + (2 * y)];
        if (list.contains(x + (3 * y))) {
          betaCheck.add(x + (3 * y));
        }
        if (list.contains(x - y)) {
          betaCheck.add(x - y);
        }
        if (betaChecker()) {
          betaCheck = [];
        }
        preCheck = preCheck + betaCheck;
        betaCheck = [];
      }
    }

    check(1);
    check(-1);
    check(xAxis - 1);
    check(-xAxis - 1);
    check(xAxis);
    check(-xAxis);
    check(xAxis + 1);
    check(-xAxis + 1);

    if (preCheck.isNotEmpty) {
      setState(() {
        winnerCheck = preCheck;
        winnerName = player;
        if (!kIsWeb) {
            //if not web
            _confettiController.play();
          }
        //Decor.notification("hello", context); //add later?
      });
    }
  }

  void _resetGame() {
    setState(() {
      player = 1;
      player1 = [];
      player2 = [];
      winnerCheck = [];
      winnerName = "null";
      initPlace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Grammar Grid!",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                 Decor.howToPlay(
                    'This is an Explanation on how to play this game! It will be added later...',
                    context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: FittedBox(
                          child: Icon(
                        Icons.info_outline_rounded,
                      ))),
                ))
          ],
        ),
        body: Center(
            child: Column(children: [
          Confetter(controller: _confettiController),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            AddName(
              _editName,
              1,
              player1Name,
              player2Name,
            ),
            Button(text: "Reset", function: _resetGame, color: Colors.red[300]),
            Button(text: "Back", function: _backSpace, color: Colors.blue[300]),
            AddName(
              _editName,
              2,
              player1Name,
              player2Name,
            ),
          ]),
          Image.asset('images/horz.jpeg'),
          Row(children: [
            SizedBox(
                width: 75,
                height: 700,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset('images/vert.jpeg', scale: 1.4),
                )),
            SizedBox(
                width: 700,
                child: GridView.count(
                  // Create a grid with 9 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: xAxis,
                  childAspectRatio: 3 / 4,
                  shrinkWrap: true, // make grid take up only space it needs
                  physics:
                      const NeverScrollableScrollPhysics(), // make grid not scroll
                  // Generate 63 widgets that display their index in the List.
                  children: List.generate(63, (index) {
                    return Center(
                        child: GridDot(player1, player2, index, _updateScore,
                            winnerCheck));
                  }),
                )),
          ]),
          Winner(player1Name, player2Name, winnerName, player),
        ])));
  }
}
