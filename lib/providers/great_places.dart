import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sweepstakes/helper/location_helper.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  bool error = false;
  bool isDisposed = false;
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
          'creatorId': userId,
        }),
      );
      _items.add(newPlace);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //TODO work on this as POST is working but not GET
  Future<void> fetchAndSetPlaces([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Place> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Place(
            id: prodId,
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

  Future<void> deleteProduct(String id) async {
    final url =
        'https://bazaar-45301.firebaseio.com/postings/$id.json?auth=$authToken';
    //optimistic deleting/updating
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete sweepstake.');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Place newPlace) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://bazaar-45301.firebaseio.com/postings/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newPlace.title,
            'image': newPlace.image.path,
            'address': newPlace.location.address,
          }));
      _items[prodIndex] = newPlace;
      notifyListeners();
    } else {
      print('Posting does not exist');
    }
  }
}
