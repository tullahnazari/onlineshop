import 'dart:io';

import 'package:flutter/material.dart';

class OverviewPosting extends StatelessWidget {
  final String id;
  final String title;
  final File image;
  final String address;

  OverviewPosting({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridTile(
        footer: GestureDetector(
          onTap: () {},
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(title),
            subtitle: Text(address),
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
              image: FileImage(image ?? ''),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
