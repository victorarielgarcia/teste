import 'dart:async';
import 'dart:collection';
import 'package:easytech_electric_blue/services/speed.dart';
import 'package:easytech_electric_blue/services/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../utilities/nmea.dart';
import 'log_saver.dart';
import 'logger.dart';

// Bluetooth
bool connected = false;
bool connecting = false;

// Nmea
String tempLatitude = '';
String tempLongitude = '';
String dateAndTime = '';
int numberOfSatellites = 0;
int qualitySignal = 0;
double satelliteSpeed = 0;
double latitude = 0.0;
double longitude = 0.0;

Semaphore _sendSemaphore = Semaphore(1);

class Semaphore {
  int _permits;
  final Queue<Completer<void>> _queue = Queue<Completer<void>>();

  Semaphore(this._permits);

  Future<void> acquire() {
    if (_permits > 0) {
      _permits--;
      return Future.value();
    } else {
      final completer = Completer<void>();
      _queue.add(completer);
      return completer.future;
    }
  }

  void release() {
    if (_queue.isEmpty) {
      _permits++;
    } else {
      _queue.removeFirst().complete();
    }
  }
}

class Bluetooth {
  static final Bluetooth _singleton = Bluetooth._internal();

  factory Bluetooth() {
    return _singleton;
  }

  Bluetooth._internal();

  late StreamSubscription<ConnectionStateUpdate> connection;
  late StreamSubscription<DiscoveredDevice> scanStream;
  late QualifiedCharacteristic characteristic;

  Uuid serviceUUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
  Uuid characteristicUuIdRX =
      Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
  Uuid characteristicUuIdTX =
      Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

  final flutterReactiveBle = FlutterReactiveBle();

  List<String> connectedDevices = [];
  startScan() async {
    scanStream = flutterReactiveBle.scanForDevices(withServices: []).listen(
      (device) {
        if (!connecting) {
          if (device.name != "") {
            int index = devices
                .indexWhere((existingDevice) => existingDevice.id == device.id);
            if (index != -1) {
              devices[index] = device;
            } else {
              devices.add(device);
            }

            if (device.name == "EasyTech Electric" &&
                bluetoothLE['mainId'] == device.id &&
                !connected &&
                !connectedDevices.contains(device.id)) {
              connecting = true;
              connectedDevices.add(device.id.toString());
              characteristic = QualifiedCharacteristic(
                  serviceId: serviceUUID,
                  characteristicId: characteristicUuIdRX,
                  deviceId: device.id);
              connect(bluetoothLE['mainId']);
            }
          }
        }
      },
      onError: (error) {
        AppLogger.error("ERROR $error");
      },
    );
  }

  disconnect() {
    if (!connected && !connecting) {
      AppLogger.log(
          "Não está conectado ou está tentando realizar uma conexão no momento");
      return;
    }
    connection.cancel();
    connected = false;
  }

  _requestMTU() async {
    await flutterReactiveBle.requestMtu(
        deviceId: bluetoothLE['mainId'], mtu: 50);
  }

  void connect(String id) {
    try {
      connection = flutterReactiveBle
          .connectToDevice(
        id: id,
        servicesWithCharacteristicsToDiscover: {
          serviceUUID: [serviceUUID, characteristicUuIdRX]
        },
        connectionTimeout: const Duration(seconds: 2),
      )
          .listen((device) {
        switch (device.connectionState) {
          case DeviceConnectionState.connecting:
            {
              connecting = true;
              AppLogger.log("Connecting");
              break;
            }

          case DeviceConnectionState.connected:
            {
              connected = true;
              connecting = false;
              bluetoothManager.changeConnectionState(connected);
              AppLogger.log("Bluetooth Connected!");
              _requestMTU();
              _readData();
              break;
            }
          case DeviceConnectionState.disconnecting:
            {
              AppLogger.log("Disconnecting from $id");
              break;
            }
          case DeviceConnectionState.disconnected:
            {
              connected = false;
              connecting = false;
              bluetoothManager.changeConnectionState(connected);
              connectedDevices.remove(id);
              AppLogger.log("Disconnected from $id");
              break;
            }
        }
      }, onError: (Object error) {
        connected = false;
        connecting = false;
        bluetoothManager.changeConnectionState(connected);
        AppLogger.log("ERROR BLE CONNECTION $error");
      });
    } catch (e) {
      connected = false;
      connecting = false;
      bluetoothManager.changeConnectionState(connected);
      AppLogger.log("BLE CONNECTION $e");
    }
  }

