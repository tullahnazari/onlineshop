import 'package:flutter/material.dart';
import 'package:sweepstakes/screens/adding_sweepstakes.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';

class YourSweepstake extends StatelessWidget {
  static const routeName = 'your-sweepstake';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Sweepstakes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
