import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class TripSearch {
  DateTime? dayEnd;
  DateTime? dayStart;
  String destiny;
  int quantityPeople;
  String origin;
  File? file;

  TripSearch(
      {required this.dayEnd,
      required this.dayStart,
      required this.origin,
      required this.quantityPeople,
      required this.destiny,
      this.file});

  factory TripSearch.fromEmpty() {
    return TripSearch(
        dayEnd: null,
        dayStart: null,
        origin: "",
        quantityPeople: 0,
        destiny: "");
  }
}

final tripSearch = StateProvider<TripSearch>((ref) => TripSearch.fromEmpty());
