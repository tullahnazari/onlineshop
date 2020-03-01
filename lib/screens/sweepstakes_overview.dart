import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/user_location.dart';
import 'package:sweepstakes/providers/auth.dart';
import 'package:sweepstakes/providers/location_service.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/providers/user_table_roles.dart';
import 'package:sweepstakes/screens/camera_screen.dart';
import 'package:sweepstakes/screens/location_page.dart';
import 'package:sweepstakes/screens/sweepstake_management.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:sweepstakes/widgets/bottom_bar.dart';
import 'package:sweepstakes/widgets/sweepstake_items.dart';

class SweepstakesOverview extends StatefulWidget {
  static const routeName = '/sweepstakeoverview';

  @override
  _SweepstakesOverviewState createState() => _SweepstakesOverviewState();
}

class _SweepstakesOverviewState extends State<SweepstakesOverview> {
  var _isLoading = false;
  var _isInit = true;

  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Sweepstakes>(context).fetchProducts(false).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedSweepstakeData = Provider.of<Sweepstakes>(context);
    final loadedSweepstake = loadedSweepstakeData.items;
    final userProvider = Provider.of<Auth>(context);

    return
        // StreamProvider<UserLocation>(
        //   create: (context) => LocationService().locationStream,
        //   child:
        Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            child: Icon(Icons.search),
            onPressed: (() {
              Navigator.of(context).pushNamed(LocationPage.routeName);
            }),
          ),
          RaisedButton(
            child: Icon(Icons.camera),
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageInput(_selectImage)),
              );
            }),
          ),
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
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: loadedSweepstake.length,
                itemBuilder: (ctx, i) => SweepstakeItems(
                  id: loadedSweepstake[i].id,
                  title: loadedSweepstake[i].title,
                  imageUrl: loadedSweepstake[i].imageUrl,
                  price: loadedSweepstake[i].price,
                  dateTime: loadedSweepstake[i].dateTime,
                ),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  // childAspectRatio: MediaQuery.of(context).size.width /
                  //     (MediaQuery.of(context).size.height / 4),
                ),
              ),
            ),
    );
  }
}
