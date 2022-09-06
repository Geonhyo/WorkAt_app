import 'package:workcafe/data-source/firebase-data-source.dart';
import 'package:workcafe/models/request-info.dart';

class RequestRepository {
  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  Future<Object>  postRequest(RequestInfo requestInfo) async {
    var response = await _firebaseDataSource.postToFirebase("request-list",requestInfo.toFirestore());
    return response;
  }
}