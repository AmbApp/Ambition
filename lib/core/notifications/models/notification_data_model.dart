import '../../ride/models/items.dart';
import '../../ride/models/requirements.dart';

class NotificationDataModel {
  String? rideId;
  String? passengerId;
  String? passengerContact;
  String? driverName;
  String? passengerName;
  String? helperName;
  String? rideSource;
  String? rideDestination;
  String? type;
  double? distance;
  double? fare;
  double? eta;
  List<Items>? items;
  Requirement? requirements;
  dynamic data;

  NotificationDataModel({this.data});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    data = json['rideId'];
    rideId = json['rideId'];
    passengerContact = json['passengerContact'];
    rideId = json['rideId'];
    helperName = json['helperName'];
    driverName = json['driverName'];
    passengerName = json['passengerName'];
    rideSource = json['rideSource'];
    requirements = json['requirements'];
    rideDestination = json['rideDestination'];
    type = json['type'];
    items = json['items'] == null
        ? null
        : (json['items'] as List<dynamic>?)
            ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
            .toList();
    // items   = json['items'] == null
    //     ? null
    //     : (json['items'] as List<dynamic>?)
    //         ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
    //         .toList();
    distance = double.parse(json['distance']);
    fare = double.parse(json['fare']);
    eta = double.parse(json['ETA']);
  }
}
