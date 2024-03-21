import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/error.dart';
import '../../../Utils/helpers.dart';
import '../../../config/network/network_config.dart';

import '../domain/registration_service.dart';
import '../models/driver_response.dart';
import '../models/file_upload_response.dart';

class RegistrationServiceImpl extends RegistrationService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<DriverInfoResponse> registerDriver(
    String niNumberFrontImage,
    String niNumberBackImage,
    String niNumberIssueDate,
    String niNumberExpireDate,
    String drivingLicenseFrontImage,
    String drivingLicenseBackImage,
    String drivingLicenseIssueDate,
    String drivingLicenseExpireDate,
    String profilePicture,
    String proof0fAddress,
    String commercialVehicle,
    String goodInTransit,
    String account,
    bool isVerified,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final body = {
        "userId": id,
        "niNumberFrontImage": niNumberFrontImage,
        "niNumberBackImage": niNumberBackImage,
        "niNumberIssueDate": niNumberIssueDate,
        "niNumberExpireDate": niNumberExpireDate,
        "drivingLicenseFrontImage": drivingLicenseFrontImage,
        "drivingLicenseBackImage": drivingLicenseBackImage,
        "drivingLicenseIssueDate": drivingLicenseIssueDate,
        "drivingLicenseExpireDate": drivingLicenseExpireDate,
        "profile_picture": profilePicture,
        "proof_of_address": proof0fAddress,
        "commercialVehicle": commercialVehicle,
        "goodInTransit": goodInTransit,
        "account": account,
        "isVerified": isVerified
      };

      logger("RegisterDriverImpl: registerDriver() Body: $body");

      final Response response = await dio.post('/documents',
          data: jsonEncode(body),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      logger("RegisterDriverImpl: registerDriver() Respose: $response.data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse =
            DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        logger(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> getDriver() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("driverId");

      final Response response =
          await dio.get('/driver/$id', queryParameters: {'id': id});
      debugPrint(response.data.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse =
            DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        debugPrint("Getting Driver Details");
        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> updateDriverInfo(String? userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final Response response = await dio.get('/user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse =
            DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        logger(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> searchDriver(String? userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final Response response = await dio.get('/user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse =
            DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        logger(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<FileUploadResponse> uploadFile() async {
    try {
      final Response response = await dio.post('/file');

      logger(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final FileUploadResponse fileResponse =
            FileUploadResponse.fromJson(response.data as Map<String, dynamic>);

        return fileResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> registerVehicle(
    String make,
    String color,
    String pcoLicense,
    String licensePlate,
  ) async {
    logger('VEHICLE 2');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? driverId = prefs.getString("driverID");

    try {
      final body = {
        "name": make,
        "color": color,
        "pcoLicense": pcoLicense,
        "licensePlate": licensePlate,
        "driverId": driverId,
      };

      logger("RegisterDriverImpl: registerVehicle() Body: $body");

      final Response response = await dio.post('/vehicle',
          data: jsonEncode(body),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      logger("RegisterDriverImpl: registerVehicle() Respose: $response.data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse =
            DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        logger(response.data.toString());

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }
}
