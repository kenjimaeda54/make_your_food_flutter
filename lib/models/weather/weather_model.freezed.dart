// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForecastWeather _$ForecastWeatherFromJson(Map<String, dynamic> json) {
  return _Weather.fromJson(json);
}

/// @nodoc
mixin _$ForecastWeather {
  Forecast get forecast => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForecastWeatherCopyWith<ForecastWeather> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastWeatherCopyWith<$Res> {
  factory $ForecastWeatherCopyWith(
          ForecastWeather value, $Res Function(ForecastWeather) then) =
      _$ForecastWeatherCopyWithImpl<$Res, ForecastWeather>;
  @useResult
  $Res call({Forecast forecast});

  $ForecastCopyWith<$Res> get forecast;
}

/// @nodoc
class _$ForecastWeatherCopyWithImpl<$Res, $Val extends ForecastWeather>
    implements $ForecastWeatherCopyWith<$Res> {
  _$ForecastWeatherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forecast = null,
  }) {
    return _then(_value.copyWith(
      forecast: null == forecast
          ? _value.forecast
          : forecast // ignore: cast_nullable_to_non_nullable
              as Forecast,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ForecastCopyWith<$Res> get forecast {
    return $ForecastCopyWith<$Res>(_value.forecast, (value) {
      return _then(_value.copyWith(forecast: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherImplCopyWith<$Res>
    implements $ForecastWeatherCopyWith<$Res> {
  factory _$$WeatherImplCopyWith(
          _$WeatherImpl value, $Res Function(_$WeatherImpl) then) =
      __$$WeatherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Forecast forecast});

  @override
  $ForecastCopyWith<$Res> get forecast;
}

/// @nodoc
class __$$WeatherImplCopyWithImpl<$Res>
    extends _$ForecastWeatherCopyWithImpl<$Res, _$WeatherImpl>
    implements _$$WeatherImplCopyWith<$Res> {
  __$$WeatherImplCopyWithImpl(
      _$WeatherImpl _value, $Res Function(_$WeatherImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forecast = null,
  }) {
    return _then(_$WeatherImpl(
      forecast: null == forecast
          ? _value.forecast
          : forecast // ignore: cast_nullable_to_non_nullable
              as Forecast,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherImpl with DiagnosticableTreeMixin implements _Weather {
  const _$WeatherImpl({required this.forecast});

  factory _$WeatherImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherImplFromJson(json);

  @override
  final Forecast forecast;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ForecastWeather(forecast: $forecast)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ForecastWeather'))
      ..add(DiagnosticsProperty('forecast', forecast));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherImpl &&
            (identical(other.forecast, forecast) ||
                other.forecast == forecast));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, forecast);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      __$$WeatherImplCopyWithImpl<_$WeatherImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherImplToJson(
      this,
    );
  }
}

abstract class _Weather implements ForecastWeather {
  const factory _Weather({required final Forecast forecast}) = _$WeatherImpl;

  factory _Weather.fromJson(Map<String, dynamic> json) = _$WeatherImpl.fromJson;

  @override
  Forecast get forecast;
  @override
  @JsonKey(ignore: true)
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Forecast _$ForecastFromJson(Map<String, dynamic> json) {
  return _Forecast.fromJson(json);
}

/// @nodoc
mixin _$Forecast {
  @JsonKey(name: 'forecastday')
  List<ForecastDay> get forecastDay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForecastCopyWith<Forecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastCopyWith<$Res> {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) then) =
      _$ForecastCopyWithImpl<$Res, Forecast>;
  @useResult
  $Res call({@JsonKey(name: 'forecastday') List<ForecastDay> forecastDay});
}

/// @nodoc
class _$ForecastCopyWithImpl<$Res, $Val extends Forecast>
    implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forecastDay = null,
  }) {
    return _then(_value.copyWith(
      forecastDay: null == forecastDay
          ? _value.forecastDay
          : forecastDay // ignore: cast_nullable_to_non_nullable
              as List<ForecastDay>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForecastImplCopyWith<$Res>
    implements $ForecastCopyWith<$Res> {
  factory _$$ForecastImplCopyWith(
          _$ForecastImpl value, $Res Function(_$ForecastImpl) then) =
      __$$ForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'forecastday') List<ForecastDay> forecastDay});
}

/// @nodoc
class __$$ForecastImplCopyWithImpl<$Res>
    extends _$ForecastCopyWithImpl<$Res, _$ForecastImpl>
    implements _$$ForecastImplCopyWith<$Res> {
  __$$ForecastImplCopyWithImpl(
      _$ForecastImpl _value, $Res Function(_$ForecastImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forecastDay = null,
  }) {
    return _then(_$ForecastImpl(
      forecastDay: null == forecastDay
          ? _value._forecastDay
          : forecastDay // ignore: cast_nullable_to_non_nullable
              as List<ForecastDay>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForecastImpl with DiagnosticableTreeMixin implements _Forecast {
  const _$ForecastImpl(
      {@JsonKey(name: 'forecastday')
      required final List<ForecastDay> forecastDay})
      : _forecastDay = forecastDay;

  factory _$ForecastImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForecastImplFromJson(json);

  final List<ForecastDay> _forecastDay;
  @override
  @JsonKey(name: 'forecastday')
  List<ForecastDay> get forecastDay {
    if (_forecastDay is EqualUnmodifiableListView) return _forecastDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forecastDay);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Forecast(forecastDay: $forecastDay)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Forecast'))
      ..add(DiagnosticsProperty('forecastDay', forecastDay));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastImpl &&
            const DeepCollectionEquality()
                .equals(other._forecastDay, _forecastDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_forecastDay));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastImplCopyWith<_$ForecastImpl> get copyWith =>
      __$$ForecastImplCopyWithImpl<_$ForecastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForecastImplToJson(
      this,
    );
  }
}

abstract class _Forecast implements Forecast {
  const factory _Forecast(
      {@JsonKey(name: 'forecastday')
      required final List<ForecastDay> forecastDay}) = _$ForecastImpl;

  factory _Forecast.fromJson(Map<String, dynamic> json) =
      _$ForecastImpl.fromJson;

  @override
  @JsonKey(name: 'forecastday')
  List<ForecastDay> get forecastDay;
  @override
  @JsonKey(ignore: true)
  _$$ForecastImplCopyWith<_$ForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForecastDay _$ForecastDayFromJson(Map<String, dynamic> json) {
  return _ForecastDay.fromJson(json);
}

/// @nodoc
mixin _$ForecastDay {
  Day get day => throw _privateConstructorUsedError;
  List<Hour> get hour => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForecastDayCopyWith<ForecastDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastDayCopyWith<$Res> {
  factory $ForecastDayCopyWith(
          ForecastDay value, $Res Function(ForecastDay) then) =
      _$ForecastDayCopyWithImpl<$Res, ForecastDay>;
  @useResult
  $Res call({Day day, List<Hour> hour, String date});

  $DayCopyWith<$Res> get day;
}

/// @nodoc
class _$ForecastDayCopyWithImpl<$Res, $Val extends ForecastDay>
    implements $ForecastDayCopyWith<$Res> {
  _$ForecastDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hour = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as Day,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as List<Hour>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DayCopyWith<$Res> get day {
    return $DayCopyWith<$Res>(_value.day, (value) {
      return _then(_value.copyWith(day: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForecastDayImplCopyWith<$Res>
    implements $ForecastDayCopyWith<$Res> {
  factory _$$ForecastDayImplCopyWith(
          _$ForecastDayImpl value, $Res Function(_$ForecastDayImpl) then) =
      __$$ForecastDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Day day, List<Hour> hour, String date});

  @override
  $DayCopyWith<$Res> get day;
}

/// @nodoc
class __$$ForecastDayImplCopyWithImpl<$Res>
    extends _$ForecastDayCopyWithImpl<$Res, _$ForecastDayImpl>
    implements _$$ForecastDayImplCopyWith<$Res> {
  __$$ForecastDayImplCopyWithImpl(
      _$ForecastDayImpl _value, $Res Function(_$ForecastDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hour = null,
    Object? date = null,
  }) {
    return _then(_$ForecastDayImpl(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as Day,
      hour: null == hour
          ? _value._hour
          : hour // ignore: cast_nullable_to_non_nullable
              as List<Hour>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForecastDayImpl with DiagnosticableTreeMixin implements _ForecastDay {
  const _$ForecastDayImpl(
      {required this.day, required final List<Hour> hour, required this.date})
      : _hour = hour;

  factory _$ForecastDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForecastDayImplFromJson(json);

  @override
  final Day day;
  final List<Hour> _hour;
  @override
  List<Hour> get hour {
    if (_hour is EqualUnmodifiableListView) return _hour;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hour);
  }

  @override
  final String date;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ForecastDay(day: $day, hour: $hour, date: $date)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ForecastDay'))
      ..add(DiagnosticsProperty('day', day))
      ..add(DiagnosticsProperty('hour', hour))
      ..add(DiagnosticsProperty('date', date));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastDayImpl &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality().equals(other._hour, _hour) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, day, const DeepCollectionEquality().hash(_hour), date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastDayImplCopyWith<_$ForecastDayImpl> get copyWith =>
      __$$ForecastDayImplCopyWithImpl<_$ForecastDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForecastDayImplToJson(
      this,
    );
  }
}

abstract class _ForecastDay implements ForecastDay {
  const factory _ForecastDay(
      {required final Day day,
      required final List<Hour> hour,
      required final String date}) = _$ForecastDayImpl;

  factory _ForecastDay.fromJson(Map<String, dynamic> json) =
      _$ForecastDayImpl.fromJson;

  @override
  Day get day;
  @override
  List<Hour> get hour;
  @override
  String get date;
  @override
  @JsonKey(ignore: true)
  _$$ForecastDayImplCopyWith<_$ForecastDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Hour _$HourFromJson(Map<String, dynamic> json) {
  return _Hour.fromJson(json);
}

/// @nodoc
mixin _$Hour {
  @JsonKey(name: 'chance_of_rain')
  num get chanceOfRain => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HourCopyWith<Hour> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourCopyWith<$Res> {
  factory $HourCopyWith(Hour value, $Res Function(Hour) then) =
      _$HourCopyWithImpl<$Res, Hour>;
  @useResult
  $Res call({@JsonKey(name: 'chance_of_rain') num chanceOfRain});
}

/// @nodoc
class _$HourCopyWithImpl<$Res, $Val extends Hour>
    implements $HourCopyWith<$Res> {
  _$HourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chanceOfRain = null,
  }) {
    return _then(_value.copyWith(
      chanceOfRain: null == chanceOfRain
          ? _value.chanceOfRain
          : chanceOfRain // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourImplCopyWith<$Res> implements $HourCopyWith<$Res> {
  factory _$$HourImplCopyWith(
          _$HourImpl value, $Res Function(_$HourImpl) then) =
      __$$HourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'chance_of_rain') num chanceOfRain});
}

/// @nodoc
class __$$HourImplCopyWithImpl<$Res>
    extends _$HourCopyWithImpl<$Res, _$HourImpl>
    implements _$$HourImplCopyWith<$Res> {
  __$$HourImplCopyWithImpl(_$HourImpl _value, $Res Function(_$HourImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chanceOfRain = null,
  }) {
    return _then(_$HourImpl(
      chanceOfRain: null == chanceOfRain
          ? _value.chanceOfRain
          : chanceOfRain // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HourImpl with DiagnosticableTreeMixin implements _Hour {
  const _$HourImpl(
      {@JsonKey(name: 'chance_of_rain') required this.chanceOfRain});

  factory _$HourImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourImplFromJson(json);

  @override
  @JsonKey(name: 'chance_of_rain')
  final num chanceOfRain;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Hour(chanceOfRain: $chanceOfRain)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Hour'))
      ..add(DiagnosticsProperty('chanceOfRain', chanceOfRain));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourImpl &&
            (identical(other.chanceOfRain, chanceOfRain) ||
                other.chanceOfRain == chanceOfRain));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, chanceOfRain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HourImplCopyWith<_$HourImpl> get copyWith =>
      __$$HourImplCopyWithImpl<_$HourImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourImplToJson(
      this,
    );
  }
}

abstract class _Hour implements Hour {
  const factory _Hour(
          {@JsonKey(name: 'chance_of_rain') required final num chanceOfRain}) =
      _$HourImpl;

  factory _Hour.fromJson(Map<String, dynamic> json) = _$HourImpl.fromJson;

  @override
  @JsonKey(name: 'chance_of_rain')
  num get chanceOfRain;
  @override
  @JsonKey(ignore: true)
  _$$HourImplCopyWith<_$HourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Day _$DayFromJson(Map<String, dynamic> json) {
  return _Day.fromJson(json);
}

/// @nodoc
mixin _$Day {
  @JsonKey(name: 'maxtemp_c')
  num get maxTemperature => throw _privateConstructorUsedError;
  @JsonKey(name: 'mintemp_c')
  num get minTemperature => throw _privateConstructorUsedError;
  Condition get condition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DayCopyWith<Day> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayCopyWith<$Res> {
  factory $DayCopyWith(Day value, $Res Function(Day) then) =
      _$DayCopyWithImpl<$Res, Day>;
  @useResult
  $Res call(
      {@JsonKey(name: 'maxtemp_c') num maxTemperature,
      @JsonKey(name: 'mintemp_c') num minTemperature,
      Condition condition});

  $ConditionCopyWith<$Res> get condition;
}

/// @nodoc
class _$DayCopyWithImpl<$Res, $Val extends Day> implements $DayCopyWith<$Res> {
  _$DayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxTemperature = null,
    Object? minTemperature = null,
    Object? condition = null,
  }) {
    return _then(_value.copyWith(
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as num,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as num,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Condition,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConditionCopyWith<$Res> get condition {
    return $ConditionCopyWith<$Res>(_value.condition, (value) {
      return _then(_value.copyWith(condition: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DayImplCopyWith<$Res> implements $DayCopyWith<$Res> {
  factory _$$DayImplCopyWith(_$DayImpl value, $Res Function(_$DayImpl) then) =
      __$$DayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'maxtemp_c') num maxTemperature,
      @JsonKey(name: 'mintemp_c') num minTemperature,
      Condition condition});

  @override
  $ConditionCopyWith<$Res> get condition;
}

/// @nodoc
class __$$DayImplCopyWithImpl<$Res> extends _$DayCopyWithImpl<$Res, _$DayImpl>
    implements _$$DayImplCopyWith<$Res> {
  __$$DayImplCopyWithImpl(_$DayImpl _value, $Res Function(_$DayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxTemperature = null,
    Object? minTemperature = null,
    Object? condition = null,
  }) {
    return _then(_$DayImpl(
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as num,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as num,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Condition,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayImpl with DiagnosticableTreeMixin implements _Day {
  const _$DayImpl(
      {@JsonKey(name: 'maxtemp_c') required this.maxTemperature,
      @JsonKey(name: 'mintemp_c') required this.minTemperature,
      required this.condition});

  factory _$DayImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayImplFromJson(json);

  @override
  @JsonKey(name: 'maxtemp_c')
  final num maxTemperature;
  @override
  @JsonKey(name: 'mintemp_c')
  final num minTemperature;
  @override
  final Condition condition;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Day(maxTemperature: $maxTemperature, minTemperature: $minTemperature, condition: $condition)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Day'))
      ..add(DiagnosticsProperty('maxTemperature', maxTemperature))
      ..add(DiagnosticsProperty('minTemperature', minTemperature))
      ..add(DiagnosticsProperty('condition', condition));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayImpl &&
            (identical(other.maxTemperature, maxTemperature) ||
                other.maxTemperature == maxTemperature) &&
            (identical(other.minTemperature, minTemperature) ||
                other.minTemperature == minTemperature) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, maxTemperature, minTemperature, condition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayImplCopyWith<_$DayImpl> get copyWith =>
      __$$DayImplCopyWithImpl<_$DayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayImplToJson(
      this,
    );
  }
}

abstract class _Day implements Day {
  const factory _Day(
      {@JsonKey(name: 'maxtemp_c') required final num maxTemperature,
      @JsonKey(name: 'mintemp_c') required final num minTemperature,
      required final Condition condition}) = _$DayImpl;

  factory _Day.fromJson(Map<String, dynamic> json) = _$DayImpl.fromJson;

  @override
  @JsonKey(name: 'maxtemp_c')
  num get maxTemperature;
  @override
  @JsonKey(name: 'mintemp_c')
  num get minTemperature;
  @override
  Condition get condition;
  @override
  @JsonKey(ignore: true)
  _$$DayImplCopyWith<_$DayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Condition _$ConditionFromJson(Map<String, dynamic> json) {
  return _Condition.fromJson(json);
}

/// @nodoc
mixin _$Condition {
  String get text => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConditionCopyWith<Condition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConditionCopyWith<$Res> {
  factory $ConditionCopyWith(Condition value, $Res Function(Condition) then) =
      _$ConditionCopyWithImpl<$Res, Condition>;
  @useResult
  $Res call({String text, String icon});
}

/// @nodoc
class _$ConditionCopyWithImpl<$Res, $Val extends Condition>
    implements $ConditionCopyWith<$Res> {
  _$ConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConditionImplCopyWith<$Res>
    implements $ConditionCopyWith<$Res> {
  factory _$$ConditionImplCopyWith(
          _$ConditionImpl value, $Res Function(_$ConditionImpl) then) =
      __$$ConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String icon});
}

/// @nodoc
class __$$ConditionImplCopyWithImpl<$Res>
    extends _$ConditionCopyWithImpl<$Res, _$ConditionImpl>
    implements _$$ConditionImplCopyWith<$Res> {
  __$$ConditionImplCopyWithImpl(
      _$ConditionImpl _value, $Res Function(_$ConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? icon = null,
  }) {
    return _then(_$ConditionImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConditionImpl with DiagnosticableTreeMixin implements _Condition {
  const _$ConditionImpl({required this.text, required this.icon});

  factory _$ConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConditionImplFromJson(json);

  @override
  final String text;
  @override
  final String icon;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Condition(text: $text, icon: $icon)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Condition'))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConditionImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConditionImplCopyWith<_$ConditionImpl> get copyWith =>
      __$$ConditionImplCopyWithImpl<_$ConditionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConditionImplToJson(
      this,
    );
  }
}

abstract class _Condition implements Condition {
  const factory _Condition(
      {required final String text,
      required final String icon}) = _$ConditionImpl;

  factory _Condition.fromJson(Map<String, dynamic> json) =
      _$ConditionImpl.fromJson;

  @override
  String get text;
  @override
  String get icon;
  @override
  @JsonKey(ignore: true)
  _$$ConditionImplCopyWith<_$ConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
