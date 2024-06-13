import 'package:dio/dio.dart';

abstract class BaseClientService {
  Dio customDio() {
    Dio dio = Dio();
    dio.options = BaseOptions(
        baseUrl: 'http://api.weatherapi.com/v1',
        connectTimeout: const Duration(seconds: 36000),
        receiveTimeout: const Duration(seconds: 36000));
    return dio;
  }
}
