import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweepstakes/helper/location_helper.dart';
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
  Position currentLocation;

  // @override
  // void initState() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<GreatPlaces>(context, listen: false)
  //         .fetchResultsByState()
  //         .then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   super.initState();
  // }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<GreatPlaces>(context, listen: false)
        .fetchResultsByState();
  }

  @override
  Widget build(BuildContext context) {
    // final loadedSweepstakeData = Provider.of<GreatPlaces>(context);
    // final loadedSweepstake = loadedSweepstakeData.items;
    // final userProvider = Provider.of<Auth>(context);

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
              PopupMenuItem(
                child: FlatButton(
                    child: Text("state"),
                    onPressed: () async {
                      //await getLocation();
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
          : FutureBuilder(
              future: _refreshProducts(context),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<GreatPlaces>(
                        builder: (ctx, greatPlaces, _) => Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 5, right: 5),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (ctx, i) => OverviewPosting(
                              id: greatPlaces.items[i].id,
                              title: greatPlaces.items[i].title,
                              image: greatPlaces.items[i].image,
                              address: greatPlaces.items[i].location.address,
                            ),
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              // childAspectRatio: MediaQuery.of(context).size.width /
                              //     (MediaQuery.of(context).size.height / 4),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getUserLocation() async {
    currentLocation = await locateUser();
    var lat = currentLocation.latitude;
    var long = currentLocation.longitude;
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, long);
    String state = placemark.first.administrativeArea;
    print(state);
    return state;
  }
}
