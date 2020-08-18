library globals;

import 'package:Varithms/users.dart';
import 'package:flutter/cupertino.dart';

import 'algorithm.dart';
import 'algorithm_type.dart';

User user = new User("", "", "", "", "", "", "");

double width(double width) {}

double height(double height) {}
bool darkModeOn = false;
bool isPortrait;

BuildContext cont;
List<AlgorithmTypes> algoTypeList = new List<AlgorithmTypes>();
List<Algorithms> algoList = new List<Algorithms>();
String selectedAlgoTypeName = "";
List<Algorithms> algoListForDashboard = new List<Algorithms>();
