import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_page.dart'; // Import the EditProfilePage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      _userData = userDoc.data() as Map<String, dynamic>;
    });
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _userData['profilePictureUrl'] != null
                      ? NetworkImage(_userData['profilePictureUrl'])
                      : AssetImage('assets/default_profile.jpg') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 20,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: _editProfile,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _userData['fullName'] ?? 'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              _userData['email'] ?? 'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          ProfileOption(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: _editProfile,
          ),
          ProfileOption(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Implement change password functionality
            },
          ),
          ProfileOption(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () {
              // Navigate to notification settings page
            },
          ),
          ProfileOption(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              // Navigate to language settings page
            },
          ),
          ProfileOption(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help & support page
            },
          ),
          ProfileOption(
            icon: Icons.exit_to_app,
            title: 'Logout',
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set the background color to white
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
