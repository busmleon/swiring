import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swiring_app/Services/LocationService.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:flutter_tags/tag.dart';
import 'package:swiring_app/Services/TagService.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:swiring_app/Services/UserService.dart';

import 'ChangePasswordPage.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);
  final String font = "Verdana";
  List<String> _dropdownValues = new List();
  String selectedLocation = LoginService.appUser.getLocation();
  String firstName = LoginService.appUser.getFirstname();
  String lastName = LoginService.appUser.getSurname();
  String email = LoginService.appUser.getEmail();
  File _image;
  Uint8List bytes;
  String base64;
  bool addSkillTagEnabled = false;
  bool addInterestTagEnabled = false;
  String selectedTag;
  List<String> chosenSkillTags = new List();
  List<DropdownMenuItem> unusedSkillTagsItems = new List();
  List<String> chosenInterestTags = new List();
  List<DropdownMenuItem> unusedInterestTagItems = new List();

  @override
  void initState() {
    _dropdownValues = LocationService.allLocations;
    //_dropdownValues.add("test");
    _resetSkillTagLists();
    _resetInterestTagLists();
    return super.initState();
  }

  void _resetSkillTagLists() {
    chosenSkillTags.clear();
    LoginService.appUser
        .getUsedSkillTags()
        .forEach((element) => chosenSkillTags.add(element));
    unusedSkillTagsItems.clear();
    TagService.unusedSkillTags
        .forEach((element) => unusedSkillTagsItems.add(new DropdownMenuItem(
              child: Text(element),
              value: element,
            )));
  }

  void _resetInterestTagLists() {
    chosenInterestTags.clear();
    LoginService.appUser
        .getUsedInterestTags()
        .forEach((element) => chosenInterestTags.add(element));
    unusedInterestTagItems.clear();
    TagService.unusedInterestTags
        .forEach((element) => unusedInterestTagItems.add(new DropdownMenuItem(
              child: Text(element),
              value: element,
            )));
    unusedInterestTagItems.add(new DropdownMenuItem(
      child: Text("test"),
      value: "text",
    ));
    unusedSkillTagsItems.add(new DropdownMenuItem(
      child: Text("test"),
      value: "text",
    ));
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
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    children: <Widget>[
                      //ProfilePic
                      new Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image:
                                LoginService.appUser.getNetworkImage() == null
                                    ? LoginService.appUser.getAssetImage()
                                    : LoginService.appUser.getNetworkImage(),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      //Add new Photo
                      FloatingActionButton(
                        heroTag: "pickImage",
                        onPressed: getImage,
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo,
                            size: MediaQuery.of(context).size.width * 0.08),
                        backgroundColor: atosBlue,
                      ),
                      //Textfield FirstName
                      Divider(color: Colors.black),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'First Name',
                              //style: TextStyle(color: atosBlue)
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextField(
                              controller:
                                  TextEditingController(text: firstName),
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                      //TextField LastName
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Last Name',
                              //style: TextStyle(color: atosBlue)
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextField(
                              controller: TextEditingController(text: lastName),
                              enabled: false,
                              onTap: () {
                                print('Editing stated $widget');
                              },
                            ),
                          ),
                        ],
                      ),
                      //TextField Mail
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Email',
                              //style: TextStyle(color: atosBlue)
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextField(
                                controller: TextEditingController(text: email),
                                enabled: false),
                          ),
                        ],
                      ),
                      //DropDown Location
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Location',
                              // style: TextStyle(color: atosBlue)
                            ),
                          ),
                          //SelectField
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
                              //List
                              items: _dropdownValues.map((String location) {
                                return new DropdownMenuItem<String>(
                                  value: location,
                                  child: new Text(
                                    location,
                                    //style: new TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black),
                      //SkillTags + List Tags
                      Row(
                        children: <Widget>[
                          //DescText
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Skills',
                              //style: TextStyle(color: atosBlue)
                            ),
                          ),
                          //ButtonImage ToDo
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      addSkillTagEnabled = true;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/icons/add_tag.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //DropdownList
                          Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.1),
                                child: Visibility(
                                  visible: addSkillTagEnabled,
                                  child: SearchableDropdown(
                                    items: unusedSkillTagsItems,
                                    value: selectedTag,
                                    hint: Text("Add a new skill tag...      "),
                                    onChanged: (value) {
                                      setState(() {
                                        chosenSkillTags.add(value);
                                        unusedSkillTagsItems.removeWhere(
                                            (element) =>
                                                element.value == value);
                                        addSkillTagEnabled = false;
                                      });
                                    },
                                  ),
                                ),
                              )),
                        ],
                      ),

                      //Tags
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            bottom: MediaQuery.of(context).size.height * 0.03),
                        child: Tags(
                          itemCount: chosenSkillTags.length,
                          itemBuilder: (int index) {
                            return ItemTags(
                              key: Key(index.toString()),
                              index: index,
                              title: chosenSkillTags[index],
                              removeButton: ItemTagsRemoveButton(),
                              onRemoved: () {
                                setState(() {
                                  unusedSkillTagsItems.add(new DropdownMenuItem(
                                    child:
                                        Text(chosenSkillTags.elementAt(index)),
                                    value: chosenSkillTags.elementAt(index),
                                  ));
                                  chosenSkillTags.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Divider(color: Colors.black),
                      //InterestTags + List Interests
                      Row(
                        children: <Widget>[
                          //DescText
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Interests',
                              //style: TextStyle(color: atosBlue)
                            ),
                          ),
                          //ButtonImage ToDo
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      addInterestTagEnabled = true;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/icons/add_tag.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //DropdownList
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.1),
                              child: Visibility(
                                visible: addInterestTagEnabled,
                                child: SearchableDropdown(
                                  items: unusedInterestTagItems,
                                  value: selectedTag,
                                  hint: Text("Add a new interest tag...      "),
                                  onChanged: (value) {
                                    setState(() {
                                      chosenInterestTags.add(value);
                                      unusedInterestTagItems.removeWhere(
                                          (element) => element.value == value);
                                      addInterestTagEnabled = false;
                                      //setUnusedSkillTagsList();
                                      //selectedTag = value;
                                      //print(value);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            bottom: MediaQuery.of(context).size.height * 0.03),
                        child: Tags(
                          itemCount: chosenInterestTags.length,
                          itemBuilder: (int index) {
                            return ItemTags(
                              key: Key(index.toString()),
                              index: index,
                              title: chosenInterestTags[index],
                              removeButton: ItemTagsRemoveButton(),
                              onRemoved: () {
                                setState(() {
                                  unusedInterestTagItems
                                      .add(new DropdownMenuItem(
                                    child: Text(
                                        chosenInterestTags.elementAt(index)),
                                    value: chosenInterestTags.elementAt(index),
                                  ));
                                  chosenInterestTags.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
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
                          heroTag: "changePassword",
                          onPressed: () => changePassword(context),
                          label: Text('change Password'),
                          backgroundColor: atosBlue,
                        )),

                    // Save button
                    Container(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.height * 0.02325,
                      ),
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        heroTag: "save",
                        onPressed: saveProfile,
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
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    await UserService.uploadImage(_image);
  }

  void saveProfile() async {
    await UserService.writeProfileToFirebase(
        selectedLocation, chosenSkillTags, chosenInterestTags);

    // save Changes locally
    LoginService.appUser.setLocation(selectedLocation);
    LoginService.appUser.getUsedSkillTags().clear();
    chosenSkillTags.forEach(
        (element) => LoginService.appUser.getUsedSkillTags().add(element));
    TagService.unusedSkillTags.clear();
    unusedSkillTagsItems
        .forEach((element) => TagService.unusedSkillTags.add(element.value));
    LoginService.appUser.getUsedInterestTags().clear();
    chosenInterestTags.forEach(
        (element) => LoginService.appUser.getUsedInterestTags().add(element));
    TagService.unusedInterestTags.clear();
    unusedInterestTagItems
        .forEach((element) => TagService.unusedInterestTags.add(element.value));
  }
}

void changePassword(BuildContext context) async {
  // new window (dialog)
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangePasswordPage();
      });
}
