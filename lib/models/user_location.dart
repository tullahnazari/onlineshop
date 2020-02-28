import 'package:flutter/cupertino.dart';

class UserLocation extends ChangeNotifier {
  final double latitude;
  final double longitude;
  UserLocation({this.latitude, this.longitude});
}
