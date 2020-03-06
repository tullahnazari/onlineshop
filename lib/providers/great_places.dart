import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sweepstakes/helper/location_helper.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;

  GreatPlaces(this.authToken, this.userId, this._items);

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken';
    try {
      final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        location: updatedLocation,
      );
      await http.post(
        url,
        body: json.encode({
          'id': newPlace.id,
          'title': newPlace.title,
          'image': newPlace.image.path,
          'loc_lat': newPlace.location.latitude,
          'loc_lng': newPlace.location.longitude,
          'address': newPlace.location.address,
        }),
      );
      _items.add(newPlace);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //TODO work on this as POST is working but not GET
  Future<void> fetchAndSetPlaces() async {
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Place> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Place(
            id: prodData['id'],
            title: prodData['title'],
            image: File(prodData['image']),
            location: PlaceLocation(
              latitude: prodData['loc_lat'],
              longitude: prodData['loc_lng'],
              address: prodData['address'],
            )));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
