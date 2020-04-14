import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:sweepstakes/helper/location_helper.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  GreatPlaces(this.authToken, this.userId, this._items);
  bool error = false;
  bool isDisposed = false;
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    List pickedImage,
    PlaceLocation pickedLocation,
    String pickedDescription,
    String pickedEmail,
    String pickedPhone,
    String pickedPrice,
  ) async {
    var stateAddress = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: stateAddress,
    );
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken';
    try {
      final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        description: pickedDescription,
        location: updatedLocation,
        email: pickedEmail,
        phone: pickedPhone,
        price: pickedPrice,
      );
      await http.post(
        url,
        body: json.encode({
          'id': newPlace.id,
          'title': newPlace.title,
          'image': newPlace.image,
          'loc_lat': newPlace.location.latitude,
          'loc_lng': newPlace.location.longitude,
          'address': stateAddress,
          'creatorId': userId,
          'state': stateAddress,
          'description': newPlace.description,
          'email': newPlace.email,
          'phone': newPlace.phone,
          'price': newPlace.price,
        }),
      );
      _items.add(newPlace);
      newPlace.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchResultsByState(
    String state,
  ) async {
    //final filterString = 'orderBy="address"&equalTo="$state"';
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken&orderBy="state"&equalTo="$state"';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Place> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Place(
            id: prodId,
            title: prodData['title'],
            image: prodData['image'],
            location: PlaceLocation(
              latitude: prodData['loc_lat'],
              longitude: prodData['loc_lng'],
              address: prodData['address'],
            ),
            description: prodData['description'],
            email: prodData['email'],
            phone: prodData['phone'],
            price: prodData['price'],
          ),
        );
      });
      _items = loadedProducts.reversed.toList();

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //get length
  Future<int> getCount() async {
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Place> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Place(
            id: prodId,
            title: prodData['title'],
            //image: File(prodData['image']),
            location: PlaceLocation(
              latitude: prodData['loc_lat'],
              longitude: prodData['loc_lng'],
              address: prodData['address'],
            )));
      });
      _items = loadedProducts;
      final length = loadedProducts.length;

      return length;

      print(length);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //TODO work on this as POST is working but not GET
  Future<void> fetchAndSetPlaces([bool filterByUser = true]) async {
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
            image: prodData['image'],
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

  //TODO work on this as POST is working but not GET
  Future<void> fetchFirstImage([bool filterByUser = true]) async {
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
            //image: File(prodData['image']),
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
            // 'image': newPlace.image.path,
            'address': newPlace.location.address,
          }));
      _items[prodIndex] = newPlace;
      notifyListeners();
    } else {
      print('Posting does not exist');
    }
  }
}
