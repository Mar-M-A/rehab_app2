import 'package:flutter/material.dart';
import 'package:rehab_app2/models/exercise_model.dart';
import 'package:rehab_app2/screens/form.page.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final PageController _controller = PageController();
  List<Exercise> exercises = [];

  int? _currentSessionId;
  int? _currentExerciseId;
  int? _currentSessionExerciseId;

  double? meanHr;
  double? meanBr;

  @override
  void initState() {
    super.initState();
    //TODO: obtain the current sessionid from a global state or pass it from homescreen
    _currentSessionId = 1; //for testing purposes
    _loadExercises();
  }

  void _loadExercises() async {
    try {
      final fetched = await ApiService.fetchExercises();
      setState(() {
        exercises = fetched;
      });
    } catch (e) {
      print('Failed to load exercises: $e');
    }
  }

  Future<void> _startAndNavigateToExercise(
    String exerciseName,
    int exerciseId,
    int sets,
    int reps,
  ) async {
    if (_currentSessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No active session. Please start a session first'),
        ),
      );
      return;
    }
    final int? newSessionExerciseId = await ApiService.startExerciseSession(
      _currentSessionId!,
      exerciseId,
    );

    if (newSessionExerciseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start exercise session on backend.')),
      );
      return;
    }

    setState(() {
      _currentSessionExerciseId = newSessionExerciseId;
      _currentExerciseId = exerciseId;
    });

    final result = await Navigator.pushNamed(
      context,
      '/exercise',
      arguments: {
        'exerciseName': exerciseName,
        'sets': sets,
        'reps': reps,
        'sessionExerciseId': newSessionExerciseId,
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        meanHr = result['meanHr'];
        meanBr = result['meanBr'];
      });
    }
  }

  Future<void> _submitMetricsAndFinish() async {
    if (_currentSessionExerciseId == null || meanHr == null || meanBr == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Metrics not available yet.')));
      return;
    }

    bool success = await ApiService.setMetrics(
      _currentExerciseId!,
      meanHr!,
      meanBr!,
    );

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit metrics')));
    } else {
      await showMetrics(_currentSessionExerciseId!);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  Future<void> showMetrics(int sessionExerciseId) async {
    final metrics = await ApiService.fetchSessionExercisesummary(
      sessionExerciseId,
    );
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Session Metrics'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  metrics
                      .map((m) => Text('${m.metricName}: ${m.value}'))
                      .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK.'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout')),
      body: Column(
        children: [
          ...exercises.map((exercise) {
            return Center(
              child: Card(
                margin: EdgeInsets.all(24),
                child: ListTile(
                  title: Text(exercise.description),
                  trailing: Icon(Icons.arrow_forward),
                  onTap:
                      () => _startAndNavigateToExercise(
                        exercise.description,
                        exercise.id,
                        3, //example sets
                        12, //example reps
                      ),
                ),
              ),
            );
          }),
          //   Expanded(
          //     child: PageView.builder(
          //       controller: _controller,
          //       itemCount: exercises.length,
          //       itemBuilder: (ctx, i) {
          //         final exercise = exercises[i];
          //         return Center(
          //           child: Card(
          //             margin: EdgeInsets.all(24),
          //             child: ListTile(
          //               title: Text(exercise['name']!),
          //               trailing: Icon(Icons.arrow_forward),
          //               onTap:
          //                   () => _startAndNavigateToExercise(
          //                     exercise['name']!,
          //                     exercise['id']!,
          //                     3, //example sets
          //                     12, //example reps
          //                   ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          GestureDetector(
            onTap: () {
                print('Tapped!');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Anar al form",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _submitMetricsAndFinish,
              child: Text('Finish Session'),
            ),
          ),
        ],
      ),
    );
  }
}
