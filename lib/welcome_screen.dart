import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _volumeDownPressCount = 0;
  Timer? _timer;
  final String _targetPhoneNumber = '6361688905';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RawKeyboardListener(
          onKey: _onKeyPressed,
          focusNode: FocusNode(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'or',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  icon: const Icon(Icons.facebook),
                  label: const Text('Continue with Facebook'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  icon: const Icon(Icons.filter),
                  label: const Text('Continue with Google'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  icon: const Icon(Icons.apple),
                  label: const Text('Continue with Apple'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onKeyPressed(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.volumeDown)) {
      _onVolumeDownPress();
    }
  }

  void _onVolumeDownPress() {
    setState(() {
      _volumeDownPressCount++;
    });

    if (_volumeDownPressCount == 1) {
      _timer = Timer(const Duration(seconds: 1), () {
        setState(() {
          _volumeDownPressCount = 0;
        });
      });
    }

    if (_volumeDownPressCount >= 5) {
      _showCallConfirmationDialog();
      _resetVolumeDownCounter();
    }
  }

  void _showCallConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Call'),
        content: Text('Do you want to call $_targetPhoneNumber?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _makeCall,
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:$_targetPhoneNumber');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $_targetPhoneNumber';
    }
  }

  void _resetVolumeDownCounter() {
    setState(() {
      _volumeDownPressCount = 0;
    });
    _timer?.cancel();
  }
}