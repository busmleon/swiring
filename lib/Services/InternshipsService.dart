import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiring_app/Entities/Internship.dart';

class InternshipsService {
  static Internship selectedInternship;

  static List<String> usedTags = new List();
  static List<String> unusedTags = new List();

  static List<DropdownMenuItem> unusedTagsItems = new List();

  static void removeFromSkillTagList(int index) {
    unusedTags.add(usedTags.elementAt(index));
    unusedTagsItems.add(new DropdownMenuItem(
      child: Text(usedTags.elementAt(index)),
      value: usedTags.elementAt(index),
    ));
    usedTags.removeAt(index);
  }

  static void addToSkillTagList(String s) {
    usedTags.add(s);
    //unusedSkillTagsList.remove(s);
    //setUnusedSkillTagsList();
  }

  static Future<bool> deleteInternship() async {
    try {
      await Firestore.instance
          .collection('placements')
          .document(selectedInternship.docId)
          .delete();
    } on Exception {
      return false;
    }
    return true;
  }
}
