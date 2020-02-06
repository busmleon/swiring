import 'package:flutter/cupertino.dart';

class AppUser {
  String userId;
  String firstname;
  String surname;
  String location;
  String role;
  String email;
  String imageUrl;
  NetworkImage imageNetwork;
  AssetImage imageAsset;
  List<String> usedSkillTags = new List();
  List<String> usedInterestTags;

  AppUser(
      {@required this.firstname,
      @required this.surname,
      @required this.imageUrl,
      @required this.email,
      @required this.role,
      @required this.location,
      @required this.usedSkillTags,
      @required this.usedInterestTags}) {
    if (this.imageUrl == '') {
      imageAsset = AssetImage('assets/images/default_avatar.png');
    } else {
      imageNetwork = NetworkImage(this.imageUrl);
    }
  }

  String getFirstname() => this.firstname;
  String getSurname() => this.surname;
  String getLocation() => this.location;
  String getRole() => this.role;
  String getEmail() => this.email;
  String getImageUrl() => this.imageUrl;
  NetworkImage getNetworkImage() => this.imageNetwork;
  void setNetworkImage(NetworkImage image) => this.imageNetwork = image;
  AssetImage getAssetImage() => this.imageAsset;
  void setFirstname(String firstname) => this.firstname = firstname;
  void setSurname(String surname) => this.surname = surname;
  void setLocation(String location) => this.location = location;
  List<String> getUsedSkillTags() => this.usedSkillTags;

  void setSkillTagList(List<String> tagList) => this.usedSkillTags = tagList;

  List<String> getUsedInterestTags() => this.usedInterestTags;

  void setInterestTagList(List<String> tagList) =>
      this.usedInterestTags = tagList;
}
