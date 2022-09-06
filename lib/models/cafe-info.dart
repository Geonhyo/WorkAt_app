import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class CafeInfo{
  CafeInfo({
    required this.cafeId,
    required this.cafeName,
    required this.cafeMainImgUrl,
    required this.cafeLocation,
    required this.cafeType,
    required this.cafeTime,
    required this.cafeStyle,
  });

  String cafeId;
  String cafeName;
  String cafeMainImgUrl;
  LatLng cafeLocation;
  String cafeType;
  List<String> cafeTime;
  List<String> cafeStyle;
  // https://search.naver.com/search.naver?query=온더플랜커피랩&nso=&where=blog

  factory CafeInfo.fromJson(Map<String, dynamic> json) => CafeInfo(
    cafeId: json["cafe_id"],
    cafeName: json["cafe_name"],
    cafeMainImgUrl:json["cafe_main_img_url"],
    cafeLocation: LatLng(List<double>.from(json["cafe_location"])[0],List<double>.from(json["cafe_location"])[1],),
    cafeType: json["cafe_type"],
    cafeTime: List<String>.from(json["cafe_time"]),
    cafeStyle: List<String>.from(json["cafe_style"]),
  );

  factory CafeInfo.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CafeInfo(
      cafeId: snapshot.id,
      cafeName: data['cafe_name']??"error",
      cafeMainImgUrl: data['cafe_main_img_url']??"error",
      cafeLocation: LatLng(data['cafe_location'][0]??0,data['cafe_location'][1]??0,),
      cafeType: data['cafe_type']??"error",
      cafeTime: List<String>.from(data['cafe_time']??["error"]),
      cafeStyle: List<String>.from(data['cafe_style']??["error"]),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "cafe_name": cafeName,
      "cafe_main_img_url": cafeMainImgUrl,
      "cafe_location": [cafeLocation.latitude,cafeLocation.longitude],
      "cafe_type": cafeType,
      "cafe_time": cafeTime,
      "cafe_style": cafeStyle,
    };
  }
}