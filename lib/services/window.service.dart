import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  static Future<void> init() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(400, 600),
      center: true,
      title: "AI Dictate",
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    await windowManager.setPreventClose(true);
  }

  static Future<void> show() async {
    await windowManager.show();
  }

  static Future<void> focus() async {
    await windowManager.focus();
  }
}
