// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherImpl _$$WeatherImplFromJson(Map<String, dynamic> json) =>
    _$WeatherImpl(
      forecast: Forecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WeatherImplToJson(_$WeatherImpl instance) =>
    <String, dynamic>{
      'forecast': instance.forecast,
    };

_$ForecastImpl _$$ForecastImplFromJson(Map<String, dynamic> json) =>
    _$ForecastImpl(
      forecastDay: (json['forecastday'] as List<dynamic>)
          .map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ForecastImplToJson(_$ForecastImpl instance) =>
    <String, dynamic>{
      'forecastday': instance.forecastDay,
    };

_$ForecastDayImpl _$$ForecastDayImplFromJson(Map<String, dynamic> json) =>
    _$ForecastDayImpl(
      day: Day.fromJson(json['day'] as Map<String, dynamic>),
      hour: (json['hour'] as List<dynamic>)
          .map((e) => Hour.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$$ForecastDayImplToJson(_$ForecastDayImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'date': instance.date,
    };

_$HourImpl _$$HourImplFromJson(Map<String, dynamic> json) => _$HourImpl(
      chanceOfRain: json['chance_of_rain'] as num,
    );

Map<String, dynamic> _$$HourImplToJson(_$HourImpl instance) =>
    <String, dynamic>{
      'chance_of_rain': instance.chanceOfRain,
    };

_$DayImpl _$$DayImplFromJson(Map<String, dynamic> json) => _$DayImpl(
      maxTemperature: json['maxtemp_c'] as num,
      minTemperature: json['mintemp_c'] as num,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DayImplToJson(_$DayImpl instance) => <String, dynamic>{
      'maxtemp_c': instance.maxTemperature,
      'mintemp_c': instance.minTemperature,
      'condition': instance.condition,
    };

_$ConditionImpl _$$ConditionImplFromJson(Map<String, dynamic> json) =>
    _$ConditionImpl(
      text: json['text'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$ConditionImplToJson(_$ConditionImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
    };
