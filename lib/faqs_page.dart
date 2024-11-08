import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What types of legal information does this app provide?',
      'answer': 'Our app covers a wide range of legal topics including criminal law, civil law, family law, and more. We provide brief explanations and general information about various legal concepts and processes.'
    },
    {
      'question': 'How can I connect with a pro bono lawyer?',
      'answer': 'You can browse our list of pro bono lawyers in the "Lawyers" section of the app. Each lawyer\'s profile includes their areas of expertise and contact information.'
    },
    {
      'question': 'Is the legal information in this app up-to-date?',
      'answer': 'We strive to keep our information as current as possible. However, laws can change frequently. Always consult with a qualified legal professional for the most up-to-date and accurate legal advice.'
    },
    {
      'question': 'Can I use this app to file legal documents?',
      'answer': 'No, this app is for informational purposes only. It does not provide tools for filing legal documents. For official legal processes, please consult with a lawyer or visit your local court\'s website.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqs[index]['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}