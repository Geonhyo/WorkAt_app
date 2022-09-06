import 'package:flutter/material.dart';
import 'package:workcafe/models/bookmark-info.dart';
import 'package:workcafe/repository/bookmark-repository.dart';

class BookMarkProvider with ChangeNotifier {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  List<BookmarkInfo> _bookmarkList = [];

  List<BookmarkInfo> get bookmarkList => _bookmarkList;

  Future init() async {
    _bookmarkList = await _bookmarkRepository.readBookmarkList();
    notifyListeners();
  }

  Future<void> deleteBookmark(String cafeId) async {
    _bookmarkList.removeWhere((bookmarkInfo) => bookmarkInfo.cafeId == cafeId);
    await _bookmarkRepository.deleteBookmarkInfo(cafeId);
    notifyListeners();
  }
}