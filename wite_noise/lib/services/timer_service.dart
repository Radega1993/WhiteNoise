import 'dart:async';
import '../models/timer_settings.dart';
import 'notification_service.dart';

enum TimerPhase { work, shortBreak, longBreak }

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  Timer? _timer;
  TimerSettings _settings = TimerSettings();
  TimerPhase _currentPhase = TimerPhase.work;
  int _currentSession = 1;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  final StreamController<TimerState> _stateController = 
      StreamController<TimerState>.broadcast();

  Stream<TimerState> get stateStream => _stateController.stream;

  TimerSettings get settings => _settings;
  TimerPhase get currentPhase => _currentPhase;
  int get currentSession => _currentSession;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  Future<void> initialize(TimerSettings settings) async {
    print('Initializing TimerService with settings: ${settings.workDuration}min work, ${settings.breakDuration}min break');
    _settings = settings;
    _currentPhase = TimerPhase.work;
    _currentSession = 1;
    _remainingSeconds = settings.workDuration * 60;
    _isRunning = false;
    _isPaused = false;
    _notifyStateChange();
    print('TimerService initialized. Remaining seconds: $_remainingSeconds');
  }

  void start() {
    if (_isRunning) return;
    
    print('Starting timer. Phase: $_currentPhase, Session: $_currentSession, Remaining: $_remainingSeconds');
    _isRunning = true;
    _isPaused = false;
    _startTimer();
    _notifyStateChange();
  }

  void pause() {
    if (!_isRunning || _isPaused) return;
    
    _isPaused = true;
    _timer?.cancel();
    _notifyStateChange();
  }

  void resume() {
    if (!_isRunning || !_isPaused) return;
    
    _isPaused = false;
    _startTimer();
    _notifyStateChange();
  }

  void stop() {
    _isRunning = false;
    _isPaused = false;
    _timer?.cancel();
    _currentPhase = TimerPhase.work;
    _currentSession = 1;
    _remainingSeconds = _settings.workDuration * 60;
    _notifyStateChange();
  }

  void skip() {
    _timer?.cancel();
    _nextPhase();
  }

  void _startTimer() {
    print('Starting timer ticker');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        if (_remainingSeconds % 60 == 0) {
          print('Timer tick: $_remainingSeconds seconds remaining');
        }
        _notifyStateChange();
      } else {
        _timerComplete();
      }
    });
  }

  void _timerComplete() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    
    // Show notification
    _showNotification();
    
    // Auto-start next phase if enabled
    if (_currentPhase == TimerPhase.work) {
      if (_settings.autoStartBreaks) {
        _nextPhase();
        start();
      }
    } else {
      if (_settings.autoStartWork) {
        _nextPhase();
        start();
      }
    }
    
    _notifyStateChange();
  }

  void _nextPhase() {
    if (_currentPhase == TimerPhase.work) {
      if (_currentSession % _settings.sessionsBeforeLongBreak == 0) {
        _currentPhase = TimerPhase.longBreak;
        _remainingSeconds = _settings.longBreakDuration * 60;
      } else {
        _currentPhase = TimerPhase.shortBreak;
        _remainingSeconds = _settings.breakDuration * 60;
      }
    } else {
      _currentPhase = TimerPhase.work;
      _currentSession++;
      _remainingSeconds = _settings.workDuration * 60;
    }
    
    _notifyStateChange();
  }

  Future<void> _showNotification() async {
    if (!_settings.notificationsEnabled) return;

    String title;
    String body;

    switch (_currentPhase) {
      case TimerPhase.work:
        title = 'Work Session Complete!';
        body = 'Time for a break. Great job!';
        break;
      case TimerPhase.shortBreak:
        title = 'Break Complete!';
        body = 'Ready to get back to work?';
        break;
      case TimerPhase.longBreak:
        title = 'Long Break Complete!';
        body = 'You\'ve completed a full Pomodoro cycle!';
        break;
    }

    await NotificationService().showTimerNotification(
      title: title,
      body: body,
    );
  }

  void _notifyStateChange() {
    _stateController.add(TimerState(
      phase: _currentPhase,
      session: _currentSession,
      remainingSeconds: _remainingSeconds,
      isRunning: _isRunning,
      isPaused: _isPaused,
      settings: _settings,
    ));
  }

  void dispose() {
    _timer?.cancel();
    _stateController.close();
  }
}

class TimerState {
  final TimerPhase phase;
  final int session;
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;
  final TimerSettings settings;

  TimerState({
    required this.phase,
    required this.session,
    required this.remainingSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.settings,
  });

  Duration get remainingDuration => Duration(seconds: remainingSeconds);
  
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get phaseName {
    switch (phase) {
      case TimerPhase.work:
        return 'Work';
      case TimerPhase.shortBreak:
        return 'Short Break';
      case TimerPhase.longBreak:
        return 'Long Break';
    }
  }
} 