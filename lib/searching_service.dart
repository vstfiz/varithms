import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  search(String query) {
    return Firestore.instance
        .collection('algorithms')
        .where('key', isEqualTo: query.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
