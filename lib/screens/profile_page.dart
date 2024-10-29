import 'dart:math';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showHistoryDetail = false;
  String? _selectedHistoryItem;

// Simulated history data with dates
  final List<Map<String, String>> _history = [
    {'date': '2024-10-01', 'time': '10:30 AM', 'genre': 'Jazz'},
    {'date': '2024-10-02', 'time': '11:00 AM', 'genre': 'Rock'},
    {'date': '2024-10-03', 'time': '12:15 PM', 'genre': 'Classical'},
    {'date': '2024-10-04', 'time': '1:00 PM', 'genre': 'Pop'},
    {'date': '2024-10-05', 'time': '2:30 PM', 'genre': 'Hip-Hop'},
    {'date': '2024-10-06', 'time': '3:15 PM', 'genre': 'Reggae'},
    {'date': '2024-10-07', 'time': '4:00 PM', 'genre': 'Blues'},
    {'date': '2024-10-08', 'time': '5:45 PM', 'genre': 'Metal'},
    {'date': '2024-10-09', 'time': '6:30 PM', 'genre': 'Electronic'},
    {'date': '2024-10-10', 'time': '7:00 PM', 'genre': 'Country'},
    {'date': '2024-10-11', 'time': '8:00 PM', 'genre': 'Folk'},
  ];

  // Simulated song features for statistics
  final List<Map<String, double>> _songFeatures = [
    {'Bass': 70.0, 'Treble': 55.0, 'Pitch': 80.0, 'Tempo': 120.0, 'Volume': 75.0},
    {'Bass': 65.0, 'Treble': 60.0, 'Pitch': 78.0, 'Tempo': 130.0, 'Volume': 80.0},
    {'Bass': 80.0, 'Treble': 70.0, 'Pitch': 85.0, 'Tempo': 140.0, 'Volume': 90.0},
  ];

  // Show selected history item details
  void _showHistoryDetails(String historyItem) {
    setState(() {
      _showHistoryDetail = true;
      _selectedHistoryItem = historyItem;
    });
  }

  // Back to profile's main content
  void _showMainProfileContent() {
    setState(() {
      _showHistoryDetail = false;
      _selectedHistoryItem = null;
    });
  }

  // Calculate statistics
  String _mostAssignedGenre() {
    final genreCount = <String, int>{};

    for (var entry in _history) {
      final genre = entry['genre']!;
      genreCount[genre] = (genreCount[genre] ?? 0) + 1;
    }

    return genreCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _averageFeature(String feature) {
    double total = 0.0;
    for (var song in _songFeatures) {
      total += song[feature] ?? 0;
    }
    return total / _songFeatures.length;
  }

  String _mostProminentFeature() {
    final featureCount = <String, int>{};

    for (var song in _songFeatures) {
      for (var feature in song.keys) {
        featureCount[feature] = (featureCount[feature] ?? 0) + 1;
      }
    }

    return featureCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // Placeholder soundwave widget
  Widget _buildSoundwavePlaceholder() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text('Soundwave Placeholder', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  // Placeholder images for song suggestions
  List<Widget> _buildSongSuggestionImages() {
    return List<Widget>.generate(10, (index) {
      return Container(
        width: 80, height: 80, // width and height for small song recommendation images
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/song_placeholder.png'), // placeholder image, make more dynamic
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Removes background color
        elevation: 0, // Removes shadow
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'), // Placeholder image
              radius: 20,
            ),
            const SizedBox(width: 8), // Padding between icon and text
            Text('${widget.username}\'s corner'), // e.g. "Ida's corner" if username is Ida
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: _showHistoryDetail ? _buildHistoryDetail() : _buildProfileContent(),
          ),
        ],
      ),
    );
  }

  // Main profile content with statistics and history list
  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Music Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 140, // Set a fixed height for the Music Statistics section
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Genre: ${_mostAssignedGenre()}', style: TextStyle(height: 2)
              ),
              Text(
                'Average Tempo: ${_averageFeature('Tempo').toStringAsFixed(1)}', style: TextStyle(height: 2)
              ),
              Text(
                'Average Volume: ${_averageFeature('Volume').toStringAsFixed(1)}', style: TextStyle(height: 2)
              ),
              Text(
                'Most Important Feature: ${_mostProminentFeature()}', style: TextStyle(height: 2)
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Recording History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling of ListView
              shrinkWrap: true, // Shrink ListView to fit within ScrollView
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(0.0), // Padding inside the item
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light gray background
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: ListTile(
                    title: Text('${item['genre']}'),
                    subtitle: Text('${item['time']}'),
                    onTap: () => _showHistoryDetails('${item['genre']} at ${item['time']}'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // History item detail view with soundwave, features, and song suggestions
  Widget _buildHistoryDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _showMainProfileContent,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedHistoryItem ?? 'History Detail',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildSoundwavePlaceholder(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sound Features',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var feature in _generateRandomSoundFeatures())
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(feature, style: const TextStyle(fontSize: 16)),
                ),
              const SizedBox(height: 16),
              const Text(
                'Song Suggestions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildSongSuggestionImages(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Generate random sound features
  List<String> _generateRandomSoundFeatures() {
    final random = Random();
    return List<String>.generate(5, (index) {
      final featureNames = ['Bass', 'Treble', 'Pitch', 'Tempo', 'Volume'];
      final featureName = featureNames[random.nextInt(featureNames.length)];
      final featureValue = random.nextDouble() * 100;
      return '$featureName: ${featureValue.toStringAsFixed(1)}';
    });
  }
}
