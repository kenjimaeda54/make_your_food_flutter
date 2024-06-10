import 'package:flutter_gemini/flutter_gemini.dart';

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
  Content? documentNeedTravel
});

typedef OptionsTripPlan = ({
  String id,
  String title,
  String imagePath,
  double size,
});

typedef CardImagesSuggestions = ({String title, String image, String location});
