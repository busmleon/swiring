import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiring_app/Services/InternshipsService.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:swiring_app/dialogs/DialogButton.dart';
import 'package:swiring_app/pages/universal/login/LoginPage.dart';

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

class EmailNotVerifiedDialog extends StatelessWidget {
  final FirebaseAuth auth;
  final AuthResult result;
  EmailNotVerifiedDialog(this.auth, this.result);
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(
      DialogButton(
        'Send again',
        () async {
          Navigator.of(context).pop();
          result.user.sendEmailVerification();
          auth.signOut();

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return VerifyEmailDialog();
            },
          );
        },
      ),
    );
    actions.add(DialogButton('Close', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.emailNotVerifiedMessage, actions);
  }
}

class UserAlreadyExistsDialog extends StatelessWidget {
  final String _email;
  UserAlreadyExistsDialog(this._email);
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(
      DialogButton(
        'Reset password',
        () async {
          Navigator.of(context).pop();
          FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return PasswordResetedDialog();
            },
          );
        },
      ),
    );
    actions.add(DialogButton('Close', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.userAlreadyExistsMessage, actions);
  }
}

class PasswordResetedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Close', () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }));

    return MessageDialog(Messages.passwordResetedMessage, actions);
  }
}

class WrongCredentialsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Close', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.wrongCredentialsMessage, actions);
  }
}

class UnknownErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Close', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.unknownErrorMessage, actions);
  }
}

class VerifyEmailDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Close', () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }));
    return MessageDialog(Messages.emailVerificationMessage, actions);
  }
}

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Sign out', () async {
      await LoginService.logOut(context);
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      LoginService.appUser = null;
    }));
    actions.add(DialogButton('Cancel', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.logoutMessage, actions);
  }
}

class DeleteInternshipDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = new List<Widget>();
    actions.add(DialogButton('Yes', () async {
      print("Delete internship");
      if (await InternshipsService.deleteInternship()) {
        InternshipsService.selectedInternship = null;
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }));
    actions.add(DialogButton('No', () => Navigator.of(context).pop()));
    return MessageDialog(Messages.deleteInternshipMessage, actions);
  }
}
