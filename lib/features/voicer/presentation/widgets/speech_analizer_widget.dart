import 'package:flutter/cupertino.dart'; // Ensure this import is present
import 'package:flutter/material.dart'; // Ensure this import is present

class SpeechAnalyzerWidget extends StatelessWidget {
  const SpeechAnalyzerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text('Speech Analysis'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speech Rate',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.7), // Changed to LinearProgressIndicator
                SizedBox(height: 16),
                Text(
                  'Pronunciation Accuracy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.85), // Changed to LinearProgressIndicator
                SizedBox(height: 16),
                Text(
                  'Vocabulary Usage',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.6), // Changed to LinearProgressIndicator
                // Add more analysis metrics as needed
              ],
            ),
          ),
        ),
      ],
    );
  }
}