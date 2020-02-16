import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/auth.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/providers/user_table_roles.dart';
import 'package:sweepstakes/screens/sweepstake_management.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:sweepstakes/widgets/sweepstake_items.dart';

class SweepstakesOverview extends StatefulWidget {
  static const routeName = '/sweepstakeoverview';

  @override
  _SweepstakesOverviewState createState() => _SweepstakesOverviewState();
}

class _SweepstakesOverviewState extends State<SweepstakesOverview> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Sweepstakes>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadedSweepstakeData = Provider.of<Sweepstakes>(context);
    final loadedSweepstake = loadedSweepstakeData.items;
    final userProvider = Provider.of<Auth>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: <Widget>[
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
          'Active Sweeps',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
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
            ),
    );
  }
}
