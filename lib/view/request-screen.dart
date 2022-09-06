import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcafe/viewModel/request-provider.dart';

import '../viewModel/bookmark-provider.dart';

class RequestScreen extends StatelessWidget {
  late RequestProvider requestProvider;
  final String cafeName;
  RequestScreen({Key? key, required this.cafeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    requestProvider = Provider.of<RequestProvider>(context);
    String requestText = '';
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "정보 수정 요청",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        elevation: 1,
        actions: [
          InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              await requestProvider.uploadRequest(cafeName, requestText);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                "보내기",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F96FF),
                  fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              cafeName,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF000000)
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "수정을 원하는 부분에 대해 작성해주세요",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFFC4C4C4)
                ),
              ),
              onChanged: (value) {
                requestText = value;
              },
              maxLines: null,
            ),
          ),
        ],
      )
    );
  }
}
