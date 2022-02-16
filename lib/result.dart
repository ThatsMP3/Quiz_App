/*
  Presotto Matteo
  5_CIA
  14/02/2022
*/
import 'package:flutter/material.dart';

class ResultsRoute extends StatelessWidget {
  final int rightAnswers;

  ResultsRoute({required int this.rightAnswers});

  @override
  Widget build(BuildContext context) {
    String points = this.rightAnswers.toString() + "/ 10";
    String msg = "Your score is: ";
    String msg2 = "Better luck next time...";

    if (this.rightAnswers >= 6) {
      msg = "Congratulation your score is: ";
      msg2 = "Keep up!";
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  msg + "\n\n" + points + "\n\n\n" + msg2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
