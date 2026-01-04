import 'package:flutter/material.dart';
import 'services/window.service.dart';
import 'services/tray.service.dart';
import 'services/hotkey.service.dart';
import 'services/recorder.service.dart'; // Import the new service
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services
  await WindowService.init();
  final trayService = TrayService();
  await trayService.init();

  final recorderService = RecorderService();
  await recorderService.init();

  await HotkeyService().init(
    onTrigger: () async {
      debugPrint("Hotkey pressed! Toggling recording...");

      // Toggle recording
      await recorderService.toggleRecording();

      // Update Tray Icon based on new state
      await trayService.setRecordingState(recorderService.isRecording);
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
