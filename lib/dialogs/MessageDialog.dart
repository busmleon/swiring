import 'package:flutter/material.dart';

import 'Messages.dart';

class MessageDialog extends StatelessWidget {
  final Message message;
  final List<Widget> actions;
  MessageDialog(this.message, this.actions);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message.title),
      content: Text(message.content),
      actions: actions,
    );
  }
}