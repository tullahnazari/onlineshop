import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:halalbazaar/helper/calls_messaging_service.dart';
import 'package:halalbazaar/helper/service_locater.dart';
import 'package:provider/provider.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/screens/sweepstakes_detail.dart';

class SweepstakeItems extends StatelessWidget {
  final String id;
  final String title;
  final List image;
  final String price;

  SweepstakeItems({this.id, this.title, this.image, this.price});

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    final productCount = Provider.of<GreatPlaces>(context, listen: false);
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      leading: Container(
        height: 100,
        width: 100,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: image.first,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),

      title: Text(
        title,
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text(
        '\$$price',
        style: TextStyle(fontSize: 18),
      ),
      trailing:
          // Container(
          //   width: 100,
          //   child: Row(
          //     children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   // onPressed: () {
          //   //   Navigator.of(context).pushNamed(
          //   //       AddingSweepstake.routeName,
          //   //       arguments: id);
          //   // },
          //   color: Theme.of(context).primaryColor,
          // ),
          IconButton(
        iconSize: 30,
        icon: Icon(Icons.delete),
        onPressed: () async {
          var descriptionCount = await productCount.getDescriptionValue();
          if (descriptionCount > 0) {
            Flushbar(
              title:
                  "Sorry, you can't perform this action because you have been reported",
              message:
                  "If you think this is by error, please reach out to Halal Bazaar by clicking send email and we will respond in 24 hours",
              duration: Duration(seconds: 10),
              mainButton: FlatButton(
                onPressed: () {
                  _service.sendEmail("affordableapps4u@gmail.com");
                },
                child: Text(
                  "Send Email",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 14),
                ),
              ),
            )..show(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => FancyDialog(
                ok: 'Delete',
                title: "We just want to confirm",
                descreption: "Are you sure you want to delete this posting?",
                animationType: FancyAnimation.BOTTOM_TOP,
                theme: FancyTheme.FANCY,
                gifPath: FancyGif.MOVE_FORWARD, //'./assets/walp.png',
                okFun: () => {
                  Provider.of<GreatPlaces>(context, listen: false)
                      .deleteProduct(id)
                },
              ),
            );
          }
        },
        color: Theme.of(context).errorColor,
      ),
      //    ],
      //  ),
      //   ),
    );
    // return GridTile(
    //   child: Image.network(imageUrl),
    //   header: Text(
    //     title,
    //     style: TextStyle(
    //       backgroundColor: Colors.white60,
    //       color: Colors.black,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'Lato',
    //     ),
    //     textAlign: TextAlign.right,
    //   ),
    //   footer: Text(
    //     price.toString(),
    //     style: TextStyle(
    //       backgroundColor: Colors.white60,
    //       color: Colors.black,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'Lato',
    //     ),
    //     textAlign: TextAlign.right,
    //   ),
    // );
    // return Column(
    //   children: <Widget>[
    //     SizedBox(
    //       height: 20,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.of(context)
    //             .pushNamed(SweepstakesDetail.routeName, arguments: id);
    //       },
    //       child: Card(
    //         child: Image.network(
    //           imageUrl,
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 5,
    //     ),
    //     Row(
    //       children: <Widget>[
    //         Icon(Icons.timer),
    //         SizedBox(
    //           width: 3,
    //         ),
    //         Text('ends ${dateTime}', style: TextStyle(fontSize: 18)),
    //         Spacer(),
    //         Text(
    //           title,
    //           style: TextStyle(fontSize: 18),
    //           textAlign: TextAlign.right,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
