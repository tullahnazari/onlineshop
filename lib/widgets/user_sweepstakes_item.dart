import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/adding_sweepstakes.dart';

class UserSweepstakeItem extends StatelessWidget {
  final String id;
  final String title;
  final File image;
  final String address;

  UserSweepstakeItem({this.id, this.title, this.image, this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: FileImage(image),
      ),
      subtitle: Text(address),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddingSweepstake.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              // onPressed: () {
              //   Provider.of<GreatPlaces>(context, listen: false)
              //       .deleteProduct(id);
              // },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
