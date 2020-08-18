import 'package:Varithms/algorithm.dart';
import 'package:Varithms/algorithm_type.dart';
import 'package:Varithms/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

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
    QuerySnapshot querySnapshot = await ref.limit(15)
        .getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    for (var doc in ds) {
      Algorithms algorithms = new Algorithms(doc['difficulty'], doc['content'],
          doc['name'], doc['noOfLearners'], doc['imageUrl'], doc['category']);
      globals.algoListForDashboard.add(algorithms);
    }
    return globals.algoListForDashboard;
  }
}
