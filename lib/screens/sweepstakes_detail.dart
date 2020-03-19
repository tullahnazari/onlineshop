import 'package:ads/admob.dart';
import 'package:clippy_flutter/diagonal.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/helper/calls_messaging_service.dart';
import 'package:sweepstakes/helper/service_locater.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/models/sweepstake.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/results.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/results_screen.dart';
import 'package:sweepstakes/widgets/animation.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SweepstakesDetail extends StatelessWidget {
  static const routeName = '/sweepstakedetail';

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    final posting = Provider.of<Place>(context, listen: false);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedPosting = Provider.of<GreatPlaces>(
      context,
      listen: false,
    ).findById(productId);
    String price = loadedPosting.price.toString();

    // final coursePrice = Container(
    //   padding: const EdgeInsets.all(7.0),
    //   decoration: new BoxDecoration(
    //       border: new Border.all(color: Colors.white),
    //       borderRadius: BorderRadius.circular(5.0)),
    //   child: new Text(
    //     "\$" + loadedPosting.title,
    //     style: TextStyle(color: Colors.white),
    //   ),
    // );

    // final topContentText = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     SizedBox(height: 120.0),
    //     Container(
    //       width: 90.0,
    //       child: new Divider(color: Colors.green),
    //     ),
    //     SizedBox(height: 10.0),
    //     Text(
    //       loadedPosting.title,
    //       style: TextStyle(color: Colors.white, fontSize: 45.0),
    //     ),
    //     SizedBox(height: 30.0),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         Expanded(
    //             flex: 6,
    //             child: Padding(
    //                 padding: EdgeInsets.only(left: 10.0),
    //                 child: Text(
    //                   loadedPosting.location.address,
    //                   style: TextStyle(color: Colors.white),
    //                 ))),
    //         Expanded(flex: 1, child: coursePrice)
    //       ],
    //     ),
    //   ],
    // );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: new DecorationImage(
                image: FileImage(loadedPosting.image),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          //decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
              //child: topContentText,
              ),
        ),
      ],
    );

    final bottomContentText = Text(
      loadedPosting.title,
      style: TextStyle(fontSize: 18.0),
    );
    // final backButton = InkWell(
    //   //highlightColor: Colors.black,
    //   onTap: () {
    //     Navigator.pop(context);
    //   },
    //   child: Icon(
    //     Icons.arrow_back,
    //     color: Colors.black,
    //   ),
    // );
    final description = Column(
      children: <Widget>[
        Text(
          loadedPosting.description,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '\$$price' ?? '',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Lato', fontSize: 30),
        ),
      ],
    );
    // final priceText = Text(
    //   '\$$price' ?? '',
    //   style: TextStyle(
    //       color: Theme.of(context).accentColor,
    //       fontFamily: 'Lato',
    //       fontSize: 22),
    // );
    final readButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          //highlightColor: Colors.black,
          onTap: () {
            Navigator.pop(context);
          },
          child: IconButton(
              iconSize: 50,
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(FontAwesomeIcons.arrowCircleLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        SizedBox(
          width: 30,
        ),
        InkWell(
          //highlightColor: Colors.black,
          onTap: () {
            _service.sendEmail(loadedPosting.email);
          },
          child: Icon(
            Icons.email,
            size: 75,
            color: Colors.black,
          ),
        ),
        InkWell(
          //highlightColor: Colors.black,
          onTap: () {
            _service.call(loadedPosting.phone);
          },
          child: IconButton(
              iconSize: 50,
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(FontAwesomeIcons.phone),
              onPressed: () {
                print("Pressed");
              }),
        ),
      ],
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            description,
            readButton,
          ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
