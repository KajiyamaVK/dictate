import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotkeyService {
  Future<void> init({required VoidCallback onTrigger}) async {
    await hotKeyManager.unregisterAll();

    HotKey hotKey = HotKey(
      key: PhysicalKeyboardKey.keyK, // Changed to K
      modifiers: [
        HotKeyModifier.alt,
        HotKeyModifier.control, // Changed to CTRL + ALT
      ],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        onTrigger();
      },
    );
  }
}
