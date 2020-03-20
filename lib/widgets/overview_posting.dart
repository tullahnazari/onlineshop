import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';

class OverviewPosting extends StatelessWidget {
  // final String id;
  // final String title;
  // final File image;
  // final String address;

  // OverviewPosting({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    final place = Provider.of<Place>(context, listen: false);
    String price = place.price.toString();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridTile(
        footer: GestureDetector(
          onTap: () {},
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              place.title ?? '',
              style: TextStyle(fontSize: 24),
            ),
            subtitle: Text(
              '\$$price' ?? '',
              style: TextStyle(fontSize: 24),
            ),
            trailing: IconButton(
              iconSize: 50,
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(FontAwesomeIcons.arrowCircleRight),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  SweepstakesDetail.routeName,
                  arguments: place.id,
                );
              },
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(1.0), BlendMode.dstATop),
              image: FileImage(place.image ?? ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
