import 'dart:io';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class AudioProcessorService {
  /// Trims silence from the beginning, end, and middle of the audio file.
  /// Returns the path to the processed file, or null if it failed.
  Future<String?> trimSilence(String inputPath) async {
    final String outputPath = _getOutputPath(inputPath);

    // FFmpeg filter:
    // - start_periods=1 (trim start)
    // - stop_periods=-1 (trim all other silence)
    // - detection threshold -50dB
    const String filter =
        "silenceremove=start_periods=1:stop_periods=-1:start_threshold=-50dB:stop_threshold=-50dB";

    bool success = false;

    if (Platform.isLinux) {
      success = await _runLinuxFFmpeg(inputPath, outputPath, filter);
    } else {
      success = await _runMobileMacFFmpeg(inputPath, outputPath, filter);
    }

    if (success) {
      debugPrint("Audio treatment complete: $outputPath");

      // Optional: Delete original if you only want the treated one
      // await File(inputPath).delete();

      return outputPath;
    } else {
      debugPrint("Audio treatment failed.");
      return null;
    }
  }

  String _getOutputPath(String inputPath) {
    final dir = p.dirname(inputPath);
    final name = p.basenameWithoutExtension(inputPath);
    final ext = p.extension(inputPath);
    return p.join(dir, '${name}_trimmed$ext');
  }

  // Linux: Use system binary via Process.run
  Future<bool> _runLinuxFFmpeg(
    String input,
    String output,
    String filter,
  ) async {
    try {
      final result = await Process.run('ffmpeg', [
        '-i', input,
        '-af', filter,
        '-y', // Overwrite output if exists
        output,
      ]);

      if (result.exitCode == 0) {
        return true;
      } else {
        debugPrint("Linux FFmpeg Error: ${result.stderr}");
        return false;
      }
    } catch (e) {
      debugPrint("Failed to run system FFmpeg: $e");
      return false;
    }
  }

  // MacOS/Mobile: Use the Flutter package
  Future<bool> _runMobileMacFFmpeg(
    String input,
    String output,
    String filter,
  ) async {
    // We wrap path in quotes just in case, though the kit handles most well
    final command = '-i "$input" -af $filter -y "$output"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return true;
    } else {
      final logs = await session.getAllLogsAsString();
      debugPrint("FFmpeg Kit Error: $logs");
      return false;
    }
  }
}
