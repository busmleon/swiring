import 'package:flutter/cupertino.dart';
import 'Mentor.dart';

class Internship {
  String docId;
  String title;
  String location;
  DateTime start;
  DateTime end;
  String description;
  List<String> tags;
  String imageUrl;
  AssetImage assetImage;
  NetworkImage networkImage;
  Mentor mentor;
  Internship(
      {this.docId,
      @required this.title,
      @required this.location,
      @required this.start,
      @required this.end,
      @required this.description,
      @required this.tags,
      @required this.imageUrl,
      @required this.mentor}) {
    if (this.imageUrl == '') {
      assetImage = AssetImage('assets/images/default_avatar.png');
    } else {
      networkImage = NetworkImage(this.imageUrl);
    }
  }
  String getDocId()=>this.docId;
  String getTitle() => this.title;
  String getLocation() => this.location;
  DateTime getStart() => this.start;
  DateTime getEnd() => this.end;
  String getDescription() => this.description;
  List<String> getTags() => this.tags;
  AssetImage getAssetImage() => this.assetImage;
  NetworkImage getNetworkImage() => this.networkImage;
  Mentor getMentor() => this.mentor;
}
