import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/helper/service_locater.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/models/user_location.dart';
import 'package:sweepstakes/providers/auth.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/location_service.dart';
import 'package:sweepstakes/providers/results.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/add_place_screen.dart';

import 'package:sweepstakes/screens/auth-screen.dart';
import 'package:sweepstakes/screens/location_page.dart';
import 'package:sweepstakes/screens/spash_screen.dart';
import 'package:sweepstakes/screens/sweepstake_management.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';
import 'package:sweepstakes/screens/sweepstakes_overview.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  File _pickedImage;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  // This widget is the root of your application.
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
          },
        ),
      ),
    );
  }
}
