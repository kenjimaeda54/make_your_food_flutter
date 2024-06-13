import 'package:make_your_travel/client/base_client.dart';
import 'package:make_your_travel/client/interfaces/i_future_weather.dart';
import 'package:make_your_travel/data/data_or_expection.dart';
import 'package:make_your_travel/models/weather/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:make_your_travel/old_chat/utils/constants_environment.dart';

class ForecastWeatherService extends BaseClientService
    implements IForecastWeather {
  @override
  Future<DataOrException<ForecastWeather>> fetchFutureForecastWeather(
      {required String date, required String city}) async {
    try {
      final apiKey = dotenv.env[environmentApiKeyWeather];
      final response = await customDio().get(
          "/future.json?key=$apiKey&q=$city&dt=$date&lang=pt&hour=10&days=5");
      return DataOrException(
          data: ForecastWeather.fromJson(response.data),
          exception: null,
          isSuccess: true);
    } catch (e) {
      return DataOrException(
          data: null, exception: e.toString(), isSuccess: false);
    }
  }

  @override
  Future<DataOrException<ForecastWeather>> fetchForecastWeather(
      {required String city, required String date}) async {
    try {
      final apiKey = dotenv.env[environmentApiKeyWeather];
      final response = await customDio().get(
          "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&hour=10&lang=pt&dt=$date");
      return DataOrException(
          data: ForecastWeather.fromJson(response.data),
          exception: null,
          isSuccess: true);
    } catch (e) {
      return DataOrException(
          data: null, exception: e.toString(), isSuccess: false);
    }
  }
}
