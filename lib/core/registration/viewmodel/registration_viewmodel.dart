import 'package:flutter/material.dart';

import '../../../Utils/helpers.dart';
import '../../../config/network/resources.dart';

import '../domain/registration_service.dart';
import '../models/driver_response.dart';
import '../models/file_upload_response.dart';
import '../service/registration_service_impl.dart';

class RegistrationViewModel extends ChangeNotifier {
  late RegistrationService _registrationService;

  RegistrationViewModel() {
    _registrationService = RegistrationServiceImpl();
  }

  Resource<DriverInfoResponse> getDriverResource = Resource.idle();

  String id = '';
  String active = '';
  String cnicBack = '';
  String cnicFront = '';
  String licenseBack = '';
  String licenseFront = '';
  String userId = '';
  String verified = '';

  Future<void> getDriver() async {
    try {
      getDriverResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response =
          await _registrationService.getDriver();

      debugPrint('getDriver');
      debugPrint(response.toString());
      getDriverResource = Resource.success(response);

      // id = getDriverResource.modelResponse!.data!.id!.toString();
      // active = getDriverResource.modelResponse!.data!.active.toString();
      // cnicBack = getDriverResource.modelResponse!.data!.cnicBack.toString();
      // cnicFront = getDriverResource.modelResponse!.data!.cnicFront.toString();
      // licenseBack =
      //     getDriverResource.modelResponse!.data!.licenseBack.toString();
      // licenseFront =
      //     getDriverResource.modelResponse!.data!.licenseFront.toString();
      // userId = getDriverResource.modelResponse!.data!.userId.toString();
      // verified = getDriverResource.modelResponse!.data!.verified.toString();

      notifyListeners();
    } catch (e) {
      getDriverResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<DriverInfoResponse> registerDriverResource = Resource.idle();

  Future<void> registerDriver({
    required String? niNumberFrontImage,
    required String? niNumberBackImage,
    required String? niNumberIssueDate,
    required String? niNumberExpireDate,
    required String? drivingLicenseFrontImage,
    required String? drivingLicenseBackImage,
    required String? drivingLicenseIssueDate,
    required String? drivingLicenseExpireDate,
    required String? profilePicture,
    required String? proof0fAddress,
    required String? account,
    required String? commercialVehicle,
    required String? goodInTransit,
    required bool? isVerified,
  }) async {
    try {
      registerDriverResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response =
          await _registrationService.registerDriver(
        niNumberFrontImage!,
        niNumberBackImage!,
        niNumberIssueDate!,
        niNumberExpireDate!,
        drivingLicenseFrontImage!,
        drivingLicenseBackImage!,
        drivingLicenseIssueDate!,
        drivingLicenseExpireDate!,
        profilePicture!,
        proof0fAddress!,
        commercialVehicle!,
        goodInTransit!,
        account!,
        isVerified!,
      );

      registerDriverResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      registerDriverResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<DriverInfoResponse> registerVehicleResource = Resource.idle();

  Future<void> registerVehicle(
      {required String make,
      required String color,
      required String licensePlate,
      required String pcoLicense}) async {
    try {
      registerVehicleResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response = await _registrationService
          .registerVehicle(make, color, licensePlate, pcoLicense);

      registerVehicleResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      registerVehicleResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<FileUploadResponse> fileUploadResource = Resource.idle();

  Future<String?> uploadFile() async {
    try {
      fileUploadResource = Resource.loading();
      notifyListeners();

      logger('FileUploadResponse CALLED');
      final FileUploadResponse response =
          await _registrationService.uploadFile();

      logger('FileUploadResponse');
      logger(response.toString());
      fileUploadResource = Resource.success(response);
      notifyListeners();

      return fileUploadResource.modelResponse?.data?.fileUrl;
    } catch (e) {
      getDriverResource = Resource.failed(e.toString());
      notifyListeners();
      return '';
    }
  }
}
