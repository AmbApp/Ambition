class RideHistoryData {
  final Requirements requirements;
  final String id;
  final Coordinates sourceCoordinates;
  final List<Coordinates> destinationCoordinates;
  final List<Item> items;
  final String moveType;
  final String rideStatus;
  final String passengerId;
  final List<dynamic>
      traversedCoordinates; // Assuming dynamic type as no data provided
  final String createdAt;
  final String updatedAt;
  final int version;

  RideHistoryData({
    required this.requirements,
    required this.id,
    required this.sourceCoordinates,
    required this.destinationCoordinates,
    required this.items,
    required this.moveType,
    required this.rideStatus,
    required this.passengerId,
    required this.traversedCoordinates,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory RideHistoryData.fromJson(Map<String, dynamic> json) =>
      RideHistoryData(
        requirements: Requirements.fromJson(json['requirements']),
        id: json['_id'],
        sourceCoordinates: Coordinates.fromJson(json['sourceCoordinates']),
        destinationCoordinates: List<Coordinates>.from(
            json['destinationCoordinates'].map((x) => Coordinates.fromJson(x))),
        items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
        moveType: json['moveType'],
        rideStatus: json['rideStatus'],
        passengerId: json['passengerId'],
        traversedCoordinates:
            List<dynamic>.from(json['traversedCoordinates'].map((x) => x)),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        version: json['__v'],
      );
}

class Requirements {
  final String selectedFloorStart;
  final String selectedFloorEnd;
  final bool requires2People;
  final int peopleTaggingAlong;
  final String specialRequirements;

  Requirements({
    required this.selectedFloorStart,
    required this.selectedFloorEnd,
    required this.requires2People,
    required this.peopleTaggingAlong,
    required this.specialRequirements,
  });

  factory Requirements.fromJson(Map<String, dynamic> json) => Requirements(
        selectedFloorStart: json['selectedFloorStart'],
        selectedFloorEnd: json['selectedFloorEnd'],
        requires2People: json['requires2People'],
        peopleTaggingAlong: json['peopleTaggingAlong'],
        specialRequirements: json['specialRequirements'],
      );
}

class Coordinates {
  final String lat;
  final String lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        lat: json['lat'],
        lng: json['lng'],
      );
}

class Item {
  final String name;
  final String qty;
  final String id;

  Item({required this.name, required this.qty, required this.id});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json['name'],
        qty: json['qty'],
        id: json['_id'],
      );
}
