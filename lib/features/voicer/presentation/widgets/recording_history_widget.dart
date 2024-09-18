import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/voicer/models/recording_model.dart';


class RecordingHistoryWidget extends StatelessWidget {
  final List<RecordingModel> recordings;

  const RecordingHistoryWidget({Key? key, required this.recordings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text('Recording History'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final recording = recordings[index];
              return CupertinoListTile(
                title: Text('Recording ${index + 1}'),
                subtitle: Text('Duration: ${_formatDuration(recording.durationInSeconds)}'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.play_circle),
                  onPressed: () {
                    // TODO: Implement playback functionality
                  },
                ),
              );
            },
            childCount: recordings.length,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}