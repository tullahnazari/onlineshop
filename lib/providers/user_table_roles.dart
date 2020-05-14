import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halalbazaar/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class Users with ChangeNotifier {
  Users(this.authToken, this.userId, this._items);
  final String authToken;
  final String userId;
  bool error = false;

  bool isDisposed = false;
  List<User> _items = [];

  List<User> get items {
    return [..._items];
  }

  User findById(String id) {
    return _items.firstWhere((user) => user.id == id);
  }

  Future<void> addUserToBlockList(
    String id,
    String blockedList,
  ) async {
    var id = userId;
    final url =
        'https://bazaar-45301.firebaseio.com/users/$id.json?auth=$authToken';
    try {
      final newPlace = User(
        blockedList: blockedList,
      );
      await http.post(
        url,
        body: json.encode({
          'blockedList': newPlace.blockedList,
        }),
      );
      _items.add(newPlace);
      newPlace.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateAndBlockUser(String id, List updateUser) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://bazaar-45301.firebaseio.com/users/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'blockedList': updateUser,
          }));
      //_items[prodIndex] = updateUser;
      notifyListeners();
    } else {
      print('Blocked user does not exist');
    }
  }
}
