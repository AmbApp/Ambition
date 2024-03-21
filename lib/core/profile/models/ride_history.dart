import 'package:ambition_app/core/profile/models/ride_history_datum.dart';

import '../../../Utils/helpers.dart';

class RideHistoryResponse {
  int? statusCode;
  String? error;
  List<RideHistoryData>? data;

  RideHistoryResponse({this.statusCode, this.error, this.data});

  factory RideHistoryResponse.fromJson(dynamic json) {
    logger(json.toString());
    return RideHistoryResponse(
        data: List<RideHistoryData>.from(
            json.map((x) => RideHistoryData.fromJson(x))));
  }
}
