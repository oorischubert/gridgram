// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class GridDot extends StatelessWidget {
  final List p1;
  final List p2;
  final List winner;
  final int index;
  final Function score;
  GridDot(this.p1, this.p2, this.index, this.score, this.winner, {Key? key})
      : super(key: key);
  double p1Width = 50;
  double p2Width = 50;
  @override
  Widget build(BuildContext context) {
    if (winner.contains(index)) {
      if (p1.contains(index)) {
        p1Width = 200;
      } else {
        p2Width = 200;
      }
    }
    if (p1.contains(index)) {
      return Container(
        height: p1Width,
        width: p1Width,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else if (p2.contains(index)) {
      return Container(
        height: p2Width,
        width: p2Width,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return InkWell(
          child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              )),
          onTap: () => score(index));
    }
  }
}
