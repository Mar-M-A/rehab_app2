import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final PageController _controller = PageController();
  final List<String> exercises = ['Squats', 'Push-ups', 'Pull-ups'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout')),
      body: PageView.builder(
        controller: _controller,
        itemCount: exercises.length,
        itemBuilder: (ctx, i) {
          return Center(
            child: Card(
              margin: EdgeInsets.all(24),
              child: ListTile(
                title: Text(exercises[i]),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/exercise',
                  arguments: {
                    'exerciseName': exercises[i],
                    'sets': 3,
                    'reps': 12
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
