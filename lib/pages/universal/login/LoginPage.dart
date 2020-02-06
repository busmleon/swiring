import 'package:flutter/material.dart';
import 'package:swiring_app/Services/loginService.dart';
import 'package:swiring_app/pages/student/registration/RegistrationPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  FocusNode userFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      //Hintergrundbild ohne Mitscrollen
      Positioned(
        top: 0.0,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset("assets/images/login_page_background.png",
            fit: BoxFit.fill),
      ),
      Center(
        child: buildWidget(),
      ),
    ]);
  }

//Erstellen des scrollenden Overlays
  Widget buildWidget() {
    return new Scaffold(
        //Overlay Hintergrund
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.75),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Logo
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      bottom: MediaQuery.of(context).size.height * 0.15,
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/icons/logo_swiring_framed.png"),
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  )),
                ),
                //Username
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Row(
                            children: <Widget>[
                              //Icon
                              Container(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.06,
                                  ),
                                  child: new Image.asset(
                                    'assets/icons/customer.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    fit: BoxFit.cover,
                                  )),
                              //InputField
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  onSaved: (value) => email = value,
                                  focusNode: userFocus,
                                  validator: (value) => value.isEmpty
                                      ? "E-Mail darf nicht leer sein"
                                      : null,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "username",
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmitted: (value) =>
                                      _fieldFocusChange(
                                          context, userFocus, passwordFocus),
                                  textInputAction: TextInputAction.next,
                                ),
                              )
                            ],
                          ),
                        ),

                        //Password
                        Container(
                          child: Row(
                            children: <Widget>[
                              //Icon
                              Container(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.06,
                                  ),
                                  child: new Image.asset(
                                    'assets/icons/password.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    fit: BoxFit.cover,
                                  )),

                              //InputField
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  focusNode: passwordFocus,
                                  validator: (value) => value.isEmpty
                                      ? 'Passwort darf nicht leer sein'
                                      : null,
                                  onChanged: (value) => password = value,
                                  onFieldSubmitted: submitPasswordField,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "password",
                                  ),
                                  textInputAction: TextInputAction.done,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //Buttons
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  child: Column(
                    children: <Widget>[
                      //SingIn
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FlatButton(
                          onPressed: () {
                            submitPasswordField(password);
                          },
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          padding: EdgeInsets.only(left: 1, right: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Sign In"),
                        ),
                      ),

                      //SignUp
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
                            );
                          },
                          color: Colors.transparent,
                          textColor: Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * .002),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          child: Text("Sign Up"),
                        ),
                      ),

                      //ForgotPassword
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: () {},
                          color: Colors.transparent,
                          textColor:
                              Theme.of(context).colorScheme.secondaryVariant,
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * .002),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.transparent)),
                          child: Text("forgot password"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  //Methode zum Wechsel in anderesTextfeld
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode newFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(newFocus);
  }

  //Login aufruf
  Future<void> submitPasswordField(String value) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await LoginService.login(context, email, value);
    }
  }
}
