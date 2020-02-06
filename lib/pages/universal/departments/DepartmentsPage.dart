import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiring_app/Entities/Department.dart';
import 'package:swiring_app/Entities/Mentor.dart';
import 'package:swiring_app/helpers/MyCircularProgressIndicator.dart';
import 'package:swiring_app/pages/student/profile/StudentProfilePage.dart';

final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);
final String font = "Verdana";

class DepartmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DepartmentsPage();
  }
}

class _DepartmentsPage extends StatefulWidget {
  _DepartmentsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _State createState() => _State();
}

class _State extends State<_DepartmentsPage> {
  // List<Internship> praxisphasen = new List();

  @override
  Widget build(BuildContext context) {
    print("test");
    // praxisphasen = new List();
    // praxisphasen.add(new PracticalPlacement("DIG IOT", "Gelsenkirchen",
    //     new DateTime(2021), new DateTime(2022), "1 Betreuer"));
    // praxisphasen.add(new PracticalPlacement("SAP ABAP", "Paderboring",
    //     new DateTime(1980), new DateTime(1970), "veraltete Systeme"));
    // praxisphasen.add(new PracticalPlacement("Java Web", "Paderboring",
    //     new DateTime(1980), new DateTime(1872), "Quuuuueeerryyy"));
    // praxisphasen.add(new PracticalPlacement("SAP ABAP", "Paderboring",
    //     new DateTime(1980), new DateTime(1970), "veraltete Systeme"));
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: <Widget>[
          // button to filter
          IconButton(
            icon: Image.asset('assets/icons/filter.png'),
            iconSize: 20.0,
            onPressed: null,
            /*() => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FilterPage())),*/
          ),
          // button to profile
          IconButton(
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
                stream: Firestore.instance
                    .collection('fl_content')
                    .where("_fl_meta_.schema", isEqualTo: 'addDepartment')
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? MyCircularProgressIndicator('Loading Placements...')
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            String doc(String s) {
                              return snapshot.data.documents[index][s];
                            }

                            String _departmentName = doc('addDepartmentName');
                            String _division = doc('addDivision');
                            String _description = doc('description');
                            String _circuit = doc('circuit');
                            String _mail = doc('mail');
                            String _name = doc('name');
                            List<dynamic> _tagsDynamic =
                                snapshot.data.documents[index]['tags'];
                            List<String> _tagsString = new List();
                            _tagsDynamic.forEach((element) =>
                                _tagsString.add(element.toString()));

                            return buildButtonDepartment(Department(
                                departmentName: _departmentName,
                                division: _division,
                                description: _description,
                                tags: _tagsString,
                                mentor: Mentor(
                                    name: _name,
                                    mail: _mail,
                                    circuit: _circuit)));
                          });
                }),
          ),
        ],
      ),
      //Divider(height: 0,),
      //Container(),
      //buildButtonPlacement("Hallo", 'assets/images/placements.jpg', new DateTime(2020).toString(),new DateTime(2022).toString(),"Gelsenkirchen"),
      //buildButtonPlacement("Welt", 'assets/images/placements.jpg',new DateTime(2020).toString(),new DateTime(2022).toString(),"Paderboring"),
    );
  }

  void imageTapped() {
    print("platzhalter");
  }

  void selectDepartment(Department department) {}

  Container buildButtonDepartment(Department department) {
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
            onTap: () => selectDepartment(department),
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
                      //Align(
                      //  alignment: Alignment.center,
                      //child:
                      Text(
                        setTitle(department),
                        style: buildTextStyleHeader(),
                      ),
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

  TextStyle buildTextStyleHeader() {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
      fontFamily: font,
      color: atosBlue,
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    );
  }

  String setTitle(Department department){
    if(department.getTitle().length > 18) {
      return department.getTitle().substring(0, 15) + "...";
    }
    return department.getTitle();
  }
}
