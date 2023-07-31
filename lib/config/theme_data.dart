import 'package:flutter/material.dart';
import '../utilities/constants/colors.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}

class ThemeDefault {
  ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: kBackgroundColor,
      textSelectionTheme: const TextSelectionThemeData(
        // cursorColor: Colors.red,
        // selectionColor: Colors.green,
        selectionHandleColor: Colors.transparent,
      ),
      // brightness: Brightness.light,
      // appBarTheme: const AppBarTheme(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: kPrimaryColor
      // ),
      //   color: kSecondaryColor,
      // ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: NoTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionsBuilder(),
        },
      ),
      // checkboxTheme: CheckboxThemeData(
      //   side: MaterialStateBorderSide.resolveWith(
      //     (_) => BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.5)),
      //   ),
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //   fillColor: MaterialStateProperty.all(kSecondaryColor),
      //   checkColor: MaterialStateProperty.all(Colors.white),
      // ),
    );
  }
}
