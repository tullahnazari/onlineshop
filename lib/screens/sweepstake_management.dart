import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/great_places.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/add_place_screen.dart';
import 'package:sweepstakes/screens/adding_sweepstakes.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:sweepstakes/widgets/user_sweepstakes_item.dart';

class SweepstakeManagement extends StatelessWidget {
  static const routeName = '/user-sweepstakes';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces();
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Sweepstakes>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Postings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
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
                    child: Consumer<Sweepstakes>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserSweepstakeItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].image,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
