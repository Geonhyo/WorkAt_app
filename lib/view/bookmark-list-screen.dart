import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/bookmark-provider.dart';

class BookmarkListScreen extends StatefulWidget {
  const BookmarkListScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  late BookMarkProvider bookMarkProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Provider.of<BookMarkProvider>(context,listen: false).init();
      setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bookMarkProvider = Provider.of<BookMarkProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "즐겨찾기 ",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            Text(
              "(${bookMarkProvider.bookmarkList.length})",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: bookMarkProvider.bookmarkList.length,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, idx) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 0.5
                      )
                  )
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    bookMarkProvider.bookmarkList[idx].cafeName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () => Provider.of<BookMarkProvider>(context,listen: false).deleteBookmark(bookMarkProvider.bookmarkList[idx].cafeId),
                    child: Text(
                      '삭제',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: Color(0xFF727272)
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      )
    );
  }
}
