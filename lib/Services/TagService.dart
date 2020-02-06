import 'package:cloud_firestore/cloud_firestore.dart';

import 'loginService.dart';

class TagService {
  static List<String> allSkillTags = new List();
  static List<String> unusedSkillTags = new List();
  static List<String> unusedInterestTags = new List();
  static Future<void> getAllTags() async {
    CollectionReference ref = Firestore.instance.collection('fl_content');
    QuerySnapshot tagQuery = await ref
        .where("_fl_meta_.schema", isEqualTo: 'addNewTags')
        .getDocuments();
    tagQuery.documents.forEach(
        (document) => allSkillTags.add(document['addNewTags'].toString()));
    generateUnusedSkillTags();
    generateUnusedInterestTags();
  }

  static Future<void> generateUnusedSkillTags() async {
    allSkillTags.forEach((tag) {
      if (!LoginService.appUser.getUsedSkillTags().contains(tag)) {
        unusedSkillTags.add(tag);
      }
    });
  }

  static Future<void> generateUnusedInterestTags() async {
    allSkillTags.forEach((tag) {
      if (!LoginService.appUser.getUsedInterestTags().contains(tag)) {
        unusedInterestTags.add(tag);
      }
    });
  }
}
