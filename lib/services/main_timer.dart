import 'dart:async';
import 'package:easytech_electric_blue/services/bluetooth.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/messages.dart';
import 'package:easytech_electric_blue/widgets/dialogs/error_dialog.dart';

class MainTimer {
  static final MainTimer _singleton = MainTimer._internal();
  Timer? _timer;

  factory MainTimer() {
    return _singleton;
  }

  MainTimer._internal();

  void startTimer() {
    // SIMULAÇÂO
    // motor['rpm'][0] = 10.0;
    // motor['rpm'][1] = 10.0;
    // motor['rpm'][2] = 10.0;
    // motor['rpm'][21] = 10.0;
    // motor['rpm'][22] = 10.0;
    // motor['rpm'][23] = 6.0;
    // motor['rpm'][42] = 5.0;
    // motor['rpm'][43] = 10.0;
    // motor['rpm'][44] = 8.0;
    // for (var i = 0; i < seed['rate'].length; i++) {
    //   seed['rate'][i] = 0.0;
    // }
    // seed['rate'][0] = 5.0;
    // seed['rate'][4] = 5.0;

    // seed['rate'][12] = 2.0;
    // seed['rate'][16] = 2.0;

    // seed['rate'][24] = 8.0;
    // seed['rate'][28] = 8.0;

    // seed['rate'][19] = 10.0;
    // seed['rate'][20] = 8.0;
    // seed['rate'][21] = 7.9;
    // seed['rate'][22] = 7.8;
    // seed['rate'][23] = 7.7;

    // seed['rate'][28] = 7.2;
    // seed['rate'][29] = 7.1;
    // seed['rate'][30] = 7.0;
    // seed['rate'][31] = 6.9;
    // seed['rate'][32] = 6.8;
    // seed['rate'][33] = 6.7;
    // seed['rate'][34] = 6.6;
    // seed['rate'][35] = 6.5;

    // List<double> doubleList =
    //     (seed['rate'] as List<dynamic>).map((e) => e as double).toList();
    // seedManager.updateRate(doubleList);
    // // motor['rpm'][6] = 8.0;
    // // motor['rpm'][58] = 10.0;

    // motor['targetRPMBrachiaria'] = 10.0;
    // motorManager.updateRPM(
    //   motor['rpm'],
    //   motor['targetRPMBrachiaria'],
    //   motor['targetRPMFertilizer'],
    //   motor['targetRPMSeed'],
    // );
    // List<double> doubleList =
    //     (seed['rate'] as List<dynamic>).map((e) => e as double).toList();
    // seedManager.updateRate(doubleList);

// Um mapa para manter contagem de erros para cada motor
    Map<int, int> seedErrorCounts = {};
    Map<int, int> fertilizerErrorCounts = {};
    Map<int, int> brachiariaErrorCounts = {};

    // Listas para armazenar os motores com erro
    List<int> seedMotorsWithError = [];
    List<int> fertilizerMotorsWithError = [];
    List<int> brachiariaMotorsWithError = [];
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (!status['minimized']) {
          // Tocar som de "carência" após dois minutos
          if (mainTimer['lackCount'] == 120) {
            soundManager.playSound('lack');
            mainTimer['lackCount'] = 0;
          }

          // Envia mensagem de manutenção para o módulo Bluetooth
          if (mainTimer['manutenceCount'] == 3) {
            if (!sendWithQueue && connected) {
              if (sendManutenceMessage) {
                Messages().message["manutence"]!();
              }
            }
            checkConnection = false;
            sendManutenceMessage = true;

            // Verifica conexão com Bluetooth caso esteja desconectado
            if (!connected) {
              Bluetooth().connect();
            }
            bluetoothManager.changeConnectionState(connected);
            mainTimer['manutenceCount'] = 0;
          }

          // Verifica os alertas
          // if (false) {
          if (status['isPlanting'] && !machine['stoppedMotors'] && connected) {
            // Inicia o monitoramento das linhas após 2 segundos
            if (mainTimer['enableMonitoringCount'] == 2) {
              // Plantadeira devia estar plantando o motor parou, após 5 segundos dar pop-up erro
              status['showMonitoring'] = true;

              // Verificação para motores de semente
              if (acceptedDialog['seedError']) {
                for (var i = 0; i < machine['numberOfLines']; i++) {
                  if (seed['setMotors'][i] == 1) {
                    double percentageDifference = ((motor['rpm']
                                        [seed['addressedLayout'][i] - 1] -
                                    motor['targetRPMSeed'])
                                .abs() /
                            motor['targetRPMSeed']) *
                        100;

                    if (percentageDifference >= 10) {
                      seedErrorCounts[i] = (seedErrorCounts[i] ?? 0) + 1;

                      if (seedErrorCounts[i]! >= 10) {
                        if (!seedMotorsWithError.contains(i + 1)) {
                          seedMotorsWithError.add(i + 1);
                        }
                        seedErrorCounts[i] = 0; // Reset do contador
                      }
                    } else {
                      seedErrorCounts[i] = 0;
                    }
                  }
                }
              }

              // Verificação para motores de adubo
              if (acceptedDialog['fertilizerError']) {
                for (var i = 0; i < fertilizer['layout'].length; i++) {
                  if (fertilizer['setMotors'][i] == 1) {
                    double percentageDifference = ((motor['rpm']
                                        [fertilizer['addressedLayout'][i] - 1] -
                                    motor['targetRPMFertilizer'])
                                .abs() /
                            motor['targetRPMFertilizer']) *
                        100;

                    if (percentageDifference >= 10) {
                      fertilizerErrorCounts[i] =
                          (fertilizerErrorCounts[i] ?? 0) + 1;

                      if (fertilizerErrorCounts[i]! >= 10) {
                        fertilizerMotorsWithError.add(i + 1);
                        fertilizerErrorCounts[i] = 0; // Reset do contador
                      }
                    } else {
                      fertilizerErrorCounts[i] = 0;
                    }
                  }
                }
              }
              // Verificação para motores de brachiaria
              if (acceptedDialog['brachiariaError']) {
                for (var i = 0; i < brachiaria['layout'].length; i++) {
                  if (brachiaria['setMotors'][i] == 1) {
                    double percentageDifference = ((motor['rpm']
                                        [brachiaria['addressedLayout'][i] - 1] -
                                    motor['targetRPMBrachiaria'])
                                .abs() /
                            motor['targetRPMBrachiaria']) *
                        100;

                    if (percentageDifference >= 10) {
                      brachiariaErrorCounts[i] =
                          (brachiariaErrorCounts[i] ?? 0) + 1;

                      if (brachiariaErrorCounts[i]! >= 10) {
                        brachiariaMotorsWithError.add(i + 1);
                        brachiariaErrorCounts[i] = 0; // Reset do contador
                      }
                    } else {
                      brachiariaErrorCounts[i] = 0;
                    }
                  }
                }
              }

              if (seedMotorsWithError.isNotEmpty &&
                  acceptedDialog['seedError']) {
                errorDialog(1, seedMotorsWithError);
                seedMotorsWithError = [];
                seedErrorCounts = {};
              }
              if (fertilizerMotorsWithError.isNotEmpty &&
                  acceptedDialog['fertilizerError']) {
                errorDialog(2, fertilizerMotorsWithError);
                fertilizerMotorsWithError = [];
                fertilizerErrorCounts = {};
              }
              if (brachiariaMotorsWithError.isNotEmpty &&
                  acceptedDialog['brachiariaError']) {
                errorDialog(3, brachiariaMotorsWithError);
                brachiariaMotorsWithError = [];
                brachiariaErrorCounts = {};
              }

              //
            } else {
              mainTimer['enableMonitoringCount']++;
            }
            mainTimer['lackCount']++;
          } else {
            mainTimer['lackCount'] = 0;
            mainTimer['enableMonitoringCount'] = 0;
            mainTimer['brachiariaErrorCount'] = 0;
            status['showMonitoring'] = false;
          }
          // Incrementa contadores
          mainTimer['manutenceCount']++;
          // print("MAIN TIMER: $mainTimer $seedErrorCounts");
        }
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
