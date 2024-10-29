import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final Function(String) onLogin;

  const UserPage({super.key, required this.onLogin});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _shake() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _attemptLogin() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _showError = true;
      });
      _shake();
    } else {
      setState(() {
        _showError = false;
      });
      widget.onLogin(_usernameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_showError ? _animation.value : 0, 0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              );
            },
          ),
          // Fixed-size space for error message
          SizedBox(
            height: 20,
            child: _showError && _usernameController.text.isEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Username is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(), // Empty placeholder when no error
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_showError ? _animation.value : 0, 0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              );
            },
          ),
          // Fixed-size space for error message
          SizedBox(
            height: 20,
            child: _showError && _passwordController.text.isEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Password is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(), // Empty placeholder when no error
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Forgot password functionality here
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: _attemptLogin,
                child: const Text('Login'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New around here? ',
                style: TextStyle(color: Colors.black),
              ),
              TextButton(
                onPressed: () {
                  // Create new profile functionality here
                },
                child: const Text(
                  'Create new profile',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
