import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/helper/location_helper.dart';
import 'package:sweepstakes/models/user_location.dart';
import 'package:sweepstakes/providers/location_service.dart';
import 'package:sweepstakes/screens/map_screen.dart';

class LocationPage extends StatefulWidget {
  static const routeName = '/location-page';

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _previewImageUrl;

  Future<void> getCurrentLocation() async {
    final location = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => HomePage(),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    //...
  }

  @override
  Widget build(BuildContext context) {
    // getLocation.getLocation();
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            Container(
              height: 400,
              width: 350,
              child: _previewImageUrl == null
                  ? Text(
                      'No location chosen',
                      textAlign: TextAlign.center,
                    )
                  : Image.network(
                      _previewImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            RaisedButton(
              child: Text('Find Location'),
              onPressed: () {
                getCurrentLocation();
              },
            ),
            RaisedButton(
              child: Text('Select on a map'),
              onPressed: () {
                _selectOnMap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
