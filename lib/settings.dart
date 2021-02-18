import 'package:Varithms/fire_auth.dart';
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'size_config.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      right: true,
      left: true,
      bottom: false,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future<bool>.value(false);
        },
        child: Scaffold(
          body: SingleChildScrollView(
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
    return Container(
      color: globals.darkModeOn ? Colors.grey[800] : Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: SizeConfig.height(100),
            left: SizeConfig.width(0),
            right: SizeConfig.width(0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - SizeConfig.width(40),
              height: 180,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Card(
                color: globals.darkModeOn ? Colors.black : Colors.white,
                elevation: 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: SizeConfig.height(45),
                      left: SizeConfig.width(40),
                      child: Container(
                        height: SizeConfig.height(90),
                        width: SizeConfig.width(90),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: Image
                                    .asset('assets/images/night.jpg')
                                    .image,
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Positioned(
                      left: SizeConfig.width(145),
                      top: SizeConfig.height(75),
                      child: Container(
                        width: SizeConfig.width(150),
                        child: Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Livvic",
                            color: globals.darkModeOn ? Colors.white : Colors
                                .black,),
                        ),
                      ),
                    ),
                    Positioned(
                      left: SizeConfig.width(300),
                      top: SizeConfig.height(75),
                      child: CupertinoSwitch(
                        value: globals.darkModeOn,
                        onChanged: (value) async {
                          setState(() {
                            globals.darkModeOn = value;
                          });
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          sharedPreferences.setBool('darkMode', value);
                          Phoenix.rebirth(globals.cont);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.height(310),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: SizeConfig.height(80),
              child: Text(
                "Connect with the Developer",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Livvic",
                  color: globals.darkModeOn ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.height(390),
            left: SizeConfig.width(20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                Image
                                    .asset('assets/images/github-logo.png')
                                    .image)),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://www.github.com/vstfiz/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(40),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
//                            shape: BoxShape.circle,

                            image: DecorationImage(
                                image: Image
                                    .asset('assets/images/linkedin.png')
                                    .image)),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://www.linkedin.com/in/vstfiz/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(40),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image
                                    .asset('assets/images/twitter.png')
                                    .image)),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://www.twitter.com/vstfiz/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.height(50),
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image
                                    .asset('assets/images/facebook.png')
                                    .image)),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://www.facebook.com/vstfiz/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(40),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image
                                    .asset(
                                    'assets/images/instagram-sketched.png')
                                    .image)),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://www.github.com/sin_of__wrath/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(40),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: globals.darkModeOn
                          ? Colors.grey[800]
                          : Colors.white,
                      child: Container(
                        height: SizeConfig.height(80),
                        width: SizeConfig.width(80),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              Image
                                  .asset('assets/images/whatsapp.png')
                                  .image,
                            )),
                        child: FlatButton(
                          onPressed: () async {
                            const url = 'https://wa.me/918266976136/';
                            bool val = await canLaunch(url);
                            print(val);
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                  'Could connect to the Internet. Please, try again later',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: SizeConfig.height(680),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text("Mini Project III year", style: TextStyle(
                color: globals.darkModeOn ? Colors.white : Colors.grey,
                fontFamily: "Livvic",
                fontSize: 25,),
                textAlign: TextAlign.center,),
            ),
          ),
          Positioned(
            top: SizeConfig.height(700),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text("Vstfiz Tech Pvt Ltd", style: TextStyle(
                color: globals.darkModeOn ? Colors.white : Colors.grey,
                fontFamily: "Livvic",
                fontSize: 25,),
                textAlign: TextAlign.center,),
            ),
          ),
          Positioned(
            top: SizeConfig.height(800),
            left: SizeConfig.width(0),
            right: SizeConfig.width(0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40,
              margin: EdgeInsets.only(left: SizeConfig.width(20), right: SizeConfig.width(20)),
              height: SizeConfig.height(70),
              decoration: BoxDecoration(
                  color: globals.darkModeOn ? Colors.pink : Color(0xFF2D3E50),
                  borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  signOutWithGoogle().whenComplete(() {
                    SystemNavigator.pop();
                  });
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white, fontFamily: "Livvic", fontSize: 30,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _landscapeStack(BuildContext context) {}
}
