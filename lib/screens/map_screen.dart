import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sweepstakes/models/place.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';

class MapScreen extends StatefulWidget {
  // final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Icon(
        Icons.arrow_upward,
      ),
      appBar: AppBar(
        title: Text('My Map'),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.422, -122.084),
          zoom: 16,
        ),
      ),
    );
  }
}
