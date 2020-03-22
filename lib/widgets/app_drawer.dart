import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/providers/auth.dart';

import 'package:sweepstakes/screens/sweepstake_management.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Auth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to HB'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 30,
            ),
            title: Text('Posting'),
            subtitle: Text('See Products or Service near you'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 30,
            ),
            title: Text('Manage Postings'),
            subtitle: Text('Add a Service or Product'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SweepstakeManagement.routeName);
            },
          ),
          SizedBox(
            height: 500,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 30,
            ),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
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
      onTap: () {},
    );
  }
}
