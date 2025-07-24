import 'package:flutter/foundation.dart';
import '../models/sound.dart';
import '../models/player_state.dart';
import '../models/timer_settings.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/timer_service.dart';
import '../services/notification_service.dart';

class AppProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final StorageService _storageService = StorageService();
  final TimerService _timerService = TimerService();

  List<Sound> _sounds = [];
  Map<String, AudioPlayerState> _playerStates = {};
  TimerSettings _timerSettings = TimerSettings();
  List<String> _favorites = [];
  List<String> _lastUsed = [];
  bool _isInitialized = false;

  // Getters
  List<Sound> get sounds => _sounds;
  Map<String, AudioPlayerState> get playerStates => _playerStates;
  TimerSettings get timerSettings => _timerSettings;
  List<String> get favorites => _favorites;
  List<String> get lastUsed => _lastUsed;
  bool get isInitialized => _isInitialized;

  // Streams
  Stream<Map<String, AudioPlayerState>> get audioStateStream => _audioService.stateStream;
  Stream<TimerState> get timerStateStream => _timerService.stateStream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    print('Initializing AppProvider...');

    try {
      // Initialize services
      await _storageService.initialize();
      await NotificationService().initialize();

      // Load sounds
      _loadSounds();

      // Load saved data
      await _loadSavedData();

      // Initialize timer with default settings if none exist
      if (_timerSettings.workDuration == 0) {
        _timerSettings = TimerSettings(); // Use default values
      }
      await _timerService.initialize(_timerSettings);

      // Listen to audio state changes
      _audioService.stateStream.listen((states) {
        _playerStates = states;
        notifyListeners();
        _savePlayerStates();
      });

      // Listen to timer state changes
      _timerService.stateStream.listen((state) {
        print('Timer state changed: ${state.phase}, running: ${state.isRunning}');
        notifyListeners();
      });

      _isInitialized = true;
      notifyListeners();
      print('AppProvider initialized successfully');
    } catch (e) {
      print('Error initializing AppProvider: $e');
      // Even if there's an error, mark as initialized to prevent infinite loading
      _isInitialized = true;
      notifyListeners();
    }
  }

  void _loadSounds() {
    _sounds = [
      Sound(
        id: 'rain',
        name: 'Rain',
        imagePath: 'assets/images/rain.jpg',
        audioPath: 'music/rain.mp3',
        category: 'Nature',
        defaultVolume: 0.5,
        isLooping: true,
      ),
      Sound(
        id: 'fountain',
        name: 'Fountain',
        imagePath: 'assets/images/fuente.jpg',
        audioPath: 'music/fountain.mp3',
        category: 'Water',
        defaultVolume: 0.5,
        isLooping: true,
      ),
    ];
  }

  Future<void> _loadSavedData() async {
    try {
      // Load timer settings
      _timerSettings = await _storageService.getTimerSettings();

      // Load player states
      _playerStates = await _storageService.getPlayerStates();

      // Load favorites
      _favorites = await _storageService.getFavorites();

      // Load last used
      _lastUsed = await _storageService.getLastUsedSounds();

      notifyListeners();
    } catch (e) {
      print('Error loading saved data: $e');
      // Use default values if loading fails
      _timerSettings = TimerSettings();
      _playerStates = {};
      _favorites = [];
      _lastUsed = [];
    }
  }

  Future<void> _savePlayerStates() async {
    try {
      await _storageService.savePlayerStates(_playerStates);
    } catch (e) {
      print('Error saving player states: $e');
    }
  }

  // Audio methods
  Future<void> initializeSound(Sound sound) async {
    await _audioService.initializeSound(sound);
  }

  Future<void> toggleSound(String soundId) async {
    // Initialize sound if not already initialized
    final sound = getSoundById(soundId);
    if (sound != null) {
      await _audioService.initializeSound(sound);
      await _audioService.toggleSound(soundId);
      await _storageService.addToLastUsed(soundId);
    }
  }

  Future<void> setVolume(String soundId, double volume) async {
    await _audioService.setVolume(soundId, volume);
  }

  Future<void> stopAllSounds() async {
    await _audioService.stopAllSounds();
  }

  Future<void> pauseAllSounds() async {
    await _audioService.pauseAllSounds();
  }

  Future<void> resumeAllSounds() async {
    await _audioService.resumeAllSounds();
  }

  // Timer methods
  void startTimer() {
    _timerService.start();
  }

  void pauseTimer() {
    _timerService.pause();
  }

  void resumeTimer() {
    _timerService.resume();
  }

  void stopTimer() {
    _timerService.stop();
  }

  void skipTimer() {
    _timerService.skip();
  }

  Future<void> updateTimerSettings(TimerSettings settings) async {
    _timerSettings = settings;
    await _storageService.saveTimerSettings(settings);
    await _timerService.initialize(settings);
    notifyListeners();
  }

  // Favorites methods
  Future<void> toggleFavorite(String soundId) async {
    final isFavorite = await _storageService.isFavorite(soundId);
    if (isFavorite) {
      await _storageService.removeFromFavorites(soundId);
      _favorites.remove(soundId);
    } else {
      await _storageService.addToFavorites(soundId);
      _favorites.add(soundId);
    }
    notifyListeners();
  }

  bool isFavorite(String soundId) {
    return _favorites.contains(soundId);
  }

  // Utility methods
  Sound? getSoundById(String soundId) {
    try {
      return _sounds.firstWhere((sound) => sound.id == soundId);
    } catch (e) {
      return null;
    }
  }

  List<Sound> getSoundsByCategory(String category) {
    return _sounds.where((sound) => sound.category == category).toList();
  }

  List<Sound> getFavoriteSounds() {
    return _sounds.where((sound) => _favorites.contains(sound.id)).toList();
  }

  List<Sound> getLastUsedSounds() {
    return _lastUsed
        .map((id) => getSoundById(id))
        .where((sound) => sound != null)
        .cast<Sound>()
        .toList();
  }

  bool isAnySoundPlaying() {
    return _audioService.isAnySoundPlaying();
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
} 