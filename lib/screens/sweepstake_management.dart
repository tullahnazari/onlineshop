import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:halalbazaar/providers/auth.dart';
import 'package:halalbazaar/providers/great_places.dart';
import 'package:halalbazaar/providers/sweepstakes.dart';
import 'package:halalbazaar/screens/add_place_screen.dart';
import 'package:halalbazaar/widgets/app_drawer.dart';
import 'package:halalbazaar/widgets/sweepstake_items.dart';
import 'package:halalbazaar/widgets/user_sweepstakes_item.dart';

class SweepstakeManagement extends StatefulWidget {
  static const routeName = '/user-sweepstakes';

  @override
  _SweepstakeManagementState createState() => _SweepstakeManagementState();
}

class _SweepstakeManagementState extends State<SweepstakeManagement> {
  var _isLoading = false;

  var _isInit = true;

  Position currentLocation;

  @override
  void initState() {
    _refreshProducts(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _refreshProducts(context);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces();
  }

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
            var descriptionCount = await productCount.getDescriptionValue();
            if (order > 4) {
              Flushbar(
                title: "Ohhh Shucks...",
                message:
                    "You can only have 5 active postings, please delete inactive or dated posts ",
                duration: Duration(seconds: 5),
              )..show(context);
            } else if (descriptionCount > 0) {
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
                return RefreshIndicator(
                  displacement: 120,
                  color: Theme.of(context).primaryColor,
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<GreatPlaces>(
                    builder: (ctx, greatPlaces, _) => Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (_, i) => ChangeNotifierProvider.value(
                          // builder: (c) => products[i],
                          value: greatPlaces.items[i],
                          child: Column(children: [
                            SweepstakeItems(
                              id: greatPlaces.items[i].id,
                              title: greatPlaces.items[i].title,
                              image: greatPlaces.items[i].image,
                              price: greatPlaces.items[i].price,
                            ),
                            Divider(),
                          ]),
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
  // bottomSheet: SolidBottomSheet(
  //   maxHeight: MediaQuery.of(context).size.height * .22,
  //   headerBar: Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadiusDirectional.only(
  //           topStart: Radius.circular(50), topEnd: Radius.circular(50)),
  //       color: Theme.of(context).primaryColor,
  //     ),
  //     height: MediaQuery.of(context).size.height * .10,
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

}
