import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/models/user_location.dart';
import 'package:sweepstakes/providers/auth.dart';
import 'package:sweepstakes/providers/great_places.dart';

import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:sweepstakes/widgets/overview_posting.dart';
import 'package:sweepstakes/widgets/sweepstake_items.dart';

class SweepstakesOverview extends StatefulWidget {
  static const routeName = '/sweepstakeoverview';

  @override
  _SweepstakesOverviewState createState() => _SweepstakesOverviewState();
}

class _SweepstakesOverviewState extends State<SweepstakesOverview> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<GreatPlaces>(context, listen: false)
          .fetchAndSetPlaces()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadedSweepstakeData = Provider.of<GreatPlaces>(context);
    final loadedSweepstake = loadedSweepstakeData.items;
    final userProvider = Provider.of<Auth>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          Icon(Icons.search),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: FlatButton(
                    child: Text("Logout"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    }),
              ),
            ],
          ),
        ],
        title: Text(
          'Near you',
          style: TextStyle(
              color: Theme.of(context).accentColor, fontFamily: 'Lato'),
        ),
      ),
      // bottomNavigationBar: BottomBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: loadedSweepstake.length,
                itemBuilder: (ctx, i) => OverviewPosting(
                  id: loadedSweepstake[i].id,
                  title: loadedSweepstake[i].title,
                  image: loadedSweepstake[i].image,
                  address: loadedSweepstake[i].location.address,
                ),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  // childAspectRatio: MediaQuery.of(context).size.width /
                  //     (MediaQuery.of(context).size.height / 4),
                ),
              ),
            ),
    );
  }
}
