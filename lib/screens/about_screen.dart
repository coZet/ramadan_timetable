import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ramadan Timetable',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Offline Ramadan timetable & prayer alarm app.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.coffee),
              label: const Text('Buy Me a Coffee'),
              onPressed: () {
                launchUrl(
                  Uri.parse('https://www.buymeacoffee.com/YOURNAME'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
