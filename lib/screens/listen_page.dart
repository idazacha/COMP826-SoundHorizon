import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:async';
import 'results_page.dart'; // Import the new results widget

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late RecorderController _controller;
  bool _isRecording = false;
  Timer? _timer;
  int _recordingDuration = 0;
  bool _showDuration = false;
  bool _isLoading = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _controller = RecorderController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _controller.stop();
      print('Recorded file path: $path');
      _timer?.cancel();

      setState(() {
        _isLoading = true;
        _isRecording = false;
        _showDuration = false;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _showResults = true;
      });
    } else {
      final hasPermission = await _controller.checkPermission(); // Get permission to use microphone
      if (hasPermission) {
        await _controller.record(path: 'path_to_save_audio');
        _startTimer();
        setState(() {
          _showDuration = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied!')),
        );
      }
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _startTimer() {
    _recordingDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _showResults
            ? RecordResults(
                onRecordAgain: () {
                  setState(() {
                    _showResults = false;
                    _recordingDuration = 0;
                    _isRecording = false;
                  });
                },
              )
            : _buildRecordingInterface(),
      ),
    );
  }

  Widget _buildRecordingInterface() {
    return _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Processing... Please wait.'),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusted to use space between
            children: [
              AudioWaveforms(
                size: Size(MediaQuery.of(context).size.width, 200.0),
                recorderController: _controller,
                enableGesture: true,
                waveStyle: WaveStyle(
                  showDurationLabel: false,
                  spacing: 8.0,
                  showBottom: false,
                  extendWaveform: true,
                  showMiddleLine: false,
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 48, 234),
                      const Color.fromARGB(255, 0, 38, 255)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(Rect.fromLTRB(
                      0, 0, MediaQuery.of(context).size.width, 200)),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  const SizedBox(height: 40),
                  if (_showDuration)
                    Text(
                      'Duration: ${_formatDuration(_recordingDuration)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Place the record button here
              ElevatedButton(
                onPressed: _toggleRecording,
                child: Text(
                    _isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
              const SizedBox(height: 40), // Space before the buttons
            ],
          );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
