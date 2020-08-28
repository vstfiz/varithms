import 'package:Varithms/fire_auth.dart';
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
        onWillPop: () {},
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
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40,
              height: 180,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 45,
                      left: 40,
                      child: Container(
                        height: 90,
                        width: 90,
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
                      left: 145,
                      top: 75,
                      child: Container(
                        width: 150,
                        child: Text(
                          "Dark Mode",
                          style: TextStyle(fontSize: 30, fontFamily: "Livvic"),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 300,
                      top: 75,
                      child: CupertinoSwitch(
                        value: globals.darkModeOn,
                        onChanged: (value) async {
                          setState(() {
                            globals.darkModeOn = value;
                          });
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          sharedPreferences.setBool('darkMode', value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 310,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 80,
              child: Text(
                "Connect with the Developer",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Livvic",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 390,
            left: 20,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 80,
                        width: 80,
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
                      width: 40,
                    ),
                    CircleAvatar(
                      radius: 50,
                      child: Container(
                        height: 80,
                        width: 80,
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
                      width: 40,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 80,
                        width: 80,
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
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 80,
                        width: 80,
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
                      width: 40,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 80,
                        width: 80,
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
                      width: 40,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 80,
                        width: 80,
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
            top: 820,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40,
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFF2D3E50),
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
                      color: Colors.white, fontFamily: "Livvic", fontSize: 25),
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
