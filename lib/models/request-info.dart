import 'package:cloud_firestore/cloud_firestore.dart';

class RequestInfo {
  RequestInfo({
    required this.cafeName,
    required this.requestText,
    required this.requestDateTime
  });

  final String cafeName;
  final String requestText;
  final DateTime requestDateTime;

  factory RequestInfo.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return RequestInfo(
      cafeName: data['cafe_name']??"error",
      requestText: data['request-text']??"error",
      requestDateTime: data['request-date-time']??"error",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "cafe_name": cafeName,
      "request-text": requestText,
      "request-date-time": requestDateTime,
    };
  }
}