import 'package:flutter/material.dart';
import 'services/window.service.dart';
import 'services/tray.service.dart';
import 'services/hotkey.service.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services
  await WindowService.init();
  await TrayService().init();

  await HotkeyService().init(
    onTrigger: () {
      debugPrint("Hotkey pressed!");
      WindowService.show();
      WindowService.focus();
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
