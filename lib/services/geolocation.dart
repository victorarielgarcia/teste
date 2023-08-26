import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

late LocationSettings locationSettings;

class Geolocation {
  static init() async {
    await Permission.location.request().isGranted;

    
    if (!await Geolocator.isLocationServiceEnabled()) {
      await requestPermission();
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  static getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
        
    // print(position);
    // print(position.speed.toStringAsFixed(2));
    return position;
  }

  static requestPermission() async {
    await Geolocator.requestPermission();
  }
}
