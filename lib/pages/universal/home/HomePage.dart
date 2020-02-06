import 'package:flutter/material.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:swiring_app/pages/student/profile/StudentProfilePage.dart';
import 'package:swiring_app/pages/student/swipe/StudentSwipePage.dart';
import 'package:swiring_app/pages/universal/departments/DepartmentsPage.dart';
import 'package:swiring_app/pages/universal/favourites/FavouritesPage.dart';
import 'package:swiring_app/pages/universal/home/LogoutButton.dart';
import 'package:swiring_app/pages/universal/internships/InternshipsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginService.appUser.getRole() == "student"
            ? buildHomePageForStudents()
            : buildHomePageForMentors());
  }

  Scaffold buildHomePageForStudents() {
    return Scaffold(
      appBar: AppBar(
        leading: LogoutButton(),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/profile.png'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => StudentProfilePage())),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Divider(
                color: Colors.transparent,
                thickness: 0,
              ),
              buildButton("Placements", "assets/images/placements.jpg",
                  InternshipsPage()),
              buildButton("Departments", "assets/images/departments.jpg",
                  DepartmentsPage()),
              buildButton("Favourites", 'assets/images/favourites.jpg',
                  FavouritesPage())
            ],
          ),
        ],
      ),
    );
  }

  Scaffold buildHomePageForMentors() {
    return Scaffold(
      appBar: AppBar(
        leading: LogoutButton(),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Divider(
            color: Colors.transparent,
            thickness: 0,
          ),
          buildButton(
              "Students", "assets/images/placements.jpg", StudentSwipePage()),
          buildButton(
              "Placements", "assets/images/departments.jpg", InternshipsPage()),
          buildButton(
              "Favourites", 'assets/images/favourites.jpg', FavouritesPage())
        ],
      ),
    );
  }

  Container buildButton(String title, String imageLink, Widget navigation) {
    var width = MediaQuery.of(context).size.width * 0.75;
    var height = MediaQuery.of(context).size.height * 0.25;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.05,
      ),
      width: width, //26.0,
      height: height, //20.0,
      child: Container(
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 7.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => navigation));
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: myBoxDecoration(),
                        child: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            imageLink,
                            width: width,
                            height: height,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border:
          Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    );
  }
}
