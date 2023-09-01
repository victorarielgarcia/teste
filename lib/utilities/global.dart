import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/antenna_model.dart';
import '../models/bluetooth_model.dart';
import '../models/calibration_model.dart';
import '../models/lift_sensor_model.dart';
import '../models/module_addressing_model.dart';
import '../models/module_version_model.dart';
import '../models/motor_adressing_model.dart';
import '../models/motor_model.dart';
import '../models/nmea_model.dart';
import '../models/seed_drop_model.dart';
import '../models/seed_model.dart';
import '../services/sound_manager.dart';

String softwareVersion = '1.0.0 (Software SE Terra T320 15l)';

final navigatorKey = GlobalKey<NavigatorState>();

final _pattern = RegExp(r'(?:0x)?(\d+)');
int binaryStringToInt(String binaryString) =>
    int.parse(_pattern.firstMatch(binaryString)!.group(1)!, radix: 2);

SoundManager soundManager = SoundManager();

BluetoothDevice device = const BluetoothDevice(address: '00:00:00:00:00:00');
List<BluetoothDevice> devices = [];

BluetoothManager bluetoothManager = BluetoothManager();
MotorAddressingManager motorAddressingManager = MotorAddressingManager();

bool sendManutenceMessage = false;
bool sendWithQueue = false;
bool checkConnection = false;

Map<String, dynamic> bluetooth = {
  'address': '00:00:00:00:00:00',
};

Map<String, dynamic> machine = {
  'numberOfLines': 36,
  'spacing': 45,
  'fertilizer': false,
  'brachiaria': false,
  'stoppedMotors': false,
  'diskFilling': false,
  'sectionsLayout': <int>[],
  'sectionIndex': 0,
};

MotorManager motorManager = MotorManager();
Map<String, dynamic> motor = {
  'rpm': <double>[
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ],
  'targetRPMBrachiaria': 0.0,
  'targetRPMFertilizer': 0.0,
  'targetRPMSeed': 0.0,
};

SeedManager seedManager = SeedManager();
Map<String, dynamic> seed = {
  'desiredRate': 5,
  'numberOfHoles': 45,
  'gearRatio': 1,
  'firstErrorLimit': 5,
  'secondErrorLimit': 10,
  'errorCompensation': 0,
  'rate': <double>[
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ],
  'setMotors': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'setSensors': <int>[
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
  ],
  'addressed': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'addressedLayout': [
    10,
    11,
    12,
    13,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    52,
    53,
    54,
    55,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    38,
    39,
    40,
    41,
    42,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    94,
    95,
    96,
    97,
    98,
    99,
    100,
    101,
    102,
    103,
    104,
    105
  ]
};

CalibrationManager calibrationManager = CalibrationManager();
Map<String, dynamic> calibration = {
  'motorNumber': 1,
  'RPMToCalibrate': 20,
  'numberOfLaps': 20,
  'calibrationResult': 0.0,
  'collectedWeight': 0,
  'numberOfLinesCollected': 1,
};

Map<String, dynamic> fertilizer = {
  'desiredRate': 200,
  'constantWeight': 48,
  'gearRatio': 1,
  'firstErrorLimit': 5,
  'secondErrorLimit': 10,
  'errorCompensation': 0,
  'layout': <int>[],
  'setMotors': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'addressed': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'addressedLayout': <int>[
    4,
    5,
    25,
    26,
    27,
    46,
    47,
    6,
    7,
    8,
    9,
    28,
    29,
    30,
    48,
    49,
    50,
    51,
    67,
    68,
    69,
    70,
    71,
    72,
    88,
    89,
    90,
    91,
    92,
    93
  ]
};

Map<String, dynamic> brachiaria = {
  'desiredRate': 3,
  'constantWeight': 5,
  'gearRatio': 0.2,
  'firstErrorLimit': 0,
  'secondErrorLimit': 0,
  'errorCompensation': 0,
  'layout': <int>[],
  'setMotors': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'addressed': <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ],
  'addressedLayout': <int>[
    1,
    22,
    43,
    2,
    3,
    23,
    24,
    44,
    45,
    64,
    65,
    66,
    85,
    86,
    87
  ]
};

Map<String, dynamic> velocity = {
  'options': 3,
  'speed': 0.0,
  'errorCompensation': 0,
};

Map<String, dynamic> simulated = {
  'simulated': 0,
};

AntennaManager antennaManager = AntennaManager();
Map<String, dynamic> antenna = {
  'speed': 0.0,
  'errorCompensation': 0,
};

NmeaManager nmeaManager = NmeaManager();
Map<String, dynamic> nmea = {
  'speed': 0.0,
  'errorCompensation': 0,
};

LiftSensorManager liftSensorManager = LiftSensorManager();
Map<String, dynamic> liftSensor = {
  'options': 1,
  'normallyOpen': false,
  'manualMachineLifted': false,
  'machineLifted': false,
};

Map<String, dynamic> advancedSettings = {
  'motor50RPMSeed': false,
  'anticlockwiseSeed': false,
  'motor50RPMFertilizer': false,
  'anticlockwiseFertilizer': false,
  'motor50RPMBrachiaria': false,
  'anticlockwiseBrachiaria': false,
};

ModuleAddresingManager moduleAddressingManager = ModuleAddresingManager();
ModuleVersionManager moduleVersionManager = ModuleVersionManager();
Map<String, dynamic> module = {
  'layout': <int>[12, 12],
  'addressed': <int>[0, 0, 0],
  'antenna': 1,
  'liftSensor': 1,
};

Map<String, dynamic> section = {
  'cutted': [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ],
};

SeedDropManager seedDropManager = SeedDropManager();
Map<String, dynamic> seedDropControl = {
  'enabled': false,
  'calibration': 0.0,
  'isControlling': false,
  // NEW TEST
  'lastValue': 0.0,
};

Map<String, dynamic> settings = {
  'sendAntennaAndLiftSensorModule': false,
};

Map<String, dynamic> battery = {
  'level': 0,
  'state': BatteryState.unknown,
};

Map<String, dynamic> status = {
  'isPlanting': false,
  'showMonitoring': false,
  'minimized': false,
};

Map<String, dynamic> log = {
  'enabled': false,
};

Map<String, dynamic> mainTimer = {
  'lackCount': 0,
  'manutenceCount': 0,
  'enableMonitoringCount': 0,
  'seedErrorCount': 0,
};

Map<String, dynamic> acceptedDialog = {
  'seedError': true,
  'fertilizerError': true,
  'brachiariaError': true,
  'bluetoothError': true,
};
