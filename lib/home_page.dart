import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jumping_bird/widget/bird.dart';
import 'package:jumping_bird/widget/darrier.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY=0.0;
  double initPos = birdY;
  double height=0;
  double time=0;
  double gravity= -4.5; // how strong the gravity is
  double velocity= 3; // how strong the jump is
  double birdWidth=0.1;
  double birdHeight=0.1;
  bool gameHasStarted = false;
  int score = 0;

  static List<double> barrierX=[2, 2 + 1.5];
  static double barrierWidth=0.5;
  static List<List<double>> barrierHeight=[
    [0.6,0.4],
    [0.4,0.6]
  ];

  void startGame(){
    gameHasStarted=true;
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      height = (gravity * time * time) + (velocity * time);
      setState(() {
        birdY = initPos - height;
      });
      if(birdIsDead()){
        timer.cancel();
        gameHasStarted= false;
        _showDialog();
      }
      moveMap();
      time += 0.01;

      setState(()=> score += 1);
    });
  }

  void moveMap(){
    for(int i =0; i<barrierX.length; i++){
      setState(() {
        barrierX[i] -= 0.005;
      });
      if(barrierX[i] < -1.5){
        barrierX[i] += 3;
      }
    }
  }

  void jump(){
    setState(() {
      time = 0;
      initPos = birdY;
    });
  }

  bool birdIsDead(){
    if(birdY < -1 || birdY > 1){
      return true;
    }

    for(int i =0; i<barrierX.length; i++){
      if(barrierX[i] <= birdWidth &&
        barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
           birdY + birdHeight >= 1 - barrierHeight[i][1])){
        return true;
      }
    }
    return false;
  }

  void resetGame(){
    Navigator.pop(context);
    setState(() {
      birdY=0;
      gameHasStarted=false;
      time=0;
      initPos=birdY;
      score=0;
    });
  }

  _showDialog(){
    showDialog(
      barrierDismissible: false,
        context: context, builder: (_)=>
        AlertDialog(
          scrollable: true,
          title: const Center(child: Text('G A M E  O V E R !!',style: TextStyle(color: Colors.orange))),
          content: Center(child: Column(
            children: [
              Text('SCORE: $score',style: const TextStyle(color: Colors.green,fontSize: 18)),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: resetGame, //resetGame,
                  child: const Text('PLAY AGAIN',style: TextStyle(color: Colors.white))),
            ],
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted? jump :startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(birdY: birdY),

                      MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false),

                      MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          isThisBottomBarrier: true),

                      MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false),

                      MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          isThisBottomBarrier: true),

                      if(!gameHasStarted) Container(
                          alignment: const Alignment(0, -0.5),
                          child: const Text('TAP  TO  PLAY',style: TextStyle(color: Colors.green,fontSize: 20))),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                alignment: const Alignment(0,0),
                color: Colors.brown,
                child:  Text('SCORE: $score',style: const TextStyle(color: Colors.white,fontSize: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
