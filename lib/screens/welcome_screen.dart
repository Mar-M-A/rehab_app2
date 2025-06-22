// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/services/api_service.dart';

class WelcomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(text: "192.168.1.43");

  WelcomeScreen({super.key});

  void _onInputChanged(String value) {
    ApiService.setUrl(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Spacer(), // pushes content to the top
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome to Rehab App!',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 16),
                Text('Start your rehabilitation program.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Text('Get Started'),
                ),
              ],
            ),
            Spacer(), // pushes input to the bottom
            TextField(
              controller: _controller,
              onChanged: _onInputChanged,
              decoration: InputDecoration(
                hintText: 'Enter IP',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}