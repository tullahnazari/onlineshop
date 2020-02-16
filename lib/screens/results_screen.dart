import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/providers/results.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/sweepstakes_overview.dart';
import 'package:sweepstakes/widgets/result_item.dart';

class ResultScreen extends StatefulWidget {
  //giving page route name
  static const routeName = '/results';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Sweepstake"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Results>(context, listen: false).fetchAndSetResults(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Results>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.items.length,
                  itemBuilder: (ctx, i) => ResultItemWidget(orderData.items[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
