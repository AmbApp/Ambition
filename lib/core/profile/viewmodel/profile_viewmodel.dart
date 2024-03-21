import 'package:ambition_app/Utils/helpers.dart';
import 'package:ambition_app/core/profile/domain/profile_service.dart';

import 'package:ambition_app/core/profile/service/profile_service_impl.dart';
import 'package:flutter/material.dart';

import '../../../config/network/resources.dart';

import '../models/ride_history.dart';
import '../models/ride_history_datum.dart';
import '../models/user_info_response.dart';

class ProfileViewModel extends ChangeNotifier {
  late ProfileService _registrationService;

  ProfileViewModel() {
    _registrationService = ProfileServiceImpl();
  }

  Resource<RideHistoryResponse> getHistoryResource = Resource.idle();
  Resource<UserInfoResponse> getProfileResource = Resource.idle();

  List<RideHistoryData> _rideHistory = [];
  List<RideHistoryData> get rideHistory => _rideHistory;

  String? name = '';
  String? email = '';
  String? phone = '';
  String? id = "";
  String? image = "";

  Future<void> getUserProfile() async {
    try {
      // getProfileResource = Resource.loading();
      // notifyListeners();

      _rideHistory = [];

      final UserInfoResponse response = await _registrationService.getProfile();
      logger('HERE');
      logger(response.toString());
      getProfileResource = Resource.success(response);

      name = response.data!.firstName;
      email = response.data!.email.toString();
      phone = response.data!.phone!;
      image = response.data!.avatarImage!.toString();
      id = response.data!.id!.toString();
      logger(name);
      logger(id);

      notifyListeners();
    } catch (e) {
      getProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Future<void> getRideHistory() async {
    try {
      getHistoryResource = Resource.loading();
      notifyListeners();

      _rideHistory = [];

      final RideHistoryResponse response =
          await _registrationService.getRideHistory();

      for (var datum in response.data!) {
        _rideHistory.add(datum);
      }

      getHistoryResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      getHistoryResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
