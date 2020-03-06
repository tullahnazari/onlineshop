import 'dart:io';

class Sweepstake {
  final String id;
  final String title;
  final File image;
  final double price;
  final String dateTime;
  final int randomNumber;

  Sweepstake(
      {this.id,
      this.title,
      this.image,
      this.price,
      this.dateTime,
      this.randomNumber});
}
