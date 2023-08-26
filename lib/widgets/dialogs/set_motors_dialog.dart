
import 'package:flutter/material.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/sizes.dart';
import '../../utilities/global.dart';
import '../../utilities/messages.dart';
import '../alert_box.dart';
import '../card.dart';

setMotorsDialog() {
  JMAlertBox(
          title: 'Configurar motores',
          onPressed: () {},
          dismissible: true,
          insetPadding: 100,
          width: 1200,
          ok: false,
          cancel: true,
          offsetPosition: 120,
          body: const SetMotorsDialog())
      .openJMAlertBox(navigatorKey.currentContext);
}

class SetMotorsDialog extends StatefulWidget {
  const SetMotorsDialog({
    super.key,
  });

  @override
  State<SetMotorsDialog> createState() => _SetMotorsDialogState();
}

class _SetMotorsDialogState extends State<SetMotorsDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            !machine['brachiaria']
                ? const SizedBox()
                : Column(
                    children: [
                      const Text(
                        "Braquiária",
                        style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 2),
                        child: SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: brachiaria['layout'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding / 4),
                                child: JMCard(
                                  height: 60,
                                  width: 100,
                                  body: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Column(children: [
                                          const SizedBox(
                                              height: kDefaultPadding / 2),
                                          Text(
                                            "Motor ${index + 1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Switch(
                                                value: brachiaria['setMotors']
                                                            [index] ==
                                                        1
                                                    ? true
                                                    : false,
                                                activeColor: kSuccessColor,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    value
                                                        ? brachiaria[
                                                                'setMotors']
                                                            [index] = 1
                                                        : brachiaria[
                                                                'setMotors']
                                                            [index] = 0;
                                                  });
                                                  Messages()
                                                      .message["setMotors"]!();
                                                }),
                                          ),
                                        ]),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (brachiaria['setMotors']
                                                      [index] ==
                                                  1) {
                                                brachiaria['setMotors'][index] =
                                                    0;
                                              } else {
                                                brachiaria['setMotors'][index] =
                                                    1;
                                              }
                                            });
                                            Messages().message["setMotors"]!();
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 90,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                    ],
                  ),
            !machine['fertilizer']
                ? const SizedBox()
                : Column(
                    children: [
                      const Text(
                        "Adubo",
                        style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 2),
                        child: SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: fertilizer['layout'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding / 4),
                                child: JMCard(
                                  height: 60,
                                  width: 100,
                                  body: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Column(children: [
                                          const SizedBox(
                                              height: kDefaultPadding / 2),
                                          Text(
                                            "Motor ${index + 1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Switch(
                                              value: fertilizer['setMotors']
                                                          [index] ==
                                                      1
                                                  ? true
                                                  : false,
                                              activeColor: kSuccessColor,
                                              onChanged: (bool value) {},
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (fertilizer['setMotors']
                                                      [index] ==
                                                  1) {
                                                fertilizer['setMotors'][index] =
                                                    0;
                                              } else {
                                                fertilizer['setMotors'][index] =
                                                    1;
                                              }
                                            });
                                            Messages().message["setMotors"]!();
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 90,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                    ],
                  ),
            const Text(
              "Semente",
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              child: SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: machine['numberOfLines'],
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 4),
                      child: JMCard(
                        height: 60,
                        width: 100,
                        body: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(children: [
                                const SizedBox(height: kDefaultPadding / 2),
                                Text(
                                  "Motor ${index + 1}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Switch(
                                      value: seed['setMotors'][index] == 1
                                          ? true
                                          : false,
                                      activeColor: kSuccessColor,
                                      onChanged: (bool value) {
                                        setState(() {
                                          value
                                              ? seed['setMotors'][index] = 1
                                              : seed['setMotors'][index] = 0;
                                        });

                                        Messages().message["setMotors"]!();
                                      }),
                                ),
                              ]),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (seed['setMotors'][index] == 1) {
                                      seed['setMotors'][index] = 0;
                                    } else {
                                      seed['setMotors'][index] = 1;
                                    }
                                  });
                                  Messages().message["setMotors"]!();
                                },
                                child: Container(
                                  width: 100,
                                  height: 90,
                                  color: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
          ],
        ),
      ),
    );
  }
}
