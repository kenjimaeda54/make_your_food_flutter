import 'package:hooks_riverpod/hooks_riverpod.dart';

class TripSearch {
  DateTime? dayEnd;
  DateTime? dayStart;
  String to;
  int quantityPeople;
  String from;

  TripSearch(
      {required this.dayEnd,
      required this.dayStart,
      required this.from,
      required this.quantityPeople,
      required this.to});

  factory TripSearch.fromEmpty() {
    return TripSearch(
        dayEnd: null, dayStart: null, from: "", quantityPeople: 0, to: "");
  }
}

final tripSearch = StateProvider<TripSearch>((ref) => TripSearch.fromEmpty());
