import 'package:flutter/material.dart';
import 'package:halalbazaar/models/result.dart';

class ResultItemWidget extends StatefulWidget {
  final ResultItem order;

  ResultItemWidget(this.order);

  @override
  _ResultItemWidget createState() => _ResultItemWidget();
}

class _ResultItemWidget extends State<ResultItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.order.title ?? 'Sweepstake'),
            subtitle: Text(widget.order.randomNumber.toString()),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // if (_expanded)
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          //     height: min(widget.order.products.length * 20.0 + 10, 100),
          //     child: ListView(
          //       children: widget.order.products
          //           .map(
          //             (prod) => Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: <Widget>[
          //                 Text(
          //                   prod.title,
          //                   style: TextStyle(
          //                       fontSize: 18, fontWeight: FontWeight.bold),
          //                 ),
          //                 Text(
          //                   '${prod.quantity} x \$${prod.price}',
          //                   style:
          //                       TextStyle(fontSize: 14, color: Colors.blueGrey),
          //                 ),
          //               ],
          //             ),
          //           )
          //           .toList(),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
