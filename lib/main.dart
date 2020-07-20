import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halalbazaar/screens/eula.dart';
import 'package:halalbazaar/screens/report_posting.dart';
import 'package:native_state/native_state.dart';
import 'package:provider/provider.dart';
import 'package:halalbazaar/helper/service_locater.dart';
import 'package:halalbazaar/models/place.dart';
import 'package:halalbazaar/models/result.dart';
import 'package:halalbazaar/models/user_location.dart';
import 'package:halalbazaar/providers/auth.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/providers/location_service.dart';
import 'package:halalbazaar/providers/results.dart';
import 'package:halalbazaar/providers/sweepstakes.dart';
import 'package:halalbazaar/screens/add_place_screen.dart';

import 'package:halalbazaar/screens/auth-screen.dart';
import 'package:halalbazaar/screens/location_page.dart';
import 'package:halalbazaar/screens/spash_screen.dart';
import 'package:halalbazaar/screens/sweepstake_management.dart';
import 'package:halalbazaar/screens/sweepstakes_detail.dart';
import 'package:halalbazaar/screens/sweepstakes_overview.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        Future.delayed(const Duration(seconds: 8), () {
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              strokeWidth: 6,
            ),
          );
        });
      } else if (_previousResult == ConnectivityResult.none) {
        nav.currentState.push(MaterialPageRoute(
            builder: (BuildContext _) => SweepstakesOverview()));
      }

      _previousResult = connectivityResult;
    });
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //ability to add multiple providers at root of app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Sweepstakes>(
          update: (ctx, auth, previousProducts) => Sweepstakes(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Results>(
          update: (ctx, auth, previousOrders) => Results(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, GreatPlaces>(
          update: (ctx, auth, previousPosts) => GreatPlaces(
            auth.token,
            auth.userId,
            previousPosts == null ? [] : previousPosts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: ResultItem(),
        ),
        ChangeNotifierProvider.value(
          value: UserLocation(),
        ),
        ChangeNotifierProvider.value(
          value: LocationService(),
        ),
        ChangeNotifierProvider.value(
          value: Place(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          navigatorKey: nav,
          title: 'Halal Bazaar',
          theme: ThemeData(
            primaryColor: Colors.teal,
            accentColor: Colors.white,
            fontFamily: 'Lato',
          ),
          // home: SweepstakesOverview(),

          // /fix after landing page is finished
          home: auth.isAuth
              ? SweepstakesOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SweepstakesOverview()
                          : AuthScreen(),
                ),
          routes: {
            SweepstakesDetail.routeName: (ctx) => SweepstakesDetail(),
            SweepstakeManagement.routeName: (ctx) => SweepstakeManagement(),
            SweepstakesOverview.routeName: (ctx) => SweepstakesOverview(),
            LocationPage.routeName: (ctx) => LocationPage(),
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            ReportListing.routeName: (ctx) => ReportListing(),
            EULA.routeName: (ctx) => EULA(),
          },
        ),
      ),
    );
  }
}
