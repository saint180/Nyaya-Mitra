import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = '';
  int _rating = 0;
  String _selectedEmoji = '';

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'feedback': _feedback,
          'rating': _rating,
          'emoji': _selectedEmoji,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thank you for your feedback!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _rating = 0;
          _selectedEmoji = '';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback. Please try again.')),
        );
      }
    }
  }

  Widget _buildEmojiButton(String emoji, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedEmoji == emoji ? Colors.purple : Colors.grey[200],
        backgroundColor: _selectedEmoji == emoji ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedEmoji = emoji;
        });
      },
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate your experience',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEmojiButton('😞', 'Bad'),
                  _buildEmojiButton('🙂', 'Decent'),
                  _buildEmojiButton('😍', 'Love it!'),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'How likely are you to recommend our app?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _rating.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: _rating.toString(),
                onChanged: (double value) {
                  setState(() {
                    _rating = value.round();
                  });
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tell us more...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some feedback';
                  }
                  return null;
                },
                onSaved: (value) {
                  _feedback = value!;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  child: Text('Submit Feedback'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}