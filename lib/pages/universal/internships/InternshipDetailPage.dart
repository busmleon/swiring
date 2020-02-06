import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swiring_app/Services/DateConverterService.dart';
import 'package:swiring_app/Services/InternshipsService.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:flutter_tags/tag.dart';
import 'package:swiring_app/pages/mentor/internship/ChangeInternshipPage.dart';
import 'package:swiring_app/pages/student/profile/StudentProfilePage.dart';

class InternshipDetailPage extends StatefulWidget {
  InternshipDetailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IntershipDetailState createState() => _IntershipDetailState();
}

class _IntershipDetailState extends State<InternshipDetailPage> {
  final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);
  final String font = "Verdana";

  //final List<String> _dropdownValues = LocationService.allLocations;

  String title = "";
  DateTime startDate = new DateTime(2020);
  DateTime endDate = new DateTime(2020);
  String selectedLocation = "Gelsenkirchen";
  String description = "Description";
  List<String> tags = ["a", "b", "c"];
  //TagService.getUserUnusedSkillTags(LoginService.appUser);
  String name = LoginService.appUser.getSurname() +
      ", " +
      LoginService.appUser.getFirstname();
  String email = LoginService.appUser.getEmail();
  String circuit = "Hier Circuit einfügen";

  File _image;
  Uint8List bytes;
  String base64;
  bool addTagEnabled = false;
  String selectedTag;

  @override
  void initState() {
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: <Widget>[
              LoginService.appUser.getRole() == "mentor"
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeInternshipPage())),
                    )
                  : IconButton(
                      icon: Image.asset('assets/icons/profile.png'),
                      iconSize: 20.0,
                      color: atosBlue,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentProfilePage())),
                    ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.005),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            InternshipsService.selectedInternship.getTitle(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline,
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              DateConverterService.getDateAsString(
                                      InternshipsService.selectedInternship
                                          .getStart()) +
                                  " - " +
                                  DateConverterService.getDateAsString(
                                      InternshipsService.selectedInternship
                                          .getEnd()),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display4,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              InternshipsService.selectedInternship
                                  .getLocation(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display4,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Description',
                                style: TextStyle(color: atosBlue)),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: 100,
                              decoration: myBoxDecoration(),
                              child: Text(
                                InternshipsService.selectedInternship
                                    .getDescription(),
                                style: Theme.of(context).textTheme.display3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.03,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.03),
                              child: Tags(
                                itemCount: InternshipsService.selectedInternship
                                    .getTags()
                                    .length,
                                itemBuilder: (int index) {
                                  return ItemTags(
                                    key: Key(index.toString()),
                                    index: index,
                                    title: InternshipsService.selectedInternship
                                        .getTags()[index],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Contact',
                                style: TextStyle(color: atosBlue)),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Name'),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              InternshipsService.selectedInternship
                                  .getMentor()
                                  .getName(),
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Email'),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              InternshipsService.selectedInternship
                                  .getMentor()
                                  .getMail(),
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
      await uploadImage();
    } catch (e) {}
  }

  Future<void> uploadImage() async {
    // setState(() {
    //   _isLoading = true;
    // });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/' + pictureFilename() + '.png');
    StorageUploadTask task = firebaseStorageRef.putFile(_image);
    String profilePictureUrl =
        await (await task.onComplete).ref.getDownloadURL();
    try {
      await Firestore.instance
          .collection('users')
          .document(LoginService.appUser.getEmail())
          .updateData({'ImageUrl': profilePictureUrl});
    } catch (e) {
      print("*******" + e.toString());
    }

    print(profilePictureUrl);
    LoginService.appUser.setNetworkImage(NetworkImage(profilePictureUrl));
    // setState(() {
    //   _isLoading = false;
    // });
  }

  String pictureFilename() {
    return LoginService.appUser.getEmail().split('@')[0];
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }
}
