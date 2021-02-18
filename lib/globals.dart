library globals;

import 'package:Varithms/users.dart';
import 'package:flutter/cupertino.dart';

import 'algorithm.dart';
import 'algorithm_type.dart';

User user = new User("", "", "", "", "", "", "");
User mainUser = new User("", "", "", "", "", "", "");

double width(double width) {}

double height(double height) {}
bool darkModeOn = false;
bool isPortrait;
bool isPlaying = false;
bool isOtpLogin = false;
List<String> i1 = [];
List<String> i2 = [];
bool isEmailLogin = false;
bool isFireLogin = false;
TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController cnfPasswordController = new TextEditingController();
TextEditingController mobileController = new TextEditingController();
TextEditingController otpController = new TextEditingController();

BuildContext cont;
List<AlgorithmTypes> algoTypeList = new List<AlgorithmTypes>();
List<Algorithms> algoList = new List<Algorithms>();
List<Algorithms> myAlgoList = new List<Algorithms>();
String selectedAlgoTypeName = "";
Algorithms selectedAlgo =
    new Algorithms(0, "content", 'name', 'imageUrl', 'category', 0, "", "");
List<Algorithms> algoListForDashboard = new List<Algorithms>();
