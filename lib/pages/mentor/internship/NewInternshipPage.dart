import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:swiring_app/Services/InternshipsService.dart';
import 'package:swiring_app/Services/LocationService.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:swiring_app/Services/TagService.dart';
import 'package:swiring_app/pages/universal/internships/DateTimePicker.dart';

class NewInternshipPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NewInternship();
  }
}

class NewInternship extends StatefulWidget {
  NewInternship({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewInternshipState createState() => _NewInternshipState();
}

class _NewInternshipState extends State<NewInternship> {
  final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);
  final String font = "Verdana";

  final List<String> _dropdownValues = LocationService.allLocations;

  String title = "";
  DateTime startDate = new DateTime(2020);
  DateTime endDate = new DateTime(2020);
  String selectedLocation = LoginService.appUser.getLocation();
  String description = "Description";
  String name = LoginService.appUser.getSurname() +
      ", " +
      LoginService.appUser.getFirstname();
  String email = LoginService.appUser.getEmail();
  String circuit = "Hier Circuit einfügen";

  String documentId;
  String internshipPictureUrl;

  File _image;
  Uint8List bytes;
  String base64;
  bool addTagEnabled = false;
  String selectedTag;

  @override
  void initState() {
    InternshipsService.usedTags.clear();
    InternshipsService.unusedTags.clear();
    print("all Tags " + TagService.allSkillTags.length.toString());
    InternshipsService.unusedTagsItems.clear();

    TagService.allSkillTags
        .forEach((elem) => InternshipsService.unusedTags.add(elem));

    InternshipsService.unusedTags.forEach(
        (elem) => InternshipsService.unusedTagsItems.add(new DropdownMenuItem(
              child: Text(elem),
              value: elem,
            )));
    print(
        "verfügbare Tags: " + InternshipsService.unusedTags.length.toString());
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Theme.of(context).colorScheme.background,
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
                      new Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: _image == null
                                ? LoginService.appUser.getAssetImage()
                                : FileImage(_image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: getImage,
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo,
                            size: MediaQuery.of(context).size.width * 0.08),
                        backgroundColor: atosBlue,
                      ),
                      Divider(color: Colors.black),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Title',
                                style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                              initialValue: title,
                              onChanged: (value) => title = value,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Period',
                                style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 4,
                            child: DateTimePicker(
                              selectDate: (value) => startDate = value,
                              labelText: 'from',
                              selectedDate: startDate,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: DateTimePicker(
                              selectDate: (value) => endDate = value,
                              labelText: 'to',
                              selectedDate: endDate,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Location',
                                style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 8,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Choose Location'),
                              value: selectedLocation,
                              onChanged: (String value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                              items: _dropdownValues.map((String location) {
                                return new DropdownMenuItem<String>(
                                  value: location,
                                  child: new Text(
                                    location,
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child:
                                Text('Tags', style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Material(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      addTagEnabled = true;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/icons/add_tag.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                )),
                              )),
                          Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.1),
                                child: Visibility(
                                  visible: addTagEnabled,
                                  child: SearchableDropdown(
                                    items: InternshipsService.unusedTagsItems,
                                    value: selectedTag,
                                    hint: Text("Add a new skill tag...      "),
                                    onChanged: (value) {
                                      setState(() {
                                        InternshipsService.usedTags.add(value);
                                        InternshipsService.unusedTagsItems
                                            .removeWhere((element) =>
                                                element.value == value);
                                        addTagEnabled = false;
                                      });
                                    },
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: Tags(
                          itemCount: InternshipsService.usedTags.length,
                          itemBuilder: (int index) {
                            return ItemTags(
                              key: Key(index.toString()),
                              index: index,
                              title: InternshipsService.usedTags[index],
                              removeButton: ItemTagsRemoveButton(),
                              onRemoved: () {
                                setState(() {
                                  InternshipsService.removeFromSkillTagList(
                                      index);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Description',
                                style: TextStyle(color: atosBlue)),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 8,
                              child: TextFormField(
                                onChanged: (value) => description = value,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: atosBlue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                              ))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Contact',
                                style: TextStyle(color: atosBlue)),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child:
                                Text('Name', style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                              initialValue: name,
                              onChanged: (value) => name = value,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Email',
                                style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                              initialValue: email,
                              onChanged: (value) => email = value,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Circuit',
                                style: TextStyle(color: atosBlue)),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                              initialValue: circuit,
                              onChanged: (value) => circuit = value,
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

          //Buttons bottom (change Password, save)
          showFab
              ? Stack(
                  children: <Widget>[
                    // change Password button
                    Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.height * 0.02325,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton.extended(
                          heroTag: "btnCancel",
                          onPressed: () => Navigator.pop(context),
                          label:
                              Text('Cancel', style: TextStyle(color: atosBlue)),
                          backgroundColor: Colors.white,
                        )),

                    // Save button
                    Container(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.height * 0.02325,
                      ),
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        heroTag: "btnsave",
                        onPressed: saveInternship,
                        label: Text('Save'),
                        backgroundColor: atosBlue,
                      ),
                    ),
                    // end save button
                  ],
                )
              : Text(
                  "",
                  style: TextStyle(fontSize: 0),
                ),
          // end bottom buttons
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
      //await uploadImage();
    } catch (e) {}
  }

  Future<void> uploadImage() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('internship_pictures/' + this.documentId + '.png');
    StorageUploadTask task = firebaseStorageRef.putFile(_image);
    this.internshipPictureUrl =
        await (await task.onComplete).ref.getDownloadURL();
  }

  Future saveInternship() async {
    if (_image != null && selectedLocation != null) {
      try {
        DocumentReference docRef =
            await Firestore.instance.collection('placements').add({
          'circuit': circuit,
          'description': description,
          'end': endDate,
          'imageUrl': "",
          'location': selectedLocation,
          'mail': email,
          'name': name,
          'start': startDate,
          'tags': InternshipsService.usedTags,
          'title': title
        });
        documentId = docRef.documentID;
        await uploadImage();
        Firestore.instance
            .collection('placements')
            .document(this.documentId)
            .updateData({'imageUrl': this.internshipPictureUrl});
        Navigator.pop(context);
      } catch (e) {
        print("*******" + e.toString());
      }
    }
  }
}
