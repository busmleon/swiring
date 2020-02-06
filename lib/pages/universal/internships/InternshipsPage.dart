import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiring_app/Entities/Internship.dart';
import 'package:swiring_app/Entities/Mentor.dart';
import 'package:swiring_app/Services/DateConverterService.dart';
import 'package:swiring_app/Services/InternshipsService.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:swiring_app/pages/mentor/internship/NewInternshipPage.dart';
import 'package:swiring_app/pages/student/profile/StudentProfilePage.dart';
import 'package:swiring_app/pages/universal/internships/InternshipDetailPage.dart';
import 'package:swiring_app/helpers/MyCircularProgressIndicator.dart';

class InternshipsPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _InternshipsPage();
  }
}

class _InternshipsPage extends StatefulWidget {
  _InternshipsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _State createState() => _State();
}

class _State extends State<_InternshipsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: <Widget>[
          LoginService.appUser.getRole() == "mentor" ?
          IconButton(
            icon: Icon(Icons.add), 
            //Image.asset('assets/icons/add.png'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewInternshipPage())),
          ) : IconButton(
            icon: Image.asset('assets/icons/profile.png'),
            iconSize: 20.0,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => StudentProfilePage())),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.transparent,
            thickness: 0,
          ),
          Expanded(
            child: StreamBuilder(
                stream: Firestore.instance.collection('placements').snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? MyCircularProgressIndicator('Loading Placements...')
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            String _docId =
                                snapshot.data.documents[index].documentID;
                            String _location =
                                snapshot.data.documents[index]['location'];
                            String _circuit =
                                snapshot.data.documents[index]['circuit'];
                            String _description =
                                snapshot.data.documents[index]['description'];
                            DateTime _end =
                                snapshot.data.documents[index]['end'].toDate();

                            DateTime _start = snapshot
                                .data.documents[index]['start']
                                .toDate();
                            String _imageUrl =
                                snapshot.data.documents[index]['imageUrl'];
                            String _mail =
                                snapshot.data.documents[index]['mail'];
                            String _name =
                                snapshot.data.documents[index]['name'];
                            List<dynamic> _tagsDynamic =
                                snapshot.data.documents[index]['tags'];
                            List<String> _tagsString = new List();
                            _tagsDynamic
                                .forEach((element) => _tagsString.add(element));
                            String _title =
                                snapshot.data.documents[index]['title'];
                            Internship internship = new Internship(
                                docId: _docId,
                                title: _title,
                                location: _location,
                                start: _start,
                                end: _end,
                                description: _description,
                                tags: _tagsString,
                                imageUrl: _imageUrl,
                                mentor: Mentor(
                                    name: _name,
                                    mail: _mail,
                                    circuit: _circuit));
                            return buildButtonPlacement(internship);
                          });
                }),
          ),
        ],
      ),
    );
  }

  void selectPracticalPlacement(Internship pp) {
    InternshipsService.selectedInternship = pp;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => InternshipDetailPage()));
  }

  Container buildButtonPlacement(Internship internship) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.200
          : MediaQuery.of(context).size.height * 0.5,
      child: Container(
        decoration: myBoxDecoration(),
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 7.0,
          child: InkWell(
            onTap: () => selectPracticalPlacement(internship),
            child: new Row(
              children: <Widget>[
                Container(
                  decoration: myBoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.asset(
                      'assets/images/placements.jpg',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ),
                Container(
                  padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.02,
                    left: MediaQuery.of(context).size.width * 0.02 
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        setTitle(internship),
                        style: Theme.of(context).textTheme.display2,
                        maxLines: null,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(DateConverterService.getDateAsString(
                              internship.getStart()) +
                          " - ",
                          style: Theme.of(context).textTheme.display3,),
                      Text(DateConverterService.getDateAsString(
                          internship.getEnd()),
                          style: Theme.of(context).textTheme.display3,),
                      Text(internship.getLocation(),
                          style: Theme.of(context).textTheme.display3,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          color: Theme.of(context).colorScheme.secondaryVariant, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    );
  }

  String setTitle(Internship internship){
    if(internship.getTitle().length > 18) {
      return internship.getTitle().substring(0, 15) + "...";
    }
    return internship.getTitle();
  }
}
