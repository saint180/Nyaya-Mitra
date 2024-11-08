import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We are dedicated to making legal information accessible to everyone. Our app provides easy-to-understand explanations of various laws and connects users with pro bono lawyers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Our Team',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Our team consists of legal experts, tech enthusiasts, and passionate individuals committed to bridging the gap between complex legal systems and everyday people.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}