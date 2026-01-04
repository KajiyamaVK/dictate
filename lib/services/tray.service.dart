import 'dart:io';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class TrayService {
  final SystemTray _systemTray = SystemTray();

  Future<void> init() async {
    await _systemTray.initSystemTray(
      title: "AI Dictate",
      iconPath: _getIconPath(false),
    );

    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show App', onClicked: (_) => windowManager.show()),
      MenuItemLabel(label: 'Hide App', onClicked: (_) => windowManager.hide()),
      MenuSeparator(),
      MenuItemLabel(label: 'Exit', onClicked: (_) => windowManager.destroy()),
    ]);

    await _systemTray.setContextMenu(menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        windowManager.show();
      } else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
    });
  }

  Future<void> setRecordingState(bool isRecording) async {
    await _systemTray.setImage(_getIconPath(isRecording));
  }

  String _getIconPath(bool isRecording) {
    // Ensure you have this second icon in your assets folder!
    return isRecording ? 'assets/app_icon_mic.png' : 'assets/app_icon.png';
  }
}
