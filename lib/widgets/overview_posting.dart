import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';

class OverviewPosting extends StatelessWidget {
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  // final String id;
  // final String title;
  // final File image;
  // final String address;

  // OverviewPosting({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    final place = Provider.of<Place>(context, listen: false);
    String price = place.price.toString();

    final CarouselSlider autoPlayDemo = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      items: place.image.map(
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

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text('Auto Playing Carousel'),
          autoPlayDemo,
        ],
      ),
    );
    // GridTile(
    //   footer: GestureDetector(
    //     onTap: () {
    //       Navigator.of(context).pushNamed(
    //         SweepstakesDetail.routeName,
    //         arguments: place.id,
    //       );
    //     },
    //     child: GridTileBar(
    //       backgroundColor: Colors.black45,
    //       title: Text(
    //         place.title ?? '',
    //         style: TextStyle(fontSize: 22),
    //       ),
    //       subtitle: Text(
    //         '\$$price' ?? '',
    //         style: TextStyle(fontSize: 22),
    //       ),
    //       trailing: IconButton(
    //         iconSize: 50,
    //         // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
    //         icon: FaIcon(FontAwesomeIcons.arrowCircleRight),
    //         onPressed: () {
    //           Navigator.of(context).pushNamed(
    //             SweepstakesDetail.routeName,
    //             arguments: place.id,
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    //   child: Carousel(images: place.image),
    // ),
  }
}
