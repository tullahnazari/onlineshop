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
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(imageUrl),
      ),
      title:
          Text(title, style: TextStyle(color: Theme.of(context).accentColor)),
      subtitle: Text(
        '$price',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context)
            .pushNamed(SweepstakesDetail.routeName, arguments: id);
      },
      selected: true,

      // children: <Widget>[
      //   SizedBox(
      //     height: 20,
      //   ),
      //   GestureDetector(
      //     onTap: () {
      //       Navigator.of(context)
      //           .pushNamed(SweepstakesDetail.routeName, arguments: id);
      //     },
      //     child: Card(
      //       child: Image.network(
      //         imageUrl,
      //       ),
      //     ),
      //   ),
      //   SizedBox(
      //     height: 5,
      //   ),
      //   Row(
      //     children: <Widget>[
      //       Icon(Icons.timer),
      //       SizedBox(
      //         width: 3,
      //       ),
      //       Text('ends ${dateTime}', style: TextStyle(fontSize: 18)),
      //       Spacer(),
      //       Text(
      //         title,
      //         style: TextStyle(fontSize: 18),
      //         textAlign: TextAlign.right,
      //       ),
      //     ],
      //   ),
      // ],
    );
  }
}
