import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workcafe/models/cafe-info.dart';
import 'package:workcafe/repository/bookmark-repository.dart';
import '../viewModel/map-provider.dart';
import 'bookmark-list-screen.dart';
import 'request-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MapProvider mapProvider;
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;
  final LocationTrackingMode _trackingMode = LocationTrackingMode.NoFollow;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Provider.of<MapProvider>(context,listen: false).init();
      setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mapProvider = Provider.of<MapProvider>(context,listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "WorkAt",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkListScreen()));
                },
                icon: Icon(
                  Icons.bookmark_border,
                  color: Color(0xFF000000),
                  size: 30,
                )
            ),
          ], systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          alignment: Alignment.center,
          child: NaverMap(
              initialCameraPosition: CameraPosition(
                target: mapProvider.currentPosition,
                zoom: 16,
              ),
              onMapCreated: onMapCreated,
              mapType: _mapType,
              initLocationTrackingMode: _trackingMode,
              locationButtonEnable: true,
              indoorEnable: true,
              onCameraChange: _onCameraChange,
              onCameraIdle: _onCameraIdle,
              onMapTap: (_) {
                FocusScope.of(context).unfocus();
              },
              onMapLongTap: _onMapLongTap,
              onMapDoubleTap: _onMapDoubleTap,
              onMapTwoFingerTap: _onMapTwoFingerTap,
              maxZoom: 17,
              minZoom: 10,
              useSurface: kReleaseMode,
              logoClickEnabled: true,
              markers: mapProvider.cafeList.map((cafeInfo) => Marker(
                  markerId: cafeInfo.cafeId,
                  position: cafeInfo.cafeLocation,
                  onMarkerTab:(_,__) {
                    mapProvider.checkInBookmark(cafeInfo.cafeId);
                    _showDialog(cafeInfo);
                  }
              )).toList()
          )
    ),
    );
  }

  _showDialog(CafeInfo cafeInfo) {
    const weekDayList = ['월','화','수','목','금','토','일'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.bottomCenter,
          insetPadding: EdgeInsets.all(16),
          child: Container(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RequestScreen(cafeName: cafeInfo.cafeName,))),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFAAAAAA),
                                      width: 0.5
                                  )
                              )
                          ),
                          child: Text(
                            "정보 수정 요청",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFDDDDDD),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => mapProvider.toggleBookmarked(cafeInfo),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Provider.of<MapProvider>(context).bookmarked? Icons.bookmark : Icons.bookmark_border,
                            color: Color(0xFF000000),
                            size: 26,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => launchUrl(Uri.parse("https://search.naver.com/search.naver?query=${cafeInfo.cafeName}&nso=&where=blog")),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:[
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0,4)
                        )
                      ]
                    ),
                    height: 110,
                    width: MediaQuery.of(context).size.width - 32,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: NetworkImage(cafeInfo.cafeMainImgUrl),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        cafeInfo.cafeName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Color(0xFF000000)
                                        ),
                                      ),
                                      Text(
                                        " ${cafeInfo.cafeType}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xFF727272)
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      /*
                                        Icon(Icons.star,color: Color(0xFF0F96FF),size: 14,),
                                        Text(
                                          "4.5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Color(0xFF000000)
                                          ),
                                        ),
                                        Text(
                                          "(3)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Color(0xFF727272)
                                          ),
                                        ),
                                   */
                                        Text(
                                          "${weekDayList[DateTime.now().weekday-1]}요일 ${cafeInfo.cafeTime[DateTime.now().weekday-1]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Color(0xFF727272)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 152,
                                    child: Wrap(
                                      direction: Axis.horizontal, // 정렬 방향
                                      alignment: WrapAlignment.start,
                                      spacing:5,
                                      runSpacing:5,
                                      children: cafeInfo.cafeStyle.map((cafeStyle) => _tagBox(cafeStyle)).toList()
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tagBox(String text){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        "#$text",
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF0F96FF)
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xFF0F96FF),width: 1)
      ),
    );
  }

  _onMapLongTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapDoubleTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapTwoFingerTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onSymbolTap(LatLng? position, String? caption) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onSymbolTap] caption: $caption, lat: ${position?.latitude}, lon: ${position?.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, index) {
          final type = MapType.values[index];
          String title;
          switch (type) {
            case MapType.Basic:
              title = '기본';
              break;
            case MapType.Navi:
              title = '내비';
              break;
            case MapType.Satellite:
              title = '위성';
              break;
            case MapType.Hybrid:
              title = '위성혼합';
              break;
            case MapType.Terrain:
              title = '지형도';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)]),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  _trackingModeSelector() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: _onTapTakeSnapShot,
        child: Container(
          margin: EdgeInsets.only(right: 16, bottom: 48),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 지도 생성 완료시
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  /// 지도 유형 선택시
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }

  /// my location button
  // void _onTapLocation() async {
  //   final controller = await _controller.future;
  //   controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  // }

  void _onCameraChange(
      LatLng? latLng, CameraChangeReason reason, bool? isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng?.latitude}, ${latLng?.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
  }

  /// 지도 스냅샷
  void _onTapTakeSnapShot() async {
    final controller = await _controller.future;
    controller.takeSnapshot((path) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: path != null
                  ? Image.file(
                File(path),
              )
                  : Text('path is null!'),
              titlePadding: EdgeInsets.zero,
            );
          });
    });
  }
}
