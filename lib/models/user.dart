import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String id;
  final List blocked;

  User({this.id, this.blocked});
}
