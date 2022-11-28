
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:grade_planner/com/snow/di/injecting.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/startscreen/startscreen.dart';
import 'package:grade_planner/com/snow/ui/theme/color_schemes.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

late Injector provider;

void main()async {
  var binding = WidgetsFlutterBinding.ensureInitialized();
  ModuleContainer().init(Injector()).then((value) {
    provider = value;
    Settings.init();
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Planner',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

      home: const StartScreen(title: 'Grade Planner'),
    );
  }
}
