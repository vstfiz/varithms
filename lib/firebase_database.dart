import 'dart:convert';
import 'dart:io';

import 'package:Varithms/algorithm.dart';
import 'package:Varithms/algorithm_type.dart';
import 'package:Varithms/fill_details.dart';
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/question.dart';
import 'package:Varithms/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'dashboard.dart';

class FirebaseDB {
  static bool _check = false;

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
      Algorithms algorithms = new Algorithms(
          doc['difficulty'],
          doc['content'],
          doc['name'],
          doc['imageUrl'],
          doc['category_name'],
          doc['progress'],
          doc['implInJava'],
          doc['implInPython']);
      globals.algoList.add(algorithms);
    }
    return globals.algoList;
  }

  static Future<List<Algorithms>> getMyAlgos() async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.where("uid", isEqualTo: globals.user.uid).getDocuments();
    String ds = querySnapshot.documents.single.documentID;
    ref = firestore.collection('users/${ds}/myAlgorithms');
    querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> data = querySnapshot.documents;
    for (var doc in data) {
      Algorithms algorithms = new Algorithms(
          doc['difficulty'],
          doc['content'],
          doc['name'],
          doc['imageUrl'],
          doc['category_name'],
          doc['progress'],
          doc['implInJava'],
          doc['implInPython']);
      globals.myAlgoList.add(algorithms);
    }
    return globals.myAlgoList;
  }

  static Future<List<Algorithms>> getAlgosForDashboard() async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('algorithms');
    QuerySnapshot querySnapshot = await ref.limit(15).getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    for (var doc in ds) {
      // print(doc['category_name']);
      Algorithms algorithms = new Algorithms(
          doc['difficulty'],
          doc['content'],
          doc['name'],
          doc['imageUrl'],
          doc['category_name'],
          doc['progress'],
          doc['implInJava'],
          doc['implInPython']);
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
      DocumentSnapshot document = ds.single;
      globals.mainUser = new User(
          document['name'],
          document['profession'],
          document['phone'],
          document['email'],
          document['gender'],
          document['displayUrl'],
          document['uid']);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DashBoard();
      }));
    }
  }

  static Future<bool> createUser(name, mail, gender, phone, iAmA,
      imageUrl) async {
    globals.mainUser =
    new User(
        name,
        "",
        phone,
        mail,
        gender,
        imageUrl,
        globals.user.uid);
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    Map<String, String> userData = new Map<String, String>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('gender', () => gender);
    userData.putIfAbsent('phone', () => phone);
    userData.putIfAbsent('profession', () => iAmA);
    userData.putIfAbsent('uid', () => globals.user.uid);
    userData.putIfAbsent('displayUrl', () => imageUrl);
    userData
        .forEach((String k, String v) => print("k is: " + k + "v is  : " + v));
    ref.add(userData);
  }

  static Future<bool> updateDetails(name, mail, gender, phone, iAmA) async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('uid', isEqualTo: globals.user.uid)
        .getDocuments();
    String ds = querySnapshot.documents.single.documentID;
    Map<String, String> userData = new Map<String, String>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('gender', () => gender);
    userData.putIfAbsent('phone', () => phone);
    userData.putIfAbsent('profession', () => iAmA);
    userData
        .forEach((String k, String v) => print("k is: " + k + "v is  : " + v));
    var ref = firestore.collection('users').document(ds).updateData(userData);
  }

  static Future<List<Question>> getQuestions(String name) async {
    List<Question> ques = new List<Question>();
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('algorithms').where('name', isEqualTo: name);
    QuerySnapshot querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    String ds = documentSnapshot.single.documentID;
    var refe = await firestore
        .collection('algorithms')
        .document(ds)
        .collection('questions')
        .getDocuments();
    List<DocumentSnapshot> data = refe.documents;
    data.forEach((element) {
      Question q = new Question(
          element['name'],
          element['questionNumber'],
          element['option1'],
          element['option2'],
          element['option3'],
          element['option4'],
          element['answer']);
      ques.add(q);
    });
    return ques;
  }

  static void uploadProgress(String algoName, double progress) async {
    Firestore firestore = Firestore.instance;
    print("user id is : " + globals.user.uid);
    var ref =
    firestore.collection('users').where('uid', isEqualTo: globals.user.uid);
    QuerySnapshot querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    String ds = documentSnapshot.single.documentID;
    print("user document is:" + ds);
    ref = firestore
        .collection('users/${ds}/myAlgorithms')
        .where('name', isEqualTo: algoName);
    querySnapshot = await ref.getDocuments();
    documentSnapshot = querySnapshot.documents;
    String algoDs = documentSnapshot.single.documentID;
    print("algo id is:" + ds);
    if (documentSnapshot.single['progress'] < progress) {
      firestore
          .collection('users/${ds}/myAlgorithms')
          .document(algoDs)
          .updateData({
        'progress': progress,
      });
    }
    print("data updated successfully");
  }

  static void addInMine() async {
    Firestore firestore = Firestore.instance;
    print("user id is : " + globals.user.uid);
    var ref =
    firestore.collection('users').where('uid', isEqualTo: globals.user.uid);
    QuerySnapshot querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    String ds = documentSnapshot.single.documentID;
    print("user document is:" + ds);
    print(globals.selectedAlgo.category);
    Map<String, dynamic> algo = new Map<String, dynamic>();
    algo.putIfAbsent('name', () => globals.selectedAlgo.name);
    algo.putIfAbsent('category', () => globals.selectedAlgo.category);
    algo.putIfAbsent('content', () => globals.selectedAlgo.content);
    algo.putIfAbsent('implInJava', () => globals.selectedAlgo.implInJava);
    algo.putIfAbsent('implInPython', () => globals.selectedAlgo.implInPython);
    algo.putIfAbsent('difficulty', () => globals.selectedAlgo.difficulty);
    algo.putIfAbsent('imageUrl', () => globals.selectedAlgo.imageUrl);
    algo.putIfAbsent('progress', () => globals.selectedAlgo.progress);
    await _checkAlgoInMine(globals.selectedAlgo.name, ds);
    if (_check) {
      firestore.collection('users/${ds}/myAlgorithms').add(algo);
    }
  }

  static Future<bool> _checkAlgoInMine(name, userId) async {
    Firestore firestore = Firestore.instance;
    print("user id is : " + globals.user.uid);
    var ref = firestore
        .collection('users/${userId}/myAlgorithms')
        .where('name', isEqualTo: name);
    QuerySnapshot querySnapshot = await ref.getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    _check = (documentSnapshot.length == 0);
    return false;
  }

  static var httpClient = new HttpClient();

  static Future<List<String>> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    List<String> data = [];
    await rootBundle.loadString('$dir/$filename').then((q) {
      for (String i in LineSplitter().convert(q)) {
        data.add(i);
      }
    });
    // print(data);
    return data;
  }

  static Future<void> readFileJava(String url, String name) async {
    globals.i1.clear();
    globals.i1 = await _downloadFile(url, "Java" + name);
  }

  static Future<void> readFilePython(String url, String name) async {
    globals.i2.clear();
    globals.i2 = await _downloadFile(url, "Python" + name);
  }
}
