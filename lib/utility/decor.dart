import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Decor {
  //function to add border and rounded edges to our form
  static OutlineInputBorder inputformdeco() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(
          width: 1.0, color: Colors.blue, style: BorderStyle.solid),
    );
  }

//textstyle for changing size
  static TextStyle textStyler(double size) {
    return TextStyle(fontSize: size);
  }

//notification
  //custom notification logic
  static notification(
      {required String text,
      Color color = Colors.white,
      required context,
      double margin = 20}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(text),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
            //bottom: MediaQuery.of(context).size.height - 200, //(makes notifications appear from top)
            right: margin,
            left: margin),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: color,
      ));
  }

//popup box for how to play explanations
  static Future howToPlay(String text, context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('How to Play')]),
            content: Text(text)));
  }
  
//<><><><><><><><><><><><><><><><><><><><><><><><>
//              Confetti Logic!
//<><><><><><><><><><><><><><><><><><><><><><><><>

  static Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

class Confetter extends StatelessWidget {
  final ConfettiController controller;
  const Confetter({required this.controller, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: .05,
        maxBlastForce: 10, // set a lower max blast force
        minBlastForce: 2, // set a lower min blast force
        shouldLoop: false,
        numberOfParticles: 100, // a lot of particles at once
        gravity: .5,
      ),
    );
  }
}

class ScaledBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  const ScaledBox(
      {required this.child,
      required this.height,
      required this.width,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height, width: width, child: FittedBox(child: child));
  }
}

//wraps text in an auto expanding enclosure.
class TextWrapper extends StatelessWidget {
  final String text;
  const TextWrapper({Key? key, required this.text})
      : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      readOnly: true,
      initialValue: text,
      decoration: InputDecoration(
        enabledBorder: Decor.inputformdeco(),
        focusedBorder: Decor.inputformdeco(),
      ),
    );
  }
}
