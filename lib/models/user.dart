import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final List blockedUser;

  User({this.blockedUser});
}
