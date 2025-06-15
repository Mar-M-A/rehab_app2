import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome to RApp!',
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
        ),
      ),
    );
  }
}
