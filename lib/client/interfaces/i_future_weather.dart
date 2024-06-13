import 'package:make_your_travel/data/data_or_expection.dart';
import 'package:make_your_travel/models/weather/weather_model.dart';

abstract class IForecastWeather {
  Future<DataOrException<ForecastWeather>> fetchFutureForecastWeather(
      {required String date, required String city});

  Future<DataOrException<ForecastWeather>> fetchForecastWeather(
      {required String city, required String date});
}
