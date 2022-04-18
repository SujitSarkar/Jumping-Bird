import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({Key? key, required this.birdY}) : super(key: key);
  final double birdY;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0,birdY),
      child: Image.asset('assets/bird.gif',height: 50, width: 50),
    );
  }
}

