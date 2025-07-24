enum AudioState { stopped, playing, paused }

class AudioPlayerState {
  final String soundId;
  final AudioState state;
  final double volume;
  final bool isLooping;
  final Duration position;
  final Duration duration;

  AudioPlayerState({
    required this.soundId,
    this.state = AudioState.stopped,
    this.volume = 0.5,
    this.isLooping = true,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    String? soundId,
    AudioState? state,
    double? volume,
    bool? isLooping,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      soundId: soundId ?? this.soundId,
      state: state ?? this.state,
      volume: volume ?? this.volume,
      isLooping: isLooping ?? this.isLooping,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundId': soundId,
      'state': state.index,
      'volume': volume,
      'isLooping': isLooping,
      'position': position.inMilliseconds,
      'duration': duration.inMilliseconds,
    };
  }

  factory AudioPlayerState.fromJson(Map<String, dynamic> json) {
    return AudioPlayerState(
      soundId: json['soundId'],
      state: AudioState.values[json['state'] ?? 0],
      volume: json['volume']?.toDouble() ?? 0.5,
      isLooping: json['isLooping'] ?? true,
      position: Duration(milliseconds: json['position'] ?? 0),
      duration: Duration(milliseconds: json['duration'] ?? 0),
    );
  }
} 