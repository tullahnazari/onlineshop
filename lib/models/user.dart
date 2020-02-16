import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String id;
  final bool isAdmin;

  User({this.id, this.isAdmin});
}
