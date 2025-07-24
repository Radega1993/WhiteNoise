import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound.dart';
import '../models/player_state.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<String, AudioPlayerState> _playerStates = {};
  final StreamController<Map<String, AudioPlayerState>> _stateController = 
      StreamController<Map<String, AudioPlayerState>>.broadcast();

  Stream<Map<String, AudioPlayerState>> get stateStream => _stateController.stream;

  Future<void> initializeSound(Sound sound) async {
    if (_players.containsKey(sound.id)) return;

    print('Initializing sound: ${sound.id} with path: ${sound.audioPath}');
    
    final player = AudioPlayer();
    _players[sound.id] = player;
    _playerStates[sound.id] = AudioPlayerState(
      soundId: sound.id,
      volume: sound.defaultVolume,
      isLooping: sound.isLooping,
    );

    // Listen to player state changes
    player.onPlayerStateChanged.listen((state) {
      print('Player state changed for ${sound.id}: $state');
      AudioState audioState;
      switch (state) {
        case PlayerState.playing:
          audioState = AudioState.playing;
          break;
        case PlayerState.paused:
          audioState = AudioState.paused;
          break;
        case PlayerState.stopped:
        default:
          audioState = AudioState.stopped;
          break;
      }
      _updatePlayerState(sound.id, audioState);
    });

    player.onPositionChanged.listen((position) {
      _updatePlayerPosition(sound.id, position);
    });

    player.onDurationChanged.listen((duration) {
      print('Duration changed for ${sound.id}: $duration');
      _updatePlayerDuration(sound.id, duration);
    });

    // Set audio source with better configuration
    try {
      await player.setSource(AssetSource(sound.audioPath));
      await player.setVolume(sound.defaultVolume);
      // Use ReleaseMode.stop for better audio quality
      await player.setReleaseMode(ReleaseMode.stop);
      
      print('Sound ${sound.id} initialized successfully');
    } catch (e) {
      print('Error initializing sound ${sound.id}: $e');
    }
    
    _notifyStateChange();
  }

  Future<void> playSound(String soundId) async {
    print('Attempting to play sound: $soundId');
    
    final player = _players[soundId];
    if (player != null) {
      try {
        final state = await player.state;
        if (state == PlayerState.stopped) {
          // For looping sounds, use ReleaseMode.loop only when playing
          final sound = _getSoundById(soundId);
          if (sound?.isLooping == true) {
            await player.setReleaseMode(ReleaseMode.loop);
          }
          await player.play(AssetSource(_getSoundById(soundId)?.audioPath ?? ''));
        } else {
          await player.resume();
        }
        print('Sound $soundId played successfully');
        _updatePlayerState(soundId, AudioState.playing);
      } catch (e) {
        print('Error playing sound $soundId: $e');
      }
    } else {
      print('Player not found for sound: $soundId');
    }
  }

  Sound? _getSoundById(String soundId) {
    // This is a temporary solution - in a real app, you'd pass the sound list
    if (soundId == 'rain') {
      return Sound(
        id: 'rain',
        name: 'Rain',
        imagePath: 'assets/images/rain.jpg',
        audioPath: 'music/rain.mp3',
        category: 'Nature',
        defaultVolume: 0.5,
        isLooping: true,
      );
    } else if (soundId == 'fountain') {
      return Sound(
        id: 'fountain',
        name: 'Fountain',
        imagePath: 'assets/images/fuente.jpg',
        audioPath: 'music/fountain.mp3',
        category: 'Water',
        defaultVolume: 0.5,
        isLooping: true,
      );
    }
    return null;
  }

  Future<void> pauseSound(String soundId) async {
    final player = _players[soundId];
    if (player != null) {
      await player.pause();
      _updatePlayerState(soundId, AudioState.paused);
    }
  }

  Future<void> stopSound(String soundId) async {
    final player = _players[soundId];
    if (player != null) {
      await player.stop();
      _updatePlayerState(soundId, AudioState.stopped);
    }
  }

  Future<void> setVolume(String soundId, double volume) async {
    final player = _players[soundId];
    if (player != null) {
      await player.setVolume(volume);
      _playerStates[soundId] = _playerStates[soundId]!.copyWith(volume: volume);
      _notifyStateChange();
    }
  }

  Future<void> toggleSound(String soundId) async {
    final state = _playerStates[soundId];
    if (state == null) return;

    if (state.state == AudioState.playing) {
      await pauseSound(soundId);
    } else {
      await playSound(soundId);
    }
  }

  Future<void> stopAllSounds() async {
    for (final player in _players.values) {
      await player.stop();
    }
    
    for (final soundId in _playerStates.keys) {
      _updatePlayerState(soundId, AudioState.stopped);
    }
  }

  Future<void> pauseAllSounds() async {
    for (final player in _players.values) {
      await player.pause();
    }
    
    for (final soundId in _playerStates.keys) {
      _updatePlayerState(soundId, AudioState.paused);
    }
  }

  Future<void> resumeAllSounds() async {
    for (final player in _players.values) {
      await player.resume();
    }
    
    for (final soundId in _playerStates.keys) {
      _updatePlayerState(soundId, AudioState.playing);
    }
  }

  AudioPlayerState? getPlayerState(String soundId) {
    return _playerStates[soundId];
  }

  Map<String, AudioPlayerState> getAllPlayerStates() {
    return Map.unmodifiable(_playerStates);
  }

  bool isAnySoundPlaying() {
    return _playerStates.values.any((state) => state.state == AudioState.playing);
  }

  void _updatePlayerState(String soundId, AudioState state) {
    if (_playerStates.containsKey(soundId)) {
      _playerStates[soundId] = _playerStates[soundId]!.copyWith(state: state);
      _notifyStateChange();
    }
  }

  void _updatePlayerPosition(String soundId, Duration position) {
    if (_playerStates.containsKey(soundId)) {
      _playerStates[soundId] = _playerStates[soundId]!.copyWith(position: position);
      _notifyStateChange();
    }
  }

  void _updatePlayerDuration(String soundId, Duration duration) {
    if (_playerStates.containsKey(soundId)) {
      _playerStates[soundId] = _playerStates[soundId]!.copyWith(duration: duration);
      _notifyStateChange();
    }
  }

  void _notifyStateChange() {
    _stateController.add(Map.unmodifiable(_playerStates));
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _playerStates.clear();
    await _stateController.close();
  }
} 