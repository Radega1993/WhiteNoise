import 'package:audioplayers/audioplayers.dart';

class AudioConfig {
  static const double defaultVolume = 0.5;
  static const double maxVolume = 1.0;
  static const double minVolume = 0.0;
  
  // Audio quality settings
  static const PlayerMode playerMode = PlayerMode.mediaPlayer;
  static const ReleaseMode defaultReleaseMode = ReleaseMode.stop;
  static const ReleaseMode loopReleaseMode = ReleaseMode.loop;
  
  // Volume fade settings for smooth transitions
  static const Duration fadeInDuration = Duration(milliseconds: 500);
  static const Duration fadeOutDuration = Duration(milliseconds: 300);
  
  // Buffer settings for better audio quality
  static const int bufferSize = 8192;
  static const int sampleRate = 44100;
  
  // Error handling
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);
} 