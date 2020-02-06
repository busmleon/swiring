import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:swiring_app/dialogs/Dialogs.dart';

import 'package:flutter/services.dart';

import 'loginService.dart';

class UserService {
  static Future<void> createUserInFirebase(String _email, String _password,
      String _firstname, String _surname, BuildContext context) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      //auth.setLanguageCode('de-DE');
      // UserUpdateInfo userUpdate = new UserUpdateInfo();
      // userUpdate.displayName = _firstname + ' ' + _surname;
      // await result.user.updateProfile(userUpdate);
      result.user.sendEmailVerification();
      await Firestore.instance
          .collection('users')
          .document(_email.toLowerCase())
          .setData({
        'E-Mail': _email.toLowerCase(),
        'Firstname': _firstname,
        'Surname': _surname,
        'Role': "student",
        'ImageUrl': '',
        'Location': 'Deutschland',
        'UsedInterestTags': new List<String>(),
        'UsedSkillTags': new List<String>(),
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) => VerifyEmailDialog());
      Navigator.pop(context);
    } on PlatformException catch (p) {
      switch (p.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  UserAlreadyExistsDialog(_email));
          //setState(() => _isLoading = false);
          break;
        default:
          await showDialog(
              context: context,
              builder: (BuildContext context) => UnknownErrorDialog());
          //setState(() => _isLoading = false);
          break;
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => UnknownErrorDialog());
      //setState(() => _isLoading = false);
    }
  }

  static Future<void> changePassword(
      BuildContext context, String newPassword, String oldPassword) async {
    try {
      await LoginService.fb.signInWithEmailAndPassword(
          email: LoginService.appUser.getEmail(), password: oldPassword);
    } on PlatformException catch (p) {
      switch (p.code) {
        case 'ERROR_WRONG_PASSWORD':
          await showDialog(
              context: context,
              builder: (BuildContext context) => WrongCredentialsDialog());
          break;
        default:
          await showDialog(
              context: context,
              builder: (BuildContext context) => UnknownErrorDialog());
          break;
      }
    }

    // Änderung des PWs
    var user = await LoginService.fb.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(
        email: user.email, password: newPassword);
    user.updatePassword(newPassword).then((function) {
      user.reauthenticateWithCredential(credential).catchError(() {
        print("Fehler beim erneuten einloggen!");
        LoginService.logOut(context);
      });
    });
  }

  static Future<void> uploadImage(File _image) async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/' +
            LoginService.appUser.getEmail().split('@')[0] +
            '.png');
    StorageUploadTask task = firebaseStorageRef.putFile(_image);
    String profilePictureUrl =
        await (await task.onComplete).ref.getDownloadURL();
    await Firestore.instance
        .collection('users')
        .document(LoginService.appUser.getEmail())
        .updateData({'ImageUrl': profilePictureUrl});
    LoginService.appUser.setNetworkImage(NetworkImage(profilePictureUrl));
  }

  static Future<void> writeToUserDocument(String key, Object value) async {
    await Firestore.instance
        .collection('users')
        .document(LoginService.appUser.getEmail())
        .updateData({key: value});
  }

  static Future<void> writeProfileToFirebase(String selectedLocation,
      List<String> chosenSkillTags, List<String> usedInterestTags) async {
    await Firestore.instance
        .collection('users')
        .document(LoginService.appUser.getEmail())
        .updateData({
      'Location': selectedLocation,
      'UsedSkillTags': chosenSkillTags,
      'UsedInterestTags': LoginService.appUser.getUsedInterestTags()
    });
  }
}
