import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/failure.dart';
import '../models/success.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Object> getFromFirebase(String collectionId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    try{
      querySnapshot = await FirebaseFirestore.instance.collection(collectionId).get();
      return Success(response: querySnapshot);
    }catch (e) {
      return Failure(code: 400, errorResponse: "로드에 실패했습니다");
    }
  }

  Future<Object> postToFirebase(String collectionId, Map<String, dynamic> inputData) async {
    try{
      await FirebaseFirestore.instance.collection(collectionId).add(inputData);
      return Success(response: '성공');
    }catch (e) {
      return Failure(code: 400, errorResponse: "업로드에 실패했습니다");
    }
  }
}