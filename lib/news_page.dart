import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => _isLoading = true);
    try {
      // Replace 'YOUR_API_KEY' with a valid API key
      final response = await http.get(Uri.parse('https://newsdata.io/api/1/latest?apikey=YOUR_API_KEY&category=legal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _news = data['results'];  // Changed from 'articles' to 'results'
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest News'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _news.isEmpty
          ? Center(child: Text('No news available.'))
          : ListView.builder(
        itemCount: _news.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: _news[index]['urlToImage'] != null
                  ? Image.network(
                _news[index]['urlToImage'],
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              )
                  : Icon(Icons.article),
              title: Text(_news[index]['title']),
              subtitle: Text(_news[index]['description'] ?? ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(article: _news[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  NewsDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              Image.network(
                article['urlToImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    article['description'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    article['content'] ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Source: ${article['source']['name'] ?? 'Unknown'}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Published: ${article['publishedAt'] ?? 'Unknown'}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}