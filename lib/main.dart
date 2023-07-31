import 'package:easytech_electric_blue/screens/advanced_screen.dart';
import 'package:easytech_electric_blue/screens/brachiaria_screen.dart';
import 'package:easytech_electric_blue/screens/fertilizer_calibration_screen.dart';
import 'package:easytech_electric_blue/screens/fertilizer_screen.dart';
import 'package:easytech_electric_blue/screens/machine_layout_screen.dart';
import 'package:easytech_electric_blue/screens/machine_screen.dart';
import 'package:easytech_electric_blue/screens/module_addressing_screen.dart';
import 'package:easytech_electric_blue/screens/motor_addressing_screen.dart';
import 'package:easytech_electric_blue/screens/motor_screen.dart';
import 'package:easytech_electric_blue/screens/sections_layout_screen.dart';
import 'package:easytech_electric_blue/screens/seed_screen.dart';
import 'package:easytech_electric_blue/screens/sensor_screen.dart';
import 'package:easytech_electric_blue/screens/splash_screen.dart';
import 'package:easytech_electric_blue/screens/support_screen.dart';
import 'package:easytech_electric_blue/screens/velocity_screen.dart';
import 'package:easytech_electric_blue/screens/work_screen.dart';
import 'package:easytech_electric_blue/services/logger.dart';
import 'package:easytech_electric_blue/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'config/theme_data.dart';
import 'screens/fertilizer_calibration_result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  AppLogger.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'EasyTech Electric',
        debugShowCheckedModeBanner: false,
        theme: ThemeDefault().getTheme(),
        initialRoute: SplashScreen.route,
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          WorkScreen.route: (context) => const WorkScreen(),
          MotorScreen.route: (context) => const MotorScreen(),
          MachineScreen.route: (context) => const MachineScreen(),
          MachineLayoutScreen.route: (context) => const MachineLayoutScreen(),
          SeedScreen.route: (context) => const SeedScreen(),
          FertilizerScreen.route: (context) => const FertilizerScreen(),
          BrachiariaScreen.route: (context) => const BrachiariaScreen(),
          VelocityScreen.route: (context) => const VelocityScreen(),
          SensorScreen.route: (context) => const SensorScreen(),
          SupportScreen.route: (context) => const SupportScreen(),
          AdvancedScreen.route: (context) => const AdvancedScreen(),
          ModuleAddressingScreen.route: (context) =>
              const ModuleAddressingScreen(),
          MotorAddressingScreen.route: (context) =>
              const MotorAddressingScreen(),
          FertilizerCalibrationScreen.route: (context) =>
              const FertilizerCalibrationScreen(),
          FertilizerCalibrationResultScreen.route: (context) =>
              const FertilizerCalibrationResultScreen(),
          SectionsLayoutScreen.route: (context) => const SectionsLayoutScreen(),

          // RegisterScreen.route: (context) => const RegisterScreen(),
          // FilesScreen.route: (context) => hasLoading(const FilesScreen()),
          // MachineScreen.route: (context) => hasLoading(const MachineScreen()),
        },
      ),
    );
  }
}

LoaderOverlay hasLoading(Widget screen) {
  return LoaderOverlay(
    useDefaultLoading: false,
    overlayWidget: const Loading(),
    child: screen,
  );
}
