import '../../../Utils/helpers.dart';
import '../../auth/models/user.dart';

class UserInfoResponse {
  int? code;
  String? error;
  User? data;

  UserInfoResponse({this.code, this.error, this.data});

  factory UserInfoResponse.fromJson(json) {
    logger('EJEE');
    return UserInfoResponse(
      data: User.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data?.toJson(),
      };
}
