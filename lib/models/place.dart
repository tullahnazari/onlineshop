import 'dart:io';

import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Place with ChangeNotifier {
  final String id;
  final String title;
  final PlaceLocation location;
  final List image;
  final String description;
  final String email;
  final String phone;
  final String price;
  final String address;

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
    @required this.description,
    @required this.email,
    @required this.phone,
    @required this.price,
    @required this.address,
  });

  notifyListeners();
}
