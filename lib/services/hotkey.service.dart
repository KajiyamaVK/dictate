import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for PhysicalKeyboardKey
import 'package:hotkey_manager/hotkey_manager.dart';

class HotkeyService {
  Future<void> init({required VoidCallback onTrigger}) async {
    // Unregister any existing hotkeys to prevent duplicates during hot reloads
    await hotKeyManager.unregisterAll();

    // Define the HotKey using PhysicalKeyboardKey and named parameters
    HotKey hotKey = HotKey(
      key: PhysicalKeyboardKey.keyD, // Replaces deprecated KeyCode.keyD
      modifiers: [
        HotKeyModifier.alt,
        HotKeyModifier.shift,
      ], // Use HotKeyModifier enum
      scope: HotKeyScope.system, // Makes it a global shortcut
    );

    // Register the hotkey with a callback
    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        onTrigger();
      },
    );
  }
}
