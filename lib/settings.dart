import 'package:Varithms/fire_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: 340,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    signOutWithGoogle().whenComplete(() {
                      SystemNavigator.pop();
                    });
                  },
                  child: Text("Logout"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
