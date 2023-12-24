import 'dart:io';
import 'package:easytech_electric_blue/services/geolocation.dart';
import 'package:easytech_electric_blue/services/logger.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Cloud {
  static send() async {
    if (await checkInternetConnection()) {
      updateMachinePosition();
    } else {
      AppLogger.log("No internet connection");
    }
  }

  static updateMachinePosition() async {
    try {
      Position position = await Geolocation.getLocation();
      var response = await http.post(
        Uri.https(url, 'api/machine/update/location'),
        body: ({
          'id': 1.toString(),
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        }),
      );
      AppLogger.log("RESPONSE ${response.body}");
    } catch (e) {
      AppLogger.error("UPDATE MACHINE POSITION ERROR: $e");
    }
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('google.com');
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
