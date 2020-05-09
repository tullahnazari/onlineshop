import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:halalbazaar/helper/location_helper.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import 'package:uuid/uuid.dart';

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
    var countyAddress = await LocationHelper.getCounty(
        pickedLocation.latitude, pickedLocation.longitude);
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: stateAddress,
    );
    var uuid = Uuid();
    String uid = uuid.v1();
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken';
    try {
      final newPlace = Place(
        id: uid,
        dateTime: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        description: pickedDescription,
        address: countyAddress,
        location: updatedLocation,
        email: pickedEmail,
        phone: pickedPhone,
        price: pickedPrice,
        creatorId: userId,
      );
      await http.post(
        url,
        body: json.encode({
          'id': newPlace.id,
          'dateTime': DateTime.now().toString(),
          'title': newPlace.title,
          'image': newPlace.image,
          'loc_lat': newPlace.location.latitude,
          'loc_lng': newPlace.location.longitude,
          'address': countyAddress,
          'creatorId': newPlace.creatorId,
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
              dateTime: prodData['dateTime'],
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
              address: prodData['address'],
              creatorId: prodData['creatorId']),
        );
      });
      _items = loadedProducts;
      loadedProducts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

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
  Future<void> fetchAndSetPlaces() async {
    final url =
        'https://bazaar-45301.firebaseio.com/postings.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
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
            price: prodData['price'],
            title: prodData['title'],
            image: prodData['image'],
            location: PlaceLocation(
              latitude: prodData['loc_lat'],
              longitude: prodData['loc_lng'],
              address: prodData['address'],
            ),
            address: prodData['address'],
            description: prodData['description'],
            email: prodData['email'],
            phone: prodData['phone'],
            dateTime: prodData['dateTime'],
            creatorId: prodData['creatorId'],
          ),
        );
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
    deleteImage(existingProduct.image);
    _items.removeAt(existingProductIndex);

    //TODO delete a list of images
    //final image = existingProduct.image.forEach();

    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete sweepstake.');
    }
    existingProduct = null;
  }

  //deleting list of images from firebase storage
  Future deleteImage(List imageFileName) async {
    // final FirebaseStorage storage =
    //     FirebaseStorage(storageBucket: 'gs://bazaar-45301.appspot.com/');

    try {
      imageFileName.forEach((element) async {
        StorageReference ref =
            await FirebaseStorage.instance.getReferenceFromUrl(element);
        await ref.delete();
      });
      imageFileName.clear();
      return true;
    } catch (e) {
      return e.toString();
    }
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
