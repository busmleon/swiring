import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiring_app/Services/LocationService.dart';
import 'package:swiring_app/Services/TagService.dart';
import 'package:swiring_app/dialogs/Dialogs.dart';
import 'package:swiring_app/pages/universal/home/HomePage.dart';
import '../Entities/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'LocationService.dart';

class LoginService {
  static AppUser appUser;
  static FirebaseAuth fb = FirebaseAuth.instance;
  static Future<void> login(
      BuildContext context, String _email, String _password) async {
    try {
      AuthResult result = await fb.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (!result.user.isEmailVerified) {
        await showDialog(
            context: context,
            builder: (BuildContext context) =>
                EmailNotVerifiedDialog(fb, result));
        return;
      }
      await _loadCurrentUser(result.user.email);
      await _load();
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } on PlatformException catch (p) {
      switch (p.code) {
        case 'ERROR_USER_NOT_FOUND':
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_INVALID_EMAIL':
          await showDialog(
              context: context,
              builder: (BuildContext context) => WrongCredentialsDialog());
          break;
        default:
          await showDialog(
              context: context,
              builder: (BuildContext context) => UnknownErrorDialog());
          print(p.code);
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> logOut(BuildContext context) async {
    try {
      await fb.signOut();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => UnknownErrorDialog());
    }
  }

  static Future<void> _loadCurrentUser(String email) async {
    DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(email.toLowerCase())
        .get();
    List<String> usedSkillTagsString = new List();
    usedSkillTagsString.add("");
    List<String> usedInterestTagsString = new List();
    usedInterestTagsString.add("");
    // try {
    if (userDoc.data['Role'] == "student") {
      List<dynamic> usedSkillTagsDynamic = new List();
      usedSkillTagsDynamic = await userDoc.data['UsedSkillTags'];

      usedSkillTagsDynamic
          .forEach((element) => usedSkillTagsString.add(element.toString()));
      List<dynamic> usedInterestTagsDynamic = new List();
      usedInterestTagsDynamic = await userDoc.data['UsedInterestTags'];

      usedInterestTagsDynamic
          .forEach((element) => usedInterestTagsString.add(element.toString()));
    }
    LoginService.appUser = AppUser(
      location: userDoc.data['Location'],
      imageUrl:
          userDoc.data['Role'] == "student" ? userDoc.data['ImageUrl'] : "",
      firstname: userDoc.data['Firstname'],
      surname: userDoc.data['Surname'],
      email: userDoc.data['E-Mail'].toString().toLowerCase(),
      role: userDoc.data['Role'],
      usedSkillTags: usedSkillTagsString,
      usedInterestTags: usedInterestTagsString,
    );
    print("*******" + appUser.getUsedSkillTags().length.toString());
    // } on NoSuchMethodError {
    //   LoginService.appUser = AppUser(
    //       location: userDoc.data['Location'],
    //       imageUrl:
    //           userDoc.data['Role'] == "student" ? userDoc.data['ImageUrl'] : "",
    //       firstname: userDoc.data['Firstname'],
    //       surname: userDoc.data['Surname'],
    //       email: userDoc.data['E-Mail'].toString().toLowerCase(),
    //       role: userDoc.data['Role'],
    //       usedSkillTags: new List(),
    //       usedInterestTags: new List());
    // }
  }

  static Future<void> _load() async {
    await LocationService.loadAllLocations();
    await TagService.getAllTags();
    await TagService.generateUnusedSkillTags();
    await TagService.generateUnusedInterestTags();
    // await TagService.generateUnusedSkillTags();
    // await TagService.generateUnusedInterestTags();
  }
}
