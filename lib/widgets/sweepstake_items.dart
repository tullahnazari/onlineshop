import 'package:flutter/material.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';

class SweepstakeItems extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String dateTime;
  final double price;

  SweepstakeItems(
      {this.id, this.title, this.imageUrl, this.dateTime, this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 24,
                  backgroundColor: Theme.of(context).accentColor,
                  color: Theme.of(context).primaryColor),
            ),
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 24,
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
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
