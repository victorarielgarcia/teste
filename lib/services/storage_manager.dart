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
    await storeData('simulated', simulated);
    await storeData('antenna', antenna);
    await storeData('nmea', nmea);
    await storeData('liftSensor', liftSensor);
    await storeData('advancedSettings', advancedSettings);
    await storeData('module', module);
    await storeData('section', section);
    await storeData('bluetooth', bluetooth);
  }

  load() async {
    machine = (await retrieveData('machine'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
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
    simulated = (await retrieveData('simulated'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    antenna = (await retrieveData('antenna'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    nmea = (await retrieveData('nmea'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    liftSensor = (await retrieveData('liftSensor'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    advancedSettings = (await retrieveData('advancedSettings'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    module = (await retrieveData('module'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};
    section = (await retrieveData('section'))
            ?.map((key, value) => MapEntry(key.toString(), value)) ??
        {};

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

// TENTATIVA 1

  // Future<Map<String, dynamic>?> retrieveData(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString(key); // Retrieve JSON string.

  //   if (jsonString != null) {
  //     Map<String, dynamic> value =
  //         json.decode(jsonString); // Convert JSON string back to Map.

  //     // Iterate over each key-value pair in the map.
  //     for (var key in value.keys) {
  //       // Check if the value is a map.
  //       if (value[key] is Map) {
  //         // Convert keys of the map back to int.
  //         value[key] = (value[key] as Map)
  //             .map((key, value) => MapEntry(int.tryParse(key) ?? key, value));
  //       }
  //     }

  //     return value;
  //   } else {
  //     return null;
  //   }
  // }

  //  ANTIGO
  // Future<Map<String, dynamic>?> retrieveData(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString(key); // Retrieve JSON string.

  //   if (jsonString != null) {
  //     Map<String, dynamic> value =
  //         json.decode(jsonString); // Convert JSON string back to Map.

  //     // Convert keys of 'addressedLayout' map back to int.
  //     if (value['addressedLayout'] is Map) {
  //       value['addressedLayout'] = (value['addressedLayout'] as Map)
  //           .map((key, value) => MapEntry(int.parse(key), value));
  //     }

  //     return value;
  //   } else {
  //     return null;
  //   }
  // }
}
