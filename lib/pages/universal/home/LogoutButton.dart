import 'package:flutter/material.dart';
import 'package:swiring_app/dialogs/Dialogs.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () async => await showDialog(
            context: context,
            builder: (BuildContext context) => LogoutDialog()));
  }
}
