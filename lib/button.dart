/*
  Presotto Matteo
  5_CIA
  14/02/2022
*/
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as htmlParser; // to print html chars

class Button extends StatelessWidget {
  final Function() selectHandler;
  final String buttonText;
  final Color color;

  Button(
      {required this.selectHandler,
      required this.buttonText,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: RawMaterialButton(
        elevation: 1.0,
        fillColor: this.color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        child: Text(
          htmlParser.DocumentFragment.html(buttonText).text.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: selectHandler,
      ),
    );
  }
}
