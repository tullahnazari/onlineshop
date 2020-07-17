import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:halalbazaar/helper/location_helper.dart';
import 'package:halalbazaar/models/place.dart';
import 'package:halalbazaar/models/user_location.dart';
import 'package:halalbazaar/providers/auth.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/screens/add_place_screen.dart';
import 'package:http/http.dart' as http;
import 'package:halalbazaar/widgets/app_drawer.dart';
import 'package:halalbazaar/widgets/overview_posting.dart';
import 'package:halalbazaar/widgets/sweepstake_items.dart';

class SweepstakesOverview extends StatefulWidget {
  static const routeName = '/sweepstakeoverview';

  @override
  _SweepstakesOverviewState createState() => _SweepstakesOverviewState();
}

class _SweepstakesOverviewState extends State<SweepstakesOverview> {
  var _isLoading = false;

  var _isInit = true;

  var _category = 'default';

  Position currentLocation;

  var value;

  Place place;

  List<Permission> lp = Permission.values;

  @override
  void initState() {
    super.initState();
    getDeviceLocationPermission();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    if (_category == 'default') {
      await getUserLocation().then((value) async {
        await Provider.of<GreatPlaces>(context, listen: false)
            .fetchResultsByState(value);
      });
    } else if (_category == 'Hose') {
      _isLoading = true;
      await getUserLocation().then((value) async {
        await Provider.of<GreatPlaces>(context, listen: false)
            .fetchResultsByStateAndVehicles(value);
        _isLoading = false;
      });
    }
  }

  Future _loadMore() async {
    Container(child: Text('you have reached the bottom'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      // final loadedSweepstakeData = Provider.of<GreatPlaces>(context);
      // final loadedSweepstake = loadedSweepstakeData.items;
      // final userProvider = Provider.of<Auth>(context);
      //final productCount = Provider.of<GreatPlaces>(context, listen: false);
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: FlatButton(
                      child: Text("Show All"),
                      onPressed: () {
                        setState(() {
                          _category = 'default';
                        });
                      }),
                ),
                PopupMenuItem(
                  child: FlatButton(
                      child: Text("Show Hose"),
                      onPressed: () {
                        setState(() {
                          _category = 'Hose';
                          _refreshProducts(context);

                          print(_category);
                        });
                      }),
                ),
              ],
            ),
          ],
          title: Text(
            'Near you',
            style: TextStyle(
                color: Theme.of(context).accentColor, fontFamily: 'Lato'),
            textAlign: TextAlign.center,
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: FloatingActionButton(
        //   tooltip: 'Add A Posting',
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () async {
        //     var order = await productCount.getCount();
        //     if (order > 4) {
        //       Flushbar(
        //         title: "Ohhh Shucks...",
        //         message:
        //             "You can only have 5 active postings, please delete inactive or dated posts ",
        //         duration: Duration(seconds: 5),
        //       )..show(context);
        //     } else {
        //       Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
        //     }
        //   },
        //   child: Icon(
        //     FontAwesomeIcons.plus,
        //     size: 30,
        //     color: Theme.of(context).accentColor,
        //   ),
        // ),
        // bottomNavigationBar: BottomBar(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : FutureBuilder(
                future: _refreshProducts(context),
                builder: (ctx, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          strokeWidth: 6,
                        ),
                      );
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          strokeWidth: 6,
                        ),
                      );
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          strokeWidth: 6,
                        ),
                      );
                    case ConnectionState.done:
                      // if (snapshot.hasError) {
                      //   return Center(
                      //     child: CircularProgressIndicator(
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       strokeWidth: 6,
                      //     ),
                      //   );
                      // } else {
                      return LazyLoadScrollView(
                        onEndOfPage: () => _loadMore(),
                        scrollOffset: 10,
                        child: RefreshIndicator(
                          displacement: 120,
                          color: Theme.of(context).primaryColor,
                          onRefresh: () => _refreshProducts(context),
                          child: Consumer<GreatPlaces>(
                            builder: (ctx, greatPlaces, _) => Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 2, left: 2, right: 2),
                              child: GridView.builder(
                                // padding: const EdgeInsets.all(8),
                                //padding: const EdgeInsets.all(10.0),
                                itemCount: greatPlaces.items.length,
                                itemBuilder: (ctx, i) =>
                                    ChangeNotifierProvider.value(
                                  // builder: (c) => products[i],
                                  value: greatPlaces.items[i],
                                  child: OverviewPosting(
                                    id: greatPlaces.items[i].id,
                                    title: greatPlaces.items[i].title,
                                    image: greatPlaces.items[i].image,
                                    address:
                                        greatPlaces.items[i].location.address,
                                  ),
                                ),
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  //childAspectRatio: 1,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              .50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    //   );
                  }
                }
                //      },
                ),
      ),
    );
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<PermissionStatus> getDeviceLocationPermission() async {
    Permission _permission = lp.elementAt(5); // 5 = location in use permission

    print(_permission);

    final PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;

    if (permissionStatus != PermissionStatus.granted) {
      await Permission.locationWhenInUse.request();
    }

    return permissionStatus;
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    var lat = currentLocation.latitude;
    var lng = currentLocation.longitude;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    var addressBody = response.body;
    List<dynamic> addressComponents =
        json.decode(addressBody)['results'][0]['address_components'];

    String address = addressComponents.firstWhere((entry) =>
        entry['types'].contains('administrative_area_level_1'))['long_name'];
    print(address);
    return address;
  }
}
