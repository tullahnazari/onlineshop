import 'dart:io';

import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridTile(
        footer: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              SweepstakesDetail.routeName,
              arguments: place.id,
            );
          },
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(place.title ?? ''),
            subtitle: Text(place.location.address ?? ''),
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
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
