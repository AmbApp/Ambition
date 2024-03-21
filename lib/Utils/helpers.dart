import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'constants.dart';

class GlobalVariable {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

getSharedPrefs(String key) async {
  final value = sharedPreferences.getInt(key) ?? '';
  return value;
}

void setSharedPrefs(String key, String value) async {
  await sharedPreferences.setString(key, value);
}

LatLng getLatLngFromSharedPrefs() {
  // return const LatLng(33.6844, 73.0479);

  // TO DO: REPLACE WHEN TESTING ON REAL DEVICE
  return LatLng(
      double.parse(sharedPreferences.getString('latitude') ?? '33.6844'),
      double.parse(sharedPreferences.getString('longitude') ?? '73.0479'));
}

num getDistanceFromSharedPrefs(int index) {
  num distance = 2000; //getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = 100; //getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                )),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}

bool isCoordinateInIslamabad(String coordinate) {
  double latitude, longitude;

  // Split the coordinate string into latitude and longitude
  List<String> parts = coordinate.split(',');

  if (parts.length != 2) {
    throw const FormatException(
        'Invalid coordinate format. Expected "latitude,longitude".');
  }

  // Parse latitude and longitude values
  try {
    latitude = double.parse(parts[0]);
    longitude = double.parse(parts[1]);
  } catch (e) {
    throw const FormatException(
        'Invalid coordinate values. Latitude and longitude must be numeric.');
  }

  // Define the boundary coordinates for Islamabad
  double islamabadMinLatitude = 33.5;
  double islamabadMaxLatitude = 34.1;
  double islamabadMinLongitude = 72.6;
  double islamabadMaxLongitude = 73.4;

  // Check if the coordinate is within Islamabad
  if (latitude >= islamabadMinLatitude &&
      latitude <= islamabadMaxLatitude &&
      longitude >= islamabadMinLongitude &&
      longitude <= islamabadMaxLongitude) {
    return true;
  }

  return false;
}

Future<String> getCurrentLocation() async {
  var location = loc.Location();
  var locationService = await location.getLocation();

  String currentLocationFromMob =
      "${locationService.latitude},${locationService.longitude}";

  return currentLocationFromMob;
}

void logger(String? message) {
  // ignore: avoid_print
  kDebugMode ? log(('$message')) : debugPrint('$message');
}

Future<String?> autoCompleteSearch(String value) async {
  if (value != '') {
    try {
      List<Location> locations = await locationFromAddress(value);

      return '${locations[0].latitude.toString()},${locations[0].longitude.toString()}';
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  return null;
}

LatLng? convertStringToLatLng(String? latLngString) {
  if (latLngString == null) {
    return null;
  }
  List<String> latLngList = latLngString.split(',');
  if (latLngList.length != 2) {
    return null;
  }
  double? latitude = double.tryParse(latLngList[0].trim());
  double? longitude = double.tryParse(latLngList[1].trim());
  if (latitude == null || longitude == null) {
    return null;
  }
  return LatLng(latitude, longitude);
}

String formatDate(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
}

String _twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}

String mapServiceType(Move_Type type) {
  switch (type) {
    case Move_Type.Events_Transportation:
      return "Events";
    case Move_Type.House_Move:
      return "House Move";
    case Move_Type.Waste_Disposal:
      return "Waste Disposal";
    case Move_Type.Shopping_Transportation:
      return "Transport Items";
    case Move_Type.Storage_Move:
      return "Storage Move";
    case Move_Type.Items_Transportation:
      return "Transport Items";
    case Move_Type.Other_Service:
      return "Other Service";
    case Move_Type.Office_Relocation:
      return "Office Relocation";
    default:
      return "Unknown Service Type";
  }
}
