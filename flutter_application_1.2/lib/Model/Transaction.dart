//class
import 'package:flutter_application_1/map.dart';
import 'package:geolocator/geolocator.dart';

class Transaction {
  double dose;
  double userlocation;
  DateTime date;

  Transaction(
      {required this.dose, required this.userlocation, required this.date});
}
