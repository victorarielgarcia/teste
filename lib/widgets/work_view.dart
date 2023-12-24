import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';

class JMWorkView extends StatefulWidget {
  const JMWorkView({
    super.key,
  });

  @override
  State<JMWorkView> createState() => _JMWorkViewState();
}

class _JMWorkViewState extends State<JMWorkView>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final nmeaState = nmeaManager.state;
  final antennaState = antennaManager.state;
  bool isAnimationRunning = false;
  double _verticalPosition = 0;
  double speed = 0.0;
  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void speedControl() {
    if (velocity['options'] == 1) {
      if (mounted) {
        setState(() {
          speed = antenna['speed'];
          speed = antennaState.speed;
          if (speed < 1) {
            _animationController.stop();
            isAnimationRunning = false;
          } else {
            if (!isAnimationRunning) {
              speed > 60 ? speed = 60 : speed = speed;
              isAnimationRunning = true;
              _animationController.duration = const Duration(seconds: 10);
              // _animationController.duration = Duration(seconds: 60 ~/ speed);
              _animationController.repeat();
            }
          }
        });
      }
    } else if (velocity['options'] == 2) {
      if (mounted) {
        setState(() {
          speed = nmea['speed'];
          speed = nmeaState.satelliteSpeed;
          if (speed < 1) {
            _animationController.stop();
            isAnimationRunning = false;
          } else {
            if (!isAnimationRunning) {
              speed > 60 ? speed = 60 : speed = speed;

              isAnimationRunning = true;
              _animationController.duration = const Duration(seconds: 10);
              // _animationController.duration = Duration(seconds: 60 ~/ speed);
              _animationController.repeat();
            }
          }
        });
      }
    } else if (velocity['options'] == 3) {
      speed = velocity['speed'].toDouble();
      if (speed < 1) {
        _animationController.stop();
        isAnimationRunning = false;
      } else {
        if (!isAnimationRunning) {
          speed > 60 ? speed = 60 : speed = speed;
          isAnimationRunning = true;
          _animationController.duration = const Duration(seconds: 10);
          // _animationController.duration = Duration(seconds: 60 ~/ speed);
          _animationController.repeat();
        }
      }
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _animationController.stop();
    _animation = Tween<double>(begin: 385, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animation.addListener(() {
      setState(() {
        _verticalPosition = -_animation.value;
      });
    });

    speedControl();
    timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      speedControl();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: !Platform.isWindows ? 660 : 910,
          height: 365,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: 782,
              child: Transform.translate(
                offset: Offset(0, _verticalPosition),
                child: Image.asset(
                  'assets/images/work_background.png',
                  width: 894,
                  height: 782,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/planter.png',
                width: 420,
                fit: BoxFit.fitWidth,
              ),
              //       Positioned(
              //         top: 225,
              //         left: 5.5,
              //         child: AnimatedOpacity(
              //             duration: const Duration(seconds: 1),
              //             opacity: seed['setMotors'][0] == 0 ||
              //                     machine['stoppedMotors'] ||
              //                     speed < 0.5
              //                 ? 0
              //                 : 1,
              //             child: const SeedAnimation()),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 28.5,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][1] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 52,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][2] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 75,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][3] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 98,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][4] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 121,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][5] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 143,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][6] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 167,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][7] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 190,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][8] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 214,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][9] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 237,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][10] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 261,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][11] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 283,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][12] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 306,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][13] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 329,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][14] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 353,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][15] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 225,
              //         left: 376,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][16] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
              //       Positioned(
              //         top: 245,
              //         left: 401,
              //         child: AnimatedOpacity(
              //           duration: const Duration(seconds: 1),
              //           opacity: seed['setMotors'][17] == 0 ||
              //                   machine['stoppedMotors'] ||
              //                   speed < 0.5
              //               ? 0
              //               : 1,
              //           child: const SeedAnimation(),
              //         ),
              //       ),
            ],
          ),
        ),
      ],
    );
  }
}

class SeedAnimation extends StatefulWidget {
  const SeedAnimation({
    super.key,
  });

  @override
  State<SeedAnimation> createState() => _SeedAnimationState();
}

class _SeedAnimationState extends State<SeedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _verticalPosition = 0;
  Timer? timer;
  bool stopped = false;
  double speed = 0.0;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 189, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    )
      ..addListener(() {
        setState(() {
          _verticalPosition = -_animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });

    _animationController.forward();

    timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (velocity['options'] == 1) {
        if (mounted) {
          speed = antenna['speed'];
          setState(() {
            if (speed < 1) {
              stopped = true;
              _animationController.stop();
            } else {
              if (stopped) {
                _animationController.forward();
              }
              stopped = false;
            }
          });
        }
      } else if (velocity['options'] == 2) {
        if (mounted) {
          speed = nmea['speed'];
          setState(() {
            if (speed < 1) {
              stopped = true;
              _animationController.stop();
            } else {
              if (stopped) {
                _animationController.forward();
              }
              stopped = false;
            }
          });
        }
      } else if (velocity['options'] == 3) {
        speed = velocity['speed'].toDouble();
        setState(() {
          if (speed < 1) {
            stopped = true;
            _animationController.stop();
          } else {
            if (stopped) {
              _animationController.forward();
            }
            stopped = false;
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  List<Seed> generateSeeds() {
    List<Seed> widgets = [];
    for (int i = 0; i < 20; i++) {
      widgets.add(
        Seed(key: ValueKey<int>(i)),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, _verticalPosition),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: generateSeeds(),
        ),
      ),
    );
  }
}

class Seed extends StatefulWidget {
  final bool isFirst;
  final int isTeste;

  const Seed({
    super.key,
    this.isTeste = 0,
    this.isFirst = false,
  });

  @override
  State<Seed> createState() => _SeedState();
}

class _SeedState extends State<Seed> with SingleTickerProviderStateMixin {
  double topPosition = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          kDefaultPadding / 6, kDefaultPadding / 4, 0, kDefaultPadding / 4),
      child: Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: widget.isTeste == 1
              ? kErrorColor
              : widget.isTeste == 2
                  ? kWarningColor
                  : kSuccessColor,
          border: Border.all(
              color: kStrokeColor,
              strokeAlign: BorderSide.strokeAlignInside,
              width: 1),
          borderRadius: BorderRadius.circular(
            kDefaultBorderSize,
          ),
        ),
      ),
    );
  }
}
