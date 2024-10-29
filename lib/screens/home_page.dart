import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _lyric = 'Loading...'; // Initial loading state
  String _artist = ''; // Variable to hold artist name
  bool _showArtist = false; // Flag to control artist visibility
  final List<Map<String, String>> _trends = []; // List to hold trends data

  @override
  void initState() {
    super.initState();
    _loadLyrics();
    _loadTrends(); // Load trends data on initialization
  }

  Future<void> _loadLyrics() async {
    // Load the lyrics from the text file
    String lyrics = await rootBundle.loadString('assets/lyrics.txt');
    List<String> lyricList = lyrics.split('\n'); // Split by new line
    int seed = DateTime.now().day; // Use current day as seed
    Random random = Random(seed);
    String selectedLyric = lyricList[random.nextInt(lyricList.length)].trim();
    List<String> parts = selectedLyric.split(' - ');
    setState(() {
      _lyric = parts[0]; // The lyric
      _artist = parts.length > 1 ? parts[1] : ''; // The artist (if available)
    });
  }

  Future<void> _loadTrends() async {
    // Load trends from the text file
    String trendsData = await rootBundle.loadString('assets/trends.txt');
    List<String> lines = trendsData.split('\n'); // Split by new line
    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        List<String> parts = line.split('|'); // Split by pipe
        if (parts.length == 3) {
          _trends.add({
            'title': parts[0],
            'description': parts[1],
            'imageName': parts[2],
          });
        }
      }
    }
    setState(() {}); // Trigger a rebuild after loading trends
  }

  void _revealArtist() {
    setState(() {
      _showArtist = true; // Set the flag to true to show the artist
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Padding on all sides
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Padding at the top of the lyric text
            child: Text(
              _lyric,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Row to contain the button or artist text
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align the content to the right
            children: [
              SizedBox(
                width: 150, // Fixed width to prevent layout shifts
                height: 30, // Fixed height for consistency between button and text
                child: _showArtist
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _artist,
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.right,
                        ),
                      )
                    : TextButton(
                        onPressed: _revealArtist,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove padding
                          minimumSize: const Size(0, 0), // Override minimum size to align with text height
                          alignment: Alignment.centerRight,
                          foregroundColor: const Color(0xFF6D28D9), // Set text color to Electric Purple
                        ),
                        child: const Text(
                          'Reveal Artist',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.right,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Align "Current Music Trends" to the left
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Current Music Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10), // Space between trends title and list
          Expanded(
            child: SingleChildScrollView( // Make this part scrollable
              child: Column(
                children: _trends.map((trend) {
                  return TrendCard(
                    title: trend['title'] ?? 'Untitled',
                    imageUrl: 'assets/images/trends/${trend['imageName']}', // Use the image path
                    description: trend['description'] ?? 'No description available.',
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;

  const TrendCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  _TrendCardState createState() => _TrendCardState();
}

class _TrendCardState extends State<TrendCard> {
  bool _isExpanded = false; // State to manage the expanded/collapsed state

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make the box full width
      margin: const EdgeInsets.symmetric(vertical: 5.0), // Space between cards
      padding: const EdgeInsets.all(8.0), // Padding inside the card
      decoration: BoxDecoration(
        color: Color(0xFFE5E7EB), // Set background color to Light Gray
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          // Image at the top
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.cover, // Ensure the image covers the container
              height: 180, // Set a fixed height for the image
              width: double.infinity, // Ensures the image fills the width of the card
            ),
          ),
          const SizedBox(height: 8.0), // Space between image and text
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0), // Space between header and description
          // Display only two lines initially
          Text(
            widget.description,
            maxLines: _isExpanded ? null : 2, // Show full text if expanded
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis, // Ellipsis when not expanded
          ),
          // Toggle button for expanding/collapsing the card
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle the expanded state
              });
            },
            child: Text(_isExpanded ? 'Read less' : 'Read more'), // Change text based on state
          ),
        ],
      ),
    );
  }
}
