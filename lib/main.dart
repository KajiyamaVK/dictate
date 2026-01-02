import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Window Manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 600),
    center: true,
    title: "AI Dictation",
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Prevent "X" from killing the app process
  await windowManager.setPreventClose(true);

  // 2. Initialize System Tray (The function that was missing)
  await setupSystemTray();

  runApp(const MyApp());
}

// This is the function the compiler was looking for
Future<void> setupSystemTray() async {
  final SystemTray systemTray = SystemTray();

  // Make sure assets/app_icon.png exists in your project and pubspec.yaml
  await systemTray.initSystemTray(
    title: "AI Dictation",
    iconPath: 'assets/app_icon.png',
  );

  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(
      label: 'Show App',
      onClicked: (menuItem) => windowManager.show(),
    ),
    MenuItemLabel(
      label: 'Hide App',
      onClicked: (menuItem) => windowManager.hide(),
    ),
    MenuSeparator(),
    MenuItemLabel(
      label: 'Exit',
      onClicked: (menuItem) => windowManager.destroy(),
    ),
  ]);

  await systemTray.setContextMenu(menu);

  // Handle icon clicks
  systemTray.registerSystemTrayEventHandler((eventName) {
    if (eventName == kSystemTrayEventClick) {
      windowManager.show();
    } else if (eventName == kSystemTrayEventRightClick) {
      systemTray.popUpContextMenu();
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this); // Start listening for window events
  }

  @override
  void dispose() {
    windowManager.removeListener(this); // Clean up
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // When user clicks "X", we just hide the window
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('AI Dictate')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, size: 64, color: Colors.blue),
              SizedBox(height: 20),
              Text("Listening for global shortcut..."),
            ],
          ),
        ),
      ),
    );
  }
}
