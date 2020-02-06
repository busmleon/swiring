import 'package:flutter/cupertino.dart';
import 'Mentor.dart';

class Department {
  String departmentName;
  String division;
  String description;
  List<String> tags;
  Mentor mentor;
  Department(
      {@required this.departmentName,
      @required this.division,
      @required this.description,
      @required this.tags,
      @required this.mentor});

  String getTitle() => this.departmentName;
  String getLocation() => this.division;
  String getDescription() => this.getDescription();
  List<String> getTags() => this.tags;
  Mentor getMentor() => this.mentor;
}
