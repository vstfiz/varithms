import 'package:Varithms/custom_drop_down.dart' as cdd;
import 'package:Varithms/responsiveui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FillDetails extends StatefulWidget {
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  List<cdd.DropdownMenuItem> gender = new List<cdd.DropdownMenuItem>();
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    cdd.DropdownMenuItem item = new cdd.DropdownMenuItem(child: Text("Male"),);
    gender.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
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
    return Stack(
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    style: TextStyle(fontFamily: "Livvic"),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Name",
                        labelStyle: TextStyle(fontFamily: "Livvic"),
                        contentPadding: EdgeInsets.all(5.0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    style: TextStyle(fontFamily: "Livvic"),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: "E-mail",
                        labelStyle: TextStyle(fontFamily: "Livvic"),
                        contentPadding: EdgeInsets.all(5.0)),
                  ),
                ),
                Container(
                  width: 350,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: cdd.DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down),

                    value: dropdownValue,
                    hint: Text("Gender",
                      style: TextStyle(fontFamily: "Livvic", fontSize: 20),),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    style: TextStyle(fontFamily: "Livvic", color: Colors.black),
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
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 150,
          child: Container(
            height: 100,
            width: 100,
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
      ],
    );
  }

  Widget _landscapeStack(BuildContext context) {}
}
