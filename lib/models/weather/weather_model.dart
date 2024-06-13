// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class ForecastWeather with _$ForecastWeather {
  const factory ForecastWeather({
    required Forecast forecast,
  }) = _Weather;

  factory ForecastWeather.fromJson(Map<String, Object?> json) =>
      _$ForecastWeatherFromJson(json);
}

@freezed
class Forecast with _$Forecast {
  const factory Forecast({
    @JsonKey(name: 'forecastday') required List<ForecastDay> forecastDay,
  }) = _Forecast;

  factory Forecast.fromJson(Map<String, Object?> json) =>
      _$ForecastFromJson(json);
}

@freezed
class ForecastDay with _$ForecastDay {
  const factory ForecastDay(
      {required Day day,
      required List<Hour> hour,
      required String date}) = _ForecastDay;

  factory ForecastDay.fromJson(Map<String, Object?> json) =>
      _$ForecastDayFromJson(json);
}

@freezed
class Hour with _$Hour {
  const factory Hour({
    @JsonKey(name: 'chance_of_rain') required num chanceOfRain,
  }) = _Hour;

  factory Hour.fromJson(Map<String, Object?> json) => _$HourFromJson(json);
}

@freezed
class Day with _$Day {
  const factory Day(
      {@JsonKey(name: 'maxtemp_c') required num maxTemperature,
      @JsonKey(name: 'mintemp_c') required num minTemperature,
      required Condition condition}) = _Day;

  factory Day.fromJson(Map<String, Object?> json) => _$DayFromJson(json);
}

@freezed
class Condition with _$Condition {
  const factory Condition({
    required String text,
    required String icon,
  }) = _Condition;

  factory Condition.fromJson(Map<String, Object?> json) =>
      _$ConditionFromJson(json);
}
