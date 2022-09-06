import 'package:workcafe/data-source/firebase-data-source.dart';

class MapRepository {
  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  Future<Object>  readCafeList() async {
    var response = await _firebaseDataSource.getFromFirebase("cafe-list");
    return response;
  }
}