import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:halalbazaar/screens/sweepstake_management.dart';
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

  GreatPlaces postings;

  Place place;

  List<Permission> lp = Permission.values;

  List<int> data = [];
  int currentLength = 0;

  final int increment = 10;

  @override
  void initState() {
    super.initState();
    getDeviceLocationPermission();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    switch (_category) {
      case "Vehicles":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndVehicles(value);
          });

          break;
        }

      case "default":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByState(value);
          });
        }
        break;

      case "Electronics":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndElectronics(value);
          });

          break;
        }
        break;
      case "Home & Tools":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndHomeapp(value);
          });

          break;
        }
      case "Jobs & Services":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndJobsservice(value);
          });

          break;
        }
      case "Clothes":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndCommunitygatherings(value);
          });

          break;
        }
      case "Food & Grocery":
        {
          getUserLocation().then((value) {
            Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndFood(value);
          });

          break;
        }
      case "Community Gatherings":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndCommunitygatherings(value);
          });

          break;
        }
      case "Wanted":
        {
          await getUserLocation().then((value) async {
            await Provider.of<GreatPlaces>(context, listen: false)
                .fetchResultsByStateAndWanted(value);
          });

          break;
        }
      default:
        {
          print("Invalid choice");
        }
        break;
    }
    // if (_category == 'default') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByState(value);
    //   });
    // } else if (_category == 'Vehicles') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndVehicles(value);
    //   });
    // } else if (_category == 'Electronics') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndElectronics(value);
    //   });
    // } else if (_category == 'Home & Tools') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndHomeapp(value);
    //   });
    // } else if (_category == 'Jobs & Services') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndJobsservice(value);
    //   });
    // } else if (_category == 'Clothes') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndClothes(value);
    //   });
    // } else if (_category == 'Toys') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndToys(value);
    //   });
    // } else if (_category == 'Community Gatherings') {
    //   await getUserLocation().then((value) async {
    //     await Provider.of<GreatPlaces>(context, listen: false)
    //         .fetchResultsByStateAndCommunitygatherings(value);
    //   });
    // }
  }

  // Future _loadMore() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // Add in an artificial delay
  //   await new Future.delayed(const Duration(seconds: 2));
  //   for (var i = currentLength; i <= currentLength + increment; i++) {
  //     data.add(i);
  //   }
  //   setState(() {
  //     _isLoading = false;
  //     currentLength = data.length;
  //   });
  // }

  Future _loadMore() async {
    Container(child: Text('you have reached the bottom'));
  }

  bool showAllChecked() {
    if (_category == 'default') {
      return true;
    } else {
      return false;
    }
  }

  bool showElectronics() {
    if (_category == 'Electronics') {
      return true;
    } else {
      return false;
    }
  }

  bool showVehicles() {
    if (_category == 'Vehicles') {
      return true;
    } else {
      return false;
    }
  }

  bool showHomeAppliances() {
    if (_category == 'Home & Tools') {
      return true;
    } else {
      return false;
    }
  }

  bool showJobsService() {
    if (_category == 'Jobs & Services') {
      return true;
    } else {
      return false;
    }
  }

  bool showClothes() {
    if (_category == 'Clothes') {
      return true;
    } else {
      return false;
    }
  }

  bool showToys() {
    if (_category == 'Food & Grocery') {
      return true;
    } else {
      return false;
    }
  }

  bool showCommunityGatherings() {
    if (_category == 'Community Gatherings') {
      return true;
    } else {
      return false;
    }
  }

  bool showWanted() {
    if (_category == 'Wanted') {
      return true;
    } else {
      return false;
    }
  }

  Widget _threeItemPopup() => PopupMenuButton(
        itemBuilder: (context) {
          var list = List<PopupMenuEntry<Object>>();
          list.add(
            PopupMenuItem(
              child: Text('Filter By Category'),
              // value: 1,
            ),
          );
          list.add(
            PopupMenuDivider(
              height: 10,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Show All",
                style: TextStyle(color: Colors.black),
              ),
              value: 1,
              checked: showAllChecked(),
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Electronics",
                style: TextStyle(color: Colors.black),
              ),
              value: 2,
              checked: showElectronics(),
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Vehicles",
                style: TextStyle(color: Colors.black),
              ),
              value: 3,
              checked: showVehicles(),
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Home & Tools",
                style: TextStyle(color: Colors.black),
              ),
              value: 4,
              checked: showHomeAppliances(),
              //checked: false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Jobs & Services",
                style: TextStyle(color: Colors.black),
              ),
              value: 5,
              checked: showJobsService(),
              //checked: false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Clothes",
                style: TextStyle(color: Colors.black),
              ),
              value: 6,
              checked: showClothes(),
              //checked: false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Food & Grocery",
                style: TextStyle(color: Colors.black),
              ),
              value: 7,
              checked: showToys(),
              //checked: false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Community Gatherings",
                style: TextStyle(color: Colors.black),
              ),
              value: 8,
              checked: showCommunityGatherings(),
              //checked: false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: Text(
                "Wanted",
                style: TextStyle(color: Colors.black),
              ),
              value: 9,
              checked: showWanted(),
              //checked: false,
            ),
          );
          return list;
        },
        //initialValue: 1,
        onSelected: (value) {
          if (value == 1) {
            setState(() {
              _category = 'default';
            });
            _refreshProducts(context);
          }
          if (value == 2) {
            setState(() {
              _category = 'Electronics';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 3) {
            setState(() {
              _category = 'Vehicles';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 4) {
            setState(() {
              _category = 'Home & Tools';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 5) {
            setState(() {
              _category = 'Jobs & Services';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 6) {
            setState(() {
              _category = 'Clothes';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 7) {
            setState(() {
              _category = 'Food & Grocery';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 8) {
            setState(() {
              _category = 'Community Gatherings';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
          if (value == 9) {
            setState(() {
              _category = 'Wanted';
              _isLoading = true;
              _refreshProducts(context);
              _isLoading = false;

              print(_category);
            });
          }
        },
        icon: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        // final loadedSweepstakeData = Provider.of<GreatPlaces>(context);
        // final loadedSweepstake = loadedSweepstakeData.items;
        // final userProvider = Provider.of<Auth>(context);

        child: Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              actions: <Widget>[
                _threeItemPopup(),
                // PopupMenuButton(
                //   icon: Icon(Icons.filter_list),
                //   itemBuilder: (_) => [
                //     PopupMenuItem(
                //       child: FlatButton(
                //           child: Text("Show All"),
                //           onPressed: () {
                //             setState(() {
                //               _category = 'default';
                //             });
                //           }),
                //     ),
                //     PopupMenuItem(
                //       child: FlatButton(
                //           child: Text("Show Hose"),
                //           onPressed: () {
                //             setState(() {
                //               _category = 'Hose';
                //               //    _isLoading = true;
                //               _refreshProducts(context);
                //               //  _isLoading = false;

                //               print(_category);
                //             });
                //           }),
                //     ),
                //   ],
                // ),
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
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      // if (snapshot.connectionState == ConnectionState.active &&
                      //     snapshot.hasData) {
                      //   //print('project snapshot data is: ${projectSnap.data}');
                      //   return Container();
                      // }
                      // switch (snapshot.connectionState) {
                      //   case ConnectionState.none:
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         strokeWidth: 6,
                      //       ),
                      //     );
                      //   case ConnectionState.active:
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         strokeWidth: 6,
                      //       ),
                      //     );
                      //   case ConnectionState.waiting:
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         strokeWidth: 6,
                      //       ),
                      //     );
                      //   case ConnectionState.done:
                      // if (snapshot.hasError) {
                      //   return Center(
                      //     child: CircularProgressIndicator(
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       strokeWidth: 6,
                      //     ),
                      //   );
                      // // } else {
                      // if (!snapshot.hasData || snapshot.data == null) {
                      //   return Text('Loading');
                      // }
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.none) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            strokeWidth: 6,
                          ),
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        return LazyLoadScrollView(
                          onEndOfPage: () => _loadMore(),
                          child: RefreshIndicator(
                            displacement: 120,
                            color: Theme.of(context).primaryColor,
                            onRefresh: () => _refreshProducts(context),
                            child: Consumer<GreatPlaces>(
                              builder: (ctx, greatPlaces, _) => Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, bottom: 2, left: 2, right: 2),
                                child: greatPlaces.items.length == 0
                                    ? emptyGrid()
                                    : GridView.builder(
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
                                            address: greatPlaces
                                                .items[i].location.address,
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .50),
                                        ),
                                      ),
                              ),
                              // ),
                            ),
                          ),
                        );
                      }
                    })));
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

  Future<void> _showDialog1(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Results found for this Category near you'),
          content: const Text(
              'You can add a wanted posting for the search criteria so others are aware you are looking for these items. You can also filter by a different category.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SweepstakesOverview(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Container emptyGrid() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "No results found near you. You can add a wanted posting by navigating to your 'Manage Postings' and clicking the + button on the bottom right,",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: width * .4,
                  child: ButtonTheme(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    buttonColor: Theme.of(context).primaryColor,
                    height: height * .05,
                    child: RaisedButton(
                        child: Text(
                          'View All Postings',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              SweepstakesOverview.routeName);
                        }),
                  ),
                ),
                Container(
                  width: width * .4,
                  child: ButtonTheme(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    buttonColor: Theme.of(context).primaryColor,
                    height: height * .05,
                    child: RaisedButton(
                        child: Text(
                          'Go to Manage Postings',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              SweepstakeManagement.routeName);
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
