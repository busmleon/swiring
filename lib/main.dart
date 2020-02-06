import 'package:flutter/material.dart';
import 'package:swiring_app/pages/universal/login/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: MyTheme.buildThemeData(),
      home: LoginPage(),
      theme: ThemeData(
        colorScheme: myColorScheme(),
        textTheme: myTextTheme(),
        iconTheme: myIconThemeData(),
      ),
    );
  }

  static Color getAtosBlue() {
    return Color.fromRGBO(0, 102, 161, 1.0);
  }

  static Color getAtosLightBlue() {
    return Color.fromRGBO(0, 175, 216, 1.0);
  }

  static ColorScheme myColorScheme() => ColorScheme(
        primary: getAtosBlue(),
        primaryVariant: getAtosLightBlue(),
        onPrimary: Colors.white,
        secondary: Colors.black,
        secondaryVariant: Colors.grey[500],
        onSecondary: Colors.white,
        surface: getAtosLightBlue(),
        onSurface: getAtosBlue(),
        background: Colors.white,
        onBackground: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        brightness: Brightness.light,
      );

  // static ColorScheme myColorScheme() => ColorScheme(
  //       primary: Colors.red,
  //       primaryVariant: Colors.redAccent,
  //       onPrimary: Colors.white,
  //       secondary: Colors.green,
  //       secondaryVariant: Colors.greenAccent,
  //       onSecondary: Colors.white,
  //       surface: Colors.orange,
  //       onSurface: Colors.orangeAccent,
  //       background: Colors.purple,
  //       onBackground: Colors.purpleAccent,
  //       error: Colors.red,
  //       onError: Colors.white,
  //       brightness: Brightness.light,
  //     );

  static TextTheme myTextTheme() => TextTheme(
        display1: TextStyle(
            fontSize: 35.0,
            fontFamily: 'Verdana',
            color: myColorScheme().primary),
        headline: TextStyle(
            fontSize: 35.0,
            fontFamily: 'Verdana',
            fontWeight: FontWeight.bold,
            color: myColorScheme().primary),
        display2: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Verdana',
            color: myColorScheme().primary),
        display4: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Verdana',
            color: myColorScheme().secondary),
        display3: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Verdana',
            color: myColorScheme().secondary),
        body1: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Verdana',
            color: myColorScheme().primary),
        button: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Verdana',
            color: myColorScheme().secondary),
      );

  static InputDecorationTheme myInputDecorationTheme() => InputDecorationTheme(
        focusColor: myColorScheme().primary,
      );

  static IconThemeData myIconThemeData() => IconThemeData(
        color: myColorScheme().primary,
        opacity: 1,
        size: 50.0,
      );

}
