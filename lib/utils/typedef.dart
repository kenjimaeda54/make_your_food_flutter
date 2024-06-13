import 'package:flutter_gemini/flutter_gemini.dart';

typedef TemperatureOnTravel = ({
  String temperatureMinimum,
  String temperatureMaximum,
  DateTime date,
  String icon,
  String chanceOfRain,
  String condition,
});

typedef HotelsLatitudeAndLongitude = ({
  double latitude,
  double longitude,
  String id
});
typedef ResponseGemini = ({
  String countryCurrency,
  Content hotels,
  bool isInternational,
  Content whatDoCity,
  Content bestRoute,
  Content? documentNeedTravel,
  List<TemperatureOnTravel> temperatures,
});

typedef OptionsTripPlan = ({
  String id,
  String title,
  String imagePath,
  double size,
});

typedef CardImagesSuggestions = ({String title, String image, String location});
