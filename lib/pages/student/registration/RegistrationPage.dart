import 'package:flutter/material.dart';
import 'package:swiring_app/Services/UserService.dart';
import 'package:swiring_app/pages/universal/login/LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final Color atosBlue = Color.fromRGBO(1, 103, 160, 1.0);
  final String font = "Verdana";
  //bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String firstName = "";
  String lastName = "";
  String email = "";

  String password = "";
  String passwordConfirm = "";
  
  
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: ListView(children: <Widget>[
      Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Login Details',
                  style: buildTextStyleAtosBlue(),
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _firstNameFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                },
                onSaved: (text) => firstName = text,
                validator: (value) =>
                    value.isEmpty || (!RegExp('^[a-zA-Z]+\$').hasMatch(value))
                        ? 'Invalid first name'
                        : null,
                decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: buildTextStyle(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: atosBlue))),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _lastNameFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _lastNameFocus, _emailFocus);
                },
                onSaved: (text) => lastName = text,
                validator: (value) =>
                    value.isEmpty || (!RegExp('^[a-zA-Z]+\$').hasMatch(value))
                        ? 'Invalid last name'
                        : null,
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: buildTextStyle(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: atosBlue))),
              ),
              TextFormField(    
                keyboardType: TextInputType.emailAddress,           
                textInputAction: TextInputAction.next,
                focusNode: _emailFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _emailFocus, _passwordFocus);
                },
                onSaved: (text) => email = text.toLowerCase(),
                validator: (value) => value.isEmpty ||
                        (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value))
                    ? "Invalid email"
                    : null,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: buildTextStyle(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: atosBlue))),
              ),
              SizedBox(height: 30.0),
              Text(
                'Password Details',
                style: buildTextStyleAtosBlue(),
                textAlign: TextAlign.start,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _passwordFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _passwordFocus, _passwordConfirmFocus);
                },
                validator: (value) {
                  password = value;
                  return value.length < 8 ? 'Password is too short' : null;
                },
                onSaved: (text) {
                  return () {
                    password = text;
                  };
                },
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: buildTextStyle(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: atosBlue))),
                obscureText: true,
              ),
              TextFormField(                
                textInputAction: TextInputAction.done,
                focusNode: _passwordConfirmFocus,
                onFieldSubmitted: (value) {
                  _passwordConfirmFocus.unfocus();
                },
                onSaved: (text) => passwordConfirm = text,
                validator: (value) {
                  passwordConfirm = value;
                  return value != password ? 'Passwords do not match' : null;
                },
                decoration: InputDecoration(
                    labelText: 'Password confirmation',
                    labelStyle: buildTextStyle(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: atosBlue))),
                obscureText: true,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
              SizedBox(height: 30.0),
              Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: atosBlue,
                    color: atosBlue,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () => onPressedRegister(),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontFamily: font),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 20.0),
              Container(
                height: 40.0,
                color: Colors.transparent,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Center(
                      child: Text('already have an account',
                          style: buildTextStyle()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }

  TextStyle buildTextStyleAtosBlue() {
    return TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: atosBlue);
  }

  TextStyle buildTextStyle() {
    return TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.grey);
  }

  void onPressedRegister() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // setState(() => _isLoading = true);
      _register();
    }
  }

  Future<void> _register() async {
    await UserService.createUserInFirebase(
        email, password, firstName, lastName, context);
    /*setState(() {
      _isLoading = false;
    });
    */
  }

  String validatePasswordConfirm(String value) {
    return (value.toString() == password.toString())
        ? null
        : "Passwords do not match";
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
