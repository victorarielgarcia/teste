
import 'package:flutter/material.dart';

class MotorModel {
  List<double> rpm;
  double targetRPMBrachiaria;

  double targetRPMFertilizer;
  double targetRPMSeed;

  MotorModel({
    required this.rpm,
    required this.targetRPMBrachiaria,
    required this.targetRPMFertilizer,
    required this.targetRPMSeed,
  });
}

class MotorManager extends ChangeNotifier {
  // Timer? _errorTimer;

  // void _checkForError(String tipoMotor, double targetRPM) {
  //   if (targetRPM < 3 || targetRPM > 60) {
  //     // Cancela qualquer timer de erro anterior para evitar chamadas múltiplas
  //     _errorTimer?.cancel();

  //     // Inicia um novo timer
  //     _errorTimer = Timer(const Duration(seconds: 3), () {
  //       // Re-verifica a condição
  //       if (targetRPM < 3 || targetRPM > 60) {
  //         advancedDialog(); // Chame sua função de erro aqui
  //       }
  //     });
  //   } else {
  //     // Cancela o timer de erro, se houver algum, quando tudo está OK
  //     _errorTimer?.cancel();
  //   }
  // }

  final MotorModel _state = MotorModel(
    rpm: [
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
    targetRPMBrachiaria: 0.0,
    targetRPMFertilizer: 0.0,
    targetRPMSeed: 0.0,
  );

  MotorModel get state => _state;

  void updateRPM(
    List<double> rpm,
    double targetRPMBrachiaria,
    double targetRPMFertilizer,
    double targetRPMSeed,
  ) {
    _state.rpm = rpm;
    _state.targetRPMBrachiaria = targetRPMBrachiaria;
    _state.targetRPMFertilizer = targetRPMFertilizer;
    _state.targetRPMSeed = targetRPMSeed;
    // _checkForError('semente', targetRPMSeed);
    // _checkForError('adubo', targetRPMFertilizer);
    // _checkForError('braquiária', targetRPMBrachiaria);
    notifyListeners();
  }
}
