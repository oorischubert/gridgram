import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utility/decor.dart';
import '../utility/firestore.dart';

class VerbGame extends StatefulWidget {
  const VerbGame({Key? key}) : super(key: key);

  @override
  State<VerbGame> createState() => _VerbGameState();
}

class _VerbGameState extends State<VerbGame> {
  bool isLoaded = false;
  bool correctAnswer = false;
  double increment = 0;
  final VerbData _verbData = VerbData();
  late List questions;
  late int totalQuests;
  int question = 0;
  bool wrongAnswer = false;
  late Color questionColor;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    //Get question data from api!
    getData();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future getData() async {
    questions = await _verbData.getData();
    if (questions.isNotEmpty) {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  wrongAnswerState(Color color) {
    questionColor = color;
    if (mounted) {
      setState(() {
        wrongAnswer = true;
      });
    }
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          wrongAnswer = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verb Game"),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Decor.howToPlay(
                    'Pick the correct verb for each sentence.', context);
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
      body: isLoaded
          ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Confetter(controller: _confettiController),
              SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: increment,
                  )),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      question = 0;
                      increment = 0;
                    });
                  },
                  child: const Text('Restart')),
              const Spacer(),
              Text(
                VerbData.questions[question]['sentence'],
                style: wrongAnswer
                    ? TextStyle(fontSize: 30, color: questionColor)
                    : Decor.textStyler(30),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0;
                      i < VerbData.questions[question]['words'].length;
                      i++)
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (VerbData.questions[question]['words'][i] ==
                                VerbData.questions[question]['answer']) {
                              if (increment <= 1 && !correctAnswer) {
                                increment += 1 / questions.length;
                              }
                              if (increment == 1) {
                                if (!kIsWeb) {
                                  //if not web
                                  _confettiController.play();
                                }
                              }
                              Decor.notification(
                                 text: "Correct!", color: Colors.green, context: context);
                              wrongAnswerState(Colors.green);
                              correctAnswer = true;
                            } else {
                              wrongAnswerState(Colors.red);
                              Decor.notification(
                                  text: "Try Again!", color: Colors.red, context: context);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text(VerbData.questions[question]['words'][i])),
                ],
              ),
              const Spacer(),
              correctAnswer
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          correctAnswer = false;
                          if (question < questions.length - 1) {
                            question += 1;
                          }
                        });
                      },
                      child: Text('Next Sentence', style: Decor.textStyler(20)))
                  : Container(),
              const Spacer(),
            ])
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Transform.scale(
                    scale: 4, child: const CircularProgressIndicator())
              ])
            ]),
    );
  }
}
