import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../models/cafe-info.dart';

class CustomMarker extends Marker {
  final CafeInfo cafeInfo;

  CustomMarker({required this.cafeInfo, required super.position, super.width = 30, super.height = 45})
      : super(markerId: cafeInfo.cafeId, captionText: cafeInfo.cafeName);

  factory CustomMarker.fromCafeInfo(cafeInfo) => CustomMarker(cafeInfo: cafeInfo, position: LatLng(cafeInfo.cafeLocation[0],cafeInfo.cafeLocation[1]));

  Future<void> createImage(BuildContext context) async {
    icon = await OverlayImage.fromAssetImage(assetName: "assets/images/location-pin.png");
  }

  void setOnMarkerTab(void Function(Marker? marker, Map<String, int?> iconSize) callBack){
    onMarkerTab = callBack;
  }
}