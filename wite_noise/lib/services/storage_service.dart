import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_settings.dart';
import '../models/player_state.dart';

class StorageService {
  static const String _timerSettingsKey = 'timer_settings';
  static const String _playerStatesKey = 'player_states';
  static const String _favoritesKey = 'favorites';
  static const String _lastUsedSoundsKey = 'last_used_sounds';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Timer Settings
  Future<void> saveTimerSettings(TimerSettings settings) async {
    await _prefs.setString(_timerSettingsKey, jsonEncode(settings.toJson()));
  }

  Future<TimerSettings> getTimerSettings() async {
    final jsonString = _prefs.getString(_timerSettingsKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return TimerSettings.fromJson(json);
      } catch (e) {
        print('Error parsing timer settings: $e');
      }
    }
    return TimerSettings(); // Return default settings
  }

  // Player States
  Future<void> savePlayerStates(Map<String, AudioPlayerState> states) async {
    final statesMap = <String, Map<String, dynamic>>{};
    for (final entry in states.entries) {
      statesMap[entry.key] = entry.value.toJson();
    }
    await _prefs.setString(_playerStatesKey, jsonEncode(statesMap));
  }

  Future<Map<String, AudioPlayerState>> getPlayerStates() async {
    final jsonString = _prefs.getString(_playerStatesKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final states = <String, AudioPlayerState>{};
        for (final entry in json.entries) {
          states[entry.key] = AudioPlayerState.fromJson(entry.value);
        }
        return states;
      } catch (e) {
        print('Error parsing player states: $e');
      }
    }
    return {};
  }

  // Favorites
  Future<void> saveFavorites(List<String> favoriteSoundIds) async {
    await _prefs.setStringList(_favoritesKey, favoriteSoundIds);
  }

  Future<List<String>> getFavorites() async {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addToFavorites(String soundId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(soundId)) {
      favorites.add(soundId);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(String soundId) async {
    final favorites = await getFavorites();
    favorites.remove(soundId);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(String soundId) async {
    final favorites = await getFavorites();
    return favorites.contains(soundId);
  }

  // Last Used Sounds
  Future<void> saveLastUsedSounds(List<String> soundIds) async {
    await _prefs.setStringList(_lastUsedSoundsKey, soundIds);
  }

  Future<List<String>> getLastUsedSounds() async {
    return _prefs.getStringList(_lastUsedSoundsKey) ?? [];
  }

  Future<void> addToLastUsed(String soundId) async {
    final lastUsed = await getLastUsedSounds();
    lastUsed.remove(soundId); // Remove if already exists
    lastUsed.insert(0, soundId); // Add to beginning
    
    // Keep only last 10
    if (lastUsed.length > 10) {
      lastUsed.removeRange(10, lastUsed.length);
    }
    
    await saveLastUsedSounds(lastUsed);
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
} 