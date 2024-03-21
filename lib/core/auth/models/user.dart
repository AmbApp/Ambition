import '../../../Utils/helpers.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? fcmToken;
  bool active = false;
  bool verified = false;
  String? currentMode;
  String? OTP;
  bool isAvatarImageSet = false;
  String? avatarImage;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  int? v;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.fcmToken,
    this.active = false,
    this.verified = false,
    this.currentMode,
    this.OTP,
    this.isAvatarImageSet = false,
    this.avatarImage,
    // this.createdAt,
    // this.updatedAt,
    // this.v,
  });

  User.fromJson(Map<String, dynamic> json) {
    logger('HEEEE');
    logger(json.toString());
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    fcmToken = json['fcm_token']; // Added this line
    active = json['active'] ?? false;
    verified = json['verified'] ?? false;
    currentMode = json['currentMode'];
    OTP = json['OTP'];
    isAvatarImageSet = json['isAvatarImageSet'] ?? false;
    avatarImage = json['avatarImage'];

    // v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['fcm_token'] = fcmToken; // Added this line
    data['active'] = active;
    data['verified'] = verified;
    data['currentMode'] = currentMode;
    data['OTP'] = OTP;
    data['isAvatarImageSet'] = isAvatarImageSet;
    data['avatarImage'] = avatarImage;
    // data['createdAt'] = createdAt?.toIso8601String();
    // data['updatedAt'] = updatedAt?.toIso8601String();
    // data['__v'] = v;
    return data;
  }
}
