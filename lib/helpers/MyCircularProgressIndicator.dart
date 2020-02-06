import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  final String text;
  MyCircularProgressIndicator(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(0.87)),
          ),
        ],
      ),
    );
  }
}
