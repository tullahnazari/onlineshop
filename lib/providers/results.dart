import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:sweepstakes/models/result.dart';
import 'package:sweepstakes/models/sweepstake.dart';

class Results with ChangeNotifier {
  List<ResultItem> _resultItems = [];

  final String authToken;
  final String userId;

  Results(this.authToken, this.userId, this._resultItems);

  List<ResultItem> get items {
    return [..._resultItems];
  }

  ResultItem findById(String id) {
    return _resultItems.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetResults() async {
    final url =
        'https://bazaar-45301.firebaseio.com/results/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<ResultItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        ResultItem(
          id: orderId,
          title: orderData['title'],
          randomNumber: orderData['randomNumber'],
        ),
      );
    });
    _resultItems = loadedOrders;
    notifyListeners();
  }

  //ADD entry to contest
  Future<void> enterSweepstake(ResultItem result, Sweepstake sweepstake) async {
    //send https request
    final url =
        'https://bazaar-45301.firebaseio.com/results/$userId.json?auth=$authToken';
    var title = sweepstake.title;
    final randomNumber = generateRandomNumber;
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': result.id,
          'title': title,
          'randomNumber': randomNumber,
        }),
      );
      final newContest = ResultItem(
        id: json.decode(response.body)['name'],
        title: title,
        randomNumber: randomNumber,
      );
      _resultItems.add(newContest);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //generating random number
  int get generateRandomNumber {
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt();
  }

//   void addItem(
//     String sweepstakeId,
//     int randomNumber,
//     String title,
//   ) {
//     if (_items.containsKey(sweepstakeId)) {
//       //change quantity
//       _items.update(
//           sweepstakeId,
//           (existingCartItem) => ResultItem(
//               id: existingCartItem.id,
//               title: existingCartItem.title,
//               randomNumber: existingCartItem.randomNumber));
//     } else {
//       //addd item to cart
//       _items.putIfAbsent(
//         sweepstakeId,
//         () => ResultItem(
//           id: DateTime.now().toString(),
//           title: title,
//           randomNumber: randomNumber,
//         ),
//       );
//     }
//     notifyListeners();
//   }
}
