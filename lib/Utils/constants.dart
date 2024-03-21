enum CurrentModeEnum { driver, passenger }

enum MapMode { driver, passenger }

enum PaymentOptionType {
  stripe,
  googlePay,
  creditCard,
  payShare,
}

enum Ride_Type {
  MOVE,
  SCHEDULED_MOVE,
  REFRIGERATION,
}

enum Move_Type {
  Events_Transportation,
  House_Move,
  Waste_Disposal,
  Shopping_Transportation,
  Storage_Move,
  Items_Transportation,
  Other_Service,
  Office_Relocation,
}

final localStorageKeys = {
  'userID': 'userID',
  'driverID': 'driverID',
  'passengerID': 'passengerID',
};

String googleMapApiToken = 'AIzaSyA8_QKTi32aERXeWOyOguUIwaWsVY-2KXE';
    //'AIzaSyBjvLABfS6xq4oLGjDipVIs17Hcwf2XyJU'; // TO DO: remove and move to .env
  // = const [
  //   LatLng(33.684714, 73.048045),
  //   LatLng(33.673281, 73.026413),
  //   LatLng(33.663012, 73.006765),
  //   LatLng(33.652757, 72.987332),
  //   LatLng(33.648144, 72.978459),
  //   LatLng(33.647678, 72.978431),
  //   LatLng(33.645952, 72.979731),
  //   LatLng(33.64621, 72.981138),
  //   LatLng(33.645655, 72.985249),
  //   LatLng(33.64582, 72.985731),
  //   LatLng(33.645435, 72.985988),
  //   LatLng(33.645182, 72.985556),
  //   LatLng(33.645509, 72.985208)
  // ];
