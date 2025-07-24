import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_settings.dart';
import '../providers/app_provider.dart';
import '../services/timer_service.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Check if app is initialized
        if (!appProvider.isInitialized) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Loading timer...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        return StreamBuilder(
          stream: appProvider.timerStateStream,
          builder: (context, snapshot) {
            // Always show timer UI, even if no data yet
            TimerState timerState;
            
            if (snapshot.hasError) {
              print('Timer stream error: ${snapshot.error}');
              timerState = _createFallbackTimerState();
            } else if (snapshot.hasData) {
              timerState = snapshot.data!;
            } else {
              // Create a default timer state while waiting for data
              timerState = _createFallbackTimerState();
            }
            final isRunning = timerState.isRunning;
            final isPaused = timerState.isPaused;
            final currentPhase = timerState.phase;
            final remainingTime = timerState.remainingDuration;
            final totalTime = _getTotalTimeForPhase(currentPhase, timerState.settings);
            final progress = totalTime.inSeconds > 0 
                ? (totalTime.inSeconds - remainingTime.inSeconds) / totalTime.inSeconds 
                : 0.0;

            print('Timer State - Running: $isRunning, Paused: $isPaused, Phase: $currentPhase, Remaining: ${remainingTime.inSeconds}s, Progress: ${(progress * 100).toStringAsFixed(1)}%');

            return _buildTimerUI(timerState);
          },
        );
      },
    );
  }

  Widget _buildTimerUI(TimerState timerState) {
    final isRunning = timerState.isRunning;
    final isPaused = timerState.isPaused;
    final currentPhase = timerState.phase;
    final remainingTime = timerState.remainingDuration;
    final totalTime = _getTotalTimeForPhase(currentPhase, timerState.settings);
    final progress = totalTime.inSeconds > 0 
        ? (totalTime.inSeconds - remainingTime.inSeconds) / totalTime.inSeconds 
        : 0.0;

    return Column(
      children: [
        // Timer Display
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  // Progress Circle
                                            Center(
                            child: SizedBox(
                              width: 220,
                              height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getPhaseColor(currentPhase),
                        ),
                      ),
                    ),
                  ),
                  
                  // Timer Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Phase Label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getPhaseColor(currentPhase).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getPhaseLabel(currentPhase),
                            style: TextStyle(
                              color: _getPhaseColor(currentPhase),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                                                        const SizedBox(height: 12),
                                
                                // Time Display
                                Text(
                                  _formatTime(remainingTime),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                
                                const SizedBox(height: 6),
                                
                                // Session Info
                                Text(
                                  'Session ${timerState.session}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Controls
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Main Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Skip Button
                  _buildControlButton(
                    icon: Icons.skip_next,
                    label: 'Skip',
                    color: Colors.orange,
                    onPressed: () {
                      print('Skip button pressed');
                      Provider.of<AppProvider>(context, listen: false).skipTimer();
                    },
                  ),
                  
                  // Main Control Button
                  _buildMainControlButton(
                    isRunning: isRunning,
                    isPaused: isPaused,
                    onPressed: () {
                      print('Main control button pressed - Running: $isRunning, Paused: $isPaused');
                      final appProvider = Provider.of<AppProvider>(context, listen: false);
                      if (!isRunning && !isPaused) {
                        print('Starting timer');
                        appProvider.startTimer();
                      } else if (isPaused) {
                        print('Resuming timer');
                        appProvider.resumeTimer();
                      } else {
                        print('Pausing timer');
                        appProvider.pauseTimer();
                      }
                    },
                  ),
                  
                  // Stop Button
                  _buildControlButton(
                    icon: Icons.stop,
                    label: 'Stop',
                    color: Colors.red,
                    onPressed: () {
                      print('Stop button pressed');
                      Provider.of<AppProvider>(context, listen: false).stopTimer();
                    },
                  ),
                ],
              ),
              
              // Settings Button
              ElevatedButton.icon(
                onPressed: () => _showTimerSettings(context),
                icon: const Icon(Icons.settings, size: 18),
                label: const Text('Timer Settings', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TimerState _createFallbackTimerState() {
    return TimerState(
      phase: TimerPhase.work,
      session: 1,
      remainingSeconds: 25 * 60, // 25 minutes default
      isRunning: false,
      isPaused: false,
      settings: TimerSettings(),
    );
  }

  Widget _buildMainControlButton({
    required bool isRunning,
    required bool isPaused,
    required VoidCallback onPressed,
  }) {
    IconData icon;
    Color color;
    String label;

    if (!isRunning && !isPaused) {
      icon = Icons.play_arrow;
      color = Colors.green;
      label = 'Start';
    } else if (isPaused) {
      icon = Icons.play_arrow;
      color = Colors.green;
      label = 'Resume';
    } else {
      icon = Icons.pause;
      color = Colors.orange;
      label = 'Pause';
    }

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
            ),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Duration _getTotalTimeForPhase(TimerPhase phase, TimerSettings settings) {
    switch (phase) {
      case TimerPhase.work:
        return Duration(minutes: settings.workDuration);
      case TimerPhase.shortBreak:
        return Duration(minutes: settings.breakDuration);
      case TimerPhase.longBreak:
        return Duration(minutes: settings.longBreakDuration);
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _getPhaseLabel(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.work:
        return 'FOCUS';
      case TimerPhase.shortBreak:
        return 'BREAK';
      case TimerPhase.longBreak:
        return 'LONG BREAK';
    }
  }

  Color _getPhaseColor(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.work:
        return Colors.red.shade400;
      case TimerPhase.shortBreak:
        return Colors.green.shade400;
      case TimerPhase.longBreak:
        return Colors.blue.shade400;
    }
  }

  void _showTimerSettings(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _TimerSettingsSheet(
        currentSettings: appProvider.timerSettings,
        onSettingsChanged: (settings) {
          appProvider.updateTimerSettings(settings);
        },
      ),
    );
  }
}

class _TimerSettingsSheet extends StatefulWidget {
  final TimerSettings currentSettings;
  final Function(TimerSettings) onSettingsChanged;

  const _TimerSettingsSheet({
    required this.currentSettings,
    required this.onSettingsChanged,
  });

  @override
  State<_TimerSettingsSheet> createState() => _TimerSettingsSheetState();
}

class _TimerSettingsSheetState extends State<_TimerSettingsSheet> {
  late int workDuration;
  late int breakDuration;
  late int longBreakDuration;
  late int sessionsBeforeLongBreak;

  @override
  void initState() {
    super.initState();
    workDuration = widget.currentSettings.workDuration;
    breakDuration = widget.currentSettings.breakDuration;
    longBreakDuration = widget.currentSettings.longBreakDuration;
    sessionsBeforeLongBreak = widget.currentSettings.sessionsBeforeLongBreak;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Timer Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Work Duration
            _buildSettingItem(
              label: 'Work Duration',
              value: workDuration,
              onChanged: (value) {
                setState(() {
                  workDuration = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Break Duration
            _buildSettingItem(
              label: 'Break Duration',
              value: breakDuration,
              onChanged: (value) {
                setState(() {
                  breakDuration = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Long Break Duration
            _buildSettingItem(
              label: 'Long Break Duration',
              value: longBreakDuration,
              onChanged: (value) {
                setState(() {
                  longBreakDuration = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Sessions Before Long Break
            _buildSettingItem(
              label: 'Sessions Before Long Break',
              value: sessionsBeforeLongBreak,
              onChanged: (value) {
                setState(() {
                  sessionsBeforeLongBreak = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newSettings = TimerSettings(
                    workDuration: workDuration,
                    breakDuration: breakDuration,
                    longBreakDuration: longBreakDuration,
                    sessionsBeforeLongBreak: sessionsBeforeLongBreak,
                  );
                  widget.onSettingsChanged(newSettings);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (value > 1) {
                  onChanged(value - 1);
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.indigo,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '$value min',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                onChanged(value + 1);
              },
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.indigo,
            ),
          ],
        ),
      ],
    );
  }
} 