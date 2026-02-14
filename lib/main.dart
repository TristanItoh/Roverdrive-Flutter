import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

import 'main_scene.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  theme: ThemeData(
    scaffoldBackgroundColor: AppColors.bColorre,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.secondaryColo,
    ),
  ),
  home: const MainScene(),
);
  }
}
