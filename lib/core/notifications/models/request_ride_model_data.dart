class RequestRideNotification {
  final RideDetails rideDetails;
  final FilteredRideDetails filteredRideDetails;

  RequestRideNotification(
      {required this.rideDetails, required this.filteredRideDetails});

  factory RequestRideNotification.fromJson(Map<String, dynamic> json) {
    return RequestRideNotification(
      rideDetails: RideDetails.fromJson(json['rideDetails']),
      filteredRideDetails:
          FilteredRideDetails.fromJson(json['filteredRideDetails']),
    );
  }
}

class RideDetails {
  final String createdAt;
  final Requirements requirements;
  final List<Coordinate> destinationCoordinates;
  final Coordinate sourceCoordinates;
  final List<dynamic> traversedCoordinates; // Assuming dynamic type
  final int v;
  final String rideStatus;
  final String passengerId;
  final String id;
  final List<Item> items;
  final String moveType;
  final String updatedAt;

  RideDetails({
    required this.createdAt,
    required this.requirements,
    required this.destinationCoordinates,
    required this.sourceCoordinates,
    required this.traversedCoordinates,
    required this.v,
    required this.rideStatus,
    required this.passengerId,
    required this.id,
    required this.items,
    required this.moveType,
    required this.updatedAt,
  });

  factory RideDetails.fromJson(Map<String, dynamic> json) {
    return RideDetails(
      createdAt: json['createdAt'],
      requirements: Requirements.fromJson(json['requirements']),
      destinationCoordinates: List<Coordinate>.from(
          json['destinationCoordinates'].map((x) => Coordinate.fromJson(x))),
      sourceCoordinates: Coordinate.fromJson(json['sourceCoordinates']),
      traversedCoordinates: List<dynamic>.from(
          json['traversedCoordinates'].map((x) => x)), // Assuming dynamic type
      v: json['__v'],
      rideStatus: json['rideStatus'],
      passengerId: json['passengerId'],
      id: json['_id'],
      items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
      moveType: json['moveType'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Requirements {
  final String selectedFloorStart;
  final bool requires2People;
  final int peopleTaggingAlong;
  final String selectedFloorEnd;
  final String specialRequirements;

  Requirements({
    required this.selectedFloorStart,
    required this.requires2People,
    required this.peopleTaggingAlong,
    required this.selectedFloorEnd,
    required this.specialRequirements,
  });

  factory Requirements.fromJson(Map<String, dynamic> json) {
    return Requirements(
      selectedFloorStart: json['selectedFloorStart'],
      requires2People: json['requires2People'],
      peopleTaggingAlong: json['peopleTaggingAlong'],
      selectedFloorEnd: json['selectedFloorEnd'],
      specialRequirements: json['specialRequirements'],
    );
  }
}

class Coordinate {
  final String lng;
  final String lat;

  Coordinate({required this.lng, required this.lat});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      lng: json['lng'],
      lat: json['lat'],
    );
  }
}

class Item {
  final String qty;
  final String name;
  final String id;

  Item({required this.qty, required this.name, required this.id});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qty: json['qty'],
      name: json['name'],
      id: json['_id'],
    );
  }
}

class FilteredRideDetails {
  final int fare;
  final String eta;
  final String driverId;
  final String distance;
  final String totalTime;
  final String id;

  FilteredRideDetails({
    required this.fare,
    required this.eta,
    required this.driverId,
    required this.distance,
    required this.totalTime,
    required this.id,
  });

  factory FilteredRideDetails.fromJson(Map<String, dynamic> json) {
    return FilteredRideDetails(
      fare: json['fare'],
      eta: json['eta'],
      driverId: json['driverId'],
      distance: json['distance'],
      totalTime: json['totalTime'],
      id: json['_id'],
    );
  }
}
