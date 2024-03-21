import 'package:dio/dio.dart';

import 'dio_interceptor.dart';

class NetworkConfig {
  static final NetworkConfig _instance = NetworkConfig._internal();

  late Dio dio;

  static const _DEV_URL = "https://ambitionbackend-258e6c7522d2.herokuapp.com/";

  factory NetworkConfig() {
    return _instance;
  }

  NetworkConfig._internal();

  void initNetworkConfig() {
    late String baseUrl;

    baseUrl = NetworkConfig._DEV_URL;

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 20000,
        receiveTimeout: 10000,
      ),
    )..interceptors.add(DioInterceptior());
  }
}
