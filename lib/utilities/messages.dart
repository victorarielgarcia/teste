import 'package:flutter/services.dart';

import '../models/lift_sensor_model.dart';
import '../services/bluetooth.dart';
import 'global.dart';

class Messages {
  void sendSettingsRequest() async {
    Messages().message["machine"]!();
    Messages().message["seed"]!();
    Messages().message["fertilizer"]!();
    Messages().message["brachiaria"]!();
    Messages().message["velocity"]!();
    Messages().message["setMotors"]!();
    Messages().message["sensor"]!(LiftSensor().getSelectableOption());
    Messages().message['requestSettings']!();
    Messages().message["advanced"]!();
  }

  Map<String, Function> message = {
    'manutence': () async {
      Bluetooth().send(
          0,
          0,
          99,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
          ]),
          1);
    },
    'machine': () async {
      Bluetooth().send(
          0,
          0,
          24,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            machine['numberOfLines'],
            machine['spacing'],
          ]),
          1);
    },
    'seed': () async {
      Bluetooth().send(
          0,
          0,
          25,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            (seed['desiredRate'] * 10) ~/ 256.toInt(),
            ((seed['desiredRate'] * 10) % 256).toInt(),
            seed['numberOfHoles'],
            (seed['gearRatio'] * 1000) ~/ 256.toInt(),
            ((seed['gearRatio'] * 1000) % 256).toInt(),
          ]),
          1);
    },
    'fertilizer': () async {
      Bluetooth().send(
          0,
          0,
          27,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            (fertilizer['desiredRate']) ~/ 256.toInt(),
            ((fertilizer['desiredRate']) % 256).toInt(),
            (fertilizer['constantWeight'] * 10) ~/ 256.toInt(),
            ((fertilizer['constantWeight'] * 10) % 256).toInt(),
            (fertilizer['gearRatio'] * 1000) ~/ 256.toInt(),
            ((fertilizer['gearRatio'] * 1000) % 256).toInt(),
          ]),
          1);
    },
    'brachiaria': () async {
      Bluetooth().send(
          0,
          0,
          28,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            ((brachiaria['desiredRate'] * 10)).toInt(),
            (brachiaria['constantWeight'] * 100) ~/ 256.toInt(),
            ((brachiaria['constantWeight'] * 100) % 256).toInt(),
            (brachiaria['gearRatio'] * 1000) ~/ 256.toInt(),
            ((brachiaria['gearRatio'] * 1000) % 256).toInt(),
          ]),
          1);
    },
    'velocity': () async {
      Bluetooth().send(
          0,
          0,
          29,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            velocity['options'] == 3
                ? (velocity['speed'] * 10) ~/ 256.toInt()
                : 0,
            velocity['options'] == 3
                ? ((velocity['speed'] * 10) % 256).toInt()
                : 0,
            velocity['options'] == 1 || velocity['options'] == 2
                ? (velocity['errorCompensation'] + 20).toInt()
                : 20,
            velocity['options']
          ]),
          1);
    },
    'sensor': (int option) async {
      Bluetooth().send(
          0,
          0,
          31,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            option,
          ]),
          1);
    },
    'advanced': () async {
      Bluetooth().send(
          0,
          0,
          32,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            binaryStringToInt(
                '00${advancedSettings['motor50RPMBrachiaria'] ? 1 : 0}${advancedSettings['motor50RPMFertilizer'] ? 1 : 0}${advancedSettings['motor50RPMSeed'] ? 1 : 0}${advancedSettings['anticlockwiseBrachiaria'] ? 1 : 0}${advancedSettings['anticlockwiseFertilizer'] ? 1 : 0}${advancedSettings['anticlockwiseSeed'] ? 1 : 0}'),
          ]),
          1);
    },
    'setMotors': () async {
      List<int> setMotorsMessage = List.filled(8 * 34, 0);

      for (var i = 0; i < brachiaria['layout'].length; i++) {
        int index = 0;

        brachiaria['addressedLayout'][i] > 30
            ? index = brachiaria['addressedLayout'][i] + 2
            : index = brachiaria['addressedLayout'][i];
        setMotorsMessage[index - 1] = brachiaria['setMotors'][i];
      }
      for (var i = 0; i < fertilizer['layout'].length; i++) {
        int index = 0;

        fertilizer['addressedLayout'][i] > 30
            ? index = fertilizer['addressedLayout'][i] + 2
            : index = fertilizer['addressedLayout'][i];

        setMotorsMessage[index - 1] = fertilizer['setMotors'][i];
      }
      for (var i = 0; i < machine['numberOfLines']; i++) {
        int index = 0;

        seed['addressedLayout'][i] > 30
            ? index = seed['addressedLayout'][i] + 2
            : index = seed['addressedLayout'][i];
        setMotorsMessage[index - 1] = seed['setMotors'][i];
      }

      List<int> setMotorsBinary = [];
      // Agrupa a cada 8 bits e converte para um número inteiro
      for (int i = 0; i < setMotorsMessage.length; i += 8) {
        if (i + 8 <= setMotorsMessage.length) {
          String binaryString = setMotorsMessage.sublist(i, i + 8).join();
          int converted = binaryStringToInt(binaryString);
          setMotorsBinary.add(converted);
        }
      }
      Bluetooth().send(0, 0, 0, Uint8List.fromList(setMotorsBinary), 1);
    },
    'stopMotors': () async {
      Bluetooth().send(
          0,
          0,
          1,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
          ]),
          1);
    },
    'startMotors': () async {
      Bluetooth().send(
          0,
          0,
          1,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
          ]),
          1);
    },
    'fillDisk': (int onOff) async {
      Bluetooth().send(
          0,
          0,
          2,
          Uint8List.fromList([
            onOff,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
          ]),
          1);
    },
    'moduleAddressing': (int module) async {
      Bluetooth().send(
          0,
          0,
          39,
          Uint8List.fromList([
            module,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
          ]),
          1);
    },
    'motorAddressing': (int motor) async {
      Bluetooth().send(
          0,
          0,
          42,
          Uint8List.fromList([
            motor,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
          ]),
          1);
    },
    'requestSettings': () async {
      Bluetooth().send(
          0,
          0,
          47,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
          ]),
          1);
    },
    'antennaAndLiftSensorModule': () async {
      Bluetooth().send(
          0,
          0,
          45,
          Uint8List.fromList([
            module['antenna'],
            module['liftSensor'],
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
          ]),
          1);
    },
    'calibration': (int fillRotor, int mode) async {
      Bluetooth().send(
          0,
          0,
          34,
          Uint8List.fromList([
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            calibration['RPMToCalibrate'].toInt(),
            calibration['numberOfLaps'].toInt(),
            fillRotor,
            mode == 1
                ? fertilizer['addressedLayout']
                    [calibration['motorNumber'].toInt() - 1]
                : brachiaria['addressedLayout']
                    [calibration['motorNumber'].toInt() - 1],
          ]),
          1);
    },
  };
}
