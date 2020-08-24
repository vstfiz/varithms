import 'dart:async';

import 'package:Varithms/custom_drop_down.dart' as cdd;
import 'package:Varithms/dashboard.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FillDetails extends StatefulWidget {
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  List<cdd.DropdownMenuItem> gender = new List<cdd.DropdownMenuItem>();
  String dropdownValue;
  String dropdownValuePerson;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  Future<bool> detailsChecker() {
    Future<bool> result = Future<bool>.value(false);
    print("value is" + _nameController.text.toString());
    if (_nameController.text != null || _nameController.text != '') {} else {
      print("value is" + _nameController.text.toString());
      Fluttertoast.showToast(
          msg: "Name cannot be empty",
          fontSize: 25,
          toastLength: Toast.LENGTH_LONG);
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    if (globals.isOtpLogin) {
      _phoneController = globals.mobileController;
    } else if (globals.isEmailLogin) {
      _emailController = globals.usernameController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) =>
                ResponsiveWidget(
                  portraitLayout: _portraitStack(context),
                  landscapeLayout: _landscapeStack(context),
                ),
          ),
        ),
      ),
    );
  }

  Widget _portraitStack(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.1,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/back_login.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 150),
            width: 380,
            height: 600,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8.0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        "Hello! Learners, please fill these minor details and start your learning experience with us",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Livvic",
                            color: Colors.grey),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(fontFamily: "Livvic"),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Name",
                          labelStyle: TextStyle(fontFamily: "Livvic"),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: TextField(
                      style: TextStyle(fontFamily: "Livvic"),
                      controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: "E-mail",
                          labelStyle: TextStyle(fontFamily: "Livvic"),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                  ),
                  Container(
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: cdd.DropdownButton<String>(
                      leftMargin: 187,
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.grey,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      value: dropdownValue,
                      hint: Text(
                        "Gender",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 17,
                            color: Colors.grey[650]),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      style:
                      TextStyle(fontFamily: "Livvic", color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          print(newValue);
                        });
                      },
                      items: <String>['Male', 'Female', 'Prefer not to say']
                          .map<cdd.DropdownMenuItem<String>>((String value) {
                        return cdd.DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: TextField(
                      style: TextStyle(fontFamily: "Livvic"),
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "Mobile",
                          labelStyle: TextStyle(fontFamily: "Livvic"),
                          contentPadding: EdgeInsets.all(5.0)),
                    ),
                  ),
                  Container(
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: cdd.DropdownButton<String>(
                      leftMargin: 130,
                      prefixIcon: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.grey,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      value: dropdownValuePerson,
                      hint: Text(
                        "I am a",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 17,
                            color: Colors.grey[650]),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      style:
                      TextStyle(fontFamily: "Livvic", color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValuePerson = newValue;
                          print(newValue);
                        });
                      },
                      items: <String>[
                        'Student',
                        'Salaried Professional',
                        'Self Employed Professional',
                      ].map<cdd.DropdownMenuItem<String>>((String value) {
                        return cdd.DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 75,
            left: (MediaQuery
                .of(context)
                .size
                .width / 2) - 75,
            child: Container(
              height: 150,
              width: 150,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: FlatButton(
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 725,
            left: (MediaQuery
                .of(context)
                .size
                .width / 2) - 75,
            child: Container(
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.blue),
              child: FlatButton(
                onPressed: () {
                  print(_nameController.text.toString());
                  if (_nameController.text != "" &&
                      _nameController.text != null) {
                    if (EmailValidator.validate(_emailController.text)) {
                      if (dropdownValue != "" && dropdownValue != null) {
                        if (validatePhone(_phoneController.text)) {
                          if (dropdownValuePerson != "" &&
                              dropdownValuePerson != null) {
                            print("reached");
                            fdb.FirebaseDB.createUser(
                                _nameController.text,
                                _emailController.text,
                                dropdownValue,
                                _phoneController.text,
                                dropdownValuePerson)
                                .whenComplete(() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => DashBoard()));
                            });
                          } else {
                            print("b1");
                          }
                        } else {
                          print("b2");
                        }
                      } else {
                        print("b3");
                      }
                    } else {
                      print("b4");
                    }
                  } else {
                    print("b5");
                  }
                },
                child: Text("Submit",
                    style: TextStyle(
                        fontFamily: "Livvic",
                        fontSize: 15,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void invokeToast() {}

  bool validatePhone(String phone) {
    RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phone);
  }

  Widget _landscapeStack(BuildContext context) {}
}
