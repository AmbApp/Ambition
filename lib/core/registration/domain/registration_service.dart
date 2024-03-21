import '../models/driver_response.dart';
import '../models/file_upload_response.dart';

abstract class RegistrationService {
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
  );

  Future<DriverInfoResponse> registerVehicle(
    String make,
    String color,
    String pcoLicense,
    String licensePlate,
  );
  Future<DriverInfoResponse> getDriver();
  Future<DriverInfoResponse> updateDriverInfo(String? userId);
  Future<DriverInfoResponse> searchDriver(String? userId);
  Future<FileUploadResponse> uploadFile();
}
