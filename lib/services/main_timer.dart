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
    motor['rpm'][0] = 10.0;
    motor['rpm'][1] = 10.0;
    motor['rpm'][2] = 10.0;
    motor['rpm'][21] = 10.0;
    motor['rpm'][22] = 10.0;
    motor['rpm'][23] = 6.0;
    motor['rpm'][42] = 5.0;
    motor['rpm'][43] = 10.0;
    motor['rpm'][44] = 8.0;

    motor['rpm'][6] = 8.0;
    motor['rpm'][58] = 10.0;

    motor['targetRPMBrachiaria'] = 10.0;
    motorManager.updateRPM(
      motor['rpm'],
      motor['targetRPMBrachiaria'],
      motor['targetRPMFertilizer'],
      motor['targetRPMSeed'],
    );
    // List<double> doubleList =
    //     (seed['rate'] as List<dynamic>).map((e) => e as double).toList();
    // seedManager.updateRate(doubleList);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
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
        if (status['isPlanting']) {
          // Inicia o monitoramento das linhas após 3 segundos
          if (mainTimer['enableMonitoringCount'] == 3) {
            // Plantadeira devia estar plantando o motor parou, após 5 segundos dar pop-up erro
            status['showMonitoring'] = true;
            // Verifica se os motores de adubo estão atingindo o RPM alvo,
            // se estiver 10% a mais ou a menos ele é considerando um motor com erro
            Set seedMotorsWithError = {};
            Set seedMotorsCheckError = {};
            for (var i = 0; i < machine['numberOfLines']; i++) {
              double percentageDifference = ((motor['rpm']
                                  [seed['addressedLayout'][i] - 1] -
                              motor['targetRPMSeed'])
                          .abs() /
                      motor['targetRPMSeed']) *
                  100;
              if (percentageDifference >= 10 && acceptedDialog['error']) {
                seedMotorsCheckError.add(i);
              }
            }
            if (seedMotorsCheckError.isNotEmpty) {
              if (mainTimer['seedErrorCount'] == 5) {
                for (int motorIndex in seedMotorsCheckError) {
                  double percentageDifference =
                      ((motor['rpm'][seed['addressedLayout'][motorIndex] - 1] -
                                      motor['targetRPMSeed'])
                                  .abs() /
                              motor['targetRPMSeed']) *
                          100;
                  if (percentageDifference >= 10) {
                    seedMotorsWithError.add(motorIndex + 1);
                  }
                }
                if (acceptedDialog['error'] &&
                    status['isPlanting'] &&
                    seedMotorsWithError.isNotEmpty) {
                  errorDialog('semente', seedMotorsWithError.toList());
                  seedMotorsWithError.clear();
                  seedMotorsCheckError.clear();
                }
              } else {
                mainTimer['seedErrorCount']++;
              }
            } else {
              mainTimer['seedErrorCount'] = 0;
            }

            // Verifica se os motores de adubo estão atingindo o RPM alvo,
            // se estiver 10% a mais ou a menos ele é considerando um motor com erro
            Set fertilizerMotorsWithError = {};
            Set fertilizerMotorsCheckError = {};
            for (var i = 0; i < fertilizer['layout'].length; i++) {
              double percentageDifference = ((motor['rpm']
                                  [fertilizer['addressedLayout'][i] - 1] -
                              motor['targetRPMFertilizer'])
                          .abs() /
                      motor['targetRPMFertilizer']) *
                  100;
              if (percentageDifference >= 10 && acceptedDialog['error']) {
                fertilizerMotorsCheckError.add(i);
              }
            }
            if (fertilizerMotorsCheckError.isNotEmpty) {
              if (mainTimer['fertilizerErrorCount'] == 5) {
                for (int motorIndex in fertilizerMotorsCheckError) {
                  double percentageDifference =
                      ((motor['rpm'][fertilizer['addressedLayout'][motorIndex] -
                                          1] -
                                      motor['targetRPMFertilizer'])
                                  .abs() /
                              motor['targetRPMFertilizer']) *
                          100;
                  if (percentageDifference >= 10) {
                    fertilizerMotorsWithError.add(motorIndex + 1);
                  }
                }
                if (acceptedDialog['error'] &&
                    status['isPlanting'] &&
                    fertilizerMotorsWithError.isNotEmpty) {
                  errorDialog('adubo', fertilizerMotorsWithError.toList());
                  fertilizerMotorsWithError.clear();
                  fertilizerMotorsCheckError.clear();
                }
              } else {
                mainTimer['fertilizerErrorCount']++;
              }
            } else {
              mainTimer['fertilizerErrorCount'] = 0;
            }

            // Verifica se os motores da brachiaria estão atingindo o RPM alvo,
            // se estiver 10% a mais ou a menos ele é considerando um motor com erro
            Set brachiariaMotorsWithError = {};
            Set brachiariaMotorsCheckError = {};
            for (var i = 0; i < brachiaria['layout'].length; i++) {
              double percentageDifference = ((motor['rpm']
                                  [brachiaria['addressedLayout'][i] - 1] -
                              motor['targetRPMBrachiaria'])
                          .abs() /
                      motor['targetRPMBrachiaria']) *
                  100;
              if (percentageDifference >= 10 && acceptedDialog['error']) {
                brachiariaMotorsCheckError.add(i);
              }
            }

            if (brachiariaMotorsCheckError.isNotEmpty) {
              if (mainTimer['brachiariaErrorCount'] == 5) {
                for (int motorIndex in brachiariaMotorsCheckError) {
                  double percentageDifference =
                      ((motor['rpm'][brachiaria['addressedLayout'][motorIndex] -
                                          1] -
                                      motor['targetRPMBrachiaria'])
                                  .abs() /
                              motor['targetRPMBrachiaria']) *
                          100;
                  if (percentageDifference >= 10) {
                    brachiariaMotorsWithError.add(motorIndex + 1);
                  }
                }
                if (acceptedDialog['error'] &&
                    status['isPlanting'] &&
                    brachiariaMotorsWithError.isNotEmpty) {
                  errorDialog('braquiária', brachiariaMotorsWithError.toList());
                  brachiariaMotorsWithError.clear();
                  brachiariaMotorsCheckError.clear();
                }
              } else {
                mainTimer['brachiariaErrorCount']++;
              }
            } else {
              mainTimer['brachiariaErrorCount'] = 0;
            }
          } else {
            mainTimer['enableMonitoringCount']++;
          }
          mainTimer['lackCount']++;
        } else {
          mainTimer['lackCount'] = 0;
          mainTimer['manutenceCount'] = 0;
          mainTimer['enableMonitoringCount'] = 0;
          mainTimer['brachiariaErrorCount'] = 0;
          status['showMonitoring'] = false;
        }
        // Incrementa contadores
        mainTimer['manutenceCount']++;
        print("MAIN TIMER: $mainTimer");
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
