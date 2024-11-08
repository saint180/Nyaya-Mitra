import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LawyersPage extends StatelessWidget {
  final List<Map<String, String>> lawyers = [
    {'name': 'Sachin K', 'phone': '+1234567890', 'email': 'john.doe@example.com'},
    {'name': 'Sachin Yadav', 'phone': '+1987654321', 'email': 'jane.smith@example.com'},
    {'name': 'Surya Vamshi', 'phone': '+1122334455', 'email': 'bob.johnson@example.com'},
    {'name': 'Hema C', 'phone': '+1555666777', 'email': 'alice.williams@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pro Bono Lawyers'),
      ),
      body: ListView.builder(
        itemCount: lawyers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(lawyers[index]['name']![0]),
              ),
              title: Text(lawyers[index]['name']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () => _launchUrl('tel:${lawyers[index]['phone']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () => _launchUrl('mailto:${lawyers[index]['email']}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}