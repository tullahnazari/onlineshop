import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String id;
  final String blockedList;

  User({this.id, this.blockedList});
}
