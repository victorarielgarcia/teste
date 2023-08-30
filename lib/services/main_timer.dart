import 'dart:async';

import 'package:easytech_electric_blue/services/bluetooth.dart';
import 'package:easytech_electric_blue/services/speed.dart';
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
    motor['rpm'][23] = 10.0;
    motor['rpm'][42] = 10.0;
    motor['rpm'][43] = 10.0;
    motor['rpm'][44] = 8.2;
    motor['targetRPMBrachiaria'] = 10.0;
    motorManager.updateRPM(
      motor['rpm'],
      motor['targetRPMBrachiaria'],
      motor['targetRPMFertilizer'],
      motor['targetRPMSeed'],
    );
    seed['rate'][0] = 5.0;
    seed['rate'][1] = 5.0;
    seed['rate'][2] = 5.0;
    seed['rate'][3] = 5.0;
    List<double> doubleList =
        (seed['rate'] as List<dynamic>).map((e) => e as double).toList();
    seedManager.updateRate(doubleList);

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

            // Verifica os motores de semente que deveriam estar rodando
            for (var i = 0; i < machine['numberOfLines']; i++) {
              double percentageDifference = ((motor['rpm']
                                  [seed['addressedLayout'][i] - 1] -
                              motor['targetRPMSeed'])
                          .abs() /
                      motor['targetRPMSeed']) *
                  100;
              if (percentageDifference >= 10) {
                Timer(const Duration(seconds: 5), () {
                  double percentageDifference = ((motor['rpm']
                                      [seed['addressedLayout'][i] - 1] -
                                  motor['targetRPMSeed'])
                              .abs() /
                          motor['targetRPMSeed']) *
                      100;
                  if (percentageDifference >= seed["secondErrorLimit"]) {
                    print("RPM FORA SEMENTE: ${i + 1}");
                    if (acceptedDialog['error']) {
                      errorDialog();
                    }
                  }
                });
              }
            }

            // Verifica os motores de adubo que deveriam estar rodando
            for (var i = 0; i < fertilizer['layout'].length; i++) {
              double percentageDifference = ((motor['rpm']
                                  [fertilizer['addressedLayout'][i] - 1] -
                              motor['targetRPMFertilizer'])
                          .abs() /
                      motor['targetRPMFertilizer']) *
                  100;
              if (percentageDifference >= 10) {
                Timer(const Duration(seconds: 5), () {
                  double percentageDifference = ((motor['rpm']
                                      [fertilizer['addressedLayout'][i] - 1] -
                                  motor['targetRPMFertilizer'])
                              .abs() /
                          motor['targetRPMFertilizer']) *
                      100;
                  if (percentageDifference >= 10) {
                    print("RPM FORA ADUBO: ${i + 1}");
                    if (acceptedDialog['error']) {
                      errorDialog();
                    }
                  }
                });
              }
            }

            // Verifica os motores de braquiária que deveriam estar rodando
            for (var i = 0; i < brachiaria['layout'].length; i++) {
              double percentageDifference = ((motor['rpm']
                                  [brachiaria['addressedLayout'][i] - 1] -
                              motor['targetRPMBrachiaria'])
                          .abs() /
                      motor['targetRPMBrachiaria']) *
                  100;
              if (percentageDifference >= 10) {
                Timer(const Duration(seconds: 5), () {
                  double percentageDifference = ((motor['rpm']
                                      [brachiaria['addressedLayout'][i] - 1] -
                                  motor['targetRPMBrachiaria'])
                              .abs() /
                          motor['targetRPMBrachiaria']) *
                      100;
                  if (percentageDifference >= 10) {
                    print("RPM FORA BRAQUIÁRIA: ${i + 1}");
                    if (acceptedDialog['error']) {
                      errorDialog();
                    }
                  }
                });
              }
            }
          } else {
            mainTimer['enableMonitoringCount']++;
          }
        } else {
          acceptedDialog['error'] = true;
        }

        // Incrementa contadores
        mainTimer['lackCount']++;
        mainTimer['manutenceCount']++;

        print("MAIN TIMER: $mainTimer");
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
