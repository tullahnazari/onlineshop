import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:halalbazaar/models/place.dart';
import 'package:halalbazaar/screens/sweepstakes_detail.dart';

class OverviewPosting extends StatelessWidget {
  final String id;
  final String title;
  final List image;
  final String address;

  OverviewPosting({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    final place = Provider.of<Place>(context, listen: false);
    String price = place.price.toString();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              SweepstakesDetail.routeName,
              arguments: id,
            );
          },
          child: GridTile(
            footer: Material(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                  top: Radius.circular(8),
                ),
              ),
              color: Colors.grey,
              clipBehavior: Clip.antiAlias,
              child: GridTileBar(
                backgroundColor: Colors.black87,
                title: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  '\$$price',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                  ),
                ),

                // child: GridTileBar(
                //   backgroundColor: Colors.black45,
                //   title: Text(
                //     title ?? '',
                //     style: TextStyle(fontSize: 22),
                //   ),
                //   subtitle: Text(
                //     '\$$price' ?? '',
                //     style: TextStyle(fontSize: 22),
                //   ),
                //   trailing: IconButton(
                //     iconSize: 50,
                //     // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                //     icon: FaIcon(FontAwesomeIcons.arrowCircleRight),
                //     onPressed: () {
                //       Navigator.of(context).pushNamed(
                //         SweepstakesDetail.routeName,
                //         arguments: id,
                //       );
                //     },
                //   ),
                // ),
              ),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: image.first,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
