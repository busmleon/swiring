import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static List<String> allLocations = new List();
  static Future<void> loadAllLocations() async {
    allLocations.clear();
    CollectionReference ref = Firestore.instance.collection('fl_content');
    QuerySnapshot locationQuery = await ref
        .where("_fl_meta_.schema", isEqualTo: 'addLocation')
        .getDocuments();
    locationQuery.documents.forEach(
        (document) async => allLocations.add(await document['addLocation']));
  }
}
