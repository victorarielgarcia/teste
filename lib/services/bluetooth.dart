import 'dart:async';
import 'dart:collection';
import 'package:easytech_electric_blue/services/speed.dart';
import 'package:easytech_electric_blue/services/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../utilities/nmea.dart';
import 'log_saver.dart';
import 'logger.dart';

// Bluetooth
bool connected = false;
bool verify = false;
int count = 0;
late Uint8List message;

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
  static BluetoothConnection? connection;

  List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    try {
      if (devices.isEmpty) {
        items.add(const DropdownMenuItem(
          child: Text('Nenhum dispositivo'),
        ));
      } else {
        for (var device in devices) {
          items.add(DropdownMenuItem(
            value: device,
            child: Text(device.name ?? ''),
          ));
        }
      }
    } catch (e) {
      AppLogger.error("ERROR GetDeviceItems: $e");
    }

    return items;
  }

  Future<void> getPairedDevices() async {
    try {
      FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
      devices = await bluetooth.getBondedDevices();
      for (var element in devices) {
        AppLogger.error(element.address);
      }
      device = devices.first;
    } catch (e) {
      device = const BluetoothDevice(address: '', name: 'Nenhum dispositivo');
      devices.add(device);
      AppLogger.error("Error getPairedDevices $e");
    }
  }

  Future connect() async {
    // try {
    //   await FlutterBluetoothSerial.instance.requestEnable();

    //   await connection?.finish();
    //   await connection?.close();
    //   sendWithQueue = true;
    //   //  connection = await BluetoothConnection.toAddress('A8:42:E3:89:9F:62');
    //   connection = await BluetoothConnection.toAddress(bluetooth['address']);
    //   AppLogger.log("Bluetooth Connected!");
    //   connected = true;
    //   bluetoothManager.changeConnectionState(connected);

    //   // Messages().sendSettingsRequest();
    //   sendWithQueue = false;
    //   startRead(connection!.input!.cast<List<int>>());
    // } catch (e) {
    //   AppLogger.error("ERROR CONNECTION BLUETOOTH: $e");
    //   // Timer(const Duration(seconds: 8), () {
    //   //   connect();
    //   // });
    //   connected = false;
    //   bluetoothManager.changeConnectionState(connected);
    // }
  }

  send(int deviceId, int type, int messageId, Uint8List data, int cks) async {
    await _sendSemaphore.acquire();
    try {
      await Future.delayed(const Duration(milliseconds: 10));
      Uint8List header = Uint8List.fromList([35, deviceId, type, messageId]);
      Uint8List end = Uint8List.fromList([cks, 10]);
      Uint8List message = Uint8List.fromList(header + data + end);
      // AppLogger.log('MESSAGE SEND: $message');
      if (connection != null) {
        try {
          connection?.output.add(message);
          await connection?.output.allSent;
          if (type != 1) {
            sendManutenceMessage = false;
          }
        } catch (e) {
          bluetoothManager.changeConnectionState(connected);
          connected = false;
          // connect();
        }
      } else {
        bluetoothManager.changeConnectionState(connected);
        connected = false;
        // connect();
      }
    } finally {
      _sendSemaphore.release();
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
    final byteData = ByteData(1);
    List<int> message = [];
    await for (final chunk in stream) {
      for (final byte in chunk) {
        byteData.setUint8(0, byte);

        if (byte == 35) {
          verify = true;
        }
        if (verify) {
          if (message.length < 40) {
            message.add(byte);
            count++;
          } else {
            message.clear();
            count = 0;
            verify = false;
          }
        }
        if (count == 40) {
          if (byte == 10) {
            // MENSAGEM DEPURAÇÃO
            int id = message[3];
            AppLogger.log("ID: $id | $message");
            // int type = message[2];
            getData(id, message);
            checkConnection = true;
            count = 0;
            verify = false;
            message.clear();
          } else {
            AppLogger.error("ERROR ON RECEIVE BYTE A BYTE: $message");
            count = 0;
            verify = false;
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

  getSeedRate(int id, List<int> message) {
    try {
      if (status['showMonitoring ']) {
        if (id == 3) {
          // ERROR UPDATE SCREEN
          if (seed['rate'].isNotEmpty) seed['rate'].clear();
          int j = 0;
          List<int> tempMessage = [];
          for (int i = 4; i < 38; i++) {
            tempMessage.add(message[i]);
            if (j == 1) {
              double rate = ((tempMessage[0] * 256) + tempMessage[1]) / 100;
              seed['rate'].add(rate);
              tempMessage.clear();
              j = -1;
            }
            j++;
          }
        }
        if (id == 4) {
          int j = 0;
          List<int> tempMessage = [];
          for (int i = 4; i < 38; i++) {
            tempMessage.add(message[i]);
            if (j == 1) {
              double rate = ((tempMessage[0] * 256) + tempMessage[1]) / 100;
              seed['rate'].add(rate);
              tempMessage.clear();
              j = -1;
            }
            j++;
          }
        }
        if (id == 5) {
          int j = 0;
          List<int> tempMessage = [];
          for (int i = 4; i < 38; i++) {
            tempMessage.add(message[i]);
            if (j == 1) {
              double rate = ((tempMessage[0] * 256) + tempMessage[1]) / 100;
              seed['rate'].add(rate);
              tempMessage.clear();
              j = -1;
            }
            j++;
          }
        }
        if (id == 6) {
          int j = 0;
          List<int> tempMessage = [];
          for (int i = 4; i < 23; i++) {
            tempMessage.add(message[i]);
            if (j == 1) {
              double rate = ((tempMessage[0] * 256) + tempMessage[1]) / 100;
              seed['rate'].add(rate);
              tempMessage.clear();
              j = -1;
            }
            j++;
          }
        }
        if (id == 3 || id == 4 || id == 5 || id == 6) {
          seedManager.updateRate((seed['rate'] as List).cast<double>());
        }
      }
    } catch (e) {
      AppLogger.error("GET RATE ERROR: $e");
    }
  }

  getMotorsRPM(id, message) {
    try {
      if (status['showMonitoring ']) {
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
      // if (!sendWithQueue) {
      Messages().sendSettingsRequest();
      // if (settings['sendAntennaAndLiftSensorModule']) {
      Messages().message["antennaAndLiftSensorModule"]!();
      // }
      settings['sendAntennaAndLiftSensorModule'] = true;
      // }
    }
  } catch (e) {
    sendWithQueue = false;
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
