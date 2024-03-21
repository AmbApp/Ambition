import 'package:ambition_app/core/notifications/models/request_ride_model_data.dart';

class Ride {
  String? sId;
  SourceCoordinates? sourceCoordinates;
  List<DestinationCoordinates>? destinationCoordinates;
  List<Item>? items;
  String? moveType;
  String? rideStatus;
  String? passengerId;
  List<String>? traversedCoordinates;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? driverId;

  Ride(
      {this.sId,
      this.sourceCoordinates,
      this.destinationCoordinates,
      this.items,
      this.moveType,
      this.rideStatus,
      this.passengerId,
      this.traversedCoordinates,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.driverId});

  Ride.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sourceCoordinates = json['sourceCoordinates'] != null
        ? new SourceCoordinates.fromJson(json['sourceCoordinates'])
        : null;
    if (json['destinationCoordinates'] != null) {
      destinationCoordinates = <DestinationCoordinates>[];
      json['destinationCoordinates'].forEach((v) {
        destinationCoordinates!.add(new DestinationCoordinates.fromJson(v));
      });
    }
    // if (json['items'] != null) {
    //   items = <Null>[];
    //   json['items'].forEach((v) {
    //     items!.add(new Item.fromJson(v));
    //   });
    // }
    moveType = json['moveType'];
    rideStatus = json['rideStatus'];
    passengerId = json['passengerId'];
    traversedCoordinates = json['traversedCoordinates'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.sourceCoordinates != null) {
      data['sourceCoordinates'] = this.sourceCoordinates!.toJson();
    }
    if (this.destinationCoordinates != null) {
      data['destinationCoordinates'] =
          this.destinationCoordinates!.map((v) => v.toJson()).toList();
    }
    // if (this.items != null) {
    //   data['items'] = this.items!.map((v) => v.toJson()).toList();
    // }
    data['moveType'] = this.moveType;
    data['rideStatus'] = this.rideStatus;
    data['passengerId'] = this.passengerId;
    data['traversedCoordinates'] = this.traversedCoordinates;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['driverId'] = this.driverId;
    return data;
  }
}

class SourceCoordinates {
  String? lat;
  String? lng;

  SourceCoordinates({this.lat, this.lng});

  SourceCoordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class DestinationCoordinates {
  String? lat;
  String? lng;
  String? sId;

  DestinationCoordinates({this.lat, this.lng, this.sId});

  DestinationCoordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['_id'] = this.sId;
    return data;
  }
}
