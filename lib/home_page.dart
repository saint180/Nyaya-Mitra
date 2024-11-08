import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_page.dart';
import 'profile_page.dart';
import 'laws_page.dart';
import 'lawyers_page.dart';
import 'contact_us_page.dart';
import 'about_us_page.dart';
import 'feedback_page.dart';
import 'faqs_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      _userName = userDoc['fullName'] ?? "User";
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1: // News
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsPage()),
        );
        break;
      case 2: // Laws
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LawsPage()),
        );
        break;
      case 3: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: _currentUser.photoURL != null
                  ? NetworkImage(_currentUser.photoURL!)
                  : AssetImage('assets/default_profile.jpg') as ImageProvider,
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(
              _userName,
              style: TextStyle(color: _isDarkMode ? Colors.black : Colors.white),
            ),
          ],
        ),
        backgroundColor: _isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.black : Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: _isDarkMode ? Colors.black : Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'contact_us':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsPage()));
                  break;
                case 'about_us':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
                  break;
                case 'feedback':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
                  break;
                case 'faqs':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FAQsPage()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'contact_us',
                child: Text('Contact Us'),
              ),
              PopupMenuItem<String>(
                value: 'about_us',
                child: Text('About Us'),
              ),
              PopupMenuItem<String>(
                value: 'feedback',
                child: Text('Feedback'),
              ),
              PopupMenuItem<String>(
                value: 'faqs',
                child: Text('FAQs'),
              ),
            ],
          ),
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeColor: Colors.black,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: _isDarkMode ? Colors.black : Colors.white,
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: _isDarkMode ? Colors.black : Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.newspaper, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('News', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.gavel, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Laws', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LawsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Probono Lawyers', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LawyersPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Settings', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Account', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Logout', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                  // Navigate to login page or handle logout
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Top Stories',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black
                    )
                ),
                SizedBox(height: 20),
                NewsCard(
                    title: 'Famous snowboarder wins Grand Prix',
                    imageUrl: 'assets/snowboarder.jpg',
                    source: 'Sports News',
                    time: '2 hours ago',
                    isDarkMode: _isDarkMode
                ),
                SizedBox(height: 20),
                NewsCard(
                    title: 'French Cycling Tour is postponed',
                    imageUrl: 'assets/cycling.png',
                    source: 'Cycling Weekly',
                    time: '3 hours ago',
                    isDarkMode: _isDarkMode
                ),
                SizedBox(height: 20),
                Text(
                    'Latest Laws',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black
                    )
                ),
                SizedBox(height: 20),
                LawCard(
                    title: 'New Environmental Protection Act',
                    category: 'Environmental Law',
                    date: 'May 15, 2024',
                    isDarkMode: _isDarkMode
                ),
                SizedBox(height: 20),
                LawCard(
                    title: 'Digital Privacy Rights Act',
                    category: 'Cyber Law',
                    date: 'June 1, 2024',
                    isDarkMode: _isDarkMode
                ),
                SizedBox(height: 20),
                Text(
                    'Categories',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black
                    )
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    CategoryChip(label: 'Politics', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Technology', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Sports', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Health', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Environmental', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Criminal', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Civil', isDarkMode: _isDarkMode),
                    CategoryChip(label: 'Corporate', isDarkMode: _isDarkMode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Laws',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor: _isDarkMode ? Colors.grey : Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String source;
  final String time;
  final bool isDarkMode;

  NewsCard({
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.time,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    source,
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)
                ),
                Text(
                    time,
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LawCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final bool isDarkMode;

  LawCard({
    required this.title,
    required this.category,
    required this.date,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black
          ),
        ),
        subtitle: Text(
            '$category - $date',
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isDarkMode;

  CategoryChip({
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
          label,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)
      ),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
    );
  }
}