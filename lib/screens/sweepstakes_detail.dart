import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/diagonal.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:halalbazaar/screens/report_posting.dart';
import 'package:halalbazaar/screens/sweepstakes_overview.dart';
import 'package:provider/provider.dart';
import 'package:halalbazaar/helper/calls_messaging_service.dart';
import 'package:halalbazaar/helper/location_helper.dart';
import 'package:halalbazaar/helper/service_locater.dart';
import 'package:halalbazaar/models/place.dart';
import 'package:halalbazaar/models/result.dart';
import 'package:halalbazaar/models/sweepstake.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/providers/results.dart';
import 'package:halalbazaar/providers/sweepstakes.dart';
import 'package:halalbazaar/widgets/animation.dart';
import 'package:halalbazaar/widgets/location_input.dart';
import 'package:url_launcher/url_launcher.dart';

class SweepstakesDetail extends StatelessWidget {
  static const routeName = '/sweepstakedetail';

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final posting = Provider.of<Place>(context, listen: false);
    final greatPlaces = Provider.of<GreatPlaces>(
      context,
      listen: false,
    );
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

    blockConfirmationAndNavigate() async {
        greatPlaces.updateDescription(loadedPosting.id).whenComplete(() => Navigator.of(context).pushNamed(
            SweepstakesOverview.routeName,
          ));
                   
    }

    _sendEmail() async {
      final String _email = Uri.encodeFull('mailto:affordableapps4u@gmail.com' +
          '?subject=user ${loadedPosting.id} was reported' +
          '&body=I would like to report the following user ${loadedPosting.creatorId}. Additionally if you would like to add more details about why you are reporting this listing, please describe below. If not, please hit send and we will follow-up within 24 hours.');
      if (await canLaunch(_email)) {
        await launch(_email);
      } else {
        throw "Can't phone that number.";
      }
    }

    Future<void> sendEmail() async {
      final Email email = Email(
          body:
              'I would like to report the following user ${loadedPosting.creatorId}. Additionally if you would like to add more details about why you are reporting this listing, please describe below. If not, please hit send and we will follow-up within 24 hours.',
          subject: '${loadedPosting.id}',
          recipients: ['mailto:affordableapps4u@gmail.com']);
      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
      } catch (error) {
        error.toString();
        Flushbar(
          title: "Uh-oh",
          message: "We ran into an error while trying to report",
          duration: Duration(seconds: 5),
        )..show(context);
      }
    }

    String generateLocationPreviewImage({
      double latitude,
      double longitude,
    }) {
      return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=12&size=600x300&maptype=roadmap&key=$GOOGLE_API_KEY';
    }

    Widget _detectWidget() {
      if (Platform.isAndroid) {
        // Return here any Widget you want to display in Android Device.
        return IconButton(
            color: Theme.of(context).primaryColor,
            iconSize: 50,
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            });
      } else if (Platform.isIOS) {
        // Return here any Widget you want to display in iOS Device.
        return IconButton(
            color: Theme.of(context).primaryColor,
            iconSize: 50,
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            });
      }
    }

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
      pauseAutoPlayOnTouch: Duration(seconds: 50),
      height: height * .85,
      viewportFraction: 1.0,
      aspectRatio: 1.85 / 1,
      autoPlay: true,
      enlargeCenterPage: true,
      items: loadedPosting.image.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: CachedNetworkImage(
                imageUrl: url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                  value: downloadProgress.progress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        },
      ).toList(),
    );

    Future<void> _saveRecord() async {
      // List blockedList = [];
      // String blockedId = loadedPosting.creatorId;
      // blockedList.add(blockedId);
      await Provider.of<GreatPlaces>(context, listen: false)
          .getDescriptionValue();
    }

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

    final bottomContentText = Center(
      child: Text(
        loadedPosting.title,
        style: TextStyle(
            fontSize: 34.0,
            color: Theme.of(context).primaryColor,
            fontFamily: 'Lato'),
      ),
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
        Center(
          child: Text(
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
        Text(loadedPosting.address),
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
          height: 100,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: width * .4,
              child: ButtonTheme(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                
                buttonColor: Theme.of(context).primaryColor,
                height: height * .05,
                
                        child: Flexible(
                                                  child: RaisedButton(
                          
                  
                    child: Text('Report Posting', style: TextStyle(color: Theme.of(context).secondaryHeaderColor), textAlign: TextAlign.center,),
                    onPressed: () {
                      if (Platform.isIOS) {
                          sendEmail();
                      } else {
                          sendEmail();
                      }
                    }),
                        ),
              ),
            ),
          
        
        Container(
          width: width * .4,
          child: ButtonTheme(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            buttonColor: Theme.of(context).primaryColor,
            height: height * .05,
                    child: Flexible(
                                          child: RaisedButton(
                child: Text('Block User', style: TextStyle(color: Theme.of(context).secondaryHeaderColor), textAlign: TextAlign.center,),
                onPressed: () {
                  
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => FancyDialog(
                      ok: 'Delete',
                      title: "We just want to confirm",
                      descreption: "Are you sure you want to block this user?",
                      animationType: FancyAnimation.BOTTOM_TOP,
                      theme: FancyTheme.FANCY,
                      gifPath: FancyGif.MOVE_FORWARD, //'./assets/walp.png',
                      okFun: () => {
                        blockConfirmationAndNavigate(),
                        
                      },
                  ),
                );
                  
                }),
                    ),
          ),
        ),
          ],),
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
        fabOpenColor: Theme.of(context).accentColor,
        ringDiameter: width * 1.0,
        // ringWidth: width * 1.25,
        fabElevation: 30,
        fabSize: 85,
        children: <Widget>[
          _detectWidget(),
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
