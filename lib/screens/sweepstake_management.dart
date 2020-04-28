import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:halalbazaar/providers/auth.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/providers/sweepstakes.dart';
import 'package:halalbazaar/screens/add_place_screen.dart';
import 'package:halalbazaar/widgets/app_drawer.dart';
import 'package:halalbazaar/widgets/sweepstake_items.dart';
import 'package:halalbazaar/widgets/user_sweepstakes_item.dart';

class SweepstakeManagement extends StatelessWidget {
  static const routeName = '/user-sweepstakes';

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final productCount = Provider.of<GreatPlaces>(context, listen: false);
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Postings'),
        ),
        drawer: AppDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add A Posting',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            var order = await productCount.getCount();
            if (order > 4) {
              Flushbar(
                title: "Ohhh Shucks...",
                message:
                    "You can only have 5 active postings, please delete inactive or dated posts ",
                duration: Duration(seconds: 5),
              )..show(context);
            } else {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            }
          },
          child: Icon(
            FontAwesomeIcons.plus,
            size: 30,
            color: Theme.of(context).accentColor,
          ),
        ),
        body: FutureBuilder(
            future: Provider.of<GreatPlaces>(context, listen: false)
                .fetchAndSetPlaces(authData.userId),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              // else {
              //   if (dataSnapshot.error != null) {
              //     // ...
              //     // Do error handling stuff
              //     return Center(
              //       child: Text('An error occurred!'),
              //     );
              //   }
              else {
                return Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, child) => ListView.builder(
                    itemCount: greatPlaces.items.length,
                    itemBuilder: (ctx, i) => SweepstakeItems(
                      id: greatPlaces.items[i].id,
                      title: greatPlaces.items[i].title,
                      image: greatPlaces.items[i].image,
                      price: greatPlaces.items[i].price,
                    ),
                  ),
                );
              }
            }
            //     },
            ),
        // bottomSheet: SolidBottomSheet(
        //   maxHeight: deviceSize.height * .22,
        //   headerBar: Container(
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadiusDirectional.only(
        //           topStart: Radius.circular(50), topEnd: Radius.circular(50)),
        //       color: Theme.of(context).primaryColor,
        //     ),
        //     height: deviceSize.height * .10,
        //     child: Center(
        //         child: Text(
        //       'Swipe up for Instructions',
        //       style: TextStyle(
        //           fontSize: 20,
        //           color: Theme.of(context).accentColor,
        //           fontFamily: 'Lato'),
        //     )),
        //   ), // Your header here
        //   body: Container(
        //     height: 100,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Center(
        //         child: Text(
        //           'Click on the plus icon on the right to add a service or product. Your posting will be shared with the community near by. You can also post services you want, such as Food prep service, tailoring, and even a reccomendation for a nice restaurant',
        //           style: TextStyle(
        //             fontSize: 20,
        //             fontFamily: 'Lato',
        //           ),
        //         ),
        //       ),
        //     ),
        //   ), // Your body here
        // ),
      ),
    );
  }
}
