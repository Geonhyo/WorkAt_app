class BookmarkInfo {
  BookmarkInfo({
   required this.cafeId,
   required this.cafeName,
  });

  String cafeId;
  String cafeName;

  Map<String, dynamic> toMap(){
    return {
      'cafe_id': cafeId,
      'cafe_name': cafeName,
    };
  }
}