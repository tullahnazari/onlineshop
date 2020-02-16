import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 30,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 20.0,
              padding: EdgeInsets.only(left: 28, right: 28, top: 15),
              icon: Icon(Icons.home),
              onPressed: () {
                // setState(() {
                //   //_myPage.jumpToPage(0);
                // });
              },
            ),
            IconButton(
              iconSize: 20.0,
              padding: EdgeInsets.only(left: 28, right: 28, top: 15),
              icon: Icon(Icons.search),
              onPressed: () {
                // setState(() {
                //   // _myPage.jumpToPage(1);
                // });
              },
            ),
            IconButton(
              iconSize: 20.0,
              padding: EdgeInsets.only(left: 28, right: 28, top: 15),
              icon: Icon(Icons.mail),
              onPressed: () {
                // setState(() {
                //   // _myPage.jumpToPage(3);
                // });
              },
            ),
            IconButton(
              iconSize: 20.0,
              padding: EdgeInsets.only(left: 28, right: 28, top: 15),
              icon: Icon(Icons.notifications),
              onPressed: () {
                // setState(() {
                //   // _myPage.jumpToPage(2);
                // });
              },
            ),
            IconButton(
              iconSize: 20.0,
              padding: EdgeInsets.only(left: 28, right: 28, top: 15),
              icon: Icon(Icons.list),
              onPressed: () {
                // setState(() {
                //   // _myPage.jumpToPage(3);
                // });
              },
            )
          ],
        ),
      ),
    );
  }
}
