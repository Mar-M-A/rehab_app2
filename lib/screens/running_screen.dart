// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/services/api_service.dart';

class RunningScreen extends StatefulWidget {
  final int setId;
  final int exerciseId;

  const RunningScreen({
    super.key,
    required this.setId,
    required this.exerciseId
  });

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {

  @override
  void initState() {
    super.initState();
    _initializeExercise();
  }

  void _initializeExercise() async {
    try {
      await ApiService.setExercise(1, widget.setId, widget.exerciseId);
    } catch (e) {
      print('Failed to init exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Exercise in progress...',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  //Send stop signal (for sensors)
                  await ApiService.setExercise(1, widget.setId, -1);
                  await ApiService.setMetrics(widget.setId);
                  if (context.mounted){
                    Navigator.popUntil(context, ModalRoute.withName('/workout'));
                  }
                }, 
                child: Text('Finish exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
