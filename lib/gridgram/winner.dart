import 'package:flutter/material.dart';

class Winner extends StatelessWidget {
  final String p1;
  final String p2;
  final String winnerName;
  final int playerTurn;
  const Winner(this.p1, this.p2, this.winnerName, this.playerTurn, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (winnerName == p1 || winnerName == p2) {
      return Container(
          height: 75,
          width: 900,
          color: Colors.yellow,
          child: Center(
              child: Text('$winnerName wins!',
                  style: const TextStyle(fontSize: 40, color: Colors.black))));
    } else if (playerTurn == 1) {
      return Container(
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Container(
          height: 70,
          width: 75,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ));
    }
  }
}
