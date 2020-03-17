import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/auth.dart';

import 'package:sweepstakes/screens/sweepstake_management.dart';
import 'package:sweepstakes/screens/your_sweepstake.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Auth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello, Tullah'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Posting'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Postings'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SweepstakeManagement.routeName);
            },
          ),
          // StreamBuilder<DocumentSnapshot>(
          //   stream: Firestore.instance
          //       .collection('users')
          //       .document(userProvider.userId)
          //       .snapshots(),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<DocumentSnapshot> snapshot) {
          //     if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     }
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.waiting:
          //         return Text('Loading..');
          //       default:
          //         return ListTile(
          //           leading: Icon(Icons.edit),
          //           title: Text('Manage Postings'),
          //           onTap: () {
          //             Navigator.of(context)
          //                 .pushReplacementNamed(SweepstakeManagement.routeName);
          //           },
          //         );
          //     }
          //   },
          // )

          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: Text('Manage Sweepstakes'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(SweepstakeManagement.routeName);
          //   },
          // ),
        ],
      ),
    );
  }

  checkRole(DocumentSnapshot snapshot, BuildContext context) {
    if (snapshot.data['isAdmin'] == true) {
      return adminPage(snapshot, context);
    } else {
      return notAdmin(snapshot, context);
    }
  }

  adminPage(DocumentSnapshot snapshot, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Manage Sweepstakes'),
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed(SweepstakeManagement.routeName);
      },
    );
  }

  notAdmin(DocumentSnapshot snapshot, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Your Sweepstakes'),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(YourSweepstake.routeName);
      },
    );
  }
}
