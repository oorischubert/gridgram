import 'package:flutter/material.dart';

class AddName extends StatelessWidget {
  final Function editName;
  final int playerNum;
  final String player1Name;
  final String player2Name;
  AddName(this.editName, this.playerNum, this.player1Name, this.player2Name,
      {Key? key})
      : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (playerNum == 1) {
      return Container(
          height: 35,
          width: 150,
          color: Colors.red,
          child: TextField(
            controller: _controller,
            obscureText: false,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: player1Name,
            ),
            onChanged: (String value) async {
              await editName(_controller.text, playerNum);
            },
          ));
    } else {
      return Container(
          height: 35,
          width: 150,
          color: Colors.blue,
          child: TextField(
              controller: _controller,
              obscureText: false,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: player2Name,
              ),
              onChanged: (String value) async {
                await editName(_controller.text, playerNum);
              }));
    }
  }
}
