import 'dart:io';

import 'package:easytech_electric_blue/services/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import '../utilities/global.dart';
import 'logger.dart';

class LogSaver {
  static Future<String> get _localPath async {
    late Directory directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
      // directory = await getApplicationDocumentsDirectory();
    } catch (e) {
      AppLogger.error("LOG SAVER ERROR: $e");
    }

    return directory.path;
  }

  static Future<File> get _localFile async {
    // Buscar data do log
    DateTime dateNow = DateTime.now();
    // Gerar local que será salvo
    final path = await _localPath;
    return File('$path/log${dateNow.day}_${dateNow.month}_${dateNow.year}.txt');
  }

  static Future<File> writeLog(String log) async {
    final file = await _localFile;
    return file.writeAsString('$log\n', mode: FileMode.append);
  }

  static generateLog() async {
    DateTime dateNow = DateTime.now();
    Position position = await Geolocation.getLocation();
    writeLog(
        '$dateNow | Info Tablet - Speed: ${position.speed} - LatLong: ${position.latitude} , ${position.longitude} | ${motor.toString()} | ${velocity.toString()} | ${simulated.toString()} | ${antenna.toString()} | ${liftSensor.toString()}');
  }

  static Future<FileSystemEntity> clearLog(String log) async {
    final file = await _localFile;
    return file.delete();
  }

  static Future<String> readLog() async {
    try {
      final file = await _localFile;
      // Lê o arquivo
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // Se houver um erro ao ler o arquivo, retorne uma string vazia
      return '';
    }
  }
}
