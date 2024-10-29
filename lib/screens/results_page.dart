import 'package:flutter/material.dart';
import 'dart:math';

class RecordResults extends StatelessWidget {
  final VoidCallback onRecordAgain;

  const RecordResults({
    Key? key,
    required this.onRecordAgain,
  }) : super(key: key);

  // Generate random song features
  List<String> _generateRandomSoundFeatures() {
    final features = ['Bass', 'Treble', 'Pitch', 'Tempo', 'Volume'];
    return List<String>.generate(5, (index) {
      final value = (Random().nextDouble() * 100).toStringAsFixed(1);
      return '${features[index]}: $value';
    });
  }

  String _generateGenre() {
    // Generate a random genre
    final genres = ['Blues', 'Classic rock', 'Country', 'Dance', 'Disco', 'Pop', 'Rock', 'Jazz', 'Classical', 'Electronic'];
    return genres[Random().nextInt(genres.length)];
  }

  // Placeholder images for song suggestions
  List<Widget> _buildSongSuggestionImages() {
    return List<Widget>.generate(10, (index) {
      return Container(
        width: 90, // Set width for small images
        height: 90, // Set height for small images
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/song_placeholder.png'), // Placeholder image
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final genre = _generateGenre();
    final songFeatures = _generateRandomSoundFeatures();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Predicted Genre: $genre',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        for (var feature in songFeatures)
          Text(
            feature,
            style: const TextStyle(fontSize: 18),
          ),
        const SizedBox(height: 40),
        // Recommended songs section
        const Text(
          'Recommended Songs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildSongSuggestionImages(),
          ),
        ),
        const SizedBox(height: 100),
        ElevatedButton(
          onPressed: onRecordAgain,
          child: const Text('Record Again'),
        ),
      ],
    );
  }
}
