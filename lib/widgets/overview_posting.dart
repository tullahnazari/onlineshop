import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';

class OverviewPosting extends StatelessWidget {
  final String id;
  final String title;
  final File image;
  final String address;

  OverviewPosting({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      //leading: FileImage(image),
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(1.0), BlendMode.dstATop),
            image: FileImage(image ?? ''),
            fit: BoxFit.contain,
          ),
        ),
      ),
      header: Text(
        title,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      footer: Text(
        address,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
    );
  }
}
