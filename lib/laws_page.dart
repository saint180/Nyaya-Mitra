import 'package:flutter/material.dart';

class LawsPage extends StatelessWidget {
  final List<Map<String, String>> lawTypes = [
    {
      'name': 'Criminal Law',
      'description': 'Deals with crimes and their punishments. It includes areas such as murder, assault, theft, and fraud.'
    },
    {
      'name': 'Civil Law',
      'description': 'Concerns disputes between individuals or organizations. It covers areas like contracts, property, and torts.'
    },
    {
      'name': 'Constitutional Law',
      'description': 'Interprets and applies a country\'s constitution. It deals with the fundamental principles by which a government exercises its authority.'
    },
    {
      'name': 'Administrative Law',
      'description': 'Governs the activities of administrative agencies of government. It includes areas like regulations, rulemaking, and adjudication.'
    },
    {
      'name': 'International Law',
      'description': 'Deals with the relationships between countries and regulates international organizations. It includes treaties, customs, and general principles of law recognized by civilized nations.'
    },
    {
      'name': 'Corporate Law',
      'description': 'Regulates the formation and operations of corporations. It includes areas like mergers and acquisitions, shareholders\' rights, and corporate governance.'
    },
    {
      'name': 'Environmental Law',
      'description': 'Regulates human impact on the natural environment. It covers areas like pollution control, resource conservation, and climate change.'
    },
    {
      'name': 'Intellectual Property Law',
      'description': 'Protects creations of the mind. It includes patents, trademarks, copyrights, and trade secrets.'
    },
    {
      'name': 'Family Law',
      'description': 'Deals with matters related to family relationships such as marriage, divorce, child custody, and adoption.'
    },
    {
      'name': 'Labor Law',
      'description': 'Governs the relationship between employers and employees. It includes issues such as employment rights, wages, and workplace safety.'
    },
    {
      'name': 'Tort Law',
      'description': 'Provides remedies to individuals harmed by the wrongful actions of others. It includes areas like personal injury and negligence.'
    },
    {
      'name': 'Contract Law',
      'description': 'Regulates legally binding agreements between parties. It covers the formation, execution, and enforcement of contracts.'
    },
    {
      'name': 'Commercial Law',
      'description': 'Governs the rights, relations, and conduct of persons and businesses engaged in commerce, trade, and sales.'
    },
    {
      'name': 'Bankruptcy Law',
      'description': 'Helps businesses or individuals who can no longer meet their financial obligations seek relief through liquidation or reorganization.'
    },
    {
      'name': 'Immigration Law',
      'description': 'Concerns the rules and regulations regarding foreign individuals entering, residing in, and being deported from a country.'
    },
    {
      'name': 'Real Estate Law',
      'description': 'Governs land and the buildings on it. It includes the buying, selling, and leasing of property.'
    },
    {
      'name': 'Tax Law',
      'description': 'Deals with the rules and regulations governing the collection of taxes by the government.'
    },
    {
      'name': 'Health Law',
      'description': 'Regulates the provision of healthcare services and the relationship between healthcare providers, patients, and insurers.'
    },
    {
      'name': 'Human Rights Law',
      'description': 'Protects the fundamental rights and freedoms to which all human beings are entitled. It includes areas like discrimination and freedom of expression.'
    },
    {
      'name': 'Education Law',
      'description': 'Deals with the rights, responsibilities, and duties within the educational system. It covers areas like student rights and teacher contracts.'
    },
    {
      'name': 'Cyber Law',
      'description': 'Regulates the use of the internet, computers, and digital platforms. It includes data privacy, cybersecurity, and intellectual property online.'
    },
    {
      'name': 'Entertainment Law',
      'description': 'Covers legal issues in the entertainment industry, such as contracts, intellectual property, and defamation.'
    },
    {
      'name': 'Sports Law',
      'description': 'Governs the conduct of sports professionals, contracts, and disputes in sports activities.'
    },
    {
      'name': 'Media Law',
      'description': 'Regulates the media industry, including defamation, freedom of speech, and broadcasting rights.'
    },
    {
      'name': 'Aviation Law',
      'description': 'Covers laws and regulations pertaining to air travel and the aviation industry, including aircraft operations and safety.'
    },
    {
      'name': 'Military Law',
      'description': 'Regulates the conduct of armed forces personnel and military institutions.'
    },
    {
      'name': 'Maritime Law',
      'description': 'Governs navigable waters and the relationships between private entities, such as shipowners and marine workers.'
    },
    {
      'name': 'Insurance Law',
      'description': 'Regulates the business of insurance, including policies, claims, and disputes between insurers and policyholders.'
    },
    {
      'name': 'Food and Drug Law',
      'description': 'Regulates the production and distribution of food, drugs, and cosmetics to ensure safety and efficacy.'
    },
    {
      'name': 'Animal Law',
      'description': 'Covers laws concerning the treatment of animals, including issues of animal welfare and rights.'
    },
    {
      'name': 'Elder Law',
      'description': 'Focuses on legal issues affecting the elderly, such as retirement, healthcare, and estate planning.'
    },
    {
      'name': 'Banking Law',
      'description': 'Regulates banks and financial institutions, covering areas like loans, deposits, and mergers.'
    },
    {
      'name': 'Transportation Law',
      'description': 'Deals with the regulation of public and private transportation, including vehicle licensing and road safety.'
    },
    {
      'name': 'Construction Law',
      'description': 'Regulates construction activities and the relationships between contractors, subcontractors, and clients.'
    },
    {
      'name': 'Space Law',
      'description': 'Regulates activities in outer space, covering issues like satellite operations, space exploration, and planetary defense.'
    },
    {
      'name': 'Agricultural Law',
      'description': 'Deals with legal issues in agriculture, including land use, food safety, and farm subsidies.'
    },
    // Add additional laws up to 100 as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Types of Laws'),
      ),
      body: ListView.builder(
        itemCount: lawTypes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(lawTypes[index]['name']!),
              subtitle: Text(lawTypes[index]['description']!),
              onTap: () {
                // Navigate to a detailed page for this law type
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LawDetailPage(lawType: lawTypes[index]),
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

class LawDetailPage extends StatelessWidget {
  final Map<String, String> lawType;

  LawDetailPage({required this.lawType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lawType['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lawType['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              lawType['description']!,
              style: TextStyle(fontSize: 16),
            ),
            // Add more detailed information about this law type here
          ],
        ),
      ),
    );
  }
}
