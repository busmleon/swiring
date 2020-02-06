import 'package:flutter/material.dart';

class Mentor {
  String name, mail, circuit;
  Mentor({
    @required this.name,
    @required this.mail,
    @required this.circuit,
  });
  String getName() => name;
  String getMail() => mail;
  String getCircuit() => circuit;
}
