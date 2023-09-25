import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/global.dart';

class StorageManager {
  save() async {
    await storeData('machine', machine);
    await storeData('seed', seed);
    await storeData('fertilizer', fertilizer);
    await storeData('brachiaria', brachiaria);
    await storeData('velocity', velocity);
    // await storeData('simulated', simulated);
    // await storeData('antenna', antenna);
    await storeData('nmea', nmea);
    await storeData('liftSensor', liftSensor);
    await storeData('advancedSettings', advancedSettings);
    await storeData('module', module);
    // await storeData('section', section);
    await storeData('bluetooth', bluetooth);
  }

  load() async {
    machine = (await retrieveData('machine'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    machine['stoppedMotors'] = false;
    machine['diskFilling'] = false;

    seed = (await retrieveData('seed'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    fertilizer = (await retrieveData('fertilizer'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    brachiaria = (await retrieveData('brachiaria'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    velocity = (await retrieveData('velocity'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    velocity['speed'] = 0;

    // simulated = (await retrieveData('simulated'))
    //         ?.map((key, value) => MapEntry(key.toString(), value)) ??
    //     {};

    // antenna = (await retrieveData('antenna'))
    //         ?.map((key, value) => MapEntry(key.toString(), value)) ??
    //     {};

    nmea = (await retrieveData('nmea'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    liftSensor = (await retrieveData('liftSensor'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    // liftSensorManager.update(!liftSensor['machineLifted']);

    advancedSettings = (await retrieveData('advancedSettings'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    module = (await retrieveData('module'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

    for (int i = 0; i < module["addressed"].length; i++) {
      module["addressed"][i] = 0;
    }

    // section = (await retrieveData('section'))
    //         ?.map((key, value) => MapEntry(key.toString(), value)) ??
    //     {};

    bluetooth = (await retrieveData('bluetooth'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
  }

  Future<void> storeData(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert keys of 'addressedLayout' map to String.
    if (value['addressedLayout'] is Map) {
      value['addressedLayout'] = (value['addressedLayout'] as Map)
          .map((key, value) => MapEntry(key.toString(), value));
    }

    String jsonString = json.encode(value); // Convert Map to JSON string.
    prefs.setString(key, jsonString); // Store JSON string.
  }

  Map<dynamic, dynamic> convertKeysToInt(Map<dynamic, dynamic> map) {
    final newMap = <dynamic, dynamic>{};
    for (final key in map.keys) {
      final value = map[key];
      if (value is Map) {
        newMap[int.tryParse(key) ?? key] = convertKeysToInt(value);
      } else {
        newMap[int.tryParse(key) ?? key] = value;
      }
    }
    return newMap;
  }

  Future<Map<dynamic, dynamic>?> retrieveData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      Map<dynamic, dynamic> value = jsonDecode(jsonString);
      value = convertKeysToInt(value);
      return value;
    } else {
      return null;
    }
  }
}
