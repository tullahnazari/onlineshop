import 'package:ads/admob.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/diagonal.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/helper/calls_messaging_service.dart';
import 'package:sweepstakes/helper/location_helper.dart';
import 'package:sweepstakes/helper/service_locater.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/models/sweepstake.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/results.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/widgets/animation.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:sweepstakes/widgets/location_input.dart';

class SweepstakesDetail extends StatelessWidget {
  static const routeName = '/sweepstakedetail';

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final posting = Provider.of<Place>(context, listen: false);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedPosting = Provider.of<GreatPlaces>(
      context,
      listen: false,
    ).findById(productId);
    String price = loadedPosting.price.toString();

    _showPreview(double lat, double lng) {
      LocationHelper.generateLocationPreviewImage(
        latitude: lat,
        longitude: lng,
      );
      //return staticMapImageUrl;
    }

    String generateLocationPreviewImage({
      double latitude,
      double longitude,
    }) {
      return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=12&size=600x300&maptype=roadmap&key=$GOOGLE_API_KEY';
    }

    Set<Circle> circles = Set.from([
      Circle(
        //circleId: CircleId(id),
        center: LatLng(
            loadedPosting.location.latitude, loadedPosting.location.longitude),
        radius: 4000,
      )
    ]);

    // GoogleMap(
    //   mapType: MapType.normal,
    //   myLocationEnabled: true,
    //   myLocationButtonEnabled: true,
    //   // initialCameraPosition: initialMapLocation,
    //   // onMapCreated: (GoogleMapController controller) {
    //   //   _controller.complete(controller);
    //   // },
    //   onCameraMove: null,
    //   circles: circles,
    // );

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

    final CarouselSlider autoPlayDemo = CarouselSlider(
      height: height * .75,
      viewportFraction: 0.9,
      aspectRatio: 50 / 45,
      autoPlay: true,
      enlargeCenterPage: true,
      items: loadedPosting.image.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );

    // final topContent = Stack(
    //   children: <Widget>[
    //     Container(
    //         padding: EdgeInsets.only(left: 10.0),
    //         height: MediaQuery.of(context).size.height * 0.65,
    //         decoration: new BoxDecoration(
    //           boxShadow: [
    //             new BoxShadow(
    //               color: Theme.of(context).primaryColor,
    //               offset: new Offset(0.0, 8.0),
    //             )
    //           ],
    //           borderRadius: BorderRadius.circular(20),
    //           image: new DecorationImage(
    //             // image: (loadedPosting.image),
    //             fit: BoxFit.fill,
    //           ),
    //         )),
    //     Container(
    //       height: MediaQuery.of(context).size.height * 0.65,
    //       padding: EdgeInsets.all(40.0),
    //       width: MediaQuery.of(context).size.width,
    //       //decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
    //       child: Center(
    //           //child: topContentText,
    //           ),
    //     ),
    //   ],
    // );

    final bottomContentText = Text(
      loadedPosting.title,
      style: TextStyle(
          fontSize: 34.0,
          color: Theme.of(context).primaryColor,
          fontFamily: 'Lato'),
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
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Lato',
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '\$$price' ?? '',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Lato',
              fontSize: 30),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          height: 200,
          //width: 300,
          child: Image.network(
            generateLocationPreviewImage(
                latitude: loadedPosting.location.latitude,
                longitude: loadedPosting.location.longitude),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Text('For confideniality, Map has a radius'),
        SizedBox(
          height: 20,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     IconButton(
        //         iconSize: 30,
        //         color: Colors.red,
        //         // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
        //         icon: Icon(Icons.report),
        //         onPressed: () {
        //           String affordableAppsEmail = 'affordableapps4u@gmail.com';
        //           _service.sendEmail(affordableAppsEmail);
        //         }),
        //   ],
        // ),
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
      // height: 400,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            description,
            //readButton,
          ],
        ),
      ),
    );

    return Scaffold(
      floatingActionButton: FabCircularMenu(
        ringDiameter: width * 1.0,
        // ringWidth: width * 1.25,
        fabElevation: 30,
        fabSize: 85,
        children: <Widget>[
          IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 50,
              icon: Icon(
                Icons.message,
              ),
              onPressed: () {
                _service.sendSms(loadedPosting.phone);
              }),
          IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 50,
              icon: Icon(
                Icons.call,
              ),
              onPressed: () {
                _service.call(loadedPosting.phone);
              }),
          IconButton(
            color: Theme.of(context).primaryColor,
            iconSize: 50,
            icon: Icon(Icons.email),
            onPressed: () {
              _service.sendEmail(loadedPosting.email);
            },
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.report),
            onPressed: () {
              String affordableAppsEmail = 'affordableapps4u@gmail.com';
              _service.sendEmail(affordableAppsEmail);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[SizedBox(height: 50), autoPlayDemo, bottomContent],
        ),
      ),

      // bottomNavigationBar: FancyBottomNavigation(
      //   tabs: [
      //     TabData(
      //         iconData: Icons.keyboard_arrow_left,
      //         title: "Back",
      //         onclick: () {
      //           Navigator.pop(context);
      //         }),
      //     TabData(
      //         iconData: Icons.email,
      //         title: "Email",
      //         onclick: () {
      //           _service.sendEmail(loadedPosting.email);
      //         }),
      //     TabData(
      //         iconData: Icons.call,
      //         title: "Call/Text",
      //         onclick: () {
      //           _service.call(loadedPosting.phone);
      //         })
      //   ],
      //   onTabChangedListener: (position) {
      //     // setState(() {
      //     //   currentPage = position;
      //     // });
      //   },
      // )
    );
  }
}
