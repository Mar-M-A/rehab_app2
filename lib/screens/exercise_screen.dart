import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  final String exerciseName;
  final int sets;
  final int reps;

  const ExerciseScreen({
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goal', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('$sets sets × $reps reps'),
            SizedBox(height: 24),
            // TODO: Integrate pulse oximeter data stream here
            // TODO: Integrate Kinnect posture data stream here
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Mark as complete and return to workout or home
                Navigator.pushNamed(context, '/workout');
              },
              child: Text('Mark Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
