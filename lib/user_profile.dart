import 'dart:async';

import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfile extends StatefulWidget {
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = true;
  bool field1 = false;
  bool field2 = false;
  bool field3 = false;
  bool field4 = false;
  bool field5 = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _occupationController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = globals.mainUser.name;
    _emailController.text = globals.mainUser.email;
    _phoneController.text = globals.mainUser.mobile;
    _genderController.text = globals.mainUser.gender;
    _occupationController.text = globals.mainUser.occupation;

    wait();
  }

  wait() async {
    if (globals.myAlgoList.length != 0) {
      globals.myAlgoList.removeRange(0, globals.myAlgoList.length - 1);
    }
    await fdb.FirebaseDB.getMyAlgos();
    return Timer(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      right: true,
      bottom: false,
      left: true,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future<bool>.value(false);
        },
        child: Scaffold(
          backgroundColor: globals.darkModeOn ? Colors.grey[800] : Colors.white,
          body: isLoading
              ? SingleChildScrollView(
            child: ResponsiveWidget(
              portraitLayout: _loadingPortraitStack(context),
              landscapeLayout: _loadingLandscapeStack(context),
            ),
          )
              : SingleChildScrollView(
            child: ResponsiveWidget(
              portraitLayout: _portraitStack(context),
              landscapeLayout: _landscapeStack(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _portraitStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 360,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: globals.darkModeOn ? Colors.pink : Colors.grey,
            ),
          ),
        ),
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 350,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: globals.darkModeOn ? Colors.black : Color(0xFF2D3E50),
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: (MediaQuery
              .of(context)
              .size
              .width / 2) - 70,
          right: (MediaQuery
              .of(context)
              .size
              .width / 2) - 70,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: globals.darkModeOn ? Colors.white : Colors.grey,
          ),
        ),
        Positioned(
          top: 30,
          left: (MediaQuery
              .of(context)
              .size
              .width / 2) - 65,
          right: (MediaQuery
              .of(context)
              .size
              .width / 2) - 65,
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) =>
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
            placeholder: (context, url) =>
                Center(
                  child: Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl:
            globals.mainUser.dp,
            // width: 10 * SizeConfig.imageSizeMultiplier,
            // height: 10 * SizeConfig.imageSizeMultiplier,
          ),
        ),
        Positioned(
          top: 130,
          left: (MediaQuery
              .of(context)
              .size
              .width / 2) + 30,
//          right: (MediaQuery.of(context).size.width / 2 ) -70,
          child: Container(
              height: 30,
              width: 30,
              decoration:
              BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
              )),
        ),
        Positioned(
          top: 200,
//          right: 20,
          left: 20,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 40,
            child: Text(
              globals.mainUser.name,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 35, color: Colors.white),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        Positioned(
          top: 240,
//          right: 20,
          left: 20,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 40,
            child: Text(
              globals.mainUser.email,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        Positioned(
          top: 280,
//          right: 20,
          left: 20,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 40,
            child: Text(
              "${globals.myAlgoList.length} Algorithms",
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 425),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text("Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                          fontFamily: "Livvic",
                          color: globals.darkModeOn ? Colors.white : Colors
                              .black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: TextField(
                          controller: _nameController,
                          enabled: field1,
                          style: TextStyle(fontFamily: "Livvic",
                              fontSize: 25,
                              color: Colors.grey),

                          decoration: InputDecoration(
                              hintText: globals.mainUser.name,
                              contentPadding: EdgeInsets.only(
                                  right: 5.0, bottom: 8.0),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            field1 = !field1;
                            print(field1);
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 500),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text("E-mail",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                          fontFamily: "Livvic",
                          color: globals.darkModeOn ? Colors.white : Colors
                              .black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: TextField(
                          enabled: field2,
                          style: TextStyle(fontFamily: "Livvic",
                              fontSize: 25,
                              color: Colors.grey),

                          decoration: InputDecoration(
                              hintText: globals.mainUser.email,
                              contentPadding: EdgeInsets.only(
                                  right: 5.0, bottom: 8),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            field2 = !field2;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 575),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text("Phone",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                          fontFamily: "Livvic",
                          color: globals.darkModeOn ? Colors.white : Colors
                              .black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: TextField(
                          enabled: field3,
                          style: TextStyle(fontFamily: "Livvic",
                              fontSize: 25,
                              color: Colors.grey),

                          decoration: InputDecoration(
                              hintText: globals.mainUser.mobile,
                              contentPadding: EdgeInsets.only(
                                  right: 5.0, bottom: 8),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            field3 = !field3;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 650),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text("Gender",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                          fontFamily: "Livvic",
                          color: globals.darkModeOn ? Colors.white : Colors
                              .black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: TextField(
                          enabled: field4,
                          style: TextStyle(fontFamily: "Livvic",
                              fontSize: 25,
                              color: Colors.grey),

                          decoration: InputDecoration(
                              hintText: globals.mainUser.gender,
                              contentPadding: EdgeInsets.only(
                                  right: 5.0, bottom: 8),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            field4 = !field4;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 725),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text("Occupation",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                          fontFamily: "Livvic",
                          color: globals.darkModeOn ? Colors.white : Colors
                              .black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: TextField(
                          enabled: field5,
                          style: TextStyle(fontFamily: "Livvic",
                              fontSize: 25,
                              color: Colors.grey),

                          decoration: InputDecoration(
                              hintText: globals.mainUser.occupation,
                              contentPadding: EdgeInsets.only(
                                  right: 5.0, bottom: 8),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            field5 = !field5;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Divider(
                      thickness: 1,
                      color: globals.darkModeOn ? Colors.white : Colors.black
                  ),
                ),
              ],
            )),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 40,
          margin: EdgeInsets.only(left: 20, right: 20, top: 820),
          decoration: BoxDecoration(
              color: globals.darkModeOn ? Colors.pink : Colors.blue,
              borderRadius: BorderRadius.circular(15)),
          child: FlatButton(
            onPressed: () {
              if (_nameController.text != "" &&
                  _nameController.text != null) {
                if (EmailValidator.validate(_emailController.text)) {
                  if (_genderController.text != "" &&
                      _genderController.text != null) {
                    if (validatePhone(_phoneController.text)) {
                      if (_occupationController.text != "" &&
                          _occupationController.text != null) {
                        print("reached");
                        showDialog(context: context,
                            builder: (context) => _loadingDialog());
                        fdb.FirebaseDB.updateDetails(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _phoneController.text,
                            _occupationController.text)
                            .whenComplete(() {
                          Navigator.pop(context);
                          SystemNavigator.pop();
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Occupation entered. Please enter your Occupation",
                            toastLength: Toast.LENGTH_LONG);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Invalid Mobile. Please enter valid Mobile Number",
                          toastLength: Toast.LENGTH_LONG);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "No Gender entered. Please enter your gender",
                        toastLength: Toast.LENGTH_LONG);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Invalid E-mail. Please enter valid E-mail",
                      toastLength: Toast.LENGTH_LONG);
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Name can't be empty. Please enter your name",
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 30, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  bool validatePhone(String phone) {
    RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phone);
  }

  Widget _loadingDialog() {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: 60,
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Uploading Data...", style: TextStyle(
                      fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),)
                ],
              ),
            )
        )
    );
  }

  Widget _userDetailFields(double top, String title, String value, bool field) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        margin: EdgeInsets.only(top: top),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, fontFamily: "Livvic"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Divider(
                thickness: 1,
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 20),
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 80,
                    child: TextField(
                      enabled: true,
                      style: TextStyle(fontFamily: "Livvic",
                          fontSize: 25,
                          color: Colors.grey),

                      decoration: InputDecoration(
                          hintText: value,
                          contentPadding: EdgeInsets.only(right: 5.0, top: 8),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        field = true;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Divider(
                thickness: 1,
              ),
            ),
          ],
        ));
  }

  Widget _loadingPortraitStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 360,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 350,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: Color(0xFF2D3E50),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery
              .of(context)
              .size
              .height - 60) / 2,
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: 60,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Loading Data...",
                          style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 23,
                              letterSpacing: 1),
                        )
                      ],
                    ),
                  ))),
        )
      ],
    );
  }

  Widget _landscapeStack(BuildContext context) {
    return SizedBox();
  }

  Widget _loadingLandscapeStack(BuildContext context) {
    return SizedBox();
  }
}
