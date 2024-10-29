// importing packages
import 'package:flutter/material.dart';

// importing screens
import 'screens/home_page.dart';
import 'screens/listen_page.dart';
import 'screens/user_page.dart';
import 'screens/profile_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Horizon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // background color
      ),
      home: const MyHomePage(), // set initial home page
    );
  }
}

// initial home page / main screen w. navigation
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _loggedIn = false;
  String _username = '';

  // Method to handle login action from UserPage
  void _handleLogin(String username) {
    setState(() {
      _loggedIn = true;
      _username = username;
      _selectedIndex = 2; // Navigate to ProfilePage after login
    });
  }

  // Method to handle logout action from ProfilePage
  void _handleLogout() {
    setState(() {
      _loggedIn = false;
      _username = '';
      _selectedIndex = 2; // Navigate back to UserPage after logout
    });
  }

  // Define the pages with login state and navigation management
  List<Widget> _pages() => [
        const LandingPage(),
        RecordPage(),
        _loggedIn
            ? ProfilePage(username: _username, onLogout: _handleLogout)
            : UserPage(onLogin: _handleLogin),
      ];

  // bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min, // min size for the row
        children: [
          Image.asset(
            'assets/images/logo2.png',
            height: 45, // height of logo
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8), // adding some space between logo and text
          const Text(
            'Sound Horizon',
            style: TextStyle(
              color: Color(0xFF1E3A8A), // Primary color for text color
            ),
          ),
        ],
      ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        actions: _loggedIn
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _handleLogout, // Log out action
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            child: _pages()[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar( // Bottom menu bar
        backgroundColor: const Color(0xFF1E3A8A),
        selectedItemColor: const Color(0xFFF472B6),
        unselectedItemColor: const Color(0xFFE5E7EB),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2 && _loggedIn) {
            setState(() => _selectedIndex = 2); // Stay on ProfilePage
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}
