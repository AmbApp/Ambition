// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:socket_io_client/socket_io_client.dart" as IO;
import 'package:ambition_app/core/home/screens/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/device_info_service.dart';
import '../../../Utils/error.dart';
import '../../../Utils/helpers.dart';
import '../../../config/network/network_config.dart';
import '../../notifications/services/notification_service.dart';
import '../../registration/modals/registration_modal.dart';
import '../screens/otp_screen.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  String actualCode = '';

  final Dio dio = NetworkConfig().dio;

  @observable
  bool isPhoneLoading = false;
  @observable
  bool isEmailLoading = false;

  @observable
  late bool isOtpLoading = false;

  @observable
  late bool isUserInfoLoading = false;

  @observable
  late bool isPhoneDone = false;

  @observable
  late bool isEmailDone = false;

  @observable
  late bool isOtpDone = false;

  @observable
  bool isDriver = false;

  @observable
  bool isRegistering = false;

  @observable
  String? userId = '';

  @observable
  late String authToken = '';

  bool get isAuth {
    return authToken != '';
  }

  // PHONE SIGN IN
  @action
  Future<void> phoneLogin(
      BuildContext context, String phone, String pass) async {
    String token = await NotificationService.getToken();
    final body = {"phone": phone, "password": pass, 'fcmToken': token};

    debugPrint('/authentication/login${body.toString()}');
    if (phone != '') {
      try {
        isPhoneLoading = true;
        final Response response = await dio.post(
          '/authentication/login',
          data: jsonEncode(body),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );
        debugPrint(response.toString());
        isPhoneLoading = false;

        debugPrint(response.statusCode.toString());

        if (response.statusCode == 200 || response.statusCode == 201) {
          isPhoneDone = true;

          logger('response');
          logger(response.toString());

          Future.delayed(const Duration(milliseconds: 1), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpPage(
                  phoneNumber: phone,
                  otpmode: 'login',
                ),
              ),
            );
          });
        } else {
          isPhoneLoading = false;

          final String errorMsg = response.statusMessage as String;

          _showSnackBar(context, errorMsg);
          AppErrors.processErrorJson(
              response.data['data'] as Map<String, dynamic>);
        }
      } on DioError catch (e) {
        isPhoneLoading = false;

        if (e.response != null) {
          final errorMessage = e.response!.data?["message"]?.toString() ??
              "Unknown error"; // Get the error message from the response data
          _showSnackBar(context, errorMessage);
          logger(e.response!.data.toString());
        } else {
          final errorMessage = "Network Error: ${e.message}";
          _showSnackBar(context, errorMessage);
          logger(e.message);
        }
      }
    } else {
      _showSnackBar(
        context,
        "Please provide a phone number",
      );
    }
  }

  // OTP VERIFICATION
  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode,
      String phone, String otpmode) async {
    final body = {"phone": phone, "OneTimePassword": smsCode};
    final url =
        '/authentication/${otpmode == 'login' ? 'confirmLoginOTP' : 'confirmRegOTP'}';

    logger(jsonEncode(body).toString());
    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      isOtpLoading = false;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        isOtpLoading = false;

        saveUserDataToSharedPrefs(responseData);
        onOtpSuccessful(context, otpmode, responseData);
      } else {
        const String errorMsg = "Unknown error while registering";
        _showSnackBar(context, errorMsg);
      }
    } on DioError catch (e) {
      isOtpLoading = false;

      if (e.response != null) {
        final errorMessage =
            e.response!.data?["error"]?.toString() ?? "Unknown error";
        _showSnackBar(context, errorMessage);
        logger(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        final errorMessage = "Network Error: ${e.message}";
        _showSnackBar(context, errorMessage);
        logger(e.message);
      }
    }
  }

  // OTP VERIFICATION
  @action
  Future<void> resendOtp(BuildContext context, String phone) async {
    final body = {
      "phone": phone,
    };

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post(
        '/authentication/resendRegOTP',
        data: jsonEncode(body),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      isOtpLoading = false;
      final result = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        isUserInfoLoading = false;
        logger(response.toString());
      } else {
        final String errorMsg = response.data['data']["message"] as String;
        _showSnackBar(context, errorMsg);
      }
    } on DioError catch (e) {
      isOtpLoading = false;

      if (e.response != null) {
        final errorMessage = e.response!.data?["mesage"]?.toString() ??
            "Unknown error"; // Get the error message from the response data
        _showSnackBar(context, errorMessage);
        logger(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        final errorMessage = "Network Error: ${e.message}";
        _showSnackBar(context, errorMessage);
        logger(e.message);
      }
    }
  }

  @action
  Future<void> resetPassword(BuildContext context, String phone,
      String oldPassword, String newPassword) async {
    final body = {
      "phone": phone,
      "oldPassword": oldPassword,
      'newPassword': newPassword
    };
  }

  // USER SIGNUP
  @action
  Future<void> registerUser(
      BuildContext context,
      String password,
      String phone,
      String email,
      String firstName,
      String lastName,
      String? currentMode,
      String? account) async {
    String token = await NotificationService.getToken();

    final body = {
      "password": password,
      "phone": phone,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "currentMode": currentMode ?? 'driver',
      "account": 'personal',
      'fcmToken': token
    };

    logger(body.toString());

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post(
        'authentication/registration',
        data: jsonEncode(body),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      isOtpLoading = false;
      logger(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpPage(
              phoneNumber: phone,
              otpmode: 'signup',
            ),
          ),
        );
        debugPrint("response.toString()");
        debugPrint(response.toString());
        debugPrint(response.data.toString());
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpPage(
              phoneNumber: phone,
              otpmode: 'signup',
            ),
          ),
        );
        debugPrint("registerUser. error");
        final String errorMsg = response.statusMessage as String;
        _showSnackBar(context, errorMsg);
      }
    } on DioError catch (e) {
      isOtpLoading = false;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpPage(
            phoneNumber: phone,
            otpmode: 'signup',
          ),
        ),
      );
      if (e.response != null) {
        final errorMessage = e.response!.data?["error"]?.toString() ??
            "error while registering, try again"; // Get the error message from the response data
        _showSnackBar(context, errorMessage);
        logger(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        final errorMessage = "Network Error: ${e.message}";
        _showSnackBar(context, errorMessage);
        logger(e.message);
      }
    }
  }

  Future<void> onOtpSuccessful(BuildContext context, String otpmode,
      Map<String, dynamic> response) async {
    isOtpDone = true;
    if (otpmode == 'login') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      log("response['currentMode'].toString()");
      log(response.toString());
      log(response['currentMode'].toString());
      final bool isDriver = response['currentMode'] == 'driver';
      log("isDriver.toString(");
      log(isDriver.toString());
      if (true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationModal(),
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
    isOtpLoading = false;
  }

  Future<void> loadInitialDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final DeviceInformation? deviceInformation =
        await DeviceInfoService.getDeviceInfo();

    final bool isDriver = prefs.getString('currentMode').toString() == 'driver';
    this.isDriver = isDriver;
    logger(isDriver.toString());

    final String userId = prefs.getString('userID') ?? '';

    String token = await NotificationService.getToken();

    var body = {
      "userId": userId,
      "deviceType": deviceInformation?.toString() ?? '',
      "token": token
    };

    // try {
    //   final response = await dio.post(
    //     '/user/device',
    //     data: jsonEncode(body),
    //   );
    //   debugPrint(response.data.toString());

    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     logger("Response After posting token: ${response.data}");
    //   } else {}
    // } on DioError catch (e) {
    //   logger('Sending ddevice data $e');
    // }
  }

  void saveUserDataToSharedPrefs(Map<String, dynamic> userAuth) async {
    logger('user:');

    logger(userAuth.toString());

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('currentMode', userAuth['currentMode'] as String? ?? '');
      prefs.setString(
          'refreshToken', userAuth['refreshToken'] as String? ?? '');
      prefs.setString('userID', userAuth['_id'] as String? ?? '');
      prefs.setString('userMode', userAuth['currentMode'] as String? ?? '');

      prefs.setString("user", jsonEncode(userAuth));

      final String? currentMode = userAuth['currentMode'] as String?;
      prefs.setString("accessToken", 'signed in');

      final bool isDriver = currentMode == 'driver';
      this.isDriver = isDriver;
      logger("current mode ");
      logger(userAuth['_id'].toString());
      logger(currentMode.toString());

      if (currentMode == 'driver') {
        prefs.setBool("isDriver", true);
        prefs.setString("driverID", userAuth['_id'] as String? ?? '');
        connectAndListen(userAuth['_id'] as String);
      } else {
        prefs.setBool("isDriver", false);
        prefs.setString("passengerID", userAuth['_id'] as String? ?? '');
      }
    });
  }

  void connectAndListen(String id) {
    logger('connectAndListen');
    logger(id);
    Socket socket = IO.io('https://ambitionbackend-258e6c7522d2.herokuapp.com/',
        OptionBuilder().setTransports(['websocket']).build());
    socket.connect();

    socket.onConnect((_) {
      logger('connected');
      socket.emit('message', 'Hello From Flutter Client App');
    });

    socket.on('message', (data) => logger(' message from socket $data'));

    socket.emit('add-user', {
      'userId': id,
      'lat': '51.5116269',
      'lng': '-0.147806',
    });
    logger('connected done');
    socket.onDisconnect((_) => logger('disconnect'));
  }
  // // saving user to Shared preferences
  // Future<void> _storeUserData(responseData) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // final DeviceInformation? deviceInformation =
  //   //     await DeviceInfoService.getDeviceInfo();

  //   // prefs.setString("deviceId", deviceInformation?.uUID.toString() ?? '');
  //   // prefs.setString("deviceInfo", deviceInformation?.toJson().toString() ?? '');

  //   String token = await NotificationService.getToken();

  // final Map<String, dynamic> userAuth =
  //     responseData['data'] as Map<String, dynamic>;
  // debugPrint(userAuth['user'].toString());

  // prefs.setString('currentMode', userAuth['currentMode'] as String);
  // prefs.setString('refreshToken', userAuth['refreshToken'] as String);
  // prefs.setString('userID', userAuth['userId'] as String);
  // prefs.setString('userMode', userAuth['user']['currentMode'] as String);
  // prefs.setString("user", jsonEncode(userAuth['user']));

  // userId = userAuth['userId'] as String;
  // logger(userAuth['user']['currentMode']);
  // isDriver = true;
  // if (userAuth['user']['currentMode'] == 'driver') {
  //   logger('CURRENT MODE');
  //   logger(userAuth['user']['currentMode']);
  //   isDriver = true;
  //   prefs.setString("driverID", userAuth['driverId'] as String);
  // } else {
  //   isDriver = false;
  //   prefs.setString("passengerID", userAuth['passengerId'] as String);
  // }

  // var body = {
  //   "userId": userAuth['userId'] as String,
  // "deviceType": deviceInformation?.toString() ?? '',
  // "token": token
  // };

  // try {
  //   final response = await dio.post(
  //     '/user/device',
  //     data: jsonEncode(body),
  //   );
  //   debugPrint(response.data.toString());

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     logger("Response After posting token: ${response.data}");
  //   } else {
  //     debugPrint("sendValuesToBackend(). Failed response from Backend");
  //   }
  // } on DioError catch (e) {
  //   logger('Sending ddevice data $e');
  // }
  // }

  // logging out user
  Future<void> logoutUser(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await FirebaseMessaging.instance.deleteToken();
      await prefs.clear();
    } on DioError catch (e) {
      isOtpLoading = false;

      if (e.response != null) {
        final errorMessage = e.response!.data?["error"]?.toString() ??
            "Unknown error"; // Get the error message from the response data
        _showSnackBar(context, errorMessage);
        logger(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        final errorMessage = "Network Error: ${e.message}";
        _showSnackBar(context, errorMessage);
        logger(e.message);
      }
    }
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: AppColors.SECONDARY,
        content: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
