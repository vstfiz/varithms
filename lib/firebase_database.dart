import 'package:Varithms/algorithm.dart';
import 'package:Varithms/algorithm_type.dart';
import 'package:Varithms/fill_details.dart';
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class FirebaseDB {
  static Future<void> getAlgotype() async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('algorithmTypes');

    QuerySnapshot querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    for (var doc in ds) {
      AlgorithmTypes algorithmTypes = new AlgorithmTypes(
          doc['imageUrl'], doc['name'], doc['noOfAlgorithms']);
      print("\n\n\n\n");
      print(algorithmTypes.toString());
      globals.algoTypeList.add(algorithmTypes);
    }
  }

  static Future<List<Algorithms>> getAlgos(String categoryName) async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('algorithms');
    QuerySnapshot querySnapshot = await ref
        .where("category_name", isEqualTo: categoryName)
        .getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    for (var doc in ds) {
      Algorithms algorithms = new Algorithms(doc['difficulty'], doc['content'],
          doc['name'], doc['noOfLearners'], doc['imageUrl'], doc['category']);
      globals.algoList.add(algorithms);
    }
    return globals.algoList;
  }

  static Future<List<Algorithms>> getAlgosForDashboard() async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('algorithms');
    QuerySnapshot querySnapshot = await ref.limit(15).getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    for (var doc in ds) {
      Algorithms algorithms = new Algorithms(doc['difficulty'], doc['content'],
          doc['name'], doc['noOfLearners'], doc['imageUrl'], doc['category']);
      globals.algoListForDashboard.add(algorithms);
    }
    return globals.algoListForDashboard;
  }

  static Future<User> getUserDetails(String uid, BuildContext context) async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    if (ds.isEmpty) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => FillDetails()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DashBoard();
      }));
    }
//    globals.mainUser = new User(ref['name'], ref['country'], ref['mobile'], email, gender, dp, uid)
  }

  static Future<bool> createUser(name, mail, gender, phone, iAmA) async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    Map<String, String> userData = new Map<String, String>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('gender', () => gender);
    userData.putIfAbsent('phone', () => phone);
    userData.putIfAbsent('profession', () => iAmA);
    userData.putIfAbsent('uid', () => globals.user.uid);
    userData.putIfAbsent('displayUrl', () => globals.user.dp);
    userData.forEach((String k, String v) =>
        print("k is: " + k + "v is  : " + v));
    ref.add(userData);
  }
}
