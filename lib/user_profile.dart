import 'dart:async';

import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class UserProfile extends StatefulWidget {
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    wait();
  }

  wait() async {
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
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF2D3E50),
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: (MediaQuery.of(context).size.width / 2) - 70,
          right: (MediaQuery.of(context).size.width / 2) - 70,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
          ),
        ),
        Positioned(
          top: 30,
          left: (MediaQuery.of(context).size.width / 2) - 65,
          right: (MediaQuery.of(context).size.width / 2) - 65,
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  shape: BoxShape.circle),
            ),
            placeholder: (context, url) => Center(
              child: Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/varithms7354.appspot.com/o/users%2F1598419940536.jpg?alt=media&token=33627ee7-3b64-4e2e-9643-6fc3b08b7ba4",
            width: 10 * SizeConfig.imageSizeMultiplier,
            height: 10 * SizeConfig.imageSizeMultiplier,
          ),
        ),
        Positioned(
          top: 130,
          left: (MediaQuery.of(context).size.width / 2) + 30,
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
            width: MediaQuery.of(context).size.width - 40,
            child: Text(
              "Vivek Sharma",
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
            width: MediaQuery.of(context).size.width - 40,
            child: Text(
              "vivek.sharma7354@gmail.com",
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
            width: MediaQuery.of(context).size.width - 40,
            child: Text(
              "25 Algorithms",
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _userDetailFields(425, "Name", "Vivek Sharma"),
        _userDetailFields(
            500, "E-mail", "vivek.sharma7354@gmail.comcxrthfcytygty"),
        _userDetailFields(575, "Phone", "8266976136"),
        _userDetailFields(650, "Gender", "Male"),
        _userDetailFields(725, "Occupation", "Student"),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: EdgeInsets.only(left: 20, right: 20, top: 820),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          child: FlatButton(
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

  Widget _userDetailFields(double top, String title, String value) {
    return Container(
        width: MediaQuery.of(context).size.width,
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
                    width: MediaQuery.of(context).size.width - 80,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Livvic",
                          color: Colors.grey),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
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
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF2D3E50),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height - 60) / 2,
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
