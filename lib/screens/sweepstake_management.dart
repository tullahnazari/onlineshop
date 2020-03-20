import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/add_place_screen.dart';
import 'package:sweepstakes/screens/adding_sweepstakes.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:sweepstakes/widgets/sweepstake_items.dart';
import 'package:sweepstakes/widgets/user_sweepstakes_item.dart';

class SweepstakeManagement extends StatelessWidget {
  static const routeName = '/user-sweepstakes';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<GreatPlaces>(context, listen: false)
        .fetchAndSetPlaces(true);
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    final products = Provider.of<GreatPlaces>(context, listen: false);
    final productCount = Provider.of<GreatPlaces>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Postings'),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
          //   },
          // ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add A Posting',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var order = await productCount.getCount();
          if (order > 9) {
            Flushbar(
              title: "Hey Ninja",
              message:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
          }
        },
        child: Icon(
          FontAwesomeIcons.plusCircle,
          color: Theme.of(context).accentColor,
        ),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<GreatPlaces>(
                      builder: (ctx, greatPlaces, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              SweepstakeItems(
                                id: greatPlaces.items[i].id,
                                title: greatPlaces.items[i].title,
                                image: greatPlaces.items[i].image,
                                address: greatPlaces.items[i].location.address,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                      // onTap: () {
                      //   Navigator.of(context).pushNamed(
                      //     PlaceDetailScreen.routeName,
                      //     arguments: greatPlaces.items[i].id,
                      //   );
                      // },

                      // trailing: Container(
                      //   width: 100,
                      //   child: Row(
                      //     children: <Widget>[
                      //       IconButton(
                      //         icon: Icon(Icons.edit),
                      //         // onPressed: () {
                      //         //   Navigator.of(context).pushNamed(
                      //         //       AddingSweepstake.routeName,
                      //         //       arguments: id);
                      //         // },
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //       IconButton(
                      //         icon: Icon(Icons.delete),
                      //         onPressed: () {
                      //           Provider.of<GreatPlaces>(context,
                      //                   listen: false)
                      //               .deleteProduct(greatPlaces.items[1].id);
                      //         },
                      //         color: Theme.of(context).errorColor,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
      ),
    );
  }
}
