import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';

class SweepstakeItems extends StatelessWidget {
  final String id;
  final String title;
  final List image;
  final String price;

  SweepstakeItems({this.id, this.title, this.image, this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          image.first,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('\$$price'),
      trailing:
          // Container(
          //   width: 100,
          //   child: Row(
          //     children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   // onPressed: () {
          //   //   Navigator.of(context).pushNamed(
          //   //       AddingSweepstake.routeName,
          //   //       arguments: id);
          //   // },
          //   color: Theme.of(context).primaryColor,
          // ),
          IconButton(
        iconSize: 30,
        icon: Icon(Icons.delete),
        onPressed: () {
          Provider.of<GreatPlaces>(context, listen: false).deleteProduct(id);
        },
        color: Theme.of(context).errorColor,
      ),
      //    ],
      //  ),
      //   ),
    );
    // return GridTile(
    //   child: Image.network(imageUrl),
    //   header: Text(
    //     title,
    //     style: TextStyle(
    //       backgroundColor: Colors.white60,
    //       color: Colors.black,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'Lato',
    //     ),
    //     textAlign: TextAlign.right,
    //   ),
    //   footer: Text(
    //     price.toString(),
    //     style: TextStyle(
    //       backgroundColor: Colors.white60,
    //       color: Colors.black,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'Lato',
    //     ),
    //     textAlign: TextAlign.right,
    //   ),
    // );
    // return Column(
    //   children: <Widget>[
    //     SizedBox(
    //       height: 20,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.of(context)
    //             .pushNamed(SweepstakesDetail.routeName, arguments: id);
    //       },
    //       child: Card(
    //         child: Image.network(
    //           imageUrl,
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 5,
    //     ),
    //     Row(
    //       children: <Widget>[
    //         Icon(Icons.timer),
    //         SizedBox(
    //           width: 3,
    //         ),
    //         Text('ends ${dateTime}', style: TextStyle(fontSize: 18)),
    //         Spacer(),
    //         Text(
    //           title,
    //           style: TextStyle(fontSize: 18),
    //           textAlign: TextAlign.right,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
