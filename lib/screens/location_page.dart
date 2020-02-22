import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/user_location.dart';
import 'package:sweepstakes/providers/location_service.dart';

class LocationPage extends StatelessWidget {
  static const routeName = '/location-page';

  const LocationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> getCurrentLocation() async {
      final location = await Location().getLocation();
      print(location.latitude);
      print(location.longitude);
    }

    // getLocation.getLocation();
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('get location'),
          onPressed: () {
            getCurrentLocation();
          },
        ),
      ),
    );
  }
}
