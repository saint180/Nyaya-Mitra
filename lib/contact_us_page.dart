import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We\'d love to hear from you. Here\'s how you can reach us:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('support@legalapp.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+1 (555) 123-4567'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Address'),
              subtitle: Text('123 Legal Street, Lawville, LW 12345'),
            ),
          ],
        ),
      ),
    );
  }
}