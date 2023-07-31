import 'package:flutter/material.dart';

import '../utilities/global.dart';

class NmeaModel {
  double latitude;
  double longitude;
  int qualitySignal;
  int numberOfSatellites;
  double satelliteSpeed;
  String dateAndTime;
  NmeaModel({
    required this.latitude,
    required this.longitude,
    required this.qualitySignal,
    required this.numberOfSatellites,
    required this.satelliteSpeed,
    required this.dateAndTime,
  });
}

class NmeaManager extends ChangeNotifier {
  final NmeaModel _state = NmeaModel(
    latitude: 0.0,
    longitude: 0.0,
    qualitySignal: 0,
    dateAndTime: '',
    numberOfSatellites: 0,
    satelliteSpeed: 0.0,
  );

  NmeaModel get state => _state;

  void updateNmea(double latitude, double longitude, int qualitySignal,
      int numberOfSatellites, double satelliteSpeed, String dateAndTime) {
    _state.latitude = latitude;
    _state.longitude = longitude;
    _state.qualitySignal = qualitySignal;
    _state.numberOfSatellites = numberOfSatellites;
    _state.satelliteSpeed = satelliteSpeed;
    _state.dateAndTime = dateAndTime;
    nmea['speed'] = satelliteSpeed;
    notifyListeners();
  }
}
