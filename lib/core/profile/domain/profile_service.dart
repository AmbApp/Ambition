import 'package:ambition_app/core/ride/models/ride.dart';

import '../models/ride.dart';
import '../models/ride_history.dart';
import '../models/user_info_response.dart';

abstract class ProfileService {
  Future<RideHistoryResponse> getRideHistory();
  Future<UserInfoResponse> getProfile();
  Future<UserInfoResponse> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? locale,
    String? timezone,
    String? currentCity,
    String? gender,
    String? birthDate,
    String? profilePic,
    String? currentMode,
    bool? optedInAt,
    bool? active,
    bool? verified,
  });
}
