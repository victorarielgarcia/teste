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
  });

  openJMAlertBox(
    context,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: dismissible ? true : false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(kDefaultBorderSize))),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  cancel
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            onCancel ?? () {};
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: 40,
                                            height: 30,
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
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
                        horizontal: kDefaultPadding, vertical: kDefaultPadding),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: cancel
                                          ? TextButton(
                                              child: const Text("Cancelar"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                onCancel ?? () {};
                                              })
                                          : const SizedBox()),
                                  const SizedBox(width: kDefaultPadding / 4),
                                  SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: JMButton(
                                          text: "Ok",
                                          backgroundColor: kPrimaryColor,
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
        });
  }
}
