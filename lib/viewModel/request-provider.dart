import 'package:flutter/material.dart';
import 'package:workcafe/models/request-info.dart';
import 'package:workcafe/repository/request-repository.dart';

import '../models/failure.dart';
import '../models/success.dart';

class RequestProvider with ChangeNotifier {
  final RequestRepository _requestRepository = RequestRepository();
  late RequestInfo _requestInfo;
  bool _requestSuccess = false;
  String? _requestError;

  bool get requestSuccess => _requestSuccess;
  String get requestError => _requestError!;

  Future<void> uploadRequest(String cafeName, String requestText) async {
    _requestInfo = RequestInfo(cafeName: cafeName, requestText: requestText, requestDateTime: DateTime.now());
    var response = await _requestRepository.postRequest(_requestInfo);

    if(response is Success) {
      _requestSuccess = true;
      _requestError = null;
    }
    if(response is Failure) {
      _requestSuccess = false;
      _requestError = response.errorResponse;
    }
  }
}