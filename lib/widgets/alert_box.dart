import 'package:flutter/material.dart';

import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import 'button.dart';

class JMAlertBox {
  final String title;
  final void Function() onPressed;
  final void Function()? onCancel;
  final bool ok;
  final bool cancel;
  final bool dismissible;
  final double insetPadding;
  final double width;
  final Widget body;
  final int errorType;
  final double offsetPosition;

  JMAlertBox({
    required this.title,
    required this.onPressed,
    this.onCancel,
    this.ok = true,
    this.cancel = false,
    this.dismissible = false,
    this.insetPadding = 0.0,
    this.width = 500.0,
    required this.body,
    this.errorType = 0,
    this.offsetPosition = 220.0,
  });

  openJMAlertBox(context) {
    return showDialog(
        context: context,
        barrierDismissible: dismissible ? true : false,
        builder: (navigatorKey) {
          return Stack(
            children: [
              Positioned(
                top: offsetPosition,
                left: 0,
                right: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(kDefaultBorderSize))),
                      contentPadding: const EdgeInsets.only(top: 10.0),
                      insetPadding: EdgeInsets.only(bottom: insetPadding),
                      content: SizedBox(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            title == ''
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            errorType == 0
                                                ? kDefaultPadding / 2
                                                : kDefaultPadding * 3,
                                            0,
                                            kDefaultPadding / 4),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                title,
                                                style: const TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24),
                                              ),
                                            ),
                                            // ... resto do seu código
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: kDefaultPadding / 4,
                                      ),
                                      const Divider(
                                        color: kStrokeColor,
                                        height: 1.0,
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding),
                              child: body,
                            ),
                            !ok
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: kDefaultPadding / 4,
                                      ),
                                      const Divider(
                                        color: kStrokeColor,
                                        height: 1.0,
                                      ),
                                      const SizedBox(
                                        height: kDefaultPadding / 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding,
                                            vertical: kDefaultPadding / 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                                height: 40,
                                                width: 100,
                                                child: cancel
                                                    ? TextButton(
                                                        child: const Text(
                                                            "Cancelar"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          onCancel ?? () {};
                                                        })
                                                    : const SizedBox()),
                                            const SizedBox(
                                                width: kDefaultPadding / 4),
                                            SizedBox(
                                                height: 40,
                                                width: 100,
                                                child: JMButton(
                                                    text: "Ok",
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      onCancel ?? () {};
                                                    })),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: kDefaultPadding / 4,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              errorType == 0
                  ? const SizedBox()
                  : Positioned(
                      top: 165,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: errorType == 1 ? kWarningColor : kErrorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            errorType == 1
                                ? Icons.priority_high_outlined
                                : Icons.close,
                            size: 65,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                    ),
            ],
          );
        });
  }
}
