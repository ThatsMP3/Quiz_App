/*
  Presotto Matteo
  5_CIA
  14/02/2022
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/result.dart';
import './textdisplay.dart';
import './button.dart';
import 'question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presotto Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Presotto Quiz App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample url:
  final baseurl = "https://opentdb.com/api.php?amount=10";

  List<Question>? _questions = null; // questions data structure
  List<String>? _answers = null; // answers list
  List<int> _answered = [];
  var _index = 0;
  var _correct_answer = 0;

  // Go to next question:
  void next() {
    if (_questions == null || _questions!.length == 0) return;
    setState(() {
      if (_index < _questions!.length - 1)
        _index++;
      else
        _index = 0;
      // update answers:
      _answers = List.from(_questions![_index].incorrect);
      _answers!.add(_questions![_index].correct);
      _answers!.shuffle();
    });
  }

  // Get data
  void doGet() {
    http.get(Uri.parse(baseurl)).then((response) {
      var jsondata = json.decode(response.body);
      var questions = jsondata['results'];
      // create data structure with questions
      setState(() {
        _questions =
            questions.map<Question>((val) => Question.fromJson(val)).toList();
        // initialize answer list:
        _answers = List.from(_questions![_index].incorrect);
        _answers!.add(_questions![_index].correct);
        _answers!.shuffle();
      });

      // debug
      print("First question: " + questions[0]['question']);
      print("First question: " + questions[0]['correct_answer']);
      print("category: " + questions[0]['category']);
    });
  }

  void reset() {
    setState(() {
      _questions = null; // questions data structure
      _answers = null; // answers list
      _index = 0;
      _correct_answer = 0;
    });
    doGet();
  }

  // Check if the answer is correct and display an AlertDialog:
  void _checkAnswer(String ans) {
    String msg =
        "Sorry, but the correct answer was " + _questions![_index].correct;

    if (ans == _questions![_index].correct) {
      msg = "Congratulation! The correct answer was " +
          _questions![_index].correct;
      if (!_answered.contains(_index)) {
        _correct_answer++;
      }
    }

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Result'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                    autofocus: true,
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                      next();
                      if (_index == 9) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResultsRoute(
                              rightAnswers: _correct_answer,
                            ),
                          ),
                        );
                        doGet();
                      }
                    })
              ],
            ));
  }

  // Return a list of buttons with the answers to put in the screen:
  List<Widget> _buildAnswerButtons(List<String> ans) {
    return ans
        .map<Button>((e) => Button(
            selectHandler: () => _checkAnswer(e),
            buttonText: e,
            color: Colors.orange))
        .toList();
  }

  // Load data from Open Trivia DB at the beginning:
  void initState() {
    doGet();
    //assert(_debugLifecycleState == _StateLifecycle.created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),

          TextDisplay(
            (_questions != null && _questions![0] != null)
                ? _questions![_index].question
                : 'none',
          ),
          if (_answers != null && _buildAnswerButtons(_answers!) != null)
            ..._buildAnswerButtons(_answers!)
          else
            const CircularProgressIndicator(), //Text('Load Quiz!'),

          const SizedBox(
            height: 50.0,
          ),
          Button(selectHandler: next, buttonText: 'next'),
          Button(selectHandler: reset, buttonText: 'reload'),
        ],
      ),
    );
  }
}
