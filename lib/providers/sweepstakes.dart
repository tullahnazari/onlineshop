import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halalbazaar/models/sweepstake.dart';
import 'package:http/http.dart' as http;

class Sweepstakes with ChangeNotifier {
  List<Sweepstake> _items = [
    // Sweepstake(
    //     id: '1',
    //     title: 'Jordan 1s',
    //     imageUrl:
    //         'https://sneakernews.com/wp-content/uploads/2019/10/Air-Jordan-1-High-Fearless-Les-Twins-CK5666_100-1.jpg',
    //     price: 299.99,
    //     dateTime: '12/26/2020'),
    // Sweepstake(
    //     id: '2',
    //     title: '60 inch OLED',
    //     imageUrl:
    //         'https://images-na.ssl-images-amazon.com/images/I/81Nu4cpJ9JL._SL1500_.jpg',
    //     price: 299.99,
    //     dateTime: '12/26/2020'),
    // Sweepstake(
    //     id: '3',
    //     title: 'iPhone 11 Pro',
    //     imageUrl:
    //         'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-11-pro-space-select-2019?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1566954989577',
    //     price: 999.99,
    //     dateTime: '12/27/2020'),
    // Sweepstake(
    //     id: '4',
    //     title: 'PS4 PRO',
    //     imageUrl:
    //         'https://media.kohlsimg.com/is/image/kohls/3355334?wid=500&hei=500&op_sharpen=1',
    //     price: 349.99,
    //     dateTime: '12/27/2020'),
    // Sweepstake(
    //     id: '5',
    //     title: 'Nintendo Switch',
    //     imageUrl:
    //         'https://target.scene7.com/is/image/Target/GUEST_5561e25a-a986-4b57-bba4-ee339796ae89?fmt=webp&wid=1400&qlt=80',
    //     price: 299.99,
    //     dateTime: '12/28/2020'),
  ];

  final String authToken;
  final String userId;
  File pickedImage;

  Sweepstakes(this.authToken, this.userId, this._items);

  //MAKING IT SO ONLY DATA INSIDE HERE IS CHANGED FOR PRODUCT DATA
  List<Sweepstake> get items {
    return [..._items];
  }

  Sweepstake findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://bazaar-45301.firebaseio.com/sweepstakes.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Sweepstake> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Sweepstake(
          id: prodId,
          title: prodData['title'],
          dateTime: prodData['dateTime'],
          price: prodData['price'],
          image: prodData[pickedImage],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://bazaar-45301.firebaseio.com/sweepstakes.json?auth=$authToken';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Sweepstake> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Sweepstake(
          id: prodId,
          title: prodData['title'],
          dateTime: prodData['dateTime'],
          price: prodData['price'],
          image: prodData[pickedImage],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Sweepstake newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://bazaar-45301.firebaseio.com/sweepstakes/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'dateTime': newProduct.dateTime,
            'image': newProduct.image,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Sweepstake does not exist');
    }
  }

  Future<void> addProduct(Sweepstake product) async {
    //send https request
    final url =
        'https://bazaar-45301.firebaseio.com/sweepstakes.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': product.id,
          'title': product.title,
          'dateTime': product.dateTime,
          'image': product.image,
          'price': product.price,
          'creatorId': userId
        }),
      );
      final newProduct = Sweepstake(
        title: product.title,
        dateTime: product.dateTime,
        price: product.price,
        image: product.image,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://bazaar-45301.firebaseio.com/sweepstakes/$id.json?auth=$authToken';
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
}
