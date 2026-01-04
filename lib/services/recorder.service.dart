import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'audio_processor.service.dart';

class RecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioProcessorService _audioProcessor = AudioProcessorService();

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<void> init() async {
    // Check and request permission if needed
    if (!await _audioRecorder.hasPermission()) {
      debugPrint("Microphone permission not granted");
    }
  }

  Future<String?> toggleRecording() async {
    if (_isRecording) {
      return await _stop();
    } else {
      await _start();
      return null;
    }
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final String filePath = await _getFilePath();

        // CONFIGURED: Noise suppression, Echo cancellation, and Auto Gain
        const config = RecordConfig(
          noiseSuppress: true,
          echoCancel: true,
          autoGain:
              true, // Best practice: keeps volume consistent when noise is suppressed
        );

        // Start recording to file with the config
        await _audioRecorder.start(config, path: filePath);

        _isRecording = true;
        debugPrint("Started recording to $filePath");
      }
    } catch (e) {
      debugPrint("Error starting record: $e");
    }
  }

  Future<String?> _stop() async {
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      debugPrint("Stopped recording. Raw file: $path");

      if (path != null) {
        // --- NEW: Apply Treatment ---
        debugPrint("Processing audio...");
        final processedPath = await _audioProcessor.trimSilence(path);

        if (processedPath != null) {
          debugPrint("Final processed file: $processedPath");
          return processedPath; // Return the treated file
        }
        return path; // Fallback to raw file if processing failed
      }
      return null;
    } catch (e) {
      debugPrint("Error stopping record: $e");
      return null;
    }
  }

  Future<String> _getFilePath() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dictateDir = '${dir.path}/Dictate';

    await Directory(dictateDir).create(recursive: true);

    final String timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    // Using .m4a (AAC) which is the default and efficient for voice
    return '$dictateDir/recording_$timestamp.m4a';
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
