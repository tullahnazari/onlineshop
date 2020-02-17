import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/providers/auth.dart';
import 'package:sweepstakes/providers/results.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/adding_sweepstakes.dart';
import 'package:sweepstakes/screens/auth-screen.dart';
import 'package:sweepstakes/screens/results_screen.dart';
import 'package:sweepstakes/screens/spash_screen.dart';
import 'package:sweepstakes/screens/sweepstake_management.dart';
import 'package:sweepstakes/screens/sweepstakes_detail.dart';
import 'package:sweepstakes/screens/sweepstakes_overview.dart';
import 'package:sweepstakes/screens/your_sweepstake.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        ChangeNotifierProvider.value(
          value: ResultItem(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Halaal Bazaar',
          theme: ThemeData(
            primaryColor: Colors.blueGrey,
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
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            SweepstakesDetail.routeName: (ctx) => SweepstakesDetail(),
            ResultScreen.routeName: (ctx) => ResultScreen(),
            AddingSweepstake.routeName: (ctx) => AddingSweepstake(),
            SweepstakeManagement.routeName: (ctx) => SweepstakeManagement(),
            SweepstakesOverview.routeName: (ctx) => SweepstakesOverview(),
            YourSweepstake.routeName: (ctx) => YourSweepstake(),
          },
        ),
      ),
    );
  }
}
