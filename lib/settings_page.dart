import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkMode);
    prefs.setBool('notifications', _notifications);
    prefs.setString('language', _language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: _notifications,
            onChanged: (bool value) {
              setState(() {
                _notifications = value;
              });
              _saveSettings();
            },
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _language = newValue;
                  });
                  _saveSettings();
                }
              },
              items: <String>['English', 'Spanish', 'French', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Privacy Policy page
            },
          ),
          ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Terms of Service page
            },
          ),
          ListTile(
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to About page
            },
          ),
        ],
      ),
    );
  }
}