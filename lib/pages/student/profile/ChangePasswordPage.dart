import 'package:flutter/material.dart';
import 'package:swiring_app/Services/UserService.dart';
import 'package:swiring_app/dialogs/DialogButton.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);

  String oldPW = "";
  String password = "";
  String passwordConfirmation = "";
  String s = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Fields in Dialog
          children: <Widget>[
            // current password
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    'current password',
                    style: TextStyle(color: atosBlue),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    validator: (value) {
                      oldPW = value;
                      return value.isEmpty ? 'Current Password is empty' : null;
                    },
                    onSaved: (text) {
                      return () {
                        oldPW = text;
                      };
                    },
                    obscureText: true,
                  ),
                ),
              ],
            ),
            // new password
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    'new password',
                    style: TextStyle(color: atosBlue),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    validator: (value) {
                      password = value;
                      return value.length < 8 ? 'Password is too short' : null;
                    },
                    onSaved: (text) {
                      return () {
                        password = text;
                      };
                    },
                    obscureText: true,
                  ),
                ),
              ],
            ),
            // new password confirmation
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    'new password',
                    style: TextStyle(color: atosBlue),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    validator: (value) {
                      passwordConfirmation = value;
                      return value != password
                          ? 'Passwords do not match'
                          : null;
                    },
                    onSaved: (text) => passwordConfirmation = text,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // buttons
      actions: <Widget>[
        // cancel button
        DialogButton('Cancel', () {
          Navigator.of(context).pop();
        }),
        // save button
        DialogButton('Save', () async {
          await savePW();
          // only close dialog, if input values are valid
          if (s == "valid") {
            Navigator.of(context).pop();
          }
        })
      ],
    );
  }

  Future savePW() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await UserService.changePassword(context, password, oldPW);
      s = "valid";
      print("if");
      print(s);
    } else {
      s = "not_valid";
      print("else");
      print(s);
    }

    // for debugging purposes
    print("savePW");
  }
}
