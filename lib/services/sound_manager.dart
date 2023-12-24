import 'dart:io';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'logger.dart';

class SoundManager {
  late Soundpool soundPool;
  Map<String, int> soundIds = {};

  // Este método inicializa o Soundpool e carrega todos os sons necessários
  Future<void> init() async {
    soundPool = Soundpool.fromOptions();

    // Carregar todos os sons aqui
    soundIds['click'] = await _loadSound('assets/sounds/click.wav');
    soundIds['cut'] = await _loadSound('assets/sounds/cut.mp3');
    soundIds['error'] = await _loadSound('assets/sounds/error.mp3');
    soundIds['lack'] = await _loadSound('assets/sounds/lack.mp3');
    soundIds['beep'] = await _loadSound('assets/sounds/beep.mp3');
  }

  // Este método carrega um som e retorna seu ID
  Future<int> _loadSound(String assetPath) async {
    ByteData soundData = await rootBundle.load(assetPath);
    return await soundPool.load(soundData);
  }

  // Este método toca um som
  Future<void> playSound(String soundName) async {
    if (!Platform.isWindows) {
      if (soundIds.containsKey(soundName)) {
        soundPool.play(soundIds[soundName]!);
      } else {
        AppLogger.log('Sound not found: $soundName');
      }
    }
  }
}
