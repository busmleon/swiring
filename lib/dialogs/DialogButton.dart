import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final Function function;
  DialogButton(this.text, this.function);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      color: Color.fromRGBO(0, 102, 161, 1.0),
      child: Text(text),
      onPressed: function,
    );
  }
}
