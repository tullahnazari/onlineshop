import 'package:flutter/foundation.dart';

class ResultItem with ChangeNotifier {
  final String id;
  final String title;
  final int randomNumber;

  ResultItem({this.id, this.title, this.randomNumber});
}
