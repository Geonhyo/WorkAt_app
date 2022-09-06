import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workcafe/models/bookmark-info.dart';
import 'package:workcafe/models/cafe-info.dart';
import 'package:workcafe/repository/bookmark-repository.dart';
import 'package:workcafe/repository/map-repository.dart';

import '../models/failure.dart';
import '../models/success.dart';

class MapProvider with ChangeNotifier {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  bool requestSuccess = false;
  String? _requestError;
  LatLng _currentPosition = LatLng(37.55749746766902, 126.93689280950194);
  final MapRepository _mapRepository = MapRepository();
  List<CafeInfo> _cafeList = [];
  bool _bookmarked = false;


  LatLng get currentPosition => _currentPosition;
  String get requestError => _requestError!;
  List<CafeInfo> get cafeList => _cafeList;
  bool get bookmarked => _bookmarked;

  Future init() async {
    await Geolocator.requestPermission();
    var response = await _mapRepository.readCafeList();
    if(response is Success) {
      requestSuccess = true;
      _requestError = null;
      _cafeList = (response.response as QuerySnapshot<Map<String,dynamic>>).docs.map((queryDocumentSnapshot) => CafeInfo.fromFirestore(queryDocumentSnapshot)).toList();
      notifyListeners();
    }
    if(response is Failure) {
      requestSuccess = false;
      _requestError = response.errorResponse;
      notifyListeners();
    }
  }

  Future<void> checkInBookmark(String cafeInfoId) async {
    _bookmarked = await _bookmarkRepository.checkDB(cafeInfoId);
    notifyListeners();
  }

  Future<void> toggleBookmarked(CafeInfo cafeInfo) async {
    if(_bookmarked){
      await _bookmarkRepository.deleteBookmarkInfo(cafeInfo.cafeId);
      _bookmarked = false;
    }
    else{
      BookmarkInfo bookmarkInfo = BookmarkInfo(cafeId: cafeInfo.cafeId, cafeName: cafeInfo.cafeName);
      await _bookmarkRepository.createBookmarkInfo(bookmarkInfo);
      _bookmarked = true;
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    _currentPosition = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }
}