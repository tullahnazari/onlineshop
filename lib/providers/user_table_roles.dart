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

  // User findById(String id) {
  //   return _items.firstWhere((user) => user.blockedUser == id);
  // }

  Future<void> addUserToBlockList(
    String updateUser,
  ) async {
    List blockedList = [];
    String blockedId = updateUser;
    blockedList.add(blockedId);
    final url =
        'https://bazaar-45301.firebaseio.com/users/blockedUsers.json?auth=$authToken';
    try {
      final newPlace = User(
        // id: userId,
        blockedUser: blockedList,
      );
      await http.post(
        url,
        body: json.encode({
          'blockedUser': updateUser,
        }),
      );
      _items.add(newPlace);
      newPlace.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //TODO work on this as POST is working but not GET
  Future<void> fetchBlockedUsers() async {
    final url =
        'https://bazaar-45301.firebaseio.com/users/blockedUsers.json?auth=$authToken';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return 'nothing to display';
      }
      final List<User> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          User(
            blockedUser: prodData,
          ),
        );
      });
      _items = loadedProducts;
      print(loadedProducts);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> updateAndBlockUser(String id, List updateUser) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url =
  //         'https://bazaar-45301.firebaseio.com/users.json?auth=$authToken';
  //     await http.patch(url,
  //         body: json.encode({
  //           'blocked': updateUser,
  //         }));
  //     //_items[prodIndex] = updateUser;
  //     notifyListeners();
  //   } else {
  //     print('Blocked user does not exist');
  //   }
  // }
}
