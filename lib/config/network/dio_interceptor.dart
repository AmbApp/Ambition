import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/helpers.dart';

class DioInterceptior extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("accessToken");
    logger(authToken.toString());
    options.headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    logger('accessToken: $authToken');
    if (authToken != null) {
      options.headers = <String, String>{"Authorization": authToken};
    }
  }

  @override
  Future<String> onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    logger(
        "DioInterceptor.class: Error from dio request: ${err.toString()}, ${err.response?.data?.toString()}, ${err.message}, ${err.requestOptions.data.toString()}, ${err.requestOptions.uri.toString()}");

    if (err.response != null) {
      if (err.response!.data != null) {
        if (err.response!.data!
            .toString()
            .contains("SocketException: Failed host lookup")) {
          handler.reject(DioError(
              requestOptions:
                  RequestOptions(path: "", data: {"message": "no iNTERNET"})));
        }

        if (err.response!.data.toString().contains("INVALID_TOKEN")) {
          final prefs = await SharedPreferences.getInstance();

          final String? token = prefs.getString("authToken");

          logger("Logging out due to invalid token");
        }
      }
    }

    return err.response?.data?.toString() ?? "";
  }
}
