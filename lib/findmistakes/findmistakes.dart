import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utility/firestore.dart';
import '../utility/decor.dart';
//import 'openai.dart';

class FindMistakes extends StatefulWidget {
  const FindMistakes({Key? key}) : super(key: key);

  @override
  State<FindMistakes> createState() => _FindMistakesState();
}

class _FindMistakesState extends State<FindMistakes> {
  final SentenceData _sentenceData = SentenceData();
  bool isLoaded = false; //controls loading screen
  bool correctAnswer = false;
  bool wrongAnswer = false;
  int sentenceNum = 0; //which sentence we are on
  int mistakes = 0; //shows number of mistakes on screem
  double increment = 0; //progress indicator increment
  late int totalSents; //# of sentences
  late String currentSent; //current sentence
  late List sentences;
  late TextEditingController _textController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    //Get sentence data from api!
    getData();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future getData() async {
    sentences = await _sentenceData.getData();
    if (sentences.isNotEmpty) {
      _textController = TextEditingController(text: sentences[0]['incorrect']);
      totalSents = sentences.length;
      currentSent = sentences[sentenceNum]['incorrect'];
      _sentChecker(0, currentSent);
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  wrongAnswerState() {
    if (mounted) {
      setState(() {
        wrongAnswer = true;
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          wrongAnswer = false;
        });
      }
    });
  }

  _sentChecker(int num, String text) {
    int newMistakes = 0;
    late List currentSent;
    late List correctList;
    currentSent = text.trim().split(RegExp(r'\s+'));
    correctList = sentences[num]['correct'].trim().split(RegExp(r'\s+'));
    for (int i = 0; i < correctList.length; i++) {
      if (currentSent[i] != correctList[i]) {
        newMistakes += 1;
      }
    }
    if (newMistakes != 0) {
      setState(() {
        mistakes = newMistakes;
        correctAnswer = false;
      });
      wrongAnswerState();
    } else {
      setState(() {
        mistakes = 0;
        if (increment < 1 && !correctAnswer) {
          increment += 1 / totalSents;
        }
        if (increment == 1) {
          if (!kIsWeb) {
            //if not web
            _confettiController.play();
          }
        }
        correctAnswer = true;
      });
      Decor.notification(text: 'Good Job!', color: Colors.green, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Mistakes!'),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Decor.howToPlay(
                    'Find and fix the mistakes in each sentence!',
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
      body: isLoaded
          ? Column(children: [
              Confetter(controller: _confettiController),
              SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: increment,
                  )),
              const Spacer(),
              const Spacer(),
              wrongAnswer
                  ? Text(
                      mistakes == 1
                          ? '$mistakes mistake'
                          : '$mistakes mistakes',
                      style: const TextStyle(fontSize: 30, color: Colors.red))
                  : Text(
                      mistakes == 1
                          ? '$mistakes mistake'
                          : '$mistakes mistakes',
                      style: Decor.textStyler(30)),
              Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: TextFormField(
                    readOnly: correctAnswer,
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Find the Mistake!:',
                      enabledBorder: Decor.inputformdeco(),
                      focusedBorder: Decor.inputformdeco(),
                    ),
                    onChanged: (value) {
                      currentSent = value.trim();
                    },
                  )),
              ElevatedButton(
                  onPressed: () {
                    _sentChecker(sentenceNum, currentSent);
                    //Controller.getApiRequest(
                    //    answer: currentSent, correct: sentences[sentenceNum]['correct']);
                  },
                  child: const Text('Check')),
              const Spacer(),
              correctAnswer
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          correctAnswer = false;
                          if (sentenceNum < sentences.length - 1) {
                            sentenceNum += 1;
                          }
                          _textController.clear();
                          _textController = TextEditingController(
                              text: sentences[sentenceNum]['incorrect']);
                        });
                        _sentChecker(
                            sentenceNum, sentences[sentenceNum]['incorrect']);
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
