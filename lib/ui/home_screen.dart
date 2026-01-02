import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  @override
  void initState() {
    super.initState();
    // Register this screen as a listener for window events (like clicking "X")
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is destroyed
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // Intercept the close button to hide the window instead of quitting
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Dictate'), centerTitle: true),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 64, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Listening for global shortcut...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
