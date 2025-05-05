// //
// // import 'package:just_audio/just_audio.dart';
// //
// // class SoundController {
// //   static final SoundController _instance = SoundController._internal();
// //   factory SoundController() => _instance;
// //   SoundController._internal();
// //
// //   final AudioPlayer _audioPlayer = AudioPlayer();
// //
// //   Future<void> playWheelSound() async {
// //     try {
// //       await _audioPlayer.setAsset('assets/sound/musicOne.mp3');
// //       // await _audioPlayer.setLoopMode(LoopMode.all);
// //       await _audioPlayer.play();
// //     } catch (e) {
// //       print("Error playing sound: $e");
// //     }
// //   }
// //
// //   Future<void> stopWheelSound() async {
// //     try {
// //       await _audioPlayer.stop();
// //     } catch (e) {
// //       print("Error stopping sound: $e");
// //     }
// //   }
// //
// //   void dispose() {
// //     _audioPlayer.dispose();
// //   }
// // }
//
//
import 'dart:developer';
import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';

// class AudioController {
//   // static final AudioController _instance = AudioController._internal();
//   // factory AudioController() => _instance;
//   // AudioController._internal();
//
//   // final AudioPlayer _audioPlayer = AudioPlayer();
//
//   // Future<void> playWheelSound() async {
//   //   try {
//   //     String filePath = await _getAssetFilePath('assets/sound/musicOne.mp3');
//   //     await _audioPlayer.play(DeviceFileSource(filePath));
//   //   } catch (e) {
//   //     print("Error playing sound: $e");
//   //   }
//   // }
//
//   Future<String> _getAssetFilePath(String asset) async {
//     final ByteData data = await rootBundle.load(asset);
//     final Directory tempDir = await getTemporaryDirectory();
//     final File file = File('${tempDir.path}/musicOne.mp3');
//     await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
//     return file.path;
//   }
//   //
//   // Future<void> stopWheelSound() async {
//   //   try {
//   //     await _audioPlayer.stop();
//   //   } catch (e) {
//   //     print("Error stopping sound: $e");
//   //   }
//   // }
//
//   // Future<void> playSound(String fileName) async {
//   //   try {
//   //     _audioPlayer.stop();
//   //     String filePath = await _getAssetFilePath('assets/sound/$fileName.mp3');
//   //     await _audioPlayer.play(DeviceFileSource(filePath));
//   //   } catch (e) {
//   //     print("Error playing sound: $e");
//   //   }
//   // }
//
//   Future<void> playSound(String fileName) async {
//     try {
//       Media media = await Media.memory(
//         (await loadAsset(
//           path: 'assets/sound/$fileName.mp3',
//         )).buffer.asUint8List(),
//       );
//       audioPlayer.open(media);
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   Future<ByteData> loadAsset({required String path}) async {
//     return await rootBundle.load(path);
//   }
//
//   Player audioPlayer = Player();
//   Future<void> playWheelSound() async {
//     try {
//       Media media = await Media.memory(
//         (await loadAsset(
//           path: 'assets/sound/musicOne.mp3',
//         )).buffer.asUint8List(),
//       );
//       audioPlayer.open(media);
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   Future<void> stopSound() async {
//     try {
//       await _audioPlayer.stop();
//     } catch (e) {
//       print("Error stopping sound: $e");
//     }
//   }
//
//   // Future<void> pauseSound() async {
//   //   try {
//   //     await _audioPlayer.pause();
//   //   } catch (e) {
//   //     print("Error pausing sound: $e");
//   //   }
//   // }
//   //
//   // Future<void> resumeSound() async {
//   //   try {
//   //     await _audioPlayer.resume();
//   //   } catch (e) {
//   //     print("Error resuming sound: $e");
//   //   }
//   // }
//   //
//   // Future<void> setVolume(double volume) async {
//   //   try {
//   //     await _audioPlayer.setVolume(volume);
//   //   } catch (e) {
//   //     print("Error setting volume: $e");
//   //   }
//   // }
//   //
//   // void dispose() {
//   //   _audioPlayer.dispose();
//   // }
// }


class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  final Player _audioPlayer = Player();

  /// Load asset from bundle
  Future<ByteData> loadAsset({required String path}) async {
    return await rootBundle.load(path);
  }

  /// Convert asset to memory & play sound
  Future<void> playSound(String fileName) async {
    try {
      await _audioPlayer.stop(); // Stop previous if playing
      Media media = await Media.memory(
        (await loadAsset(path: 'assets/sound/$fileName.mp3')).buffer.asUint8List(),
      );
      await _audioPlayer.open(media);
    } catch (e) {
      log("Error playing sound: $e");
    }
  }

  /// Specific sound function (can be reused as shortcut)
  Future<void> playWheelSound() async {
    await playSound("musicOne");
  }

  /// Stop current sound
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      log("Error stopping sound: $e");
    }
  }

  /// Pause current sound
  Future<void> pauseSound() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      log("Error pausing sound: $e");
    }
  }

  /// Resume paused sound
  Future<void> resumeSound() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      log("Error resuming sound: $e");
    }
  }

  /// Set audio volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      log("Error setting volume: $e");
    }
  }

  /// Clean up player resources
  void dispose() {
    _audioPlayer.dispose();
  }

  Future<String> generateBarcodeImage(String data) async {
    final Barcode bc = Barcode.code128();
    final Uint8List barcodeBytes = Uint8List.fromList(
      bc.toSvg(data, width: 300, height: 80).codeUnits,
    );

    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/barcode.svg');
    await file.writeAsBytes(barcodeBytes);

    return file.path;
  }
}