  _readData() async {
    // Requisita o MTU para 40 bytes

    final characteristic = QualifiedCharacteristic(
        serviceId: serviceUUID,
        characteristicId: characteristicUuIdTX,
        deviceId: bluetoothLE['mainId']);
    // Leitura byte a byte
    startRead(flutterReactiveBle.subscribeToCharacteristic(characteristic));
  }

  send(int deviceId, int type, int messageId, Uint8List data, int cks) async {
    if (connected) {
      await _sendSemaphore.acquire();
      try {
        await Future.delayed(const Duration(milliseconds: 10));
        Uint8List header = Uint8List.fromList([35, deviceId, type, messageId]);
        Uint8List end = Uint8List.fromList([cks, 10]);
        Uint8List message = Uint8List.fromList(header + data + end);

        try {
          await flutterReactiveBle.writeCharacteristicWithoutResponse(
              QualifiedCharacteristic(
                  characteristicId: characteristicUuIdRX,
                  serviceId: serviceUUID,
                  deviceId: bluetoothLE['mainId']),
              value: message);
          if (type != 1) {
            sendManutenceMessage = false;
          }
        } catch (e) {
          AppLogger.error("SEND BLE: $e");
        }
      } finally {
        _sendSemaphore.release();
      }
    }
  }

  void currentScreen(BuildContext context, int screen) async {
    send(
        0,
        0,
        26,
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
          screen,
        ]),
        1);
  }

  Future<void> startRead(Stream<List<int>> stream) async {
    List<int> message = [];
    bool isStart = false;

    await for (final chunk in stream) {
      for (final byte in chunk) {
        if (byte == 35 && message.isEmpty) {
          isStart = true;
        }

        if (isStart) {
          message.add(byte);
          if (message.length == 40) {
            if (message.last == 10) {
              int messageId = message[3];
              AppLogger.log("ID: $messageId | $message");
              getData(messageId, message);
            } else {
              AppLogger.error("ERROR ON RECEIVE BYTE A BYTE: $message");
            }

            isStart = false;
            message.clear();
          }
        }
      }
    }
  }

  getData(int id, List<int> message) {
    // Mensagem da taxa de semente
    getSeedRate(id, message);
    // Mensagem leitura RPM
    getMotorsRPM(id, message);
    // Mensagem leitura RPM
    getModuleVersion(id, message);
    //Mensagem motores endereçados
    getAddressedMotors(id, message);
    //Busca a porcentagem de calibração
    getCalibrationPorcetage(id, message);
    // Mensagem velocidade e sensor de levante
    getAntennaSpeedAndLiftSensor(id, message);
    // Mensagem com informações NMEA
    getNmeaBluetooth(id, message);
    // Mensagem módulos endereçados
    getModuleAddresingStatus(id, message);
    // Mensagem pedindo configurações disponíveis
    getSettingsRequest(id, message);
    // Mensagem pedindo configurações disponíveis
    getAntennaAndLiftSensorModule(id, message);
  }

  void getSeedRate(int id, List<int> message) {
    try {
      int start = 4;
      int end;
      int offsetIndex;

      if (id == 3) {
        end = 38;
        offsetIndex = 0; // IDs 3 vão de 1 a 17
      } else if (id == 4) {
        end = 38;
        offsetIndex = 17; // IDs 4 vão de 18 a 34
      } else if (id == 5) {
        end = 38;
        offsetIndex = 34; // IDs 5 vão de 35 a 51
      } else if (id == 6) {
        end = 23;
        offsetIndex = 51; // IDs 6 vão de 52 a 70
      } else {
        return; // IDs não reconhecidos.
      }

      // Se for o primeiro update, inicializa seed['rate'] com zeros.
      if (seed['rate'].isEmpty) {
        seed['rate'] = List.filled(70, 0.0);
      }

      List<int> tempMessage = [];
      for (int i = start, j = 0; i < end; i++, j++) {
        tempMessage.add(message[i]);
        if (j == 1) {
          double rate = ((tempMessage[0] * 256) + tempMessage[1]) / 100;
          // Adicionando o valor calculado ao índice correto considerando o deslocamento.
          int index = offsetIndex + (i - start) ~/ 2;
          if (index >= 0 && index < seed['rate'].length) {
            seed['rate'][index] = rate;
          }
          tempMessage.clear();
          j = -1;
        }
      }
      seedManager.updateRate((seed['rate'] as List).cast<double>());
    } catch (e) {
      AppLogger.error("GET RATE ERROR: $e");
    }
  }

  getMotorsRPM(id, message) {
    try {
      if (id == 7) {
        //   AppLogger.error("RPM: ${motor['rpm']}");
        // if (motor['rpm'].isNotEmpty) motor['rpm'].clear();
        int j = 0;
        int k = 0;
        List<int> tempMessage = [];
        for (int i = 4; i < 38; i++) {
          tempMessage.add(message[i]);
          if (j == 1) {
            double rpm = ((tempMessage[0] * 256) + tempMessage[1]) / 81;
            motor['rpm'][k] = rpm;
            k++;
            tempMessage.clear();
            j = -1;
          }

          j++;
        }
      }

      if (id == 8) {
        int j = 0;
        int k = 17;
        List<int> tempMessage = [];
        for (int i = 4; i < 38; i++) {
          tempMessage.add(message[i]);
          if (j == 1) {
            double rpm = ((tempMessage[0] * 256) + tempMessage[1]) / 81;
            motor['rpm'][k] = rpm;
            tempMessage.clear();
            j = -1;
            k++;
          }
          j++;
        }
      }
      if (id == 9) {
        int j = 0;
        int k = 34;
        List<int> tempMessage = [];
        for (int i = 4; i < 38; i++) {
          tempMessage.add(message[i]);
          if (j == 1) {
            double rpm = ((tempMessage[0] * 256) + tempMessage[1]) / 81;
            motor['rpm'][k] = rpm;
            tempMessage.clear();
            j = -1;
            k++;
          }
          j++;
        }
      }
      if (id == 10) {
        int j = 0;
        int k = 51;
        List<int> tempMessage = [];
        for (int i = 4; i < 38; i++) {
          tempMessage.add(message[i]);
          if (j == 1) {
            double rpm = ((tempMessage[0] * 256) + tempMessage[1]) / 81;
            motor['rpm'][k] = rpm;
            tempMessage.clear();
            j = -1;
            k++;
          }
          j++;
        }
      }
      if (id == 11) {
        int j = 0;
        int k = 68;
        List<int> tempMessage = [];
        for (int i = 4; i < 38; i++) {
          tempMessage.add(message[i]);
          if (j == 1) {
            double rpm = ((tempMessage[0] * 256) + tempMessage[1]) / 81;
            motor['rpm'][k] = rpm;
            tempMessage.clear();
            j = -1;
            k++;
          }
          j++;
        }
      }

      //   AppLogger.error("MOTOR length: ${motor['rpm'].length}");
      if (id == 7 || id == 8 || id == 9 || id == 10 || id == 11) {
        double speed = Speed.getCurrentVelocity();

        if (machine['diskFilling']) {
          motor['targetRPMSeed'] = 10.0;
        } else {
          motor['targetRPMSeed'] =
              ((seed['desiredRate'] / seed['numberOfHoles']) *
                  (speed / 3.6) *
                  60);
        }

        motor['targetRPMFertilizer'] = (((fertilizer['desiredRate'] /
                        (10000 / machine['spacing']) /
                        fertilizer['constantWeight']) *
                    (speed / 3.6) *
                    60) *
                10) /
            fertilizer['gearRatio'];

        motor['targetRPMBrachiaria'] = (((brachiaria['desiredRate'] /
                        (10000 / machine['spacing']) /
                        brachiaria['constantWeight']) *
                    (speed / 3.6) *
                    60) *
                10) /
            brachiaria['gearRatio'];

        motorManager.updateRPM(
          motor['rpm'],
          motor['targetRPMBrachiaria'],
          motor['targetRPMFertilizer'],
          motor['targetRPMSeed'],
        );
        if (log['enabled']) {
          LogSaver.generateLog();
        }
      }
    } catch (e) {
      AppLogger.error("GET MOTORS RPM ERROR: $e");
    }
  }

  getModuleVersion(int id, List<int> message) {
    try {
      if (id == 12) {
        int a = 0;
        List<int> moduleVerion = [];
        for (int i = 0; i < module['layout'].length; i++) {
          moduleVerion.add(((message[4 + a] * 256 + message[5 + a])).toInt());
          a += 2;
        }
        moduleVersionManager.update(moduleVerion);
      }
    } catch (e) {
      AppLogger.error("GET MODULE VERSION ERROR: $e");
    }
  }

  getAddressedMotors(id, message) {
    try {
      if (id == 14) {
        List<int> motorsStatus = message.sublist(4, message.length - 2);
        int a = 1;
        int step = 0;
        for (int m in motorsStatus) {
          String bin = m.toRadixString(2).padLeft(8, '0');
          for (int i = 0; i < bin.length; i++) {
            if (step < 21 || step > 24) {
              int addressed = int.parse(bin[i]);
              if (addressed == 1) {
                if (brachiaria['addressedLayout'].indexOf(a) != -1) {
                  brachiaria['addressed']
                      [brachiaria['addressedLayout'].indexOf(a)] = 1;
                } else if (fertilizer['addressedLayout'].indexOf(a) != -1) {
                  fertilizer['addressed']
                      [fertilizer['addressedLayout'].indexOf(a)] = 1;
                } else if (seed['addressedLayout'].indexOf(a) != -1) {
                  seed['addressed'][seed['addressedLayout'].indexOf(a)] = 1;
                }
              } else {
                if (brachiaria['addressedLayout'].indexOf(a) != -1) {
                  brachiaria['addressed']
                      [brachiaria['addressedLayout'].indexOf(a)] = 0;
                } else if (fertilizer['addressedLayout'].indexOf(a) != -1) {
                  fertilizer['addressed']
                      [fertilizer['addressedLayout'].indexOf(a)] = 0;
                } else if (seed['addressedLayout'].indexOf(a) != -1) {
                  seed['addressed'][seed['addressedLayout'].indexOf(a)] = 0;
                }
              }
              a++;
            }
            step++;
            if (step == 24) {
              step = 0;
            }
          }
        }
        motorAddressingManager.update(brachiaria['addressed'],
            fertilizer['addressed'], seed['addressed']);
      }
    } catch (e) {
      AppLogger.error("GET ADDRESSED MOTORS ERROR: $e");
    }
  }

  getCalibrationPorcetage(id, message) {
    try {
      if (id == 15) {
        calibrationManager.update(message[4]);
      }
    } catch (e) {
      AppLogger.error("GET CALIBRATION PORCENTAGE ERROR: $e");
    }
  }

  getAntennaSpeedAndLiftSensor(id, message) {
    try {
      if (id == 16) {
        double speed = ((message[5] * 256 + message[6]) / 100).toDouble();
        antennaManager.updateSpeed(speed);
        if (!liftSensor['manualMachineLifted']) {
          if (message[4] == 1) {
            liftSensor['machineLifted'] = true;
          } else {
            liftSensor['machineLifted'] = false;
          }
          liftSensorManager.update(liftSensor['machineLifted']);
        }
      }
    } catch (e) {
      AppLogger.error("GET SVA AND LIFT SENSOR ERROR: $e");
    }
  }

  getNmeaBluetooth(int id, List<int> message) {
    try {
      if (velocity['options'] == 2) {
        // Mensagem GPS Nmea 1
        if (id == 20) {
          int c = 0;
          int i = 0;
          for (var msg in message) {
            String asciiMsg = String.fromCharCode(msg);
            // bool checker = false;
            if (asciiMsg == ',') {
              c++;
            }
            if (c == 0) {
              dateAndTime += asciiMsg;
            }
            if (c == 1 || c == 2) {
              tempLatitude += asciiMsg;
            }
            if ((c == 3 || c == 4) && i < 38) {
              tempLongitude += asciiMsg;
            }
            if (i == 38) {
              tempLatitude = tempLatitude.substring(1);
              tempLongitude = tempLongitude.substring(1);
            }

            i++;
          }
        }
        // Mensagem GPS Nmea 2
        if (id == 21) {
          int c = 0;
          int i = 0;
          String auxSatelites = '';
          String auxQualitySignal = '';
          for (var msg in message) {
            String asciiMsg = String.fromCharCode(msg);
            if (asciiMsg == ',') {
              c++;
            }
            if (i > 3 && c < 2) {
              tempLongitude += asciiMsg;
            }
            if (c == 2) {
              auxQualitySignal += asciiMsg;
            }
            if (c == 3) {
              auxSatelites += asciiMsg;
            }
            i++;
          }

          if (auxSatelites.isNotEmpty) {
            numberOfSatellites = int.parse(auxSatelites.substring(1));
          }
          if (auxQualitySignal.isNotEmpty) {
            qualitySignal = int.parse(auxQualitySignal.substring(1));
          }

          if (tempLatitude.length > 5 && tempLongitude.length > 5) {
            latitude = CoordinateConverter.dmsToDecimal(
              int.parse(tempLatitude.substring(0, 2)),
              double.parse(
                  tempLatitude.substring(2, tempLatitude.indexOf(','))),
              tempLatitude.substring(tempLatitude.length - 1),
            );

            longitude = CoordinateConverter.dmsToDecimal(
              int.parse(tempLongitude.substring(0, 3)),
              double.parse(
                  tempLongitude.substring(3, tempLongitude.indexOf(','))),
              tempLongitude.substring(tempLongitude.length - 1),
            );
            // points.add(JMPoint(latitude, longitude));
            //   AppLogger.error("DEBUG POINTS: ${points.length}");
            // if (points.length > 50) {
            //     AppLogger.error("DEBUG ENTROU CONDICAO");
            //   List<JMPolygon> polygons = MapPainting.createPolygons(points, 0.01);
            //     AppLogger.error("DEBUG POLIGONO: $polygons");
            // }
          }
        }
        // Mensagem GPS Nmea 2
        if (id == 22) {}

        // Mensagem GPS Nmea 3
        if (id == 23) {
          int c = 0;
          String auxSatelliteSpeed = '';
          for (var msg in message) {
            String asciiMsg = String.fromCharCode(msg);

            if (asciiMsg == ',') {
              c++;
            }
            if (c == 6) {
              auxSatelliteSpeed += asciiMsg;
            } else if (c == 7) {
              satelliteSpeed = double.parse(auxSatelliteSpeed.substring(1));
            }
          }
          tempLatitude = '';
          tempLongitude = '';
          dateAndTime = '';
          //   AppLogger.error(
          //     "LatLong: ($latitude , $longitude) | Nº Satelites: $numberOfSatellites | Qualidade Sinal: $qualitySignal | Velocidade: $satelliteSpeed");

          nmeaManager.updateNmea(latitude, longitude, qualitySignal,
              numberOfSatellites, satelliteSpeed, dateAndTime);
        }
      }
    } catch (e) {
      tempLatitude = '';
      tempLongitude = '';
      dateAndTime = '';
      // numberOfSatellites = 0;
      // qualitySignal = 0;
      // satelliteSpeed = 0;
      // latitude = 0.0;
      // longitude = 0.0;
      AppLogger.error("NMEA ERROR WITH MESSAGE: $message ERROR: $e ");
    }
  }

  getModuleAddresingStatus(id, message) {
    try {
      if (id == 40) {
        moduleAddressingManager.update(message[4], 1);
      }
      if (id == 41) {
        if (message[4] == 1) {
          moduleAddressingManager.update(1, 1);
        } else {
          moduleAddressingManager.update(1, 0);
        }
        if (message[5] == 1) {
          moduleAddressingManager.update(2, 1);
        } else {
          moduleAddressingManager.update(2, 0);
        }
        if (message[6] == 1) {
          moduleAddressingManager.update(3, 1);
        } else {
          moduleAddressingManager.update(3, 0);
        }
        if (message[7] == 1) {
          moduleAddressingManager.update(4, 1);
        } else {
          moduleAddressingManager.update(4, 0);
        }
        if (message[8] == 1) {
          moduleAddressingManager.update(5, 1);
        } else {
          moduleAddressingManager.update(5, 0);
        }
      }
    } catch (e) {
      AppLogger.error("GET MODULE ADDRESSING STATUS ERROR: $e");
    }
  }
}

getSettingsRequest(id, message) async {
  try {
    if (id == 46) {
      Messages().sendSettingsRequest();
      Messages().message["antennaAndLiftSensorModule"]!();
      settings['sendAntennaAndLiftSensorModule'] = true;
    }
  } catch (e) {
    AppLogger.error("GET SETTINGS REQUEST ERROR: $e");
  }
}

getAntennaAndLiftSensorModule(id, message) async {
  try {
    if (id == 44) {
      if (message[4] != 0 && message[5] != 0) {
        module['antenna'] = message[4];
        module['liftSensor'] = message[5];
        await StorageManager().save();
      }
    }
  } catch (e) {
    AppLogger.error("GET ANTENNA AND LIFT SENSOR MODULE REQUEST ERROR: $e");
  }
}
