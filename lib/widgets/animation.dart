import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 20.0, height: 100.0),
        Text(
          "TO WIN:",
          style: TextStyle(fontSize: 33.0, color: Color(0xffFFFFFF)),
        ),
        SizedBox(width: 10.0, height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotateAnimatedTextKit(
              text: [
                "CLICK TO ENTER BELOW",
                "   DRAWING IS 9PM CST",
                "           GOOD LUCK!"
              ],
              textStyle: TextStyle(
                  fontSize: 33.0,
                  fontFamily: "Horizon",
                  color: Color(0xffFFFFFF)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
