import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  String get lastWords => _lastWords;
  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _speechEnabled;

  Future<bool> init() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) => debugPrint('Voice Status: $status'),
        onError: (errorNotification) =>
            debugPrint('Voice Error: $errorNotification'),
      );
      return _speechEnabled;
    } catch (e) {
      debugPrint("Voice init error: $e");
      return false;
    }
  }

  Future<void> startListening({required Function(String) onResult}) async {
    if (!_speechEnabled) {
      bool available = await init();
      if (!available) return;
    }

    await _speechToText.listen(onResult: (result) {
      _lastWords = result.recognizedWords;
      onResult(_lastWords);
    });
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
