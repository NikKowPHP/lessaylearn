import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';

import 'package:lessay_learn/core/providers/language_service_provider.dart';

import 'package:lessay_learn/features/voicer/models/recording_model.dart';
import 'package:lessay_learn/features/voicer/presentation/widgets/recording_history_widget.dart';
import 'package:lessay_learn/features/voicer/presentation/widgets/speech_analizer_widget.dart';

import 'package:lessay_learn/features/voicer/providers/recording_provider.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  String? selectedLanguageId;
  bool isRecording = false;
  Duration recordingDuration = Duration.zero;
  bool isPaused = false; // New variable to track pause state

  @override
  Widget build(BuildContext context) {
    final languagesAsync = ref.watch(allLanguagesProvider);
    final recordingsAsync = ref.watch(userRecordingsProvider('currentUserId')); // Replace with actual user ID

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Voice Recorder'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildLanguageSelector(languagesAsync),
            Expanded(
              child: CupertinoTabScaffold(
                tabBar: CupertinoTabBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.mic),
                      label: 'Record',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.list_bullet),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.graph_circle),
                      label: 'Analyze',
                    ),
                  ],
                ),
                tabBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildRecorderTab();
                    case 1:
                      return _buildHistoryTab(recordingsAsync);
                    case 2:
                      return _buildAnalyzerTab();
                    default:
                      return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(AsyncValue<List<LanguageModel>> languagesAsync) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: languagesAsync.when(
        data: (languages) => CupertinoSlidingSegmentedControl<String>(
          groupValue: selectedLanguageId,
          children: {
            for (var lang in languages)
              lang.id: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(lang.shortcut),
              )
          },
          onValueChanged: (value) {
            setState(() {
              selectedLanguageId = value;
            });
          },
        ),
        loading: () => CupertinoActivityIndicator(),
        error: (_, __) => Text('Failed to load languages'),
      ),
    );
  }

  Widget _buildRecorderTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(recordingDuration),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row( // Changed to Row to accommodate multiple buttons
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: isPaused ? _continueRecording : _toggleRecording,
                child: Icon(
                  isPaused ? CupertinoIcons.play_circle : CupertinoIcons.mic,
                  size: 64,
                  color: isPaused ? CupertinoColors.activeBlue : (isRecording ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue),
                ),
              ),
              SizedBox(width: 20), // Space between buttons
              if (isRecording) // Show stop button only when recording
                CupertinoButton(
                  onPressed: _stopRecording, // Disable if not recording
                  child: Icon(
                    CupertinoIcons.stop_circle,
                    size: 64,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            isRecording ? (isPaused ? 'Tap to continue' : 'Tap to stop') : 'Tap to start recording',
            style: TextStyle(color: CupertinoColors.inactiveGray),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(AsyncValue<List<RecordingModel>> recordingsAsync) {
    return recordingsAsync.when(
      data: (recordings) => RecordingHistoryWidget(recordings: recordings),
      loading: () => Center(child: CupertinoActivityIndicator()),
      error: (_, __) => Center(child: Text('Failed to load recordings')),
    );
  }

  Widget _buildAnalyzerTab() {
    return SpeechAnalyzerWidget();
  }

  void _toggleRecording() {
    setState(() {
      if (isPaused) {
        _continueRecording(); // Resume recording
      } else {
        isRecording = !isRecording; // Toggle recording state
        if (isRecording) {
          _startRecording(); // Start recording
        } else {
          _stopRecording(); // Stop recording
        }
      }
    });
  }

  void _continueRecording() {
    setState(() {
      isPaused = false; // Set paused state to false
      _updateRecordingDuration(); // Resume duration update
    });
  }

  void _startRecording() {
    // TODO: Implement actual recording logic
    if (!isRecording) { // Only reset duration if starting fresh
        recordingDuration = Duration.zero; // Reset duration when starting
    }
    isPaused = false; // Reset pause state when starting
    _updateRecordingDuration(); // Start updating duration
  }

  void _stopRecording() {
    // TODO: Implement actual recording stop logic and saving the recording
    isPaused = false; // Reset pause state when stopping
    isRecording = false; // Set recording state to false
  }

  void _updateRecordingDuration() {
    if (isRecording) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          recordingDuration += Duration(seconds: 1); // Increment duration
          _updateRecordingDuration(); // Continue updating
        });
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}